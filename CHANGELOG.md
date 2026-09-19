# Changelog — lxr-spawn

## 3.0.0 — 2026-09-19
* LXRCore v3 release line: every resource ships as 3.0.0 from here (the entries below are the road to it).

## [3.1.0] — 2026-09-18
- Place card: region, a line about the place (`place.<id>` in locales), what is in town as tags.
- "Where you left off" shows when the character was last seen and the distance to the nearest town.
- Arrival protection (`Config.Protection`): invincible for a few seconds after the teleport, toast before it ends.
- `shared/rules.lua` (Allowed / Ordered / Nearest / Miles / Ago) and offline tests with a `--mock` writer.
- Two screenshots.

## [3.0.0] — 2026-09-17
- Picker on the LXR UI Kit: index rows, kind tags, keyboard, both themes.

## [2.0.0] — 2026-09-17
- Rewrite for LXRCore v3: server-resolved spawn ids (no client coordinates), last-position and random options, job-restricted points, vanilla NUI, control lock only while open, en/ka locales.
- Removed FiveM apartment/house hooks and CDN jQuery.
