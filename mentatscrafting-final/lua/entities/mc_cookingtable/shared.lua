--[[
 - shared.lua is the client and server connection file for the Abraxo Cleaner entity.
 - 
 - @author Kyle James
 - @version 23 August 2023
]]

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.PrintName = "Chemistry Station";
ENT.Category = "Mentats Crafting";
ENT.Spawnable = true;

-- Shared Data Between Server & Client
function ENT:SetupDataTables()

    self:NetworkVar("Entity",0,"CookingPot");   -- Stores the Cooking Pot entity
    self:NetworkVar("Entity",1,"Boiler");       -- Stores the Boiler entity
    self:NetworkVar("Entity",2,"HotPlate");     -- Stores the Hot Plate entity
    self:NetworkVar("Entity",3,"Crate");        -- Stores the Crate entity
    self:NetworkVar("Bool",4,"Cooking");        -- Whether or not Mentats are currently cooking
    self:NetworkVar("Float",5,"TimeRemaining"); -- How much time is left cooking

end;