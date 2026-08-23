local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.5.4"] = {
  HOTFIX = true,
  RELEASE_DATE = "Aug 23, 2026",
  CHANGES = {
    "* Bug fixes",
    F.String.Retail() .. "Potentially fix Armory's nil string error",

    "* Documentation",
    F.String.MinElv("15.25"),
  },
}
