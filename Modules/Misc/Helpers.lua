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
  -- Unknown
  [0] = M:GetCoordinates(8, 8),

  [I.Specs.DeathKnight.Blood] = M:GetCoordinates(1, 1),
  [I.Specs.DeathKnight.Frost] = M:GetCoordinates(2, 1),
  [I.Specs.DeathKnight.Unholy] = M:GetCoordinates(3, 1),

  [I.Specs.DemonHunter.Havoc] = M:GetCoordinates(3, 5),
  [I.Specs.DemonHunter.Vengeance] = M:GetCoordinates(4, 5),
  [I.Specs.DemonHunter.Devourer] = M:GetCoordinates(8, 5),

  [I.Specs.Druid.Balance] = M:GetCoordinates(4, 1),
  [I.Specs.Druid.Feral] = M:GetCoordinates(5, 1),
  [I.Specs.Druid.Guardian] = M:GetCoordinates(6, 1),
  [I.Specs.Druid.Restoration] = M:GetCoordinates(7, 1),

  [I.Specs.Evoker.Devastation] = M:GetCoordinates(5, 5),
  [I.Specs.Evoker.Preservation] = M:GetCoordinates(6, 5),
  [I.Specs.Evoker.Augmentation] = M:GetCoordinates(7, 5),

  [I.Specs.Hunter.BeastMastery] = M:GetCoordinates(8, 1),
  [I.Specs.Hunter.Marksmanship] = M:GetCoordinates(1, 2),
  [I.Specs.Hunter.Survival] = M:GetCoordinates(2, 2),

  [I.Specs.Mage.Arcane] = M:GetCoordinates(3, 2),
  [I.Specs.Mage.Fire] = M:GetCoordinates(4, 2),
  [I.Specs.Mage.Frost] = M:GetCoordinates(5, 2),

  [I.Specs.Monk.Brewmaster] = M:GetCoordinates(6, 2),
  [I.Specs.Monk.Mistweaver] = M:GetCoordinates(7, 2),
  [I.Specs.Monk.Windwalker] = M:GetCoordinates(8, 2),

  [I.Specs.Paladin.Holy] = M:GetCoordinates(1, 3),
  [I.Specs.Paladin.Protection] = M:GetCoordinates(2, 3),
  [I.Specs.Paladin.Retribution] = M:GetCoordinates(3, 3),

  [I.Specs.Priest.Discipline] = M:GetCoordinates(4, 3),
  [I.Specs.Priest.Holy] = M:GetCoordinates(5, 3),
  [I.Specs.Priest.Shadow] = M:GetCoordinates(6, 3),

  [I.Specs.Rogue.Assassination] = M:GetCoordinates(7, 3),
  [I.Specs.Rogue.Outlaw] = M:GetCoordinates(8, 3),
  [I.Specs.Rogue.Subtlety] = M:GetCoordinates(1, 4),

  [I.Specs.Shaman.Elemental] = M:GetCoordinates(2, 4),
  [I.Specs.Shaman.Enhancement] = M:GetCoordinates(3, 4),
  [I.Specs.Shaman.Restoration] = M:GetCoordinates(4, 4),

  [I.Specs.Warlock.Affliction] = M:GetCoordinates(5, 4),
  [I.Specs.Warlock.Demonology] = M:GetCoordinates(6, 4),
  [I.Specs.Warlock.Destruction] = M:GetCoordinates(7, 4),

  [I.Specs.Warrior.Arms] = M:GetCoordinates(8, 4),
  [I.Specs.Warrior.Fury] = M:GetCoordinates(1, 5),
  [I.Specs.Warrior.Protection] = M:GetCoordinates(2, 5),
}

-- Blizzard specIconID (texture file ID) -> ToxiUI specID mapping
M.BlizzardToSpecID = {
  -- Death Knight
  [135770] = I.Specs.DeathKnight.Blood,
  [135773] = I.Specs.DeathKnight.Frost,
  [135775] = I.Specs.DeathKnight.Unholy,
  -- Demon Hunter
  [1247264] = I.Specs.DemonHunter.Havoc,
  [1247265] = I.Specs.DemonHunter.Vengeance,
  [7455385] = I.Specs.DemonHunter.Devourer,
  -- Druid
  [136096] = I.Specs.Druid.Balance,
  [132115] = I.Specs.Druid.Feral,
  [132276] = I.Specs.Druid.Guardian,
  [136041] = I.Specs.Druid.Restoration,
  -- Evoker
  [4511811] = I.Specs.Evoker.Devastation,
  [4511812] = I.Specs.Evoker.Preservation,
  [5198700] = I.Specs.Evoker.Augmentation,
  -- Hunter
  [461112] = I.Specs.Hunter.BeastMastery,
  [236179] = I.Specs.Hunter.Marksmanship,
  [461113] = I.Specs.Hunter.Survival,
  -- Mage
  [135932] = I.Specs.Mage.Arcane,
  [135810] = I.Specs.Mage.Fire,
  [135846] = I.Specs.Mage.Frost,
  -- Monk
  [608951] = I.Specs.Monk.Brewmaster,
  [608952] = I.Specs.Monk.Mistweaver,
  [608953] = I.Specs.Monk.Windwalker,
  -- Paladin
  [135920] = I.Specs.Paladin.Holy,
  [236264] = I.Specs.Paladin.Protection,
  [135873] = I.Specs.Paladin.Retribution,
  -- Priest
  [135940] = I.Specs.Priest.Discipline,
  [237542] = I.Specs.Priest.Holy,
  [136207] = I.Specs.Priest.Shadow,
  -- Rogue
  [236270] = I.Specs.Rogue.Assassination,
  [236286] = I.Specs.Rogue.Outlaw,
  [132320] = I.Specs.Rogue.Subtlety,
  -- Shaman
  [136048] = I.Specs.Shaman.Elemental,
  [237581] = I.Specs.Shaman.Enhancement,
  [136052] = I.Specs.Shaman.Restoration,
  -- Warlock
  [136145] = I.Specs.Warlock.Affliction,
  [136172] = I.Specs.Warlock.Demonology,
  [136186] = I.Specs.Warlock.Destruction,
  -- Warrior
  [132355] = I.Specs.Warrior.Arms,
  [132347] = I.Specs.Warrior.Fury,
  [132341] = I.Specs.Warrior.Protection,
}

function M:GetSpecIconStyleValues()
  return {
    ToxiSpecStylized = F.String.Class("Spec") .. " " .. F.String.ToxiUI("Stylized"),
    ToxiSpecWhite = F.String.Class("Spec") .. " " .. F.String.ToxiUI("White"),
    ToxiSpecWhiteStroke = F.String.Class("Spec") .. " " .. F.String.ToxiUI("White Stroke"),
    ToxiSpecColored = F.String.Class("Spec") .. " " .. F.String.ToxiUI("Colored"),
    ToxiSpecColoredStroke = F.String.Class("Spec") .. " " .. F.String.ToxiUI("Colored Stroke"),
  }
end

function M:GetClassIconPath(theme)
  if not theme or theme == "" then theme = "ToxiClasses" end

  return [[|TInterface\AddOns\ElvUI_ToxiUI\Media\Textures\Icons\]] .. theme .. [[:32:32:0:0:512:512:%s|t]]
end

function M:ReverseIconCoords(coords)
  local x1, x2, y1, y2 = strsplit(":", coords)
  return format("%s:%s:%s:%s", x2, x1, y1, y2)
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
  elseif TXUI.IsClassic then
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
