local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["7.0.5"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",

    "* New features",

    "* Bug fixes",

    "* Profile updates",
    F.String.Plater() .. ": Add Legion Remix Empowered buffs to both Automatic and Manual tracking",
    F.String.Plater() .. ": Add " .. F.String.ToxiUI("Force Threat Colors") .. " mod to override M+ colors when you have aggro",
    F.String.Plater() .. ": Re-add " .. F.String.Class("Sigil of Silence", "DEMONHUNTER") .. " to Buff Special",

    "* Documentation",

    "* Settings refactoring",

    "* Development improvements",
  },
}
