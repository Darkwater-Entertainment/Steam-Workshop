--[[
 - cl_init.lua is the client file for the Special Pot entity.
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
	
	-- If the player is within range, display the UI
	if LocalPlayer():GetPos():Distance(self:GetPos()) < JC_UI_RANGE then

		-- Local fields
		local ang = self:GetAngles();
		local potTime = "Time: "..self:GetNWInt("time").."s";

		-- Set the appropriate roations for UI
		ang:RotateAroundAxis(ang:Up(), 90);
		ang:RotateAroundAxis(ang:Forward(), 90);

		-- Set the appropriate status message
		-- If the Special Pot isn't finished
		if (self:GetNWInt("status") == 0) then

			potTime = "Time: "..self:GetNWInt("time").."s";

		-- If the Special Pot is finished
		elseif (self:GetNWInt("status") == 1) then

			potTime = "Ready! Use to extract!";

		end;

		-- Draw the background & outline
		cam.Start3D2D(pos + ang:Up() * 8, ang, 0.10);

			draw.RoundedBox(0, -69, -43, 138, 106, JC_OUTLINE_COLOR);
			draw.RoundedBox(0, -64, -38, 128, 96, JC_BG_COLOR);

		cam.End3D2D();

		-- Draw the progress text UI
		cam.Start3D2D(pos + ang:Up() * 8, ang, 0.055);

			draw.SimpleText("Jet", "TerminalFont", 0, -56, JC_TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
			draw.SimpleText("______________", "TerminalFont", 0, -54, JC_TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

			draw.RoundedBox(0, -104, -32, 204, 24, JC_OUTLINE_COLOR);			
			draw.RoundedBox(0, -101.5, -30, math.Round((self:GetNWInt("time") * 198) / self:GetNWInt("maxTime")), 20, JC_BG_COLOR);		
			
			draw.SimpleText("Ingredients", "TerminalFont", -101, 8, JC_TEXT_COLOR, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
			draw.SimpleText("______________", "TerminalFont", 0, 10, JC_TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
						
			draw.SimpleText("Amphetamine ("..self:GetNWInt("amphetamine")..")", "TerminalFont", -101, 38, JC_TEXT_COLOR, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
			draw.SimpleText("Fertilizer ("..self:GetNWInt("fertilizer")..")", "TerminalFont", -101, 68, JC_TEXT_COLOR, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);		
		
		cam.End3D2D();			
		
		-- Draw the status text UI
		cam.Start3D2D(pos + ang:Up()*8, ang, 0.035);

			draw.SimpleText(potTime, "TerminalFont", -152, -32, JC_TEXT_COLOR, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);		
		
		cam.End3D2D();		
		
	end;
end;