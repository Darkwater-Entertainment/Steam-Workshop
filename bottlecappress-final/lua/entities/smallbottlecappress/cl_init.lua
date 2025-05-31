--[[
 - cl_init.lua is the client file for the Small Bottlecap Press entity.
 - 
 - @author Kyle James
 - @version 22 August 2023
]]

-- Inclusions
include("shared.lua");

-- Fonts
surface.CreateFont( "MoneyFont", {
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
--[[Draw: Draws the entity model and the associated UI.]]
function ENT:Draw()

	-- Draw the model
	self:DrawModel();

	-- If the player is within range, display the UI
	if LocalPlayer():GetPos():Distance(self:GetPos()) < BP_UI_RANGE then

		-- Local fields
		local ang = self:GetAngles();
		local owner = self:Getowning_ent();

		-- Set appropriate rotations for UI
		ang:RotateAroundAxis(self:GetAngles():Right(), 270);
		ang:RotateAroundAxis(self:GetAngles():Forward(), 90);

		-- Get the owner of the entity if it's DarkRP
		if gmod.GetGamemode().Name == "DarkRP" then

			owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown");

		else

			owner = "unknown";

		end;

		-- Draw the UI
		cam.Start3D2D(self:GetPos(), ang, 0.1);

			draw.RoundedBox(0, -105, -705, 210, 210, BP_OUTLINE_COLOR);

			draw.RoundedBox(0, -100, -700, 200, 200, BP_BG_COLOR);

			draw.SimpleText("Bottle Cap Press v1", "MoneyFont", 0, -675, BP_TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

			draw.SimpleText("Owner:", "MoneyFont", 0, -625, BP_TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

			draw.SimpleText(owner, "MoneyFont", 0, -600, BP_TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

			draw.SimpleText("Caps: ¢" .. self:GetMoneyAmount(), "MoneyFont", 0, -550, BP_TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

		cam.End3D2D();

	end;

end;