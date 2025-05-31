--[[
 - init.lua is the server file for the Special Pot entity.
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
	local ent = ents.Create("jc_spot");

	-- Sets up the entity position, spawns it, and activates it
	ent:SetPos(trace.HitPos + trace.HitNormal * 8);
	ent:Spawn();
	ent:Activate();
     
	-- Returns the entity
	return ent;

end;

--[[Initialize: Initializes the entity.]]
function ENT:Initialize()

	-- Initialize the model
	self:SetModel("models/props_c17/metalPot001a.mdl");

	-- Initialize the physics
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);

	-- Initialize the network values
	self:SetNWInt("distance", JC_UI_RANGE);
	self:SetNWInt("amphetamine", 0);	
	self:SetNWInt("fertilizer", 0);
	self:SetNWInt("time", JC_SPECIAL_POT_START_TIME);
	self:SetNWInt("maxTime", JC_SPECIAL_POT_START_TIME);
	self:SetNWInt("status", 0);

	-- Adjust the positions' height for spawn
	self:SetPos(self:GetPos() + Vector(0, 0, 8));

end;

--[[PhysicsCollide: Called when the entity collides with anything.
		data: Information regarding the collision
		collider: The physics object that collided
]]
function ENT:PhysicsCollide(data, phys)
	
	-- Local fields
	local curTime = CurTime();
	
	-- If time passed since the collision and it collided with Amphetamine with less than ten Amphetamine and it's not a completed status
	if ((data.DeltaTime > 0) and (data.HitEntity:GetClass() == "jc_amphetamine") and (self:GetNWInt("amphetamine")<10) and (self:GetNWInt("status") != 1)) then	
		
		-- If there's still Amphetamine
		if (data.HitEntity:GetNWInt("amount") > 0) then

			-- Subtract one Amphetamine
			data.HitEntity:SetNWInt("amount", math.Clamp(data.HitEntity:GetNWInt("amount") - 1, 0, 100));
			
			-- If you want the items to disappear when none of the ingredient remains
			if (data.HitEntity:GetNWInt("amount") == 0) then

				data.HitEntity:Destruct();

			end;
			
			-- Update the network values
			self:SetNWInt("time", self:GetNWInt("time") + JC_SPECIAL_POT_ON_ADD_AMPHETAMINE);
			self:SetNWInt("maxTime", self:GetNWInt("maxTime") + JC_SPECIAL_POT_ON_ADD_AMPHETAMINE);
			self:SetNWInt("amphetamine", self:GetNWInt("amphetamine") + 1);
			self:EmitSound("ambient/levels/canals/toxic_slime_sizzle3.wav");
			
			-- Display the visual effect
			self:VisualEffect();

		end;

	end;

	-- If time passed since the collision and it collided with Fertilizer with less than ten Fertilizer and it's not a completed status
	if ((data.DeltaTime > 0) and (data.HitEntity:GetClass() == "jc_fertilizer") and (self:GetNWInt("fertilizer")<10) and (self:GetNWInt("status") != 1)) then
		
		-- If there's still Fertilizer
		if (data.HitEntity:GetNWInt("amount") > 0) then

			-- Subtract one Fertilizer
			data.HitEntity:SetNWInt("amount", math.Clamp(data.HitEntity:GetNWInt("amount") - 1, 0, 100));
			
			-- If there is nothing left
			if (data.HitEntity:GetNWInt("amount")==0) then

				-- Destruct the ingredient
				data.HitEntity:Destruct();

			end;

			-- Update the network values
			self:SetNWInt("time", self:GetNWInt("time") + JC_SPECIAL_POT_ON_ADD_FERTILIZER);
			self:SetNWInt("maxTime", self:GetNWInt("maxTime") + JC_SPECIAL_POT_ON_ADD_FERTILIZER);
			self:SetNWInt("fertilizer", self:GetNWInt("fertilizer") + 1);

			-- Play the sound
			self:EmitSound("ambient/levels/canals/toxic_slime_sizzle3.wav");
			
			-- Display the visual effect
			self:VisualEffect();

		end;

	end;

end;


--[[Use: What happens when the player uses the entity.
        act: The entity that caused this input. This will usually be the player who pressed their use key
]]
function ENT:Use(activator, caller)

	-- Local fields
	local curTime = CurTime();

	-- If the use is within the buffer or has never been used
	if (!self.nextUse or curTime >= self.nextUse) then
		
		-- If it's finished and there are ingredients in it
		if ((self:GetNWInt("status") == 1) and ((self:GetNWInt("amphetamine") > 0) and (self:GetNWInt("fertilizer") > 0))) then			
			
			-- Local fields (set how much Jet to drop)
			local jetAmount = (self:GetNWInt("amphetamine") + self:GetNWInt("fertilizer"));
		
			-- Play the sound
			self:EmitSound("ambient/levels/canals/toxic_slime_sizzle2.wav");

			-- Reset the network variables
			self:SetNWInt("amphetamine", 0);			
			self:SetNWInt("fertilizer", 0);
			self:SetNWInt("time", JC_SPECIAL_POT_START_TIME);
			self:SetNWInt("maxTime", JC_SPECIAL_POT_START_TIME);
			self:SetNWInt("status", 0);			
			
			-- Create the Jet entity, spawn it, and set it's values
			jet = ents.Create("jc_jet");
			jet:SetPos(self:GetPos()+self:GetUp() * 12);
			jet:SetAngles(self:GetAngles());
			jet:Spawn();
			jet:GetPhysicsObject():SetVelocity(self:GetUp() * 2);
			jet:SetNWInt("amount", jetAmount);
			jet:SetNWInt("maxAmount", jetAmount);
			jet:SetNWInt("value", jetAmount);

		end;
		
		-- Set the next use to prevent spam
		self.nextUse = curTime + 0.5;

	end;
	
end;

--[[OnTakeDamage: What happens when the entity takes damage.
        dmginfo: The damage to be applied to the entity
]]
function ENT:OnTakeDamage(dmginfo)
	
	-- Display the visual effect
	self:VisualEffect();

	-- Destroy the entity
	self:Remove();

end;

--[[VisualEffect: Displays a visual effect.]]
function ENT:VisualEffect()

	-- Local fields
	local effectData = EffectData();	
	
	-- Set the start, origin, and scale of the effect
	effectData:SetStart(self:GetPos());
	effectData:SetOrigin(self:GetPos());
	effectData:SetScale(8);

	-- Start the glass impact effect
	util.Effect("GlassImpact", effectData, true, true);

end;