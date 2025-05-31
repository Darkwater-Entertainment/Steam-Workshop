--[[
 - cl_init.lua is the client file for the Power Core entity.
 - 
 - @author Kyle James
 - @version 24 August 2023
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

	-- Initialize the time and particle position
	self.emitTime = CurTime();
	self.gasPlace = ParticleEmitter(self:GetPos());

end;

--[[Think: What the entity does each tick.]]
function ENT:Think()
	
	-- If there is gas remaining, the emit time is not caught up to the current time, and the canister is open
	if (self:GetNWInt("amount") > 0) and (self.emitTime < CurTime()) and (self:GetNWBool("open")) then

		-- Set up the particle emission point
		local gasPos = self:GetPos() + (self:GetUp() * 28), self:GetPos() + (self:GetUp() * 42);

		-- Set up the smoke particle
		local smoke = self.gasPlace:Add("particle/smokesprites_000"..math.random(1,9), gasPos);
		
		-- Set the smoke's appearance
		smoke:SetVelocity(self:GetUp() * 128);
		smoke:SetDieTime(math.Rand(0.6, 1.3));
		smoke:SetStartAlpha(math.Rand(150, 200));
		smoke:SetEndAlpha(0);
		smoke:SetStartSize(math.random(0, 5));
		smoke:SetEndSize(math.random(16, 18));
		smoke:SetRoll(math.Rand(180, 480));
		smoke:SetRollDelta(math.Rand(-3, 3));
		smoke:SetColor(255, 255, 255);
		smoke:SetGravity(Vector(0, 0, 10));
		smoke:SetAirResistance(256);

		-- Increment the emission time
		self.emitTime = CurTime() + .1;

	end;

end;

--[[Draw: Draws the model and UI.]]
function ENT:Draw()
	
	-- Local fields
	local pos = self:GetPos()

	-- Alter appearance and draw the model
	self:SetMaterial("models/debug/debugwhite")
	self:SetColor(Color(243,227,93))
	self:DrawModel();
	
	-- If the player is within range, display the UI
	if LocalPlayer():GetPos():Distance(pos) < JC_UI_RANGE then
		
		-- Local fields
		local ang = self:GetAngles();
		
		-- Set appropriate rotations for UI
		ang:RotateAroundAxis(ang:Up(), 0);
		ang:RotateAroundAxis(ang:Forward(), 0);
		ang:RotateAroundAxis(ang:Right(), -90);
		
		-- Set and draw the laser to show connection
		render.SetMaterial(Material("cable/redlaser"));
		render.DrawBeam(pos + (self:GetUp() * 28), pos + (self:GetUp() * 42), 1, 1, 1, Color(255, 0, 0, 255));

		-- Draw the UI
		cam.Start3D2D(pos+ang:Up()*4.75, ang, 0.1);
		
				draw.RoundedBox(0, -176, -12, 450, 24, JC_OUTLINE_COLOR);
			
				draw.RoundedBox(0, -173, -9, math.Round((self:GetNWInt("amount") * 444) / self:GetNWInt("maxAmount")), 18, JC_BG_COLOR);

				draw.SimpleText(math.Round((self:GetNWInt("amount") * 100) / self:GetNWInt("maxAmount")) .. "% (" .. self:GetNWInt("amount") .. "/" .. self:GetNWInt("maxAmount") .. ")", "TerminalFontSmall", -170, -7, JC_TEXT_COLOR, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);

		cam.End3D2D();

	end;

end;