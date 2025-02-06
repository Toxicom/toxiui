local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local DC = TXUI:NewModule("Deconstruct", "AceHook-3.0")

-- Globals
local _G = _G
local C_Item_GetItemInventoryTypeByID = C_Item and C_Item.GetItemInventoryTypeByID
local CreateFrame = CreateFrame
local format = string.format
local GameTooltip = GameTooltip
local GameTooltip_Hide = GameTooltip_Hide
local GetContainerItemInfo = GetContainerItemInfo or (C_Container and C_Container.GetContainerItemInfo)
local GetContainerNumSlots = GetContainerNumSlots or (C_Container and C_Container.GetContainerNumSlots)
local GetCVarBool = GetCVarBool
local GetItemInfo = GetItemInfo
local GetProfessionInfo = GetProfessionInfo
local GetProfessions = GetProfessions
local InCombatLockdown = InCombatLockdown
local ipairs = ipairs
local IsEquippableItem = IsEquippableItem
local LE_ITEM_ARMOR_COSMETIC = LE_ITEM_ARMOR_COSMETIC
local LE_ITEM_CLASS_ARMOR = LE_ITEM_CLASS_ARMOR
local LE_ITEM_CLASS_GEM = LE_ITEM_CLASS_GEM
local LE_ITEM_CLASS_WEAPON = LE_ITEM_CLASS_WEAPON
local LE_ITEM_EQUIPLOC_SHIRT = _G.Enum.InventoryType and _G.Enum.InventoryType.IndexBodyType or 4
local LE_ITEM_QUALITY_EPIC = _G.Enum.ItemQuality.Epic
local LE_ITEM_QUALITY_UNCOMMON = _G.Enum.ItemQuality.Uncommon
local LE_ITEM_SUBCLASS_ARTIFACT = 11 -- TODO: Check for enum
local match = string.match
local pairs = pairs
local select = select
local SetItemButtonDesaturated = SetItemButtonDesaturated
local strsplit = strsplit
local tonumber = tonumber
local wipe = wipe
local TooltipDataProcessor_AddTooltipPostCall = TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall
local Enum_TooltipDataType = Enum.TooltipDataType

-- Vars
local B

DC.deconstructStateMap = {
  [333] = I.Enum.DeconstructState.DISENCHANT,
  [755] = I.Enum.DeconstructState.PROSPECT,
  [773] = I.Enum.DeconstructState.MILL,
}

DC.spellStateMap = {
  [I.Enum.DeconstructState.DISENCHANT] = 13262,
  [I.Enum.DeconstructState.PROSPECT] = 31252,
  [I.Enum.DeconstructState.MILL] = 51005,
}

DC.excludeList = {
  [I.Enum.DeconstructState.DISENCHANT] = {
    [51525] = true, -- Wrathful Gladiator's Chopper
    [116985] = true, -- Headdress of the First Shaman
    [44731] = true, -- Bouquet of Ebon Roses
    [136630] = true, -- "Twirling Bottom" Repeater
    [136629] = true, -- Felgibber Shotgun
    [11287] = true, -- Lesser Magic Wand
    [11288] = true, -- Greater Magic Wand
    [31404] = true, -- Green Trophy Tabard of the Illidari
  },
}

DC.allowList = {
  [I.Enum.DeconstructState.DISENCHANT] = {
    [137195] = true, -- Highmountain Armor
    [137221] = true, -- Enchanted Raven Sigil
    [137286] = true, -- Fel-Crusted Rune
    [182021] = true, -- Antique Kyrian Javelin
    [182043] = true, -- Antique Necromancer's Staff
    [182067] = true, -- Antique Duelist's Rapier
    [181991] = true, -- Antique Stalker's Bow
  },

  [I.Enum.DeconstructState.PROSPECT] = {
    [2770] = true, -- Copper Ore
    [2771] = true, -- Tin Ore
    [2772] = true, -- Iron Ore
    [3858] = true, -- Mithril Ore
    [10620] = true, -- Thorium Ore
    [23424] = true, -- Fel Iron Ore
    [23425] = true, -- Adamantite Ore
    [36909] = true, -- Cobalt Ore
    [36910] = true, -- Titanium Ore
    [36912] = true, -- Saronite Ore
    [52183] = true, -- Pyrite Ore
    [52185] = true, -- Elementium Ore
    [53038] = true, -- Obsidium Ore
    [72092] = true, -- Ghost Iron Ore
    [72093] = true, -- Kyparite
    [72094] = true, -- Black Trillium Ore
    [72103] = true, -- White Trillium Ore
    [123918] = true, -- Leystone Ore
    [123919] = true, -- Felslate
    [151564] = true, -- Empyrium
    [152512] = true, -- Monelite Ore
    [152513] = true, -- Platinum Ore
    [152579] = true, -- Storm Silver Ore
    [155830] = true, -- Runic Core
    [168185] = true, -- Osmenite Ore
    [171828] = true, -- Laestrite Ore
    [171829] = true, -- Solenium Ore
    [171830] = true, -- Oxxein Ore
    [171831] = true, -- Phaedrum Ore
    [171832] = true, -- Sinvyr Ore
    [171833] = true, -- Elethium Ore
    [187700] = true, -- Progenium Ore

    -- Dragonflight
    [188658] = true, -- Draconium Ore
    [194545] = true, -- Prismatic Ore
    [190313] = true, -- Titaniclum Ore
    [190394] = true, -- Tyrivite Ore
  },

  [I.Enum.DeconstructState.MILL] = {
    [765] = true, -- Silverleaf
    [785] = true, -- Mageroyal
    [2447] = true, -- Peacebloom
    [2449] = true, -- Earthroot
    [2450] = true, -- Briarthorn
    [2452] = true, -- Swiftthistle
    [2453] = true, -- Bruiseweed
    [3355] = true, -- Wild Steelbloom
    [3356] = true, -- Kingsblood
    [3357] = true, -- Liferoot
    [3358] = true, -- Khadgar's Whisker
    [3369] = true, -- Grave Moss
    [3818] = true, -- Fadeleaf
    [3819] = true, -- Dragon's Teeth
    [3820] = true, -- Stranglekelp
    [3821] = true, -- Goldthorn
    [4625] = true, -- Firebloom
    [8831] = true, -- Purple Lotus
    [8836] = true, -- Arthas' Tears
    [8838] = true, -- Sungrass
    [8839] = true, -- Blindweed
    [8845] = true, -- Ghost Mushroom
    [8846] = true, -- Gromsblood
    [13463] = true, -- Dreamfoil
    [13464] = true, -- Golden Sansam
    [13465] = true, -- Mountain Silversage
    [13466] = true, -- Sorrowmoss
    [13467] = true, -- Icecap
    [22785] = true, -- Felweed
    [22786] = true, -- Dreaming Glory
    [22787] = true, -- Ragveil
    [22789] = true, -- Terocone
    [22790] = true, -- Ancient Lichen
    [22791] = true, -- Netherbloom
    [22792] = true, -- Nightmare Vine
    [22793] = true, -- Mana Thistle
    [36901] = true, -- Goldclover
    [36903] = true, -- Adder's Tongue
    [36904] = true, -- Tiger Lily
    [36905] = true, -- Lichbloom
    [36906] = true, -- Icethorn
    [36907] = true, -- Talandra's Rose
    [37921] = true, -- Deadnettle
    [39969] = true, -- Fire Seed
    [39970] = true, -- Fire Leaf
    [52983] = true, -- Cinderbloom
    [52984] = true, -- Stormvine
    [52985] = true, -- Azshara's Veil
    [52986] = true, -- Heartblossom
    [52987] = true, -- Twilight Jasmine
    [52988] = true, -- Whiptail
    [72234] = true, -- Green Tea Leaf
    [72235] = true, -- Silkweed
    [72237] = true, -- Rain Poppy
    [79010] = true, -- Snow Lily
    [79011] = true, -- Fool's Cap
    [89639] = true, -- Desecrated Herb
    [109124] = true, -- Frostweed
    [109125] = true, -- Fireweed
    [109126] = true, -- Gorgrond Flytrap
    [109127] = true, -- Starflower
    [109128] = true, -- Nagrand Arrowbloom
    [109129] = true, -- Talador Orchid
    [124101] = true, -- Aethril
    [124102] = true, -- Dreamleaf
    [124103] = true, -- Foxflower
    [124104] = true, -- Fjarnskaggl
    [124105] = true, -- Starlight Rose
    [124106] = true, -- Felwort
    [128304] = true, -- Yseralline Seed
    [151565] = true, -- Astral Glory
    [152505] = true, -- Riverbud
    [152506] = true, -- Star Moss
    [152507] = true, -- Akunda's Bite
    [152508] = true, -- Winter's Kiss
    [152509] = true, -- Siren's Pollen
    [152510] = true, -- Anchor Weed
    [152511] = true, -- Sea Stalk
    [168487] = true, -- Zin'anthid
    [168583] = true, -- Widowbloom
    [168586] = true, -- Rising Glory
    [168589] = true, -- Marrowroot
    [169701] = true, -- Death Blossom
    [170554] = true, -- Vigil's Torch
    [171315] = true, -- Nightshade
    [187699] = true, -- First Flower

    -- Dragonflight
    [191460] = true, -- Hochenblume
    [191461] = true, -- Hochenblume
    [191462] = true, -- Hochenblume
    [191464] = true, -- Saxifrage
    [191465] = true, -- Saxifrage
    [191466] = true, -- Saxifrage
    [191467] = true, -- Bubble Poppy
    [191468] = true, -- Bubble Poppy
    [191469] = true, -- Bubble Poppy
    [191470] = true, -- Writhebark
    [191471] = true, -- Writhebark
    [191472] = true, -- Writhebark
    [198412] = true, -- Serene Pigment
    [198413] = true, -- Serene Pigment
    [198414] = true, -- Serene Pigment
    [198415] = true, -- Flourishing Pigment
    [198416] = true, -- Flourishing Pigment
    [198417] = true, -- Flourishing Pigment
    [198418] = true, -- Blazing Pigment
    [198419] = true, -- Blazing Pigment
    [198420] = true, -- Blazing Pigment
    [198421] = true, -- Shimmering Pigment
    [198422] = true, -- Shimmering Pigment
    [198423] = true, -- Shimmering Pigment
  },
}

function DC:IsItemFrame(frame)
  for _, bagID in ipairs(B.BagFrame.BagIDs) do
    for slotID = 1, GetContainerNumSlots(bagID) do
      if B.BagFrame.Bags[bagID][slotID] == frame then return true end
    end
  end

  return false
end

function DC:GetItemIdFromLink(txt)
  local isItemString = match(txt, "item[%-?%d:]+")
  if not isItemString then return false end

  local _, itemID = strsplit(":", isItemString)
  if not itemID or (itemID == "") then return false end

  itemID = tonumber(itemID)
  if not itemID then return false end

  return itemID
end

function DC:ToggleHoverAnimations(play)
  if self.hoverButton.FadeIn then
    if self.hoverButton.FadeIn:IsPlaying() then self.hoverButton.FadeIn:Stop() end
  end

  if self.hoverButton.Pulse then
    if self.hoverButton.Pulse:IsPlaying() then self.hoverButton.Pulse:Stop() end
  end

  if not play or not self.db.animations then return end

  if self.hoverButton.FadeIn then self.hoverButton.FadeIn:Play() end
end

function DC:ToggleBagAnimations(play)
  if self.bagButton.Texture.FadeIn then
    if self.bagButton.Texture.FadeIn:IsPlaying() then self.bagButton.Texture.FadeIn:Stop() end
  end

  if self.bagButton.txSoftShadow.FadeIn then
    if self.bagButton.txSoftShadow.FadeIn:IsPlaying() then self.bagButton.txSoftShadow.FadeIn:Stop() end
  end

  if self.bagButton.Texture.Pulse then
    if self.bagButton.Texture.Pulse:IsPlaying() then self.bagButton.Texture.Pulse:Stop() end
  end

  if self.bagButton.txSoftShadow.Pulse then
    if self.bagButton.txSoftShadow.Pulse:IsPlaying() then self.bagButton.txSoftShadow.Pulse:Stop() end
  end

  if not play or not self.db.animations then return end

  if self.bagButton.Texture.FadeIn then self.bagButton.Texture.FadeIn:Play() end
  if self.bagButton.txSoftShadow.FadeIn then self.bagButton.txSoftShadow.FadeIn:Play() end
end

function DC:SetupAnimationGroups(obj)
  obj.FadeIn = obj.FadeIn or TXUI:CreateAnimationGroup(obj)

  obj.FadeIn.ResetFade = obj.FadeIn.ResetFade or obj.FadeIn:CreateAnimation("Fade")
  obj.FadeIn.ResetFade:SetDuration(0)
  obj.FadeIn.ResetFade:SetChange(0)
  obj.FadeIn.ResetFade:SetOrder(1)

  obj.FadeIn.Fade = obj.FadeIn.Fade or obj.FadeIn:CreateAnimation("Fade")
  obj.FadeIn.Fade:SetDuration(0.2 * self.db.animationsMult)
  obj.FadeIn.Fade:SetEasing("out-quadratic")
  obj.FadeIn.Fade:SetChange(1)
  obj.FadeIn.Fade:SetOrder(2)
  obj.FadeIn.Fade:SetScript("OnFinished", function(anim)
    if anim and (anim:GetParent()) and anim:GetParent().Pulse then anim:GetParent().Pulse:Play() end
  end)

  obj.Pulse = obj.Pulse or TXUI:CreateAnimationGroup(obj)
  obj.Pulse:SetLooping(true)

  obj.Pulse.PulseOut = obj.Pulse.PulseOut or obj.Pulse:CreateAnimation("Fade")
  obj.Pulse.PulseOut:SetDuration(0.5 * self.db.animationsMult)
  obj.Pulse.PulseOut:SetEasing("inout-quadratic")
  obj.Pulse.PulseOut:SetChange(1)
  obj.Pulse.PulseOut:SetOrder(1)

  obj.Pulse.PulseIn = obj.Pulse.PulseIn or obj.Pulse:CreateAnimation("Fade")
  obj.Pulse.PulseIn:SetDuration(0.5 * self.db.animationsMult)
  obj.Pulse.PulseIn:SetEasing("inout-quadratic")
  obj.Pulse.PulseIn:SetChange(0.85)
  obj.Pulse.PulseIn:SetOrder(2)
end

function DC:TooltipHandler(frame)
  GameTooltip:SetOwner(frame)
  GameTooltip:ClearLines()

  if (self.bagID ~= nil) and (self.slotID ~= nil) then GameTooltip:SetBagItem(self.bagID, self.slotID) end

  GameTooltip:Show()
end

function DC:OnRefreshHandler()
  if self.active then
    self:SetState(self.active)

    if (self.bagID ~= nil) and (self.slotID ~= nil) then
      if self:CalculateHoverButtonState(B.BagFrame.Bags[self.bagID][self.slotID]) then return end
      self:OnLeaveHandler()
    end
  end
end

function DC:OnClickHandler()
  local active = self.active

  if active == nil then
    active = true
  elseif active == false then
    active = true
  else
    active = false
  end

  self:SetState(active)

  if GameTooltip and GameTooltip:IsShown() then B.Tooltip_Show(self.bagButton) end
end

function DC:OnHideHandler()
  self:SetState(false)
end

function DC:SetState(active)
  if active == true then
    self:ShowEligableOverlay(true)

    local color = I.Strings.Branding.ColorRGBA

    if self.db.glowEnabled then
      self.bagButton.txSoftShadow:SetBackdropBorderColor(color.r, color.g, color.b, self.db.glowAlpha)
    else
      self.bagButton.txSoftShadow:SetBackdropBorderColor(0, 0, 0, 0)
    end

    self.bagButton.txSoftShadow:Show()

    F.Color.SetGradientRGB(self.bagButton.Texture, "VERTICAL", color.r, color.g, color.b, 0, color.r, color.g, color.b, 0.8)
    self.bagButton.Texture:Show()

    if self.active ~= active then self:ToggleBagAnimations(true) end
  else
    self:ShowEligableOverlay(false)
    self:ToggleBagAnimations(false)
    self.bagButton.txSoftShadow:Hide()
    self.bagButton.Texture:Hide()
    self:OnLeaveHandler()
  end

  self.active = (active == true)

  self.bagButton.ttText2 = format(I.Strings.Deconstruct.Status.Text, self.active and I.Strings.Deconstruct.Status.Active or I.Strings.Deconstruct.Status.Inactive)
end

function DC:IsAllowedState(professionState)
  return self.allowedStates[professionState]
end

function DC:UpdateStateForProfession(prof)
  if not prof then return end
  local professionID = select(7, GetProfessionInfo(prof))
  local professionState = self.deconstructStateMap[professionID]
  if professionState then self.allowedStates[professionState] = true end
end

function DC:UpdateAllowedStates()
  self.allowedStates = self.allowedStates or {}
  wipe(self.allowedStates)

  local prof1, prof2 = GetProfessions()

  self:UpdateStateForProfession(prof1)
  self:UpdateStateForProfession(prof2)
end

function DC:IsUsable(itemID, professionState)
  -- Disenchanting
  if professionState == I.Enum.DeconstructState.DISENCHANT then
    if self:IsAllowedState(professionState) then
      -- Always true if in allowList
      if DC.allowList[professionState] and DC.allowList[professionState][itemID] then return true end

      -- Always false if in excludeList
      if DC.excludeList[professionState] and DC.excludeList[professionState][itemID] then return false end

      -- Get Item Info
      local itemName, _, itemQuality, _, _, _, _, _, itemEquipLoc, _, _, classID, subclassID = GetItemInfo(itemID)

      -- Don't allow if we couldn't get item info
      if not itemName then return false end

      -- Needs to be Green or higher or Purple or lower
      if not (itemQuality >= LE_ITEM_QUALITY_UNCOMMON and itemQuality <= LE_ITEM_QUALITY_EPIC) then return false end

      -- Needs to categoriesd as equipment (check comes from blizzard)
      if TXUI.IsRetail then
        if not (classID == 2 or (classID == 4 and subclassID ~= 5) or (classID == 3 and subclassID == 11)) then return false end
      else
        if
          not (
            classID == LE_ITEM_CLASS_WEAPON
            or (classID == LE_ITEM_CLASS_ARMOR and subclassID ~= LE_ITEM_ARMOR_COSMETIC)
            or (classID == LE_ITEM_CLASS_GEM and subclassID == LE_ITEM_SUBCLASS_ARTIFACT)
          )
        then
          return false
        end
      end

      -- Don't allow shirts to be dischanted
      if C_Item_GetItemInventoryTypeByID(itemID) == LE_ITEM_EQUIPLOC_SHIRT then return false end

      -- Don't allow if not equippable or an bag
      if (not IsEquippableItem(itemID)) or (itemEquipLoc == "INVTYPE_BAG") then return false end

      -- Return
      return true
    end

    -- Return
    return false
  end

  -- Mill & Prospect
  if (professionState == I.Enum.DeconstructState.MILL) or (professionState == I.Enum.DeconstructState.PROSPECT) then
    if self:IsAllowedState(professionState) then
      -- Always true if in allowList
      if DC.allowList[professionState] and DC.allowList[professionState][itemID] then return true end

      -- Always false if in excludeList
      if DC.excludeList[professionState] and DC.excludeList[professionState][itemID] then return false end
    end

    -- Return
    return false
  end
end

function DC:IsEligibleItemFrame(itemFrame)
  local itemInfo, itemLink, itemId
  local professionState = I.Enum.DeconstructState.NONE

  local bagID = itemFrame:GetParent():GetID()
  if not bagID then return professionState end

  local slotID = itemFrame:GetID()
  if slotID == nil then return professionState end

  if TXUI.IsRetail then
    itemInfo = GetContainerItemInfo(bagID, slotID)
    if not itemInfo then return professionState end

    itemLink = itemInfo.hyperlink
    if not itemLink then return professionState end

    itemId = itemInfo.itemID
  else
    itemLink = select(7, GetContainerItemInfo(bagID, slotID))
    if not itemLink then return professionState end

    itemId = self:GetItemIdFromLink(itemLink)
  end

  if not itemId then return professionState end

  if (professionState == I.Enum.DeconstructState.NONE) and (self:IsUsable(itemId, I.Enum.DeconstructState.DISENCHANT)) then professionState = I.Enum.DeconstructState.DISENCHANT end
  if (professionState == I.Enum.DeconstructState.NONE) and (self:IsUsable(itemId, I.Enum.DeconstructState.PROSPECT)) then professionState = I.Enum.DeconstructState.PROSPECT end
  if (professionState == I.Enum.DeconstructState.NONE) and (self:IsUsable(itemId, I.Enum.DeconstructState.MILL)) then professionState = I.Enum.DeconstructState.MILL end

  return professionState, itemId, bagID, slotID
end

function DC:ShowEligableOverlay(enabled)
  for _, bagFrame in pairs(B.BagFrames) do
    for _, bagID in ipairs(bagFrame.BagIDs) do
      for slotID = 1, GetContainerNumSlots(bagID) do
        local itemFrame = bagFrame.Bags[bagID][slotID]
        if not enabled or (self.db.highlightMode == "NONE") or (self:IsEligibleItemFrame(itemFrame) ~= I.Enum.DeconstructState.NONE) then
          SetItemButtonDesaturated(itemFrame, itemFrame.locked or itemFrame.junkDesaturate)
          local r, g, b = itemFrame:GetBackdropBorderColor()
          itemFrame:SetBackdropBorderColor(r, g, b, 1)
          itemFrame.searchOverlay:SetAlpha(1)
          itemFrame.searchOverlay:Hide()
        else
          if self.db.highlightMode == "ALPHA" then
            SetItemButtonDesaturated(itemFrame, nil)
            local r, g, b = itemFrame:GetBackdropBorderColor()
            if GetContainerItemInfo(bagID, slotID) then
              itemFrame:SetBackdropBorderColor(r, g, b, 0.5)
              itemFrame.searchOverlay:SetAlpha(0.5)
              itemFrame.searchOverlay:Show()
            else
              itemFrame:SetBackdropBorderColor(r, g, b, 1)
              itemFrame.searchOverlay:SetAlpha(1)
              itemFrame.searchOverlay:SetAlpha(1)
              itemFrame.searchOverlay:Hide()
            end
          elseif self.db.highlightMode == "DARK" then
            SetItemButtonDesaturated(itemFrame, 1)
            itemFrame.searchOverlay:SetAlpha(1)
            itemFrame.searchOverlay:Show()
          end
        end
      end
    end
  end
end

function DC:CalculateHoverButtonState(itemFrame)
  local profesionMode, itemId, bagID, slotID = self:IsEligibleItemFrame(itemFrame)
  if profesionMode ~= I.Enum.DeconstructState.NONE then
    local sameSlot = (self.bagID == bagID) and (self.slotID == slotID)
    if not sameSlot then self:OnLeaveHandler() end

    local spellProffession = self.spellStateMap[profesionMode]
    if spellProffession then
      -- Get Color for Task/State
      local color = I.Strings.Deconstruct.Color[profesionMode]
      if not color then return self:LogDebug("Could not find colorMap entry", profesionMode) end

      -- Set Label if enabled
      if self.db.labelEnabled then
        local label = I.Strings.Deconstruct.Label[profesionMode]
        if not label then return self:LogDebug("Could not find labelMap entry", profesionMode) end

        self.hoverButton.Text:SetText(label)
      else
        self.hoverButton.Text:SetText("")
      end

      -- Set vars
      self.bagID = bagID
      self.slotID = slotID

      -- Show glow if enabled
      if self.db.glowEnabled then
        self.hoverButton.txSoftShadow:SetBackdropBorderColor(color.r, color.g, color.b, self.db.glowAlpha)
      else
        self.hoverButton.txSoftShadow:SetBackdropBorderColor(0, 0, 0, 0)
      end

      -- Color Label and Inner Glow
      self.hoverButton.Text:SetTextColor(color.r, color.g, color.b, 1)
      F.Color.SetGradientRGB(self.hoverButton.Texture, "VERTICAL", color.r, color.g, color.b, 0, color.r, color.g, color.b, 0.8)

      -- Color ItemFrame Border
      itemFrame:SetBackdropBorderColor(color.r, color.g, color.b, 1)

      -- Anchor hover button
      self.hoverButton:ClearAllPoints()
      self.hoverButton:SetAllPoints(itemFrame)
      self.hoverButton:SetAlpha(1)
      self.hoverButton:Show()

      -- Set action for left click
      self.hoverButton.ID = itemId
      self.hoverButton:SetAttribute("type1", "spell")
      self.hoverButton:SetAttribute("spell", spellProffession)
      self.hoverButton:SetAttribute("target-bag", bagID)
      self.hoverButton:SetAttribute("target-slot", slotID)

      -- Play animation if its not the same slot
      if not sameSlot then self:ToggleHoverAnimations(true) end

      return true
    end
  end

  return false
end

function DC:OnHoverHandler(tooltip)
  if not tooltip then return end
  if not self.db or not self.db.enabled then return end
  if not self.active or InCombatLockdown() then return end
  if self.hoverButton == tooltip then return end

  local itemFrame = tooltip.GetOwner and tooltip:GetOwner()
  if not itemFrame then return end
  if not self:IsItemFrame(itemFrame) then return end

  self:CalculateHoverButtonState(itemFrame)
end

function DC:OnClassicHoverHandler(frame)
  if not frame then return end
  if not self.db or not self.db.enabled then return end
  if not self.active or InCombatLockdown() then return end
  if self.hoverButton == frame then return end

  local itemFrame = frame.GetOwner and frame:GetOwner()
  if not itemFrame then return end
  if not self:IsItemFrame(itemFrame) then return end

  self:CalculateHoverButtonState(itemFrame)
end

function DC:OnLeaveHandler()
  if (self.bagID ~= nil) and (self.slotID ~= nil) then
    self.hoverButton:SetAlpha(0)

    if InCombatLockdown() then
      F.Event.RegisterOnceFrameEventAndCallback("PLAYER_REGEN_ENABLED", F.Event.GenerateClosure(self.OnCombatEndHandler, self))
      return
    end

    self:ToggleHoverAnimations(false)
    B:UpdateSlot(B.BagFrame, self.bagID, self.slotID)

    self.slotID = nil
    self.bagID = nil

    self.hoverButton:ClearAllPoints()
    self.hoverButton:Hide()

    if GameTooltip and GameTooltip:IsShown() then GameTooltip:Hide() end
  end
end

function DC:OnCombatEndHandler()
  self.hoverButton:OnLeave()
end

function DC:CreateElements()
  local hoverButton = self.hoverButton or CreateFrame("Button", "TXDeconstructHoverButton", E.UIParent, "SecureActionButtonTemplate")
  hoverButton:RegisterForClicks(GetCVarBool("ActionButtonUseKeyDown") and "AnyDown" or "AnyUp")
  hoverButton:SetFrameStrata("TOOLTIP")

  hoverButton.TipLines = {}

  hoverButton:SetScript("OnEnter", E.noop)
  hoverButton:SetScript("OnLeave", E.noop)
  hoverButton:Hide()

  hoverButton.Text = hoverButton.Text or hoverButton:CreateFontString(nil, "OVERLAY")
  hoverButton.Text:SetInside(hoverButton, 0, -(E.Border * 4))
  F.SetFontFromDB(self.db, "label", hoverButton.Text, false)
  hoverButton.Text:SetText("")
  hoverButton.Text:SetJustifyH("CENTER")
  hoverButton.Text:SetJustifyV("TOP")

  hoverButton.Texture = hoverButton.Texture or hoverButton:CreateTexture(nil, "OVERLAY")
  hoverButton.Texture:SetInside()
  hoverButton.Texture:SetTexture(E.media.blankTex)
  hoverButton.Texture:SetVertexColor(1, 1, 1, 1)
  F.Color.SetGradientRGB(hoverButton.Texture, "VERTICAL", 0, 0, 0, 0, 0, 0, 0, 0)

  -- Sush
  F.CreateSoftShadow(hoverButton, 32)

  -- Setup animations
  self:SetupAnimationGroups(hoverButton)

  -- Hook for Handlers
  self:SecureHookScript(hoverButton, "OnEnter", "TooltipHandler")
  self:SecureHookScript(hoverButton, "OnLeave", "OnLeaveHandler")

  local bagButton = self.bagButton or CreateFrame("Button", nil, B.BagFrame, "BackdropTemplate")
  bagButton:SetSize(16 + E.Border, 16 + E.Border)
  bagButton:SetTemplate()
  bagButton:SetPoint("RIGHT", B.BagFrame.bagsButton, "LEFT", -5, 0)
  B:SetButtonTexture(bagButton, "Interface/ICONS/INV_Inscription_TarotChaos")
  bagButton:StyleButton(nil, true)

  bagButton.Texture = bagButton.Texture or bagButton:CreateTexture(nil, "OVERLAY")
  bagButton.Texture:SetInside()
  bagButton.Texture:SetTexture(E.media.blankTex)
  bagButton.Texture:SetVertexColor(1, 1, 1, 1)
  F.Color.SetGradientRGB(bagButton.Texture, "VERTICAL", 0, 0, 0, 0, 0, 0, 0, 0)

  -- Setup animations
  self:SetupAnimationGroups(bagButton.Texture)

  -- Sush
  F.CreateSoftShadow(bagButton, bagButton:GetHeight() / 2)

  -- Setup animations
  self:SetupAnimationGroups(bagButton.txSoftShadow)

  bagButton.ttText = I.Strings.Deconstruct.Status.Title
  bagButton.ttText2 = format(I.Strings.Deconstruct.Status.Text, I.Strings.Deconstruct.Status.Inactive)

  bagButton:SetScript("OnEnter", B.Tooltip_Show)
  bagButton:SetScript("OnLeave", GameTooltip_Hide)
  bagButton:SetScript("OnClick", E.noop)

  -- Hook for Handler
  self:SecureHookScript(bagButton, "OnClick", "OnClickHandler")

  self.hoverButton = hoverButton
  self.bagButton = bagButton
end

function DC:Disable()
  if not self.Initialized then return end
  if not self:IsHooked(B, "UpdateBagSlots") then return end

  self:UnhookAll()
  F.Event.UnregisterFrameEventAndCallback("SKILL_LINES_CHANGED", self)

  if not self.bagButton then return end

  self:SetState(false)

  B.BagFrame.vendorGraysButton:ClearAllPoints()
  B.BagFrame.vendorGraysButton:SetPoint("RIGHT", B.BagFrame.bagsButton, "LEFT", -5, 0)

  self.bagButton:Hide()
end

function DC:Enable()
  if not self.Initialized then return end
  if not (self.db and self.db.enabled) then return end
  if self:IsHooked(B, "UpdateBagSlots") then return end

  self:CreateElements()

  self:SecureHookScript(B.BagFrame, "OnHide", "OnHideHandler")
  if TXUI.IsRetail then
    TooltipDataProcessor_AddTooltipPostCall(Enum_TooltipDataType.Item, function(tooltip)
      DC:OnHoverHandler(tooltip)
    end)
  else
    self:SecureHookScript(GameTooltip, "OnTooltipSetItem", "OnClassicHoverHandler")
  end
  self:SecureHook(B, "UpdateBagSlots", "OnRefreshHandler")
  self:SecureHook(B, "SearchUpdate", "OnRefreshHandler")

  F.Event.RegisterFrameEventAndCallback("SKILL_LINES_CHANGED", self.UpdateAllowedStates, self)

  self.bagButton:Show()
  B.BagFrame.vendorGraysButton:ClearAllPoints()
  B.BagFrame.vendorGraysButton:SetPoint("RIGHT", self.bagButton, "LEFT", -5, 0)

  self:UpdateAllowedStates()
end

function DC:SettingsUpdate()
  if not self.Initialized then return end
  if not (self.db and self.db.enabled) then return end

  self:CreateElements()
end

function DC:DatabaseUpdate()
  -- Set db
  self.db = F.GetDBFromPath("TXUI.addons.deconstruct")

  F.Event.ContinueOutOfCombat(function()
    -- Disable only out of combat
    self:Disable()

    -- Enable only out of combat
    if TXUI:HasRequirements(I.Requirements.Deconstruct) and (self.db and self.db.enabled) then self:Enable() end
  end)
end

function DC:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("Deconstruct.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("Deconstruct.SettingsUpdate", self.SettingsUpdate, self)

  -- Get Frameworks
  B = E:GetModule("Bags")

  -- We are done, hooray!
  self.Initialized = true
end

if TXUI.IsRetail then TXUI:RegisterModule(DC:GetName()) end
