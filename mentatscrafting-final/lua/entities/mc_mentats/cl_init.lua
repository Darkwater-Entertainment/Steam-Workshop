--[[
 - cl_init.lua is the client file for the Mentats entity.
 - 
 - @author Kyle James
 - @version 23 August 2023
]]

-- Inclusions
include("shared.lua")

-- Functions
--[[Draw: Draws the model.]]
function ENT:Draw()

	self:DrawModel();

end

-- Receives the mentatsnotify from the server upon interaction with the Mentats.
net.Receive("mentatsnotify", function(len, ply)
	-- Local fields
	local mentats = net.ReadInt(32); -- The number of Mentats picked up
	local w = Color(255, 255, 255);	 -- The color white

	chat.AddText( w, "Picked up a container of mentats.  You are now carrying ", MC_TEXT_COLOR, tostring(mentats), " container(s) ", w, "of mentats" )
end)