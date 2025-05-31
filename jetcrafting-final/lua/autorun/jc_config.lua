--[[
 - jc_config.lua is the configuration file for the Jet Crafting addon.
 -
 - @author Kyle James
 - @version 24 August 2023
]]

-- UNIVERSAL CONSTANTS
JC_UI_RANGE 		= 256; 						-- The range at which to draw the UI
JC_TEXT_COLOR       = Color(87, 184, 119);      -- The terminal text color
JC_BG_COLOR         = Color(45, 89, 58, 100);   -- The terminal background color
JC_OUTLINE_COLOR    = Color(28, 36, 24);        -- The terminal outline color
JC_USE_DELAY 		= 1;						-- The number of seconds to delay the user from spamming use on some entities

-- JET ADDICT CONSTANTS
-- Type 'jc_addict_add <name>' in the in-game console to add NPC on map (at your target position and faces you).
-- Type 'jc_addict_remove <name>' in the in-game console to remove NPC from map.
JC_USE_ADDICT 		= true; -- Do you want to use the Jet Addict to sell Jet
JC_ADDICT_SFX		= true;	-- Do you want the Jet Addict to emit sound
JC_ADDICT_NO_JET 	= {		-- Phrases to pull from when the player has no Jet but tries to interact with the NPC

	"If I had two caps to scrape together I'd buy the materials to make my own, but my damn hands won't stop shaking.",

	"Last time I stopped, I felt like I was going to turn inside out.",

	"Speaking of which, do you have any spare caps?",

	"Heh heh. Good meat, huh? Cat meat, rat meat, dog meat - maybe even *you* meat!"

};
JC_ADDICT_NO_JET_SFX = {	-- Audio phrases to pull from when the player has no Jet but tries to interact with the NPC

	"vo/npc/male01/gethellout.wav",

	"vo/npc/male01/no02.wav",

	"vo/npc/male01/no01.wav",

	"vo/npc/male01/ohno.wav"

};
JC_ADDICT_JET = {			-- Phrases to pull from when the player has Jet and interacts with the NPC

	"Thank God! I thought I was going to die if you didn't come back soon.",

	"At this point, I'm mostly buying his stuff just so I don't feel sick.",

	"You're a bastard after my own heart. Here, it's all I got.",

	"It's totally mind-blowing shit."

};	
JC_ADDICT_JET_SFX = {		-- Audio phrases to pull from when the player has Jet and interacts with the NPC

	"vo/npc/male01/yeah02.wav",

	"vo/npc/male01/finally.wav",

	"vo/npc/male01/oneforme.wav",

};

-- CHEM STATION CONSTANTS
JC_CHEM_STATION_HEALTH 				= 400;						-- How much health the Chem Station has
JC_CHEM_STATION_EXPLOSION_TYPE 		= 2;						-- Explosion type: 0 = Indestructible, 1 = Destructible (no explosion), 2 = Explosion
JC_CHEM_STATION_EXPLOSION_DAMAGE 	= 100;						-- How much damage the explosion does (if explosion type is 2)
JC_CHEM_STATION_CONSUMPTION 		= 1; 						-- How much energy to consume per second
JC_CHEM_STATION_HEAT 				= 1; 						-- How much to heat
JC_CHEM_STATION_STORAGE 			= 600;						-- How much energy the Chem Station can store
JC_CHEM_STATION_GRAV_GUN 			= true;						-- Whether or not you can grab the Chem Station with the Grav Gun
JC_CHEM_STATION_SMOKE_COLOR_R 		= 100;						-- The red color value of the smoke
JC_CHEM_STATION_SMOKE_COLOR_G 		= 100;						-- The green color value of the smoke
JC_CHEM_STATION_SMOKE_COLOR_B 		= 0;						-- The blue color value of the smoke
JC_CHEM_STATION_INDICATOR_COLOR 	= Color(255, 222, 0, 255);	-- The indicator color


-- JAR CONSTANTS
JC_JAR_START_PROGRESS 	= 0;	-- What % to start the progress on
JC_JAR_MIN_SHAKE 		= 25;	-- How fast the player needs to shake the Jar to make progress
JC_JAR_MAX_SHAKE 		= 1000;	-- The upper limit of the "perfect" zone for optimal Jar progress
JC_JAR_CORRECT_SHAKE 	= 4;	-- How much progress to make on a perfect shake
JC_JAR_WRONG_SHAKE 		= 1;	-- How much progress to make on an excessive shake
JC_JAR_DESTROY_EMPTY 	= true;	-- Whether or not to destroy Spoiled Meat/Fruit/Vegetables when they have nothing left

-- POT CONSTANTS
JC_POT_START_TIME 			= 30;	-- The baseline for the Pot cook time
JC_POT_ON_ADD_SPOILED_MEAT 	= 5;	-- How much time to add for each Spoiled Meat added
JC_POT_DESTROY_EMPTY 		= true;	-- Whether or not to destroy Spoiled Meat/Protein Extract when they have nothing left

-- SPECIAL POT CONSTANTS
JC_SPECIAL_POT_START_TIME 			= 30;	-- The baseline for the Special Pot cook time
JC_SPECIAL_POT_ON_ADD_AMPHETAMINE 	= 10;	-- How much time to add for each Amphetamine added
JC_SPECIAL_POT_ON_ADD_FERTILIZER 	= 10;	-- How much time to add for each Fertilizer added

-- POWER CORE CONSTANTS
JC_PC_REMOVE 	= true;	-- Whether or not to remove the Power Core after it's depleted
JC_PC_AMOUNT 	= 900;	-- The default amount of energy in the Power Core
JC_PC_EXPLOSION = 0;	-- Explosion style: 0 - cannot be destroyed, 1 - destroys w/o explosion, 2 - explodes instantly

-- SPOILED FRUIT CONSTANTS
JC_SPOILED_FRUIT_AMOUNT = 10;	-- How much Spoiled Fruit spawns

-- SPOILED MEAT CONSTANTS
JC_SPOILED_MEAT_AMOUNT = 10;	-- How much Spoiled Meat spawns

-- SPOILED VEGGIES CONSTANTS
JC_SPOILED_VEGGIES_AMOUNT = 10;	-- How many Spoiled Veggies spawn

-- PROTEIN EXTRACT CONSTANTS
JC_PROTEIN_EXTRACT_AMOUNT = 10;	-- How much Protein Extract spawns

-- JET CONSTANTS
JC_JET_VALUE_MODIFIER = 20;		-- How many caps to give per unit of Jet