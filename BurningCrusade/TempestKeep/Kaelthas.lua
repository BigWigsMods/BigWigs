--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Kael'thas Sunstrider", 550, 1576)
if not mod then return end
--Kael'thas Sunstrider, Thaladred the Darkener, Master Engineer Telonicus, Grand Astromancer Capernian, Lord Sanguinar
mod:RegisterEnableMob(19622, 20064, 20063, 20062, 20060)
mod:SetAllowWin(true)
mod:SetEncounterID(2467)

local MCd = mod:NewTargetList()
local phase = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "Energy. Power."
	L.engage_message = "Phase 1"

	L.gaze = "Gaze"
	L.gaze_desc = "Warn when Thaladred focuses on a player."
	L.gaze_trigger = "sets eyes"

	L.fear_soon_message = "Fear soon!"
	L.fear_message = "Fear!"
	L.fear_bar = "~Fear"

	L.rebirth = "Phoenix Rebirth"
	L.rebirth_desc = "Approximate Phoenix Rebirth timers."
	L.rebirth_warning = "Possible Rebirth in ~5sec!"
	L.rebirth_bar = "~Rebirth"

	L.pyro = "Pyroblast"
	L.pyro_desc = "Show a 60 second timer for Pyroblast"
	L.pyro_trigger = "%s begins to cast Pyroblast!"
	L.pyro_warning = "Pyroblast in 5sec!"
	L.pyro_message = "Casting Pyroblast!"

	L.phase = "Phase warnings"
	L.phase_desc = "Warn about the various phases of the encounter."
	L.thaladred_inc_trigger = "Let us see how your nerves hold up against the Darkener, Thaladred! "
	L.sanguinar_inc_trigger = "You have persevered against some of my best advisors... but none can withstand the might of the Blood Hammer. Behold, Lord Sanguinar!"
	L.capernian_inc_trigger = "Capernian will see to it that your stay here is a short one."
	L.telonicus_inc_trigger = "Well done, you have proven worthy to test your skills against my master engineer, Telonicus."
	L.weapons_inc_trigger = "As you see, I have many weapons in my arsenal...."
	L.phase3_trigger = "Perhaps I underestimated you. It would be unfair to make you fight all four advisors at once, but... fair treatment was never shown to my people. I'm just returning the favor."
	L.phase4_trigger = "Alas, sometimes one must take matters into one's own hands. Balamore shanal!"

	L.flying_trigger = "I have not come this far to be stopped! The future I have planned will not be jeopardized! Now you will taste true power!!"
	L.flying_message = "Phase 5 - Gravity Lapse in 1min"

	L.weapons_inc_message = "Phase 2 - Weapons incoming!"
	L.phase3_message = "Phase 3 - Advisors and Weapons!"
	L.phase4_message = "Phase 4 - Kael'thas incoming!"
	L.phase4_bar = "Kael'thas incoming"

	L.mc = "Mind Control"
	L.mc_desc = "Warn who has Mind Control."
	L.mc_icon = 36797

	L.revive_bar = "Adds Revived"
	L.revive_warning = "Adds Revived in 5sec!"

	L.dead_message = "%s dies"

	L.capernian = "Grand Astromancer Capernian"
	L.sanguinar = "Lord Sanguinar"
	L.telonicus = "Master Engineer Telonicus"
	L.thaladred = "Thaladred the Darkener"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"phase", 37018, "mc", 37027, {"gaze", "ICON"}, 44863, "pyro", "rebirth", "proximity"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Conflag", 37018)
	self:Log("SPELL_AURA_APPLIED", "Toy", 37027)
	self:Log("SPELL_AURA_REMOVED", "ToyRemoved", 37027)
	self:Log("SPELL_AURA_APPLIED", "MC", 36797)
	self:Log("SPELL_CAST_START", "FearCast", 44863)
	self:Log("SPELL_MISSED", "Fear", 44863)
	self:Log("SPELL_AURA_APPLIED", "Fear", 44863)
	self:Log("SPELL_CAST_SUCCESS", "Phoenix", 36723)
	self:Log("SPELL_CAST_START", "GravityLapse", 35941)

	self:BossYell("Engage", L["engage_trigger"])
	self:Emote("Pyro", L["pyro_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:Death("Win", 19622)
	self:Death("AddDeaths", 21272, 21270, 21269, 21271, 21268, 21273, 21274)
end

function mod:OnEngage()
	self:Bar("phase", 32, L["thaladred"], "Spell_Shadow_Charm")
	self:MessageOld("phase", "green", nil, L["engage_message"], false)
	phase = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Conflag(args)
	self:TargetMessageOld(args.spellId, args.destName, "yellow")
	self:TargetBar(args.spellId, 10, args.destName)
end

function mod:Toy(args)
	if phase < 3 then
		self:TargetMessageOld(args.spellId, args.destName, "yellow")
		self:TargetBar(args.spellId, 60, args.destName)
	end
end

function mod:ToyRemoved(args)
	self:StopBar(args.spellName, args.destName)
end

do
	local scheduled = nil
	local function mcWarn(spellId)
		mod:TargetMessageOld("mc", MCd, "red", "alert", spellId)
		scheduled = nil
	end
	function mod:MC(args)
		MCd[#MCd + 1] = args.destName
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(mcWarn, 0.5, args.spellId)
		end
	end
end

function mod:FearCast(args)
	self:MessageOld(args.spellId, "orange", nil, L["fear_soon_message"])
end

do
	local last = 0
	function mod:Fear(args)
		local time = GetTime()
		if (time - last) > 5 then
			last = time
			self:MessageOld(args.spellId, "yellow", nil, L["fear_message"])
			self:Bar(args.spellId, 30, L["fear_bar"])
		end
	end
end

function mod:Phoenix()
	self:MessageOld("rebirth", "orange", nil, L["rebirth"])
	self:Bar("rebirth", 45, L["rebirth_bar"], "Spell_Fire_Burnout")
	self:DelayedMessage("rebirth", 40, "yellow", L["rebirth_warning"])
end

function mod:GravityLapse(args)
	self:MessageOld("phase", "red", nil, args.spellId)
	self:Bar("phase", 90, args.spellId)
end

function mod:AddDeaths(args)
	self:MessageOld("phase", "yellow", nil, L["dead_message"]:format(args.destName), false)
end

function mod:Pyro()
	self:Bar("pyro", 60, L["pyro"], "Spell_Fire_Fireball02")
	self:MessageOld("pyro", "green", nil, L["pyro_message"])
	self:DelayedMessage("pyro", 55, "yellow", L["pyro_warning"])
end

function mod:CHAT_MSG_MONSTER_EMOTE(_, msg, _, _, _, player)
	if msg:find(L["gaze_trigger"]) then
		self:TargetBar("gaze", 9, player, L["gaze"], "Spell_Shadow_EvilEye")
		self:TargetMessageOld("gaze", player, "red", nil, L["gaze"], "Spell_Shadow_EvilEye")
		self:PrimaryIcon("gaze", player)
		self.gazePlayer = player
	end
end

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg == L["thaladred_inc_trigger"] then
		self:MessageOld("phase", "green", nil, L["thaladred"], false)
	elseif msg == L["sanguinar_inc_trigger"] then
		self:MessageOld("phase", "green", nil, L["sanguinar"], false)
		self:Bar("phase", 13, L["sanguinar"], "Spell_Shadow_Charm")
		self:PrimaryIcon("gaze")
		if self.gazePlayer then
			self:StopBar(L["gaze"], self.gazePlayer)
			self.gazePlayer = nil
		end
	elseif msg == L["capernian_inc_trigger"] then
		self:MessageOld("phase", "green", nil, L["capernian"], false)
		self:Bar("phase", 7, L["capernian"], "Spell_Shadow_Charm")
		self:OpenProximity("proximity", 10)
		self:StopBar(L["fear_bar"])
	elseif msg == L["telonicus_inc_trigger"] then
		self:MessageOld("phase", "green", nil, L["telonicus"], false)
		self:Bar("phase", 8, L["telonicus"], "Spell_Shadow_Charm")
		self:CloseProximity()
	elseif msg == L["weapons_inc_trigger"] then
		phase = 2
		self:MessageOld("phase", "green", nil, L["weapons_inc_message"], false)
		self:Bar("phase", 105, L["revive_bar"], "Spell_Holy_ReviveChampion")
		self:DelayedMessage("phase", 100, "yellow", L["revive_warning"])
	elseif msg == L["phase3_trigger"] then
		phase = 3
		self:MessageOld("phase", "green", nil, L["phase3_message"], false)
		self:Bar("phase", 180, L["phase4_bar"], "Spell_ChargePositive")
	elseif msg == L["phase4_trigger"] then
		phase = 4
		self:MessageOld("phase", "green", nil, L["phase4_message"], false)
		self:Bar("pyro", 60, L["pyro"], "Spell_Fire_Fireball02")
		self:DelayedMessage("pyro", 55, "yellow", L["pyro_warning"])
		self:StopBar(L["phase4_bar"])
	elseif msg == L["flying_trigger"] then
		phase = 5
		self:CancelDelayedMessage(L["pyro_warning"])
		self:StopBar(L["pyro"])
		self:MessageOld("phase", "yellow", nil, L["flying_message"], false)
		self:Bar("phase", 60, 35941) -- Gravity Lapse
	end
end

