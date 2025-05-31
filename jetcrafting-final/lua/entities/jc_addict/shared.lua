--[[
 - shared.lua is the client and server connection file for the Jet Addict entity.
 - 
 - @author Kyle James
 - @version 24 August 2023
]]

ENT.Base = "base_ai";
ENT.Type = "ai";
ENT.PrintName = "Jet Addict";
ENT.Category	= "Jet Crafting";
ENT.Spawnable = true;
ENT.AutomaticFrameAdvance = true;

-- Functions
--[[SetAutomaticFrameAdvance: Toggles automatic frame advancing for animated sequences on an entity.
		bUsingAnim: Whether or not to set automatic frame advancing.
]]
function ENT:SetAutomaticFrameAdvance(bUsingAnim)

	self.AutomaticFrameAdvance = bUsingAnim;
	
end ;