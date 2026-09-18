--[[ ═══════════════════════════════════════════════════════════════════════════
     LXR-SPAWN — Offline tests: job gates, ordering, nearest town, "ago", locale parity
     Usage (from the lxr-spawn folder):  lua tests/run.lua [--mock out.js en|ka]
     © 2026 iBoss21 / LXRCore — All Rights Reserved
     ═══════════════════════════════════════════════════════════════════════════ ]]

local CORE = os.getenv('LXR_CORE_PATH') or '../lxr-core'
package.path = CORE .. '/?.lua;' .. package.path
local ok = pcall(function() require('tests.lib.fxshim') end)
if not ok then print('lxr-core shim not found at ' .. CORE) os.exit(2) end
local Shim = require('tests.lib.fxshim')
for _, f in ipairs({ 'shared/main.lua', 'shared/locale.lua', 'locales/en.lua', 'config.lua' }) do Shim.load(CORE .. '/' .. f) end
Config = nil Locale = nil
Shim.load('shared/locale.lua') Shim.load('locales/en.lua') Shim.load('locales/ka.lua') Shim.load('config.lua') Shim.load('shared/rules.lua')
local S = LXRSpawn

local passed, failed = 0, 0
local function test(name, fn) local okT, err = xpcall(fn, debug.traceback) if okT then passed = passed + 1 print('  ^ ok   ' .. name) else failed = failed + 1 print('  x FAIL ' .. name .. '\n' .. err) end end
local function eq(a, b, msg) if a ~= b then error((msg or 'eq') .. ': expected ' .. tostring(b) .. ' got ' .. tostring(a), 2) end end

print('lxr-spawn offline tests')
test('job gate', function()
    assert(S.Allowed({}, 'unemployed'))
    assert(S.Allowed({ jobs = { 'vallaw' } }, 'vallaw'))
    assert(not S.Allowed({ jobs = { 'vallaw' } }, 'valdoc'))
end)
test('spawns are ordered by label and every one has a card', function()
    local ids = S.Ordered(Config.Spawns)
    eq(#ids, 8)
    for i = 2, #ids do assert(Config.Spawns[ids[i - 1]].label < Config.Spawns[ids[i]].label, 'order') end
    for id, def in pairs(Config.Spawns) do
        assert(def.region and def.services and #def.services > 0, id .. ' card data')
        assert(Locale.Bundles.en['place.' .. id], id .. ' place line')
        for _, svc in ipairs(def.services) do assert(Locale.Bundles.en['ui.svc_' .. svc], svc) end
    end
    for id in pairs(Config.FirstSpawns) do assert(Locale.Bundles.en['place.' .. id], id) end
end)
test('nearest town and miles', function()
    local id, d = S.Nearest({ x = -370.0, y = 720.0, z = 116.0 }, Config.Spawns)
    eq(id, 'valentine') assert(d < 20)
    id = S.Nearest({ x = 2500.0, y = -1250.0, z = 50.0 }, Config.Spawns)
    eq(id, 'saintdenis')
    eq(S.Miles(1609.0), 1.0)
    assert(S.Nearest({ x = 0, y = 0, z = 0 }, {}) == nil)
end)
test('ago buckets', function()
    eq(S.Ago(30).unit, 'minutes') eq(S.Ago(30).n, 1)
    eq(S.Ago(7200).unit, 'hours') eq(S.Ago(7200).n, 2)
    eq(S.Ago(3 * 86400 + 5).unit, 'days') eq(S.Ago(3 * 86400 + 5).n, 3)
end)
test('locale parity', function()
    local en, ka = Locale.Bundles.en, Locale.Bundles.ka
    local missing = {}
    for k in pairs(en) do if ka[k] == nil then missing[#missing + 1] = k end end
    eq(#missing, 0, 'ka missing: ' .. table.concat(missing, ', '))
end)
print(('%d passed, %d failed'):format(passed, failed))
if arg and arg[1] == '--mock' and arg[2] then
    Config.Lang = arg[3] or 'en'
    local options = { { id = 'last', kind = 'last', label = Lang:t('ui.last_position'), coords = { x = -300, y = 800, z = 118 }, note = Lang:t('ui.last_note'), seen = { since = 5 * 3600 + 120, near = 'Valentine', miles = 2.1 } } }
    for _, id in ipairs(S.Ordered(Config.Spawns)) do
        local def = Config.Spawns[id]
        options[#options + 1] = { id = id, kind = 'town', label = def.label, region = def.region, coords = { x = def.coords.x, y = def.coords.y, z = def.coords.z }, note = Lang:t('place.' .. id), services = def.services }
    end
    options[#options + 1] = { id = 'random', kind = 'random', label = Lang:t('ui.random'), note = Lang:t('ui.random_note') }
    local f = assert(io.open(arg[2], 'w'))
    f:write('window.__LXR_MOCK__ = ' .. json.encode({ action = 'open', isNew = false, options = options, protection = Config.Protection.seconds, lang = Config.Lang, locale = Lang.bundle(), server = { name = 'The Land of Wolves', theme = 'night' } }) .. ';\n')
    f:close()
    print('mock written to ' .. arg[2])
end
os.exit(failed == 0 and 0 or 1)
