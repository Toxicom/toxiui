local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

I.Constants = {}

I.Constants.VIGOR_BAR_ID = 631

I.Constants.RandomTips = {
  -- 1
  TXUI.Title
    .. " has three different themes to choose from. You can swap to Normal mode or Dark Mode in "
    .. TXUI.Title
    .. " Themes settings",
  -- 2
  "The bar at the bottom is called WunderBar. It is heavily customizable and you can play around with it in "
    .. TXUI.Title
    .. " settings",
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
  "The same "
    .. TXUI.Title
    .. " AddOn can be installed on all three versions: Retail, Mists of Pandaria Classic & Vanilla",
  -- 6
  "The first version of "
    .. TXUI.Title
    .. " was released on "
    .. F.String.Class("October 18, 2020")
    .. " and the Discord server was created a week later, on "
    .. F.String.Class("October 24, 2020"),
  -- 7
  "If you want to support "
    .. TXUI.Title
    .. " visit the "
    .. TXUI.Title
    .. " website's FAQ page at "
    .. I.Strings.Branding.Links.Website
    .. "/faq/",
  -- 8
  "You can change Gradient colors in "
    .. TXUI.Title
    .. " Theme settings",
  -- 9
  TXUI.Title
    .. " like many other AddOns is being constantly updated. Remember to update your AddOns every day! See the changelog in "
    .. TXUI.Title
    .. " settings to find out what's new",
  -- 10
  "To easily manage your AddOns all in one client, we recommend using the CurseForge version of " .. F.String.ToxiUI("WowUp.io"),
  -- 11
  "Keeping your ActionBars hidden and relying on WeakAuras will improve your gameplay and remove unnecessary clutter from your screen!",
  -- 12
  "All UnitFrame texts are Custom Texts. To edit them go to ElvUI UnitFrame settings -> Select which unit -> Custom Texts.\n"
    .. F.String.Class("Class Icons")
    .. " are also Custom Texts!",
  -- 13
  "Most elements are hidden until you hover over them with your mouse. One example of that is the Pet ActionBar, which is under your Player UnitFrame.",
  -- 14
  "If you're finding some UI elements too small, check out the "
    .. F.String.Scaling()
    .. " in "
    .. TXUI.Title
    .. " settings. If an element is missing, let us know and we might add it!",
  -- 15
  "These tips change each time you open the game menu. Make sure to check them out since we keep adding new ones. Never know when you might learn something new! ;)",
  -- 16
  "You can switch to different "
    .. F.String.Menu.Styles()
    .. " in "
    .. TXUI.Title
    .. " settings!",
  -- 17
  "Right-clicking a mover in "
    .. F.String.ElvUI()
    .. " movers will open the settings for that mover if it has any.",
  -- 18
  "Check out the "
    .. TXUI.Title
    .. " YouTube channel to find various guides, patch update information and more!\n\n"
    .. F.String.ToxiUI("https://www.youtube.com/@ToxiTV"),
  -- 19
  "Whenever there is an update for "
    .. TXUI.Title
    .. ", you don't need to fully run the installer! Simply check the "
    .. F.String.Class("Profile updates", "ROGUE")
    .. " section in the changelog to decide if there are parts of the UI you might want to update by running the installer.",
  -- 20
  "Did you know you can change the textures for "
    .. F.String.Details()
    .. " while in Gradient Mode? Try changing all 3 bar textures to "
    .. F.String.ToxiUI("- Tx Half Fade Stroke")
    .. " and disabling the border for a cool design.",
  -- 21
  "Did you know you can change the textures for UnitFrames while in Gradient Mode? Try changing the Health texture to "
    .. F.String.ToxiUI("- Tx Fade")
    .. " under "
    .. TXUI.Title
    .. " Gradient Mode settings for a cool design.",
}
