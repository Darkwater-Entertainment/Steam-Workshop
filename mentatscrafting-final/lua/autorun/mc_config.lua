--[[
 - mc_config.lua is the configuration file for the Mentats Crafting addon.
 -
 - @author Kyle James
 - @version 24 August 2023
]]

-- UNIVERSAL CONSTANTS
MC_PAYOUT           = 50;                       -- How many caps the player receives from one tin of Mentats
MC_UI_RANGE         = 256;                      -- The range at which to draw the UI
MC_TEXT_COLOR       = Color(87, 184, 119);      -- The terminal text color
MC_BG_COLOR         = Color(45, 89, 58, 100);   -- The terminal background color
MC_OUTLINE_COLOR    = Color(28, 36, 24);        -- The terminal outline color
MC_COOKTIME         = 300;                      -- The cook time in seconds

-- MENTATS ADDICT
-- Type 'mc_addict_add <name>' in the in-game console to add NPC on map (at your target position and faces you).
-- Type 'mc_addict_remove <name>' in the in-game console to remove NPC from map.
MC_USE_DELAY            = 1;    -- The number of seconds to delay the user from spamming the Mentats Addict
MC_ADDICT_SFX           = true;	-- Do you want the Mentats Addict to emit sound
MC_ADDICT_NO_MENTATS    = {		-- Phrases to pull from when the player has no Mentats but tries to interact with the NPC

	"If I had two caps to scrape together I'd buy the materials to make my own, but my damn hands won't stop shaking.",

	"Last time I stopped, I felt like I was going to turn inside out.",

	"Speaking of which, do you have any spare caps?",

	"Heh heh. Good meat, huh? Cat meat, rat meat, dog meat - maybe even *you* meat!"

};
MC_ADDICT_NO_MENTATS_SFX = {	-- Audio phrases to pull from when the player has no Mentats but tries to interact with the NPC

	"vo/npc/male01/gethellout.wav",

	"vo/npc/male01/no02.wav",

	"vo/npc/male01/no01.wav",

	"vo/npc/male01/ohno.wav"

};
MC_ADDICT_MENTATS       = {     -- Phrases to pull from when the player has Mentats and interacts with the NPC

	"Thank God! I thought I was going to die if you didn't come back soon.",

	"At this point, I'm mostly buying his stuff just so I don't feel sick.",

	"You're a bastard after my own heart. Here, it's all I got.",

	"It's totally mind-blowing shit."

};
MC_ADDICT_MENTATS_SFX = {		-- Audio phrases to pull from when the player has Mentats and interacts with the NPC

	"vo/npc/male01/yeah02.wav",

	"vo/npc/male01/finally.wav",

	"vo/npc/male01/oneforme.wav",

};