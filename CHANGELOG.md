# ToxiUI v7.2.3 - 2026-02-05

## 🚀 New Features

- `tx:classicon:reverse` tag
- [Retail] Damage Meter skin

## 🐛 Bug Fixes

- [Retail] Fix **WunderBar** paragon faction tracking
- [Retail] Do not sync CDM bars width in combat
- [Retail] Do not sync CDM bars width when receiving invalid values (e.g. `1.0000932`)

## 🧩 Profile Updates

- **ElvUI**: Use the new reverse class icon tag for Target and Focus UnitFrames
- **ElvUI**: Adjust Target Marker Icon size and position for Player, Target, Focus, Party, Boss, and Arena UnitFrames
- **ElvUI**: Adjust Arena/Boss/Party UnitFrame size, spacing, and text positions
- **ElvUI**: Remove Arena UnitFrame PvP Spec Icon
- **ElvUI**: Add class icon tag to Arena UnitFrames
- **ElvUI**: Update Death Knight class resource colors
- **ElvUI**: Update Nameplate colors
  - With the move to nameplates, most UnitFrame colors were ported over
- **ElvUI**: Bring back SHORTENED, ABBREVIATED, and SPLIT name tags as secret-safe
  - These will no longer abbreviate, shorten, or split on secret units
- **ElvUI**: Update UnitFrame and Nameplate texts with the “new” tags
- **WindTools**: Enable Extend Merchant Pages by default
- Set `nameplateSelectedScale` CVar to `1.5` during installer/profile application

## 📘 Documentation

- Re-enable Gradient Mode by default
- Increase minimum required **ElvUI** version to `15.03`

## ♻️ Settings Refactoring

- [Retail] Update **ToxiUI** installer text for **Details**, indicating it is no longer recommended
- [Retail] Update information in CDM Fading skin description

## 🧰 Development Improvements

- Refactor `F.Dpi()`, `F.Position()`, and their usage
  - No intended user-facing changes, but some positioning/sizing differences may occur
  - Pure developer QoL refactor
  - Some values may slightly change in the future (e.g. `52 → 50`)
- [Retail] Improve CDM Bars width sync performance by caching the last width value
- [Retail] Use `OnSizeChanged` for syncing CDM Bars width instead of `OnDataChanged`
