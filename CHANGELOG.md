# ToxiUI v7.4.0 - 2026-03-25

**Full Changelog**: <https://github.com/Toxicom/toxiui/compare/v7.3.9...v7.4.0>

## ‼️ Breaking Changes

- [Retail] Damage Meter: Remove the option for header fade
  - This functionality exists in WindTools (and is most likely better), no reason to maintain it
  - The only downside is that settings for it are stored in the private profile, so you will have to re-apply this for every character, if you're using separate private profiles

## ✨ Enhancements

- Profile Updater: Display color differences as a single HEX unit instead of separate R G B units
- Profile Updater: Add open & close animations
- [Retail] Cooldown Manager: Slightly stabler code due to using built-in Blizzard API instead of self made stuff
- [Retail] Cooldown Manager: Update keybind frame level to avoid situations where it's behind power bar
- Gradient Mode: Cache some function closures for potentially better performance
- Landing Page: Show profile updater button in update landing page
- Landing Page: Display images for both landing pages

## 🐛 Bug Fixes

- Gradient Mode: Safer castbar coloring code
- WunderBar Flyouts: Grow flyouts right when the module is in a left slot
- WunderBar Hearthstone: Fix re-enabling additional teleports

## 🧩 Profile Updates

- ElvUI Movers: Move raid frames
- ElvUI Movers: Adjust action bars positions
- ElvUI Unitframes: Re-position and re-size private auras for raid frames
- ElvUI Unitframes: Re-position buffs and role icon for party frames
- ElvUI Action Bars: Adjust buttons per row and button spacing
- WindTools: Change Damage Meter texture to KMT47
- WindTools: Setup Damage Meter fading options

## 📘 Documentation

- Increase minimum required **ElvUI** version to `15.10`
