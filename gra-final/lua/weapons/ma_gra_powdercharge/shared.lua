SWEP.Base = "dangumeleenadebase"

SWEP.AdminSpawnable = true

SWEP.AutoSwitchTo = false
SWEP.Slot = 4
SWEP.PrintName = "Powder Charge"
SWEP.Author = "KyleJames0408"
SWEP.Spawnable = true
SWEP.AutoSwitchFrom = false
SWEP.Weight = 5
SWEP.DrawCrosshair = false

SWEP.Category = "Gun Runners' Arsenal"
SWEP.SlotPos = 1
 
SWEP.Purpose = "The powder charge is a crude improvised explosive consisting of a sealed tin can packed with dynamite, with a sensor module duct-taped to the side."
SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/cstrike/c_eq_flashbang.mdl"
SWEP.WorldModel = "models/weapons/w_eq_smokegrenade.mdl"

SWEP.UseHands = true
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

--STAT RATING (1-6)
SWEP.Type=2
SWEP.Strength=3 -- 1-2: Small Weapons, 3-4: Medium Weapons (e.g crowbar), 5-6: Heavy Weapons (e.g Sledgehammers and Greatswords). Strength affects throwing distance and force
SWEP.Tier=4 -- General rating based on how good/doodoo the weapon is

--SWEPs are dumb (or I am) so we must state the weapon name again
SWEP.WepName="ma_gra_powdercharge"

--Primary Attack Charge Values
SWEP.OwnerOwnsProjectile = true
SWEP.Explanation = "An explosive that detonates when anyone draws near, dealing heavy damage and having a chance to disarm."
SWEP.EntName = "magrapowdercharge"
SWEP.Velocity = 1500
SWEP.PullPinAni = false
SWEP.ThrowAni = ACT_VM_THROW
SWEP.DeployAni = ACT_VM_DRAW
SWEP.ThrowTime = 0.4
SWEP.Delay = 1
--Throwing Attack Charge Values
SWEP.CanThrow = true
SWEP.ThrowModel = "models/halokiller38/fallout/weapons/mines/powderchargemine.mdl"
SWEP.ThrowMaterial = ""
SWEP.ThrowScale = 1
SWEP.FixedThrowAng = Angle(0,0,0)
SWEP.SpinAng = Vector(0,1500,0)

--HOLDTYPES
SWEP.IdleHoldType="grenade"

--SOUNDS
SWEP.SwingSound="WeaponFrag.Throw"
SWEP.ThrowSound="weapons/iceaxe/iceaxe_swing1.wav"
SWEP.Hit1Sound="ambient/machines/slicer3.wav"
SWEP.Hit2Sound="ambient/machines/slicer3.wav"
SWEP.Hit3Sound="ambient/machines/slicer2.wav"

SWEP.Impact1Sound="physics/plastic/plastic_box_impact_hard1.wav"
SWEP.Impact2Sound="physics/plastic/plastic_box_impact_hard2.wav"

SWEP.ViewModelBoneMods = {
	["v_weapon.Flashbang_Parent"] = { scale = Vector(0.056, 0.056, 0.056), pos = Vector(0, 0, -1.297), angle = Angle(0, 0, 0) }
}


SWEP.NextFireShove = 0
SWEP.NextFireBlock = 0
SWEP.NextStun = 0

SWEP.DefSwayScale 	= 1.0
SWEP.DefBobScale 	= 1.0

SWEP.StunPos = Vector(-3.921, 0, 3.72)
SWEP.StunAng = Vector(-18.292, -0.704, -31.659)

SWEP.ShovePos = Vector(-9.851, -4.222, -3.62)
SWEP.ShoveAng = Vector(9.848, 59.095, -54.172)

SWEP.RollPos = Vector(0,0,0)
SWEP.RollAng = Vector(0, 0, 0)

SWEP.WhipPos = Vector(-0.19, -28, -1.92)
SWEP.WhipAng = Vector(61.206, 14.069, 7.034)

SWEP.ThrowPos = Vector(-0.19, -28, -1.92)
SWEP.ThrowAng = Vector(61.206, 14.069, 7.034)

SWEP.FanPos = Vector(-20, -8.443, 8.239)
SWEP.FanAng = Vector(16.884, 0, -70)

SWEP.WallPos = Vector(-0.601, -11.056, -9.65)
SWEP.WallAng = Vector(0, 0, 0)

SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = SWEP.ShieldHealth
SWEP.Primary.DefaultClip = SWEP.ShieldHealth
SWEP.Primary.Spread = 0
SWEP.Primary.NumberofShots = 0

local rndr = render
local mth = math
local srface = surface
local inpat = input

SWEP.VElements = {
	["Smokebomb"] = { type = "Model", model = "models/halokiller38/fallout/weapons/mines/powderchargemine.mdl", bone = "v_weapon.Flashbang_Parent", rel = "", pos = Vector(1.5, 0, -2), angle = Angle(190, 0, 180), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["Smokebomb"] = { type = "Model", model = "models/halokiller38/fallout/weapons/mines/powderchargemine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.5, -1, -1), angle = Angle(0, -45, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}