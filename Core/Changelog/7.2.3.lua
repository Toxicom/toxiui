local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.2.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* New features",
    F.String.ToxiUI("[tx:classicon:reverse]") .. " tag",
    F.String.Retail() .. "Damage Meter skin",

    "* Bug fixes",
    F.String.Retail() .. ": Fix WunderBar paragon faction tracking",
    F.String.Retail() .. ": Do not sync " .. F.String.CDM() .. " bars width in combat",
    F.String.Retail() .. ": Do not sync " .. F.String.CDM() .. " bars width when a stupid value comes, like 1.0000932",

    "* Profile updates",
    F.String.ElvUI() .. ": Use the new reverse class icon tag for Target and Focus UnitFrames",
    F.String.ElvUI() .. ": Adjust Target Marker Icon size and position for Player, Target, Focus, Party, Boss, and Arena UnitFrames",
    F.String.ElvUI() .. ": Adjust Arena/Boss/Party UnitFrame size, spacing and text positions",
    F.String.ElvUI() .. ": Remove Arena UnitFrame's PvP Spec Icon",
    F.String.ElvUI() .. ": Add class icon tag to Arena UnitFrames",
    F.String.ElvUI() .. ": Update Death Knight class resource colors",
    F.String.ElvUI() .. ": Update Nameplate colors" .. F.String.Sublist("Now that we use nameplates, had to port over most of the UnitFrame colors to Nameplates"),
    F.String.ElvUI() .. ": Bring back SHORTENED, ABBREVIATED, SPLIT name tags secret-safe, meaning they will not abbreviate, shorten or split on secret units",
    F.String.ElvUI() .. ": Update UnitFrame and Nameplate texts with 'new' tags",
    F.String.WindTools() .. ": Enable Extend Merchant Pages by default",
    "Set nameplateSelectedScale CVar to 1.5 during installer/profile application",

    "* Documentation",
    "Re-enable Gradient Mode by default",
    F.String.MinElv("15.03"),

    "* Settings refactoring",
    F.String.Retail() .. ": Update " .. TXUI.Title .. " installer text for " .. F.String.Details() .. ", indicating that it's no longer recommended",
    F.String.Retail() .. ": Update information in " .. F.String.CDM() .. " Fading description",

    "* Development improvements",
    "Refactor F.Dpi(), F.Position() and their usage" --
      .. F.String.Sublist("For the user, absolutely nothing should change, but there might be some positioning/sizing changes that were not intended!")
      .. F.String.Sublist("This change is purely QoL for myself as a developer")
      .. F.String.Sublist("In the future, because of this change, some values may slightly change (eg from 52 to 50 etc.)"),
    F.String.Retail() .. "Improve " .. F.String.CDM() .. " Bars width sync performance by caching last width value",
    F.String.Retail() .. "Use the OnSizeChanged hook for syncing CDM Bars width instead of OnDataChanged",
  },
}
