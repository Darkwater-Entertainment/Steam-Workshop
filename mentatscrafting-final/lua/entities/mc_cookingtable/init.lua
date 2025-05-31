--[[
 - init.lua is the server file for the Chemistry STation entity.
 - 
 - @author Kyle James
 - @version 23 August 2023
]]

-- Inclusions
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

-- Fields
ENT.BoilerState = 0;
ENT.PlateState = 0;
ENT.PotState = 0;
ENT.CrateState = 0;
ENT.Plate = nil;

-- Functions
--[[Initialize: Initializes the entity.]]
function ENT:Initialize()

	-- Local fields
	local phys = self:GetPhysicsObject();

	-- Initialize the model
	self:SetModel("models/mosi/fallout4/furniture/workstations/chemistrystation01.mdl");

	-- Initialize the physics
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);

	-- If the physics are functioning
	if phys:IsValid() then

		-- Wake the object
		phys:Wake();

	end;

	-- Adjust the spawn location
	local ang, pos = self:GetAngles(), self:GetPos();
	self:SetPos(Vector(pos.x, pos.y, pos.z + 50));

end;

--[[Think: What the entity does each tick.]]
function ENT:Think()

	-- Local fields
	local pos = self:GetPos();
	local tableLevel = Vector(pos.x, pos.y, pos.z + 100);
	local efis = ents.FindInSphere( tableLevel, 100 );

	-- Reset fields
	self.BoilerState = 0;
	self.PlateState = 0;
	self.PotState = 0;
	self.CrateState = 0;
	self:SetHotPlate(nil);
	self:SetCookingPot(nil);
	self:SetBoiler(nil);
	self:SetCrate(nil);

	-- Check each entity in range
	for a,b in pairs(efis) do

		-- If the entity is the Cooking Pot, set the state accordingly and store the reference
		if b:GetClass() == "mc_cookingpot" then

			if b:GetFull() then

				self.PotState = 2;

			else

				self.PotState = 1;

			end;

			self:SetCookingPot(b);

		end;

		-- If the entity is the Hot Plate, set the state accordingly and store the reference
		if b:GetClass() == "mc_hotplate" then

			self.PlateState = 1;
			self:SetHotPlate(b);

		end;

		-- If the entity is the Boiler, set the state accordingly and store the reference
		if b:GetClass() == "mc_boiler" then

			if b:GetFull() then

				self.BoilerState = 2;

			else

				self.BoilerState = 1;

			end;

			self:SetBoiler(b);

		end;

		-- If the entity is the Crate, set the state accordingly and store the reference
		if b:GetClass() == "mc_crate" then

			if b:GetFull() then

				self.CrateState = 2;

			else

				self.CrateState = 1;

			end;

			self:SetCrate(b);

		end;

	end;

	-- If the Mentats are ready to start cooking
	if self:MCCheckReady() then

		-- If any of the equipment items are invalid, exit the function
		if !IsValid(self:GetBoiler()) or !IsValid(self:GetCrate()) or !IsValid(self:GetCookingPot()) or !IsValid(self:GetHotPlate()) then
			
			return;
		
		end;

		-- Create the timer
		timer.Create("mentatscook" .. self:EntIndex(), MC_COOKTIME, 1, function()
			
			-- If any of the equipment items are invalid when the time runs out, play a fail sound
			if !IsValid(self:GetBoiler()) or !IsValid(self:GetCrate()) or !IsValid(self:GetCookingPot()) or !IsValid(self:GetHotPlate()) then
				
				self:EmitSound("ambient/fire/mtov_flame2.wav");

			else -- If cooking succeeds
				-- Reset full states
				self:GetBoiler():SetFull(false);
				self:GetCookingPot():SetFull(false);
				self:GetCrate():SetFull(false);

				-- Create the Mentats entity & get the physics
				local mentats = ents.Create("mc_mentats");
				local phys = mentats:GetPhysicsObject();

				-- Set the Mentats position on the Hot Plate
				mentats:SetPos(Vector(self:GetHotPlate():GetPos().x, self:GetHotPlate():GetPos().y, self:GetHotPlate():GetPos().z + 10));
				
				-- Set the Mentats physics
				if (SERVER) then

					mentats:PhysicsInit(SOLID_VPHYSICS);

				end;

				-- If the physics are functioning
				if ( IsValid( phys ) ) then

					-- Wake the object
					phys:Wake();

				end;

				-- Set appropriate angles for the Mentats
				mentats:SetAngles(self:GetAngles());

				-- Spawn the entity
				mentats:Spawn();

				-- Play the complete sound
				self:GetHotPlate():EmitSound("ambient/levels/canals/toxic_slime_sizzle2.wav");
			
			end;

		end);

	end;

	-- If the timer exists
	if timer.Exists("mentatscook" .. self:EntIndex()) and IsValid(self:GetBoiler()) and IsValid(self:GetCrate()) and IsValid(self:GetCookingPot()) and IsValid(self:GetHotPlate()) then
		
		-- Randomly play a sound about 1/7 of the time it ticks
		if math.random(1,7) == 1 then

			self:EmitSound("ambient/levels/canals/toxic_slime_gurgle" .. math.random(2,8) .. ".wav")
		
		end;

		-- Store whether or not it's cooking and reduce the time remaining
		self:SetCooking(true);
		self:SetTimeRemaining(timer.TimeLeft("mentatscook"..self:EntIndex()));

	else

		-- If the timer doesn't exist, set that it's not cooking
		self:SetCooking(false);

	end;

end;

--[[MCCheckReady: Checks to see if the Mentats are ready to start cooking]]
function ENT:MCCheckReady()

	-- If the containers are full, equipment is valid, and the timer does not exist, return true, otherwise false
	return self.BoilerState == 2 and self.PlateState == 1 and self.PotState == 2 and self.CrateState == 2 and !timer.Exists("mentatscook" .. self:EntIndex()) and IsValid(self:GetBoiler()) and IsValid(self:GetCrate()) and IsValid(self:GetCookingPot()) and IsValid(self:GetHotPlate());

end;

--[[OnRemove: Cleans up the entity upon removal.]]
function ENT:OnRemove()

	-- Removes the timer
	timer.Remove("mentatscook" .. self:EntIndex());

end;