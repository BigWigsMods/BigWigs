--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Leotheras the Blind", 548, 1569)
if not mod then return end
mod:RegisterEnableMob(21215)
mod:SetAllowWin(true)
mod:SetEncounterID(625)

local beDemon = mod:NewTargetList()
local demonTimer = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.enrage_trigger = "Finally, my banishment ends!"

	L.phase = "Demon Phase"
	L.phase_desc = "Estimated demon phase timers."
	L.phase_icon = "Spell_Shadow_Metamorphosis"
	L.phase_trigger = "Be gone, trifling elf.  I am in control now!"
	L.phase_demon = "Demon Phase for 60sec"
	L.phase_demonsoon = "Demon Phase in 5sec!"
	L.phase_normalsoon = "Normal Phase in 5sec"
	L.phase_normal = "Normal Phase!"
	L.demon_bar = "Demon Phase"
	L.demon_nextbar = "Next Demon Phase"

	L.mindcontrol = "Mind Control"
	L.mindcontrol_desc = "Warn which players are Mind Controlled."
	L.mindcontrol_icon = 37749
	L.mindcontrol_warning = "Mind Controlled"

	L.image = "Image"
	L.image_desc = "15% Image Split Alerts."
	L.image_trigger = "No... no! What have you done? I am the master! Do you hear me? I am... aaggh! Can't... contain him."
	L.image_message = "15% - Image Created!"
	L.image_warning = "Image Soon!"

	L.whisper = "Insidious Whisper (Demon)"
	L.whisper_desc = "Alert what players have Insidious Whisper (Demon)."
	L.whisper_icon = 37676
	L.whisper_message = "Demon"
	L.whisper_bar = "Demons Despawn"
	L.whisper_soon = "~Demons"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		37640, "whisper", "mindcontrol", "phase", "image", "berserk"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Whirlwind", 37640)
	self:Log("SPELL_AURA_REMOVED", "WhirlwindBar", 37640)
	self:Log("SPELL_AURA_APPLIED", "Whisper", 37676)
	self:Log("SPELL_AURA_APPLIED", "Madness", 37749)

	self:BossYell("Image", L["image_trigger"])
	self:BossYell("Phase", L["phase_trigger"])

	self:BossYell("Engage", L["enrage_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 21215)
end

function mod:OnEngage()
	self:RegisterUnitEvent("UNIT_HEALTH", nil, "target", "focus")
	demonTimer = nil

	self:DelayedMessage("phase", 55, "orange", L["phase_demonsoon"])
	self:Bar("phase", 60, L["demon_nextbar"], "Spell_Shadow_Metamorphosis")
	self:Berserk(600)
	self:WhirlwindBar()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local scheduled = nil
	local function demonWarn(spellId)
		mod:TargetMessageOld("whisper", beDemon, "yellow", nil, L["whisper_message"], spellId)
		scheduled = nil
	end
	function mod:Whisper(args)
		beDemon[#beDemon + 1] = args.destName
		if not scheduled then
			scheduled = true
			self:Bar("whisper", 30, L["whisper_bar"], args.spellId)
			self:ScheduleTimer(demonWarn, 0.3, args.spellId)
		end
	end
end

function mod:Whirlwind(args)
	self:MessageOld(args.spellId, "red", "alert")
	self:Bar(args.spellId, 12, CL["cast"]:format(args.spellName))
end

function mod:WhirlwindBar()
	self:CDBar(37640, 15)
	self:DelayedMessage(37640, 14, "yellow", CL["soon"]:format(self:SpellName(37640)))
end

function mod:Madness(args)
	self:TargetMessageOld("mindcontrol", args.destName, "orange", "alert", L["mindcontrol_warning"], args.spellId)
end

do
	local function demonSoon()
		mod:MessageOld("phase", "red", nil, L["phase_normal"], false)
		mod:DelayedMessage("phase", 40, "orange", L["phase_demonsoon"])
		mod:Bar("phase", 45, L["demon_nextbar"], "Spell_Shadow_Metamorphosis")
	end
	function mod:Phase()
		self:StopBar(CL["cast"]:format(self:SpellName(37640)))
		self:StopBar(37640)
		self:StopBar(L["demon_nextbar"])
		self:CancelAllTimers()

		self:MessageOld("phase", "yellow", nil, L["phase_demon"], false)
		self:DelayedMessage("phase", 55, "red", L["phase_normalsoon"])
		self:Bar("whisper", 23, L["whisper_soon"], 37676)
		self:Bar("phase", 60, L["demon_bar"], "Spell_Shadow_Metamorphosis")
		demonTimer = self:ScheduleTimer(demonSoon, 60)
		self:ScheduleTimer("WhirlwindBar", 60)
	end
end

function mod:Image()
	self:CancelTimer(demonTimer)
	self:CancelDelayedMessage(L["phase_normalsoon"])
	self:CancelDelayedMessage(L["phase_demonsoon"])
	self:StopBar(L["demon_bar"])
	self:StopBar(L["demon_nextbar"])
	self:MessageOld("image", "red", nil, L["image_message"], false)
end

function mod:UNIT_HEALTH(event, unit)
	if self:MobId(self:UnitGUID(unit)) == 21215 then
		local hp = self:GetHealth(unit)
		if hp > 15 and hp < 20 then
			self:MessageOld("image", "orange", nil, L["image_warning"], false)
			self:UnregisterUnitEvent(event, "target", "focus")
		end
	end
end

