local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.6.2"] = {
  HOTFIX = true,
  RELEASE_DATE = "Nov 09, 2026",
  CHANGES = {
    "* New features",
    F.String.GradientMode()
      .. ": Nameplates"
      .. F.String.Sublist("ElvUI nameplate health now uses gradients, sharing the class, NPC and state colors with your UnitFrames")
      .. F.String.Sublist("New editable threat and classification gradient colors"),

    "* Bug fixes",
    F.String.GradientMode() .. ": Follower dungeon NPCs now get their class colors right away instead of after a " .. F.String.ToxiUI("/reload"),

    "* Documentation",
    "Random tips: Added a lot of new tips and refreshed outdated ones" .. F.String.Sublist("Some tips are only shown on clients where the feature exists"),
    F.String.MinElv("16.01"),
  },
}
