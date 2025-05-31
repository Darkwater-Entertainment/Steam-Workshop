--[[
 - init.lua is the server file for the Jet Addict entity.
 - 
 - @author Kyle James
 - @version 24 August 2023
]]

-- Inclusions
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

-- Functions
--[[Initialize: Initializes the entity.]]
function ENT:Initialize()
	
	-- Initialize the model
	self:SetModel("models/fallout3/player/painspikefemaleraider.mdl");

	-- Initialize the NPC elements
	self:SetHullType(HULL_HUMAN);
	self:SetHullSizeNormal();
	self:SetNPCState(NPC_STATE_SCRIPT);
	self:SetSolid(SOLID_BBOX);
	self:SetUseType(SIMPLE_USE);
	self:SetBloodColor(BLOOD_COLOR_RED);
	
end;

--[[Use: What happens when the player uses the entity.
        act: The entity that caused this input. This will usually be the player who pressed their use key
]]
function ENT:Use(act)

	-- If the player isn't on cooldown from using the NPC
	if (!self.nextUse or CurTime() >= self.nextUse) then

		-- If the player doesn't have Jet
		if (act:IsPlayer() and (act:GetNWInt("player_jet") == 0)) then

			-- Inform the player they don't have Jet by spouting random nonsense
			act:SendLua("local tab = {JC_TEXT_COLOR, [[Jet Addict: ]], Color(255, 255, 255), [[" .. table.Random(JC_ADDICT_NO_JET) .. "]]} chat.AddText(unpack(tab))");
			
			-- If we want to emit sound
			if (JC_ADDICT_SFX) then
				
				-- Play sound that informs the player that they didn't have Jet
				timer.Simple(0.25, function() self:EmitSound(table.Random(JC_ADDICT_NO_JET_SFX), 100, 100) end);
			
			end;

		-- If the player has Jet
		elseif (act:IsPlayer()) and (act:GetNWInt("player_jet") > 0) then

			-- Add money to the player's wallet
			act:addMoney(act:GetNWInt("player_jet"));

			-- Inform the player of their payout
			act:SendLua("local tab = {JC_TEXT_COLOR, [[Jet Addict: ]], Color(255,255,255), [["..table.Random(JC_ADDICT_JET)..". Here is your ]], JC_TEXT_COLOR, [["..act:GetNWInt("player_jet").." caps.]] } chat.AddText(unpack(tab))");
			
			-- Reset their "inventory"
			act:SetNWInt("player_jet", 0);

			-- If we want to emit sound
			if (JC_ADDICT_SFX) then
				-- Play sound that informs the player that they had Jet
				timer.Simple(0.25, function() self:EmitSound(table.Random(JC_ADDICT_JET_SFX), 100, 100) end);
				timer.Simple(2.5, function() self:EmitSound("vo/npc/male01/moan0"..math.random(1, 5)..".wav") end);
			end;

		end;

		-- Set the cooldown
		self.nextUse = CurTime() + JC_USE_DELAY;

	end;

end;

--[[spawnAddict: Spawns the Jet Addict if there is data for this map.]]
function spawnAddict()	

	-- Check if the directory for Jet Crafting is established
	if not file.IsDir("jc", "DATA") then
		
		-- Create it if not
		file.CreateDir("jc", "DATA");

	end;
	
	-- Check if the directory for Jet Crafting on this map is established
	if not file.IsDir("jc/addict/"..string.lower(game.GetMap()).."", "DATA") then
		
		-- Create it if not
		file.CreateDir("jc/addict/"..string.lower(game.GetMap()).."", "DATA");
	
	end;

	-- For each Addict in this map
	for k, v in pairs(file.Find("jc/addict/"..string.lower(game.GetMap()).."/*.txt", "DATA")) do
		
		-- Get the file for this Addict
		local addictPosFile = file.Read("jc/addict/"..string.lower(game.GetMap()).."/".. v, "DATA");
	 
		-- Get the spawn position associated with this Addict
		local spawnData = string.Explode(";", addictPosFile);
		
		-- Store the spawn position with relevant angles for this Addict
		local addictPos = Vector(spawnData[1], spawnData[2], spawnData[3]);
		local addictAngles = Angle(tonumber(spawnData[4]), spawnData[5], spawnData[6]);
		
		-- Create the Addict entity
		local addict = ents.Create("jc_addict");

		-- Set the position and angles
		addict:SetPos(addictPos);
		addict:SetAngles(addictAngles);

		-- Spawn the Addict
		addict:Spawn();

	end;

end;

--[[setAddictPos: Sets a new spawn position for Jet Addicts to appear on the current map.
		ply: The player
		cmd: The console command (jc_addict_setpos)
		args: The arguments (the name of the Addict for storage)
]]
function setAddictPos(ply, cmd, args)
	-- If the player has admin rights
	if (ply:IsAdmin() or ply:IsSuperAdmin()) then

		-- Store the name of the Jet Addict
		local fileAddictName = args[1];
		
		-- If the admin did not enter a name, inform them and exit the function
		if not fileAddictName then

			ply:SendLua("local tab = {JC_TEXT_COLOR, [[|JC| ]], Color(255,255,255), [[Choose a name for your Jet Addicted NPC!]] } chat.AddText(unpack(tab))");
			return;

		end;
		
		-- If the admin entered a name already in use, inform them and exit the function
		if file.Exists( "jc/addict/"..string.lower(game.GetMap()).."/addict_".. fileAddictName ..".txt", "DATA") then 
			
			ply:SendLua("local tab = {JC_TEXT_COLOR, [[|JC| ]], Color(255,255,255), [[This name is alredy in use, choose another one or remove this one by typing 'addict_remove "..fileAddictName.."' in console.]] } chat.AddText(unpack(tab))");
			return;

		end;
		
		-- Get the Addict position and angles
		local addictPos = string.Explode(" ", tostring(ply:GetEyeTrace().HitPos));
		local addictAngles = string.Explode(" ", tostring(ply:GetAngles()+Angle(0, -180, 0)));
		
		-- Write the new Addict to the data files and inform the admin
		file.Write("jc/addict/".. string.lower(game.GetMap()) .."/addict_".. fileAddictName ..".txt", ""..(addictPos[1])..";"..(addictPos[2])..";"..(addictPos[3])..";"..(addictAngles[1])..";"..(addictAngles[2])..";"..(addictAngles[3]).."", "DATA");
		ply:SendLua("local tab = {JC_TEXT_COLOR, [[|JC| ]], Color(255,255,255), [[New pos for the Jet Addicted NPC has been set. Restart your server!]] } chat.AddText(unpack(tab))");
	
	-- If the player is not an admin, inform them that they cannot use this command
	else

		ply:SendLua("local tab = {JC_TEXT_COLOR, [[|JC| ]], Color(255,255,255), [[Only admins and superadmins can perform this action.]] } chat.AddText(unpack(tab))");
	
	end;

end;

--[[removeAddictPos: Removes a spawn position for a Jet Addict on the current map.
		ply: The player
		cmd: The console command (jc_addict_remove)
		args: The arguments (the name of the Addict for storage)
]]
function removeAddictPos(ply, cmd, args)

	-- If the player has admin rights
	if (ply:IsAdmin() or ply:IsSuperAdmin()) then

		-- Store the name of the Jet Addict
		local fileAddictName = args[1];
		
		-- If the admin did not enter a name, inform them and exit the function
		if not fileAddictName then

			ply:SendLua("local tab = {JC_TEXT_COLOR, [[|JC| ]], Color(255,255,255), [[Please enter the name of the Jet Addicted NPC to remove!]] } chat.AddText(unpack(tab))");
			return;

		end;
		
		-- If the admin entered a name in use, delete the Addict data and inform them
		if file.Exists("jc/addict/".. string.lower(game.GetMap()) .."/addict_"..fileAddictName..".txt", "DATA") then
			
			file.Delete("jc/addict/".. string.lower(game.GetMap()) .."/addict_"..fileAddictName..".txt");
			ply:SendLua("local tab = {JC_TEXT_COLOR, [[|JC| ]], Color(255,255,255), [[This Jet Addicted NPC has been removed. Restart your server!]] } chat.AddText(unpack(tab))");
			return;

		else -- If the name is not in use, inform the admin

			ply:SendLua("local tab = {JC_TEXT_COLOR, [[|JC| ]], Color(255,255,255), [[That Jet Addicted NPC does not exist; please enter an existing name.]] } chat.AddText(unpack(tab))");
			return;
		
		end;
		
	-- If the player is not an admin, inform them that they cannot use this command
	else

		ply:SendLua("local tab = {JC_TEXT_COLOR, [[|JC| ]], Color(255,255,255), [[Only admins and superadmins can perform this action.]] } chat.AddText(unpack(tab))");					
	
	end;

end;

-- Spawn existing addicts & establish console commands
timer.Simple(1, spawnAddict);
concommand.Add("jc_addict_add", setAddictPos);
concommand.Add("jc_addict_remove", removeAddictPos);