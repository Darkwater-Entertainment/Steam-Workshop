--[[
 - init.lua is the server file for the Brain Fungus entity.
 - 
 - @author Kyle James
 - @version 23 August 2023
]]

-- Inclusions
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

-- Functions
function ENT:Initialize()

	-- Local fields
	local phys = self:GetPhysicsObject();

	-- Initialize the model
	self:SetModel("models/mosi/fnv/props/food/crops/brainfungus.mdl");

	-- Initialize the physics
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	
	-- If the physics are functioning
	if phys:IsValid() then

		-- Wake the object
		phys:Wake();

	end;

	-- Adjust the spawn location
	local pos = self:GetPos();
	self:SetPos(Vector(pos.x, pos.y, pos.z + 50));

end;