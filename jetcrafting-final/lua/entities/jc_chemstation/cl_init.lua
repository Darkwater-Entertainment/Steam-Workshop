--[[
 - cl_init.lua is the client file for the Chemistry Station entity.
 - 
 - @author Kyle James
 - @version 16 September 2023
]]

-- Inclusions
include("shared.lua");

-- Fonts
surface.CreateFont( "TerminalFontSmall", {
	font = "monofonto",
	size = 16,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
});

-- Functions
--[[Initialize: Initializes the entity.]]
function ENT:Initialize()
	
	-- Set the emission time for the particles and set the particle positions
	local pos = self:GetPos();
	self.emitTime = CurTime();
	self.firePlace1 = ParticleEmitter(pos);
	self.firePlace2 = ParticleEmitter(pos);
	self.firePlace3 = ParticleEmitter(pos);
	self.firePlace4 = ParticleEmitter(pos);

end;

--[[Think: What the entity does each tick.]]
function ENT:Think()

	-- Set the fire positions
	local pos = self:GetPos();
	local firePos1 = pos + (self:GetUp() * 20) + (self:GetForward() * 2.8) + (self:GetRight() * 11.5);
	local firePos2 = pos + (self:GetUp() * 20) + (self:GetForward() * 2.8) + (self:GetRight() * -11.2);
	local firePos3 = pos + (self:GetUp() * 20) + (self:GetForward() * -9.8) + (self:GetRight() * -11.2);
	local firePos4 = pos + (self:GetUp() * 20) + (self:GetForward() * -9.8) + (self:GetRight() * 11.5);
	
	-- If there is energy
	if (self:GetNWInt("fusionStorage") > 0) then

		-- If it's time to emit (emits 1 time per second)
		if (self.emitTime < CurTime()) then

			-- If the first burner is in use
			if (self:GetNWBool("firePlace1")) then

				-- Initialize the particle and emit it
				local smoke = self.firePlace1:Add("particle/smokesprites_000" .. math.random(1, 9), firePos1);
				smoke:SetVelocity(Vector(0, 0, 150));
				smoke:SetDieTime(math.Rand(0.6, 2.3));
				smoke:SetStartAlpha(math.Rand(150, 200));
				smoke:SetEndAlpha(0);
				smoke:SetStartSize(math.random(0, 5));
				smoke:SetEndSize(math.random(33, 55));
				smoke:SetRoll(math.Rand(180, 480));
				smoke:SetRollDelta(math.Rand(-3, 3));
				smoke:SetColor(JC_CHEM_STATION_SMOKE_COLOR_R, JC_CHEM_STATION_SMOKE_COLOR_G, JC_CHEM_STATION_SMOKE_COLOR_B);
				smoke:SetGravity(Vector(0, 0, 10));
				smoke:SetAirResistance(256);

				-- Update the emit time
				self.emitTime = CurTime() + .1;

			end;

			-- If the second burner is in use
			if (self:GetNWBool("firePlace2")) then

				-- Initialize the particle and emit it
				local smoke = self.firePlace2:Add("particle/smokesprites_000" .. math.random(1, 9), firePos2);
				smoke:SetVelocity(Vector(0, 0, 150));
				smoke:SetDieTime(math.Rand(0.6, 2.3));
				smoke:SetStartAlpha(math.Rand(150, 200));
				smoke:SetEndAlpha(0);
				smoke:SetStartSize(math.random(0, 5));
				smoke:SetEndSize(math.random(33, 55));
				smoke:SetRoll(math.Rand(180, 480));
				smoke:SetRollDelta(math.Rand(-3, 3));
				smoke:SetColor(JC_CHEM_STATION_SMOKE_COLOR_R, JC_CHEM_STATION_SMOKE_COLOR_G, JC_CHEM_STATION_SMOKE_COLOR_B);
				smoke:SetGravity(Vector(0, 0, 10));
				smoke:SetAirResistance(256);

				-- Update the emit time
				self.emitTime = CurTime() + .1;

			end;

			-- If the third burner is in use
			if (self:GetNWBool("firePlace3")) then

				-- Initialize the particle and emit it
				local smoke = self.firePlace3:Add("particle/smokesprites_000"..math.random(1,9), firePos3);
				smoke:SetVelocity(Vector(0, 0, 150));
				smoke:SetDieTime(math.Rand(0.6, 2.3));
				smoke:SetStartAlpha(math.Rand(150, 200));
				smoke:SetEndAlpha(0);
				smoke:SetStartSize(math.random(0, 5));
				smoke:SetEndSize(math.random(33, 55));
				smoke:SetRoll(math.Rand(180, 480));
				smoke:SetRollDelta(math.Rand(-3, 3));
				smoke:SetColor(JC_CHEM_STATION_SMOKE_COLOR_R, JC_CHEM_STATION_SMOKE_COLOR_G, JC_CHEM_STATION_SMOKE_COLOR_B);
				smoke:SetGravity(Vector(0, 0, 10));
				smoke:SetAirResistance(256);

				-- Update the emit time
				self.emitTime = CurTime() + .1;

			end;

			-- If the fourth burner is in use
			if (self:GetNWBool("firePlace4")) then

				-- Initialize the particle and emit it
				local smoke = self.firePlace4:Add("particle/smokesprites_000"..math.random(1,9), firePos4);
				smoke:SetVelocity(Vector(0, 0, 150));
				smoke:SetDieTime(math.Rand(0.6, 2.3));
				smoke:SetStartAlpha(math.Rand(150, 200));
				smoke:SetEndAlpha(0);
				smoke:SetStartSize(math.random(0, 5));
				smoke:SetEndSize(math.random(33, 55));
				smoke:SetRoll(math.Rand(180, 480));
				smoke:SetRollDelta(math.Rand(-3, 3));
				smoke:SetColor(JC_CHEM_STATION_SMOKE_COLOR_R, JC_CHEM_STATION_SMOKE_COLOR_G, JC_CHEM_STATION_SMOKE_COLOR_B);
				smoke:SetGravity(Vector(0, 0, 10));
				smoke:SetAirResistance(256);

				-- Update the emit time
				self.emitTime = CurTime() + .1;

			end;	

		end;

	end;

end;

--[[Draw: Draws the model and UI.]]
function ENT:Draw()

	-- Local fields
	local pos = self:GetPos();

	-- Draw the model
	self:DrawModel();

	-- If the player is within range, display the UI
	if LocalPlayer():GetPos():Distance(pos) < JC_UI_RANGE then

		-- Local fields
		local laser = Material("cable/redlaser");
		local ang = self:GetAngles();

		-- Set the appropriate rotations for UI
		ang:RotateAroundAxis(ang:Up(), 90);
		ang:RotateAroundAxis(ang:Forward(), 90);

		-- Set the render material, then draw each burner's beam
		render.SetMaterial(laser);
		render.DrawBeam(pos + (self:GetUp() * 20) + (self:GetForward() * 2.8) + (self:GetRight() * 11.5), pos + (self:GetUp() * 24) + (self:GetForward() * 2.8) + (self:GetRight() * 11.5), 1, 1, 1, Color(255, 0, 0, 0)); -- Burner 1
		render.DrawBeam(pos + (self:GetUp() * 20) + (self:GetForward() * 2.8) + (self:GetRight() * -11.2), pos + (self:GetUp() * 24) + (self:GetForward() * 2.8) + (self:GetRight() * -11.2), 1, 1, 1, Color(255, 0, 0, 0)); -- Burner 2
		render.DrawBeam(pos + (self:GetUp() * 20) + (self:GetForward() * -9.8) + (self:GetRight() * -11.2), pos + (self:GetUp() * 24) + (self:GetForward() * -9.8) + (self:GetRight() * -11.2), 1, 1, 1, Color(255, 0, 0, 0)); -- Burner 3
		render.DrawBeam(pos + (self:GetUp() * 20) + (self:GetForward() * -9.8) + (self:GetRight() * 11.5), pos + (self:GetUp() * 24) + (self:GetForward() * -9.8) + (self:GetRight() * 11.5), 1, 1, 1, Color(255, 0, 0, 0)); -- Burner 4
		
		-- Draw the UI
		cam.Start3D2D(pos + ang:Up() * 14.5, ang, 0.1);
		
			draw.RoundedBox(0, -215, -51, 194, 20, JC_OUTLINE_COLOR);
			
			draw.RoundedBox(0, -213, -50, math.Round((self:GetNWInt("fusionStorage") * 190) / self:GetNWInt("fusionStorageMax")), 18, JC_BG_COLOR);	
			draw.SimpleText(math.Round((self:GetNWInt("fusionStorage") * 100) / self:GetNWInt("fusionStorageMax")) .. "%", "TerminalFontSmall", -211, -48, JC_TEXT_COLOR, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT);

			draw.RoundedBox(0, -215, -90, 48, 32, JC_OUTLINE_COLOR)	;

			-- Check the first burner's status and update the UI
			if !self:GetNWBool("firePlace1") then

				draw.RoundedBox(8, -212.5, -73, 14, 14, JC_BG_COLOR);

			elseif self:GetNWBool("firePlace1") then

				if (self:GetNWInt("fusionStorage")>0) then

					draw.RoundedBox(8, -212.5, -73, 14, 14, JC_TEXT_COLOR);

				else 		

					draw.RoundedBox(8, -212.5, -73, 14, 14, JC_BG_COLOR);

				end;

			end;
				
			-- Check the second burner's status and update the UI
			if !self:GetNWBool("firePlace2") then	

				draw.RoundedBox(8, -184.5, -73, 14, 14, JC_BG_COLOR);

			elseif self:GetNWBool("firePlace2") then

				if (self:GetNWInt("fusionStorage")>0) then

					draw.RoundedBox(8, -184.5, -73, 14, 14, JC_TEXT_COLOR);

				else 		

					draw.RoundedBox(8, -184.5, -73, 14, 14, JC_BG_COLOR);

				end;

			end;				
				
			-- Check the third burner's status and update the UI
			if !self:GetNWBool("firePlace3") then	

				draw.RoundedBox(8, -184.5, -89, 14, 14, JC_BG_COLOR);

			elseif self:GetNWBool("firePlace3") then

				if (self:GetNWInt("fusionStorage")>0) then

					draw.RoundedBox(8, -184.5, -89, 14, 14, JC_TEXT_COLOR);

				else 		

					draw.RoundedBox(8, -184.5, -89, 14, 14, JC_BG_COLOR);

				end;

			end;		
			
			-- Check the fourth burner's status and update the UI
			if !self:GetNWBool("firePlace4") then	

				draw.RoundedBox(8, -212.5, -89, 14, 14, JC_BG_COLOR);

			elseif self:GetNWBool("firePlace4") then	

				if (self:GetNWInt("fusionStorage")>0) then

					draw.RoundedBox(8, -212.5, -89, 14, 14, JC_TEXT_COLOR);

				else 		

					draw.RoundedBox(8, -212.5, -89, 14, 14, JC_BG_COLOR);

				end;

			end;		
					
		cam.End3D2D();

	end;

end;