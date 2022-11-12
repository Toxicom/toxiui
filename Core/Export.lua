local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

local EnableAddOn = EnableAddOn
local format = string.format
local gsub = string.gsub
local ipairs = ipairs
local IsAddOnLoaded = IsAddOnLoaded
local LoadAddOn = LoadAddOn
local next = next
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
  if not IsAddOnLoaded("ElvUI_OptionsUI") then
    EnableAddOn("ElvUI_OptionsUI")
    LoadAddOn("ElvUI_OptionsUI")
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

--@do-not-package@

local function removeEmptySubTables(tbl)
  if type(tbl) ~= "table" then return end

  if next(tbl) == nil then
    tbl = nil
    return tbl
  end

  for _, v in pairs(tbl) do
    if type(v) == "table" then
      if next(v) ~= nil then removeEmptySubTables(v) end
    end
  end

  for k, v in pairs(tbl) do
    if type(v) == "table" then
      if next(v) == nil then tbl[k] = nil end
    end
  end
end

local function generateLuaServerTable(tbl, level, out, flavor)
  local tkeys = {}

  for i in pairs(tbl) do
    tinsert(tkeys, i)
  end

  sort(tkeys, function(a, b)
    local A, B = type(a), type(b)

    if A == B then
      if A == "string" then
        local _, serverA = strsplit("-", a)
        local _, serverB = strsplit("-", b)
        if serverA and serverB then return serverA < serverB end

        return a < b
      end
    end

    return A < B
  end)

  local lastServer

  for _, i in ipairs(tkeys) do
    local v = tbl[i]
    local isStr = type(i) == "string"
    local ret, skip = "", false

    if isStr then
      local _, serverStr = strsplit("-", i)
      if serverStr then
        if lastServer ~= serverStr then
          if lastServer ~= nil then ret = ret .. "\n" end
          ret = ret .. strrep("  ", level) .. "-- " .. serverStr .. "\n"
        end
        lastServer = serverStr
      end
    end

    ret = ret .. strrep("  ", level) .. "["
    if isStr then
      if i == "__FLAVOR__" then
        ret = ret .. "I.Enum.Flavor." .. flavor
      elseif i == "__META_FLAVOR__" then
        skip = true
      else
        ret = ret .. "\"" .. i .. "\""
      end
    else
      ret = ret .. i
    end

    if not skip then
      ret = ret .. "] = "

      if type(v) == "number" then
        ret = ret .. v .. ",\n"
      elseif type(v) == "string" then
        ret = ret .. "\"" .. v:gsub("\\", "\\\\"):gsub("\n", "\\n"):gsub("\"", "\\\""):gsub("\124", "\124\124") .. "\",\n"
      elseif type(v) == "boolean" then
        if v then
          ret = ret .. "true,\n"
        else
          ret = ret .. "false,\n"
        end
      elseif type(v) == "table" then
        ret = ret .. "{\n"
        ret = generateLuaServerTable(v, level + 1, ret, flavor)
        ret = ret .. strrep("  ", level) .. "},\n"
      else
        ret = ret .. "\"" .. tostring(v) .. "\",\n"
      end

      out = out .. ret
    end
  end

  return out
end

local function exportImportNames()
  local distributor = E:GetModule("Distributor")
  local libDeflate = E.Libs.Deflate

  local frame
  frame = createExportFrame("", false, function()
    local dataString = frame.box:GetText()

    local function showError(msg, ...)
      TXUI:LogInfo(msg, ...)
      frame:SetTitle(F.String.Error(msg))
    end

    local decodedData = libDeflate:DecodeForPrint(dataString)
    local decompressedData, decompressedMessage = libDeflate:DecompressDeflate(decodedData)

    if not decompressedData then return showError("Error decompressing data", decompressedMessage) end

    local deserializedData = E:SplitString(decompressedData, "^^::")
    deserializedData = format("%s%s", deserializedData, "^^")

    local success, nameData = distributor:Deserialize(deserializedData)

    if not success or not nameData then
      showError("Error deserializing", nameData, decompressedData)
      return
    end

    local flavor = nameData["__META_FLAVOR__"]
    if type(flavor) == "number" then
      flavor = I.Enum.Flavor[flavor]
    else
      flavor = I.Enum.Flavor[I.Enum.Flavor.RETAIL]
    end

    -- Generate Table
    frame.box:SetText(generateLuaServerTable({
      ["USERNAME"] = {
        ["__FLAVOR__"] = nameData,
      },
    }, 0, "", flavor))
  end)
end

local function convertFonts(str)
  local replaceTable = {
    [I.Fonts.Primary] = "I.Fonts.Primary",
    [I.Fonts.PrimaryBold] = "I.Fonts.PrimaryBold",
    [I.Fonts.Title] = "I.Fonts.Title",
    [I.Fonts.Number] = "I.Fonts.Number",
    [I.Fonts.BigNumber] = "I.Fonts.BigNumber",
    [I.Fonts.Icons] = "I.Fonts.Icons",
  }

  for word, repl in pairs(replaceTable) do
    local replStr = str:gsub(word, repl)
    if replStr ~= str then return true, format("F.FontOverride(%s)", replStr) end
  end

  return false, str
end

local function keySort(a, b)
  local A, B = type(a), type(b)

  if A == B then
    if A == "number" or A == "string" then
      return a < b
    elseif A == "boolean" then
      return (a and 1 or 0) > (b and 1 or 0)
    end
  end

  return A < B
end

local function recurseStringify(data, level, lines)
  local tkeys = {}

  for i in pairs(data) do
    tinsert(tkeys, i)
  end

  sort(tkeys, keySort)

  for _, k in ipairs(tkeys) do
    local v = data[k]

    local lineFormat = strrep("  ", level) .. "[%s] = %s"
    local form1, form2
    local kType, vType = type(k), type(v)
    if kType == "string" then
      form1 = "%q"
    elseif kType == "number" then
      form1 = "%d"
    else
      form1 = "%s"
    end
    if vType == "string" then
      local didReplace, replacedV = convertFonts(v)
      if didReplace then
        v = replacedV
        form2 = "%s"
      else
        v = v:gsub("\\", "\\\\"):gsub("\n", "\\n"):gsub("\"", "\\\"")
        form2 = "%q"
      end
    elseif vType == "boolean" then
      v = tostring(v)
      form2 = "%s"
    elseif vType == "number" then
      v = v > 1 and F.Round(v) or v
      form2 = "%s"
    else
      form2 = "%s"
    end
    lineFormat = lineFormat:format(form1, form2)
    if vType == "table" then
      tinsert(lines, lineFormat:format(k, "{"))
      recurseStringify(v, level + 1, lines)
      tinsert(lines, strrep("  ", level) .. "},")
    else
      tinsert(lines, lineFormat:format(k, v) .. ",")
    end
  end
end

local function exportBigWigs(profile)
  local BigWigs = BigWigs
  local BigWigs3DB = BigWigsClassicDB or BigWigs3DB

  -- Check for BW
  if not BigWigs or not BigWigs.db or not BigWigs3DB then
    TXUI:LogInfo("BW not found or options wasn't opened at least once")
    return
  end

  -- BOOM
  BigWigs.db:RegisterDefaults(nil)

  -- BABY BOOM
  if BigWigs.db.children then
    for _, db in pairs(BigWigs.db.children) do
      db.RegisterDefaults(db, nil)
    end
  end

  -- Copy BigWigs table
  local pf = F.Table.Join({}, BigWigs3DB)

  -- Remove unused stuff
  pf.profileKeys = nil
  pf.profiles = nil
  pf.wipe80 = nil
  pf.discord = nil
  pf.namespaces["LibDualSpec-1.0"] = nil

  -- Cleanup export
  if pf.namespaces then
    -- Remove all existing boss modules from the export
    for k, _ in next, pf.namespaces do
      if k:find("BigWigs_Bosses_", nil, true) or k == "BigWigs_Plugins_Statistics" then pf.namespaces[k] = nil end
    end

    -- Remove other profiles
    for k, _ in next, pf.namespaces do
      if pf.namespaces[k] and pf.namespaces[k]["profiles"] then
        for pk, _ in next, pf.namespaces[k]["profiles"] do
          if pk ~= profile then pf.namespaces[k]["profiles"][pk] = nil end
        end
      end
    end

    -- Cleanup namespaces
    removeEmptySubTables(pf.namespaces)
  end

  -- Cleanup rest
  removeEmptySubTables(pf)

  -- Generate export
  local strTable = { "F.Table.Crush(pf, {" }
  recurseStringify(pf, 1, strTable)
  tinsert(strTable, "})")
  local profileExport = table.concat(strTable, "\n")

  -- Excape "-"" inside profile names
  local transformProfileName = gsub(profile, "%-", "%%-")

  -- Replace hardcoded profile with dynamic one
  profileExport = gsub(profileExport, "\"" .. transformProfileName .. "\"", "profileName")

  -- Set export to window
  createExportFrame(profileExport, true)
end

--@end-do-not-package@

function TXUI:ExportProfile(addon, profile)
  if addon == "names" then exportNames() end
  --@do-not-package@
  if addon == "bw" then
    exportBigWigs(profile)
  elseif addon == "import_names" then
    exportImportNames()
  end
  --@end-do-not-package@
end
