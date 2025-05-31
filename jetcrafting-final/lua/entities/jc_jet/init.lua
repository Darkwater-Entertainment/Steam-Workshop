--[[
 - init.lua is the server file for the Jet entity.
 - 
 - @author Kyle James
 - @version 16 September 2023
]]


-- Inclusions
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

-- Functions
--[[SpawnFunction: Defines how the entity spawns from the spawnmenu.
		ply: The player
		trace: A table for the player's eye trace
]]
function ENT:SpawnFunction(ply, trace)

	-- Local fields
	local ent = ents.Create("jc_jet");

	-- Sets up the entity position, spawns it, and activates it
	ent:SetPos(trace.HitPos + trace.HitNormal * 16);
	ent:Spawn();
	ent:Activate();
    
	-- Returns the entity
	return ent;

end;

--[[Initialize: Initializes the entity.]]
function ENT:Initialize()

	-- Initialize the model
	self:SetModel("models/mosi/fnv/props/health/chems/jet.mdl");

	-- Initialize the physics
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	
	-- Initialize the network values
	self:SetNWInt("distance", JC_UI_RANGE);
	self:SetNWInt("amount", 0);
	self:SetNWInt("maxAmount", 0);
	self:SetNWInt("value", 0);
	self:SetNWInt("valueMod", JC_JET_VALUE_MODIFIER);
	self:SetNWBool("salesman", JC_USE_ADDICT);

end;

--[[Use: What happens when the player uses the entity.
        act: The entity that caused this input. This will usually be the player who pressed their use key
]]
function ENT:Use(act)

	-- Local fields
	local curTime = CurTime();

	-- If the use is within the buffer or has never been used
	if (!self.nextUse or curTime >= self.nextUse) then

		-- If the server isn't using the Jet Addict
		if !JC_USE_ADDICT then

			-- Give the player caps
			act:addMoney((self:GetNWInt("amount") * JC_JET_VALUE_MODIFIER));

			-- Destroy the Jet
			self:Destruct();

			-- Set the next use buffer to prevent spam
			self.nextUse = curTime + 0.5;

		-- If the server is using the Jet Addict
		else

			-- Set how much Jet the player has
			act:SetNWInt("player_jet", act:GetNWInt("player_jet") + (self:GetNWInt("amount") * JC_JET_VALUE_MODIFIER));
			
			-- Inform the player how much Jet they have
			act:SendLua("local tab = {Color(255,255,255), [[You picked up ]], JC_TEXT_COLOR, [["..math.Round(self:GetNWInt("amount")).."]], Color(255, 255, 255), [[ units of Jet.]] } chat.AddText(unpack(tab))");
			
			-- Destroy the Jet
			self:Destruct();

			-- Set the next use buffer to prevent spam
			self.nextUse = curTime + 0.5;

		end;

	end;

end;

--[[OnTakeDamage: What happens when the entity takes damage.
        dmginfo: The damage to be applied to the entity
]]
function ENT:OnTakeDamage(dmginfo)

	self:Destruct();

end;

--[[Destruct: Destroy the entity.]]
function ENT:Destruct()

	-- Local fields
	local effectData = EffectData();

	-- Set the start, origin, and scale of the effect
	effectData:SetStart(self:GetPos());
	effectData:SetOrigin(self:GetPos());
	effectData:SetScale(8);

	-- Start the glass impact effect
	util.Effect("GlassImpact", effectData, true, true);

	-- Remove the entity
	self:Remove();

end;