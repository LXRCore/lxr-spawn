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

local function buildOptions(Player, isNew)
    local pd = Player.PlayerData
    local list, map = {}, {}
    local pool = isNew and Config.FirstSpawns or Config.Spawns

    if not isNew and Config.General.allowLastPosition and pd.position and pd.position.x then
        map.last = toCoords(pd.position)
        list[#list + 1] = { id = 'last', label = Lang:t('ui.last_position'), coords = map.last, kind = 'last' }
    end

    local ordered = {}
    for id, def in pairs(pool) do ordered[#ordered + 1] = { id = id, def = def } end
    table.sort(ordered, function(a, b) return (a.def.label or a.id) < (b.def.label or b.id) end)
    for _, entry in ipairs(ordered) do
        local def = entry.def
        local allowed = true
        if def.jobs then
            allowed = false
            for _, job in ipairs(def.jobs) do if job == pd.job.name then allowed = true end end
        end
        if allowed then
            map[entry.id] = toCoords(def.coords)
            list[#list + 1] = { id = entry.id, label = def.label or entry.id, coords = map[entry.id], kind = 'town' }
        end
    end

    if Config.General.allowRandom and #ordered > 0 then
        list[#list + 1] = { id = 'random', label = Lang:t('ui.random'), kind = 'random' }
        map.random = true
    end
    return list, map
end

---Ask the loaded player to choose a spawn (called by multicharacter through the client event).
LXRCore.Callback.Register('lxr-spawn:server:options', function(src, isNew)
    if limited(src) then return nil end
    local Player = LXRCore.Functions.GetPlayer(src)
    if not Player then return nil end
    local list, map = buildOptions(Player, isNew == true)
    pending[src] = { isNew = isNew == true, options = map }
    return { options = list, isNew = isNew == true, locale = Lang.bundle(), server = Config.ServerInfo, skipSingle = Config.General.skipUIWhenSingle }
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
