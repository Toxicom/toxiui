local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local GM = TXUI:GetModule("GameMenu")
local Misc = TXUI:GetModule("Misc")

local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local m = GM.Spacing

function GM:CreatePlayed()
  local parent = self.backgroundFade

  local played = parent:CreateFontString(nil, "OVERLAY")
  if self.mythic then
    played:Point("TOPLEFT", self.mythic["history10"], "BOTTOMLEFT", 0, m(-12))
  elseif self.collections and self.collections.achievs then
    played:Point("TOPLEFT", self.collections.achievs, "BOTTOMLEFT", 0, m(-12))
  else
    played:Point("TOPLEFT", self.outerSpacing, -self.outerSpacing)
  end
  played:SetFont(self.titleFont, F.FontSizeScaled(24), "OUTLINE")
  played:SetTextColor(1, 1, 1, 1)
  played:SetText(F.String.GradientClass("Played"))

  played.session = parent:CreateFontString(nil, "OVERLAY")
  played.session:SetPoint("TOPLEFT", played, "BOTTOMLEFT", 0, m(-4))
  played.session:SetFont(self.primaryFont, F.FontSizeScaled(16), "OUTLINE")
  played.session:SetTextColor(1, 1, 1, 1)
  played.session:SetText("Session: " .. F.String.ToxiUI("Loading…"))

  played.total = parent:CreateFontString(nil, "OVERLAY")
  played.total:SetPoint("TOPLEFT", played.session, "BOTTOMLEFT", 0, m(-1))
  played.total:SetFont(self.primaryFont, F.FontSizeScaled(16), "OUTLINE")
  played.total:SetTextColor(1, 1, 1, 1)
  played.total:SetText("Total: " .. F.String.ToxiUI("Loading…"))

  self.played = played
end

function GM:UpdatePlayed()
  if not self.played then return end

  local sumAll = GM.GetTotalPlayedAll()
  local text = (sumAll and sumAll > 0) and GM.FormatPlayed(sumAll) or F.String.ToxiUI("Loading…")
  self.played.total:SetText("Total: " .. text)

  -- Session based on elapsed since login
  local sessionSec = (self.sessionStartEpoch and (time() - self.sessionStartEpoch)) or 0
  if self.played.session then
    local sessionText = (sessionSec > 0) and GM.FormatPlayed(sessionSec, true) or F.String.ToxiUI("N/A")
    self.played.session:SetText("Session: " .. sessionText)
  end

  self:BuildPlayedGraph()
end

function GM:BuildPlayedGraph()
  if not self.played or not self.backgroundFade then return end

  -- Create container once
  if not self.played.graph then
    local graph = CreateFrame("Frame", nil, self.backgroundFade)
    graph:SetPoint("TOPLEFT", (self.played.session or self.played.total), "BOTTOMLEFT", 0, m(-10))
    graph:SetSize(700, 1)
    self.played.graph = graph
    self.played.graph.bars = {}
  end

  local graph = self.played.graph

  -- Clear previous bars
  for _, bar in ipairs(graph.bars) do
    bar:Hide()
  end
  wipe(graph.bars)

  local aggregated = GM.AggregatePlayedByClass()
  if #aggregated == 0 then return end

  local maxSeconds = aggregated[1].seconds
  local maxWidth = 240
  local barHeight = 16
  local spacing = m(-2)

  -- Color maps for class gradients (lazy-init if cache not yet generated)
  local fgMap = F.Color.GetMap("classColorMap")
  if not fgMap then
    F.Color.GenerateCache()
    fgMap = F.Color.GetMap("classColorMap")
  end
  local normalMap = fgMap and fgMap[I.Enum.GradientMode.Color.NORMAL]
  local shiftMap = fgMap and fgMap[I.Enum.GradientMode.Color.SHIFT]

  local yOffset = 0
  for _, item in ipairs(aggregated) do
    local barFrame = CreateFrame("Frame", nil, graph)
    barFrame:SetPoint("TOPLEFT", graph, "TOPLEFT", 24, yOffset)
    barFrame:SetSize(maxWidth, barHeight)

    -- Transparent black backdrop
    local bg = barFrame:CreateTexture(nil, "BACKGROUND")
    bg:SetPoint("LEFT", barFrame, "LEFT", 0, 0)
    bg:SetSize(maxWidth, barHeight)
    bg:SetColorTexture(0, 0, 0, 0.33)

    -- Class icon
    local iconFS = barFrame:CreateFontString(nil, "OVERLAY")
    iconFS:SetPoint("RIGHT", barFrame, "LEFT", -4, 0)
    iconFS:SetFont(F.GetFontPath(I.Fonts.Primary), F.FontSizeScaled(barHeight + 2), "")
    local iconTheme = "ToxiClasses"
    local iconMarkup = string.format(Misc:GetClassIconPath(iconTheme), Misc.ClassIcons[item.class] or Misc.ClassIcons[E.myclass])
    iconMarkup = iconMarkup:gsub("32:32", tostring(barHeight + 2) .. ":" .. tostring(barHeight + 2))
    iconFS:SetText(iconMarkup)

    -- Gradient bar texture
    local width = math.max(2, math.floor((item.seconds / maxSeconds) * maxWidth))
    local tex = barFrame:CreateTexture(nil, "ARTWORK")
    tex:SetPoint("LEFT", barFrame, "LEFT", 0, 0)
    tex:SetSize(width, barHeight)
    tex:SetTexture(E.media.normTex)

    local start = shiftMap and shiftMap[item.class] or CreateColor(0.3, 0.3, 0.3, 1)
    local finish = normalMap and normalMap[item.class] or CreateColor(0.6, 0.6, 0.6, 1)
    F.Color.SetGradient(tex, "HORIZONTAL", start, finish)

    -- Duration label
    local totalFS = barFrame:CreateFontString(nil, "OVERLAY")
    totalFS:SetPoint("LEFT", barFrame, "RIGHT", 8, 0)
    totalFS:SetJustifyH("LEFT")
    totalFS:SetFont(F.GetFontPath(I.Fonts.Primary), F.FontSizeScaled(13), "OUTLINE")
    totalFS:SetTextColor(1, 1, 1, 1)
    totalFS:SetText(GM.FormatPlayed(item.seconds, false))

    -- Hover highlight overlay
    local highlight = barFrame:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetAllPoints(barFrame)
    highlight:SetColorTexture(1, 1, 1, 0.12)

    -- Tooltip on hover showing per-character breakdown
    barFrame:EnableMouse(true)
    barFrame:SetScript("OnEnter", function(frame)
      bg:SetColorTexture(0, 0, 0, 0.5)

      local chars = GM.GetCharactersByClass(item.class)
      if #chars == 0 then return end

      GameTooltip:SetOwner(frame, "ANCHOR_RIGHT", 8, 0)

      local className = F.String.Class(I.EnglishClassName[item.class] or item.class, item.class)
      GameTooltip:AddLine(className .. "  —  " .. GM.FormatPlayed(item.seconds, false), 1, 1, 1)
      GameTooltip:AddLine(" ")

      for _, char in ipairs(chars) do
        local nameRealm = F.String.Class(char.name, item.class) .. "|cff888888-" .. char.realm .. "|r"
        GameTooltip:AddDoubleLine(nameRealm, GM.FormatPlayed(char.seconds, false), 1, 1, 1, 0.8, 0.8, 0.8)
      end

      GameTooltip:Show()
    end)
    barFrame:SetScript("OnLeave", function()
      bg:SetColorTexture(0, 0, 0, 0.33)
      GameTooltip:Hide()
    end)

    table.insert(graph.bars, barFrame)
    barFrame:Show()
    yOffset = yOffset - (barHeight - spacing)
  end

  graph:SetHeight(-yOffset + barHeight)
end

-- Event handlers for /played time tracking

function GM:OnTimePlayed(_, totalTimePlayed, levelTimePlayed)
  self.totalTimePlayed = totalTimePlayed
  self.levelTimePlayed = levelTimePlayed
  if self.played and self.played.total then
    local sumAll = GM.GetTotalPlayedAll() + (totalTimePlayed or 0)
    self.played.total:SetText("Total: " .. GM.FormatPlayed(sumAll))
  end

  -- Persist per-character seconds
  E.global.TXUI = E.global.TXUI or {}
  E.global.TXUI.playedSeconds = E.global.TXUI.playedSeconds or {}
  E.global.TXUI.playedSeconds[E.myrealm] = E.global.TXUI.playedSeconds[E.myrealm] or {}
  E.global.TXUI.playedSeconds[E.myrealm][E.myname] = totalTimePlayed

  -- Ensure class mapping exists
  E.global.TXUI.classMap = E.global.TXUI.classMap or {}
  E.global.TXUI.classMap[E.myrealm] = E.global.TXUI.classMap[E.myrealm] or {}
  E.global.TXUI.classMap[E.myrealm][E.myname] = E.myclass

  -- Only handle once per login request
  self:UnregisterEvent("TIME_PLAYED_MSG")
end

function GM:OnPlayerEnteringWorld(_, isLogin, isReloadingUI)
  -- Prepare persistent store for session start per character
  E.global.TXUI = E.global.TXUI or {}
  E.global.TXUI.sessionStartEpoch = E.global.TXUI.sessionStartEpoch or {}
  E.global.TXUI.sessionStartEpoch[E.myrealm] = E.global.TXUI.sessionStartEpoch[E.myrealm] or {}

  if not self._playedRequested then
    self._playedRequested = true
    self:RegisterEvent("TIME_PLAYED_MSG", "OnTimePlayed")
    RequestTimePlayed()
  end

  if isLogin then
    local now = time()
    self.sessionStartEpoch = now
    E.global.TXUI.sessionStartEpoch[E.myrealm][E.myname] = now
  elseif isReloadingUI then
    local saved = E.global.TXUI.sessionStartEpoch[E.myrealm][E.myname]
    if saved and saved > 0 then self.sessionStartEpoch = saved end
  else
    local saved = E.global.TXUI.sessionStartEpoch[E.myrealm][E.myname]
    if saved and saved > 0 then self.sessionStartEpoch = saved end
  end
end
