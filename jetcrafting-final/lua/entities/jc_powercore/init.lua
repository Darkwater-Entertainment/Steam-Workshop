--[[
 - init.lua is the server file for the Power Core entity.
 - 
 - @author Kyle James
 - @version 24 August 2023
]]

-- Inclusions
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

--[[SpawnFunction: Defines how the entity spawns from the spawnmenu.
		ply: The player
		trace: A table for the player's eye trace
]]
function ENT:SpawnFunction(ply, trace)

	-- Local fields
	local ent = ents.Create("jc_powercore");

	-- Sets up the entity position, spawns it, and activates it
	ent:SetPos(trace.HitPos + trace.HitNormal * 16);
	ent:Spawn();
	ent:Activate();
     
	-- Returns the entity
	return ent;

end;

-- Functions
--[[Initialize: Initializes the entity.]]
function ENT:Initialize()

	-- Initialize the model
	self:SetModel("models/props_c17/canister01a.mdl");

	-- Initialize the physics
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	
	-- Initialize network values
	self:SetNWInt("distance", JC_UI_RANGE);
	self:SetNWInt("amount", JC_PC_AMOUNT);
	self:SetNWInt("maxAmount", JC_PC_AMOUNT);
	self:SetNWBool("open", false);
	self:SetNWBool("explode", false);

	-- Alter the mass of the object
	self:GetPhysicsObject():SetMass(105);

	-- Set the position on spawn
	self:SetPos(self:GetPos() + Vector(0, 0, 32));

end;

--[[Think: What the entity does each tick.]]
function ENT:Think()

	-- Set up the trace to check for Chemistry Station connection
	local traceGas = {}	
	traceGas.start = (self:GetPos()+(self:GetUp()*28));
	traceGas.endpos = (self:GetPos()+(self:GetUp()*42));
	traceGas.filter = self;
	
	-- Connect the trace line
	local traceConnect = util.TraceLine(traceGas);
	
	-- If it's time to power, there's power remaining, and it's open
	if ((!self.nextGas or CurTime() >= self.nextGas) and (self:GetNWInt("amount")>0) and self:GetNWBool("open")) then	
		
		-- If the trace connects to a valid entity
		if IsValid(traceConnect.Entity) then	

			-- If the entity is the Chemistry Station
			if (traceConnect.Entity:GetClass() == "jc_chemstation") then

				-- Reduce the power remaining
				self:SetNWInt("amount", math.Clamp(self:GetNWInt("amount") - 1, 0, self:GetNWInt("maxAmount")));

				-- Increase the power in the Chemistry station
				traceConnect.Entity:SetNWInt("fusionStorage", math.Clamp(traceConnect.Entity:GetNWInt("fusionStorage") + 1, 0, traceConnect.Entity:GetNWInt("fusionStorageMax")));	
			
			-- If it's not connecting to the Chemistry Station
			else

				-- Reduce the power remaining
				self:SetNWInt("amount", math.Clamp(self:GetNWInt("amount")-1, 0, self:GetNWInt("maxAmount")));
			
			end;

		-- If it's not connecting to anything
		else

			-- Reduce the power remaining
			self:SetNWInt("amount", math.Clamp(self:GetNWInt("amount")-1, 0, self:GetNWInt("maxAmount")));
		
		end;

		-- Power every 1/100th of a second
		self.nextGas = CurTime() + 0.01;

	end;
	

	-- If the power runs out
	if (self:GetNWInt("amount") == 0) then

		-- Stop the sound if it's making noise
		if self.gasSound then

			self.gasSound:Stop();

		end;

		-- Remove it if the setting is enabled
		if JC_PC_REMOVE then

			self:Destruct();
		
		end;
	end;
		
end;

--[[Use: What happens when the player uses the entity.
        act: The entity that caused this input. This will usually be the player who pressed their use key
]]
function ENT:Use(act)

	-- Store the current time
	local curTime = CurTime();

	-- If the player isn't on cooldown from using the entity
	if (!self.nextUse or curTime >= self.nextUse) then

		-- If it's open, play a sound and update the network value
		if !self:GetNWBool("open") then
			self:SetNWBool("open", true);
			self.gasSound = CreateSound(self, Sound("ambient/gas/cannister_loop.wav"))
			self.gasSound:SetSoundLevel(42);
			self.gasSound:PlayEx(1, 150);
		-- If it's not opne, stop the sound and update the network value
		else
			self:SetNWBool("open", false);
			if self.gasSound then

				self.gasSound:Stop();

			end;

		end;

		-- Set the cooldown
		self.nextUse = curTime + JC_USE_DELAY;

	end;

end;

--[[OnTakeDamage: What happens when the entity takes damage.
        dmginfo: The damage to be applied to the entity
]]
function ENT:OnTakeDamage(dmginfo)

	-- If it's set to explode, explode
	if (JC_PC_EXPLOSION == 2) then
		
		-- Check for network values and set them
		if !self:GetNWBool("explode") then

			self:SetNWBool("explode", true);

			-- If power was left, stop the sound, then explode
			if (self:GetNWInt("amount") > 0) then

				if self.gasSound then

					self.gasSound:Stop();

				end;	

				self:Explode();

			-- If no power was left, destruct w/o damage
			else

				self:Destruct();

			end;

		end;

	-- If it's set to destruct w/o damage, destruct
	elseif (JC_PC_EXPLOSION == 1) then
		
		-- If the sound was playing, stop it
		if self.gasSound then

			self.gasSound:Stop();

		end;

		-- Destruct w/o damage
		self:Destruct();

	-- If it's indestructible, do nothing
	elseif (JC_PC_EXPLOSION == 0) then

		return false;

	end;

end;

--[[Destruct: Destroy the entity.]]
function ENT:Destruct()

	-- Local fields
	local effectData = EffectData();

	-- Set the start, origin, and scale of the effect
	effectData:SetStart(self:GetPos());
	effectData:SetOrigin(self:GetPos());
	effectData:SetScale(8);	

	-- Start the glass impact effect
	util.Effect("GlassImpact", effectData, true, true);

	-- Remove the entity
	self:Remove();
end;

--[[Explode: Destroys the entity and causes an explosion.]]
function ENT:Explode()

	-- Initialize the explosion size based on the amount of power left
	local explosionSize = math.Round(self:GetNWInt("amount") / 2);
	
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
	shake:SetKeyValue("amplitude", (explosionSize*2));
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