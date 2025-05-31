--[[
 - init.lua is the server file for the Crate entity.
 - 
 - @author Kyle James
 - @version 23 August 2023
]]

-- Inclusions
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

-- Functions
--[[Initialize: Initializes the entity.]]
function ENT:Initialize()

	-- Local fields
	local phys = self:GetPhysicsObject();

	-- Initialize Full variable
	self:SetFull(false);

	-- Initialize the model
	self:SetModel("models/mosi/fallout4/props/fortifications/woodencrate02.mdl");

	-- Initialize the physics
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	
	-- If the physics are functioning
	if phys:IsValid() then

		-- Wake the object
		phys:Wake();

	end;

	-- Make the entity a trigger
	self:SetTrigger(true);

	-- Adjust the spawn location
	local pos = self:GetPos();
	self:SetPos(Vector(pos.x, pos.y, pos.z + 50));

end;

--[[StartTouch: Called when another entity touches this entity.
		ent: The entity touching this entity.
]]
function ENT:StartTouch(ent)

	-- If the entity touching the Crate is Lead and the Crate isn't full
	if ent:GetClass() == "mc_lead" and !self:GetFull() then

		-- Set the Crate to full
		self:SetFull(true);

		-- Remove the Lead
		ent:Remove();

		-- Emit sound for haptic feedback
		self:EmitSound("ambient/levels/canals/toxic_slime_sizzle3.wav");
	end;

end;