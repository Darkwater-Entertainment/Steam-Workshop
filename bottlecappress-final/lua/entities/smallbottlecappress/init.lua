--[[
 - init.lua is the server file for the Small Bottlecap Press entity.
 - 
 - @author Kyle James
 - @version 22 August 2023
]]

-- Inclusions
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

-- Functions
--[[SpawnFunction: Defines how the entity spawns from the spawnmenu.
		ply: The player
		tr: A table for the player's eye trace
]]
function ENT:SpawnFunction(ply, tr)

    -- Local fields
    local pos = tr.HitPos + tr.HitNormal * 5;   -- Spawn position
    local e = ents.Create(self.ClassName);      -- Stores the created entity

    -- Sets up the entity position, spawns it, and activates it
    e:SetPos(pos);
    e:Spawn();
    e:Activate();

    -- Returns the entity
    return e;

end;

--[[Initialize: Initializes the entity.]]
function ENT:Initialize()

    -- Local fields
    local phys = self:GetPhysicsObject(); -- The physics object

    -- Initialize the model
    self:SetModel("models/custom_prop/fnv_props/bottlecap/bottlecap.mdl");

    -- Initialize the physics
    self:PhysicsInit(SOLID_VPHYSICS);
    self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);

    -- If the physics are functioning
	if phys:IsValid() then

        -- Wake the object
		phys:Wake();

	end;

    -- Setup the timer
	self.timer = CurTime();

    -- Start playing the sound
	self:StartSound();

end;

--[[Think: What the entity does each tick.]]
function ENT:Think()

    -- If the time is greater than the interval
	if CurTime() > self.timer + SMALLBP_INTERVAL then

        -- Reset the time
		self.timer = CurTime();

        -- If the number of stored caps is fewer than the maximum
        if self:GetMoneyAmount() < SMALLBP_MAX or SMALLBP_MAX <= 0 then

            -- Increment the caps stored
            self:SetMoneyAmount(self:GetMoneyAmount() + SMALLBP_INCREMENT);

        end;

    end;

    -- Play the sound
    self:StartSound();

end;

--[[StartSound: Starts the entity's sound.]]
function ENT:StartSound()

    -- Create the sound, set the volume, and plays the sound
    self.sound = CreateSound(self, Sound("generic/machine.wav"));
    self.sound:SetSoundLevel(52);
    self.sound:PlayEx(1, 100);

end;

--[[Use: What happens when the player uses the entity.
        act: The entity that caused this input. This will usually be the player who pressed their use key
]]
function ENT:Use(act)

    -- Local fields
    local money = self:GetMoneyAmount(); -- Get the stored caps

    -- Reset the stored caps
    self:SetMoneyAmount(0);

    -- Add money to the player's wallet if it's DarkRP
    if gmod.GetGamemode().Name == "DarkRP" then

        act:addMoney(money);

        -- If the actor exists
		if IsValid(act) and money > 0 then

			-- Notify the collector how many caps they collected
			DarkRP.notify(act, NOTIFY_GENERIC, 4, "You collected " .. money .. " caps from the Bottlecap Press v1.");
	
		end;

    end;

end;

--[[OnTakeDamage: What happens when the entity takes damage.
        dmg: The damage to be applied to the entity
]]
function ENT:OnTakeDamage(dmg)

    -- If destructible
    if SMALLBP_HEALTH > 0 then

        -- Make the entity take damage
        self:TakePhysicsDamage(dmg);

        -- Set the damage the entity has taken
        self.damage = (self.damage or SMALLBP_HEALTH) - dmg:GetDamage();

        -- If the damage exceeds the health threshold
        if self.damage <= 0 then
            -- Blow up and remove the entity
            self:Destruct();
            self:Remove();
        end;

    end;

end;

--[[Destruct: Destroy the entity]]
function ENT:Destruct()

    -- Local fields
    local vPoint = self:GetPos();       -- Get the entity's position
    local effectdata = EffectData();    -- Get the effect data

    -- Set the start, origin, and scale of the effect
    effectdata:SetStart(vPoint);
    effectdata:SetOrigin(vPoint);
    effectdata:SetScale(1);

    -- Start the explosion effect
    util.Effect("Explosion", effectdata);

    -- If there is an entity owner
    if IsValid(self:Getowning_ent()) then

        -- Notify the owner that the entity exploded
        DarkRP.notify(self:Getowning_ent(), NOTIFY_ERROR, 4, "Your Small Bottlecap Press exploded!");

    end;

end;