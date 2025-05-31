--[[
 - init.lua is the server file for the Spoiled Meat entity.
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
	local ent = ents.Create("jc_spoiledmeat");

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
	self:SetModel("models/mosi/fnv/props/food/steamedradroach.mdl");

	-- Initialize the physics
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	
	-- Initialize network values
	self:SetNWInt("distance", JC_UI_RANGE);
	self:SetNWInt("amount", JC_SPOILED_MEAT_AMOUNT);
	self:SetNWInt("maxAmount", JC_SPOILED_MEAT_AMOUNT);

	-- Adjust the spawn position
	self:SetPos(self:GetPos()+Vector(0, 0, 8));

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