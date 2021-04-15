--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Attumen the Huntsman Raid", 532, 1553)
if not mod then return end
mod:RegisterEnableMob(16152, 16151, 15550)
mod:SetAllowWin(true)
mod:SetEncounterID(2444)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.phase = "Phase"
	L.phase_desc = "Warn when entering a new Phase."
	L.phase2_trigger = "%s calls for her master!"
	L.phase2_message = "Phase 2"
	L.phase3_trigger = "Come Midnight, let's disperse this petty rabble!"
	L.phase3_message = "Phase 3"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {"phase", 29833}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Curse", 29833)
	self:BossYell("Phase3", L["phase3_trigger"])

	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:Death("Win", 15550)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Curse(args)
	self:TargetMessageOld(args.spellId, args.destName, "yellow")
end

function mod:CHAT_MSG_MONSTER_EMOTE(_, msg)
	if msg == L["phase2_trigger"] then
		self:MessageOld("phase", "red", nil, L["phase2_message"], false)
	end
end

function mod:Phase3()
	self:MessageOld("phase", "red", nil, L["phase3_message"], false)
end

