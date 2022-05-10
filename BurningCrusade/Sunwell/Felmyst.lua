--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Felmyst", 580, 1593)
if not mod then return end
mod:RegisterEnableMob(25038)
mod:SetAllowWin(true)
mod:SetEncounterID(726)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local breathCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.phase = "Phases"
	L.phase_desc = "Warn for takeoff and landing phases."
	L.phase_icon = 19879 -- inv_misc_head_dragon_01

	L.airphase_trigger = "I am stronger than ever before!"
	L.takeoff_bar = "Takeoff"
	L.takeoff_message = "Taking off in 5sec!"

	L.landing_bar = "Landing"
	L.landing_message = "Landing in 10sec!"

	L.breath = "Deep Breath"
	L.breath_desc = "Deep Breath warnings."
	L.breath_icon = 40508 -- spell_nature_acid_01
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		45855, -- Gas Nova
		{45402, "ICON"}, -- Demonic Vapor
		{45661, "ICON", "PROXIMITY"}, -- Encapsulate
		"phase",
		"breath",
		"berserk",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Log("SPELL_CAST_START", "GasNova", 45855)
	self:Log("SPELL_SUMMON", "SummonDemonicVapor", 45392)
	self:Log("SPELL_DAMAGE", "Encapsulate", 45661) -- Doesn't function like a normal debuff

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:Death("Win", 25038)
end

function mod:OnEngage()
	breathCount = 1
	self:Berserk(600)

	self:PhaseOne()
	self:OpenProximity(45661, 18) -- Encapsulate
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:GasNova(args)
	self:MessageOld(args.spellId, "yellow", nil, CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 20)
end

function mod:SummonDemonicVapor(args)
	self:TargetMessageOld(45402, args.sourceName, "orange", "alert")
	self:TargetBar(45402, 10, args.sourceName)
	self:PrimaryIcon(45402, args.sourceName)
end

do
	local prev = 0
	function mod:Encapsulate(args)
		local t = args.time
		if t-prev > 15 then
			prev = t
			self:TargetBar(args.spellId, 6, args.destName)
			self:TargetMessageOld(args.spellId, args.destName, "red", "alert")
			self:PrimaryIcon(args.spellId, args.destName)
		end
	end
end

function mod:PhaseOne()
	self:Bar("phase", 60, L.takeoff_bar, L.phase_icon)
	self:DelayedMessage("phase", 55, "yellow", L.takeoff_message)

	self:Bar(45661, 30) -- Encapsulate
	self:DelayedMessage(45661, 25, "yellow", CL.custom_sec:format(self:SpellName(45661), 5))
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, _, unit)
	if unit == self.displayName then
		self:MessageOld("breath", "yellow", nil, CL.count:format(L.breath, breathCount), L.breath_icon)
		self:Bar("breath", 4, CL.count:format(L.breath, breathCount), L.breath_icon)
		breathCount = breathCount + 1
		if breathCount < 4 then
			self:CDBar("breath", 17, CL.count:format(L.breath, breathCount), L.breath_icon)
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg == L.airphase_trigger then
		self:Bar("phase", 100, L.landing_bar, L.phase_icon)
		self:DelayedMessage("phase", 90, "yellow", L.landing_message)

		self:ScheduleTimer("PhaseOne", 100)

		breathCount = 1
		self:CDBar("breath", 40.5, CL.count:format(L.breath, breathCount), L.breath_icon)
	end
end
