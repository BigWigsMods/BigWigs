--------------------------------------------------------------------------------
-- TODO:
-- - Timers are completely useless, because the boss is a full lag fest and
--   doesn't do anything most of the time.

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Mortanis", -1536, 2431)
if not mod then return end
mod:RegisterEnableMob(167525)
mod.otherMenu = -1647
mod.worldBoss = 167525

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		338848, -- Spine Crawl
		338847, -- Unholy Frenzy
		{338851, "FLASH", "SAY", "SAY_COUNTDOWN"}, -- Screaming Skull
		338846, -- Bone Cleave
		338849, -- Unruly Remains
		338850, -- Lord of the Fallen
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")

	self:Log("SPELL_CAST_START", "SpineCrawl", 338848)
	self:Log("SPELL_CAST_START", "UnholyFrenzy", 338847)
	self:Log("SPELL_AURA_APPLIED", "ScreamingSkull", 338851)
	self:Log("SPELL_CAST_START", "BoneCleave", 338846)
	self:Log("SPELL_CAST_SUCCESS", "UnrulyRemains", 338849, 339252)
	self:Log("SPELL_CAST_SUCCESS", "LordOfTheFallen", 338850)
end

function mod:OnEngage()
	self:CheckForWipe()
	--self:Bar(338847, ?) -- Unholy Frenzy
	--self:Bar(338848, ?) -- Spine Crawl
	--self:Bar(338849, ?) -- Unruly Remains
	--self:Bar(338851, ?) -- Screaming Skull
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 2410 then
		self:Win()
	end
end

function mod:SpineCrawl(args)
	self:Message(args.spellId, "yellow")
	self:CDBar(args.spellId, 17)
end

function mod:UnholyFrenzy(args)
	self:Message(args.spellId, "orange")
	self:Bar(args.spellId, 42)
	if self:Healer() or self:Tank() then
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:ScreamingSkull(args)
	self:TargetMessage(args.spellId, "red", args.destName)
	self:Bar(args.spellId, 30)

	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 8)
	end
end

function mod:BoneCleave(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "info")
	self:CDBar(args.spellId, 15)
end

function mod:UnrulyRemains(args)
	self:Message(338849, "yellow")
	self:PlaySound(338849, "alarm")
	self:Bar(338849, 16)
end

function mod:LordOfTheFallen(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
end
