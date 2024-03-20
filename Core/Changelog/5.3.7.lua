local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["5.3.7"] = {
  HOTFIX = true,
  CHANGES = {
    "* Bug fixes",
    "Fix " .. F.String.ElvUI("Shadow & Light") .. " Vehicle Bar conflict error",

    "* Documentation",
    "Update for Patch 9.2: Eternity's End",
    F.String.MinElv("12.65"),
  },
}
