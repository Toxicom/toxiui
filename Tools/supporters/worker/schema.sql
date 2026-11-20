CREATE TABLE IF NOT EXISTS users (
  user_id TEXT PRIMARY KEY,        -- Discord user ID
  display_name TEXT NOT NULL,      -- Name shown in the ToxiUI credits
  registered_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS characters (
  flavor TEXT NOT NULL,            -- I.Enum.Flavor key: RETAIL, CLASSIC, ANNIVERSARY, CLASSIC_ERA, FOREVER
  name TEXT NOT NULL,              -- "Name-Realm" (Forever: "First Last")
  user_id TEXT NOT NULL,
  PRIMARY KEY (flavor, name)       -- a character can only be claimed once per game version
);

CREATE INDEX IF NOT EXISTS idx_characters_user ON characters (user_id);
