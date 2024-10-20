local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.8.8"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Bug fixes",

    "* Profile updates",
    F.String.ElvUI() .. ": Change party/arena offset to use dynamic calculation" .. F.String.Sublist("This should revert the position to previous for non-ultrawide users"),

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
