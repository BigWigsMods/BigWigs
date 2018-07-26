
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Withered J'im", -630, 1796)
if not mod then return end
mod:RegisterEnableMob(102075, 112350) -- Withered J'im, Clone
mod.otherMenu = -619
mod.worldBoss = 102075

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_mark_boss = "Mark Withered J'im"
	L.custom_on_mark_boss_desc = "Mark the real Withered J'im with {rt8}, requires promoted or leader."
	L.custom_on_mark_boss_icon = 8
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		223715, -- More... MORE MORE MORE!
		223623, -- Nightshifted Bolts
		223614, -- Resonance
		"custom_on_mark_boss",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_REMOVED", "More", 223715) -- spawn on REMOVED (3s after APPLIED)
	self:Log("SPELL_CAST_START", "NightshiftedBolts", 223623)
	self:Log("SPELL_AURA_APPLIED", "Resonance", 223614)
	self:Death("Win", 102075)

	self:ScheduleTimer("CheckForEngage", 1)
end

function mod:OnEngage()
	self:CheckForWipe()
	self:CDBar(223623, 4) -- Nightshifted Bolts
	self:CDBar(223614, 13) -- Resonance
	self:CDBar(223715, 30, 74511, 223715) -- More... MORE MORE MORE!
	if self:GetOption("custom_on_mark_boss") then
		self:RegisterTargetEvents("MarkBoss")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MarkBoss(event, unit, guid)
	local mobId = self:MobId(guid)
	if mobId == 102075 then
		SetRaidTarget(unit, 8)
		self:UnregisterTargetEvents()
	end
end

function mod:More(args)
	self:Message(args.spellId, "cyan", "Info", 74511, args.spellId) -- 74511 = Summon Clone
	self:CDBar(args.spellId, 30, 74511, args.spellId) -- 30.6-31.0
end

function mod:NightshiftedBolts(args)
	self:Message(args.spellId, "yellow", "Alarm")
	self:CDBar(args.spellId, 31.5)
end

function mod:Resonance(args)
	self:Message(args.spellId, "orange", "Alert")
	self:CDBar(args.spellId, 31)
end
