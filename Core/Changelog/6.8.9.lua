local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

TXUI.Changelog["6.8.9"] = {
  HOTFIX = true,
  CHANGES = {
    "* Breaking changes",
    "Change the name of all custom texts that " .. TXUI.Title .. " uses" .. F.String.Sublist("We did an automatic database conversion so nothing should break"),
    "If you're experiencing issues due to some custom texts not being converted properly, follow these steps:"
      .. F.String.Sublist("Logout from your character")
      .. F.String.Sublist("Open this file in your WoW directory: WTF/Account/<ACCOUNT_ID>/SavedVariables/ElvUI.lua")
      .. F.String.Sublist("Find a line that says " .. F.String.ToxiUI("[\"lastDBConversion\"] = \"6.8.9\""))
      .. F.String.Sublist("Change 6.8.9 to 6.8.8")
      .. F.String.Sublist("Save the file & log back in to your character")
      .. F.String.Sublist("This should have triggered the database conversion one more time"),

    "* New features",

    "* Bug fixes",

    "* Profile updates",

    "* Documentation",
    "Update links to " .. TXUI.Title .. " WeakAuras guide",

    "* Settings refactoring",

    "* Development improvements",
  },
}
