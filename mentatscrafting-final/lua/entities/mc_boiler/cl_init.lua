--[[
 - cl_init.lua is the client file for the Boiler entity.
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
		t = Vector(0, -5, -45);
		t:Rotate(self:GetAngles());
		pos = pos + t;

		-- Set appropriate rotations for UI
		ang:RotateAroundAxis(self:GetAngles():Forward(), 90);
		ang:RotateAroundAxis(self:GetAngles():Up(), 180);

		-- Set the approriate text for UI
		if self:GetFull() then

			text = "Ready!";

		else

			text = "Needs Fungus!";

		end;

		-- Draw the UI
		cam.Start3D2D(pos,ang,0.1);

			draw.RoundedBox(0, -105, -705, 210, 140, MC_OUTLINE_COLOR);

			draw.RoundedBox(0, -100, -700, 200, 130, MC_BG_COLOR);

			draw.SimpleText("Boiler", "TerminalFont", 0, -675, MC_TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

			draw.SimpleText("Status: ", "TerminalFont", 0, -625, MC_TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

			draw.SimpleText(text, "TerminalFont", 0, -600, MC_TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

		cam.End3D2D();

	end;
	
end;