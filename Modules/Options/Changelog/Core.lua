local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local O = TXUI:GetModule("Options")
local CL = TXUI:GetModule("Changelog")

local ipairs = ipairs
local sub = string.sub
local format = string.format
local type = type

function O:FormatChangelog(options, version, changelogIndex, changelog)
  -- Get the changes from the last changelog
  local changelogGeneralData = changelog.CHANGES
  local changelogRetailData = changelog.CHANGES_RETAIL
  local changelogWrathData = changelog.CHANGES_WRATH
  local changelogClassicData = changelog.CHANGES_CLASSIC

  if (changelog.HOTFIX == true) and not changelogGeneralData then changelogGeneralData = { "* General", I.Strings.ChangelogText[I.Enum.ChangelogType.HOTFIX] } end

  local function generateSectionLog(section, title)
    if (type(section) ~= "table") or (#section == 0) then return "" end

    local text = ""
    local index = 1

    if title then text = text .. F.String.ToxiUI("•" .. title) .. "\n\n" end

    for _, line in ipairs(section) do
      if sub(line, 1, 2) == "* " then
        if title then
          text = text .. format("%02d", index) .. ". " .. F.String.Trim(line:sub(3)) .. "\n"
          index = index + 1
        else
          line = "•" .. line:sub(3)
          index = 1
          text = text .. "\n" .. F.String.Trim(F.String.ToxiUI(line)) .. "\n\n"
        end
      else
        text = text .. format("%02d", index) .. ". " .. F.String.Trim(line) .. "\n"
        index = index + 1
      end
    end

    return text .. "\n"
  end

  local generatedText = generateSectionLog(changelogGeneralData)

  if changelog.DYNAMIC then
    local dynamicSection = changelog.DYNAMIC()
    if dynamicSection ~= nil and #dynamicSection > 0 then generatedText = generatedText .. generateSectionLog(dynamicSection, "Additional") end
  end

  if TXUI.IsRetail then
    generatedText = generatedText .. generateSectionLog(changelogRetailData, "Retail")
  elseif TXUI.IsWrath then
    generatedText = generatedText .. generateSectionLog(changelogWrathData, "Wrath")
  elseif TXUI.IsClassic then
    generatedText = generatedText .. generateSectionLog(changelogClassicData, "Vanilla Classic")
  end

  -- Get a pretty version number
  local versionString = CL:FormattedVersion(version)

  -- Version header
  local header = {
    order = self:GetOrder(),
    type = "header",
    name = F.String.ToxiUI(versionString),
  }

  -- Big header on first changelog
  if (changelogIndex == 0) or (changelogIndex == 9999) then
    header["type"] = "description"
    header["name"] = (changelogIndex == 0) and "Latest Version " .. header["name"] or header["name"]
    header["fontSize"] = "large"
  end

  -- Add header
  options["clHeader" .. changelogIndex] = header

  -- Generate the actual changes line per line
  options["clChanges" .. changelogIndex] = {
    order = self:GetOrder(),
    type = "description",
    name = generatedText,
    fontSize = "medium",
  }
end

function O:Changelog()
  local options = self.options.changelog.args

  -- Reset order for new page
  self:ResetOrder()

  options["_recent"] = {
    order = self:GetOrder(),
    name = "Latest Changes",
    type = "group",
    args = {},
  }

  -- Vars
  local recentChangelogs = {}
  local changelogIndex = 0
  local changelogCount = 0

  -- Recent Changelog Generation
  for version, changelog in CL:GetSorted() do
    -- Get pretty changelog
    self:FormatChangelog(options["_recent"]["args"], version, changelogIndex, changelog)

    -- Add as recent changelog
    recentChangelogs[version] = true

    -- Increase by 1, this is only for iteration
    changelogIndex = changelogIndex + 1

    -- Increase by 1 if its not a hotfix
    if changelog.HOTFIX ~= true then changelogCount = changelogCount + 1 end

    -- If we had 3 major changelogs, exit loop
    if changelogCount == 3 then break end
  end

  -- Other Changelog Generation
  for version, changelog in CL:GetSorted() do
    if (changelog.HOTFIX ~= true) and not recentChangelogs[version] then
      -- Create new group
      options[version] = {
        order = self:GetOrder(),
        name = version,
        type = "group",
        args = {},
      }

      -- Get pretty changelog
      self:FormatChangelog(options[version]["args"], version, 9999, changelog)
    end
  end
end

O:AddCallback("Changelog")
