--[[
 - init.lua is the server file for the Chemistry Station entity.
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
	local ent = ents.Create("jc_chemstation");

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
	self:SetModel("models/props_c17/furnitureStove001a.mdl");

	--Initialize the physics
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);

	-- Initialize the health
	self:SetHealth(JC_CHEM_STATION_HEALTH);
   
	-- Initialize the network values
	self:SetNWInt("distance", JC_UI_RANGE);
	self:SetNWInt("chemStationConsumption", JC_CHEM_STATION_CONSUMPTION);
	self:SetNWInt("chemStationHeat", JC_CHEM_STATION_HEAT);
	self:SetNWInt("fusionStorage", JC_CHEM_STATION_STORAGE);
	self:SetNWInt("fusionStorageMax", JC_CHEM_STATION_STORAGE);
	self:SetNWBool("firePlace1", false);
	self:SetNWBool("firePlace2", false);
	self:SetNWBool("firePlace3", false);
	self:SetNWBool("firePlace4", false);
	self:SetNWBool("explode", false);
   
	-- Adjust the spawn position
	self:SetPos(self:GetPos() + Vector(0, 0, 32));
   
	-- If it can be Grav-Gunned
	if JC_CHEM_STATION_GRAV_GUN then

		-- Set the mass
		self:GetPhysicsObject():SetMass(105);

	end;   

end;

--[[Think: What the entity does each tick.]]
function ENT:Think()

	-- Local fields
	local traceF1 = {};
	local traceF2 = {};
	local traceF3 = {};
	local traceF4 = {};
	local traceFire1;
	local traceFire2;
	local traceFire3;
	local traceFire4;

	-- Update the traces
	traceF1.start = self:GetPos() + (self:GetUp() * 20) + (self:GetForward() * 2.8) + (self:GetRight() * 11.5);
	traceF1.endpos = self:GetPos() + (self:GetUp() * 24) + (self:GetForward() * 2.8) + (self:GetRight() * 11.5);
	traceF1.filter = self;
	traceF2.start = self:GetPos() + (self:GetUp() * 20) + (self:GetForward() * 2.8) + (self:GetRight() * -11.2);
	traceF2.endpos = self:GetPos() + (self:GetUp() * 24) + (self:GetForward() * 2.8) + (self:GetRight() * -11.2);
	traceF2.filter = self;
	traceF3.start = self:GetPos() + (self:GetUp() * 20) + (self:GetForward() * -9.8) + (self:GetRight() * -11.2);
	traceF3.endpos = self:GetPos() + (self:GetUp() * 24) + (self:GetForward() * -9.8) + (self:GetRight() * -11.2);
	traceF3.filter = self;
	traceF4.start = self:GetPos() + (self:GetUp() * 20) + (self:GetForward() * -9.8) + (self:GetRight() * 11.5);
	traceF4.endpos = self:GetPos() + (self:GetUp() * 24) + (self:GetForward() * -9.8) + (self:GetRight() * 11.5);
	traceF4.filter = self;

	-- Update the trace lines with the updated data
	traceFire1 = util.TraceLine(traceF1);
	traceFire2 = util.TraceLine(traceF2);
	traceFire3 = util.TraceLine(traceF3);
	traceFire4 = util.TraceLine(traceF4);

	-- If there is no progress time or the progress is behind the current time and it has energy
	if ((!self.nextHeat or CurTime() >= self.nextHeat) and (self:GetNWInt("fusionStorage") > 0)) then   
		
		-- If the first trace is valid
		if IsValid(traceFire1.Entity) then
			
			-- If it's colliding with either Pot and that Pot has ingredients in it
			if ((((traceFire1.Entity:GetClass() == "jc_pot") and ((traceFire1.Entity:GetNWInt("proteinExtract") > 0) and (traceFire1.Entity:GetNWInt("spoiledMeat") > 0))))
			or (((traceFire1.Entity:GetClass() == "jc_spot") and ((traceFire1.Entity:GetNWInt("amphetamine") > 0) and (traceFire1.Entity:GetNWInt("fertilizer") > 0))))) then
				
				-- Subtract the consumption rate
				self:SetNWInt("fusionStorage", math.Clamp(self:GetNWInt("fusionStorage") - JC_CHEM_STATION_CONSUMPTION, 0, self:GetNWInt("fusionStorageMax")));
				
				-- Subtract the time
				traceFire1.Entity:SetNWInt("time", math.Clamp(traceFire1.Entity:GetNWInt("time") - 1, 0, traceFire1.Entity:GetNWInt("maxTime")));                
				
				-- If there's no time left
				if (traceFire1.Entity:GetNWInt("time") == 0) then

					-- Set the status to finished
					traceFire1.Entity:SetNWInt("status", 1);

				end;         

				-- Flip a coin
				local soundChance = math.random(1, 2);

				-- If it's 2
				if soundChance == 2 then

					-- Play the sound
					traceFire1.Entity:EmitSound("ambient/levels/canals/toxic_slime_gurgle"..math.random(2, 8)..".wav");
				
				end;

				-- Set the first slot to be marked as used
				self:SetNWBool("firePlace1", true);

			end;

		-- If the first trace is not valid
		else
		
			-- Set the first slot to be marked as unused
			self:SetNWBool("firePlace1", false);
		
		end;

		-- If the second trace is valid
		if IsValid(traceFire2.Entity) then

			-- If it's colliding with either Pot and that Pot has ingredients in it
			if ((((traceFire2.Entity:GetClass() == "jc_pot") and ((traceFire2.Entity:GetNWInt("proteinExtract") > 0) and (traceFire2.Entity:GetNWInt("spoiledMeat") > 0))))
			or (((traceFire2.Entity:GetClass() == "jc_spot") and ((traceFire2.Entity:GetNWInt("amphetamine") > 0) and (traceFire2.Entity:GetNWInt("fertilizer") > 0))))) then
				
				-- Subtract the consumption rate
				self:SetNWInt("fusionStorage", math.Clamp(self:GetNWInt("fusionStorage") - JC_CHEM_STATION_CONSUMPTION, 0, self:GetNWInt("fusionStorageMax")));
				
				-- Subtract the time
				traceFire2.Entity:SetNWInt("time", math.Clamp(traceFire2.Entity:GetNWInt("time")-1, 0, traceFire2.Entity:GetNWInt("maxTime")));                
				
				-- If there's no time left
				if (traceFire2.Entity:GetNWInt("time") == 0) then

					-- Set the status to finished
					traceFire2.Entity:SetNWInt("status", 1);

				end;

				-- Flip a coin
				local soundChance = math.random(1, 2);

				-- If it's 2
				if soundChance == 2 then

					-- Play the sound
					traceFire2.Entity:EmitSound("ambient/levels/canals/toxic_slime_gurgle"..math.random(2, 8)..".wav");
				
				end;
				
				-- Set the second slot to be marked as used
				self:SetNWBool("firePlace2", true);

			end;

		-- If the second trace is not valid
		else

			-- Set the second slot to be marked as unused
			self:SetNWBool("firePlace2", false);

		end;

		-- If the third trace is valid
		if IsValid(traceFire3.Entity) then 

			-- If it's colliding with either Pot and that Pot has ingredients in it
			if ((((traceFire3.Entity:GetClass() == "jc_pot") and ((traceFire3.Entity:GetNWInt("proteinExtract") > 0) and (traceFire3.Entity:GetNWInt("spoiledMeat") > 0))))
			or (((traceFire3.Entity:GetClass() == "jc_spot") and ((traceFire3.Entity:GetNWInt("amphetamine") > 0) and (traceFire3.Entity:GetNWInt("fertilizer") > 0))))) then
				
				-- Subtract the consumption rate
				self:SetNWInt("fusionStorage", math.Clamp(self:GetNWInt("fusionStorage") - JC_CHEM_STATION_CONSUMPTION, 0, self:GetNWInt("fusionStorageMax")));
				
				-- Subtract the time
				traceFire3.Entity:SetNWInt("time", math.Clamp(traceFire3.Entity:GetNWInt("time")-1, 0, traceFire3.Entity:GetNWInt("maxTime")));                
				
				-- If there's no time left
				if (traceFire3.Entity:GetNWInt("time") == 0) then

					-- Set the status to finished
					traceFire3.Entity:SetNWInt("status", 1);

				end;

				-- Flip a coin
				local soundChance = math.random(1, 2);

				-- If it's 2
				if soundChance == 2 then

					-- Play the sound
					traceFire3.Entity:EmitSound("ambient/levels/canals/toxic_slime_gurgle"..math.random(2, 8)..".wav");
				end;

				-- Set the third slot to be marked as used
				self:SetNWBool("firePlace3", true);

			end;

		-- If the third trace is not valid
		else

			-- Set the third slot to be marked as unused
			self:SetNWBool("firePlace3", false);

		end;

		-- If the fourth trace is valid
		if IsValid(traceFire4.Entity) then  
			
			-- If it's colliding with either Pot and that Pot has ingredients in it
			if ((((traceFire4.Entity:GetClass() == "jc_pot") and ((traceFire4.Entity:GetNWInt("proteinExtract") > 0) and (traceFire4.Entity:GetNWInt("spoiledMeat") > 0))))
			or (((traceFire4.Entity:GetClass() == "jc_spot") and ((traceFire4.Entity:GetNWInt("amphetamine") > 0) and (traceFire4.Entity:GetNWInt("fertilizer") > 0))))) then
				
				-- Subtract the consumption rate
				self:SetNWInt("fusionStorage", math.Clamp(self:GetNWInt("fusionStorage")-JC_CHEM_STATION_CONSUMPTION, 0, self:GetNWInt("fusionStorageMax")));
				
				-- Subtract the time
				traceFire4.Entity:SetNWInt("time", math.Clamp(traceFire4.Entity:GetNWInt("time")-1, 0, traceFire4.Entity:GetNWInt("maxTime")));                
				
				-- If there's no time left
				if (traceFire4.Entity:GetNWInt("time") == 0) then

					-- Set the status to finished
					traceFire4.Entity:SetNWInt("status", 1);

				end;  
				
				-- Flip a coin
				local soundChance = math.random(1, 2);

				-- If it's 2
				if soundChance == 2 then

					-- Play the sound
					traceFire4.Entity:EmitSound("ambient/levels/canals/toxic_slime_gurgle"..math.random(2, 8)..".wav");
				
				end;

				-- Set the fourth slot to be marked as used
				self:SetNWBool("firePlace4", true);

			end;
		
		-- If the fourth trace is not valid
		else

			-- Set the fourth slot to be marked as unused
			self:SetNWBool("firePlace4", false);

		end;

		-- Set the next heat time so it only updates one time per second
		self.nextHeat = CurTime() + 1;

	end;

end;

--[[OnTakeDamage: What happens when the entity takes damage.
        dmginfo: The damage to be applied to the entity
]]
function ENT:OnTakeDamage(dmginfo)

	-- If the Chem Station is set to explode
	if (JC_CHEM_STATION_EXPLOSION_TYPE == 2) then

		-- Reduce health
		self:SetHealth(self:Health() - dmginfo:GetDamage());

		-- If there's no health left
		if self:Health() <= dmginfo:GetDamage() then

			-- If it hasn't been marked for explosion
			if !self:GetNWBool("explode") then
				
				-- Mark it to explode, then explode
				self:SetNWBool("explode", true);
				self:Explode();

			end;

		end;
	
	-- If the Chem Station is destructible
	elseif (JC_CHEM_STATION_EXPLOSION_TYPE == 1) then
		
		-- Reduce health
		self:SetHealth(self:Health()-dmginfo:GetDamage());

		-- If there's no health left
		if self:Health() <= dmginfo:GetDamage() then

			-- Remove the Chem Station
			self:Remove();

		end;
	
	-- If the Chem Station is indestructible
	elseif (JC_CHEM_STATION_EXPLOSION_TYPE == 0) then
		
		-- Exit the function
		return false;

	end;

end;

--[[Explode: Destroys the entity and causes an explosion.]]
function ENT:Explode() 

	-- Initialize the explosion size
	local explosionSize = JC_CHEM_STATION_EXPLOSION_DAMAGE;
   
	-- Create the explosion and set it's properties
	local explosion = ents.Create("env_explosion");                        
	explosion:SetPos(self:GetPos());
	explosion:SetKeyValue("iMagnitude", explosionSize);
	explosion:Spawn();
	explosion:Activate();
	explosion:Fire("Explode", 0, 0);
   
	-- Create the shake effect and set it's properties based on the explosion size
	local shake = ents.Create("env_shake");
	shake:SetPos(self:GetPos());
	shake:SetKeyValue("amplitude", (explosionSize * 2));
	shake:SetKeyValue("radius", explosionSize);
	shake:SetKeyValue("duration", "1.5");
	shake:SetKeyValue("frequency", "255");
	shake:SetKeyValue("spawnflags", "4");
	shake:Spawn();
	shake:Activate();
	shake:Fire("StartShake", "", 0);
   
	-- Remove the entity
	self:Remove();
	
end;