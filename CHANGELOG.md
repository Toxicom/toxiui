# ToxiUI v7.2.0-beta.2 - 2026-01-25

## ‼️ Breaking Changes

- Remove **Gradient Mode**
  - Gradient Mode might return in a future release; uncertain for now.
- Remove and refactor a large number of Text Tags
- This is a **major patch** — you will be forced to run the installer again
- Remove **Plater** profile
  - With scripting and modding being limited by Blizzard, we no longer see the upside of using Plater over ElvUI Nameplates.
- Remove **WeakAuraAnchor** module and related code
- Remove all mentions of **WeakAuras**
  - RIP

## 🚀 New Features

- **Animations** plugin
  - Animate the opening of Blizzard frames
  - Enabled by default
  - Can be configured per-frame in Animations settings
  - _ToxiUI Settings → Plugins → Animations_
- **Smooth Bars** toggles section
  - _Skins → ElvUI → Smooth Bars_
- Profile for **ElvUI Nameplates**

## 🐛 Bug Fixes

- Fix Dark Mode transparency issue with class color backdrops
- Fix Dark Mode transparency issues caused by changes in ElvUI structure
- Potentially fix SpecSwitch icons not showing in Classic versions

## 🧩 Profile Updates

- **ToxiUI**: Update Dark Mode profile to more closely match the former Gradient Mode profile
- **ElvUI**: Update profile for new cooldown settings
- **ElvUI**: Update which Text Tags are used
- **ElvUI**: Switch action bars and auras to a 3:2 aspect ratio (from 4:3)
- **ElvUI**: Add UnitFrame class backdrop for Dark Mode
- **ElvUI**: Show Power & Class bars by default with new positioning
  - Classic action bars style no longer repositions Power & Class bars, as they now share the default position.

## 📘 Documentation

- Increase minimum required **ElvUI** version to `14.07`
- Update Random Tips
- Update for **Midnight** patch 12.0.0

## 🧰 Development Improvements

- Stabilize installer **Turbo Mode**
