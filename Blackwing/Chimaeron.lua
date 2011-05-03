--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Chimaeron", 754)
if not mod then return end
mod:RegisterEnableMob(43296)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bileotron_engage = "The Bile-O-Tron springs to life and begins to emit a foul smelling substance."

	L.next_system_failure = "~Next System Failure"
	L.break_message = "%2$dx Break on %1$s"

	L.phase2_message = "Mortality phase soon!"

	L.warmup = "Warmup"
	L.warmup_desc = "Warmup timer"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"warmup", 82848, 88826, 82881, {88853, "FLASHSHAKE"}, 88917, 82890,
		"proximity", "berserk", "bosskill"
	}, {
		warmup = "normal",
		proximity = "general"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "SystemFailureStart", 88853)
	self:Log("SPELL_AURA_REMOVED", "SystemFailureEnd", 88853)
	self:Log("SPELL_CAST_SUCCESS", "Mortality", 82890)
	self:Log("SPELL_AURA_APPLIED", "Break", 82881)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Break", 82881)
	self:Log("SPELL_AURA_APPLIED", "DoubleAttack", 88826)
	self:Log("SPELL_CAST_START", "Massacre", 82848)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE", "Warmup")

	self:Death("Win", 43296)
end

function mod:Warmup(_, msg)
	if msg == L["bileotron_engage"] then
		self:Bar("warmup", self.displayName, 30, "achievement_dungeon_blackwingdescent_raid_chimaron")
		self:OpenProximity(6)
	end
end

function mod:OnEngage(diff)
	self:SendMessage("BigWigs_StopBar", self, self.displayName)
	self:Berserk(450)
	if diff < 3 then
		self:Bar(88853, L["next_system_failure"], 90, 88853) --happens randomly at either 60 or 90 on heroic
	end
	self:Bar(82848, GetSpellInfo(82848), 30, 82848) --Massacre
	self:RegisterEvent("UNIT_HEALTH")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SystemFailureStart(_, spellId, _, _, spellName)
	self:SendMessage("BigWigs_StopBar", self, L["next_system_failure"])
	self:Bar(88853, spellName, 30, spellId)
	self:Message(88853, spellName, "Important", spellId, "Alarm")
	self:FlashShake(88853)
	self:CloseProximity()
end

function mod:SystemFailureEnd(_, spellId)
	if self.isEngaged then --To prevent firing after a wipe
		if self:GetInstanceDifficulty() < 3 then
			self:Bar(88853, L["next_system_failure"], 65, spellId)
		end
		self:FlashShake(88853)
		self:OpenProximity(6)
	end
end

function mod:Massacre(_, spellId, _, _, spellName)
	self:Message(82848, spellName, "Attention", spellId)
	self:Bar(82848, spellName, 30, spellId)
	self:Bar(88917, GetSpellInfo(88917), 19, 88917) --Caustic Slime
end

function mod:Mortality(_, spellId, _, _, spellName)
	self:Message(82890, spellName, "Important", spellId, "Long")
	self:CloseProximity()
	self:SendMessage("BigWigs_StopBar", self, L["next_system_failure"])
end

function mod:Break(player, spellId, _, _, _, stack)
	self:TargetMessage(82881, L["break_message"], player, "Attention", spellId, nil, stack or 1)
end

function mod:DoubleAttack(_, spellId, _, _, spellName)
	self:Message(88826, spellName, "Urgent", spellId)
end

function mod:UNIT_HEALTH()
	local hp = UnitHealth("boss1") / UnitHealthMax("boss1") * 100
	if hp < 23 then
		self:Message(82890, L["phase2_message"], "Positive", 82890, "Info")
		self:UnregisterEvent("UNIT_HEALTH")
	end
end

