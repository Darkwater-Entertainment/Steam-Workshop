--[[
 - init.lua is the server file for the Pot entity.
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
	local ent = ents.Create("jc_pot");

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
	self:SetNWInt("spoiledMeat", 0);	
	self:SetNWInt("proteinExtract", 0);
	self:SetNWInt("time", JC_POT_START_TIME);
	self:SetNWInt("maxTime", JC_POT_START_TIME);
	self:SetNWInt("status", 0);

	-- Adjust the spawn position
	self:SetPos(self:GetPos() + Vector(0, 0, 8));

end;

--[[PhysicsCollide: Called when the entity collides with anything.
		data: Information regarding the collision
		collider: The physics object that collided
]]
function ENT:PhysicsCollide(data, phys)

	-- Local fields
	local curTime = CurTime();

	-- If time passed since the collision and it collided with Spoiled Meat with less than ten Spoiled Meat and it's not a completed status
	if ((data.DeltaTime > 0) and (data.HitEntity:GetClass() == "jc_spoiledmeat") and (self:GetNWInt("spoiledMeat")<10) and (self:GetNWInt("status") != 1)) then
		
		-- If there's still Spoiled Meat
		if (data.HitEntity:GetNWInt("amount") > 0) then

			-- Subtract one Spoiled Meat
			data.HitEntity:SetNWInt("amount", math.Clamp(data.HitEntity:GetNWInt("amount") - 1, 0, 100));
			
			-- If you want the items to disappear when none of the ingredient remains
			if JC_POT_DESTROY_EMPTY then

				-- If there is nothing left
				if (data.HitEntity:GetNWInt("amount") == 0) then

					-- Destruct the ingredient
					data.HitEntity:Destruct();

				end;

			end;

			-- Update the network values
			self:SetNWInt("time", self:GetNWInt("time") + JC_POT_ON_ADD_SPOILED_MEAT);
			self:SetNWInt("maxTime", self:GetNWInt("maxTime") + JC_POT_ON_ADD_SPOILED_MEAT);
			self:SetNWInt("spoiledMeat", self:GetNWInt("spoiledMeat") + 1);
			self:EmitSound("ambient/levels/canals/toxic_slime_sizzle3.wav");

			-- Display the visual effect
			self:VisualEffect();

		end;

	end;

	-- If time passed since the collision and it collided with Protein Extract with less than ten Protein Extract and it's not a completed status
	if ((data.DeltaTime > 0) and (data.HitEntity:GetClass() == "jc_proteinextract") and (self:GetNWInt("proteinExtract")<10) and (self:GetNWInt("status") != 1)) then
		
		-- If there's still Protein Extract
		if (data.HitEntity:GetNWInt("amount") > 0) then

			-- Subtract one Protein Extract
			data.HitEntity:SetNWInt("amount", math.Clamp(data.HitEntity:GetNWInt("amount") - 1, 0, 100));
			
			-- If you want the items to disappear when none of the ingredient remains
			if JC_POT_DESTROY_EMPTY then

				-- If there is nothing left
				if (data.HitEntity:GetNWInt("amount") == 0) then

					-- Destruct the ingredient
					data.HitEntity:Destruct();

				end;

			end;
			
			-- Update the network values
			self:SetNWInt("time", self:GetNWInt("time") + JC_PROTEIN_EXTRACT_AMOUNT);
			self:SetNWInt("maxTime", self:GetNWInt("maxTime") + JC_PROTEIN_EXTRACT_AMOUNT);
			self:SetNWInt("proteinExtract", self:GetNWInt("proteinExtract") + 1);

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
function ENT:Use(act)

	-- Local fields
	local curTime = CurTime();

	-- If the use is within the buffer or has never been used
	if (!self.nextUse or curTime >= self.nextUse) then
		
		-- If it's finished and there are ingredients in it
		if ((self:GetNWInt("status")==1) and ((self:GetNWInt("spoiledMeat")>0) and (self:GetNWInt("proteinExtract")>0))) then			
			
			-- Local fields (set how much amphetamine to drop)
			local amphetamineAmount = (self:GetNWInt("spoiledMeat")+self:GetNWInt("proteinExtract"));
		
			-- Play the sound
			self:EmitSound("ambient/levels/canals/toxic_slime_sizzle2.wav");

			-- Reset the network variables
			self:SetNWInt("spoiledMeat", 0);			
			self:SetNWInt("proteinExtract", 0);
			self:SetNWInt("time", JC_POT_START_TIME);
			self:SetNWInt("maxTime", JC_POT_START_TIME);
			self:SetNWInt("status", 0);			
			
			-- Create the Amphetamine entity, spawn it, and set it's values
			amphetamine = ents.Create("jc_amphetamine");
			amphetamine:SetPos(self:GetPos()+self:GetUp() * 12);
			amphetamine:SetAngles(self:GetAngles());
			amphetamine:Spawn();
			amphetamine:GetPhysicsObject():SetVelocity(self:GetUp() * 2);
			amphetamine:SetNWInt("amount", amphetamineAmount);
			amphetamine:SetNWInt("maxAmount", amphetamineAmount);

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