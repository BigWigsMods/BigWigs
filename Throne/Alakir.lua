--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Al'Akir", "Throne of the Four Winds")
if not mod then return end
mod:RegisterEnableMob(46753)
mod.toggleOptions = {88427, "phase_change", 87770, 87904, {89668, "ICON", "FLASHSHAKE", "WHISPER"}, 93286, "bosskill"}
mod.optionHeaders = {
	bosskill = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local lastWindburst = 0
local windburst = GetSpellInfo(87770)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.windburst = windburst

	L.phase3_yell = "Enough! I will no longer be contained!"

	L.phase_change = "Phase change"
	L.phase_change_desc = "Announce phase changes."
	L.phase_message = "Phase %d"

	L.feedback_message = "%dx Feedback"

	L.you = "%s on YOU!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Electrocute", 88427)
	self:Log("SPELL_CAST_START", "WindBurst1", 87770, 93261, 93263)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Feedback", 87904)
	self:Log("SPELL_AURA_APPLIED", "Feedback", 87904)
	self:Log("SPELL_AURA_APPLIED", "Phase2", 88301, 93279) -- Acid Rain is applied at P2 transition
	--self:Log("SPELL_AURA_REMOVED", "Phase3", 93279) -- Somehow it is also removed sometimes at P2 transition, use Yell instead

	self:Yell("Phase3", L["phase3_yell"])

	self:Log("SPELL_AURA_APPLIED", "LightningRod", 89668)
	self:Log("SPELL_DAMAGE", "WindBurst3", 93286) -- Wind Burst in Phase 3 is instant cast

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:Death("Win", 46753)
end


function mod:OnEngage(diff)
	self:Bar(87770, L["windburst"], 22, 87770) -- this is a try to guess the Wind Burst cooldown at fight start
	phase = 1
	lastWindburst = 0
end


--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:LightningRod(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:FlashShake(89668)
		self:LocalMessage(89668, L["you"]:format(spellName), "Personal", spellId, "Info")
	end
	self:TargetMessage(89668, spellName, player, "Urgent", spellId)
	self:Whisper(89668, player, L["you"]:format(spellName))
	self:PrimaryIcon(89668, player)
end

function mod:Phase2(_, spellId)
	if phase >= 2 then return end
	self:Message("phase_change", L["phase_message"]:format(2), "Important", spellId, "Alert")
	self:SendMessage("BigWigs_StopBar", self, L["windburst"])
	phase = 2
end

function mod:Phase3()
	if phase >= 3 then return end
	self:Message("phase_change", L["phase_message"]:format(3), "Important", 93279, "Alert")
	self:Bar(93286, L["windburst"], 24, 93286)
	phase = 3
end

function mod:Feedback(_, spellId, _, _, spellName, stack)
	self:Bar(87904, spellName, 20, spellId)
	if not stack then stack = 1 end
	self:Message(87904, L["feedback_message"]:format(stack), "Important", spellId, "Alert")
end

function mod:Electrocute(player, spellId, _, _, spellName)
	self:TargetMessage(88427, spellName, player, "Personal", spellId, "Alarm")
end

function mod:WindBurst1(_, spellId, _, _, spellName)
	self:Bar(87770, L["windburst"], 26, spellId)
	self:Message(87770, L["windburst"], "Important", spellId, "Alert")
end

function mod:WindBurst3(_, spellId, _, _, spellName)
	if (GetTime() - lastWindburst) > 5 then
		self:Bar(93286, spellName, 19, spellId) -- 22 was too long, 19 should work
		self:Message(93286, spellName, "Important", spellId, "Alert")
	end
	lastWindburst = GetTime()
end

