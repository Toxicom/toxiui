# ToxiUI v7.3.6 - 2026-03-09

**Full Changelog**: <https://github.com/Toxicom/toxiui/compare/v7.3.5...v7.3.6>

## 🐛 Bug Fixes

- Fix racial spells not showing icon in hearthstone's additional flyout

## 🧩 Profile Updates

- Set `nameplateOccludedAlphaMult` CVar to 0.8
- **ElvUI**: Add nameplates castbar width/height settings to profile
  - Previously it was using ElvUI default, so nothing changes.
- [Retail]**ElvUI**: Move PowerBarContainerMover to the right

## 📘 Documentation

- [Retail]Add Haranir Rootwalking to hearthstone module
- [Retail]Track Voidlight Marl instead of Resonance Crystals by default

## ♻️ Settings Refactoring

- Changelog: Category headers now render in uppercase
- Changelog: Update prefixes for in-game changelog entries
  - Main list items are now using a bullet
  - Sub list items are now using a chevron

## 🔧 Development Improvements

- Changelog: Remove unused `DYNAMIC` changelog field support
- Changelog: Archive all versions before v7.0.0
  - This should reduce the addon size
