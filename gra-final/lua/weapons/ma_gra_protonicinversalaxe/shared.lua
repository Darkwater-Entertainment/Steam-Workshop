SWEP.Base = "dangumeleebase"

SWEP.AdminSpawnable = true

SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.PrintName = "Protonic Inversal Axe"
SWEP.Author = "KyleJames0408"
SWEP.Spawnable = true
SWEP.AutoSwitchFrom = false
SWEP.Weight = 5
SWEP.Category = "Gun Runners' Arsenal"
SWEP.SlotPos = 1
 
SWEP.Purpose = "The protonic inversal axe is a variant of the proton axe, having a dark blue-violet blade, whitish capacitors, and a black handle. Compared to the standard proton axe, it deals increased damage and much more critical damage, in addition to being much more durable."

SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/models/danguyen/c_crovel.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.UseHands = true

--STAT RATING (1-6)
SWEP.Type=2 --1: Blade, 2: Axe, 3:Bludgeon, 4: Spear
SWEP.Strength=4 -- 1-2: Small Weapons, 3-4: Medium Weapons (e.g crowbar), 5-6: Heavy Weapons (e.g Sledgehammers and Greatswords). Strength affects throwing distance and force
SWEP.Speed=3 -- 1-2: Slow, 3-4: Decent, 5-6: Fast
SWEP.Tier=5 -- General rating based on how good/doodoo the weapon is

--SWEPs are dumb (or I am) so we must state the weapon name again
SWEP.WepName="ma_gra_protonicinversalaxe"

--Stamina Costs
SWEP.PriAtkStamina=5
SWEP.ThrowStamina=5
SWEP.BlockStamina=5
SWEP.ShoveStamina=5

--Primary Attack Charge Values
SWEP.Charge = 0
SWEP.ChargeSpeed = 0.25
SWEP.DmgMin = 58
SWEP.DmgMax = 80.6
SWEP.Delay = 0.526
SWEP.TimeToHit = 0.05
SWEP.AttackAnimRate = 0.8
SWEP.Range = 50
SWEP.Punch1 = Angle(-2, 0, 0)
SWEP.Punch2 = Angle(5, 0, -2)
SWEP.HitFX = "bloodsplat"
SWEP.IdleAfter = true
--Throwing Attack Charge Values
SWEP.Charge2 = 0
SWEP.ChargeSpeed2 = 0.35
SWEP.DmgMin2 = 60
SWEP.DmgMax2 = 83.4
SWEP.ThrowModel = "models/halokiller38/fallout/weapons/melee/inversalaxe.mdl"
SWEP.ThrowMaterial = ""
SWEP.ThrowScale = 1
SWEP.ThrowForce = 1200
SWEP.FixedThrowAng = Angle(0,90,0)
SWEP.SpinAng = Vector(1500,0,0)

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
SWEP.ThrowSound="axethrow.mp3"
SWEP.Hit1Sound="ambient/machines/slicer3.wav"
SWEP.Hit2Sound="ambient/machines/slicer2.wav"
SWEP.Hit3Sound="ambient/machines/slicer2.wav"

SWEP.Impact1Sound="physics/metal/metal_solid_impact_hard1.wav"
SWEP.Impact2Sound="physics/metal/metal_solid_impact_hard4.wav"

SWEP.ViewModelBoneMods = {
	["LeftForeArm_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(-3.052, -2.712, 1.355), angle = Angle(0, 0, 0) },
	["LeftHandRing1_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -1.017), angle = Angle(0, 0, 0) },
	["LeftHandThumb1_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(16.27, 0, 0) },
	["LeftHandIndex1_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(-0.339, 0, -1.017), angle = Angle(0, 0, 0) },
	["LeftHandPinky1_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -0.678), angle = Angle(0, 0, 0) },
	["LeftHandThumb3_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-6.103, 0, 0) },
	["RW_Weapon"] = { scale = Vector(0.037, 0.037, 0.037), pos = Vector(0, 1, -1), angle = Angle(0, 0, 0) },
	["LeftHandMiddle1_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -1.017), angle = Angle(0, 0, 0) }
}

SWEP.NextFireShove = 0
SWEP.NextFireBlock = 0
SWEP.NextStun = 0

SWEP.DefSwayScale 	= 1.0
SWEP.DefBobScale 	= 1.0
SWEP.StunPos = Vector(0,0,0)
SWEP.StunAng = Vector(-27.754, 2.467, 20.351)

SWEP.ShovePos = Vector(-5.64, -3.524, 0)
SWEP.ShoveAng = Vector(28.37, 62.907, -38.238)

SWEP.RollPos = Vector(0,0,0)
SWEP.RollAng = Vector(-33.065, 0, 0)

SWEP.ThrowPos = Vector(0, -10, -10)
SWEP.ThrowAng = Vector(45, 0, 0)

SWEP.WhipPos = Vector(0, 0, 0)
SWEP.WhipAng = Vector(16.18, -26.734, -14.775)

SWEP.FanPos = Vector(5.025, -8.242, -3.418)
SWEP.FanAng = Vector(45.025, 21.809, 40.804)

SWEP.WallPos = Vector(-0.601, -11.056, -9.65)
SWEP.WallAng = Vector(42.915, 0, 0)

function SWEP:AttackAnimation()
	self.Weapon.AttackAnimRate = 1.9
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
end
left=false
right=true
function SWEP:AttackAnimation2()
	self.Weapon.AttackAnimRate = 1.8
	if right==true then  
		self.Punch1 = Angle(0, -15, 0)
		self.Weapon:SendWeaponAnim( ACT_VM_HITRIGHT )
		right=false
		left=true
	elseif left==true then
		self.Punch1 = Angle(5, 10, 0)
		self.Weapon:SendWeaponAnim( ACT_VM_HITLEFT )
		left=false
		right=true
	end
end
function SWEP:AttackAnimation3()
self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
end

SWEP.VElements = {
	["shovel"] = { type = "Model", model = "models/halokiller38/fallout/weapons/melee/inversalaxe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 0, 25), angle = Angle(-2.395, 87.315, 177.274), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["shovel"] = { type = "Model", model = "models/halokiller38/fallout/weapons/melee/inversalaxe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.75, 0.552, 23.834), angle = Angle(0, 80.23, 167.654), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}