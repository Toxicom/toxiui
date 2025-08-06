local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.3.1"] = {
  HOTFIX = true,
  CHANGES = {
    "* New features",
    F.String.WarpDeplete() .. " " .. TXUI.Title .. " profile",
    F.String.OmniCD() .. "  " .. TXUI.Title .. " profile",
    "WunderBar visibility option - " .. F.String.RandomClassColor("Resting & Mouseover"),
    F.String.Scaling() .. " feature! Customize it in " .. F.String.Menu.Plugins() .. " -> " .. F.String.Scaling(),
    F.String.Class("Class colored") .. " indicators for cooldown text. Credits to " .. F.String.Color("Nalar", "561c75"),
    F.String.ToxiUI("Wrath: ") .. F.String.ReforgedArmory() .. " " .. TXUI.Title .. " profile",

    "* Profile updates",
    "Change default WunderBar's accent color to " .. F.String.Class("class color"),
    "Disable " .. TXUI.Title .. " VehicleBar by default",
    "Increase the padding between ActionBars",
    "Increase buttons per row for minimap bar",
    "Change Details tooltip bar color to match brand color",

    "* Bug fixes",
    "Fix Boss & Arena UnitFrames toggling for Dark Mode",
    F.String.ToxiUI("Wrath: ") .. "Fix Specialization icons for Assassination Rogue and Holy Priest",
    "Revert some changes for Vanilla API. Now the Vanilla API is more in line with Wrath's",

    "* Font fixes & updates",
    "Fix pet castbar fonts",
    "Fix debuff timer font",
    "Fix buff/debuff font & font size",
    "Fix Details missing fonts",
    "Fix Plater Buff Special font size",
    "Fix Boss & Arena UnitFrame fonts",
    "Revert combat font to " .. F.String.RandomClassColor("- M 900"),
    "Primary font for actionbars",

    "* Documentation",
    "New changelog format, please provide feedback if this is easier to read",
    "Update installer dialog texts & information",
    "Update " .. TXUI.Title .. " brand color from " .. F.String.Color("old", "00e4f5") .. " to " .. F.String.ToxiUI("new") .. " to better match the " .. TXUI.Title .. " logo",
    F.String.ToxiUI("Wrath: ") .. "Add link to " .. F.String.ReforgedArmory() .. " in " .. TXUI.Title .. " " .. F.String.Menu.Armory() .. " settings",
  },
}
