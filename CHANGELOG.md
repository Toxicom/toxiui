# ToxiUI v7.4.4 - 2026-04-22

**Full Changelog**: <https://github.com/Toxicom/toxiui/compare/v7.4.3...v7.4.4>

## 🐛 Bug Fixes

- SetFont() errors

## 📘 Documentation

- [Retail] Update for patch 12.0.5
- Increase minimum required **ElvUI** version to `15.12`

## 🔧 Development Improvements

- Performance: Gradient mode health/power/castbar color updates no longer allocate a closure per tick
- Performance: Unit tags pre-compute class/reaction color prefixes at init instead of rebuilding per tick
- Performance: Replace per-frame `OnUpdate` with on-demand flush for deferred events
- WunderBar SecureFlyOut: Replace per-frame cooldown updates with a `0.5s` ticker
- Vehicle Bar Vigor Bar: Replace per-frame animation with a `0.05s` ticker
