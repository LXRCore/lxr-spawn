# 🐺 LXR-Spawn

## Spawn Selection System — The Land of Wolves

![Version](https://img.shields.io/badge/Version-1.0.1-brightgreen)
![Build](https://img.shields.io/badge/Build-Stable-blue)
![Framework](https://img.shields.io/badge/Framework-LXRCore%20%7C%20RSG%20%7C%20VORP-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-RedM-black)
![Author](https://img.shields.io/badge/Author-iBoss21%20%2F%20The%20Lux%20Empire-orange)
![Store](https://img.shields.io/badge/Store-theluxempire.tebex.io-purple)

> **🐺 wolves.land** — The Land of Wolves | Developed by iBoss21 / The Lux Empire
>
> 🌐 Website: https://www.wolves.land | 💬 Discord: https://discord.gg/CrKcWdfd3A | 🛒 Store: https://theluxempire.tebex.io

---

## 📸 Screenshots

![Spawn](https://cdn.discordapp.com/attachments/1021700112776437760/1183161143800373409/image.png?ex=658753ae&is=6574deae&hm=8f35526c88469d9326f1e031376698c0801e593e019e179b0061146fed76e9b0&)
![Spawn2](https://cdn.discordapp.com/attachments/1021700112776437760/1183160768309497886/image.png?ex=65875355&is=6574de55&hm=856dbd8cc38fef03d729dc56db7e3370105aa382870db469b63ba8ac942b7a27&)

## ✨ Features

- Ability to select spawn location after selecting your character.
- Configurable spawn points with flexibility in selecting cities, towns, or custom locations.
- Seamless integration with LXRCore, RSG Core, VORP Core, and multi-character system.
- Resource name protection to ensure Tebex escrow compliance.

## 🔗 Dependencies

- **lxr-core**
- **lxr-multicharacter**

## 🚀 Installation

1. **Download the script** and place it in the `[lxr]` directory.

2. **Add the following lines** to your `server.cfg` or `resources.cfg`:

   ```bash
   ensure lxr-core
   ensure lxr-multicharacter
   ensure lxr-spawn
   ```

## ⚙️ Configuration

Configure spawn points in `config.lua`. You can customize spawn locations, enable/disable house or apartment spawns, and toggle random spawn mode.

```lua
LXR.EnableHouses      = false  -- Enable house spawning
LXR.EnableApartments  = false  -- Enable apartment spawning
LXR.EnableRandomSpawn = true   -- Random spawn on first join
```

## 📜 License

```
LXR-Spawn
Copyright (C) 2026 iBoss21 / The Lux Empire | wolves.land

This program is licensed under the MIT License. You may redistribute and/or
modify it under the terms of the MIT License.

This software is distributed as-is, without any warranties or guarantees.
Please see the MIT License for more details.

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
```

---

*🐺 wolves.land — The Land of Wolves | The Lux Empire*