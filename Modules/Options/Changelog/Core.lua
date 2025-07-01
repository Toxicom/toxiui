local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local O = TXUI:GetModule("Options")
local CL = TXUI:GetModule("Changelog")

local ipairs = ipairs
local sub = string.sub
local type = type

function O:FormatChangelog(options, version, changelogIndex, changelog, returnText)
  -- Get the changes from the last changelog
  local changelogGeneralData = changelog.CHANGES

  if (changelog.HOTFIX == true) and not changelogGeneralData then changelogGeneralData = { "* General", I.Strings.ChangelogText[I.Enum.ChangelogType.HOTFIX] } end

  local function generateSectionLog(section, title)
    if (type(section) ~= "table") or (#section == 0) then return "" end
    local isUsingToxiUIFont = E.db.general.font == "- ToxiUI"

    local text = ""

    local specialCases = {
      ["* Breaking changes"] = { glyph = 59711, class = "DEATHKNIGHT" },
      ["* New features"] = { glyph = 59691, class = "MONK" },
      ["* Bug fixes"] = { glyph = 59715, class = "WARLOCK" },
      ["* Profile updates"] = { glyph = 59702, class = "ROGUE" },
      ["* Documentation"] = { glyph = 59708, class = "MAGE" },
      ["* Settings refactoring"] = { glyph = 59692, class = "DRUID" },
      ["* Development improvements"] = { glyph = 59689, class = "HUNTER" },
    }

    for _, line in ipairs(section) do
      local specialCase = specialCases[line]

      if specialCase then
        local formattedLine = F.String.ConvertGlyph(specialCase.glyph) .. " " .. line:sub(3)
        if not isUsingToxiUIFont then formattedLine = line:sub(3) end
        text = text .. "\n" .. F.String.Trim(F.String.GradientClass(formattedLine, specialCase.class)) .. "\n\n"
      elseif sub(line, 1, 2) == "* " then
        if title then
          text = text .. "• " .. F.String.Trim(line:sub(3)) .. "\n"
        else
          line = "• " .. line:sub(3)
          text = text .. "\n" .. F.String.Trim(F.String.ToxiUI(line)) .. "\n\n"
        end
      else
        text = text .. "- " .. F.String.Trim(line) .. "\n"
      end
    end

    return text .. "\n"
  end

  local generatedText = generateSectionLog(changelogGeneralData)

  if returnText then return generatedText end

  if changelog.DYNAMIC then
    local dynamicSection = changelog.DYNAMIC()
    if dynamicSection ~= nil and #dynamicSection > 0 then generatedText = generatedText .. generateSectionLog(dynamicSection, "Additional") end
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
