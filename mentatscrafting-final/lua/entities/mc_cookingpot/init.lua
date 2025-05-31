--[[
 - init.lua is the server file for the Cooking Pot entity.
 - 
 - @author Kyle James
 - @version 23 August 2023
]]

-- Inclusions
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

-- Functions
--[[Initialize: Initializes the entity.]]
function ENT:Initialize()

	-- Local fields
	local phys = self:GetPhysicsObject();

	-- Initialize the model
	self:SetModel("models/props_c17/metalpot001a.mdl");

	-- Initialize the physics
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	
	-- If the physics are functiong
	if phys:IsValid() then

		-- Wake the object
		phys:Wake();

	end;

	-- Make the entity a trigger
	self:SetTrigger(true);

end;

--[[StartTouch: Called when another entity touches this entity.
		ent: The entity touching this entity.
]]
function ENT:StartTouch(ent)

	-- If the entity touching the Cooking Pot is Abraxo & the Pot isn't full
	if ent:GetClass() == "mc_abraxo" and !self:GetFull() then

		-- Set the Pot to full
		self:SetFull(true);

		-- Remove the Abraxo
		ent:Remove();

		-- Emit sound for haptic feedback
		self:EmitSound("ambient/levels/canals/toxic_slime_sizzle3.wav");

	end;

end;