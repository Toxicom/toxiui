local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.4.6"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Add "
      .. F.String.ToxiUI("Smart Power")
      .. " tags" --
      .. F.String.Sublist("Smart Power tags change color to " .. F.String.Warning("yellow") .. " & " .. F.String.Error("red") .. " when getting low")
      .. F.String.Sublist("See new tags in " .. F.String.Class("Available Tags") .. ", they are prefixed with " .. TXUI.Title),

    "* Bug fixes",
    TXUI.Title .. ": Add missing " .. F.String.Class("Teleport: Moonglade") .. " in " .. F.String.ToxiUI("Wrath") .. " & " .. F.String.ToxiUI("Classic"),

    "* Profile updates",
    TXUI.Title .. ": Update Stylized Role icons and enable them by default",
    F.String.ElvUI() --
      .. ": Swap Target UnitFrame Buffs & Debuffs"
      .. F.String.Sublist("This change was made so that it matches the Player UnitFrame Debuffs"),
    F.String.ElvUI() --
      .. ": Use the new "
      .. F.String.ToxiUI("Smart Power")
      .. " tag for non-dark mode layouts"
      .. F.String.Sublist("Old tags are still available in " .. F.String.Class("Available Tags")),
    F.String.ElvUI() .. ": Add !Power text tag to Party UnitFrames",
    F.String.ElvUI() --
      .. ": Update Focus UnitFrame"
      .. F.String.Sublist("Add a !Power text tag")
      .. F.String.Sublist("Move the Focus Power Bar to match Target UnitFrame"),
    F.String.ElvUI() .. ": Hide Target & Focus UnitFrame Power bars when the unit has no power",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
