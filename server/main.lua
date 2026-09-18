--[[
    ██╗     ██╗  ██╗██████╗        ███████╗██████╗  █████╗ ██╗    ██╗███╗   ██╗
    ██║     ╚██╗██╔╝██╔══██╗       ██╔════╝██╔══██╗██╔══██╗██║    ██║████╗  ██║
    ██║      ╚███╔╝ ██████╔╝█████╗ ███████╗██████╔╝███████║██║ █╗ ██║██╔██╗ ██║
    ██║      ██╔██╗ ██╔══██╗╚════╝ ╚════██║██╔═══╝ ██╔══██║██║███╗██║██║╚██╗██║
    ███████╗██╔╝ ██╗██║  ██║       ███████║██║     ██║  ██║╚███╔███╔╝██║ ╚████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚══════╝╚═╝     ╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═══╝

    🐺 LXR Core - Spawn Selection Server

    Builds the option list for a loaded character and resolves the chosen id
    to coordinates. The client never sends coordinates, only an id from the
    list it received, so a modified client cannot teleport anywhere it likes.

    Developer:   iBoss21 / LXRCore
    Website:     https://www.lxrcore.com
    © 2026 iBoss21 / LXRCore | lxrcore.com | All Rights Reserved
]]

local LXRCore = exports['lxr-core']:GetCoreObject()
local buckets = {}
local pending = {} -- source → { isNew, options = { id = coords } }

local function limited(src)
    local rl = Config.Security.rateLimit
    return not LXRCore.RateLimit(buckets, src, rl.burst, rl.windowMs)
end

local function toCoords(v)
    return { x = v.x, y = v.y, z = v.z, w = v.w or 0.0 }
end

local function card(id, def)
    local tags = {}
    for _, svc in ipairs(def.services or {}) do tags[#tags + 1] = svc end
    return { region = def.region, note = Lang:t('place.' .. id), services = tags }
end

-- "last seen": seconds since the row was saved and the nearest town; nil when the option is off
local function lastSeen(pd)
    if not Config.General.lastSeen then return nil end
    local t = LXRCore.DB.Scalar('SELECT UNIX_TIMESTAMP(last_updated) FROM players WHERE citizenid = ?', { pd.citizenid })
    local near, dist = LXRSpawn.Nearest(pd.position, Config.Spawns)
    return {
        since = t and math.max(0, os.time() - tonumber(t)) or nil,
        near = near and Config.Spawns[near].label or nil,
        miles = dist and LXRSpawn.Miles(dist) or nil,
    }
end

local function buildOptions(Player, isNew)
    local pd = Player.PlayerData
    local list, map = {}, {}
    local pool = isNew and Config.FirstSpawns or Config.Spawns
    if not isNew and Config.General.allowLastPosition and pd.position and pd.position.x then
        map.last = toCoords(pd.position)
        list[#list + 1] = { id = 'last', label = Lang:t('ui.last_position'), coords = map.last, kind = 'last', note = Lang:t('ui.last_note'), seen = lastSeen(pd) }
    end
    for _, id in ipairs(LXRSpawn.Ordered(pool)) do
        local def = pool[id]
        if LXRSpawn.Allowed(def, pd.job.name) then
            map[id] = toCoords(def.coords)
            local c = card(id, def)
            list[#list + 1] = { id = id, label = def.label or id, coords = map[id], kind = 'town', region = c.region, note = c.note, services = c.services }
        end
    end
    if Config.General.allowRandom and next(pool) then
        list[#list + 1] = { id = 'random', label = Lang:t('ui.random'), kind = 'random', note = Lang:t('ui.random_note') }
        map.random = true
    end
    return list, map
end
LXRCore.Callback.Register('lxr-spawn:server:options', function(src, isNew)
    if limited(src) then return nil end
    local Player = LXRCore.Functions.GetPlayer(src)
    if not Player then return nil end
    local list, map = buildOptions(Player, isNew == true)
    pending[src] = { isNew = isNew == true, options = map }
    return { options = list, isNew = isNew == true, locale = Lang.bundle(), server = LXRCore.Brand, skipSingle = Config.General.skipUIWhenSingle, protection = Config.Protection.seconds }
end)

RegisterNetEvent('lxr-spawn:server:choose', function(id)
    local src = source
    if limited(src) then return end
    local Player = LXRCore.Functions.GetPlayer(src)
    local session = pending[src]
    if not Player or not session or type(id) ~= 'string' then return end
    local target = session.options[id]
    if not target then
        LXRCore.Log.exploit(src, 'spawn id not offered', { id = id })
        return
    end
    if id == 'random' then
        local pool = session.isNew and Config.FirstSpawns or Config.Spawns
        local ids = {}
        for k, def in pairs(pool) do
            if not def.jobs then ids[#ids + 1] = k end
        end
        if #ids == 0 then for k in pairs(pool) do ids[#ids + 1] = k end end
        target = toCoords(pool[ids[math.random(1, #ids)]].coords)
    end
    pending[src] = nil
    Player.PlayerData.position = target
    Player._dirty = true
    TriggerClientEvent('lxr-spawn:client:spawnAt', src, target, session.isNew)
    TriggerEvent('lxr-spawn:server:spawned', src, id, target, session.isNew)
    LXRCore.Log.info('spawn', 'player spawned', { source = src, citizenid = Player.PlayerData.citizenid, id = id })
end)

AddEventHandler('playerDropped', function()
    pending[source] = nil
    buckets[source] = nil
end)

AddEventHandler('LXRCore:Server:OnPlayerUnload', function(src)
    pending[src] = nil
end)
