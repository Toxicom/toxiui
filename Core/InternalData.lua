local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

I.Data = {}

I.Data.Contributor = {
  [I.Enum.ContributorType.DEV] = {
    [I.Enum.Developers.TOXI] = {
      [I.Enum.Flavor.RETAIL] = {
        -- Ravencrest
        ["Toxiholy-Ravencrest"] = true, -- Paladin
        ["Toxisorc-Ravencrest"] = true, -- Mage
        ["Melissandei-Ravencrest"] = true, -- Druid
        ["Toxirage-Ravencrest"] = true, -- Warrior
        ["Toxilock-Ravencrest"] = true, -- Warlock
        ["Toxisin-Ravencrest"] = true, -- Rogue
        ["Toxivoid-Ravencrest"] = true, -- Priest
        ["Toxipain-Ravencrest"] = true, -- Demon Hunter
        ["Toxistorm-Ravencrest"] = true, -- Shaman
        ["Toxishot-Ravencrest"] = true, -- Hunter
        ["Toxilich-Ravencrest"] = true, -- Death Knight
        ["Toxivoker-Ravencrest"] = true, -- Evoker
        ["Toximoon-Ravencrest"] = true, -- Druid

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
        ["Toxizen-TarrenMill"] = true,
        ["Toxievo-TarrenMill"] = true,
      },

      [I.Enum.Flavor.CLASSIC] = {
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

      [I.Enum.Flavor.ANNIVERSARY] = {
        -- Thunderstrike
        ["Toxilock-Thunderstrike"] = true,
        ["Toxishot-Thunderstrike"] = true,
        ["Toxisin-Thunderstrike"] = true,

        -- Spineshatter
        ["Toximoon-Spineshatter"] = true,
        ["Toxisin-Spineshatter"] = true,
        ["Toxibow-Spineshatter"] = true,
      },

      [I.Enum.Flavor.CLASSIC_ERA] = {
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

      [I.Enum.Flavor.CLASSIC] = {
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
        ["Raif-Arathor"] = true,
        ["Kiasi-Arathor"] = true,
        ["Raichi-Arathor"] = true,
        ["Rai-Arathor"] = true,
        ["Kari-Arathor"] = true,
        ["Raih-Arathor"] = true,
        ["Raifel-Arathor"] = true,
        ["Kuya-Arathor"] = true,
        ["Getafix-Arathor"] = true,
        ["Toasti-Arathor"] = true,
        ["Kuyo-Arathor"] = true,
        ["Lexza-Arathor"] = true,

        -- Ragnaros
        ["Slashslashsl-Ragnaros"] = true,
        ["Aurrius-Ragnaros"] = true,
        ["Stabbystabst-Ragnaros"] = true,
        ["Hellooias-Ragnaros"] = true,
        ["Raovas-Ragnaros"] = true,
        ["Aercis-Ragnaros"] = true,

        -- Ravencrest
        ["Azryx-Ravencrest"] = true,
        ["Ariz-Ravencrest"] = true,
        ["Raishi-Ravencrest"] = true,
        ["Raifel-Ravencrest"] = true,
        ["Rainok-Ravencrest"] = true,
        ["Aercis-Ravencrest"] = true,
        ["Raitha-Ravencrest"] = true,
        ["Baahboi-Ravencrest"] = true,
        ["Raire-Ravencrest"] = true,
        ["Raim-Ravencrest"] = true,
        ["Moorai-Ravencrest"] = true,
        ["Raihi-Ravencrest"] = true,
        ["Aahhyrsdy-Ravencrest"] = true,
        ["Auru-Ravencrest"] = true,
        ["Tib-Ravencrest"] = true,
        ["Lejlighed-Ravencrest"] = true,
        ["Raish-Ravencrest"] = true,
        ["Tibs-Ravencrest"] = true,
        ["Raitra-Ravencrest"] = true,

        -- Silvermoon
        ["Vaeliris-Silvermoon"] = true,
        ["Tibs-Silvermoon"] = true,
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

    ["Kryo"] = {
      [I.Enum.Flavor.RETAIL] = {
        -- Thrall
        ["Kryosys-Thrall"] = true,
        ["Kryostab-Thrall"] = true,
        ["Kryoxys-Thrall"] = true,
        ["Kryoblast-Thrall"] = true,
        ["Kryonyx-Thrall"] = true,
        ["Kryoptyx-Thrall"] = true,
        ["Kryodyn-Thrall"] = true,
        ["Kryototem-Thrall"] = true,
      },
    },

    ["BehkFox"] = {
      [I.Enum.Flavor.RETAIL] = {
        -- Stormrage
        ["Loqenak-Stormrage"] = true,
        ["Aarkhin-Stormrage"] = true,
        ["Stldst-Stormrage"] = true,
        ["Behknk-Stormrage"] = true,
        ["Behkfox-Stormrage"] = true,
        ["Strdst-Stormrage"] = true,
        ["Zalreog-Stormrage"] = true,
        ["Lavadust-Stormrage"] = true,
        ["Behkwolf-Stormrage"] = true,
        ["Shdwdst-Stormrage"] = true,
      },
    },
  },

  -- EPIC => Purple Badge (epic supporter)
  [I.Enum.ContributorType.EPIC] = {},

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

    -- Joined Jan 15, 2026
    ["Aspry"] = {
      [I.Enum.Flavor.ANNIVERSARY] = {
        -- Spineshatter
        ["Kyenra-Spineshatter"] = true,
        ["Rindwahn-Spineshatter"] = true,
        ["Souldots-Spineshatter"] = true,
        ["Poîson-Spineshatter"] = true,
        ["Aethina-Spineshatter"] = true,
        ["Aspry-Spineshatter"] = true,
        ["Schokibunker-Spineshatter"] = true,
        ["Maggilar-Spineshatter"] = true,
        ["Hotterstar-Spineshatter"] = true,
      },
    },

    ["Liue"] = {
      [I.Enum.Flavor.RETAIL] = {
        -- Draenor
        ["Lilithye-Draenor"] = true,
        ["Inydae-Draenor"] = true,
        ["Dalitea-Draenor"] = true,
        ["Siladre-Draenor"] = true,
        ["Everita-Draenor"] = true,
        ["Yitsa-Draenor"] = true,
        ["Jicae-Draenor"] = true,
        ["Niato-Draenor"] = true,
        ["Scilia-Draenor"] = true,

        -- Silvermoon
        ["Eynia-Silvermoon"] = true,
        ["Miyena-Silvermoon"] = true,
        ["Lilithye-Silvermoon"] = true,
        ["Lialia-Silvermoon"] = true,
        ["Ridelle-Silvermoon"] = true,
        ["Aylirae-Silvermoon"] = true,
        ["Liue-Silvermoon"] = true,
        ["Eliare-Silvermoon"] = true,
        ["Yitsa-Silvermoon"] = true,
        ["Ajisa-Silvermoon"] = true,
        ["Faelya-Silvermoon"] = true,
        ["Siladre-Silvermoon"] = true,
        ["Niato-Silvermoon"] = true,
        ["Dalitea-Silvermoon"] = true,
        ["Inydae-Silvermoon"] = true,
        ["Rishah-Silvermoon"] = true,
        ["Liliyena-Silvermoon"] = true,
        ["Miendra-Silvermoon"] = true,
      },

      [I.Enum.Flavor.ANNIVERSARY] = {
        -- Thunderstrike
        ["Niato-Thunderstrike"] = true,
        ["Liue-Thunderstrike"] = true,
      },

      [I.Enum.Flavor.CLASSIC] = {
        -- Hoptallus
        ["Scilia-Hoptallus"] = true,

        -- MirageRaceway
        ["Liue-MirageRaceway"] = true,
        ["Ridelle-MirageRaceway"] = true,
        ["Niato-MirageRaceway"] = true,
      },
    },
  },

  -- BETA => Orange Badge (beta testers)
  [I.Enum.ContributorType.BETA] = {
    ["v0dKa"] = {
      [I.Enum.Flavor.RETAIL] = {
        -- Antonidas
        ["Bakul-Antonidas"] = true,

        -- Eredar
        ["Zulrak-Eredar"] = true,
        ["Panril-Eredar"] = true,
        ["Zantheas-Eredar"] = true,
        ["Varlanis-Eredar"] = true,
        ["Glanus-Eredar"] = true,
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
      },
    },
  },
}
