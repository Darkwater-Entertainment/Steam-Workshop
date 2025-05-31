--[[
 - cl_init.lua is the client file for the Fertilizer entity.
 - 
 - @author Kyle James
 - @version 24 August 2023
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
--[[Draw: Draws the model and UI.]]
function ENT:Draw()

	-- Local fields
	local pos = self:GetPos();

	-- Draw the model
	self:DrawModel();

	-- If the player is within range, display the UI
	if LocalPlayer():GetPos():Distance(pos) < JC_UI_RANGE then
		
		-- Local fields
		local ang = self:GetAngles();
		local t = Vector(-4.55, -64, 12)

		-- Set appropriate position for UI
		t:Rotate(self:GetAngles());
		pos = pos + t;
		
		-- Set appropriate rotations for UI
		ang:RotateAroundAxis(ang:Right(), 90);
		
		-- Draw the UI
		cam.Start3D2D(pos, ang, 0.1);

			draw.RoundedBox(0, -95, -705, 190, 110, JC_OUTLINE_COLOR);

			draw.RoundedBox(0, -90, -700, 180, 100, JC_BG_COLOR);

			draw.SimpleText("Fertilizer", "TerminalFont", 0, -675, JC_TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

			draw.SimpleText("Weight: " .. self:GetNWInt("amount") .. "lbs", "TerminalFont", 0, -625, JC_TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

		cam.End3D2D();

	end;

end;