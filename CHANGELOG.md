# ToxiUI v7.4.4 - 2026-04-20

**Full Changelog**: <https://github.com/Toxicom/toxiui/compare/v7.4.3...v7.4.4>

## 🔧 Development Improvements

- Performance: Gradient mode health/power/castbar color updates no longer allocate a closure per tick
- Performance: Unit tags pre-compute class/reaction color prefixes at init instead of rebuilding per tick
- Performance: Replace per-frame `OnUpdate` with on-demand flush for deferred events
- WunderBar SecureFlyOut: Replace per-frame cooldown updates with a `0.5s` ticker
- Vehicle Bar Vigor Bar: Replace per-frame animation with a `0.05s` ticker
