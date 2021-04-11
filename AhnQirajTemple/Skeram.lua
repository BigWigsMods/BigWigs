
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("The Prophet Skeram", 531)
if not mod then return end
mod:RegisterEnableMob(15263)
mod:SetAllowWin(true)
mod.engageId = 709

local splitPhase = 1
local lastMC = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "The Prophet Skeram"

	L.images = 747 -- Summon Images
	L.images_icon = "spell_shadow_impphaseshift"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{785, "ICON"}, -- True Fulfillment
		20449, -- Teleport
		26192, -- Arcane Explosion
		"images",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "TrueFulfillment", 785)
	self:Log("SPELL_AURA_REMOVED", "TrueFulfillmentRemoved", 785)
	self:Log("SPELL_CAST_SUCCESS", "Teleport", 20449, 4801, 8195)
	self:Log("SPELL_CAST_START", "ArcaneExplosion", 26192)
	self:Log("SPELL_CAST_SUCCESS", "SummonImages", 747)

	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "target", "focus")
end

function mod:OnEngage()
	splitPhase = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:TrueFulfillment(args) -- Mind control
	self:TargetMessage(785, "yellow", args.destName)
	self:TargetBar(785, 20, args.destName)
	self:PrimaryIcon(785, args.destName)
	lastMC = args.destGUID
end

function mod:TrueFulfillmentRemoved(args)
	if args.destGUID == lastMC then
		lastMC = nil
		self:PrimaryIcon(785)
	end
end

function mod:Teleport(args)
	if self:MobId(args.sourceGUID) == 15263 then -- Filter out his images
		self:Message(20449, "red")
	end
end

function mod:ArcaneExplosion(args)
	self:Message(26192, "orange")
end

function mod:SummonImages()
	self:Message("images", "red", L.images, L.images_icon)
	self:PlaySound("images", "long")
end

function mod:UNIT_HEALTH_FREQUENT(event, unit)
	if self:MobId(self:UnitGUID(unit)) == 15263 then
		local hp = self:UnitHealth(unit)
		if (hp < 82 and splitPhase == 1) or (hp < 57 and splitPhase == 2) or (hp < 32 and splitPhase == 3) then
			splitPhase = splitPhase + 1
			self:Message("images", "green", CL.soon:format(self:SpellName(L.images)), false)
			if splitPhase > 3 then
				self:UnregisterUnitEvent(event, "target", "focus")
			end
		end
	end
end

