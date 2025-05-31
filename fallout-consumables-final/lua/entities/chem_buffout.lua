--[[
  chem_buffout.lua
  File for the Buffout entity.
  @author Kyle James
  @version 31 May 2025
]]

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "fc_ent"
ENT.PrintName = "Buffout"
ENT.Category = "Fallout Consumables"
ENT.Spawnable = true

-- Consumable Configuration
ENT.ConsumableModel = "models/mosi/fnv/props/health/chems/buffout.mdl"
ENT.ConsumableModelColor = Color(255, 255, 255)
ENT.ConsumableSound = "fc_fx/mentats.mp3"
ENT.ConsumableEffect = "buffout"
ENT.ConsumableTime = 240
ENT.ConsumableDescription = [[Buffout is a highly advanced steroid that was popularized before the Great War
by professional athletes and their clandestine use of the chem.]]

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

		local rand = math.random(5, 120)

		-- Chems mixed with alcohol
		if activator:HasConsumableEffect("beer") or activator:HasConsumableEffect("whiskey") then
			activator:AddConsumableEffect("overdose", 10)
		end

		-- Chems stacked with chems
		if activator:HasConsumableEffect("buffout") then
			local remaining = activator.Effects["buffout"] - CurTime()
			if remaining > (self.ConsumableTime - rand) then
				activator:AddConsumableEffect("overdose", 10)
			end
			activator:AddConsumableEffect("buffout", 240)
		end

		activator:AddConsumableEffect(self.ConsumableEffect, self.ConsumableTime)
		activator:EmitSound(self.ConsumableSound, 75, 100)
		self:Remove()
	end

end