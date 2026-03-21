local TXUI, F, _, I, V, P, G = unpack((select(2, ...)))
local LP = TXUI:GetModule("LandingPage")

-- Build the page list for the fresh-install welcome flow.
-- Add `image`, `imageWidth`, `imageHeight` to any page to show a screenshot.
-- Example:
--   image = "Interface\\AddOns\\ElvUI_ToxiUI\\Media\\LandingPage\\options.tga",
--   imageWidth = 720, imageHeight = 220,
function LP:GetFreshInstallPages()
  local title = F.String.ToxiUI(TXUI.Title)

  return {
    -- Page 1: Welcome
    {
      title = "Welcome",
      text = title
        .. " is a pre-configured "
        .. F.String.ElvUI("ElvUI")
        .. " profile and plugin "
        .. "that transforms the default WoW UI into a clean, minimalistic, and modern interface.\n\n"
        .. F.String.ElvUI("ElvUI")
        .. " is a powerful UI framework that replaces almost every element "
        .. "of the default interface: unit frames, action bars, the minimap, chat, bags, and more. "
        .. title
        .. " sits on top of it, providing a carefully tuned profile, visual themes, "
        .. "and extra features that ElvUI does not ship with out of the box.\n\n"
        .. "In short: "
        .. F.String.ElvUI("ElvUI")
        .. " does the heavy lifting, "
        .. title
        .. " makes it look and feel great.\n\n"
        .. F.String.Silver("Use ")
        .. F.String.Good("Next >")
        .. F.String.Silver(" to learn how to get around, or close this window to jump right in."),
    },

    -- Page 2: Accessing Settings
    {
      title = "Accessing Settings",
      text = "All settings live in the "
        .. title
        .. " options panel, accessible in several ways:\n\n"
        .. F.String.Good("/ec")
        .. "  - Open the full ElvUI config. Find the "
        .. title
        .. " tab in the sidebar.\n"
        .. F.String.Good("/tx")
        .. "  - Jump directly to the "
        .. title
        .. " options.\n"
        .. F.String.Good("ESC")
        .. "  - The game menu has an "
        .. F.String.ElvUI("ElvUI")
        .. " button that opens the config.\n\n"
        .. "Inside the options panel the "
        .. F.String.ToxiUI("ToxiUI")
        .. " section contains everything "
        .. "specific to this edit: themes, class icons, gradient mode, and more.",
    },

    -- Page 3: Key Features
    {
      title = "What's Inside",
      text = F.String.ToxiUI("Themes")
        .. "  - Gradient health bars and Dark Mode. "
        .. F.String.Silver("ToxiUI > Themes")
        .. ".\n\n"
        .. F.String.ToxiUI("Skins")
        .. "  - Applies "
        .. title
        .. " styling to Blizzard's Cooldown Manager, "
        .. "Blizzard's Damage Meter, Class Icons on unit frames, and various ElvUI elements. "
        .. F.String.Silver("ToxiUI > Skins")
        .. ".\n\n"
        .. F.String.ToxiUI("WunderBar")
        .. "  - A sleek info bar showing currency, durability, system stats, "
        .. "and more. Fully configurable. "
        .. F.String.Silver("ToxiUI > WunderBar")
        .. ".\n\n"
        .. F.String.ToxiUI("Armory")
        .. "  - Enhances the default ElvUI armory panel with a richer layout, "
        .. "gradient styling, and more detailed character info. "
        .. F.String.Silver("ToxiUI > Armory")
        .. ".\n\n"
        .. F.String.ToxiUI("Fonts")
        .. "  - Override the fonts used across the entire UI from one place. "
        .. F.String.Silver("ToxiUI > Fonts")
        .. ".",
    },

    -- Page 4: Hidden Gems
    {
      title = "Hidden Gems",
      text = "A few less obvious features worth knowing about:\n\n"
        .. F.String.ToxiUI("Additional Scaling")
        .. "  - Independently scale Blizzard frames that ElvUI "
        .. "cannot resize on its own, such as the character frame, world map, quest dialog windows and more. "
        .. F.String.Silver("ToxiUI > Plugins > Additional Scaling")
        .. ".\n\n"
        .. F.String.ToxiUI("Vehicle Bar")
        .. "  - Shows a clean, styled action bar when entering a vehicle, "
        .. "skyriding, or possessing a unit, then hides it automatically when done. "
        .. F.String.Silver("ToxiUI > General > Vehicle Bar")
        .. ".\n\n"
        .. F.String.ToxiUI("Performance Mode")
        .. "  - Temporarily strips back heavy visual features for "
        .. "extra frames when you need them most. "
        .. F.String.Silver("ToxiUI > Performance")
        .. ".\n\n"
        .. F.String.ToxiUI("Contacts")
        .. "  - Quick links to the "
        .. title
        .. " website and Discord, "
        .. "right inside the options panel. "
        .. F.String.Silver("ToxiUI > Contacts")
        .. ".",
    },

    -- Page 5: Getting Help
    {
      title = "Getting Help",
      text = "If you run into anything unexpected, here is where to go:\n\n"
        .. F.String.ToxiUI("Website")
        .. "  - "
        .. F.String.Silver("toxiui.com")
        .. "\n"
        .. F.String.ToxiUI("Discord")
        .. "  - "
        .. F.String.Silver("discord.gg/toxiui")
        .. F.String.Silver(" (support, suggestions, community)")
        .. "\n"
        .. F.String.ToxiUI("Changelog")
        .. "  - "
        .. F.String.Good("/tx")
        .. F.String.Silver(" > Changelog tab")
        .. "\n\n"
        .. "Thank you for using "
        .. title
        .. "! Enjoy the experience.\n\n"
        .. F.String.Silver("Tip: Create an ElvUI profile backup before making major changes  - ")
        .. F.String.Silver("ElvUI Config > Profiles > Export Profile."),
    },
  }
end
