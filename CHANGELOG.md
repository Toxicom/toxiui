# ToxiUI v7.5.0 - 2026-08-13

**Full Changelog**: <https://github.com/Toxicom/toxiui/compare/v7.4.9...v7.5.0>

## 🚀 New Features

- Add WunderBar Durability module's middle-click to summon an Auction House mount
  - Credits to bifferz

## 🐛 Bug Fixes

- Replace old usage of E:UpdateAll()
- Fix WunderBar DataBar's max level check erroring after a recent API change
  - Falls back to the old API on Classic/Anniversary where the new one isn't available

## 📘 Documentation

- Increase minimum required **ElvUI** version to `15.21`

## 🔧 Development Improvements

- Fix the `/tx dev export names` command
  - Rewrite to use CBOR encoding instead of AceSerializer/LibDeflate
  - Credits to Tibs
