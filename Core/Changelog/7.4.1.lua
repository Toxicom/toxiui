local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.4.1"] = {
  HOTFIX = true,
  RELEASE_DATE = "Mar 25, 2026",
  CHANGES = {
    "* Bug fixes",
    F.String.Retail() .. F.String.CDM() .. " Keybinds: Lower strata to avoid overlap",
    F.String.Retail() .. F.String.CDM() .. " Centering: Buff bar width collapsing",
    F.String.GradientMode() .. ": Wrong colors on group unitframes",
  },
}
