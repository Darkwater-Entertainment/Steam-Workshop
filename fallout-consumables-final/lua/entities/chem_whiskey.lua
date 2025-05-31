--[[
  chem_whiskey.lua
  File for the Whiskey entity.
  @author Kyle James
  @version 31 May 2025
]]

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "fc_ent"

ENT.PrintName = "Whiskey"

ENT.Category = "Fallout Consumables"

ENT.Spawnable = true

-- Consumable Configuration
ENT.ConsumableModel = "models/mosi/fnv/props/drink/alcohol/whiskey01.mdl"
ENT.ConsumableModelColor = Color(255,255,255)
ENT.ConsumableSound = "fc_fx/nukacola.mp3"
ENT.ConsumableEffect = "whiskey"
ENT.ConsumableTime = 240
ENT.ConsumableDescription = [[Whiskey is a type of distilled alcoholic
beverage made from fermented grain mash.]]

-- Server-Side Logic
if SERVER then

function ENT:Initialize()
	self:SetModel( self.ConsumableModel )
 	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
 	self:SetColor( self.ConsumableModelColor )
	self:SetUseType( SIMPLE_USE )
	
	local PhysAwake = self:GetPhysicsObject()
	if ( PhysAwake:IsValid() ) then
		PhysAwake:Wake()
	end 
end

function ENT:Use(activator, caller)
		if not IsValid(activator) or not activator:IsPlayer() then return end
		if activator:HasConsumableEffect("overdose") then return end

		local rand = math.random(30, 60)

		-- Alcohol mixed with chems
		if activator:HasConsumableEffect("buffout") or activator:HasConsumableEffect("jet") or activator:HasConsumableEffect("psycho") then
			activator:AddConsumableEffect("overdose", 10)
		end

		-- Alcohol stacked with alcohol
		if activator:HasConsumableEffect("drunk") then
			local remaining = activator.Effects["drunk"] - CurTime()
			if remaining > (self.ConsumableTime - rand) then
				activator:AddConsumableEffect("overdose", 10)
			end
			activator:AddConsumableEffect("drunk", 240)
		end

		if activator:HasConsumableEffect("beer") then
			local remaining = activator.Effects["beer"] - CurTime()
			if remaining > (self.ConsumableTime - rand) then
				activator:AddConsumableEffect("drunk", 240)
			end
		end

		if activator:HasConsumableEffect("whiskey") then
			local remaining = activator.Effects["whiskey"] - CurTime()
			if remaining > (self.ConsumableTime - rand) then
				activator:AddConsumableEffect("drunk", 240)
			end
		end

		activator:AddConsumableEffect(self.ConsumableEffect, self.ConsumableTime)
		activator:EmitSound(self.ConsumableSound, 75, 100)
		self:Remove()
	end

end