--[[
 - init.lua is the server file for the Mentats entity.
 - 
 - @author Kyle James
 - @version 23 August 2023
]]

-- Inclusions
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

-- Adds the specified string to a string table, which will cache it and network it to all clients automatically when picking up Mentats.
util.AddNetworkString("mentatsnotify");

-- Functions
--[[Initialize: Initializes the entity.]]
function ENT:Initialize()

	-- Local fields
	local phys = self:GetPhysicsObject();

	-- Initialize the model
	self:SetModel("models/mosi/fnv/props/health/chems/mentats.mdl");

	-- Initialize the physics
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	
	-- If the physics are functioning
	if phys:IsValid() then

		-- Wake the object
		phys:Wake();

	end;

	-- Set the use type to only allow one use
	self:SetUseType(SIMPLE_USE);

end;

--[[Use: What happens when the player uses the entity.
        act: The entity that caused this input. This will usually be the player who pressed their use key
]]
function ENT:Use(act)

	-- If the player has no Mentats, ensure it's set numerically
	if act.HoldingMentats == nil then

		act.HoldingMentats = 0;

	end;

	-- Add the Mentats to their "inventory"
	act.HoldingMentats = act.HoldingMentats + 1;

	-- Notify the player of their "inventory"
	net.Start("mentatsnotify");

		net.WriteInt(act.HoldingMentats, 32);

	net.Send(act);

	-- Remove the Mentats
	self:Remove()

end;