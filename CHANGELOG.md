# ToxiUI v7.3.5 - 2026-03-07

**Full Changelog**: <https://github.com/Toxicom/toxiui/compare/v7.3.4...v7.3.5>

## 🚀 New Features

- Class Icons style setting now controls all spec/class icon displays globally
- Class Icons can be previewed in the options
- [Retail] **ToxiUI Cooldown Manager Skin**: Option to align Buff Bar Viewer bars to the bottom of the viewer frame
- [Retail] Option to change spec icon for Damage Meter skin
- [Retail] **ToxiUI Cooldown Manager Skin**: Option to automatically disable `ElvUI Class Bar` per specialization
- [Retail] **ToxiUI Cooldown Manager Skin**: Option to automatically disable `ElvUI Power Bar` per specialization
- [Retail] New `[tx:power:classbar]` tag: displays power value only when the Player Power Bar is disabled

## ✨ Enhancements

- Show diff for fonts in Profile Updater
- Class-only icon displays (Played graph, spec fallbacks) respect the selected class icon style
- [Retail] Allow opening `/cdm` in combat

## 🧩 Profile Updates

- **ElvUI**: Update fonts for Cooldown Manager text (name, duration, count)
- **ElvUI**: Update nameplate auras fonts
- **ElvUI**: `ClassBarMover` is now always positioned above the Power Bar, regardless of power bar state
- **ElvUI**: Set Max Overflow back to 0
- **ElvUI**: Adjust nameplate quest icon fonts
- **ElvUI**: Disable automated friendly nameplates
- **WindTools**: Update objective tracker fonts

## 📘 Documentation

- [Retail] **WunderBar**: Add Wormhole Generator: Quel'thalas to Hearthstone module
- Increase minimum required **ElvUI** version to 15.08

## ♻️ Settings Refactoring

- Remove Details section from Class Icons settings
- Remove per-feature spec icon style selectors (Game Menu, AFK, Damage Meter) in favor of global Class Icons setting
- Reduce logo size in **ToxiUI** options
- Rename **ToxiUI** **ElvUI** Skin to Shadows & Grain Background
- [Retail] **ToxiUI Cooldown Manager Skin**: Add navigation buttons to related **ElvUI** and **WindTools** Cooldown Manager settings panels
- [Retail] **ToxiUI Cooldown Manager Skin**: Refactor settings into tabs for less scrolling

## 🔧 Development Improvements

- Simplify unitframe font config
- Extract `I.ClassOrder` and `I.ClassSpecOrder` to `InternalSpecs.lua` for shared use across options modules
