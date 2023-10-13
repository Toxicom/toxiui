local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.4.4"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Bug fixes",
    TXUI.Title .. ": WunderBar LFG fix in " .. F.String.ToxiUI("Wrath"),

    "* Profile updates",
    "Double UI scale for 2054 height screens",

    "* Documentation",
    "Increase minimum required " .. F.String.ElvUI() .. " version to 13.45",

    "* Settings refactoring",

    "* Development improvements",
    "Create a doubleResolutionScale table for easier tracking of 4k resolutions",
    "Remove tukui information from .toc files since we can no longer host there",
  },
}
