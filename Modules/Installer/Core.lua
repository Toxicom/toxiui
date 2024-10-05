local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local IS = TXUI:NewModule("Installer", "AceHook-3.0")
local PF = TXUI:GetModule("Profiles")

local _G = _G
local ipairs = ipairs
local PlaySound = PlaySound
local ReloadUI = ReloadUI
local strtrim = strtrim

local CANCEL = CANCEL
local OKAY = OKAY

IS.reloadRequired = false
IS.installerOpen = false

function IS:ShowStepCompleteHook()
  local stepComplete = _G["PluginInstallStepComplete"]

  if not self:IsHooked(stepComplete, "OnShow") then
    -- Change colors
    stepComplete.bg:SetVertexColor(0, 0, 0, 0.75)
    stepComplete.lineTop:SetVertexColor(0, 0, 0, 1)
    stepComplete.lineBottom:SetVertexColor(0, 0, 0, 1)

    -- Hook script, for better animations and bug fixes
    self:RawHookScript(stepComplete, "OnShow", function(frame)
      if frame.message then
        -- LevelUp Sound
        PlaySound(888)

        -- Set Text
        frame.text:SetText(frame.message)

        -- Reset fade timer
        E:UIFrameFadeOut(frame, 0.25, 0, 1)

        -- Start fading out later but hide quicker
        E:Delay(2.5, function()
          E:UIFrameFadeOut(frame, 0.25, 1, 0)
        end)

        -- Hide after 4 seconds if no other message was shown
        E:Delay(4, function()
          if frame:GetAlpha() <= 0 then frame:Hide() end
        end)

        -- Empty message
        frame.message = nil
      else
        frame:Hide()
      end
    end)
  end
end

function IS:ShowStepComplete(step)
  step = "|cccffffff" .. step .. "|r"

  -- Hook if needed
  self:ShowStepCompleteHook()

  -- Show banner
  local stepComplete = _G["PluginInstallStepComplete"]
  stepComplete:Hide()
  stepComplete.message = step
  stepComplete:Show()

  -- Show in chat
  TXUI:LogInfo(step)
end

-- Layout Settings
function IS:ElvUI(callback)
  -- Set right versions, we do this here cause of IsTXUIProfile checks
  E.db.TXUI.changelog.lastLayoutVersion = TXUI.ReleaseVersion
  E.db.TXUI.changelog.releaseVersion = TXUI.ReleaseVersion
  E.private.TXUI.changelog.releaseVersion = TXUI.ReleaseVersion

  -- Force DB layout update before making changes
  E:UpdateDB()

  -- Disable dual spec during installation
  if not TXUI.IsVanilla and E.data:IsDualSpecEnabled() then E.data:SetDualSpecEnabled(false) end

  -- ElvUI: Profile
  PF:MergeElvUIProfile()
  PF:ElvUIProfilePrivate()
  PF:ElvUIProfileGlobal()

  -- ElvUI: Fonts
  PF:ElvUIFont()
  PF:ElvUIFontPrivates()

  -- Apply other Additonal Addons
  PF:ElvUIAdditional()
  PF:ElvUIAdditionalPrivate()

  -- Apply AddOnSkins settings
  PF:AddOnSkins()

  -- Force UIScale
  E:UIScale(true)
  E:UIScale()
  E:PixelScaleChanged("UI_SCALE_CHANGED")

  -- Setup CVars
  PF:ElvUICVars()

  -- Apply chat font, dosen't needed if PF:ElvUIChat is called
  PF:ElvUIChatFont()

  -- Execute full ElvUI Update
  PF:ExecuteElvUIUpdate(function()
    TXUI:GetModule("SplashScreen"):Hide()

    -- Customize message
    local msg = TXUI.Title
      .. " "
      .. (E.db.TXUI.installer.layout == I.Enum.Layouts.HORIZONTAL and F.String.Class("Horizontal", "MONK") or F.String.ToxiUI("Vertical") .. " layout installed.")

    -- Show success message
    self:ShowStepComplete(msg)

    -- Call callback
    if callback then callback() end
  end)
end

function IS:Privates()
  -- ElvUI
  PF:ElvUIProfilePrivate()
  PF:ElvUIAdditionalPrivate()
  PF:ElvUIFontPrivates()

  -- AddOns
  PF:AddOnSkins_Private()
  PF:Details_Private()
  PF:Plater_Private()

  self:Complete()
end

-- Installer Complete
function IS:Complete(noReload)
  E.db.TXUI.changelog.releaseVersion = TXUI.ReleaseVersion
  E.private.TXUI.changelog.releaseVersion = TXUI.ReleaseVersion

  if not noReload and not E.staggerUpdateRunning then ReloadUI() end
end

-- Profile Check
function IS:ElvUIProfileDialog()
  local function createNewProfile(name)
    if strtrim(name) == "" then return end

    if not TXUI.IsVanilla and E.data:IsDualSpecEnabled() then
      E.data:SetDualSpecProfile(name)
    else
      E.data:SetProfile(name)
    end

    E:StaticPopup_Hide("INCOMPATIBLE_ADDON")
    IS:ShowStepComplete("Profile Created")
    if self.installerOpen and not TXUI.PreventProfileUpdates then E:GetModule("PluginInstaller"):SetPage(2) end
  end

  local textInfo = "Name for the new profile"
  local errorInfo = "Note: A profile with that name already exists"
  local dialogName = "TXUI_CreateProfileNameNew"

  E.PopupDialogs[dialogName] = {
    text = textInfo,
    timeout = 0,
    hasEditBox = 1,
    whileDead = 1,
    hideOnEscape = 1,
    editBoxWidth = 350,
    maxLetters = 127,
    OnShow = function(frame)
      frame.editBox:SetAutoFocus(false)
      frame.editBox:SetText(I.ProfileNames.Default)
      frame.editBox:HighlightText()
    end,
    button1 = OKAY,
    button2 = CANCEL,
    OnAccept = function(frame)
      createNewProfile(frame.editBox:GetText())
    end,
    EditBoxOnEnterPressed = function(editBox)
      createNewProfile(editBox:GetText())
      editBox:GetParent():Hide()
    end,
    EditBoxOnEscapePressed = function(editBox)
      editBox:GetParent():Hide()
    end,
    EditBoxOnTextChanged = function(editBox)
      if strtrim(editBox:GetText()) == "" then
        editBox:GetParent().button1:Disable()
      else
        editBox:GetParent().button1:Enable()

        local parent = editBox:GetParent()
        local textObj = _G[parent:GetName() .. "Text"]

        local profs = E.data:GetProfiles()
        for _, name in ipairs(profs) do
          if name == editBox:GetText() then
            textObj:SetText(textInfo .. "\n\n" .. F.String.Warning(errorInfo))

            parent.maxHeightSoFar = 0
            E:StaticPopup_Resize(parent, dialogName)
            return
          end
        end

        textObj:SetText(textInfo)

        parent.maxHeightSoFar = 0
        E:StaticPopup_Resize(parent, dialogName)
      end
    end,
    OnEditFocusGained = function(editBox)
      editBox:HighlightText()
    end,
  }

  E:StaticPopup_Show(dialogName)
end

-- Initialization
function IS:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(IS:GetName())
