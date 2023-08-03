local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local CL = TXUI:GetModule("Changelog")

local CANCEL = CANCEL
local format = string.format

function CL:LoadPopups()
  local versionString = self:FormattedVersion()

  -- Create updater popup
  E.PopupDialogs.TXUI_OPEN_UPDATER = {
    text = format("Welcome to %s %s!", TXUI.Title, versionString),
    button1 = "Install Update",
    button2 = CANCEL,
    OnAccept = function()
      E:GetModule("PluginInstaller"):Queue(TXUI:GetModule("Installer"):Dialog())
    end,
    hideOnEscape = 1,
    whileDead = 1,
  }

  -- Create changelog popup
  E.PopupDialogs.TXUI_OPEN_CHANGELOG = {
    text = format("Thank you for installing %s %s!", TXUI.Title, versionString),
    button1 = "Changelog",
    button2 = CANCEL,
    OnAccept = function()
      E.db.TXUI.changelog.seenVersion = TXUI.ReleaseVersion
      E:ToggleOptions("TXUI,changelog")
    end,
    OnCancel = function()
      E.db.TXUI.changelog.seenVersion = TXUI.ReleaseVersion
    end,
    hideOnEscape = 1,
    whileDead = 1,
  }

  -- Create update private profile popup
  E.PopupDialogs.TXUI_OPEN_PRIVATE_UPDATER = {
    text = "You are using the " .. TXUI.Title .. " Profile but your Character Profile is not updated.",
    button1 = "Update",
    button2 = CANCEL,
    OnAccept = function()
      TXUI:GetModule("Installer"):Privates()
    end,
    OnCancel = function()
      -- you clicked cancel, this is fine, but don't you dare ask for support
      if E.private.TXUI.changelog.releaseVersion and E.private.TXUI.changelog.releaseVersion ~= 0 then E.private.TXUI.changelog.releaseVersion = TXUI.ReleaseVersion end
    end,
    whileDead = 1,
    showAlert = 1,
    preferredIndex = 3,
  }
end
