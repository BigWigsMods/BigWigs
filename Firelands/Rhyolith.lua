--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Lord Rhyolith", 800, 193)
if not mod then return end
mod:RegisterEnableMob(52577, 53087, 52558) -- Left foot, Right Foot, Lord Rhyolith

--------------------------------------------------------------------------------
-- Locales
--

local moltenArmor = GetSpellInfo(98255)
local lastFragments = nil
local bossGuid = nil

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.molten_message = "%dx stacks on boss!"
	L.armor_message = "%d%% armor left"
	L.armor_gone_message = "Armor go bye-bye!"
	L.phase2_soon_message = "Phase 2 soon!"
	L.stomp_message = "Stomp! Stomp! Stomp!"
	L.big_add_message = "Big add spawned!"
	L.small_adds_message = "Small adds inc!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		98552, 98136, 97282, 98255, 99846,
		"bosskill"
	}, {
		[98255] = "general"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED_DOSE", "MoltenArmor", 98255, 101157)
	self:Log("SPELL_CAST_START", "Stomp", 97282, 100411, 100968, 100969)
	self:Log("SPELL_SUMMON", "Spark", 98552)
	self:Log("SPELL_SUMMON", "Fragments", 100392, 98136)
	self:Log("SPELL_AURA_REMOVED_DOSE", "ObsidianStack", 98632)
	self:Log("SPELL_AURA_REMOVED", "Obsidian", 98632)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 52558)
end

function mod:OnEngage(diff)
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	lastFragments = GetTime()
	bossGuid = UnitGUID("boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Obsidian(_, spellId, _, _, _, _, _, _, _, dGUID)
	if dGUID ~= bossGuid then return end
	self:Message(98632, L["armor_gone_message"], "Positive", spellId)
end

function mod:ObsidianStack(_, spellId, _, _, _, buffStack, _, _, _, dGUID)
	if dGUID ~= bossGuid then return end
	if buffStack % 20 ~= 0 then return end -- Only warn every 20
	self:Message(98632, L["armor_message"]:format(buffStack), "Positive", spellId)
end

function mod:Spark(_, spellId)
	self:Message(98552, L["big_add_message"], "Important", spellId, "Alarm")
end

function mod:Fragments(_, spellId)
	local t = GetTime()
	if lastFragments and t < (lastFragments + 5) then return end
	lastFragments = t
	self:Message(98136, L["small_adds_message"], "Attention", spellId, "Info")
end

function mod:Stomp(_, spellId, _, _, spellName)
	self:Message(97282, L["stomp_message"], "Urgent",  spellId, "Alert")
	self:Bar(97282, L["stomp_message"], 3, spellId)
end

function mod:MoltenArmor(_, spellId, _, _, spellName, stack)
	if stack < 4 or stack % 2 ~= 0 then return end
	self:Message(98255, L["molten_message"]:format(stack), "Attention", spellId)
end

function mod:UNIT_HEALTH_FREQUENT(_, unitId)
	-- Boss frames were jumping around, there are 3 up with the buff on, so one of boss1 or boss2 is bound to exist
	if unitId == "boss1" or unitId == "boss2" then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp < 30 then -- phase starts at 25
			self:Message(99846, L["phase2_soon_message"], "Positive", 99846, "Info")
			local stack = select(4, UnitBuff(unitId, moltenArmor))
			if not stack then return end
			self:Message(98255, L["molten_message"]:format(stack), "Important", 98255, "Alarm")
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
		end
	end
end

