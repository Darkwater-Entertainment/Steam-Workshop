

---------------------
-- FOR YOU TO READ --
---------------------
--
-- please follow the provided instructions in the readme
-- unless you have prior lua knowledge, in which case
-- just run quickly over the covered steps in the readme. 
--
-- please make sure you only
-- edit the sections flagged with
-- '--$ {extra information}' editing
-- anything else can cause problems with 
-- your extension and it will not be loaded!
--
-- IF YOU REQUIRE ANY HELP CONTACT ME (slaugh7er) ON STEAM
--
----------------------

if SERVER then

	resource.AddWorkshop("2570676566") --$ place you workshop addon number here ( I told you to copy it remember ;) )
	
end

if CLIENT then

	function Nombat_Cl_Init(  )
		
		local pl = LocalPlayer() -- (DONT EDIT)
		
		if IsValid(pl) then
			
			if pl then
				
				pl.NOMBAT_Level = 1 -- (DONT EDIT)
				pl.NOMBAT_PostLevel = 1 -- (DONT EDIT)
				
				local Ambient_Time = {134,134,130,130,130,130,130,127,121,121,119,119,128,128,124,127,124,130,128,128,197,226,203,200,187,204,204,237,243,241,233,201,210,97,100,103,218,205,218,208,244,206,168,212,133,133,133,133,133,133,121,121,121,124,124,124,121,121,121,121,121,121,132,132,132,128,128,128,122,122,122,122,122,122,128,128,128,126,126,126,122,122,124,122,121,121,127,121,121,121,121,120,120,120,124,124,132,124,123,123,123,123,123,123,123,123,123} --$ song time (in seconds)
				pl.NOMBAT_Amb_Delay = CurTime() -- (DONT EDIT)
				
				local Combat_Time = {36,36,36,36,45,45,45,37,37,37,37,37,37,35,34,36,36,43,43,43,43,39,40,50,50,41,41,41,40,41,40,67,67,67,67,50,50,50,50,134,130,130,121,119,128,124,128,123,123,123,123,123,123,36,36,36,36,45,45,45,37,37,37,37,37,37,35,34,36,36,43,43,43,43,39,40,50,50,41,41,41,40,41,40,67,67,67,67,50,50,50,50,134,130,130,121,119,128,124,128,123,123,123,123,123,123,36} --$ song time (in seconds)
				pl.NOMBAT_Com_Delay = CurTime() -- (DONT EDIT)
				pl.NOMBAT_Com_Cool = CurTime() -- (DONT EDIT)
				
				local packName = "fallout_new_vegas" --$ MAKE SURE THIS IS THE SAME AS THE FOLDER NAME HOLDING THE SOUNDS
				
				if !isstring(packName) then packName = tostring( packName )	end -- (DONT EDIT)
				
				packName = packName.."/" -- (DONT EDIT)

				local subTable = { packName, Ambient_Time, Combat_Time } -- (DONT EDIT)
				
				if !pl.NOMBAT_PackTable then -- (DONT EDIT)
					pl.NOMBAT_PackTable = {subTable} -- (DONT EDIT)
						
				else
					table.insert( pl.NOMBAT_PackTable, subTable ) -- (DONT EDIT)
				end
				
				pl.NOMBAT_SVol = 0 -- (DONT EDIT)
				
			end
		end
	end
	hook.Add( "InitPostEntity", "Nombat_Cl_Init_fallout_new_vegas", Nombat_Cl_Init ) --$ change the "Nombat_Cl_Init_GAMENAME" to "Nombat_Cl_Init_" and your game name.
	
end







