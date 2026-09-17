--[[
    ██╗     ██╗  ██╗██████╗        ███████╗██████╗  █████╗ ██╗    ██╗███╗   ██╗
    ██║     ╚██╗██╔╝██╔══██╗       ██╔════╝██╔══██╗██╔══██╗██║    ██║████╗  ██║
    ██║      ╚███╔╝ ██████╔╝█████╗ ███████╗██████╔╝███████║██║ █╗ ██║██╔██╗ ██║
    ██║      ██╔██╗ ██╔══██╗╚════╝ ╚════██║██╔═══╝ ██╔══██║██║███╗██║██║╚██╗██║
    ███████╗██╔╝ ██╗██║  ██║       ███████║██║     ██║  ██║╚███╔███╔╝██║ ╚████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚══════╝╚═╝     ╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═══╝

    🐺 LXR Core - Spawn Selection Configuration

    Spawn points, first-spawn points for new characters, last-position rules and
    the overview camera. Ids are what the client sends back; the server only
    accepts ids that exist here.

    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════

    Brand:       LXRCore — Lux Empire eXperience RedM Core
    Product:     wolves.land / The Land of Wolves 🐺
    Developer:   iBoss21 / LXRCore
    Website:     https://www.lxrcore.com
    Discord:     https://discord.gg/ZHMKVYyhBa (development)
    GitHub:      https://github.com/LXRCore

    Version: 2.0.0 · Framework Support: LXR Core v3 (Native)
    © 2026 iBoss21 / LXRCore | lxrcore.com | All Rights Reserved
]]

Config = Config or {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SERVER BRANDING & INFO ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ LANGUAGE CONFIGURATION ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Lang = 'en'

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ GENERAL SETTINGS ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.General = {
    allowLastPosition = true,   -- Offer "where you left off" for existing characters
    allowRandom       = true,   -- Offer a random spawn (picked on the server)
    skipUIWhenSingle  = false,  -- true: if only one option exists spawn there immediately
    -- Client event fired after a NEW character spawned (appearance creator); nil = none
    newCharacterEvent = 'lxr-clothing:client:newPlayer',
    fadeMs            = 600,
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ CAMERA ████████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Camera = {
    heightFar  = 1500.0,  -- Overview height above the spawn
    heightNear = 60.0,    -- Height of the close-up
    farMs      = 500,
    nearMs     = 1200,
    fov        = 100.0,
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ LOCATIONS & COORDINATES ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Spawn points for existing characters. `jobs` (optional) restricts a point to job names.
Config.Spawns = {
    valentine  = { label = 'Valentine',   coords = vector4(-376.45, 726.86, 116.42, 319.16) },
    rhodes     = { label = 'Rhodes',      coords = vector4(1236.77, -1281.70, 75.91, 296.87) },
    saintdenis = { label = 'Saint Denis', coords = vector4(2570.98, -1211.55, 53.93, 0.45) },
    blackwater = { label = 'Blackwater',  coords = vector4(-805.14, -1313.69, 43.64, 266.27) },
    strawberry = { label = 'Strawberry',  coords = vector4(-1801.33, -358.38, 163.85, 286.87) },
    annesburg  = { label = 'Annesburg',   coords = vector4(2929.14, 1290.56, 44.67, 68.43) },
    tumbleweed = { label = 'Tumbleweed',  coords = vector4(-5504.19, -2948.83, -1.85, 257.09) },
    armadillo  = { label = 'Armadillo',   coords = vector4(-3673.44, -2618.99, -13.82, 359.56) },
}

-- Spawn points offered to brand-new characters only.
Config.FirstSpawns = {
    emerald = { label = 'Emerald Ranch', coords = vector4(1417.82, 268.03, 89.62, 144.5) },
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SECURITY & ANTI-ABUSE █████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Security = {
    rateLimit = { burst = 10, windowMs = 10000 },
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ END OF CONFIGURATION ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
