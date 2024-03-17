local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["4.5.0"] = {
  CHANGES = {
    "* New features",
    "Dark Mode",
    "Integrate ElvUI_GlobalFadePersist functionality inside ToxiUI",

    "* Bug fixes",
    "Fixed an issue with overwriting certain parts of existing DBM profiles during installation",
    "Fixed Plater's Abbreviation script for non-english clients",
    "Fixed double Welcome message",

    "* Profile updates",
    "Disabled Power for Player & Target frames",
    "Second Details window is now locked",
    "Title bar smaller, outline removed for Details",
    "Global Fade now hides bars 2 - 10 in vehicle and taxi",
  },
}
