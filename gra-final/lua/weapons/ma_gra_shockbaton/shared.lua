SWEP.Base = "dangumeleebase"

SWEP.AdminSpawnable = true

SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.PrintName = "Shock Baton"
SWEP.Author = "KyleJames0408"
SWEP.Spawnable = true
SWEP.AutoSwitchFrom = false
SWEP.Weight = 5
SWEP.Category = "Gun Runners' Arsenal"
SWEP.SlotPos = 1
 
SWEP.Purpose = "The shock baton is a short, fast swinging, blunt weapon with a shock damage bonus."

SWEP.ViewModelFOV = 90
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/models/danguyen/c_zweihander.mdl"
SWEP.WorldModel = "models/props_canal/mattpipe.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.UseHands = true

--STAT RATING (1-6)
SWEP.Type=3 --1: Blade, 2: Axe, 3:Bludgeon, 4: Spear
SWEP.Strength=3 -- 1-2: Small Weapons, 3-4: Medium Weapons (e.g crowbar), 5-6: Heavy Weapons (e.g Sledgehammers and Greatswords). Strength affects throwing distance and force
SWEP.Speed=4 -- 1-2: Slow, 3-4: Decent, 5-6: Fast
SWEP.Tier=3 -- General rating based on how good/doodoo the weapon is

--SWEPs are dumb (or I am) so we must state the weapon name again
SWEP.WepName="ma_gra_shockbaton"

--Stamina Costs
SWEP.PriAtkStamina=5
SWEP.ThrowStamina=5
SWEP.BlockStamina=5
SWEP.ShoveStamina=5

--Primary Attack Charge Values
SWEP.Charge = 0
SWEP.ChargeSpeed = 0.25
SWEP.DmgMin = 30
SWEP.DmgMax = 65.5
SWEP.Delay = 0.435
SWEP.TimeToHit = 0.02
SWEP.AttackAnimRate = 1
SWEP.Range = 65
SWEP.Punch1 = Angle(-2, 0, 0)
SWEP.Punch2 = Angle(5, 0, -2)
SWEP.HitFX = "bloodsplat"
SWEP.IdleAfter = true
--Throwing Attack Charge Values
SWEP.CanThrow = false
SWEP.Charge2 = 0
SWEP.ChargeSpeed2 = 0.2
SWEP.DmgMin2 = 3
SWEP.DmgMax2 = 12
SWEP.ThrowModel = "models/halokiller38/fallout/weapons/melee/shockbaton.mdl"
SWEP.ThrowMaterial = ""
SWEP.ThrowScale = 1
SWEP.ThrowForce = 1200

--HOLDTYPES
SWEP.AttackHoldType="grenade"
SWEP.Attack2HoldType="melee2"
SWEP.ChargeHoldType="melee"
SWEP.IdleHoldType="melee2"
SWEP.BlockHoldType="slam"
SWEP.ShoveHoldType="fist"
SWEP.ThrowHoldType="grenade"

--SOUNDS
SWEP.SwingSound="weapons/stunstick/stunstick_swing1.wav"
SWEP.ThrowSound="knifethrow.mp3"
SWEP.Hit1Sound="weapons/stunstick/stunstick_fleshhit1.wav"
SWEP.Hit2Sound="weapons/stunstick/stunstick_fleshhit2.wav"
SWEP.Hit3Sound="weapons/stunstick/stunstick_fleshhit1.wav"

SWEP.Impact1Sound="weapons/stunstick/stunstick_impact1.wav"
SWEP.Impact2Sound="weapons/stunstick/stunstick_impact2.wav"

SWEP.ViewModelBoneMods = {
	["TrueRoot"] = { scale = Vector(1, 1, 1), pos = Vector(-2.037, 0, -4.259), angle = Angle(-12.223, 0, 0) },
	["LeftArm_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0, -1.668, 2.407), angle = Angle(0, 0, 0) },
	["RW_Weapon"] = { scale = Vector(0.01, 0.01, 0.01), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Root"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-7.778, 0, 0) }
}

SWEP.NextFireShove = 0
SWEP.NextFireBlock = 0
SWEP.NextStun = 0

SWEP.DefSwayScale 	= 1.0
SWEP.DefBobScale 	= 1.0

SWEP.StunPos = Vector(0,0,0)
SWEP.StunAng = Vector(-14.775, 0, 43.618)

SWEP.ShovePos = Vector(-6.633, 0.804, 6.03)
SWEP.ShoveAng = Vector(0, 47.136, -49.246)

SWEP.RollPos = Vector(0,0,0)
SWEP.RollAng = Vector(-33.065, 0, 0)

SWEP.ThrowPos = Vector(-4.824, -7.437, 5.627)
SWEP.ThrowAng = Vector(100, 30.954, 9.848)

SWEP.WhipPos = Vector(0, -8.643, 3.417)
SWEP.WhipAng = Vector(56.985, -0.704, 2.813)

SWEP.FanPos = Vector(-1.611, -9.849, -2.411)
SWEP.FanAng = Vector(54.874, 0, 70)

SWEP.WallPos = Vector(-0.601, -11.056, -9.65)
SWEP.WallAng = Vector(42.915, 0, 0)

function SWEP:AttackAnimation()
	self.Punch1 = Angle(5, 10, 0)
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
end
function SWEP:AttackAnimation2()
	self.Punch1 = Angle(0, -15, 0)
	self.Weapon:SendWeaponAnim( ACT_VM_HITRIGHT )
end
function SWEP:AttackAnimation3()
self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
end


SWEP.VElements = {
	["stam"] = { type = "Model", model = "models/halokiller38/fallout/weapons/melee/shockbaton.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1, 9.5), angle = Angle(-2.21, 87.315, 177.376), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["knife"] = { type = "Model", model = "models/halokiller38/fallout/weapons/melee/shockbaton.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1, 2, 9.5), angle = Angle(0, 90, 167.442), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}