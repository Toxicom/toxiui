# ToxiUI v7.3.1 - 2026-02-18

## ‼️ Breaking Changes

- Remove **ToxiUI** **ElvUI** Skin
  - Lately it's been causing issues
  - If it ever comes back, needs to be completely refactored from scratch

## 🚀 New Features

- Total time played information shown in **ToxiUI** Game Menu Skin
  - Credits to **Kryo**
- Add `KMT47` statusbar texture
  - Credits to **kringel**

## ✨ Enhancements

- Set 0.65 UI scale for non-standard resolutions
- Update default **Gradient** color for **Paladin**
  - Old values:
  - RIGHT: #F58CBA
- Update default **Gradient** color for **Mage**
  - Old values:
  - RIGHT: #33C7FC
- Update default **Gradient** color for **Demon Hunter**
  - Old values:
  - RIGHT: #5700F5
  - Credits to **Kryo**
- Bring back Gradient Mode to **ToxiUI** Status Report window
- Re-designed Status Report window
- Add a global toggle for the **ToxiUI Cooldown Manager Skin**
  - You will need to re-enable the CDM skin, as it's off by default
- Allow updating **ToxiUI Cooldown Manager Skin** options without requiring a reload of the UI

## 🐛 Bug Fixes

- [Retail] Improve anchoring and keybinds logic of **ToxiUI Cooldown Manager Skin**
- [Retail] [TBC] Fix error when disabling **Gradient** mode
- [Retail] Fix an icon indexing issue with **ToxiUI Cooldown Manager Skin**
  - Credits to **Kryo**
- [Retail] Allow anchoring to work in combat for **ToxiUI Cooldown Manager Skin**
  - This should potentially fix the issue of it randomly yeeting

## 🧩 Profile Updates

- [Retail] **WindTools**: Enable and update the Cooldown Viewer skin
- **ElvUI** & **WindTools**: Use the new `KMT47` texture

## 🔧 Development Improvements

- Refactor Game Menu Skin as it's own module with subfolder structure
- Refactor code for Status Report, makes it easier to add/remove lines and sections
