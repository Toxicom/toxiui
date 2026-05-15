local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.4.6"] = {
  HOTFIX = true,
  RELEASE_DATE = "May 15, 2026",
  CHANGES = {
    "* Bug fixes",
    F.String.Retail() .. "Damage Meter: Fix the 'Hide Floating Player Entry' option",
    F.String.Retail() .. "Armory: Safeguard stats in combat" .. F.String.Sublist("Funky fix, might still break"),
  },
}
