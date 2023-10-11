local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")

function M:AdditionalScaling()
  -- Don't init if its not a TXUI profile or requirements are not met
  if not TXUI:HasRequirements(I.Requirements.AdditionalScaling) then return end

  -- check if database is present
  if E.db and E.db.TXUI then
    if not E.db.TXUI.misc.scaling.enabled then return end
    M:SetElementScale("map", "WorldMapFrame")
    M:SetElementScale("characterFrame", "CharacterFrame")
    M:SetElementScale("dressingRoom", "DressUpFrame")

    -- In the next parts, if the AddOn isn't loaded by the game yet,
    -- we add it to a list to be loaded as soon as the AddOn has been loaded.
    -- Otherwise we can scale the UI element directly.
    M:AddCallbackOrScale("Blizzard_InspectUI", self.ScaleInspectUI)

    -- Retail scaling
    if TXUI.IsRetail then M:AddCallbackOrScale("Blizzard_ClassTalentUI", self.ScaleTalents) end

    -- Retail & Wrath scaling
    if not TXUI.IsClassic then M:AddCallbackOrScale("Blizzard_Collections", self.ScaleCollections) end

    -- Wrath & Classic scaling
    if not TXUI.IsRetail then
      -- Classic: Talents
      M:AddCallbackOrScale("Blizzard_TalentUI", self.ScaleTalents)
    end
  else
    TXUI:LogDebug("AdditionalScaling > E.db or E.db.TXUI not found, skipping scaling!")
  end
end

M:AddCallback("AdditionalScaling")
