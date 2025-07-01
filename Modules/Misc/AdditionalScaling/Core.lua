local TXUI, F, E, I, V, P, G = unpack((select(2, ...)))
local M = TXUI:GetModule("Misc")

function M:AdditionalScaling()
  -- Don't init if its not a TXUI profile or requirements are not met
  if not TXUI:HasRequirements(I.Requirements.AdditionalScaling) then return end

  self.hookedFrames = {}

  -- check if database is present
  if E.db and E.db.TXUI then
    if not E.db.TXUI.misc.scaling.enabled then return end
    M:SetElementScale("map", "WorldMapFrame")
    M:SetElementScale("characterFrame", "CharacterFrame")
    M:SetElementScale("dressingRoom", "DressUpFrame")
    M:SetElementScale("vendor", "MerchantFrame")
    M:SetElementScale("gossip", "GossipFrame")
    M:SetElementScale("quest", "QuestFrame")
    M:SetElementScale("mailbox", "MailFrame")
    M:SetElementScale("friends", "FriendsFrame")

    -- In the next parts, if the AddOn isn't loaded by the game yet,
    -- we add it to a list to be loaded as soon as the AddOn has been loaded.
    -- Otherwise we can scale the UI element directly.
    M:AddCallbackOrScale("Blizzard_InspectUI", self.ScaleInspectUI)

    -- Retail scaling
    if TXUI.IsRetail then
      M:AddCallbackOrScale("Blizzard_AuctionHouseUI", self.ScaleAuctionHouse)

      -- For some reason these are different, altho they function exactly the same
      M:AddCallbackOrScale("Blizzard_ItemUpgradeUI", self.ScaleItemUpgrade)
      M:AddCallbackOrScale("Blizzard_ItemInteractionUI", self.ScaleCatalyst)

      M:AddCallbackOrScale("Blizzard_Collections", self.AdjustTransmogFrame)
      M:AddCallbackOrScale("Blizzard_PlayerSpells", self.ScaleRetailSpellbook)
      M:AddCallbackOrScale("Blizzard_Professions", self.ScaleProfessions)
      M:SetElementScale("groupFinder", "PVEFrame")
    end

    -- Retail & Mists scaling
    if not TXUI.IsVanilla then M:AddCallbackOrScale("Blizzard_Collections", self.ScaleCollections) end

    -- Mists & Vanilla scaling
    if not TXUI.IsRetail then
      M:AddCallbackOrScale("Blizzard_TalentUI", self.ScaleTalents)
      M:AddCallbackOrScale("Blizzard_TrainerUI", self.ScaleClassTrainer)
      M:AddCallbackOrScale("Blizzard_TradeSkillUI", self.ScaleProfessions)
      M:AddCallbackOrScale("Blizzard_AuctionUI", self.ScaleAuctionHouse)
      M:SetElementScale("taxi", "TaxiFrame")
      M:SetElementScale("spellbook", "SpellBookFrame")
    end
  else
    TXUI:LogDebug("AdditionalScaling > E.db or E.db.TXUI not found, skipping scaling!")
  end
end

M:AddCallback("AdditionalScaling")
