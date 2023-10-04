local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.4.2"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "Remove WeakAuras skinning feature from " .. TXUI.Title .. F.String.Sublist("WeakAuras v5.7.2 removed skinning support for other AddOns"),

    "* New features",

    "* Bug fixes",
    TXUI.Title .. ": Potentially fix Details dark theme gradient name error for Neltharus Weapons etc.",
    TXUI.Title .. ": Fix Mining profession for WunderBar in Classic Era",

    "* Profile updates",

    "* Documentation",
    "Increase minimum required " .. F.String.ElvUI() .. " version to 13.42",

    "* Settings refactoring",

    "* Development improvements",
  },
}
