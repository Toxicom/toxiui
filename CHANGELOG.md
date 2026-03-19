# ToxiUI v7.3.7 - 2026-03-19

**Full Changelog**: <https://github.com/Toxicom/toxiui/compare/v7.3.6...v7.3.7>

## ‼️ Breaking Changes

- Remove action bar styles
  - Buggy code that never worked correctly
  - With individual Profile Updater, no longer that useful
- Remove `ThemeThreatGlow` module
  - Caused taint errors spamming in combat

## 🚀 New Features

- Individual update option in Profile Updater
- [Retail] Option to enable Damage Meter reset on new instances
- [Retail] **WunderBar** Hearthstone: Option to select random hearthstone pool
- [Retail] Add `/em` chat command to open Edit Mode
- [Retail] **ToxiUI Cooldown Manager Skin**: Option to sync buff bars to player unitframe

## ✨ Enhancements

- Update diff display in Profile Updater
- [Retail] **ToxiUI Cooldown Manager Skin**: Hopefully improve code for when entering Edit Mode
- [Retail] Profile Updater: Do not display unitframe bar width updates if **ToxiUI Cooldown Manager Skin** dynamic width is enabled
- **WunderBar** Time: Add tooltip information
- **WunderBar** Time: Add middle-click to reload UI

## 🐛 Bug Fixes

- [Classic] [TBC] [Mists] Incorrect class icon showing on Game Menu Skin
- [Retail] **ToxiUI Cooldown Manager Skin**: Fix essential anchoring being disabled if only one of the class/power bars is disabled
- [Retail] Disable **ToxiUI Cooldown Manager Skin** when enabling classic action bar style
- Fix nameplate text tags not being in the profile

## 🧩 Profile Updates

- **ElvUI** Fonts: Update world/pvp (sub)zone texts
- **ElvUI** Fonts: Use correct settings for raid and tank unitframes
- **ElvUI** Nameplates: Enable classification colors, only in instances
- **ElvUI** Unitframes & Nameplates: Update filters to match **ElvUI** defaults

## 📘 Documentation

- Increase minimum required **ElvUI** version to `15.09`
- [Retail] **ToxiUI Cooldown Manager Skin**: Add **Frost Mage** by default to Power Bar Overrides
  - ElvUI 15.09 now shows icicles as class bar, so we can hide power bar
- [Retail] **ToxiUI Cooldown Manager Skin**: Enable all submodules by default
  - Main module is still disabled by default

## ♻️ Settings Refactoring

- [Retail] **ToxiUI Cooldown Manager Skin**: Display only current class specs in the overrides tab
  - Option to display all specs is available
- [Retail] **ToxiUI Cooldown Manager Skin**: Tidy up keybind settings
- [Retail] **ToxiUI Cooldown Manager Skin**: Refactor dynamic width settings to accomodate new options
- [Retail] Simplify the settings of Damage Meter skin
- Add `Commands` tab in General **ToxiUI** settings
- Display **ToxiUI** badges in the Credits section
- Allow font scale slider to go from `-5` to `5`
  - Previously it was `-3` to `3`
- Add release dates to in-game changelogs from `v7.0.0` upwards

## 🔧 Development Improvements

- Rename `TitleRaid` to `TitleBold` internally
