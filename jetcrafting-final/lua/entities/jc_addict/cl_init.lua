--[[
 - cl_init.lua is the client file for the Jet Addict entity.
 - 
 - @author Kyle James
 - @version 24 August 2023
]]

-- Inclusions
include("shared.lua");

-- Constants
ENT.RenderGroup = RENDERGROUP_BOTH; -- For both translucent/transparent and opaque/solid anim entities

-- Fonts
surface.CreateFont( "BuyerFont", {
	font = "monofonto",
	size = 69,
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
--[[Draw: Draws the model.]]
function ENT:Draw()

	-- Draw the model
	self:DrawModel();

	-- If the player is within range, display the UI
	if LocalPlayer():GetPos():Distance(self:GetPos()) < JC_UI_RANGE then

		-- Local fields
		local pos = self:GetPos();
		local ang = self:GetAngles();

		-- Set appropriate rotations for UI
		ang:RotateAroundAxis(self:GetAngles():Forward(), 90);
		ang:RotateAroundAxis(self:GetAngles():Up(), 90);
		
		-- Rotate the UI to always face the player
		ang.y = LocalPlayer():EyeAngles().y - 90;

		-- Draw the UI
		cam.Start3D2D(pos,ang,0.1);

			draw.RoundedBox(0, -230, -805, 460, 60, JC_OUTLINE_COLOR);

			draw.RoundedBox(0, -225, -800, 450, 50, JC_BG_COLOR);

			draw.SimpleText("JET ADDICT", "BuyerFont", 0, -775, JC_TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

		cam.End3D2D();

	end;

end;

--[[DrawTranslucent: Called when the entity should be drawn translucently.]]
function ENT:DrawTranslucent()

	self:Draw();

end;