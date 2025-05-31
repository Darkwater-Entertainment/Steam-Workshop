--[[
 - cl_init.lua is the client file for the consumable abstract entity.
 - 
 - @author Kyle James
 - @version 09 March 2025
]]

-- Inclusions
include("shared.lua");

-- Functions
--[[Draw: Draws the entity model.]]
function ENT:Draw()

    self.Entity:DrawModel();

end;