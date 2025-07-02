local TXUI, F, E, I, V, L, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")
local SS = TXUI:GetModule("WunderBar"):GetModule("SpecSwitch")

local format = string.format
local C_SpecializationInfo = C_SpecializationInfo

function M:GetCoordinates(col, row)
  local width = 64
  local height = 64

  local x1 = (col - 1) * width
  local x2 = col * width
  local y1 = (row - 1) * height
  local y2 = row * height

  -- Return the formatted string
  return format("%d:%d:%d:%d", x1, x2, y1, y2)
end

M.ClassIcons = {
  WARRIOR = M:GetCoordinates(1, 1),
  MAGE = M:GetCoordinates(2, 1),
  ROGUE = M:GetCoordinates(3, 1),
  DRUID = M:GetCoordinates(4, 1),
  EVOKER = M:GetCoordinates(5, 1),
  HUNTER = M:GetCoordinates(1, 2),
  SHAMAN = M:GetCoordinates(2, 2),
  PRIEST = M:GetCoordinates(3, 2),
  WARLOCK = M:GetCoordinates(4, 2),
  PALADIN = M:GetCoordinates(1, 3),
  DEATHKNIGHT = M:GetCoordinates(2, 3),
  MONK = M:GetCoordinates(3, 3),
  DEMONHUNTER = M:GetCoordinates(4, 3),
}

M.SpecIcons = {
  -- Retail
  [0] = M:GetCoordinates(8, 8), -- Unknown
  [62] = M:GetCoordinates(3, 2), -- Mage Arcane
  [63] = M:GetCoordinates(4, 2), -- Mage Fire
  [64] = M:GetCoordinates(5, 2), -- Mage Frost
  [65] = M:GetCoordinates(1, 3), -- Paladin Holy
  [66] = M:GetCoordinates(2, 3), -- Paladin Protection
  [70] = M:GetCoordinates(3, 3), -- Paladin Retribution
  [71] = M:GetCoordinates(8, 4), -- Warrior Arms
  [72] = M:GetCoordinates(1, 5), -- Warrior Fury
  [73] = M:GetCoordinates(2, 5), -- Warrior Protection
  [102] = M:GetCoordinates(4, 1), -- Druid Balance
  [103] = M:GetCoordinates(5, 1), -- Druid Feral
  [104] = M:GetCoordinates(6, 1), -- Druid Guardian
  [105] = M:GetCoordinates(7, 1), -- Druid Restoration
  [250] = M:GetCoordinates(1, 1), -- Death Knight Blood
  [251] = M:GetCoordinates(2, 1), -- Death Knight Frost
  [252] = M:GetCoordinates(3, 1), -- Death Knight Unholy
  [253] = M:GetCoordinates(8, 1), -- Hunter Beast Master
  [254] = M:GetCoordinates(1, 2), -- Hunter Marksmanship
  [255] = M:GetCoordinates(2, 2), -- Hunter Survival
  [256] = M:GetCoordinates(4, 3), -- Priest Discipline
  [257] = M:GetCoordinates(5, 3), -- Priest Holy
  [258] = M:GetCoordinates(6, 3), -- Priest Shadow
  [259] = M:GetCoordinates(7, 3), -- Rogue Assassination
  [260] = M:GetCoordinates(8, 3), -- Rogue Outlaw
  [261] = M:GetCoordinates(1, 4), -- Rogue Subtlety
  [262] = M:GetCoordinates(2, 4), -- Shaman Elemental
  [263] = M:GetCoordinates(3, 4), -- Shaman Enhancement
  [264] = M:GetCoordinates(4, 4), -- Shaman Restoration
  [265] = M:GetCoordinates(5, 4), -- Warlock Affliction
  [266] = M:GetCoordinates(6, 4), -- Warlock Demonology
  [267] = M:GetCoordinates(7, 4), -- Warlock Destruction
  [268] = M:GetCoordinates(6, 2), -- Monk Brewmaster
  [269] = M:GetCoordinates(8, 2), -- Monk Windwalker
  [270] = M:GetCoordinates(7, 2), -- Monk Mistweaver
  [577] = M:GetCoordinates(3, 5), -- Demon Hunter Havoc
  [581] = M:GetCoordinates(4, 5), -- Demon Hunter Vengeance
  [1467] = M:GetCoordinates(5, 5), -- Evoker Devastation
  [1468] = M:GetCoordinates(6, 5), -- Evoker Preservation
  [1473] = M:GetCoordinates(7, 5), -- Evoker Augmentation
}

function M:GetClassIconPath(theme)
  if not theme or theme == "" then theme = "ToxiClasses" end

  return [[|TInterface\AddOns\ElvUI_ToxiUI\Media\Textures\Icons\]] .. theme .. [[:32:32:0:0:512:512:%s|t]]
end

function M:GenerateSpecIcon(dbPath)
  local specIcon
  local iconPath = self:GetClassIconPath(dbPath or "ToxiSpecStylized")
  local iconsFont = F.GetFontPath(I.Fonts.Icons)

  if TXUI.IsRetail then
    local _, classId = UnitClassBase("player")
    local specIndex = GetSpecialization()
    local id = GetSpecializationInfoForClassID(classId, specIndex)

    if id and id ~= 0 and M.SpecIcons[id] then
      specIcon = format(iconPath, M.SpecIcons[id])
    else
      specIcon = format(self:GetClassIconPath("ToxiClasses"), M.ClassIcons[E.myclass])
    end
  elseif TXUI.IsMists then
    local specIndex = C_SpecializationInfo.GetSpecialization()
    local specId = C_SpecializationInfo.GetSpecializationInfo(specIndex)

    if specId and M.SpecIcons[specId] then
      specIcon = format(iconPath, M.SpecIcons[specId])
    else
      specIcon = format(self:GetClassIconPath("ToxiClasses"), M.ClassIcons[E.myclass])
    end
  else
    local spec
    local talents = GetActiveTalentGroup()

    if talents then spec = SS:GetWrathCacheForSpec(talents) end

    if spec and spec.id and spec.id ~= 0 and M.SpecIcons[spec.id] then
      specIcon = format(iconPath, M.SpecIcons[spec.id])
    else
      specIcon = format(self:GetClassIconPath("ToxiClasses"), M.ClassIcons[E.myclass])
    end
  end

  return specIcon, iconsFont
end
