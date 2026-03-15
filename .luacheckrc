std = "lua51"
max_line_length = false
codes = true
self = false

exclude_files = {
  ".luacheckrc",
}

ignore = {
  "113",
  "211/E",
  "211/F",
  "211/G",
  "211/L",
  "211/I",
  "211/P",
  "211/V",
  "211/TXUI",
}

files["**/_template.lua"] = { ignore = { "212" } }

globals = {
  "_G",
  "bit",

  -- Libs
  "string.utf8len",
  "string.utf8lower",
  "string.utf8sub",
  "string.utf8upper",

  -- AddOns
  "BigWigs",
  "Details",
  "ElvUI",
  "LibStub",
  "DamageMeter",

  -- AddOn DBs
  "BigWigsAPI",
  "DBT_AllPersistentOptions",
  "ElvDB",
}
