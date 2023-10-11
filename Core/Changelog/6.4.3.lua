local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.4.3"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Add new option to "
      .. F.String.ToxiUI("Additional Scaling")
      .. " module" -- comment to stop auto-formatting
      .. F.String.Sublist(F.String.Class("Talents Frame")),
    "Add option to disable whole " .. F.String.ToxiUI("Additional Scaling") .. " module",
    "Add " .. TXUI.Title .. " Raid Assist icons",
    F.String.Error("Experimental: ") .. "Add custom raid group number tag that shows group number only for first unit in a group",

    "* Bug fixes",
    TXUI.Title .. ": Remove the need to force-load AddOns when adjusting scale through " .. F.String.ToxiUI("Additional Scaling"),
    TXUI.Title .. ": Remove the need to reload when adjusting scale through " .. F.String.ToxiUI("Additional Scaling"),

    "* Profile updates",
    TXUI.Title .. ": Enable WunderBar's DataBar (Experience and Reputation bar) by default",
    TXUI.Title .. ": Enable WunderBar DataBar's Info Text by default",
    TXUI.Title .. ": Disable " .. F.String.ToxiUI("Additional Scaling") .. " module by default",
    TXUI.Title
      .. ": Reduce the step range for "
      .. F.String.ToxiUI("Additional Scaling")
      .. " module's option sliders" --
      .. F.String.Sublist("Now you can set the scaling to 0.05 precision"), --
    TXUI.Title
      .. ": Update inconsistency in internal font names" --
      .. F.String.Sublist("Title Raid -> Title Black") --
      .. F.String.Sublist("Title Secondary -> Title Raid"), --
    F.String.ElvUI() .. ": Update chat timestamp color to use " .. TXUI.Title .. " brand color",
    F.String.ElvUI() .. ": Update fonts to use the new 'Shadow' font outline",
    F.String.ElvUI() .. ": Add settings for new " .. F.String.ElvUI() .. " bag spinner animation when sorting bags",
    F.String.ElvUI() .. ": Add raid group number for raid frames",
    F.String.ElvUI() .. ": Move Addon Compartment down to avoid blocking the mail icon",

    "* Documentation",
    "Update .toc for Wrath 3.4.3",
    "Increase minimum required " .. F.String.ElvUI() .. " version to 13.44",

    "* Settings refactoring",

    "* Development improvements",
  },
}
