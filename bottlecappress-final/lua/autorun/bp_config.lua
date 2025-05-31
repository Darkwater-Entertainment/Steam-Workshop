--[[
 - bp_config.lua is the configuration file for the Bottlecap Press addon.
 -
 - @author Kyle James
 - @version 22 August 2023
 -
 - NOTES:
 -  Set any MAX constant to 0 to disable cap limits
 -  Set any HEALTH constant to 0 to make the press indestructible
]]

-- UNIVERSAL CONSTANTS
BP_INTERVAL         = 60;                       -- Time between cap increments in seconds
BP_INCREMENT        = 10;                       -- The number of caps to increment after the interval
BP_MAX              = 500;                      -- The maximum number of caps the press can hold
BP_HEALTH           = 1000;                     -- The amount of damage the press can take before blowing up
BP_UI_RANGE         = 256;                      -- The range at which to draw the UI
BP_TEXT_COLOR       = Color(87, 184, 119);      -- The terminal text color
BP_BG_COLOR         = Color(45, 89, 58, 100);   -- The terminal background color
BP_OUTLINE_COLOR    = Color(28, 36, 24);        -- The terminal outline color

-- SMALL BOTTLECAP PRESS CONSTANTS
SMALLBP_INTERVAL    = BP_INTERVAL;          -- Time between cap increments in seconds for the Small Bottlecap Press
SMALLBP_INCREMENT   = BP_INCREMENT;             -- The number of caps to increment the Small Bottlecap Press by after the interval
SMALLBP_MAX         = BP_MAX;                   -- The maximum number of caps the Small Bottlecap Press can hold
SMALLBP_HEALTH      = BP_HEALTH;                -- The amount of damage the Small Bottlecap Press can take before blowing up

-- MEDIUM BOTTLECAP PRESS CONSTANTS
MEDBP_INTERVAL      = BP_INTERVAL * 3;          -- Time between cap increments in seconds for the Medium Bottlecap Press
MEDBP_INCREMENT     = BP_INCREMENT;             -- The number of caps to increment the Medium Bottlecap Press by after the interval
MEDBP_MAX           = BP_MAX * 2;               -- The maximum number of caps the Medium Bottlecap Press can hold
MEDBP_HEALTH        = BP_HEALTH * 5;            -- The amount of damage the Medium Bottlecap Press can take before blowing up

-- BIG BOTTLECAP PRESS CONSTANTS
BIGBP_INTERVAL      = BP_INTERVAL / 2;          -- Time between cap increments in seconds for the Big Bottlecap Press
BIGBP_INCREMENT     = BP_INCREMENT;             -- The number of caps to increment the Big Bottlecap Press by after the interval
BIGBP_MAX           = 0;                        -- The maximum number of caps the Big Bottlecap Press can hold
BP_HEALTH           = 0;                        -- The amount of damage the Big Bottlecap Press can take before blowing up