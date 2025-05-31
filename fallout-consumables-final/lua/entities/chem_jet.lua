--[[
  chem_jet.lua
  File for the Jet entity.
  @author Kyle James
  @version 31 May 2025
]]

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "fc_ent"
ENT.PrintName = "Jet"
ENT.Category = "Fallout Consumables"
ENT.Spawnable = true

-- Consumable Configuration
ENT.ConsumableModel = "models/mosi/fnv/props/health/chems/jet.mdl"
ENT.ConsumableModelColor = Color(255, 255, 255)
ENT.ConsumableSound = "fc_fx/jet.mp3"
ENT.ConsumableEffect = "jet"
ENT.ConsumableTime = 240
ENT.ConsumableDescription = [[Jet or metamphetamine is a highly addictive meta-amphetamine
commonly found throughout the wasteland.]]

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
		if activator:HasConsumableEffect("jet") then
			local remaining = activator.Effects["jet"] - CurTime()
			if remaining > (self.ConsumableTime - rand) then
				activator:AddConsumableEffect("overdose", 10)
			end
			activator:AddConsumableEffect("jet", 240)
		end

		activator:AddConsumableEffect(self.ConsumableEffect, self.ConsumableTime)
		activator:EmitSound(self.ConsumableSound, 75, 100)
		self:Remove()
	end

end