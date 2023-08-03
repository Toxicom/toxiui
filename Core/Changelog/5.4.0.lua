local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["5.4.0"] = {
  HOTFIX = true,
  CHANGES = {
    "* General",
    " Improve Luxthos WA Link -- now you will get a generated link that's appropriate for your class",
    " Fix chat badges",
    "* Misc",
    " Update Discord link",
    " Add YouTube link",
    " Update the required minimal " .. F.String.ElvUI("ElvUI") .. " version to 12.79",
  },
}
