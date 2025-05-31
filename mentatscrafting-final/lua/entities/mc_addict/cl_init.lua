--[[
 - cl_init.lua is the client file for the Mentats Addict entity.
 - 
 - @author Kyle James
 - @version 23 August 2023
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
	if LocalPlayer():GetPos():Distance(self:GetPos()) < MC_UI_RANGE then

		-- Local fields
		local pos = self:GetPos()
		local ang = self:GetAngles()

		-- Set appropriate rotations for UI
		ang:RotateAroundAxis(self:GetAngles():Forward(), 90);
		ang:RotateAroundAxis(self:GetAngles():Up(), 90);

		-- Rotate the UI to always face the player
		ang.y = LocalPlayer():EyeAngles().y - 90;
		
		-- Draw the UI
		cam.Start3D2D(pos,ang,0.1);

			draw.RoundedBox(0, -230, -805, 460, 60, MC_OUTLINE_COLOR);

			draw.RoundedBox(0, -225, -800, 450, 50, MC_BG_COLOR);

			draw.SimpleText("MENTATS ADDICT", "BuyerFont", 0, -775, MC_TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		cam.End3D2D();
		
	end;

end;

--[[DrawTranslucent: Called when the entity should be drawn translucently.]]
function ENT:DrawTranslucent()

	self:Draw();

end;

-- Receives the mentatspaynotify from the server upon interaction with the Mentats Addict.
net.Receive("mentatspaynotify", function(len, ply)

	-- Local fields
	local mentats = net.ReadInt(32); -- Stores incoming data for # of Mentats the player has
	local w = Color(255, 255, 255);	 -- The color white

	-- Inform the player how much money they received based on the number of Mentats they had
	if mentats == 0 then

		chat.AddText(w, "You don't have any mentats to turn in!");

	elseif mentats == 1 then

		chat.AddText(w, "You turned in ", MC_TEXT_COLOR, tostring(mentats), " container ", w, "of mentats and got ",  MC_TEXT_COLOR, "$", tostring(mentats * MC_PAYOUT), w, ".");

	else

		chat.AddText(w, "You turned in ", MC_TEXT_COLOR, tostring(mentats), " containers ", w, "of mentats and got ",  MC_TEXT_COLOR, "$", tostring(mentats * MC_PAYOUT), w, ".");

	end;

end);