--[[ 
  sv_fc_nutritionSystem.lua
  Server-side logic for the Fallout Nutrition System addon.
  Handles hunger and thirst depletion, player death on starvation,
  and debug/admin controls.

  @author Kyle James
  @version 31 May 2025
]]

--[[ 
  checkValues(ply, hunger, thirst)
  Kills the player if hunger or thirst reach zero.
]]
local function checkValues(ply, hunger, thirst)
	if not FC_NS_KILL_ON_MALNOURISHED or not FC_NS_ENABLED then return end
	if hunger <= 0 and ply:Alive() then ply:Kill() end
	if thirst <= 0 and ply:Alive() then ply:Kill() end
end

--[[ 
  FC_NS_SetValue(ply, args, isHunger)
  Admin command to set hunger or thirst for a target player.
]]
local function FC_NS_SetValue(ply, args, isHunger)
	if not IsValid(ply) or not ply:IsSuperAdmin() then return end

	local steamID = args[1]
	if not steamID then
		ply:PrintMessage(HUD_PRINTTALK, "[Nutrition] Please specify a target SteamID64.")
		return
	end

	local target = player.GetBySteamID64(steamID)
	if not IsValid(target) then
		ply:PrintMessage(HUD_PRINTTALK, "[Nutrition] Target not found.")
		return
	end

	local amount = tonumber(args[2])
	if not amount then
		ply:PrintMessage(HUD_PRINTTALK, "[Nutrition] Please specify a numeric amount.")
		return
	end

	if isHunger then
		target:SetNW2Float("hunger", amount)
	else
		target:SetNW2Float("thirst", amount)
	end
end

--[[ 
  Admin debug command to display a player's hunger/thirst.
]]
concommand.Add("fc_ns_debug", function(ply)
	if IsValid(ply) then
		local hunger = ply:GetNW2Float("hunger")
		local thirst = ply:GetNW2Float("thirst")
		ply:PrintMessage(HUD_PRINTTALK, "[Nutrition] Hunger: " .. hunger .. ", Thirst: " .. thirst)
	end
end)

--[[ 
  Admin command to set hunger for a target player.
]]
concommand.Add("fc_ns_sethunger", function(ply, _, args)
	FC_NS_SetValue(ply, args, true)
end)

--[[ 
  Admin command to set thirst for a target player.
]]
concommand.Add("fc_ns_setthirst", function(ply, _, args)
	FC_NS_SetValue(ply, args, false)
end)

--[[ 
  PlayerSpawn hook to initialize hunger and thirst.
]]
hook.Add("PlayerSpawn", "FC_NS_InitNutrition", function(ply)
	ply:SetNW2Float("hunger", FC_NS_MAX_HUNGER)
	ply:SetNW2Float("thirst", FC_NS_MAX_THIRST)
end)

--[[ 
  Nutrition decay timer
  Runs every FC_NS_ITERATE seconds to reduce hunger/thirst.
]]
timer.Create("FC_NS_NutritionTick", FC_NS_ITERATE, 0, function()
	for _, ply in ipairs(player.GetAll()) do
		local hunger = ply:GetNW2Float("hunger") - FC_NS_HUNGER_RATE
		local thirst = ply:GetNW2Float("thirst") - FC_NS_THIRST_RATE

		ply:SetNW2Float("hunger", hunger)
		ply:SetNW2Float("thirst", thirst)

		checkValues(ply, hunger, thirst)
	end
end)