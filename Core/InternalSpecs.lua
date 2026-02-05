local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

-- Spec IDs organized by class
-- Usage: I.Specs.Warrior.Protection, I.Specs.Mage.Arcane, etc.
I.Specs = {
  DeathKnight = {
    Blood = 250,
    Frost = 251,
    Unholy = 252,
  },
  DemonHunter = {
    Havoc = 577,
    Vengeance = 581,
    Devourer = 1480,
  },
  Druid = {
    Balance = 102,
    Feral = 103,
    Guardian = 104,
    Restoration = 105,
  },
  Evoker = {
    Devastation = 1467,
    Preservation = 1468,
    Augmentation = 1473,
  },
  Hunter = {
    BeastMastery = 253,
    Marksmanship = 254,
    Survival = 255,
  },
  Mage = {
    Arcane = 62,
    Fire = 63,
    Frost = 64,
  },
  Monk = {
    Brewmaster = 268,
    Mistweaver = 270,
    Windwalker = 269,
  },
  Paladin = {
    Holy = 65,
    Protection = 66,
    Retribution = 70,
  },
  Priest = {
    Discipline = 256,
    Holy = 257,
    Shadow = 258,
  },
  Rogue = {
    Assassination = 259,
    Outlaw = 260,
    Subtlety = 261,
  },
  Shaman = {
    Elemental = 262,
    Enhancement = 263,
    Restoration = 264,
  },
  Warlock = {
    Affliction = 265,
    Demonology = 266,
    Destruction = 267,
  },
  Warrior = {
    Arms = 71,
    Fury = 72,
    Protection = 73,
  },
}

-- Spec ID to English name mapping
-- Usage: I.SpecNames[specId] -> "Protection"
I.SpecNames = {
  -- Death Knight
  [250] = "Blood",
  [251] = "Frost",
  [252] = "Unholy",
  -- Demon Hunter
  [577] = "Havoc",
  [581] = "Vengeance",
  [1480] = "Devourer",
  -- Druid
  [102] = "Balance",
  [103] = "Feral",
  [104] = "Guardian",
  [105] = "Restoration",
  -- Evoker
  [1467] = "Devastation",
  [1468] = "Preservation",
  [1473] = "Augmentation",
  -- Hunter
  [253] = "Beast Mastery",
  [254] = "Marksmanship",
  [255] = "Survival",
  -- Mage
  [62] = "Arcane",
  [63] = "Fire",
  [64] = "Frost",
  -- Monk
  [268] = "Brewmaster",
  [270] = "Mistweaver",
  [269] = "Windwalker",
  -- Paladin
  [65] = "Holy",
  [66] = "Protection",
  [70] = "Retribution",
  -- Priest
  [256] = "Discipline",
  [257] = "Holy",
  [258] = "Shadow",
  -- Rogue
  [259] = "Assassination",
  [260] = "Outlaw",
  [261] = "Subtlety",
  -- Shaman
  [262] = "Elemental",
  [263] = "Enhancement",
  [264] = "Restoration",
  -- Warlock
  [265] = "Affliction",
  [266] = "Demonology",
  [267] = "Destruction",
  -- Warrior
  [71] = "Arms",
  [72] = "Fury",
  [73] = "Protection",
}
