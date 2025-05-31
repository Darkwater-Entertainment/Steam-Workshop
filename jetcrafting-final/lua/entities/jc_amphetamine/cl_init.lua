--[[
 - cl_init.lua is the client file for the Spoiled Meat entity.
 - 
 - @author Kyle James
 - @version 16 September 2023
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
	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < JC_UI_RANGE then

		-- Local fields
		local ang = self:GetAngles();
		local t = Vector(0, 0, -44)

		-- Set appropriate position for UI
		t:Rotate(self:GetAngles());
		pos = pos + t;

		-- Set appropriate rotation for UI
		ang:RotateAroundAxis(ang:Up(), 90);
		ang:RotateAroundAxis(ang:Forward(), 90);

		-- Draw the UI
		cam.Start3D2D(pos+ang:Up() * 3.35, ang, 0.07);
		
			draw.RoundedBox(0, -65, -705, 130, 140, JC_OUTLINE_COLOR);

			draw.RoundedBox(0, -60, -700, 120, 130, JC_BG_COLOR);

			draw.SimpleText("Amphetamine", "TerminalFont", 0, -675, JC_TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

			draw.SimpleText("Weight: ", "TerminalFont", 0, -625, JC_TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
			draw.SimpleText(self:GetNWInt("amount") .. "lbs", "TerminalFont", 0, -600, JC_TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

		cam.End3D2D();
		
	end;

end;