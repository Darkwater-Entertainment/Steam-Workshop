--[[
 - cl_init.lua is the client file for the Crate entity.
 - 
 - @author Kyle James
 - @version 23 August 2023
]]

-- Inclusions
include("shared.lua");

-- Fonts
surface.CreateFont( "TerminalFont", {
	font = "monofonto",
	size = 23,
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
--[[Draw: Draws the model and the UI.]]
function ENT:Draw()

	-- Draw the model
	self:DrawModel();
	
	-- If the player is within range, display the UI
	if LocalPlayer():GetPos():Distance(self:GetPos()) < MC_UI_RANGE then

		-- Local fields
		local pos = self:GetPos();
		local ang = self:GetAngles();
		local text = "";
		local t;
		
		-- Set appropriate positions for UI
		t = Vector(14, 0, -54);
		t:Rotate(self:GetAngles());
		pos = pos + t;

		-- Set appropriate rotations for UI
		ang:RotateAroundAxis(self:GetAngles():Up(), 90);
		ang:RotateAroundAxis(self:GetAngles():Right(), 270);

		-- Set the appropriate text for UI
		if self:GetFull() then

			text = "Ready!";

		else

			text = "Needs Lead!";

		end;

		-- Draw the UI
		cam.Start3D2D(pos,ang,0.1);

			draw.RoundedBox(0, -105, -705, 210, 110, MC_OUTLINE_COLOR);

			draw.RoundedBox(0, -100, -700, 200, 100, MC_BG_COLOR);

			draw.SimpleText("Crate", "TerminalFont", 0, -675, MC_TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

			draw.SimpleText("Status: " .. text, "TerminalFont", 0, -625, MC_TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

		cam.End3D2D();
		
	end;
	
end;