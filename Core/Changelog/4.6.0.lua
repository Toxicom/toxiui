local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["4.6.0"] = {
  CHANGES = {
    "* New features",
    "Added a command to force Chat settings",
    "Weak Aura skinning to replace masque |cffff0000BETA|r",
    "|cffff97f6G|r|cfff8b0f2ra|r|cfff5c6f1di|r|cfff3d9f1en|r|cffffeafdt|r mode",

    "* Bug fixes",
    "Action Bar fixes that hopefully won't break again",

    "* Profile updates",
    "Force CVars like ElvUI installer does",
    "Fixed Pet/ToT name inconsistency",
    "Disabled Minimap shadow backdrop",
    "Force disable Masque for ActionBars",
    "Enabled range fading for Target UF",
    "Raid now shows 20 people (raid40 still show everyone else)",
    "Changed Plater Health% font",
    "Moved Plater Health% to Top Right",
    "Disabled % sign from Plater Health%",
    "Plater Health% shows only in combat",
    "Moved Plater Quest icon to avoid overlap with health%",
    "Plater Nameplate now remains the same size while in combat",
    "Swapped DBM Range frame circle and list (hopefully this will fix overlapping issue)",

    "* Settings refactoring",
    "Changes to the whole Options menu of ToxiUI",

    "* Development improvements",
    "Installer now automatically goes to the next step after applying a profile",
  },
}
