--[[
 - init.lua is the server file for the Boiler entity.
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
	self:SetModel("models/props_interiors/pot01a.mdl");

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

	--[[Add the pipe to the model]]
	-- Local fields
	local child = ents.Create( "prop_dynamic" );
	local cpos = self:GetPos();
	local cang = self:GetAngles();

	-- Initialize the pipe model
	child:SetModel( "models/props_canal/mattpipe.mdl" );

	-- Set the position
	child:SetPos(cpos + (cang:Right() * 7) + (cang:Up() * 17));

	-- Set the angles
	child:SetAngles(Angle(self:GetAngles().p, self:GetAngles().y + 90, self:GetAngles().r));
	
	-- Make the pipe a child of the Boiler
	child:SetParent(self);

	-- Ensure the pipe deletes it self when the Boiler is deleted
	self:DeleteOnRemove(child);

	-- Spawn the pipe
	child:Spawn();

end;

--[[StartTouch: Called when another entity touches this entity.
		ent: The entity touching this entity.
]]
function ENT:StartTouch(ent)
	
	-- If the entity touching the Boiler is Brain Fungus & the Boiler isn't full
	if ent:GetClass() == "mc_brainfungus" and !self:GetFull() then

		-- Set the Boiler to full
		self:SetFull(true);

		-- Remove the Brain Fungus
		ent:Remove();

		-- Emit sound for haptic feedback
		self:EmitSound("ambient/levels/canals/toxic_slime_sizzle3.wav");

	end;
	
end;