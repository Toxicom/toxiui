local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.2.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* Documentation",
    "Increase minimum required " .. F.String.ElvUI() .. " version",
    F.String.ToxiUI("Wrath: ") .. "Update for patch 3.4.2",
  },
}
