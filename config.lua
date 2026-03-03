--[[
    ██╗     ██╗  ██╗██████╗        ███████╗██████╗  █████╗ ██╗    ██╗███╗   ██╗
    ██║     ╚██╗██╔╝██╔══██╗       ██╔════╝██╔══██╗██╔══██╗██║    ██║████╗  ██║
    ██║      ╚███╔╝ ██████╔╝█████╗ ███████╗██████╔╝███████║██║ █╗ ██║██╔██╗ ██║
    ██║      ██╔██╗ ██╔══██╗╚════╝ ╚════██║██╔═══╝ ██╔══██║██║███╗██║██║╚██╗██║
    ███████╗██╔╝ ██╗██║  ██║       ███████║██║     ██║  ██║╚███╔███╔╝██║ ╚████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚══════╝╚═╝     ╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═══╝

    🐺 LXR-Spawn — Spawn Selection System for RedM

    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════

    Server:    The Land of Wolves 🐺
    Developer: iBoss21 / The Lux Empire
    Website:   https://www.wolves.land
    Discord:   https://discord.gg/CrKcWdfd3A
    Store:     https://theluxempire.tebex.io

    ═══════════════════════════════════════════════════════════════════════════════

    Version: 1.0.1
    Framework Support:
    - LXR Core  (Primary)
    - RSG Core  (Primary)
    - VORP Core (Supported)

    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE NAME PROTECTION - RUNTIME CHECK
-- ═══════════════════════════════════════════════════════════════════════════════

local REQUIRED_RESOURCE_NAME = "lxr-spawn"
local currentResourceName = GetCurrentResourceName()

if currentResourceName ~= REQUIRED_RESOURCE_NAME then
    error(string.format([[

        ═══════════════════════════════════════════════════════════════════════════════
        ❌ CRITICAL ERROR: RESOURCE NAME MISMATCH ❌
        ═══════════════════════════════════════════════════════════════════════════════

        Expected: %s
        Got: %s

        This resource is branded and must maintain the correct name.
        Rename the folder to "%s" to continue.

        🐺 wolves.land - The Land of Wolves

        ═══════════════════════════════════════════════════════════════════════════════

    ]], REQUIRED_RESOURCE_NAME, currentResourceName, REQUIRED_RESOURCE_NAME))
end

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SERVER BRANDING & INFO ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config = {}

Config.ServerInfo = {
    name      = 'The Land of Wolves 🐺',
    developer = 'iBoss21 / The Lux Empire',
    website   = 'https://www.wolves.land',
    discord   = 'https://discord.gg/CrKcWdfd3A',
    github    = 'https://github.com/iBoss21',
    store     = 'https://theluxempire.tebex.io',
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ FRAMEWORK CONFIGURATION ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Framework Priority (in order):
    1. LXR-Core  (Primary)
    2. RSG-Core  (Primary)
    3. VORP Core (Supported)
    4. Standalone (Fallback)
]]

Config.Framework = 'auto' -- 'auto' or manual: 'lxr-core', 'rsg-core', 'vorp_core', 'standalone'

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SPAWN CONFIGURATION ███████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

LXR = {}

-- Enable spawning inside houses from the spawn selector
LXR.EnableHouses = false

-- Enable spawning inside apartments from the spawn selector
LXR.EnableApartments = false

-- Enable or disable random spawn locations
LXR.EnableRandomSpawn = true -- Set to false to disable random spawn

-- First spawn locations
LXR.FirstSpawns = {
    ["emerald"] = { coords = vector4(1417.818, 268.0298, 89.61942, 144.5), location = "emerald", label = "Emerald Ranch Fence" }
}

-- Spawn locations
LXR.Spawns = {
    ["annesburg"]  = { coords = vector4(2929.1416, 1290.5629, 44.6673, 68.4290),    location = "annesburg",  label = "Annesburg"  },
    ["rhodes"]     = { coords = vector4(1236.7697, -1281.6980, 75.9116, 296.8683),  location = "rhodes",     label = "Rhodes"     },
    ["saintdenis"] = { coords = vector4(2570.9810, -1211.5509, 53.9253, 0.4514),    location = "saintdenis", label = "Saint Denis" },
    ["valentine"]  = { coords = vector4(-376.4507, 726.8616, 116.4170, 319.1562),   location = "valentine",  label = "Valentine"  },
    ["blackwater"] = { coords = vector4(-805.1362, -1313.6912, 43.6430, 266.2657),  location = "blackwater", label = "Blackwater" },
    ["strawberry"] = { coords = vector4(-1801.3273, -358.3829, 163.8472, 286.8674), location = "strawberry", label = "Strawberry" },
    ["tumbleweed"] = { coords = vector4(-5504.1934, -2948.8291, -1.8542, 257.0909), location = "tumbleweed", label = "Tumbleweed" },
    ["armadillo"]  = { coords = vector4(-3673.4417, -2618.9885, -13.8154, 359.5648), location = "armadillo", label = "Armadillo"  }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ HELPER FUNCTIONS ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Function to get random spawn point
function LXR.GetRandomSpawn()
    local spawnLocations = {}
    for _, spawn in pairs(LXR.Spawns) do
        table.insert(spawnLocations, spawn)
    end

    -- Randomly choose a spawn location
    local randomIndex = math.random(1, #spawnLocations)
    return spawnLocations[randomIndex]
end

-- Function to get spawn point based on configuration
function LXR.GetSpawnPoint()
    if LXR.EnableRandomSpawn then
        return LXR.GetRandomSpawn() -- Return a random spawn point
    else
        -- Default first spawn if random spawn is disabled
        return LXR.FirstSpawns["emerald"]
    end
end
