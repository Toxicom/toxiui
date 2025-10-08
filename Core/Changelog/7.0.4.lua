local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.0.4"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",
    "Add " .. F.String.Error("Turbo Mode") .. " to the installer." .. F.String.Sublist(
      "It is a very dangerous button that installs all of ToxiUI essential profiles in one click without asking you anything."
    ) .. F.String.Sublist("It will overwrite shit. Use at your own discretion!"),

    "* Bug fixes",
    "Fix " .. F.String.Plater() .. " NPC Colors not importing correctly",

    "* Profile updates",
    "Disable " .. F.String.ElvUI() .. " Chat during Layout installation if Chattynator is enabled",

    "* Documentation",
    F.String.MinElv("14.02"),
    "Update .toc for Patch 11.2.5",

    "* Settings refactoring",

    "* Development improvements",
    "Refactor code on how we import a " .. F.String.Plater() .. " profile",
  },
}
