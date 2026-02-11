# ToxiUI v7.2.6 - 2026-02-11

## 🚀 New Features

- **Performance** tab in **ToxiUI** settings
- [Retail] Anchoring section in **ToxiUI Cooldown Manager Skin**
- [Retail] Add option to sync Player Castbar width in **ToxiUI Cooldown Manager Skin**
- [Retail] Disabling Dynamic Width options in **ToxiUI Cooldown Manager Skin** will restore previous width
  - Will not save previous width if enabled before this update
- [Retail] Add Cooldown Manager slash commands to toggle settings
  - /cd
  - /cdm
  - /wa

## ✨ Enhancements

- [Retail] Display percentage mana for **Arcane Mages** with the `[tx:power]` tag
- Try displaying class icon when spec icon is not available for both `[tx:classicon]` tags
  - This is most noticeable in follower dungeons
- [Retail] Enable **ToxiUI Cooldown Manager Skin** by default

## 🐛 Bug Fixes

- [Retail] Potentially fix Damage Meter Skin taint when opening damage breakdown
- [Retail] Floor the dynamic bar width value for the **ToxiUI Cooldown Manager Skin**
- [Retail] Improve fading logic for **ToxiUI Cooldown Manager Skin**
- [Retail] Do not try to change Damage Meter icon if it has a spell ID
- [Retail] Fix Damage Meter Skin's header fading due to **ElvUI** changes

## 📘 Documentation

- [Retail] Update for patch 12.0.1
- Increase minimum required **ElvUI** version to 15.05

## ♻️ Settings Refactoring

- Update **ToxiUI ElvUI Skin** description
- [Retail] Update **ToxiUI Cooldown Manager Skin** description

## 🔧 Development Improvements

- [Retail] Refactor **ToxiUI Cooldown Manager Skin** for better structure
- Remove `P.blizzardFonts` from code -- we don't have that functionality for months now
