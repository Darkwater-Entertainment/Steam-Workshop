--[[
 - shared.lua is the client and server connection file for the Big Bottlecap Press entity.
 - 
 - @author Kyle James
 - @version 22 August 2023
]]

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.PrintName = "Bottle Cap Press v3 (Big)";
ENT.Category = "Bottle Cap Presses";
ENT.Spawnable = true;

-- Shared Data Between Server & Client
function ENT:SetupDataTables()

	self:NetworkVar("Int",1,"MoneyAmount");		-- The amount of money the Big Bottlecap Press is holding
	self:NetworkVar("Entity", 0, "owning_ent"); -- The player who owns the Big Bottlecap Press

end;