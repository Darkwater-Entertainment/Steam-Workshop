--[[
 - cl_fc.lua is the client file for the Fallout Consumables addon.
 -
 - @author Kyle James
 - @version 23 February 2025
]]

-- Fonts
surface.CreateFont( "ConsumablesTerminalFont", {
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

-- Local fields
local myConsumables = {}; -- active consumables
local divideEffects = 50; -- consumable HUD sizing
local startstack = (ScrH() / 2); -- consumable HUD sizing
local grad = Material("gui/gradient"); -- gradient material
local dvSwaySpeed = 0.02; -- drunk view sway speed
local dvSmoothHorizontal, dvSmoothVertical = 0,0,0; -- drunk view speed and smoothing
local dvCount = 0; -- drunk view iteration count


-- Functions
--[[DrawConsumablesHUD: Draws the consumables and text.]]
local function DrawConsumablesHUD()

	-- Local fields
	local i = 1;

	-- For each consumable
	for k, v in pairs(myConsumables) do

		-- If it's not in the consumables list, exit
		if !FC_Effects[k] then 

			continue;

		else -- If the entity is in the consumables list, draw it

			-- Update the iteration
			i = i + 1;

			-- Local variables
			local adjustedDivideEffects = i * divideEffects;
			local adjustedYPos = startstack - adjustedDivideEffects;

			-- Draw HUD background
			surface.SetDrawColor(FC_OUTLINE_COLOR);
			surface.DrawRect(0, adjustedYPos + 8, 205, 45);
			surface.SetDrawColor(FC_BG_COLOR);
			surface.DrawRect(2.5, adjustedYPos + 10.5, 200, 40);
			
			-- Draw HUD consumable gradient effect
			surface.SetDrawColor(FC_OUTLINE_COLOR);
			surface.SetMaterial(grad);
			surface.DrawTexturedRect(205, adjustedYPos + 8, 30, 45);
			surface.DrawRect(0, adjustedYPos + 8, 205, 2);
			
			-- Draw HUD consumable text information
			draw.SimpleText(FC_Effects[k].ItemName, "ConsumablesTerminalFont", 5, startstack - (adjustedDivideEffects - 12), FC_TEXT_COLOR, 0, 0);
			draw.SimpleText(math.Round(math.Clamp(v - CurTime(), 1, v - CurTime() + 1)), "ConsumablesTerminalFont", 175, startstack - (adjustedDivideEffects - 12), FC_TEXT_COLOR, 0, 0);
			draw.DrawText(FC_Effects[k].Description, "ConsumablesTerminalFont", 5, startstack - (adjustedDivideEffects - 30), FC_TEXT_COLOR);
		
		end;

	end;

end;

--[[DrawInWorldConsumablesHUD: Draws the consumables in-world HUD.]]
local function DrawInWorldConsumablesHUD()

	-- Get the trace of player's view
	local tr = LocalPlayer():GetEyeTrace();

	-- If it's an invalid entity in the player's view, the consumable has an invalid description, or the player is too far away, do not draw HUD
	if !tr.Entity:IsValid() or !tr.Entity.ConsumableDescription or LocalPlayer():GetPos():Distance( tr.Entity:GetPos() ) > 200 then 
		
		return; 

	else -- If it's valid, draw the HUD

		-- Store a local reference to the entity in view
		local ent = tr.Entity;
	
		-- Store the entity's screen position & text size offset
		local p = ent:GetPos():ToScreen();

		-- Set font before measuring!
		surface.SetFont("ConsumablesTerminalFont")
		local offx, offy = surface.GetTextSize(ent.ConsumableDescription);

		-- Draw the background
		surface.SetDrawColor(FC_OUTLINE_COLOR);
		surface.DrawRect((p.x - 5) - (offx / 2), p.y - 15, offx + 10, offy + 20);
		surface.SetDrawColor(FC_BG_COLOR);
		surface.DrawRect((p.x - 2.5) - (offx / 2), p.y - 12.5, offx + 5, offy + 15);

		-- Draw HUD consumable text information
		draw.SimpleText(ent.PrintName, "ConsumablesTerminalFont", p.x, p.y - 8 , FC_TEXT_COLOR, 1, 1);
		draw.DrawText(ent.ConsumableDescription, "ConsumablesTerminalFont", p.x, p.y, FC_TEXT_COLOR, 1);
	
	end;

end;

--[[RenderConsumableVFX: Renders screen effects for certain consumables.]]
local function RenderConsumableVFX()

	-- For each active consumable
	for k, v in pairs(myConsumables) do
		
		-- If it's not in the buffs list, exit
		if !FC_Effects[k] then 

			continue;

		else -- if it is in the buffs list, render the VFX

			-- Store local reference of the consumable
			local consumable = FC_Effects[k];

			-- If the consumable has a color modifier, draw the color modifier
			if consumable.ColorModify then 

				DrawColorModify(consumable.ColorModify);

			end;
			
			-- If the consumable has a motion blur modifier, draw the motion blur
			if consumable.MotionBlur then 

				DrawMotionBlur(consumable.MotionBlur[1], consumable.MotionBlur[2], consumable.MotionBlur[3]);

			end;

			-- If the drunk effect is active, draw unique motion blue based on time
			if k == "drunk" then

				local drunkMultiplier = (v - CurTime()) / 90;
				DrawMotionBlur((drunkMultiplier / 8), (drunkMultiplier / 2), 0.01);

			end;

		end;

	end;

end;

--[[DrunkView: Renders the drunk view for the player.
		ply: the player
		pos: the player's position
		ang: the player's angle
		fov: the player's field of view
]]
function DrunkView(ply, pos, ang, fov)

	-- If the player is not spectating, do not draw drunk view
	if ply:GetObserverMode() != OBS_MODE_NONE then return end;

	-- If the player is not drunk, do not draw drunk view
	if !myConsumables["drunk"] then 

		return false;

	else -- If the player is drunk, draw drunk view

		-- Calculate the drunk multiplier
		local drunkMultiplier = (myConsumables["drunk"] - CurTime()) / 90;

		-- Rotate the camera angle
		ang:RotateAroundAxis(ang:Right(), dvSmoothHorizontal * drunkMultiplier)
		ang:RotateAroundAxis(ang:Up(), (dvSmoothVertical * 0.5) * drunkMultiplier)
		ang:RotateAroundAxis(ang:Forward(), (dvSmoothVertical * 2) * drunkMultiplier )
	
		-- Establish new view based on drunk rotations
		local view = {};
		view.origin = pos;
		view.angles = ang;
		view.fov = fov + (-dvSmoothVertical * 2) * drunkMultiplier;
	
		-- Return the new view
		return view;

	end;

end;

--[[DrunkViewIterate: Iterate's & updates drunk view sway position.]]
function DrunkViewIterate()

	-- If the player is valid, drunk, and alive, iterate the drunk view.
	if LocalPlayer():IsValid() and myConsumables["drunk"] and LocalPlayer():Alive() then

		local dvSpeedScaler = dvSwaySpeed * 8;
		dvCount = dvCount + (dvSwaySpeed * 11) * dvSpeedScaler;
		dvSmoothHorizontal = -math.abs(math.sin(dvCount) * 1);
		dvSmoothVertical = math.sin(dvCount) * 1.5;

	end;

end;

-- Timers
--[[FC_DVSwayIterate: Iterate through drunk view sway.]]
timer.Create("FC_DVSwayIterate", 0.01, 0, DrunkViewIterate);

-- Hooks
--[[HUDPaint: Paint the HUD for the active consumables.]]
hook.Add("HUDPaint", "FC_DrawMyConsumables", DrawConsumablesHUD);

--[[HUDPaint: Draws the consumables in-world HUD.]]
hook.Add("HUDPaint", "FC_DrawPhysicalConsumablesHUD", DrawInWorldConsumablesHUD)

--[[RenderScreenspaceEffects: Render the consumable VFX.]]
hook.Add("RenderScreenspaceEffects", "FC_RenderConsumableVFX", RenderConsumableVFX);

--[[CalcView: Calculates the drunk view.]]
hook.Add( "CalcView", "FC_DrunkView", DrunkView )

-- Net Messages
--[[UpdateEffects: Receive the UpdateEffects net message and update the list of buffs.]]
net.Receive( "UpdateEffects", function(length)

	myConsumables = net.ReadTable();

end);

--[[UpdateEffects: Receive the SendEffects net message for illegal chem checking.]]
net.Receive( "SendEffects", function(length)

	-- Local fields
	local p = net.ReadEntity();
	local consumables = net.ReadTable();
	local failedChemTest = false;

	-- If the player isn't affected by chems, mark them as clean and exit the function
	if table.ToString(consumables, false) == "{}" then 

		chat.AddText(FC_TEXT_COLOR, p:Nick().." is clean");
		return;

	end

	-- Begin building the chat string
	chat.AddText(FC_TEXT_COLOR, p:Nick().." is under the influence of: ");

	-- Loop through the consumables the player is on
	for k, v in pairs(consumables) do

		-- Store a reference to the buff
		local ref = FC_Effects[k]

		-- If the consumable is illegal, update the chem test
		if ref.Illegal then 

			failedChemTest = true;

		end;

		-- List the consumable in the player's system
		chat.AddText(FC_TEXT_COLOR, k);

	end;

	-- Report the player's results from the chem test
	if failedChemTest then

		chat.AddText(FC_TEXT_COLOR, "WARNING: ILLEGAL CHEMS DETECTED!");

	else

		chat.AddText(FC_TEXT_COLOR, "No illegal chems detected");

	end;

end);