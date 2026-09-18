<!--
    lxr-spawn — LXRCore spawn selection
    Developer: iBoss21 / LXRCore · https://www.lxrcore.com
    © 2026 iBoss21 / LXRCore | lxrcore.com | All Rights Reserved
-->

<img src="https://raw.githubusercontent.com/LXRCore/.github/main/profile/lxrcore-logo.png" alt="LXRCore" width="72" align="left" style="margin-right:12px">

# lxr-spawn — Spawn selection for LXRCore v3

![Version](https://img.shields.io/badge/version-3.0.0-c21c37)
![Core](https://img.shields.io/badge/requires-lxr--core_v3-1a1512)
![NUI](https://img.shields.io/badge/NUI-vanilla_%C2%B7_no_CDN-brightgreen)

After `lxr-creator` selects or creates a character it fires
`lxr-spawn:client:setupSpawnUI(cData, isNew)`. This resource asks the server
for the allowed options, lets the player pick one with a fly-over camera and
performs the teleport the **server** ordered.

![The spawn picker](docs/img/spawn.png)


## Why v2

| v1 | v2 |
|---|---|
| NUI sent coordinates the client chose | client sends an **id**; the server resolves it from `Config.Spawns` / `Config.FirstSpawns` / last position and rejects anything else |
| jQuery from a CDN | vanilla HTML/CSS/JS, LXRCore design tokens |
| FiveM apartment / house hooks | removed; `jobs` restriction per spawn point instead |
| control-lock loop always running | loop only while the UI is open |

## Config

`Config.Spawns` (existing characters), `Config.FirstSpawns` (new
characters), `Config.General.allowLastPosition / allowRandom /
skipUIWhenSingle / newCharacterEvent`, camera heights. Optional `jobs = { 'vallaw' }`
on a spawn point restricts it.

## Events

| Name | Side | |
|---|---|---|
| `lxr-spawn:client:setupSpawnUI(cData, isNew)` | client | open the chooser |
| `lxr-spawn:server:options(isNew)` | callback | option list for the loaded character |
| `lxr-spawn:server:choose(id)` | net | validated choice |
| `lxr-spawn:client:spawnAt(coords, isNew)` | client | teleport ordered by the server |
| `lxr-spawn:server:spawned(src, id, coords, isNew)` | server | for other resources |

After the teleport the client fires `LXRCore:Server:OnPlayerLoaded` and
`LXRCore:Client:OnPlayerLoaded` (the framework's spawn signal).

## Verification

Lua / JS syntax ✅ · in-game flow **NOT TESTED** yet.

> © 2026 iBoss21 / LXRCore | [lxrcore.com](https://www.lxrcore.com) | All Rights Reserved
