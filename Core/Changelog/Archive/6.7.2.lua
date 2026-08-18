local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.7.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* Bug fixes",
    "Fix error for people who had Saturation Boost enabled prior to 6.7.1",

    "* Documentation",
    "Update " .. TXUI.Title .. " YouTube link",

    "* Development improvements",
    "Convert old Saturation Boost DB format to new one",
  },
}
