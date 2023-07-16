local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

I.Data = {}

I.Data.Contributor = {
  [I.Enum.ContributorType.DEV] = {
    [I.Enum.Developers.TOXI] = {
      [I.Enum.Flavor.RETAIL] = {
        -- Ravencrest
        ["Calistrø-Ravencrest"] = true, -- Paladin
        ["Calìstro-Ravencrest"] = true, -- Mage
        ["Melissandei-Ravencrest"] = true, -- Druid
        ["Toxirage-Ravencrest"] = true, -- Warrior
        ["Toxicom-Ravencrest"] = true, -- Warlock
        ["Toxisin-Ravencrest"] = true, -- Rogue
        ["Toxicøm-Ravencrest"] = true, -- Priest
        ["Tòxicom-Ravencrest"] = true, -- Demon Hunter
        ["Tøxicom-Ravencrest"] = true, -- Shaman
        ["Tøxii-Ravencrest"] = true, -- Hunter
        ["Toxilich-Ravencrest"] = true, -- Death Knight
        ["Toxivoker-Ravencrest"] = true, -- Evoker

        -- TarrenMill
        ["Toxiholy-TarrenMill"] = true,
        ["Toxicom-TarrenMill"] = true,
        ["Toxirage-TarrenMill"] = true,
        ["Toxiglide-TarrenMill"] = true,
        ["Toxiquiver-TarrenMill"] = true,
        ["Toxilock-TarrenMill"] = true,
        ["Toxisin-TarrenMill"] = true,
        ["Toximoon-TarrenMill"] = true,
        ["Toxivoid-TarrenMill"] = true,
        ["Toxiwiz-TarrenMill"] = true,
        ["Toxichi-TarrenMill"] = true,
        ["Toxiele-TarrenMill"] = true,
      },

      [I.Enum.Flavor.WRATH] = {
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
      },

      [I.Enum.Flavor.CLASSIC] = {
        -- Firemaw
        ["Toxisin-Firemaw"] = true,
      },
    },

    [I.Enum.Developers.WOLEN] = {
      [I.Enum.Flavor.RETAIL] = {
        -- Mal'Ganis
        ["Keelle-Mal'Ganis"] = true,
        ["Drittus-Mal'Ganis"] = true,
        ["Chilvang-Mal'Ganis"] = true,
        ["Cezo-Mal'Ganis"] = true,
        ["Vitier-Mal'Ganis"] = true,
        ["Giotao-Mal'Ganis"] = true,
        ["Wolen-Mal'Ganis"] = true,
        ["Welon-Mal'Ganis"] = true,
        ["Jaalyk-Mal'Ganis"] = true,
        ["Giotaociot-Mal'Ganis"] = true,
        ["Seraga-Mal'Ganis"] = true,
        ["Nelow-Mal'Ganis"] = true,
        ["Yanako-Mal'Ganis"] = true,

        -- Zul'jin
        ["Nelow-Zul'jin"] = true,
        ["Wolen-Zul'jin"] = true,
        ["Jukks-Zul'jin"] = true,
        ["Mozzles-Zul'jin"] = true,
        ["Welon-Zul'jin"] = true,
        ["Nolew-Zul'jin"] = true,
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

      [I.Enum.Flavor.WRATH] = {
        -- Giantstalker
        ["Lexza-Giantstalker"] = true,
      },
    },
  },

  -- LEGENDARY => Orange Badge
  [I.Enum.ContributorType.LEGENDARY] = {
    ["Ikrekot"] = {
      [I.Enum.Flavor.RETAIL] = {
        -- Burning Legion
        ["Krekotx-BurningLegion"] = true,
        ["Breysha-BurningLegion"] = true,
        ["Tinge-BurningLegion"] = true,
        ["Oachmadow-BurningLegion"] = true,
        ["Liszias-BurningLegion"] = true,
        ["Elensa-BurningLegion"] = true,
        ["Hekili-BurningLegion"] = true,
        ["Amorat-BurningLegion"] = true,
        ["Ikrekot-BurningLegion"] = true,
        ["Mechanne-BurningLegion"] = true,
        ["Jolante-BurningLegion"] = true,
        ["Grekot-BurningLegion"] = true,
        ["Achlysia-BurningLegion"] = true,
        ["Searaa-BurningLegion"] = true,
        ["Ynaqtenkle-BurningLegion"] = true,
        ["Emesalia-BurningLegion"] = true,
        ["Corette-BurningLegion"] = true,
        ["Rongzhi-BurningLegion"] = true,
        ["Prekot-BurningLegion"] = true,
        ["Krekot-BurningLegion"] = true,
        ["Mirgaram-BurningLegion"] = true,
        ["Trungirn-BurningLegion"] = true,
        ["Krekoti-BurningLegion"] = true,
        ["Krekotz-BurningLegion"] = true,
        ["Houphria-BurningLegion"] = true,
        ["Kalthnia-BurningLegion"] = true,
        ["Yneleyll-BurningLegion"] = true,
        ["Krekots-BurningLegion"] = true,
        ["Rahissar-BurningLegion"] = true,
        ["Drekot-BurningLegion"] = true,
        ["Saline-BurningLegion"] = true,
        ["Denyse-BurningLegion"] = true,
        ["Erybosa-BurningLegion"] = true,
        ["Elikot-BurningLegion"] = true,
        ["Ililaeth-BurningLegion"] = true,
        ["Nekroirek-BurningLegion"] = true,
        ["Gothy-BurningLegion"] = true,
      },

      [I.Enum.Flavor.WRATH] = {
        -- MirageRaceway
        ["Drekot-MirageRaceway"] = true,
        ["Krekot-MirageRaceway"] = true,
        ["Prekot-MirageRaceway"] = true,
        ["Ikrekot-MirageRaceway"] = true,
      },
    },

    ["Hoffi"] = {
      [I.Enum.Flavor.RETAIL] = {
        -- Eredar
        ["Currybart-Eredar"] = true,
        ["Leahnari-Eredar"] = true,
      },
    },
  },

  -- EPIC => Purple Badge (epic supporter)
  [I.Enum.ContributorType.EPIC] = {
    ["Ryada"] = {
      [I.Enum.Flavor.RETAIL] = {
        -- Draenor
        ["Ryada-Draenor"] = true,
        ["Ryadea-Draenor"] = true,
        ["Ryadia-Draenor"] = true,
      },

      [I.Enum.Flavor.WRATH] = {
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
    ["Tornic"] = {
      [I.Enum.Flavor.RETAIL] = {
        -- Argent Dawn
        ["Kyliemirogue-ArgentDawn"] = true,

        -- Silvermoon
        ["Patrón-Silvermoon"] = true,

        -- Stormscale
        ["Patrón-Stormscale"] = true,
        ["Thornic-Stormscale"] = true,
        ["Thorníc-Stormscale"] = true,
        ["Thornïc-Stormscale"] = true,
        ["Thórnic-Stormscale"] = true,
        ["Torníc-Stormscale"] = true,
        ["Tornïc-Stormscale"] = true,
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
  },
}
