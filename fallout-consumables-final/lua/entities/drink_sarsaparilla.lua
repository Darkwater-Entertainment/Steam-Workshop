--[[
  drink_sarsaparilla.lua
  File for the Sunset Sarsaparilla entity.
  @author Kyle James
  @version 31 May 2025
]]

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "fc_ent"
ENT.PrintName = "Sunset Sarsaparilla"
ENT.Category = "Fallout Consumables"
ENT.Spawnable = true


-- Consumable Configuration
ENT.ConsumableModel = "models/mosi/fnv/props/drink/sunsetsasparilla.mdl"
ENT.ConsumableModelColor = Color(255, 255, 255)
ENT.ConsumableSound = "fc_fx/nukacola.mp3"
ENT.ConsumableEffect = "ssSarsaparilla"
ENT.ConsumableTime = 25
ENT.ConsumableDescription = [[A classic sarsaparilla flavored soft drink.
A staple of the Mojave.]]

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
		if not IsValid(activator) or not activator:IsPlayer() then return end
		if activator:HasConsumableEffect("overdose") then return end

		activator:AddConsumableEffect(self.ConsumableEffect, self.ConsumableTime)
		activator:EmitSound(self.ConsumableSound, 75, 100)
		self:Remove()
	end

end