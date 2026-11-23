# ToxiUI v7.6.3 - 2026-11-23

**Full Changelog**: <https://github.com/Toxicom/toxiui/compare/v7.6.2...v7.6.3>

## 🚀 New Features

- [Forever] **WunderBar**: Achievements button in the MicroMenu now opens the Legacy system
  - Credits to bifferz for initial PR
- ElvUI: New `Max Width` option for Unit Frame Custom Texts and Nameplate names, long text gets cut off with '...'
  - Works on secret names in instances, which can't be shortened by tags
  - Found next to the other text settings in ElvUI options

## 📘 Documentation

- Increase minimum required **ElvUI** version to `16.02`

## ♻️ Settings Refactoring

- ElvUI settings that ToxiUI overrides are now greyed out with a note saying which feature controls them and where to change it
  - Covers Gradient Mode colors, Dark Mode transparency, AFK Mode, Armory, Action Bar visibility and the Cooldown Manager Class/Power Bar overrides
- ElvUI unit frame Text Format boxes now explain that ToxiUI uses Custom Texts instead, with a button to open them

## 🔧 Development Improvements

- Supporter badges are now self-service: Patreon supporters register their characters with `/supporter register` in Discord
  - Use `/tx export names` in game to get your registration code
  - The old hand-maintained supporter list has been retired, please register to keep your badge
