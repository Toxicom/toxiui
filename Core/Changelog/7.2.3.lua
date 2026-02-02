local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.2.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "tx:classicon:reverse tag",
    F.String.Retail() .. "Damage Meter skin",

    "* Bug fixes",

    "* Profile updates",
    F.String.ElvUI() .. ": Use the new reverse class icon tag for Target and Focus UnitFrames",
    F.String.ElvUI() .. ": Adjust Target Marker Icon size and position for Player, Target, Focus, Party, Boss, and Arena UnitFrames",
    F.String.ElvUI() .. ": Adjust Arena/Boss/Party UnitFrame size, spacing and text positions",
    F.String.ElvUI() .. ": Remove Arena UnitFrame's PvP Spec Icon",
    F.String.ElvUI() .. ": Add class icon tag to Arena UnitFrames",
    F.String.ElvUI() .. ": Update Death Knight class resource colors",
    F.String.WindTools() .. ": Enable Extend Merchant Pages by default",
    "Set nameplateSelectedScale CVar to 1.5 during installer/profile application",

    "* Documentation",
    "Re-enable Gradient Mode by default",

    "* Settings refactoring",
    F.String.Retail() .. ": Update " .. TXUI.Title .. " installer text for " .. F.String.Details() .. ", indicating that it's no longer recommended",

    "* Development improvements",
    "Refactor F.Dpi(), F.Position() and their usage" --
      .. F.String.Sublist("For the user, absolutely nothing should change, but there might be some positioning/sizing changes that were not intended!")
      .. F.String.Sublist("This change is purely QoL for myself as a developer")
      .. F.String.Sublist("In the future, because of this change, some values may slightly change (eg from 52 to 50 etc.)"),
    F.String.Retail() .. "Improve CDM Bars width sync performance by caching last width value",
    F.String.Retail() .. "Use the OnSizeChanged hook for syncing CDM Bars width instead of OnDataChanged",
  },
}
