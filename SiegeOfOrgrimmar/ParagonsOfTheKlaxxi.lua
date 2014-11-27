
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Paragons of the Klaxxi", 953, 853)
if not mod then return end
mod:RegisterEnableMob(
	71161, 71157, 71156, 71155, -- Kil'ruk the Wind-Reaver, Xaril the Poisoned Mind, Kaz'tik the Manipulator, Korven the Prime
	71160, 71154, 71152, 71158, 71153 -- Iyyokuk the Lucid, Ka'roz the Locust, Skeer the Bloodseeker, Rik'kal the Dissector, Hisek the Swarmkeeper
)
mod.engageId = 1593

--------------------------------------------------------------------------------
-- Locals
--

local UnitDetailedThreatSituation, UnitExists, UnitIsUnit, UnitDebuff, UnitGUID = UnitDetailedThreatSituation, UnitExists, UnitIsUnit, UnitDebuff, UnitGUID

local function getBossByMobId(mobId)
	for i=1, 5 do
		if mod:MobId(UnitGUID("boss"..i)) == mobId then
			return "boss"..i
		end
	end
end
local blueToxin, redToxin, yellowToxin = ("|cFF0033FF%s|r"):format(mod:SpellName(142532)), ("|cFFFF0000%s|r"):format(mod:SpellName(142533)),("|cFFFFFF00%s|r"):format(mod:SpellName(142534))
local results = {
	mantid = {}, sword = {}, staff = {}, ring = {}, amber = {},
	red = {}, purple = {}, blue = {}, green = {}, yellow = {},
	[1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {},
}
local raidParsed = nil
local parasiteCounter = 0
local mutateCastCounter = 1
local youAte = nil
local parasites = {}
local calculateCounter = 1
local aimCounter = 1
local injectionBar, injectionTarget
-- marking
local markableMobs = {}
local marksUsed = {}
local markTimer = nil
local catalystProximityHandler = nil
local dissectorRikkalDead = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.catalyst_match = "Catalyst: |c%sMATCHES YOU|r" -- might not be best for colorblind?
	L.you_ate = "You ate a Parasite (%d left)"
	L.other_ate = "%s ate a %sParasite (%d left)"
	L.parasites_up = "%d |4Parasite:Parasites; up"
	L.dance = "%s, Dance!"
	L.prey_message = "Use Prey on parasite"
	L.injection_over_soon = "Injection over soon (%s)!"

	-- for getting all those calculate emotes:
	-- cat Transcriptor.lua | sed "s/\t//g" | grep -E "(CHAT_MSG_RAID_BOSS_EMOTE].*Iyyokuk)" | sed "s/.*EMOTE//" | sed "s/#/\"/" | sed "s/#.*/\"/" | sort | uniq
	L.one = "Iyyokuk selects: One!"
	L.two = "Iyyokuk selects: Two!"
	L.three = "Iyyokuk selects: Three!"
	L.four = "Iyyokuk selects: Four!"
	L.five = "Iyyokuk selects: Five!"
	--------------------------------

	-- XXX these marks are not enough
	L.custom_off_edge_marks = "Edge marks"
	L.custom_off_edge_marks_desc = "Mark the players who will be edges based on the calculations {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
	L.edge_message = "You are an edge!"

	L.custom_off_parasite_marks = "Parasite marker"
	L.custom_off_parasite_marks_desc = "Mark the parasites for crowd control and Prey assignments with {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"

	L.injection_tank = "Injection cast"
	L.injection_tank_desc = "Timer bar for when Injection is cast for his current tank."
	L.injection_tank_icon = 143339
end
L = mod:GetLocale()

local calculations = {
	["shape"] = {
		["ABILITY_IYYOKUK_BOMB_white"] = "bomb",
		["ABILITY_IYYOKUK_SWORD_white"] = "sword",
		["ABILITY_IYYOKUK_DRUM_white"] = "drum",
		["ABILITY_IYYOKUK_MANTID_white"] = "mantid",
		["ABILITY_IYYOKUK_STAFF_white"] = "staff"
	},
	["color"] = {
		["FFFFFF00"] = "yellow",
		["FFFF0000"] = "red",
		["FF0000FF"] = "blue",
		["FFFF00FF"] = "purple",
		["FF00FF00"] = "green"
	},
	["number"] = {
		[L.one] = 1,
		[L.two] = 2,
		[L.three] = 3,
		[L.four] = 4,
		[L.five] = 5
	}
}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{142931, "TANK"}, {143939, "TANK_HEALER"}, {-8008, "FLASH", "SAY"}, 148677, --Kil'ruk the Wind-Reaver
		{-8034, "PROXIMITY"}, 142803, 143576, --Xaril the Poisoned Mind
		142671, --Kaz'tik the Manipulator
		142564, {143974, "TANK_HEALER"}, --Korven the Prime
		{-8055, "FLASH", "SAY"}, --Iyyokuk the Lucid
		"custom_off_edge_marks",
		{143701, "FLASH", "SAY"}, {143759, "FLASH"}, {143735, "FLASH"}, {148650, "FLASH"}, --Ka'roz the Locust
		143280, --Skeer the Bloodseeker
		143339, {"injection_tank", "TANK"}, {-8065, "FLASH"}, {148589, "FLASH"}, 143337, --Rik'kal the Dissector
		"custom_off_parasite_marks",
		{-8073, "ICON", "FLASH"}, {143243, "FLASH"}, --Hisek the Swarmkeeper

		-8003, "berserk", "bosskill",
	}, {
		[142931] = -8004, --Kil'ruk the Wind-Reaver
		[-8034] = -8009, --Xaril the Poisoned Mind
		[142671] = -8010, --Kaz'tik the Manipulator
		[142564] = -8011, --Korven the Prime
		[-8055] = -8012, --Iyyokuk the Lucid
		["custom_off_edge_marks"] = L.custom_off_edge_marks,
		[143701] = -8013, --Ka'roz the Locust
		[143280] = -8014, --Skeer the Bloodseeker
		[143339] = -8015, --Rik'kal the Dissector
		["custom_off_parasite_marks"] = L.custom_off_parasite_marks,
		[-8073] = -8016, --Hisek the Swarmkeeper
		[-8003] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_REMOVED", "ReadyToFight", 143542)

	--Kil'ruk the Wind-Reaver
	self:Log("SPELL_CAST_START", "Reave", 148677)
	self:Log("SPELL_CAST_SUCCESS", "DeathFromAbove", 142232) -- this is not so reliable but still good to have it as a backup to our timers
	self:Log("SPELL_AURA_APPLIED_DOSE", "ExposedVeins", 142931)
	self:Log("SPELL_CAST_SUCCESS", "Gouge", 143939)
	--Xaril the Poisoned Mind
	self:Log("SPELL_CAST_START", "Catalysts", 142725, 142726, 142727, 142729, 142730, 142728) -- blue red yellow purple green orange
	self:Log("SPELL_CAST_SUCCESS", "CatalystsSuccess", 142725, 142726, 142727, 142729, 142730, 142728) -- blue red yellow purple green orange
	self:Log("SPELL_CAST_SUCCESS", "ToxicInjection", 142528)
	self:Log("SPELL_AURA_REMOVED", "ToxicInjectionsRemoved", 142532, 142533, 142534) -- blue red yellow
	self:Log("SPELL_AURA_APPLIED", "ToxicInjectionsApplied", 142532, 142533, 142534) -- blue red yellow
	self:Log("SPELL_PERIODIC_DAMAGE", "ExplosiveRing", 142803)
	self:Log("SPELL_PERIODIC_DAMAGE", "CannedHeat", 143576)
	--Kaz'tik the Manipulator
	self:Log("SPELL_AURA_APPLIED", "Mesmerize", 142671)
	--Korven the Prime
	self:Log("SPELL_CAST_SUCCESS", "EncaseInEmber", 142564)
	self:Log("SPELL_CAST_START", "ShieldBash", 143974)
	--Iyyokuk the Lucid
	local emoteTriggers = {}
	for _, t in next, calculations do
		for partial in next, t do
			emoteTriggers[#emoteTriggers+1] = partial
		end
	end
	self:Emote("CalculateEmotes", unpack(emoteTriggers))
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:Log("SPELL_AURA_REMOVED", "CalculationRemoved", 143605,143606,143607,143608,143609,143610,143611,143612,143613,143614,143615,143616,143617,143618,143619,143620,143621,143622,143623,143624,143627,143628,143629,143630,143631)
	--Ka'roz the Locust
	self:Log("SPELL_CAST_START", "StoreKineticEnergy", 143709)
	self:Log("SPELL_AURA_APPLIED", "HurlAmber", 143759)
	self:Log("SPELL_CAST_SUCCESS", "CausticAmber", 143735) -- this is half a sec faster than _DAMAGE
	self:Log("SPELL_PERIODIC_DAMAGE", "CausticAmber", 143735)
	--Skeer the Bloodseeker
	self:Log("SPELL_CAST_START", "Bloodletting", 143280)
	--Rik'kal the Dissector
	self:Log("SPELL_CAST_SUCCESS" , "Prey", 144286)
	self:Log("SPELL_CAST_START", "InjectionCast", 143339)
	self:Log("SPELL_AURA_APPLIED", "Injection", 143339)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Injection", 143339)
	self:Log("SPELL_AURA_REMOVED", "InjectionRemoved", 143339)
	self:Log("SPELL_AURA_APPLIED", "ParasiteFixate", 143358)
	self:Log("SPELL_AURA_REMOVED", "FaultyMutationRemoved", 148589)
	self:Log("SPELL_AURA_APPLIED", "FaultyMutationApplied", 148589)
	self:Log("SPELL_AURA_APPLIED", "Mutate", 143337)
	--Hisek the Swarmkeeper
	self:Log("SPELL_AURA_APPLIED", "Aim", 142948)
	self:Log("SPELL_AURA_REMOVED", "AimRemoved", 142948)
	self:Log("SPELL_CAST_START", "RapidFire", 143243)

	self:Death("ParasiteDeaths", 71578)
	self:Death("ParagonDeaths", 71161, 71157, 71156, 71155, 71160, 71154, 71152, 71158, 71153)
end

function mod:OnEngage()
	self:Berserk(720)
	catalystProximityHandler = nil
	results = {
		mantid = {}, sword = {}, staff = {}, drum = {}, bomb = {},
		red = {}, purple = {}, blue = {}, green = {}, yellow = {},
		[1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {},
	}
	raidParsed = nil
	mutateCastCounter = 1
	youAte = nil
	parasiteCounter = 0
	wipe(parasites)
	calculateCounter = 1
	aimCounter = 1
	dissectorRikkalDead = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--Hisek the Swarmkeeper
function mod:RapidFire(args)
	self:Flash(args.spellId)
	self:Message(args.spellId, "Urgent", "Long", L.dance:format(args.spellName))
	self:CDBar(args.spellId, 47)
end

function mod:Aim(args)
	self:SecondaryIcon(-8073, args.destName)
	self:TargetMessage(-8073, args.destName, "Important", "Warning", CL.count:format(args.spellName, aimCounter), args.spellId, true)
	self:TargetBar(-8073, 5, args.destName)
	if not self:Tank() then
		self:Flash(-8073)
	end

	self:StopBar(CL.count:format(args.spellName, aimCounter))
	aimCounter = aimCounter + 1
	self:CDBar(-8073, 42, CL.count:format(args.spellName, aimCounter))
end

function mod:AimRemoved(args)
	self:StopBar(-8073, args.destName)
	self:SecondaryIcon(-8073, nil)
end

--Rik'kal the Dissector
do
	local parasiteEater = mod:NewTargetList()
	function mod:Prey(args)
		if not parasites[args.destGUID] then
			parasiteCounter = parasiteCounter - 1
			parasites[args.destGUID] = true
			if self:Me(args.sourceGUID) then
				self:Message(143339, "Positive", "Info", L.you_ate:format(parasiteCounter))
				youAte = true
			else
				parasiteEater[1] = args.sourceName
				local raidIcon = CombatLog_String_GetIcon(args.destRaidFlags) -- Raid icon string
				self:Message(143339, "Attention", nil, L.other_ate:format(parasiteEater[1], raidIcon, parasiteCounter), 99315) -- spell called parasite, worm look like icon
				wipe(parasiteEater)
			end
		end
		if self.db.profile.custom_off_parasite_marks then
			self:FreeMarkByGUID(args.destGUID)
		end
	end
end

do
	local prev = 0
	function mod:Mutate(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t																										   -- injection
			self:Message(args.spellId, "Attention", (self:Healer() or (self:Tank() and UnitDebuff("player", self:SpellName(143339)))) and "Alert", CL.count:format(self:SpellName(-8068), mutateCastCounter))
			mutateCastCounter = mutateCastCounter + 1
			-- this text has "Amber Scorpion" in it's name, so it is more obvious
			self:Bar(args.spellId, 32, CL.count:format(args.spellName, mutateCastCounter))
		end
	end
end

do
	local faultyMutationTimer
	local function warnFaultyMutation(spellId)
		if youAte then
			mod:CancelTimer(faultyMutationTimer)
			faultyMutationTimer = nil
			return
		end
		mod:Message(spellId, "Important", "Warning", L.prey_message)
	end
	function mod:FaultyMutationRemoved(args)
		if not self:Me(args.destGUID) then return end
		self:StopBar(args.spellId)
		self:CancelTimer(faultyMutationTimer)
		faultyMutationTimer = nil
	end
	local scheduled, mutated = nil, mod:NewTargetList()
	local function announceMutationTargets(spellId)
		mod:TargetMessage(spellId, mutated, "Important", "Warning")
		scheduled = nil
	end
	function mod:FaultyMutationApplied(args)
		mutated[#mutated+1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(announceMutationTargets, 0.2, args.spellId)
		end
		if self:Me(args.destGUID) then
			youAte = nil
			self:Bar(args.spellId, 18)
			if not faultyMutationTimer then
				faultyMutationTimer = self:ScheduleRepeatingTimer(warnFaultyMutation, 2, args.spellId)
			end
		end
	end
end

do
	function mod:FreeMarkByGUID(guid)
		for mark = 1, 7 do
			if marksUsed[mark] and marksUsed[mark] == guid then
				marksUsed[mark] = nil
				markableMobs[guid] = nil
			end
		end
	end
	local function setMark(unit, guid)
		for mark = 1, 7 do
			if not marksUsed[mark] then
				SetRaidTarget(unit, mark)
				markableMobs[guid] = "marked"
				marksUsed[mark] = guid
				return
			end
		end
	end

	local function markMobs()
		local continue
		for guid in next, markableMobs do
			if markableMobs[guid] == true then
				local unit = mod:GetUnitIdByGUID(guid)
				if unit then
					setMark(unit, guid)
				else
					continue = true
				end
			end
		end
		if not continue or not mod.db.profile.custom_off_parasite_marks then
			mod:CancelTimer(markTimer)
			markTimer = nil
		end
	end
	function mod:InjectionRemoved(args)
		if not dissectorRikkalDead then -- no more parasites spawn when boss is dead
			parasiteCounter = parasiteCounter + 5
			self:Message(143339, "Attention", nil, L.parasites_up:format(parasiteCounter), 99315) -- spell called parasite, worm look like icon
		end
		self:CancelDelayedMessage(L.injection_over_soon:format(args.destName))
		if self.db.profile.custom_off_parasite_marks and not markTimer then
			markTimer = self:ScheduleRepeatingTimer(markMobs, 0.2)
		end
	end
	function mod:UPDATE_MOUSEOVER_UNIT()
		local guid = UnitGUID("mouseover")
		if guid and markableMobs[guid] == true then
			setMark("mouseover", guid)
		end
	end
	function mod:ParasiteFixate(args)
		if self:Me(args.destGUID) then
			self:Flash(-8065)
			self:Message(-8065, "Personal", "Info", CL.you:format(self:SpellName(-8065)))
		end
		if self.db.profile.custom_off_parasite_marks then
			if not markableMobs[args.sourceGUID] then
				markableMobs[args.sourceGUID] = true
				if not markTimer then
					markTimer = self:ScheduleRepeatingTimer(markMobs, 0.2)
				end
			end
		end
	end
	function mod:Injection(args)
		local amount = args.amount or 1
		if self:Me(args.destGUID) and amount == 1 then
			self:Message(args.spellId, "Urgent", "Warning", CL.you:format(args.spellName))
		end
		injectionBar, injectionTarget = CL.count:format(args.spellName, amount), args.destName
		self:StopBar(CL.count:format(args.spellName, amount-1), args.destName)
		self:TargetBar(args.spellId, 12, args.destName, injectionBar)
		self:DelayedMessage(args.spellId, 10, "Urgent", L.injection_over_soon:format(args.destName), args.spellId)
	end
end

function mod:InjectionCast(args)
	local boss = self:GetUnitIdByGUID(args.sourceGUID)
	if UnitDetailedThreatSituation("player", boss) then
		self:Bar("injection_tank", 9.6, args.spellId)
	end
end

--Skeer the Bloodseeker
function mod:Bloodletting(args)
	self:Message(args.spellId, "Important", self:Damager() and "Warning")
	self:CDBar(args.spellId, 37)
end

--Ka'roz the Locust
do
	local prev = 0
	function mod:CausticAmber(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then
			prev = t
			self:Flash(args.spellId)
			self:Message(args.spellId, "Personal", "Info", CL.underyou:format(args.spellName))
		end
	end
end

function mod:HurlAmber(args)
	self:Flash(args.spellId)
	self:Message(args.spellId, "Attention")
	self:CDBar(args.spellId, 60)
end

do
	local whirlingTimer, lastWhirlTarget = nil, ""
	local function stopScanning()
		mod:CancelTimer(whirlingTimer)
		whirlingTimer = nil
	end
	local function warnWhirlingTarget()
		local boss = getBossByMobId(71154)
		if not boss then return end
		local target = boss.."target"
		if not UnitExists(target) then return end
		if not UnitDetailedThreatSituation(target, boss) and lastWhirlTarget ~= mod:UnitName(target) then
			lastWhirlTarget = mod:UnitName(target)
			if UnitIsUnit("player", target) then
				mod:Message(143701, "Personal", "Info", CL.you:format(mod:SpellName(143701)))
				mod:Flash(143701)
				mod:Say(143701)
			else
				if mod:Range(target) < 10 then
					mod:RangeMessage(143701)
				end
			end
		end
	end
	function mod:StoreKineticEnergy(args)
		self:CDBar(143701, 63)
		self:Message(143701, "Urgent", nil, CL.incoming:format(mod:SpellName(143701)))
		lastWhirlTarget = ""
		if not whirlingTimer then
			whirlingTimer = self:ScheduleRepeatingTimer(warnWhirlingTarget, 0.1)
			self:ScheduleTimer(stopScanning, 20)
		end
	end
end

--Iyyokuk the Lucid
function mod:CalculationRemoved(args)
	if not results.shape and not results.color and not results.number then return end -- No Fiery Edge yet, so the table is not populated
	for k, v in pairs(results) do
		if type(v) == "table" then
			v[args.destName] = nil
		end
	end
end

do
	local prev = 0
	function mod:CalculateEmotes(msg)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			results.shape, results.color, results.number = nil, nil, nil -- reset
		end

		for type, t in pairs(calculations) do
			for partial, v in pairs(t) do
				if msg:find(partial) then
					results[type] = v
					return
				end
			end
		end
	end
end

local colors = { 				"red", 				"purple", 				"blue",				 "green", 				"yellow"}

local sword  = {mod:SpellName(143605), mod:SpellName(143606), mod:SpellName(143607), mod:SpellName(143608), mod:SpellName(143609)}
local drum   = {mod:SpellName(143610), mod:SpellName(143611), mod:SpellName(143612), mod:SpellName(143613), mod:SpellName(143614)}
local bomb   = {mod:SpellName(143615), mod:SpellName(143616), mod:SpellName(143617), mod:SpellName(143618), mod:SpellName(143619)}
local mantid = {mod:SpellName(143620), mod:SpellName(143621), mod:SpellName(143622), mod:SpellName(143623), mod:SpellName(143624)}
local staff  = {mod:SpellName(143627), mod:SpellName(143628), mod:SpellName(143629), mod:SpellName(143630), mod:SpellName(143631)}

local function parseDebuff(player)
	local _, count
	for i=1, 5 do
		_, _, _, count = UnitDebuff(player, sword[i])
		if count then
			return "sword", colors[i], (count == 0) and 1 or count
		end

		_, _, _, count = UnitDebuff(player, drum[i])
		if count then
			return "drum", colors[i], (count == 0) and 1 or count
		end

		_, _, _, count = UnitDebuff(player, bomb[i])
		if count then
			return "bomb", colors[i], (count == 0) and 1 or count
		end

		_, _, _, count = UnitDebuff(player, mantid[i])
		if count then
			return "mantid", colors[i], (count == 0) and 1 or count
		end

		_, _, _, count = UnitDebuff(player, staff[i])
		if count then
			return "staff", colors[i], (count == 0) and 1 or count
		end
	end
	return false
end

local function iyyokukSelected()
	local shape, color, number = parseDebuff("player")
	if shape and (shape == results.shape or color == results.color or number == results.number) then
		mod:Flash(-8055)
		mod:Message(-8055, "Personal", "Info", L.edge_message)
		mod:Bar(-8055, 9, mod:SpellName(142809), 142809) -- Fiery Edge
		mod:Say(-8055, mod:SpellName(142809))
	end

	if mod.db.profile.custom_off_edge_marks then
		if not raidParsed then
			for unit in mod:IterateGroup() do
				shape, color, number = parseDebuff(unit)
				if shape then
					local name = mod:UnitName(unit)
					results[shape][name] = true
					results[color][name] = true
					results[number][name] = true
				end
			end
			raidParsed = true
		end

		local count = 1
		for unit in mod:IterateGroup() do
			local name = mod:UnitName(unit)
			if (results.shape and results[results.shape][name]) or (results.color and results[results.color][name]) or (results.number and results[results.number][name]) then
				SetRaidTarget(unit, count)
				count = count + 1
				if count > 8 then break end
			end
		end
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(_, _, sender)
	-- Iyyokuk only have one MONSTER_EMOTE so this should be a safe method rather than having to translate the msg
	if sender == self:SpellName(-8012) then -- hopefully no weird naming missmatch in different localization like for "Xaril the Poisoned Mind" vs "Xaril the Poisoned-Mind"
		self:Message(-8055, "Attention", nil, CL.count:format(self:SpellName(142514), calculateCounter), 142514) -- 142514 = "Calculate"
		calculateCounter = calculateCounter + 1
		self:CDBar(-8055, 35, CL.count:format(self:SpellName(142514), calculateCounter), 142514) -- 142514 = "Calculate"
		self:ScheduleTimer(iyyokukSelected, 0.2)
	end
end

--Korven the Prime
do
	local function printTarget(self, name)
		self:TargetMessage(143974, name, "Urgent", "Alarm", nil, nil, true)
	end
	function mod:ShieldBash(args)
		self:Bar(args.spellId, 17)
		self:GetBossTarget(printTarget, 0, args.sourceGUID)
	end
end

function mod:EncaseInEmber(args)
	if UnitDebuff("player", self:SpellName(148650)) then
		self:Flash(148650) -- Strong Legs
	end
	self:TargetMessage(args.spellId, args.destName, "Important", self:Damager() and "Warning")
	self:CDBar(args.spellId, self:Mythic() and 30 or 25)
end

--Kaz'tik the Manipulator
function mod:Mesmerize(args)
	self:TargetMessage(args.spellId, args.destName, "Important", self:Damager() and "Warning", nil, nil, true)
	self:CDBar(args.spellId, 18) -- 18-40 probably should figure out what delays it or where does it restart
end

--Xaril the Poisoned Mind
do
	local prev = 0
	function mod:CannedHeat(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL.underyou:format(args.spellName))
		end
	end
end

do
	local prev = 0
	function mod:ExplosiveRing(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL.underyou:format(args.spellName))
		end
	end
end

do
	local redPlayers = {}
	local matches = {
		[mod:SpellName(142532)] = {[142725] = "ff0000ff", [142729] = "ff9900FF", [142730] = "ff008000", proximityN = redPlayers, proximityH = redPlayers}, -- blue
		[mod:SpellName(142533)] = {[142726] = "ffff0000", [142729] = "ff9900FF", [142728] = "ffFF9900"}, -- red
		[mod:SpellName(142534)] = {[142727] = "ffFFFF00", [142730] = "ff008000", [142728] = "ffFF9900", proximityN = redPlayers} -- yellow
	}
	local function handleCatalystProximity()
		wipe(redPlayers)
		for unit in mod:IterateGroup() do
			if not UnitIsUnit("player", unit) and (UnitDebuff(unit, mod:SpellName(142533)) or (mod:Mythic() and UnitDebuff(unit, mod:SpellName(142534)))) then -- red or mythic and yellow
				redPlayers[#redPlayers+1] = mod:UnitName(unit)
			end
		end
		local myDebuff = UnitDebuff("player", mod:SpellName(142532)) or UnitDebuff("player", mod:SpellName(142533)) or UnitDebuff("player", mod:SpellName(142534)) -- blue, red, yellow
		if myDebuff then
			mod:OpenProximity(-8034, 10, matches[myDebuff][mod:Mythic() and "proximityH" or "proximityN"])
		end
		mod:Message(-8034, "Neutral", nil, CL.soon:format(mod:SpellName(-8034)))
	end
	function mod:Catalysts(args)
		self:CDBar(-8034, 25, -8036, -8034) -- Choose Catalyst
		local myDebuff = UnitDebuff("player", mod:SpellName(142532)) or UnitDebuff("player", mod:SpellName(142533)) or UnitDebuff("player", mod:SpellName(142534)) -- blue, red, yellow
		self:Message(-8034, "Neutral", "Alert", (myDebuff and matches[myDebuff][args.spellId]) and L.catalyst_match:format(matches[myDebuff][args.spellId]) or args.spellName, args.spellId)
		self:CancelTimer(catalystProximityHandler) -- stop our previous timer it should have happened by now, but first one is tricky, so be safe and just stop it, 2nd one will be accurate
		catalystProximityHandler = self:ScheduleTimer(handleCatalystProximity, 20)
	end
	function mod:ToxicInjection(args)
		self:CDBar(-8034, 18, -8036, -8034) -- Choose Catalyst
		catalystProximityHandler = self:ScheduleTimer(handleCatalystProximity, 13) -- nothing should be scheduled at this point since this happens before ANYTHING so we don't overwrite any timer
	end
end

function mod:CatalystsSuccess(args)
	if self:Mythic() then -- on mythic they have flight time
		self:ScheduleTimer("CloseProximity", args.spellId == 142729 and 14 or 4, -8034) -- you want proximity open for purple for full duration of the debuff -- timers might need some adjusting
	else
		self:CloseProximity(-8034)
	end
end

function mod:ToxicInjectionsRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(-8034)
	end
end

function mod:ToxicInjectionsApplied(args)
	if self:Me(args.destGUID) then
		local message
		if args.spellId == 142532 then -- blue
			message = blueToxin
		elseif args.spellId == 142533 then -- red
			message = redToxin
		elseif args.spellId == 142534 then -- yellow
			message = yellowToxin
		end
		self:Message(-8034, "Personal", "Long", CL.you:format(message))
	end
end

--Kil'ruk the Wind-Reaver
do
	-- Death from Above target scanning
	local deathFromAboveTimer, deathFromAboveStartTimer = nil, nil
	local function checkTarget()
		local boss = getBossByMobId(71161)
		if not boss then return end
		local target = boss.."target"
		if not UnitExists(target) or mod:Tank(target) or UnitDetailedThreatSituation(target, boss) then return end

		local name = mod:UnitName(target)
		if UnitIsUnit("player", target) then
			mod:Flash(-8008)
			mod:Say(-8008)
			mod:TargetMessage(-8008, name, "Urgent", "Alarm")
		elseif mod:Range(target) < 5 then
			mod:RangeMessage(-8008)
			mod:Flash(-8008)
		else
			mod:TargetMessage(-8008, name, "Urgent")
		end
		mod:StopDeathFromAboveScan()
	end

	function mod:StartDeathFromAboveScan()
		if not deathFromAboveTimer then
			deathFromAboveTimer = self:ScheduleRepeatingTimer(checkTarget, 0.2)
		end
	end
	function mod:StopDeathFromAboveScan()
		self:CancelTimer(deathFromAboveStartTimer)
		self:CancelTimer(deathFromAboveTimer)
		deathFromAboveTimer = nil
	end

	function mod:DeathFromAbove(args)
		if deathFromAboveTimer then -- didn't find a target
			self:Message(-8008, "Urgent")
		end
		self:StopDeathFromAboveScan()
		self:CDBar(-8008, 22)
		deathFromAboveStartTimer = self:ScheduleTimer("StartDeathFromAboveScan", 17)
	end
	
	function mod:Reave(args)
		-- stop scanning for Death from Above during Reave
		if deathFromAboveTimer or deathFromAboveStartTimer then
			self:StopDeathFromAboveScan()
			deathFromAboveStartTimer = self:ScheduleTimer("StartDeathFromAboveScan", 13)
		end
		self:Message(args.spellId, "Urgent", "Long", CL.incoming:format(args.spellName))
		self:CDBar(args.spellId, 33) -- 33-49
	end
end

function mod:Gouge(args)
	-- timer varies way too much, no point for a bar 22-62
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm", nil, nil, true)
end

function mod:ExposedVeins(args)
	if args.amount > 5 and args.amount % 3 == 0 then -- XXX this probably needs adjustment
		self:StackMessage(args.spellId, args.destName, args.amount, "Attention")
	end
end

-- General
function mod:ReadyToFight(args)
	local mobId = self:MobId(args.destGUID)
	if mobId ~= 71152 and mobId ~= 71158 and mobId ~= 71153 then -- don't spam at the start, although engage to jump down varies
		self:Message(-8003, "Neutral", false, args.destName, false)
	end
	if mobId == 71161 then -- Kil'ruk the Wind-Reaver
		self:CDBar(148677, 42) -- Reave
		self:ScheduleTimer("StartDeathFromAboveScan", 17) -- 22 is timer but lets start to scan 5 sec early
	elseif mobId == 71155 then -- Korven the Prime
		self:CDBar(143974, 20) -- Shield Bash
	elseif mobId == 71153 then -- Hisek the Swarmkeeper
		self:CDBar(-8073, 38, CL.count:format(self:SpellName(-8073), aimCounter)) -- Aim
		if self:Mythic() then
			self:CDBar(143243, 49) -- Rapid Fire
		end
	elseif mobId == 71157 then -- Xaril the Poisoned Mind
		self:Bar(-8034, 21, -8036, -8034) -- Choose Catalyst
	elseif mobId == 71154 then -- Ka'roz the Locust
		self:Bar(143701, 11) -- Whirling
		self:Bar(143759, 35) -- Hurl Amber
	elseif mobId == 71152 then -- Skeer the Bloodseeker
		self:Bar(143280, 6) -- Bloodletting
	elseif mobId == 71158 then -- Rik'kal the Dissector
		self:CDBar(143337, 23) -- Mutate
		if self:Tank() then
			self:Bar("injection_tank", 9, 143339) -- Injection
		end
		parasiteCounter = 0
		if self.db.profile.custom_off_parasite_marks then
			wipe(markableMobs)
			wipe(marksUsed)
			markTimer = nil
			self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
		end
	end
end

function mod:ParasiteDeaths(args)
	if not parasites[args.destGUID] then
		parasites[args.destGUID] = true
		parasiteCounter = parasiteCounter - 1
		self:Message(143339, "Attention", nil, L.parasites_up:format(parasiteCounter), 99315) -- worm like icon
	end
	if self.db.profile.custom_off_parasite_marks then
		self:FreeMarkByGUID(args.destGUID)
	end
end

function mod:ParagonDeaths(args)
	if args.mobId == 71152 then --Skeer the Bloodseeker
		self:StopBar(143280) -- Bloodletting
	elseif args.mobId == 71154 then --Ka'roz the Locust
		self:StopBar(143759) -- HurlAmber
		self:StopBar(143701) -- StoreKineticEnergy
	elseif args.mobId == 71155 then --Korven the Prime
		self:StopBar(143974) -- ShieldBash
		self:StopBar(142564) -- EncaseInEmber
	elseif args.mobId == 71156 then --Kaz'tik the Manipulator
		self:StopBar(142671) -- Mesmerize
	elseif args.mobId == 71157 then --Xaril the Poisoned Mind
		self:StopBar(-8036) -- Choose Catalyst
		self:CloseProximity(-8034)
		self:CancelTimer(catalystProximityHandler)
		catalystProximityHandler = nil
	elseif args.mobId == 71161 then --Kil'ruk the Wind-Reaver
		self:StopBar(148677) -- Reave
		self:StopBar(-8008) -- Death from Above
		self:StopDeathFromAboveScan()
	elseif args.mobId == 71153 then --Hisek the Swarmkeeper
		self:StopBar(-8073) --Aim
		self:StopBar(143243) --Rapid Fire
	elseif args.mobId == 71158 then --Rik'kal the Dissector
		dissectorRikkalDead = true
		self:StopBar(CL.count:format(self:SpellName(143337), mutateCastCounter)) -- Mutate
		if injectionTarget then
			self:CancelDelayedMessage(L.injection_over_soon:format(injectionTarget))
			self:StopBar(injectionBar, injectionTarget)
		end
		self:StopBar(143339) -- Injection
	elseif args.mobId == 71160 then -- Iyyokuk the Lucid
		self:StopBar(CL.count:format(self:SpellName(142514), calculateCounter))
	end
end

