local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))

local EnableAddOn = (C_AddOns and C_AddOns.EnableAddOn) or EnableAddOn
local format = string.format
local ipairs = ipairs
local IsAddOnLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded
local LoadAddOn = (C_AddOns and C_AddOns.LoadAddOn) or LoadAddOn
local pairs = pairs
local ReloadUI = ReloadUI
local sort = table.sort
local strrep = strrep
local strsplit = strsplit
local tconcat = table.concat
local tinsert = table.insert
local tostring = tostring
local type = type

local function createExportFrame(profileExport, needsReload, btnFunc)
  if not IsAddOnLoaded("ElvUI_Options") then
    EnableAddOn("ElvUI_Options")
    LoadAddOn("ElvUI_Options")
  end

  if not E.Libs.AceGUI then E:AddLib("AceGUI", "AceGUI-3.0") end

  local frame = E.Libs.AceGUI:Create("Frame")
  frame:SetTitle("Export")
  frame:EnableResize(false)
  frame:SetWidth(800)
  frame:SetHeight(600)
  frame:SetLayout("flow")
  frame.frame:SetFrameStrata("FULLSCREEN_DIALOG")
  frame.frame:SetScript("OnHide", function()
    if needsReload then ReloadUI() end
  end)

  local box = E.Libs.AceGUI:Create("MultiLineEditBox-ElvUI")
  box:SetNumLines(36)
  box:DisableButton(true)
  box:SetWidth(1000)
  box:SetLabel("Export")
  frame:AddChild(box)

  box.editBox:SetScript("OnCursorChanged", nil)
  box.scrollFrame:UpdateScrollChildRect()
  box:SetText(profileExport)
  box.editBox:HighlightText()
  box:SetFocus()

  frame.box = box

  if btnFunc then
    local importButton = E.Libs.AceGUI:Create("Button-ElvUI") --This version changes text color on SetDisabled
    importButton:SetText("Decode")
    importButton:SetAutoWidth(true)
    importButton:SetCallback("OnClick", btnFunc)
    frame:AddChild(importButton)
  end

  return frame
end

local function exportNames()
  local elvDB = ElvDB
  if not elvDB then return TXUI:LogDebug("ElvDB could not be found, this is impossible") end

  local exportTable = {}
  local printNames = {}

  for namerealm, _ in pairs(elvDB.profileKeys) do
    local name, realm = strsplit(" - ", namerealm, 2)
    if name and realm then
      local exportName = format("%s-%s", name, E:ShortenRealm(realm))
      exportTable[exportName] = true
      tinsert(printNames, exportName)
    else
      TXUI:LogDebug("Could not parse name and realm", namerealm)
    end
  end

  exportTable["__META_FLAVOR__"] = TXUI.Flavor

  local distributor = E:GetModule("Distributor")
  local libDeflate = E.Libs.Deflate

  local serialData = distributor:Serialize(exportTable)
  local compressedData = libDeflate:CompressDeflate(serialData, libDeflate.compressLevel)
  local encodedData = libDeflate:EncodeForPrint(compressedData)

  -- Set export to window
  createExportFrame(encodedData)

  -- Print Names
  TXUI:LogInfo("Exported Names include: ", F.String.Good(tconcat(printNames, ", ")))
end


function TXUI:ExportProfile(addon)
  if addon == "names" then exportNames() end
end
