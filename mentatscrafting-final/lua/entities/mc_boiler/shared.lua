--[[
 - shared.lua is the client and server connection file for the Boiler entity.
 - 
 - @author Kyle James
 - @version 23 August 2023
]]

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.PrintName = "Boiler";
ENT.Category = "Mentats Crafting";
ENT.Spawnable = true;

-- Shared Data Between Server & Client
function ENT:SetupDataTables()

	self:NetworkVar("Bool", 0, "Full"); -- Whether or not the Boiler is holding Brain Fungus

end;