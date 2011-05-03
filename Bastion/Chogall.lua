--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Cho'gall", 758)
if not mod then return end
mod:RegisterEnableMob(43324)

--------------------------------------------------------------------------------
-- Locals
--

local worshipTargets = mod:NewTargetList()
local worshipCooldown = 24
local firstFury = 0
local counter = 1
local corruptingCrash = GetSpellInfo(93180)
local bigcount = 1
local oozecount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.orders = "Stance changes"
	L.orders_desc = "Warning for when Cho'gall changes between Shadow/Flame Orders stances."

	L.worship_cooldown = "~Worship"

	L.adherent_bar = "Big add #%d"
	L.adherent_message = "Add %d incoming!"
	L.ooze_bar = "Ooze swarm %d"
	L.ooze_message = "Ooze swarm %d incoming!"

	L.tentacles_bar = "Tentacles spawn"
	L.tentacles_message = "Tentacle disco party!"

	L.sickness_message = "You feel terrible!"
	L.blaze_message = "Fire under YOU!"
	L.crash_say = "Crash on ME!"

	L.fury_bar = "Next Fury"
	L.fury_message = "Fury!"
	L.first_fury_soon = "Fury Soon!"
	L.first_fury_message = "85% - Fury Begins!"

	L.unleashed_shadows = "Pulsing Shadow"

	L.phase2_message = "Phase 2!"
	L.phase2_soon = "Phase 2 soon!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		91303, {81538, "FLASHSHAKE"}, {93180, "FLASHSHAKE", "ICON", "SAY"}, 93223, 82524, 81628, 82299,
		82630, 82414,
		"orders", {82235, "FLASHSHAKE", "PROXIMITY"}, "berserk", "bosskill"
	}, {
		[91303] = CL.phase:format(1),
		[82630] = CL.phase:format(2),
		orders = "general",
	}
end

function mod:OnBossEnable()
	--normal
	self:Log("SPELL_CAST_SUCCESS", "Orders", 81171, 81556)
	self:Log("SPELL_AURA_APPLIED", "Worship", 91317, 93365, 93366, 93367)
	self:Log("SPELL_CAST_START", "SummonCorruptingAdherent", 81628)
	self:Log("SPELL_CAST_START", "FuryOfChogall", 82524)
	self:Log("SPELL_CAST_START", "FesterBlood", 82299)
	self:Log("SPELL_CAST_SUCCESS", "LastPhase", 82630)
	self:Log("SPELL_CAST_SUCCESS", "DarkenedCreations", 82414, 93160, 93162)
	self:Log("SPELL_CAST_SUCCESS", "CorruptingCrash", 81685, 93178, 93179, 93180)
	self:Log("SPELL_DAMAGE", "Blaze", 81538, 93212, 93213, 93214)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 43324)
end

function mod:OnEngage(diff)
	bigcount = 1
	oozecount = 1
	self:Bar(91303, L["worship_cooldown"], 11, 91303)
	-- self:Bar(81628, L["adherent_bar"]:format(bigcount), diff > 2 and 75 or 58, 81628)
	self:Berserk(600)
	worshipCooldown = 24 -- its not 40 sec till the 1st add
	firstFury = 0
	counter = 1

	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("UNIT_HEALTH")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local last = 0
	function mod:Blaze(player, spellId, _, _, spellName)
		local time = GetTime()
		if (time - last) > 2 then
			last = time
			if UnitIsUnit(player, "player") then
				self:LocalMessage(81538, L["blaze_message"], "Personal", spellId, "Info")
				self:FlashShake(81538)
			end
		end
	end
end

do
	local function checkTarget(sGUID)
		local mobId = mod:GetUnitIdByGUID(sGUID)
		if mobId then
			local player = UnitName(mobId.."target")
			if not player then return end
			if UnitIsUnit("player", player) then
				mod:Say(93180, L["crash_say"])
				mod:FlashShake(93180)
			end
			mod:TargetMessage(93180, corruptingCrash, player, "Urgent", 93180, "Long")
			if counter == 1 then
				mod:PrimaryIcon(93180, player)
			else
				mod:SecondaryIcon(93180, player)
			end
			if mod:GetInstanceDifficulty() == 4 then counter = counter + 1 end
		end
		if counter > 2 then counter = 1 end
	end
	function mod:CorruptingCrash(...)
		local sGUID = select(11, ...)
		self:ScheduleTimer(checkTarget, 0.2, sGUID)
	end
end

do
	local sickness = GetSpellInfo(82235)
	local prev = 0
	function mod:UNIT_AURA(_, unit)
		if unit ~= "player" then return end
		local t = GetTime()
		if (t - prev) > 7 then
			local sick = UnitDebuff("player", sickness)
			if sick then
				prev = t
				self:LocalMessage(82235, L["sickness_message"], "Personal", 81831, "Long")
				self:OpenProximity(5, 82235)
				self:FlashShake(82235)
			end
		end
	end
end

function mod:FuryOfChogall(_, spellId, _, _, spellName)
	if firstFury == 1 then
		self:Message(82524, L["first_fury_message"], "Attention", spellId)
		firstFury = 2
	else
		self:Message(82524, L["fury_message"], "Attention", spellId)
	end
	self:Bar(82524, L["fury_bar"], 47, spellId)
end

function mod:Orders(_, spellId, _, _, spellName)
	self:Message("orders", spellName, "Urgent", spellId)
	if spellId == 81556 then
		if self:GetInstanceDifficulty() > 2 then
			self:Bar(93223, L["unleashed_shadows"], 24, 93223) -- verified for 25man heroic
		else
			self:Bar(93223, L["unleashed_shadows"], 15, 93223) -- verified for 10man normal
		end
	end
end

do
	local function nextAdd(spellId)
		mod:Bar(81628, L["adherent_bar"]:format(bigcount), 50, spellId)
	end
	function mod:SummonCorruptingAdherent(_, spellId, _, _, spellName)
		worshipCooldown = 40
		self:Message(81628, L["adherent_message"]:format(bigcount), "Important", spellId)
		bigcount = bigcount + 1
		self:ScheduleTimer(nextAdd, 41, spellId)

		-- I assume its 40 sec from summon and the timer is not between two casts of Fester Blood
		self:Bar(82299, L["ooze_bar"]:format(oozecount), 40, 82299)
	end
end

function mod:FesterBlood(_, spellId, _, _, spellName)
	self:Message(82299, L["ooze_message"]:format(oozecount), "Attention", spellId, "Alert")
	oozecount = oozecount + 1
end

function mod:UNIT_HEALTH()
	local hp = UnitHealth("boss1") / UnitHealthMax("boss1") * 100
	if firstFury == 0 and hp > 86 and hp < 89 then
		self:Message(82524, L["first_fury_soon"], "Attention", 82524)
		firstFury = 1
	elseif hp < 30 then
		self:Message(82630, L["phase2_soon"], "Attention", 82630, "Info")
		self:UnregisterEvent("UNIT_HEALTH")
	end
end

function mod:LastPhase(_, spellId)
	self:SendMessage("BigWigs_StopBar", self, L["adherent_bar"])
	self:SendMessage("BigWigs_StopBar", self, L["ooze_bar"])
	self:SendMessage("BigWigs_StopBar", self, L["worship_cooldown"])
	self:Message(82630, L["phase2_message"], "Positive", spellId)
	self:Bar(82414, L["tentacles_bar"], 6, 82414)
end

function mod:DarkenedCreations(_, spellId)
	self:Message(82414, L["tentacles_message"], "Urgent", spellId)
	self:Bar(82414, L["tentacles_bar"], 30, 82414)
end

do
	local scheduled = nil
	local function worshipWarn(spellName)
		mod:TargetMessage(91303, spellName, worshipTargets, "Important", 91303)
		mod:PlaySound(91303, "Alarm")
		scheduled = nil
	end
	function mod:Worship(player, spellId, _, _, spellName)
		worshipTargets[#worshipTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:Bar(91303, L["worship_cooldown"], worshipCooldown, 91303)
			self:ScheduleTimer(worshipWarn, 0.3, spellName)
		end
	end
end

