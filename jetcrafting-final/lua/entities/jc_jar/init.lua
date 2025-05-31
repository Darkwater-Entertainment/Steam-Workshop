--[[
 - init.lua is the server file for the Jar entity.
 - 
 - @author Kyle James
 - @version 15 September 2023
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
	local ent = ents.Create("jc_jar");

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
	self:SetModel("models/props_lab/jar01a.mdl");

	-- Initialize the physics
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);

	-- Initialize the network values
	self:SetNWInt("distance", JC_UI_RANGE);
	self:SetNWInt("spoiledMeat", 0);	
	self:SetNWInt("spoiledFruit", 0);
	self:SetNWInt("spoiledVegetables", 0);
	self:SetNWInt("progress", JC_JAR_START_PROGRESS);
	self:SetNWString("status", "inprogress");
	self:SetNWInt("status", 0);

	-- Adjust the position's height for spawn
	self:SetPos(self:GetPos() + Vector(0, 0, 8));	

end;

--[[Think: What the entity does each tick.]]
function ENT:Think()

	-- Local fields
	local progressTime = CurTime();

	-- If there is no progress time or the progress is behind the current time and it has each of the ingredients
	if ((!self.progressTime or CurTime() >= self.progressTime) and (self:GetNWInt("spoiledMeat") > 0) and (self:GetNWInt("spoiledFruit") > 0) and (self:GetNWInt("spoiledVegetables") > 0)) then
		
		-- If the process isn't finished
		if (self:GetNWInt("progress") != 100) then

			-- If movement is within the shake thresholds
			if ((self:GetVelocity():Length() > JC_JAR_MIN_SHAKE) and (self:GetVelocity():Length() < JC_JAR_MAX_SHAKE)) then
				
				-- Update the progress & play the sound
				self:SetNWInt("progress", math.Clamp(self:GetNWInt("progress") + JC_JAR_CORRECT_SHAKE, 0, 100));
				self:EmitSound("ambient/levels/canals/toxic_slime_sizzle4.wav", 100, 200);
			
			-- If it exceeds the max threshold
			elseif (self:GetVelocity():Length() > JC_JAR_MAX_SHAKE) then

				-- Update the progress & play the sound
				self:SetNWInt("progress", math.Clamp(self:GetNWInt("progress") - JC_JAR_WRONG_SHAKE, 0, 100));
				self:EmitSound("ambient/levels/canals/toxic_slime_sizzle4.wav", 100, 150);			
			
			end;
		
		-- If the process is finished
		elseif (self:GetNWInt("progress") == 100) then

			-- Set the status
			self:SetNWInt("status", 1);

		end;

		-- Set the progress time to prevent spam (0.5s buffer)
		self.progressTime = CurTime() + 0.5;

	end;

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
			if JC_JAR_DESTROY_EMPTY then

				-- If there is nothing left
				if (data.HitEntity:GetNWInt("amount") == 0) then
					
					-- Destruct the ingredient
					data.HitEntity:Destruct();

				end;

			end;

			-- Update network value
			self:SetNWInt("spoiledMeat", self:GetNWInt("spoiledMeat") + 1);

			-- Play the sound
			self:EmitSound("ambient/levels/canals/toxic_slime_sizzle3.wav");
			
			-- Display the visual effect
			self:VisualEffect();

		end;

	end;

	-- If time passed since the collision and it collided with Spoiled Fruit with less than ten Spoiled Fruit and it's not a completed status
	if ((data.DeltaTime > 0) and (data.HitEntity:GetClass() == "jc_spoiledfruit") and (self:GetNWInt("spoiledFruit")<10) and (self:GetNWInt("status") != 1)) then
		
		-- If there's still Spoiled Fruit
		if (data.HitEntity:GetNWInt("amount") > 0) then

			-- Subtract one Spoiled Fruit
			data.HitEntity:SetNWInt("amount", math.Clamp(data.HitEntity:GetNWInt("amount") - 1, 0, 100));
			
			-- If you want the items to disappear when none of the ingredient remains
			if JC_JAR_DESTROY_EMPTY then

				-- If there is nothing left
				if (data.HitEntity:GetNWInt("amount") == 0) then

					-- Destruct the ingredient
					data.HitEntity:Destruct();

				end;

			end;

			-- Update network value
			self:SetNWInt("spoiledFruit", self:GetNWInt("spoiledFruit") + 1);

			-- Play the sound
			self:EmitSound("ambient/levels/canals/toxic_slime_sizzle3.wav");
			
			-- Display the visual effect
			self:VisualEffect();

		end;

	end;

	-- If time passed since the collision and it collided with Spoiled Vegetables with less than ten Spoiled Vegetables and it's not a completed status
	if ((data.DeltaTime > 0) and (data.HitEntity:GetClass() == "jc_spoiledveggies") and (self:GetNWInt("spoiledVegetables")<10) and (self:GetNWInt("status") != 1)) then
		
		-- If there's still Spoiled Vegetables
		if (data.HitEntity:GetNWInt("amount") > 0) then

			-- Subtract one Spoiled Vegetables
			data.HitEntity:SetNWInt("amount", math.Clamp(data.HitEntity:GetNWInt("amount") - 1, 0, 100));
			
			-- If you want the items to disappear when none of the ingredient remains
			if JC_JAR_DESTROY_EMPTY then

				-- If there is nothing left
				if (data.HitEntity:GetNWInt("amount")==0) then

					-- Destruct the ingredient
					data.HitEntity:Destruct();
				end;

			end;

			-- Update the network value
			self:SetNWInt("spoiledVegetables", self:GetNWInt("spoiledVegetables") + 1);

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
		if ((self:GetNWInt("status") == 1) and ((self:GetNWInt("spoiledMeat") > 0) and (self:GetNWInt("spoiledFruit") > 0) and (self:GetNWInt("spoiledVegetables") > 0))) then			
			
			-- Local fields (set how much fertilizer to drop)
			local fertilizerAmount = math.Round((self:GetNWInt("spoiledMeat") + self:GetNWInt("spoiledFruit") + self:GetNWInt("spoiledVegetables")) / 2);
		
			-- Play the sound
			self:EmitSound("ambient/levels/canals/toxic_slime_sizzle2.wav");
			
			-- Reset the network variables
			self:SetNWInt("spoiledMeat", 0);			
			self:SetNWInt("spoiledFruit", 0);
			self:SetNWInt("spoiledVegetables", 0);
			self:SetNWInt("progress", JC_JAR_START_PROGRESS);
			self:SetNWInt("status", 0);			
			
			-- Create the Fertilizer entity, spawn it, and set it's values
			fertilizer = ents.Create("jc_fertilizer");
			fertilizer:SetPos(self:GetPos() + self:GetUp() * 12);
			fertilizer:SetAngles(self:GetAngles());
			fertilizer:Spawn();
			fertilizer:GetPhysicsObject():SetVelocity(self:GetUp() * 2);
			fertilizer:SetNWInt("amount", fertilizerAmount);
			fertilizer:SetNWInt("maxAmount", fertilizerAmount);			
		
		end;

		-- Set the next use to prevent spam (0.5s buffer)
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