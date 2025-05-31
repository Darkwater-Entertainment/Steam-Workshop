--[[
  drink_nukacola.lua
  File for the Nuka Cola entity.
  @author Kyle James
  @version 31 May 2025
]]

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "fc_ent"
ENT.PrintName = "Nuka-Cola"
ENT.Category = "Fallout Consumables"
ENT.Spawnable = true


-- Consumable Configuration
ENT.ConsumableModel = "models/mosi/fnv/props/drink/nukacola.mdl"
ENT.ConsumableModelColor = Color(255, 255, 255)
ENT.ConsumableSound = "fc_fx/nukacola.mp3"
ENT.ConsumableEffect = "nukaCola"
ENT.ConsumableTime = 25
ENT.ConsumableDescription = [[The most popular soft drink of the pre and post-war world.
A distinct blend of 17 different fruit essences to enhance the classic cola flavor.]]

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