--[[
 - fc_config.lua is the configuration file for the Fallout Consumables addon.
 -
 - @author Kyle James
 - @version 31 May 2025
]]

-- UNIVERAL CONSTANTS
FC_TEXT_COLOR       = Color(87, 184, 119);      -- The terminal text color
FC_BG_COLOR         = Color(45, 89, 58, 100);   -- The terminal background color
FC_OUTLINE_COLOR    = Color(28, 36, 24);        -- The terminal outline color

-- NUTRITION SYSTEM CONFIG
FC_NS_ENABLED = true                            -- Whether to enable the nutrition system
FC_NS_KILL_ON_MALNOURISHED = true               -- Whether to kill the player if they reach 0 hunger or thirst
FC_NS_ITERATE = 25                              -- The amount of time it takes for a player's hunger and thirst to decrease
FC_NS_HUNGER_RATE = 1                           -- The amount of hunger taken away from the player each tick
FC_NS_THIRST_RATE = 2.5                         -- The amount of thirst taken away from the player each tick
FC_NS_MAX_HUNGER = 1000                         -- The amount of hunger points to cap users at
FC_NS_MAX_THIRST = 1000                         -- The amount of thirst points to cap users at

-- CONSUMABLE EFFECTS
FC_Effects = {

    -- Example: Make a copy of this if you plan to add more effects
    ["exampleEffect"] = {
        ItemName = "Example Effect",            -- The name of the effect (or item)
        Description = "Effect Description",     -- The description of the effect (or item)
        MaxDuration = 240,                      -- How long the effect lasts
        Initialize = function(ply) end,         -- What happens when the effect initializes (on use)
        InitializeOnce = function(ply) end,     -- What happens ONCE when initializing
        Terminate = function(ply) end,          -- What happens when the effect ends (after duration)
        Iterate = function(ply, duration) end,  -- What happens every tick during the effect's duration (every second)
    },
	
    -- Chem Effects
    ["drunk"] = {
		ItemName = "Drunk",
		Description = "You'll be sorry tomorrow...",
		MaxDuration = 240,
        Terminate = function(ply,duration)
            ply:EmitSound("fc_fx/chems_wearoff.mp3")
        end,
	},

	["overdose"] = {
		ItemName = "Overdose",
		Description = "Excess use of chems!",
		MaxDuration = 180,
        InitializeOnce = function(ply, duration)
            ply:EmitSound("fc_fx/chems_addicted.mp3")
        end,
		Iterate = function(ply, duration)
            ply:Kill();
        end,
	},

    ["beer"] = {
        ItemName = "Beer",
        Description = "You're drinking...",
        MaxDuration = 240,
        Initialize = function(ply) 
            FC_ApplyNutrition(ply, 0, -20);
        end,
        Terminate = function(ply,duration)
            ply:EmitSound("fc_fx/chems_wearoff.mp3")
        end,
    },


    ["buffout"] = {
        ItemName = "Buffout",
        Description = "Your pills are wearing off...",
        MaxDuration = 240,
        Illegal = true,
        Initialize = function(ply) 
            if not ply:IsPlayer() then return end;
            ply:SetHealth(ply:Health() + 60);
        end,
        Terminate = function(ply)
            ply:SetHealth(ply:Health() - 60);
            ply:EmitSound("fc_fx/chems_wearoff.mp3")
        end,
        
    },

    ["jet"] = {
		ItemName = "Jet",
		Description = "You're coming down...",
		MaxDuration = 240,
        Illegal = true,
		InitializeOnce = function(ply)
            ply:SetRunSpeed(ply:GetRunSpeed() * 1.25);
        end,
		Terminate = function(ply)
            ply:SetRunSpeed(GAMEMODE.Config.runspeed)
            ply:EmitSound("fc_fx/chems_wearoff.mp3")
        end,
		Iterate = function(ply, duration) end,
		ColorModify = {
			["$pp_colour_addr"] = 0.1,
			["$pp_colour_addg"] = 0.075,
			["$pp_colour_contrast"] = 1.3,
			["$pp_colour_colour"] = 1
		},
		MotionBlur = {0.5, 0, 0.5},
	},

    ["hPowder"] = {
		ItemName = "Healing Powder",
		Description = "You're healing...",
		MaxDuration = 18,
		Iterate = function(ply, duration)
            FC_UpdateHealthPerTick(ply, 2);
        end,
        Terminate = function(ply,duration)
            ply:EmitSound("fc_fx/chems_wearoff.mp3")
        end,
		ColorModify = {
			["$pp_colour_contrast"] = 1.5,
			["$pp_colour_colour"] = 1.5
		},
	},

    ["medX"] = { -- Due to the nature of medx, this logic takes place in sv_consumables
		ItemName = "Med-X",
		Description = "You're protected...",
		MaxDuration = 240,
        Terminate = function(ply,duration)
            ply:EmitSound("fc_fx/chems_wearoff.mp3")
        end,
	},

    ["psycho"] = { -- Due to the nature of psycho, this logic takes place in sv_consumables
		ItemName = "Psycho",
		Description = "You're enraged...",
		MaxDuration = 240,
        Illegal = true,
        Terminate = function(ply,duration)
            ply:EmitSound("fc_fx/chems_wearoff.mp3")
        end,
		ColorModify = {
			["$pp_colour_addr"] = 0.2,
			["$pp_colour_contrast"] = 1.3,
			["$pp_colour_colour"] = 1
		},
		MotionBlur = {0.3, 0.8, 0.01},
	},

    ["stimpak"] = {
		ItemName = "Stimpak",
		Description = "You're healing...",
		MaxDuration = 6,
		Iterate = function(ply, duration)
            FC_UpdateHealthPerTick(ply, 5);
        end,
	},

    ["whiskey"] = {
        ItemName = "Whiskey",
        Description = "You're drinking...",
        MaxDuration = 240,
        Initialize = function(ply) 
            FC_ApplyNutrition(ply, 0, -25);
        end,
        Terminate = function(ply,duration)
            ply:EmitSound("fc_fx/chems_wearoff.mp3")
        end,
    },

    -- Food Effects
	["freshApple"] = {
        ItemName = "Fresh Apple",
        Description = "You're eating...",
        MaxDuration = 7,
        Initialize = function(ply)
            FC_ApplyNutrition(ply, 15, 10);
        end,
        Iterate = function(ply, duration) 
           FC_UpdateHealthPerTick(ply, 1);
        end,
    },

    ["iguanaStick"] = {
        ItemName = "Iguana on a Stick",
        Description = "You're eating...",
        MaxDuration = 12,
        Initialize = function(ply) 
            FC_ApplyNutrition(ply, 75, 0);
        end,
        Iterate = function(ply, duration)
            FC_UpdateHealthPerTick(ply, 1);
        end,
    },

    ["maize"] = {
        ItemName = "Maize",
        Description = "You're eating...",
        MaxDuration = 9,
        Initialize = function(ply)
            FC_ApplyNutrition(ply, 40, 10);
        end,
        Iterate = function(ply, duration) 
            FC_UpdateHealthPerTick(ply, 1);
        end,
    },

    ["blamcoMac"] = {
        ItemName = "BlamCo Mac & Cheese ",
        Description = "You're eating...",
        MaxDuration = 5,
        Initialize = function(ply)
            FC_ApplyNutrition(ply, 20, 0);
        end,
        Iterate = function(ply, duration) 
            FC_UpdateHealthPerTick(ply, 1);
        end,
    },

    ["bYucca"] = {
        ItemName = "Banana Yucca Fruit",
        Description = "You're eating...",
        MaxDuration = 7,
        Initialize = function(ply)
            FC_ApplyNutrition(ply, 10, 15);
        end,
        Iterate = function(ply, duration) 
            FC_UpdateHealthPerTick(ply, 1);
        end,
    },

    ["brocFlower"] = {
        ItemName = "Broc Flower",
        Description = "You're eating...",
        MaxDuration = 4,
        Initialize = function(ply)
            FC_ApplyNutrition(ply, 5, 0);
        end,
        Iterate = function(ply, duration) 
            FC_UpdateHealthPerTick(ply, 1);
        end,
    },

    ["buffaloGourd"] = {
        ItemName = "Buffalo Gourd Seed",
        Description = "You're eating...",
        MaxDuration = 2,
        Initialize = function(ply)
            FC_ApplyNutrition(ply, 10, 0);
        end,
        Iterate = function(ply, duration) 
            FC_UpdateHealthPerTick(ply, 1);
        end,
    },


    ["freshCarrot"] = {
        ItemName = "Fresh Carrot",
        Description = "You're eating...",
        MaxDuration = 7,
        Initialize = function(ply)
            FC_ApplyNutrition(ply, 15, 10);
        end,
        Iterate = function(ply, duration) 
            FC_UpdateHealthPerTick(ply, 1);
        end,
    },

    ["antMeat"] = {
        ItemName = "Ant meat",
        Description = "You're eating...",
        MaxDuration = 5,
        Initialize = function(ply)
            FC_ApplyNutrition(ply, 25, 0);
        end,
        Iterate = function(ply, duration) 
            FC_UpdateHealthPerTick(ply, 1);
        end,
    },

    ["cram"] = {
        ItemName = "Cram",
        Description = "You're eating...",
        MaxDuration = 5,
        Initialize = function(ply)
            FC_ApplyNutrition(ply, 50, 0);
        end,
        Iterate = function(ply, duration) 
            FC_UpdateHealthPerTick(ply, 1);
        end,
    },

    ["dboyApples"] = {
        ItemName = "Dandy Boy Apples",
        Description = "You're eating...",
        MaxDuration = 5,
        Initialize = function(ply)
            FC_ApplyNutrition(ply, 15, 0);
        end,
        Iterate = function(ply, duration) 
            FC_UpdateHealthPerTick(ply, 1);
        end,
    },

    ["dogMeat"] = {
        ItemName = "Dog Meat",
        Description = "You're eating...",
        MaxDuration = 8,
        Initialize = function(ply)
            FC_ApplyNutrition(ply, 35, 0);
        end,
        Iterate = function(ply, duration) 
            FC_UpdateHealthPerTick(ply, 1);
        end,
    },

    ["fancyLadsnackCakes"] = {
        ItemName = "Fancy Lads Snack Cakes",
        Description = "You're eating...",
        MaxDuration = 5,
        Initialize = function(ply)
            FC_ApplyNutrition(ply, 15, 0);
        end,
        Iterate = function(ply, duration) 
            FC_UpdateHealthPerTick(ply, 1);
        end,
    },

    ["fireantMeat"] = {
        ItemName = "Fire Ant Meat",
        Description = "You're eating...",
        MaxDuration = 5,
        Initialize = function(ply)
            FC_ApplyNutrition(ply, 25, 0);
        end,
        Iterate = function(ply, duration) 
            FC_UpdateHealthPerTick(ply, 1);
        end,
    },

    ["flyMeat"] = {
        ItemName = "Bloatfly Meat",
        Description = "You're eating...",
        MaxDuration = 5,
        Initialize = function(ply)
            FC_ApplyNutrition(ply, 25, 0);
        end,
        Iterate = function(ply, duration) 
            FC_UpdateHealthPerTick(ply, 1);
        end,
    },

    ["mantisClaw"] = {
        ItemName = "Grilled Mantis",
        Description = "You're eating...",
        MaxDuration = 30,
        Initialize = function(ply)
            FC_ApplyNutrition(ply, 75, 0);
        end,
        Iterate = function(ply, duration) 
            FC_UpdateHealthPerTick(ply, 1);
        end,
    },


    ["moleMeat"] = {
        ItemName = "Mole Rat Meat",
        Description = "You're eating...",
        MaxDuration = 5,
        Initialize = function(ply)
            FC_ApplyNutrition(ply, 25, 0);
        end,
        Iterate = function(ply, duration) 
            FC_UpdateHealthPerTick(ply, 1);
        end,
    },

    ["meat"] = {
        ItemName = "Meat",
        Description = "You're eating...",
        MaxDuration = 15,
        Initialize = function(ply)
            FC_ApplyNutrition(ply, 50, 0);
        end,
        Iterate = function(ply, duration) 
            FC_UpdateHealthPerTick(ply, 1);
        end,
    },

    ["ygMeat"] = {
        ItemName = "Yao Guai Meat",
        Description = "You're eating...",
        MaxDuration = 5,
        Initialize = function(ply)
            FC_ApplyNutrition(ply, 100, 0);
        end,
        Iterate = function(ply, duration) 
            FC_UpdateHealthPerTick(ply, 2);
        end,
    },

    ["nsTail"] = {
        ItemName = "Night Stalker Tail",
        Description = "You're eating...",
        MaxDuration = 5,
        Iterate = function(ply, duration) 
            FC_UpdateHealthPerTick(ply, 1);
        end,
    },

    ["water"] = {
        ItemName = "Purified Water",
        Description = "You're drinking...",
        MaxDuration = 5,
        Initialize = function(ply)
            FC_ApplyNutrition(ply, 0, 50);
        end,
        Iterate = function(ply, duration) 
            FC_UpdateHealthPerTick(ply, 2);
        end,
    },

    ["nukaCola"] = {
        ItemName = "Nuka-Cola",
        Description = "You're drinking...",
        MaxDuration = 25,
        Initialize = function(ply)
            FC_ApplyNutrition(ply, 0, 10);
        end,
        Iterate = function(ply, duration) 
            FC_UpdateHealthPerTick(ply, 2);
        end,
    },

    ["ssSarsaparilla"] = {
        ItemName = "Sunset Sarsaparilla",
        Description = "You're drinking...",
        MaxDuration = 25,
        Initialize = function(ply)
            FC_ApplyNutrition(ply, 0, 5);
        end,
        Iterate = function(ply, duration) 
            FC_UpdateHealthPerTick(ply, 2);
        end,
    },
}

-- UTILITY FUNCTIONS
--[[FC_ApplyNutrition: Applies nutrition updates to player.
        ply: the player
        hungerPoints: the hunger points to add
        thirstPoints: the thirst points to add]]
function FC_ApplyNutrition(ply, hungerPoints, thirstPoints)

    if not ply:IsPlayer() then return end;

    local newHunger = ply:GetNW2Float("hunger", 0) + hungerPoints;
    local newThirst = ply:GetNW2Float("thirst", 0) + thirstPoints;

    ply:SetNW2Float("hunger", math.Clamp(newHunger, 0, FC_NS_MAX_HUNGER));
    ply:SetNW2Float("thirst", math.Clamp(newThirst, 0, FC_NS_MAX_THIRST));

end;

--[[FC_UpdateHealthPerTick: Updates health value every tick (second)
        ply: the player
        healthPerTick: the health to add or subtract from a player per tick]]
function FC_UpdateHealthPerTick(ply, healthPerTick)

    ply:SetHealth(math.Clamp(ply:Health() + healthPerTick, 0, ply:GetMaxHealth()));

end;