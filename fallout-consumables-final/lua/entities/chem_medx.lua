--[[
  chem_medx.lua
  File for the Med-X entity.
  @author Kyle James
  @version 31 May 2025
]]

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "fc_ent"
ENT.PrintName = "Med-X"
ENT.Category = "Fallout Consumables"
ENT.Spawnable = true

-- Consumable Configuration
ENT.ConsumableModel = "models/mosi/fallout4/props/aid/medx.mdl"
ENT.ConsumableModelColor = Color(255, 255, 255)
ENT.ConsumableSound = "fc_fx/stimpak.mp3"
ENT.ConsumableEffect = "medX"
ENT.ConsumableTime = 240
ENT.ConsumableDescription = [[A highly potent painkiller.]]

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
		if activator:HasConsumableEffect("medx") then
			local remaining = activator.Effects["medx"] - CurTime()
			if remaining > (self.ConsumableTime - rand) then
				activator:AddConsumableEffect("overdose", 10)
			end
			activator:AddConsumableEffect("medx", 240)
		end

		activator:AddConsumableEffect(self.ConsumableEffect, self.ConsumableTime)
		activator:EmitSound(self.ConsumableSound, 75, 100)
		self:Remove()
	end

end