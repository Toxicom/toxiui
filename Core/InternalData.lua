local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

I.Data = {}

I.Data.Contributor = {
  [I.Enum.ContributorType.DEV] = {
    [I.Enum.Developers.TOXI] = {
      [I.Enum.Flavor.RETAIL] = {
        -- Ravencrest
        ["Calistrø-Ravencrest"] = true, -- Paladin
        ["Toxisorc-Ravencrest"] = true, -- Mage
        ["Melissandei-Ravencrest"] = true, -- Druid
        ["Toxirage-Ravencrest"] = true, -- Warrior
        ["Toxilock-Ravencrest"] = true, -- Warlock
        ["Toxisin-Ravencrest"] = true, -- Rogue
        ["Toxivoid-Ravencrest"] = true, -- Priest
        ["Tòxicom-Ravencrest"] = true, -- Demon Hunter
        ["Tøxicom-Ravencrest"] = true, -- Shaman
        ["Tøxii-Ravencrest"] = true, -- Hunter
        ["Toxilich-Ravencrest"] = true, -- Death Knight
        ["Toxivoker-Ravencrest"] = true, -- Evoker

        -- TarrenMill
        ["Toxiholy-TarrenMill"] = true,
        ["Toxicom-TarrenMill"] = true,
        ["Toxirage-TarrenMill"] = true,
        ["Toxiquiver-TarrenMill"] = true,
        ["Toxilock-TarrenMill"] = true,
        ["Toxisin-TarrenMill"] = true,
        ["Toximoon-TarrenMill"] = true,
        ["Toxivoid-TarrenMill"] = true,
        ["Toxisorc-TarrenMill"] = true,
        ["Toxichi-TarrenMill"] = true,
        ["Toxiele-TarrenMill"] = true,
        ["Toximeta-TarrenMill"] = true,
        ["Toxihunt-TarrenMill"] = true,
        ["Toxistorm-TarrenMill"] = true,
      },

      [I.Enum.Flavor.MISTS] = {
        -- Giantstalker
        ["Toxi-Giantstalker"] = true,
        ["Toxilich-Giantstalker"] = true,
        ["Toxiholy-Giantstalker"] = true,
        ["Toxisin-Giantstalker"] = true,
        ["Toxilock-Giantstalker"] = true,
        ["Toxirage-Giantstalker"] = true,
        ["Toxihunt-Giantstalker"] = true,
        ["Toxivoid-Giantstalker"] = true,
        ["Toxiboom-Giantstalker"] = true,

        -- Pyrewood Village
        ["Toxisorc-PyrewoodVillage"] = true,
        ["Toxisin-PyrewoodVillage"] = true,
        ["Toxilich-PyrewoodVillage"] = true,
        ["Toxivoid-PyrewoodVillage"] = true,
        ["Melissandei-PyrewoodVillage"] = true,
        ["Toxirage-PyrewoodVillage"] = true,
        ["Toxiholy-PyrewoodVillage"] = true,
        ["Toxilock-PyrewoodVillage"] = true,
        ["Toxibank-PyrewoodVillage"] = true,
        ["Toxispring-PyrewoodVillage"] = true,
        ["Toxitotem-PyrewoodVillage"] = true,
        ["Toximoon-PyrewoodVillage"] = true,

        -- Gehennas
        ["Toxigoblin-Gehennas"] = true,
        ["Toxisorc-Gehennas"] = true,
        ["Toxivoid-Gehennas"] = true,
        ["Toxisin-Gehennas"] = true,
        ["Toxiholy-Gehennas"] = true,
        ["Toxifer-Gehennas"] = true, -- Warlock
        ["Toxispring-Gehennas"] = true, -- Hunter
      },

      [I.Enum.Flavor.VANILLA] = {
        -- Firemaw
        ["Toxisin-Firemaw"] = true,

        -- Crusader Strike (Season of Discovery)
        ["Toxirage-CrusaderStrike"] = true,
        ["Toxisorc-CrusaderStrike"] = true,
        ["Toxivoid-CrusaderStrike"] = true,
        ["Toxibow-CrusaderStrike"] = true,
        ["Toxilock-CrusaderStrike"] = true,
        ["Toxisin-CrusaderStrike"] = true,
      },
    },

    [I.Enum.Developers.RYADA] = {
      [I.Enum.Flavor.RETAIL] = {
        -- Draenor
        ["Ryada-Draenor"] = true,
        ["Ryadea-Draenor"] = true,
        ["Ryadia-Draenor"] = true,
      },

      [I.Enum.Flavor.MISTS] = {
        -- Ashbringer
        ["Cyassa-Ashbringer"] = true,
        ["Ryashh-Ashbringer"] = true,
        ["Ryadea-Ashbringer"] = true,
        ["Ryasiz-Ashbringer"] = true,
        ["Ryasham-Ashbringer"] = true,
        ["Ryadar-Ashbringer"] = true,
        ["Ryada-Ashbringer"] = true,
      },
    },

    [I.Enum.Developers.RHAP] = {
      [I.Enum.Flavor.RETAIL] = {
        -- Illidan
        ["Rhapsodicoli-Illidan"] = true,
        ["Rhapsodicola-Illidan"] = true,
        ["Pointyhorn-Illidan"] = true,
        ["Monksody-Illidan"] = true,
        ["Shamansody-Ilidan"] = true,
        ["Roguesody-Illidan"] = true,
        ["Magesody-Illidan"] = true,
        ["Deathsody-Illidan"] = true,
        ["Rhapsoditank-Illidan"] = true,

        -- Sargeras
        ["Forthéhorde-Sargeras"] = true,
      },
    },

    [I.Enum.Developers.JAKE] = {
      [I.Enum.Flavor.RETAIL] = {
        -- Arathor
        ["Getafix-Arathor"] = true,
        ["Kari-Arathor"] = true,
        ["Kiasi-Arathor"] = true,
        ["Lexza-Arathor"] = true,
        ["Rai-Arathor"] = true,
        ["Raifel-Arathor"] = true,
        ["Raih-Arathor"] = true,
        ["Raivas-Arathor"] = true,

        -- Daggerspine
        ["Aurrius-Daggerspine"] = true,
        ["Raovasbank-Daggerspine"] = true,
      },

      [I.Enum.Flavor.MISTS] = {
        -- Giantstalker
        ["Lexza-Giantstalker"] = true,
      },
    },
  },

  -- LEGENDARY => Orange Badge
  [I.Enum.ContributorType.LEGENDARY] = {
    -- They painted the Stylized Spec icons
    ["Shaz"] = {
      [I.Enum.Flavor.RETAIL] = {
        -- Draenor
        ["Illyanna-Draenor"] = true,
        ["Seffy-Draenor"] = true,
        ["Myrcene-Draenor"] = true,
        ["Cassièl-Draenor"] = true,
        ["Shonisdog-Draenor"] = true,
        ["Liliael-Draenor"] = true,
        ["Illyea-Draenor"] = true,
        ["Sanígawd-Draenor"] = true,
        ["Lilliwilli-Draenor"] = true,
        ["Lilliaeth-Draenor"] = true,
        ["Lilywilly-Draenor"] = true,
        ["Illyra-Draenor"] = true,
        ["Iraqiprince-Draenor"] = true,
        ["Illy-Draenor"] = true,
        ["Xyllene-Draenor"] = true,
        ["Isbeth-Draenor"] = true,
        ["Lilliam-Draenor"] = true,
        ["Zyphira-Draenor"] = true,
        ["Lielee-Draenor"] = true,
        ["Brokeilly-Draenor"] = true,
        ["Iressi-Draenor"] = true,
        ["Sephy-Draenor"] = true,
        ["Liliam-Draenor"] = true,
        ["Demonilly-Draenor"] = true,
      },
    },
  },

  -- EPIC => Purple Badge (epic supporter)
  [I.Enum.ContributorType.EPIC] = {
    ["Ande"] = {
      [I.Enum.Flavor.RETAIL] = {
        -- Illidan
        ["Mojoheal-Illidan"] = true,
        ["Mojosneak-Illidan"] = true,
        ["Nohwei-Illidan"] = true,
        ["Adolluh-Illidan"] = true,
        ["Mojobegone-Illidan"] = true,
        ["Totembegone-Illidan"] = true,
        ["Andelul-Illidan"] = true,
        ["Mojoshooter-Illidan"] = true,
      },
    },
  },

  -- RARE => Green Badge (rare supporter)
  [I.Enum.ContributorType.RARE] = {
    ["Sesoni"] = {
      [I.Enum.Flavor.RETAIL] = {
        -- WyrmrestAccord
        ["Valiath-WyrmrestAccord"] = true,
        ["Varkaden-WyrmrestAccord"] = true,
        ["Sesoni-WyrmrestAccord"] = true,
        ["Ashenveil-WyrmrestAccord"] = true,
      },
    },

    -- Joined Jul 15, 2024
    ["Reat"] = {
      [I.Enum.Flavor.RETAIL] = {
        -- Sanguino
        ["Reät-Sanguino"] = true,
        ["Reatp-Sanguino"] = true,
        ["Evoreat-Sanguino"] = true,
        ["Rëat-Sanguino"] = true,

        -- Silvermoon
        ["Reatoker-Silvermoon"] = true,
        ["Reät-Silvermoon"] = true,
        ["Rëat-Silvermoon"] = true,
        ["Reatonk-Silvermoon"] = true,
        ["Reatuid-Silvermoon"] = true,
        ["Reatsham-Silvermoon"] = true,
        ["Reatp-Silvermoon"] = true,
        ["Reatmix-Silvermoon"] = true,
        ["Reatix-Silvermoon"] = true,

        -- TarrenMill
        ["Reatpal-TarrenMill"] = true,
        ["Rëat-TarrenMill"] = true,
      },
    },

    -- Joined Jul 19, 2024
    ["mrkhaglund"] = {
      [I.Enum.Flavor.RETAIL] = {
        -- Al'Akir
        ["Firaga-Al'Akir"] = true,
        ["Thalric-Al'Akir"] = true,
        ["Loahand-Al'Akir"] = true,
        ["Leep-Al'Akir"] = true,
        ["Vaiju-Al'Akir"] = true,
        ["Xpzt-Al'Akir"] = true,
        ["Saintbull-Al'Akir"] = true,
        ["Mcgregor-Al'Akir"] = true,
        ["Ishaka-Al'Akir"] = true,
        ["Arcané-Al'Akir"] = true,

        -- Darkspear
        ["Deadshoot-Darkspear"] = true,
        ["Thulsa-Darkspear"] = true,
        ["Ortodoxx-Darkspear"] = true,
        ["Erhja-Darkspear"] = true,
        ["Türok-Darkspear"] = true,
        ["Vildsint-Darkspear"] = true,

        -- ShatteredHalls
        ["Lupin-ShatteredHalls"] = true,
        ["Torwald-ShatteredHalls"] = true,
      },
    },
  },

  -- BETA => Orange Badge (beta testers)
  [I.Enum.ContributorType.BETA] = {
    ["v0dKa"] = {
      [I.Enum.Flavor.RETAIL] = {
        ["Bakul-Antonidas"] = true,
        ["Mythelor-Antonidas"] = true,
      },
    },

    ["Nalar"] = {
      [I.Enum.Flavor.RETAIL] = {
        -- BurningBlade
        ["Julka-BurningBlade"] = true,
        ["Lamaxx-BurningBlade"] = true,
        ["Morgenstein-BurningBlade"] = true,
        ["Morgrim-BurningBlade"] = true,
        ["Ressil-BurningBlade"] = true,
        ["Sarity-BurningBlade"] = true,

        -- Drak'thul
        ["Maxentius-Drak'thul"] = true,
        ["Praxila-Drak'thul"] = true,
        ["Vesso-Drak'thul"] = true,
      },
    },

    ["eaglegoboom"] = {
      [I.Enum.Flavor.RETAIL] = {
        -- Alleria
        ["Boomtassels-Alleria"] = true,
        ["Cure-Alleria"] = true,
        ["Disctassels-Alleria"] = true,
        ["Portmeround-Alleria"] = true,
      },
    },

    ["Jeor"] = {
      [I.Enum.Flavor.RETAIL] = {
        ["Beefsteak-Korgath"] = true,
        ["Groham-Korgath"] = true,
        ["Imacat-Korgath"] = true,
        ["Terrafin-Korgath"] = true,
        ["Terrafina-Korgath"] = true,
      },
    },

    ["Franny"] = {
      [I.Enum.Flavor.RETAIL] = {
        ["Besmara-Mal'Ganis"] = true,
        ["Cavtha-Mal'Ganis"] = true,
        ["Cavtha-SilverHand"] = true,
        ["Lethns-SilverHand"] = true,
      },
    },

    ["Ikrekot"] = {
      [I.Enum.Flavor.RETAIL] = {
        -- BurningLegion
        ["Krekot-BurningLegion"] = true,
        ["Ikrekot-BurningLegion"] = true,
        ["Krekots-BurningLegion"] = true,
        ["Wrekot-BurningLegion"] = true,
        ["Kalthnia-BurningLegion"] = true,
        ["Erybosa-BurningLegion"] = true,
        ["Cannenta-BurningLegion"] = true,
        ["Drekot-BurningLegion"] = true,
        ["Liszias-BurningLegion"] = true,
        ["Krekoti-BurningLegion"] = true,
        ["Hekili-BurningLegion"] = true,
        ["Krekotr-BurningLegion"] = true,
        ["Amorat-BurningLegion"] = true,
        ["Prekot-BurningLegion"] = true,
        ["Fdsfsdffedf-BurningLegion"] = true,
        ["Nekroirek-BurningLegion"] = true,
        ["Gothy-BurningLegion"] = true,
        ["Houphria-BurningLegion"] = true,

        -- Седогрив
        ["Ортетамин-Седогрив"] = true,
      },
    },
  },
}
