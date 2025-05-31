--[[
  chem_fixer.lua
  File for the Fixer entity.
  @author Kyle James
  @version 31 May 2025
]]

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "fc_ent"
ENT.PrintName = "Fixer"
ENT.Category = "Fallout Consumables"
ENT.Spawnable = true

-- Consumable Configuration
ENT.ConsumableModel = "models/mosi/fnv/props/health/chems/fixer.mdl"
ENT.ConsumableModelColor = Color(255,255,255)
ENT.ConsumableSound = "fc_fx/chems_wearoff.mp3"
ENT.ConsumableDescription = [[A Pre-War Chem that flushes all foreign substances and chems from your blood and helps you fight addictions.]]

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

	function ENT:Use( activator, caller )
		activator:ClearConsumableEffects()
		activator:EmitSound(self.ConsumableSound, 75, 100)
		self:Remove()
	end
end