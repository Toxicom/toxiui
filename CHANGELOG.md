# ToxiUI v7.2.2 - 2026-01-29

## ‼️ Breaking Changes

- Remove Wardrobe frame from Animations and Scaling modules
  - It’s already covered by the Collections Journal frame

## 🚀 New Features

- [Retail] Cooldown Manager fading option
- [Retail] Cooldown Manager dynamic bars width option
- Bring back **ToxiUI Gradient Mode** **[WIP]**

## 🐛 Bug Fixes

- Fix CDM Action Bars Style yeeting the power bar
- Crop Vehicle Bar buttons so they’re not squished

## 🧩 Profile Updates

- [Retail] **ToxiUI**: Edit shown power text for certain classes and specs
  - This change does **not** require you to re-run the installer
  - Hide Frost and Fire Mage power text
  - Hide Enhancement Shaman power text
  - Display Holy Power for Paladins
- [Retail] **ElvUI**: Style CDM cooldown text
- **ElvUI**: Use responsive values for Nameplate settings
  - For resolutions other than `0.5333333`, nameplates should now have better sizing

## 📘 Documentation

- Add **Liue** to the contributors list
- Increase minimum required **ElvUI** version to `15.02`
- [TBC] Add Naaru’s Embrace Hearthstone to **WunderBar** Hearthstone module
- [TBC] Add Stonard and Theramore portals to **WunderBar** Hearthstone module

## ♻️ Settings Refactoring

- Update **ToxiUI** installer description for the profile step to highlight the risk of overwriting an existing profile

## 🧰 Development Improvements

- Defer Gradient Mode initialization to the next frame after initial load
  - Helps avoid “script ran too long” issues
  - Causes a small load-time micro-stutter, but prevents the module from breaking
