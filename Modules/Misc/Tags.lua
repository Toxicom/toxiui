local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local M = TXUI:GetModule("Misc")
local UF = E:GetModule("UnitFrames")
local ElvUF = E.oUF

local ipairs = ipairs
local select = select
local UnitClass = UnitClass
local UnitIsPlayer = UnitIsPlayer
local UnitReaction = UnitReaction

function M:_TagsUpdate()
  if not F.IsTXUIProfile() then return end

  for _, unit in ipairs { "party", "arena", "boss", "pet", "player", "target", "targettarget", "focus", "raid1", "raid2", "raid3" } do
    if unit == "party" or unit:find("raid") then
      for i = 1, UF[unit]:GetNumChildren() do
        local child = select(i, UF[unit]:GetChildren())
        for x = 1, child:GetNumChildren() do
          local subchild = select(x, child:GetChildren())
          if subchild then subchild:UpdateTags() end
        end
      end
    elseif unit == "boss" or unit == "arena" then
      for i = 1, 10 do
        local unitframe = UF[unit .. i]
        if unitframe then unitframe:UpdateTags() end
      end
    else
      local unitframe = UF[unit]
      if unitframe then unitframe:UpdateTags() end
    end
  end
end

function M:TagsUpdate()
  if UF.Initialized then
    F.Event.RunNextFrame(function()
      F.Event.ContinueAfterElvUIUpdate(function()
        self:_TagsUpdate()
      end)
    end)
  elseif not self:IsHooked(UF, "Initialize") then
    self:SecureHook(UF, "Initialize", F.Event.GenerateClosure(self.TagsUpdate, self))
  end
end

function M:Tags()
  local dm = TXUI:GetModule("ThemesDarkTransparency")

  -- ClassColor Tag
  E:AddTag("tx:classcolor", "UNIT_NAME_UPDATE UNIT_FACTION INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(unit)
    if not dm.isEnabled then return "|cffffffff" end

    if UnitIsPlayer(unit) then
      local _, unitClass = UnitClass(unit)
      local cs = ElvUF.colors.class[unitClass]
      return (cs and "|cff" .. F.String.FastRGB(cs[1], cs[2], cs[3])) or "|cffcccccc"
    else
      local cr = ElvUF.colors.reaction[UnitReaction(unit, "player")]
      return (cr and "|cff" .. F.String.FastRGB(cr[1], cr[2], cr[3])) or "|cffcccccc"
    end
  end)

  -- ClassColor Tag Info
  E.TagInfo["tx:classcolor"] = {
    category = TXUI.Title, -- Title
    description = "Colors names by player class or NPC reaction when DarkMode is enabled, white otherwise (Ex: [tx:classcolor][name])",
  }

  -- Settings Callback
  F.Event.RegisterCallback("Tags.DatabaseUpdate", self.TagsUpdate, self)
  F.Event.RegisterCallback("TXUI.DatabaseUpdate", self.TagsUpdate, self)
  F.Event.RegisterOnceCallback("TXUI.InitializedSafe", F.Event.GenerateClosure(self.TagsUpdate, self))
end

M:AddCallback("Tags")
