--[[
 - cl_init.lua is the client file for the Chemistry Station entity.
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
		local pos = self:GetPos()
		local ang = self:GetAngles()
		local plateText = "";
		local crateText = "";
		local potText = "";
		local boilerText = "";
		local cookText = "";
		local t;
		local posEquip;
		local posStatus;

		-- Set the appropriate positions for equipment status UI
		t = Vector(-10, -40, -37);
		t:Rotate(self:GetAngles());
		posEquip = pos + t;

		-- Set the appropriate positions for cooking status UI
		t = Vector(-10, 0, -37);
		t:Rotate(self:GetAngles());
		posStatus = pos + t;

		-- Set appropriate rotations for UI
		ang:RotateAroundAxis(self:GetAngles():Forward(), 90);
		ang:RotateAroundAxis(self:GetAngles():Up(), 90);

		-- Set the appropriate text for equipment status UI
		if IsValid(self:GetHotPlate()) then

			plateText = "Ready!";

		else

			plateText = "Need Plate!";

		end;

		if IsValid(self:GetCrate()) then

			crateText = "Ready!";

		else

			crateText = "Need Crate!";

		end;

		if IsValid(self:GetCookingPot()) then

			potText = "Ready!";

		else

			potText = "Need Pot!";

		end;

		if IsValid(self:GetBoiler()) then

			boilerText = "Ready!";

		else

			boilerText = "Need Boiler!";

		end;

		-- Set the appropriate text for cooking status UI
		if self:GetCooking() then

			cookText = "Cooking...";

		else

			if IsValid(self:GetHotPlate()) and IsValid(self:GetCrate()) and IsValid(self:GetCookingPot()) and IsValid(self:GetBoiler()) then
				
				cookText = "Need Additives";

			else

				cookText = "Need Equipment";

			end;

		end;

		-- Draw the equipment status UI
		cam.Start3D2D(posEquip,ang,0.1);

			draw.RoundedBox(0, -105, -705, 240, 260, MC_OUTLINE_COLOR);

			draw.RoundedBox(0, -100, -700, 230, 250, MC_BG_COLOR);

			draw.SimpleText("EQUIPMENT STATUS", "TerminalFont", 15, -675, MC_TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

			draw.SimpleText("Hot Plate: " .. plateText, "TerminalFont", -95, -625, MC_TEXT_COLOR, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);

			draw.SimpleText("Crate: " .. crateText, "TerminalFont", -95, -575, MC_TEXT_COLOR, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);

			draw.SimpleText("Cooking Pot: " .. potText, "TerminalFont", -95, -525, MC_TEXT_COLOR, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);

			draw.SimpleText("Boiler: " .. boilerText, "TerminalFont", -95, -475, MC_TEXT_COLOR, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);

		cam.End3D2D();
		
		-- Draw the cooking status UI
		cam.Start3D2D(posStatus,ang,0.1);

			draw.RoundedBox(0, -105, -705, 240, 190, MC_OUTLINE_COLOR);

			draw.RoundedBox(0, -100, -700, 230, 180, MC_BG_COLOR);

			draw.SimpleText("COOKING STATUS", "TerminalFont", 15, -675, MC_TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

			draw.SimpleText("Status: " .. cookText, "TerminalFont", -95, -625, MC_TEXT_COLOR, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);

			draw.RoundedBox(0, -95, -575, 220, 40, MC_OUTLINE_COLOR);

			if !self:GetCooking() then

				draw.RoundedBox(0, -90, -570, 210, 30, MC_TEXT_COLOR);

			else

				draw.RoundedBox(0, -90, -570, (210 * (self:GetTimeRemaining() / 300)), 30, MC_TEXT_COLOR);
			
			end;

		cam.End3D2D();
		
	end;

end;