--[[ 
  cl_fc_nutritionSystem.lua
  Client-side HUD rendering for the Fallout Nutrition System.
  Displays stylized FOD (hunger) and H2O (thirst) labels with color fading based on stat values.

  @author Kyle James
  @version 31 May 2025
]]

-- Color thresholds generator
local function generateColorValues(max)
    return {
        [max]       = {true, true, true, 0},
        [max * 0.8] = {true, true, true, 127},
        [max * 0.6] = {true, true, true, 255},
        [max * 0.4] = {255, 0, 0, 127},
        [max * 0.2] = {255, 0, 0, 255}
    }
end

-- Fonts for HUD text
surface.CreateFont("normal", {
    font = "Impact",
    size = 25,
    weight = 400,
    outline = false
})

surface.CreateFont("blur", {
    font = "Impact",
    size = 25,
    weight = 400,
    blursize = 5,
    outline = false
})

-- Returns the color override for a given stat value (hunger/thirst)
local function getKeyByValue(tbl, stat)
    for i, v in SortedPairs(tbl) do
        if stat > i then continue end
        return v
    end
end

-- Utility to get the closest threshold override
local function getKeyByValue(tbl, stat)
    for i, v in SortedPairs(tbl) do
        if stat > i then continue end
        return v
    end
end

-- Frame cache for generated thresholds
local frameColorCache = {}
hook.Add("Think", "fc_ns_cache_update", function()
    frameColorCache.hunger = generateColorValues(FC_NS_MAX_HUNGER or 1000)
    frameColorCache.thirst = generateColorValues(FC_NS_MAX_THIRST or 1000)
end)

-- Compute the final color
local function getColor(isHunger)
    local ply = LocalPlayer()
    local stat = isHunger and ply:GetNW2Float("hunger") or ply:GetNW2Float("thirst")
    local thresholds = isHunger and frameColorCache.hunger or frameColorCache.thirst

    local pc = ply:GetPlayerColor():ToTable()
    pc[1] = pc[1] * 255
    pc[2] = pc[2] * 255
    pc[3] = pc[3] * 255
    pc[4] = 255

    local override = getKeyByValue(thresholds, stat)
    if override then
        for k, v in pairs(override) do
            if isnumber(v) then pc[k] = v end
        end
    end

    return pc
end

-- HUD draw functions
local function drawHungerBar()
    local color = getColor(true) or {255, 0, 0, 255}
    surface.SetTextColor(color[1], color[2], color[3], color[4])
    surface.SetTextPos(ScrW() - 250, ScrH() - 85)
    surface.SetFont("blur")
    surface.DrawText("FOD")
    surface.SetTextPos(ScrW() - 250, ScrH() - 85)
    surface.SetFont("normal")
    surface.DrawText("FOD")
end

-- Draws the thirst ("H2O") label with appropriate color and blur
local function drawThirstBar()
    local color = getColor(false) or {255, 0, 0, 255}
    surface.SetTextColor(color[1], color[2], color[3], color[4])
    surface.SetTextPos(ScrW() - 310, ScrH() - 85)
    surface.SetFont("blur")
    surface.DrawText("H2O")
    surface.SetTextPos(ScrW() - 310, ScrH() - 85)
    surface.SetFont("normal")
    surface.DrawText("H2O")
end

-- Main HUD hook
hook.Add("HUDPaint", "fc_ns_hudpaint", function()
    if not FC_NS_ENABLED then return end
    drawHungerBar()
    drawThirstBar()
end)