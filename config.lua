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
    -- Client event fired after a NEW character spawned; nil = none.
    -- With lxr-creator + lxr-clothing the appearance was already set before the spawn
    -- picker (Config.Integrations.newCharacterAppearance), so leave this nil.
    newCharacterEvent = nil,
    fadeMs            = 600,
    lastSeen          = true,   -- the "where you left off" row shows when and near which town
    milesPerUnit      = 0.000621,  -- game units → miles for the card ("2.1 miles from town")
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
-- `region` and `services` feed the place card on the right of the picker; the card's line about
-- the place is `place.<id>` in locales/. Services are tags (doctor, law, store, train, stable, bank, post, saloon).
Config.Spawns = {
    valentine  = { label = 'Valentine',   region = 'The Heartlands',   coords = vector4(-376.45, 726.86, 116.42, 319.16), services = { 'doctor', 'law', 'store', 'train', 'stable', 'bank', 'post', 'saloon' } },
    rhodes     = { label = 'Rhodes',      region = 'Scarlett Meadows', coords = vector4(1236.77, -1281.70, 75.91, 296.87), services = { 'law', 'store', 'train', 'stable', 'bank', 'post', 'saloon' } },
    saintdenis = { label = 'Saint Denis', region = 'Bayou Nwa',        coords = vector4(2570.98, -1211.55, 53.93, 0.45), services = { 'doctor', 'law', 'store', 'train', 'stable', 'bank', 'post', 'saloon' } },
    blackwater = { label = 'Blackwater',  region = 'Great Plains',     coords = vector4(-805.14, -1313.69, 43.64, 266.27), services = { 'doctor', 'law', 'store', 'stable', 'bank', 'post', 'saloon' } },
    strawberry = { label = 'Strawberry',  region = 'Big Valley',       coords = vector4(-1801.33, -358.38, 163.85, 286.87), services = { 'law', 'store', 'stable', 'post' } },
    annesburg  = { label = 'Annesburg',   region = 'Roanoke Ridge',    coords = vector4(2929.14, 1290.56, 44.67, 68.43), services = { 'law', 'store', 'train', 'post' } },
    tumbleweed = { label = 'Tumbleweed',  region = 'Gaptooth Ridge',   coords = vector4(-5504.19, -2948.83, -1.85, 257.09), services = { 'law', 'store', 'stable', 'post' } },
    armadillo  = { label = 'Armadillo',   region = 'Cholla Springs',   coords = vector4(-3673.44, -2618.99, -13.82, 359.56), services = { 'doctor', 'store', 'train', 'saloon' } },
}

-- Spawn points offered to brand-new characters only.
Config.FirstSpawns = {
    emerald = { label = 'Emerald Ranch', region = 'The Heartlands', coords = vector4(1417.82, 268.03, 89.62, 144.5), services = { 'stable', 'train' } },
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ ARRIVAL ═══════════════════════════════════════════════
-- ████████████████████████████████████████████████████████████████████████████████
-- After the teleport the player is untouchable for a moment so nobody camps a spawn.
Config.Protection = {
    seconds  = 10,        -- 0 disables
    warnAt   = 3,         -- a toast this many seconds before it ends
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
