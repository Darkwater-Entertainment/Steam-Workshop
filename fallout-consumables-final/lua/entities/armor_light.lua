--[[
  armor_light.lua
  File for the Leather Armor entity.
  @author Kyle James
  @version 31 May 2025
]]

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "fc_ent"
ENT.PrintName = "Leather Armor Reinforced"
ENT.Category = "Fallout Armor"
ENT.Spawnable = true

-- Consumable Configuration
ENT.ConsumableModel = "models/props_c17/SuitCase001a.mdl"
ENT.ConsumableModelColor = Color(255,255,255)
ENT.ConsumableDescription = "Reinforced Leather Armor."

-- Server-Side Logic
if SERVER then

	function ENT:Initialize()
		self:SetModel(self.ConsumableModel)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetColor(self.ConsumableModelColor)
		self:SetUseType(SIMPLE_USE)

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end

	function ENT:Use(activator, caller)
		--activator:SetModel("models/kaesar/falloutnewvegas/combatarmor/combatarmor.mdl") -- playing around with setting PM
		activator:SetArmor(30)
		self:Remove()
	end
end