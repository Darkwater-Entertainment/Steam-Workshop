--[[ 
  sv_consumables.lua
  Server-side logic for the Fallout Consumables addon.
  Handles effect application, duration tracking, and cleanup.

  @author Kyle James
  @version 31 May 2025
]]

-- Networking
util.AddNetworkString("UpdateEffects")
util.AddNetworkString("SendEffects")

-- Local reference to the Player metatable
local plymeta = FindMetaTable("Player")

--[[ 
  plymeta:AddConsumableEffect(effect, duration)
  Applies a consumable effect to the player.
  - effect: string identifier of the effect
  - duration: duration in seconds
]]
function plymeta:AddConsumableEffect(effect, duration)
	if not self:IsValid() or not self:Alive() then return end
	if not FC_Effects[effect] then
		ErrorNoHalt("[Fallout Consumables] Error: invalid effect '" .. effect .. "' for player " .. self:Nick() .. "\n")
		return
	end

	-- Set or extend effect duration
	local now = CurTime()
	local maxDuration = FC_Effects[effect].MaxDuration
	if self.Effects[effect] then
		self.Effects[effect] = math.Clamp(self.Effects[effect] + duration, now, now + maxDuration)
	else
		self.Effects[effect] = math.Clamp(now + duration, now, now + maxDuration)

		-- Call optional one-time initialization
		if FC_Effects[effect].InitializeOnce then
			local success, err = pcall(FC_Effects[effect].InitializeOnce, self)
			if not success then
				ErrorNoHalt("[Fallout Consumables] InitializeOnce error for effect '" .. effect .. "' on player " .. self:Nick() .. ": " .. err .. "\n")
			end
		end
	end

	-- Call per-application initialization
	if FC_Effects[effect].Initailize then
		local success, err = pcall(FC_Effects[effect].Initialize, self)
		if not success then
			ErrorNoHalt("[Fallout Consumables] Initialize error for effect '" .. effect .. "' on player " .. self:Nick() .. ": " .. err .. "\n")
		end
	end

	-- Notify client
	net.Start("UpdateEffects")
	net.WriteTable(self.Effects)
	net.Send(self)
end

--[[ 
  plymeta:RemoveConsumableEffect(effect)
  Removes a specific effect from the player.
]]
function plymeta:RemoveConsumableEffect(effect)
	if not self:IsValid() or not self:Alive() then return end
	if not FC_Effects[effect] then
		ErrorNoHalt("[Fallout Consumables] Error: tried to remove invalid effect '" .. effect .. "' from " .. self:Nick() .. "\n")
		return
	end

	self.Effects[effect] = nil

	net.Start("UpdateEffects")
	net.WriteTable(self.Effects)
	net.Send(self)
end

--[[ 
  plymeta:ClearConsumableEffects()
  Removes all effects from the player.
]]
function plymeta:ClearConsumableEffects()
	self.Effects = {}

	net.Start("UpdateEffects")
	net.WriteTable(self.Effects)
	net.Send(self)
end

--[[ 
  plymeta:HasConsumableEffect(effect)
  Returns true if the player has the effect.
]]
function plymeta:HasConsumableEffect(effect)
	return self.Effects[effect] ~= nil
end

--[[ 
  plymeta:CountConsumableEffects()
  Returns the number of active effects.
]]
function plymeta:CountConsumableEffects()
	return table.Count(self.Effects)
end

--[[ 
  consumableEffectLogic()
  Ticks all player effects every second. 
  Removes expired effects and calls effect logic.
]]
local function consumableEffectLogic()
	for _, ply in pairs(player.GetAll()) do
		if not ply.Effects then
			ply.Effects = {}
			continue
		end

		for effectID, expireTime in pairs(ply.Effects) do
			local effectData = FC_Effects[effectID]

			-- Run optional per-tick effect logic
			if isfunction(effectData.Iterate) then
				local success, err = pcall(effectData.Iterate, ply, expireTime - CurTime())
				if not success then
					print("[Fallout Consumables] Iterate error in effect '" .. effectID .. "' for " .. ply:Nick() .. ": " .. err)
				end
			end

			-- Expired effect cleanup
			if expireTime <= CurTime() then
				ply.Effects[effectID] = nil

				if isfunction(effectData.Terminate) then
					local success, err = pcall(effectData.Terminate, ply)
					if not success then
						print("[Fallout Consumables] Terminate error in effect '" .. effectID .. "' for " .. ply:Nick() .. ": " .. err)
					end
				end
			end
		end

		-- Update client
		net.Start("UpdateEffects")
		net.WriteTable(ply.Effects)
		net.Send(ply)
	end
end

--[[ 
  FC_TakeDamage(ent, dmg)
  Applies effect modifiers when damage is taken.
]]
local function FC_TakeDamage(ent, dmg)
	if not IsValid(ent) then return end

	local attacker = dmg:GetAttacker()

	if ent:IsPlayer() then
		if IsValid(attacker) and attacker:IsPlayer() and attacker:Alive() then
			if attacker:HasConsumableEffect("psycho") then
				dmg:ScaleDamage(1.25)
			end
		end

		if IsValid(attacker) and (attacker:IsPlayer() or attacker:IsNPC()) then
			if ent:HasConsumableEffect("medX") then
				dmg:ScaleDamage(0.75)
			end
		end
	end

	if ent:IsNPC() and IsValid(attacker) and attacker:IsPlayer() and attacker:Alive() then
		if attacker:HasConsumableEffect("psycho") then
			dmg:ScaleDamage(1.25)
		end
	end
end

-- Hooks
hook.Add("PlayerDeath", "ClearConsumableEffectsOnDeath", function(ply) ply:ClearConsumableEffects() end)
hook.Add("PlayerSpawn", "ClearConsumableEffectsOnSpawn", function(ply) ply:ClearConsumableEffects() end)
hook.Add("PlayerInitialSpawn", "ClearConsumableEffectsOnInitialSpawn", function(ply) ply:ClearConsumableEffects() end)
hook.Add("OnPlayerChangedTeam", "FC_ClearEffectsOnJobChange", function(ply) ply:ClearConsumableEffects() end)
hook.Add("EntityTakeDamage", "FC_TakeDamage", FC_TakeDamage)

-- Timer
timer.Create("fc_effectlogic", 1, 0, consumableEffectLogic)