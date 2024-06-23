local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

I.Constants = {}

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
    .. "!\nCheck it out at "
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
    .. " AddOn can be installed on all three versions: Retail, Cataclysm Classic & Vanilla",
  -- 6
  "The first version of "
    .. TXUI.Title
    .. " was released on "
    .. F.String.GradientClass("October 18, 2020")
    .. " and the Discord server was created a week later, on "
    .. F.String.GradientClass("October 24, 2020"),
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
  "All UnitFrame texts are Custom Texts. To edit them go to ElvUI UnitFrame settings -> Select which unit -> Custom Texts. "
    .. F.String.GradientClass("Class Icons")
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
  "These tips change each time you reload your UI or log in. Make sure to check them out since we keep adding new ones. Never know when you might learn something new! ;)",
  -- 16
  "You can switch to different "
    .. F.String.Menu.Styles()
    .. " in "
    .. TXUI.Title
    .. " settings!",
}
