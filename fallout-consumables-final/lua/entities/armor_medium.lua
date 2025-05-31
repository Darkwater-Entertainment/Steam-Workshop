--[[
  armor_medium.lua
  File for the Combat Armor, Reinforced Mk 2 entity.
  @author Kyle James
  @version 31 May 2025
]]

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "fc_ent"
ENT.PrintName = "Combat Armor, Reinforced Mk 2"
ENT.Category = "Fallout Armor"
ENT.Spawnable = true

-- Consumable Configuration
ENT.ConsumableModel = "models/props_c17/SuitCase001a.mdl"
ENT.ConsumableModelColor = Color(255,255,255)
ENT.ConsumableDescription = "Reinforced Combat Armor, mk 2."

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
		activator:SetArmor(70)
		self:Remove()
	end
end