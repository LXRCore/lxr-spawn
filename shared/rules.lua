--[[ ═══════════════════════════════════════════════════════════════════════════
     LXR-SPAWN — Shared rules: who may spawn where, what the card says
     © 2026 iBoss21 / LXRCore — All Rights Reserved
     ═══════════════════════════════════════════════════════════════════════════ ]]

LXRSpawn = LXRSpawn or {}
local S = LXRSpawn

---A spawn point is open to this job (no `jobs` list = everyone).
function S.Allowed(def, jobName)
    if not def.jobs then return true end
    for _, j in ipairs(def.jobs) do if j == jobName then return true end end
    return false
end

---Spawn ids of a pool in label order.
function S.Ordered(pool)
    local ids = {}
    for id in pairs(pool) do ids[#ids + 1] = id end
    table.sort(ids, function(a, b) return (pool[a].label or a) < (pool[b].label or b) end)
    return ids
end

---The nearest spawn point to a position: id, distance in game units (nil when the pool is empty).
function S.Nearest(pos, pool)
    local best, bestD
    for id, def in pairs(pool) do
        local c = def.coords
        local d = math.sqrt((pos.x - c.x) ^ 2 + (pos.y - c.y) ^ 2)
        if not bestD or d < bestD then best, bestD = id, d end
    end
    return best, bestD
end

---Game units → miles, one decimal.
function S.Miles(units) return math.floor(units * (Config.General.milesPerUnit or 0.000621) * 10 + 0.5) / 10 end

---Seconds ago → { unit = 'minutes'|'hours'|'days', n = number } for the "last seen" line.
function S.Ago(seconds)
    seconds = math.max(0, math.floor(seconds or 0))
    if seconds < 3600 then return { unit = 'minutes', n = math.max(1, math.floor(seconds / 60)) } end
    if seconds < 86400 then return { unit = 'hours', n = math.floor(seconds / 3600) } end
    return { unit = 'days', n = math.floor(seconds / 86400) }
end
