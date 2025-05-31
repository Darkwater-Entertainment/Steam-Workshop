--[[
 - init.lua is the server file for the consumable abstract entity.
 - 
 - @author Kyle James
 - @version 09 March 2025
]]

-- Inclusions
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

--[[Initialize: Initializes the entity.]]
function ENT:Initialize()

	-- Local fields
	local phys = self:GetPhysicsObject(); -- The physics object

	-- Initialize the model
	self:SetModel("models/props_lab/jar01a.mdl");

	-- Initialize the physics
 	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);

	-- If the physics are functioning
	if phys:IsValid() then
		
		-- Wake the object
		phys:Wake();

	end;

end;

--[[Use: What happens when the player uses the entity.
        act: The entity that caused this input. This will usually be the player who pressed their use key
]]
function ENT:Use(act)
	
	-- If the activator (player) isn't overdosing, remove the entity.
	if !act:HasConsumableEffect("overdose") then 

		self:Remove();

	end;

end;