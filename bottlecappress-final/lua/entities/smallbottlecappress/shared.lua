--[[
 - shared.lua is the client and server connection file for the Small Bottlecap Press entity.
 - 
 - @author Kyle James
 - @version 22 August 2023
]]

-- Entity Information
ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.PrintName = "Bottle Cap Press v1 (Small)";
ENT.Category = "Bottle Cap Presses";
ENT.Spawnable = true;

-- Shared Data Between Server & Client
function ENT:SetupDataTables()

	self:NetworkVar("Int",1,"MoneyAmount");		-- The amount of money the Small Bottlecap Press is holding
	self:NetworkVar("Entity", 0, "owning_ent");	-- The player who owns the Small Bottlecap Press

end;