local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local PF = TXUI:NewModule("Profiles", "AceHook-3.0")

local _G = _G
local format = string.format
local ipairs = ipairs
local pairs = pairs
local strsplit = strsplit
local tinsert = table.insert
local unpack = unpack

function PF:ProcessMovers(dbRef)
  -- Disable screen restrictions
  E:SetMoversClampedToScreen(false)

  -- Enable all movers
  for name in pairs(E.DisabledMovers) do
    local disable = E.DisabledMovers[name].shouldDisable
    local shouldDisable = (disable and disable()) or false

    if not shouldDisable and not E.CreatedMovers[name] then
      local holder = E.DisabledMovers[name]
      if not holder then TXUI:LogDebug("holder doesnt exist", name or "nil") end

      E.CreatedMovers[name] = {}
      for x, y in pairs(holder) do
        E.CreatedMovers[name][x] = y
      end

      E.DisabledMovers[name] = nil
    else
      TXUI:LogDebug("could not enable mover", name or "nil")
    end
  end

  local relativeMovers = {}
  local globalMovers = {}

  for name, points in pairs(dbRef.movers) do
    local _, relativeTo = strsplit(",", points)
    relativeTo = relativeTo:gsub("Mover", "")

    if relativeTo ~= "ElvUIParent" and relativeTo ~= "UIParent" then
      if not relativeMovers[relativeTo] then relativeMovers[relativeTo] = {} end
      tinsert(relativeMovers[relativeTo], { name, points })
    else
      tinsert(globalMovers, { name, points })
    end
  end

  local function processMover(info)
    local name, points = unpack(info)
    local cleanName = name:gsub("Mover", "")

    local holder = E.CreatedMovers[name]
    local mover = holder and holder.mover

    if mover and mover:GetCenter() then
      local point1, relativeTo1, relativePoint1, xOffset1, yOffset1 = strsplit(",", points)

      -- Set To DB Points
      mover:ClearAllPoints()
      mover:SetPoint(point1, relativeTo1, relativePoint1, xOffset1, yOffset1)

      -- Set ElvUI Converted Point
      local xOffsetConverted, yOffsetConverted, pointConverted = E:CalculateMoverPoints(mover)
      mover:ClearAllPoints()
      mover:SetPoint(pointConverted, _G.UIParent, pointConverted, xOffsetConverted, yOffsetConverted)

      -- Read resulting point, save it to our db
      local point3, _, relativePoint3, xOffset3, yOffset3 = mover:GetPoint()
      dbRef.movers[name] = format("%s,ElvUIParent,%s,%d,%d", point3, relativePoint3, xOffset3 and E:Round(xOffset3) or 0, yOffset3 and E:Round(yOffset3) or 0)

      -- Process other movers that are relative to us
      if relativeMovers[cleanName] and #relativeMovers[cleanName] > 0 then
        for i, relativeInfo in ipairs(relativeMovers[cleanName]) do
          if relativeInfo then
            relativeMovers[cleanName][i] = nil
            processMover(relativeInfo)
          end
        end
      end
    else
      self:LogDebug(F.String.Error("Could not find holder"), name)
    end
  end

  for _, info in ipairs(globalMovers) do
    processMover(info)
  end

  for parent, infos in pairs(relativeMovers) do
    for _, info in ipairs(infos) do
      if info then self:LogDebug(F.String.Error("Parent was never processed resulted in dangling child"), parent, info[1]) end
    end
  end
end

function PF:MergeElvUIProfile()
  local pf = self:BuildProfile()

  -- Use Debug output in development mode
  local crushFnc = TXUI.DevRelease and F.Table.CrushDebug or F.Table.Crush

  -- Merge Tables
  crushFnc(E.db, pf)

  -- Set Globals
  crushFnc(E.global, {
    uiScaleInformed = true,

    general = {
      commandBarSetting = "DISABLED",
      UIScale = F.PixelPerfect(),
    },
  })
end

function PF:ElvUIProfileMovers(callback)
  local pf = self:BuildProfile()

  -- Process all movers
  self:ProcessMovers(pf)

  -- Use Debug output in development mode
  local crushFnc = TXUI.DevRelease and F.Table.CrushDebug or F.Table.Crush

  -- Merge Tables
  crushFnc(E.db.movers, pf.movers)

  F.Event.RunNextFrame(function()
    F.Event.ContinueAfterElvUIUpdate(function()
      E:StaggeredUpdateAll()
      if callback then F.Event.ContinueAfterElvUIUpdate(callback) end
    end)
  end, 0.2)
end

function PF:ExecuteElvUIUpdate(callback, noMovers)
  -- Update ElvUI
  F.Event.RunNextFrame(function()
    F.Event.ContinueAfterElvUIUpdate(function()
      E:StaggeredUpdateAll()

      if not noMovers then
        F.Event.ContinueAfterElvUIUpdate(F.Event.GenerateClosure(self.ElvUIProfileMovers, self, callback))
      else
        F.Event.ContinueAfterElvUIUpdate(callback)
      end
    end)
  end, 0.2)
end

-- Initialization
function PF:Initialize()
  -- Don't init second time
  if self.Initialized then return end

  -- We actually don't need todo anything, everything is handled by the installer

  -- We are done, hooray!
  self.Initialized = true
end

TXUI:RegisterModule(PF:GetName())
