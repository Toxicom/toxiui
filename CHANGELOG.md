# ToxiUI v7.3.2 - 2026-02-26

**Full Changelog**: https://github.com/Toxicom/toxiui/compare/v7.3.1...v7.3.2

## 🚀 New Features

- Due to popular demand, revert the removal of **ToxiUI** **ElvUI** skin
  - Do be aware that it's known to bug out and there currently will not be much effort into fixing it
- Option to delete a character from Played data
- **WunderBar** Hearthstone: Replace secondary Hearthstone right-click with a flyout for Additional Teleports
  - All Additional Teleports are now enabled by default
- **WunderBar** Hearthstone: Add raid teleports to M+ flyout
- [Retail] Add minimum width slider to bars sync functionality of **ToxiUI Cooldown Manager Skin**
- [Retail] Option to hide floating player entry on the Damage Meter
  - Enabled by default
  - Credits to **Kryo**
- [Retail] Stylized specialization icon for **Devourer Demon Hunter**
  - Thank youuu **Shaz** <3 <3 <3

## ✨ Enhancements

- Update **Gradient** colors for classes except for **Hunter**, **Shaman** and **Rogue**
- Update **Gradient** colors for **Priest**
  - Previous color had a blue tint to it which resulted in the backdrop being dark blue, which looked very wrong
- Add borders to the played graph bars for the Game Menu Skin
- [Retail] Enable the Cooldown Manager in Blizzard settings if **ToxiUI Cooldown Manager Skin** is enabled
- [Retail] Display Essence on `[tx:power]` tag for **Evokers**
- [Retail] Reverse **Gradient** direction for Damage Meter gradients
- [Retail] Hide mana text for feral & guardian druids in human form

## 🐛 Bug Fixes

- Fix flyout buttons retaining cooldown state when reused across different flyout menus
- Fix Class Bar position after updating if Power Bar is disabled
- **WunderBar** MicroMenu: Block talent and spell icons from clicks in combat
- Fix missing requirement strings in Status Report window
- Vehicle Bar gradient colors should update dynamically
- Do not register played time events for Game Menu Skin if the feature is disabled in settings
- Do not request time played if it had already been requested by another addon to avoid duplicate chat messages
- [Retail] Protect **WunderBar** currency tooltip in combat
- [Retail] Skip anchoring and centering for the **ToxiUI Cooldown Manager Skin** if a viewer's orientation is vertical
- [Retail] Hide the debuff border for **ToxiUI Cooldown Manager Skin** icons if centering is enabled
  - This is a bandaid fix, hopefully ElvUI fixes it properly in the future
- [Retail] Update keybinds for **ToxiUI Cooldown Manager Skin** when changing shapeshift forms
- [Retail] Buff icons position for DK and Brewmaster Monk fixed in **ToxiUI Cooldown Manager Skin**

## 🧩 Profile Updates

- **ElvUI**: Nudge raid frames to the left
  - Now that they're bigger due to the requirement to fit buffs and debuffs inside of it, have to save space
- **ElvUI**: Adjust spacing for player, target, focus unitframes auras

## 📘 Documentation

- Add **Kryo** to contributors list
- Increase minimum required **ElvUI** version to 15.06
- [Retail] **WunderBar** Hearthstone: Update data adding some missing spells and toys, including Midnight ones

## ♻️ Settings Refactoring

- [Retail] Add notes to the **ToxiUI Cooldown Manager Skin** for horizontal orientation
- Sort **Gradient** mode's classes in settings
