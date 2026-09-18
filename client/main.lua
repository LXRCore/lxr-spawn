--[[
    ██╗     ██╗  ██╗██████╗        ███████╗██████╗  █████╗ ██╗    ██╗███╗   ██╗
    ██║     ╚██╗██╔╝██╔══██╗       ██╔════╝██╔══██╗██╔══██╗██║    ██║████╗  ██║
    ██║      ╚███╔╝ ██████╔╝█████╗ ███████╗██████╔╝███████║██║ █╗ ██║██╔██╗ ██║
    ██║      ██╔██╗ ██╔══██╗╚════╝ ╚════██║██╔═══╝ ██╔══██║██║███╗██║██║╚██╗██║
    ███████╗██╔╝ ██╗██║  ██║       ███████║██║     ██║  ██║╚███╔███╔╝██║ ╚████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚══════╝╚═╝     ╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═══╝

    🐺 LXR Core - Spawn Selection Client

    Shows the option list the server built, flies the camera over the hovered
    location and performs the teleport the server ordered. Controls are locked
    only while the UI is open.

    Developer:   iBoss21 / LXRCore
    Website:     https://www.lxrcore.com
    © 2026 iBoss21 / LXRCore | lxrcore.com | All Rights Reserved
]]

local LXRCore = exports['lxr-core']:GetCoreObject()
local LXR = exports['lxr-core']:GetLXR()

local ui = { open = false, cam = nil, cam2 = nil, options = {} }

local function destroyCams()
    RenderScriptCams(false, true, 500, true, true)
    if ui.cam then DestroyCam(ui.cam, true) end
    if ui.cam2 then DestroyCam(ui.cam2, true) end
    ui.cam, ui.cam2 = nil, nil
end

local function flyTo(coords)
    local c = Config.Camera
    if DoesCamExist(ui.cam or -1) then DestroyCam(ui.cam, true) end
    if DoesCamExist(ui.cam2 or -1) then DestroyCam(ui.cam2, true) end
    ui.cam2 = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', coords.x, coords.y, coords.z + c.heightFar, -85.0, 0.0, 0.0, c.fov, false, 0)
    PointCamAtCoord(ui.cam2, coords.x, coords.y, coords.z + 50.0)
    SetCamActive(ui.cam2, true)
    RenderScriptCams(true, false, 0, true, true)
    ui.cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', coords.x, coords.y, coords.z + c.heightNear, -60.0, 0.0, 0.0, c.fov, false, 0)
    PointCamAtCoord(ui.cam, coords.x, coords.y, coords.z)
    SetCamActiveWithInterp(ui.cam, ui.cam2, c.nearMs, 1, 1)
    -- move the (invisible, frozen) ped under the camera so the world streams in
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z + 5.0, false, false, false, false)
end

local function controlLock()
    CreateThread(function()
        while ui.open do
            DisableAllControlActions(0)
            Wait(0)
        end
    end)
end

local function openUI(payload)
    ui.open = true
    ui.options = payload.options
    local ped = PlayerPedId()
    SetEntityVisible(ped, false, false)
    FreezeEntityPosition(ped, true)
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open', options = payload.options, isNew = payload.isNew, locale = payload.locale, server = payload.server, brand = LXRCore.Brand, lang = Config.Lang })
    controlLock()
    local first = payload.options[1]
    if first and first.coords then flyTo(first.coords) end
    DoScreenFadeIn(Config.General.fadeMs)
end

-- arrival protection: untouchable for Config.Protection.seconds, with a warning before it ends
local protectUntil = 0
local function protect(ped)
    local secs = Config.Protection.seconds or 0
    if secs <= 0 then return end
    protectUntil = GetGameTimer() + secs * 1000
    SetEntityInvincible(ped, true)
    LXRCore.Notify(Lang:t('info.protected', { s = secs }), 'info')
    CreateThread(function()
        local warned = false
        while GetGameTimer() < protectUntil do
            if not warned and protectUntil - GetGameTimer() <= (Config.Protection.warnAt or 0) * 1000 then
                warned = true
                LXRCore.Notify(Lang:t('info.protect_end'), 'info')
            end
            Wait(250)
        end
        SetEntityInvincible(PlayerPedId(), false)
    end)
end

local function closeUI()
    ui.open = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

-- Entry point from lxr-creator (Config.Integrations.afterSelect / afterCreate): (cData, isNew)
RegisterNetEvent('lxr-spawn:client:setupSpawnUI', function(_, isNew)
    CreateThread(function()
        local payload = LXRCore.Callback.Await('lxr-spawn:server:options', isNew == true)
        if not payload then return end
        if payload.skipSingle and #payload.options == 1 then
            TriggerServerEvent('lxr-spawn:server:choose', payload.options[1].id)
            return
        end
        openUI(payload)
    end)
end)

-- Server-ordered teleport
RegisterNetEvent('lxr-spawn:client:spawnAt', function(coords, isNew)
    CreateThread(function()
        closeUI()
        DoScreenFadeOut(Config.General.fadeMs)
        Wait(Config.General.fadeMs)
        destroyCams()
        local ped = PlayerPedId()
        SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, false)
        SetEntityHeading(ped, coords.w or 0.0)
        Wait(300)
        FreezeEntityPosition(ped, false)
        SetEntityVisible(ped, true, false)
        LXR.Player.Spawned()   -- lxr:client:loaded here, lxr:player:spawned on the server
        Wait(400)
        DoScreenFadeIn(Config.General.fadeMs)
        if isNew and Config.General.newCharacterEvent then
            TriggerEvent(Config.General.newCharacterEvent)
        end
        protect(ped)
    end)
end)

-- ── NUI ──────────────────────────────────────────────────────────────────────
RegisterNUICallback('preview', function(data, cb)
    cb({})
    if not ui.open or type(data) ~= 'table' then return end
    for _, opt in ipairs(ui.options) do
        if opt.id == data.id and opt.coords then flyTo(opt.coords) break end
    end
end)

RegisterNUICallback('choose', function(data, cb)
    cb({})
    if not ui.open or type(data) ~= 'table' or type(data.id) ~= 'string' then return end
    TriggerServerEvent('lxr-spawn:server:choose', data.id)
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if ui.open then
        closeUI()
        destroyCams()
        FreezeEntityPosition(PlayerPedId(), false)
        SetEntityVisible(PlayerPedId(), true, false)
    end
end)
