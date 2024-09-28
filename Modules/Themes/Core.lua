local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local TH = TXUI:NewModule("Themes")

function TH:Toggle(theme, value)
  -- Don't allow changes before init
  if not self.Initialized then return end

  -- get profiles
  local pf = TXUI:GetModule("Profiles")

  --
  -- GradientMode
  --
  if theme == "gradientMode" then
    -- save settings
    E.db.TXUI.themes.gradientMode.enabled = value

    -- apply texture settings
    pf:UpdateProfileForGradient()

    -- apply custom texture skinning to elvui
    F.Event.TriggerEvent("ThemesGradients.DatabaseUpdate")

    -- apply custom texture skinning to details
    F.Event.TriggerEvent("SkinsDetailsGradients.DatabaseUpdate")

    -- apply custom tags
    F.Event.TriggerEvent("Tags.DatabaseUpdate")
  end

  --
  -- Dark Mode
  --
  if theme == "darkMode" then
    -- save settings
    E.db.TXUI.themes.darkMode.enabled = value
    E.db.TXUI.themes.darkMode.transparency = value

    TXUI:GetModule("SplashScreen"):Wrap("Installing ...", function()
      -- apply elvui profile
      pf:UpdateProfileForTheme()

      -- execute elvui update, callback later
      pf:ExecuteElvUIUpdate(function()
        -- Hide Splash
        TXUI:GetModule("SplashScreen"):Hide()

        -- apply transparency to elvui
        F.Event.TriggerEvent("ThemesDarkTransparency.DatabaseUpdate")

        -- apply dark mode skinning to details
        F.Event.TriggerEvent("SkinsDetailsDark.DatabaseUpdate")

        -- apply custom tags
        F.Event.TriggerEvent("Tags.DatabaseUpdate")
      end, true)
    end, true)
  end

  --
  -- Dark Mode Transparency
  --
  if theme == "darkModeTransparency" then
    -- save settings
    E.db.TXUI.themes.darkMode.transparency = value

    -- apply transparency to elvui
    F.Event.TriggerEvent("ThemesDarkTransparency.DatabaseUpdate")

    -- apply dark mode skinning to details
    F.Event.TriggerEvent("SkinsDetailsDark.DatabaseUpdate")

    -- apply custom tags
    F.Event.TriggerEvent("Tags.DatabaseUpdate")
  end

  if theme == "darkModeGradientName" then
    -- save settings
    E.db.TXUI.themes.darkMode.gradientName = value

    -- apply custom tags
    F.Event.TriggerEvent("Tags.DatabaseUpdate")
  end

  if theme == "darkModeDetailsGradientText" then
    -- Save settings
    E.db.TXUI.themes.darkMode.detailsGradientText = value

    -- Fire details update
    F.Event.TriggerEvent("SkinsDetailsDark.DatabaseUpdate")
  end
end

function TH:Initialize()
  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(TH:GetName())
