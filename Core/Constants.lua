local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

I.Constants = {}

I.Constants.SKYWARD_ASCENT_SPELL_ID = 372610
I.Constants.THRILL_OF_THE_SKIES_SPELL_ID = 377234

local function Cmd(slash)
  return F.String.ToxiUI(slash)
end

local function Click(action)
  return F.String.Class(action, "ROGUE")
end

I.Constants.RandomTips = {
  -- 1
  TXUI.Title
    .. " has three different themes to choose from: Normal, "
    .. F.String.GradientMode()
    .. " & Dark Mode. You can swap between them in "
    .. TXUI.Title
    .. " "
    .. F.String.Menu.Themes()
    .. " settings",
  -- 2
  "The bar at the bottom is called WunderBar. It is heavily customizable and you can play around with it in " .. TXUI.Title .. " settings or by typing " .. Cmd("/tx wb"),
  -- 3
  "There is a "
    .. TXUI.Title
    .. " website that has a lot of useful information and also articles about what's happening in "
    .. TXUI.Title
    .. "!\n\nCheck it out at "
    .. F.String.ToxiUI(I.Strings.Branding.Links.Website),
  -- 4
  "There is a " --
    .. TXUI.Title
    .. " Discord server if you ever need help or just want to chat! Check out the "
    .. TXUI.Title
    .. " settings "
    .. F.String.Menu.Contacts()
    .. " tab for links.",
  -- 5
  "The same " .. TXUI.Title .. " AddOn can be installed on all four versions: Midnight, Mists of Pandaria Classic, The Burning Crusade Classic & Vanilla",
  -- 6
  "The first version of " .. TXUI.Title .. " was released on " .. F.String.Class("October 18, 2020") .. " and the Discord server was created a week later, on " .. F.String.Class(
    "October 24, 2020"
  ),
  -- 7
  "If you want to support " .. TXUI.Title .. " visit the " .. TXUI.Title .. " website's FAQ page at " .. I.Strings.Branding.Links.Website .. "/faq/",
  -- 8
  "You can change " .. F.String.GradientMode() .. " colors in " .. TXUI.Title .. " " .. F.String.Menu.Themes() .. " settings",
  -- 9
  TXUI.Title
    .. " like many other AddOns is being constantly updated. Remember to update your AddOns every day! Type "
    .. Cmd("/tx cl")
    .. " to open the "
    .. F.String.Menu.Changelog()
    .. " and find out what's new",
  -- 10
  "To easily manage your AddOns all in one client, we recommend using the CurseForge version of " .. F.String.ToxiUI("WowUp.io"),
  -- 11
  "All UnitFrame texts are Custom Texts. To edit them go to ElvUI UnitFrame settings -> Select which unit -> Custom Texts.\n"
    .. F.String.Class("Class Icons")
    .. " are also Custom Texts!",
  -- 12
  "Most elements are hidden until you hover over them with your mouse. One example of that is the Pet ActionBar, which is under your Player UnitFrame.",
  -- 13
  "If you're finding some UI elements too small, check out the "
    .. F.String.Scaling()
    .. " in "
    .. TXUI.Title
    .. " "
    .. F.String.Menu.Plugins()
    .. " settings. If an element is missing, let us know and we might add it!",
  -- 14
  "These tips change each time you open the game menu. Make sure to check them out since we keep adding new ones. Never know when you might learn something new! ;)",
  -- 15
  "You can switch to different " .. F.String.Menu.Styles() .. " in " .. TXUI.Title .. " settings!",
  -- 16
  "Right-clicking a mover in " .. F.String.ElvUI() .. " movers will open the settings for that mover if it has any.",
  -- 17
  "Check out the " .. TXUI.Title .. " YouTube channel to find various guides, patch update information and more!\n\n" .. F.String.ToxiUI("https://www.youtube.com/@ToxiTV"),
  -- 18
  "Whenever there is an update for "
    .. TXUI.Title
    .. ", you don't need to run the full installer! Type "
    .. Cmd("/tx update")
    .. " to open the Profile Updater and pick only the parts of the UI you want to update.",
  -- 19
  "Did you know you can change the textures for " .. F.String.Details() .. " while in " .. F.String.GradientMode() .. "? Try changing all 3 bar textures to " .. F.String.ToxiUI(
    "- Tx Half Fade Stroke"
  ) .. " and disabling the border for a cool design.",
  -- 20
  "Did you know you can change the textures for UnitFrames while in "
    .. F.String.GradientMode()
    .. "? Try changing the Health texture to "
    .. F.String.ToxiUI("- Tx Fade")
    .. " under "
    .. TXUI.Title
    .. " "
    .. F.String.GradientMode()
    .. " settings for a cool design.",
  -- 21
  "Found a bug? Type " .. Cmd("/tx status") .. " to open the Status Report and include it when reporting the issue on Discord. It saves everyone a lot of back and forth!",
  -- 22
  "Something broke after updating your AddOns? Type "
    .. Cmd("/tx debug on")
    .. " to disable every AddOn except "
    .. F.String.ElvUI()
    .. ", "
    .. TXUI.Title
    .. " & "
    .. F.String.Details()
    .. " to find the culprit. Type "
    .. Cmd("/tx debug off")
    .. " to turn them all back on.",
  -- 23
  "Can't remember a command? The " .. F.String.Menu.General() .. " tab in " .. TXUI.Title .. " settings has a Commands section listing all of them.",
  -- 24
  "Type " .. Cmd("/kb") .. " to enter keybind mode, then hover over any ActionBar button and press a key to bind it.",
  -- 25
  "Hover over any WunderBar module to see what it can do. Most of them have extra actions on " .. Click("Left Click") .. ", " .. Click("Right Click") .. " and even " .. Click(
    "Shift + Click"
  ) .. "!",
  -- 26
  Click("Middle Click") .. " the clock on the WunderBar to quickly reload your UI.",
  -- 27
  Click("Right Click") .. " the Profession module on the WunderBar to see all of your professions at once.",
  -- 28
  "Playing on a low-end PC or want every last frame in raids? "
    .. F.String.Menu.Performance()
    .. " Mode in "
    .. TXUI.Title
    .. " settings disables heavier features with one click and restores them when you turn it off.",
  -- 29
  "Blizzard windows like the Character sheet animate when they open. You can change the speed and style of each animation, or turn them off, under Animations in "
    .. TXUI.Title
    .. " "
    .. F.String.Menu.Plugins()
    .. " settings.",
  -- 30
  "The coordinates on your Minimap can be moved around and restyled. Check out Minimap Coordinates in " .. TXUI.Title .. " " .. F.String.Menu.Plugins() .. " settings.",
  -- 31
  "Want something a bit more subtle? Try Dark Mode with transparency enabled in " .. TXUI.Title .. " " .. F.String.Menu.Themes() .. " settings.",
  -- 32
  "Messed something up? The "
    .. F.String.Menu.Reset()
    .. " tab in "
    .. TXUI.Title
    .. " settings can reset individual modules like the WunderBar without touching the rest of your setup.",
  -- 33
  "This screen also shows up when you're AFK! You can toggle the "
    .. TXUI.Title
    .. " AFK screen, its tips, emotes and camera rotation in "
    .. TXUI.Title
    .. " "
    .. F.String.Menu.Skins()
    .. " settings.",
}

-- Tips for features only available on Retail & Forever clients
if TXUI.IsModern then
  local tips = I.Constants.RandomTips

  tips[#tips + 1] = "Keeping your ActionBars hidden and relying on the " .. F.String.CDM() .. " will improve your gameplay and remove unnecessary clutter from your screen!"

  tips[#tips + 1] = "Type " .. Cmd("/cd") .. " to open the " .. F.String.CDM() .. " settings and " .. Cmd("/em") .. " to open Edit Mode."

  tips[#tips + 1] = "Using the "
    .. F.String.CDM()
    .. "? Enable the "
    .. TXUI.Title
    .. " "
    .. F.String.CDM()
    .. " features in "
    .. TXUI.Title
    .. " "
    .. F.String.Menu.Skins()
    .. " settings to make it fade with your Player UnitFrame and sync your Power Bar, Class Bar and Castbar widths to it."

  tips[#tips + 1] = "The Blizzard Damage Meter can automatically reset when you enter a new instance. Enable Auto Reset in "
    .. TXUI.Title
    .. " "
    .. F.String.Menu.Skins()
    .. " settings so you don't have to set it up on every character."

  tips[#tips + 1] = Click("Middle Click") .. " or " .. Click("Right Click") .. " the Durability module on the WunderBar to summon your repair mount."

  tips[#tips + 1] = "Open your Character sheet to see the "
    .. TXUI.Title
    .. " "
    .. F.String.Menu.Armory()
    .. ". It shows item levels and enchants at a glance and can be customized in "
    .. TXUI.Title
    .. " settings."
end

-- Tips for features only available on Retail
if TXUI.IsRetail then
  local tips = I.Constants.RandomTips

  tips[#tips + 1] = Click("Shift-Left Click") .. " the Hearthstone module on the WunderBar to open a menu with your Mythic+ and Raid teleports."

  tips[#tips + 1] = "The Weekly module on the WunderBar tracks your Great Vault and Keystone. "
    .. Click("Right Click")
    .. " it to teleport straight to your Keystone dungeon, or "
    .. Click("Shift-Left Click")
    .. " to link your Keystone in chat."

  tips[#tips + 1] = Click("Shift + Left Click") .. " the Currency module on the WunderBar to summon your Mobile Warbank."

  tips[#tips + 1] = "Have a disenchanting, milling or prospecting profession? Use the Deconstruct button in your bags to quickly break down items. The highlight, glow and labels can be tweaked in "
    .. TXUI.Title
    .. " "
    .. F.String.Menu.Skins()
    .. " settings."

  tips[#tips + 1] = "Don't like the class colors on the Skyriding Bar? You can pick your own gradient colors, change its height or hide the speed text under VehicleBar in "
    .. TXUI.Title
    .. " "
    .. F.String.Menu.Plugins()
    .. " settings."
end
