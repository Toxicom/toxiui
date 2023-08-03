local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local MC = TXUI:NewModule("MiniMapCoords", "AceHook-3.0")

-- Globals
local CreateFrame = CreateFrame
local format = string.format
local mapInfo = E.MapInfo
local miniMap = Minimap

function MC:ZoneUpdate()
  if mapInfo.x and mapInfo.y then
    self.restrictedArea = false
  else
    self.restrictedArea = true
    self.coordsHolder.playerCoords:SetText("N/A")
  end
end

function MC:UpdateCoords(_, elapsed)
  if self.restrictedArea or not mapInfo.coordsWatching then return end

  self.elapsed = (self.elapsed or 0) + elapsed
  if self.elapsed < 0.33 then return end

  if mapInfo.x and mapInfo.y then
    if not F.AlmostEqual(mapInfo.x, self.mapInfoX) and not F.AlmostEqual(mapInfo.y, self.mapInfoY) then
      self.mapInfoX = mapInfo.x
      self.mapInfoY = mapInfo.y

      self.coordsHolder.playerCoords:SetText(format(self.displayFormat, mapInfo.xText, mapInfo.yText))
    end
  else
    self.coordsHolder.playerCoords:SetText("N/A")
  end

  self.elapsed = 0
end

function MC:UpdateCoordinatesPosition()
  self.coordsHolder.playerCoords:ClearAllPoints()
  self.coordsHolder.playerCoords:SetPoint("CENTER", miniMap, "CENTER", F.Dpi(self.db.xOffset), F.Dpi(self.db.yOffset))
end

function MC:CreateCoordsFrame()
  self.coordsHolder = CreateFrame("Frame", "TXCoordsHolder", miniMap)
  self.coordsHolder:SetFrameLevel(miniMap:GetFrameLevel() + 10)
  self.coordsHolder:SetFrameStrata(miniMap:GetFrameStrata())
  self.coordsHolder:SetScript("OnUpdate", self.updateClosure)

  self.coordsHolder.playerCoords = self.coordsHolder:CreateFontString(nil, "OVERLAY")

  self:UpdateCoordinatesPosition()
end

function MC:SettingsUpdate()
  if not self.Initialized then return end
  if not self.coordsHolder then self:CreateCoordsFrame() end

  F.SetFontScaledFromDB(self.db, "coord", self.coordsHolder.playerCoords)

  self.displayFormat = format("%s, %s", self.db.format, self.db.format)
  self:UpdateCoordinatesPosition()
end

function MC:Disable()
  if not self.Initialized then return end

  self:UnhookAll()

  F.Event.UnregisterFrameEventAndCallback("LOADING_SCREEN_DISABLED", self)
  F.Event.UnregisterFrameEventAndCallback("ZONE_CHANGED_INDOORS", self)
  F.Event.UnregisterFrameEventAndCallback("ZONE_CHANGED_NEW_AREA", self)
  F.Event.UnregisterFrameEventAndCallback("ZONE_CHANGED", self)

  if self.coordsHolder then
    self.coordsHolder:Hide()
    self.coordsHolder:SetScript("OnUpdate", nil)
  end
end

function MC:Enable()
  if not self.Initialized then return end

  self:SettingsUpdate()

  if self.coordsHolder then
    self.coordsHolder:Show()
    self.coordsHolder:SetScript("OnUpdate", self.updateClosure)
  end

  F.Event.RegisterFrameEventAndCallback("LOADING_SCREEN_DISABLED", self.ZoneUpdate, self)
  F.Event.RegisterFrameEventAndCallback("ZONE_CHANGED_INDOORS", self.ZoneUpdate, self)
  F.Event.RegisterFrameEventAndCallback("ZONE_CHANGED_NEW_AREA", self.ZoneUpdate, self)
  F.Event.RegisterFrameEventAndCallback("ZONE_CHANGED", self.ZoneUpdate, self)

  self:SecureHook(E:GetModule("Minimap"), "UpdateSettings", F.Event.GenerateClosure(self.SettingsUpdate, self))
end

function MC:DatabaseUpdate()
  -- Disable
  self:Disable()

  -- Set db
  self.db = F.GetDBFromPath("TXUI.miniMapCoords")

  -- Enable only out of combat
  F.Event.ContinueOutOfCombat(function()
    if TXUI:HasRequirements(I.Requirements.MiniMapCoords) and (self.db and self.db.enabled) then self:Enable() end
  end)
end

function MC:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  self.mapInfoX = 0
  self.mapInfoY = 0
  self.updateClosure = F.Event.GenerateClosure(self.UpdateCoords, self)

  -- Register for updates
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("MiniMapCoords.DatabaseUpdate", self.DatabaseUpdate, self)
  F.Event.RegisterCallback("MiniMapCoords.SettingsUpdate", self.SettingsUpdate, self)

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(MC:GetName())
