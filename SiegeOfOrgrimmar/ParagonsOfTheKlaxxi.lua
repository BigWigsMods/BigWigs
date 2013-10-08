--[[
TODO:
	recheck if "Jump to Center" SUCCEEDED so it is always there on encounter engage
	stopbars on boss deaths
	sonic resonance maybe could use some advanced proximity warning

	could maybe warn one hurl amber target?
	heroic toxic injection proximity submarine sound and not closing
	win sound
]]--

-- some upvalues so I don't fail at finding unnecessary globals and whatnot
local wipe = wipe
local GetTime = GetTime
local UnitGUID = UnitGUID
local pairs = pairs
local unpack = unpack
local SetRaidTarget = SetRaidTarget
local next = next
local EJ_GetSectionInfo = EJ_GetSectionInfo
local UnitIsUnit = UnitIsUnit
local select = select
local UnitExists = UnitExists
local type = type
local GetNumGroupMembers = GetNumGroupMembers
local GetRaidRosterInfo = GetRaidRosterInfo
local UnitDebuff = UnitDebuff

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Paragons of the Klaxxi", 953, 853)
if not mod then return end
mod:RegisterEnableMob(71161, 71157, 71156, 71155, -- Kil'ruk the Wind-Reaver, Xaril the Poisoned Mind, Kaz'tik the Manipulator, Korven the Prime
71160, 71154, 71152, 71158, 71153 ) -- Iyyokuk the Lucid, Ka'roz the Locust, Skeer the Bloodseeker, Rik'kal the Dissector, Hisek the Swarmkeeper
--------------------------------------------------------------------------------
-- Locals
--

local deathCounter = 0
local function getBossByMobId(mobId)
	for i=1, 5 do
		if mod:MobId(UnitGUID("boss"..i)) == mobId then
			return "boss"..i
		end
	end
	return
end
local bossesSeen = {}
local blueToxin, redToxin, yellowToxin = ("|cFF0033FF%s|r"):format(mod:SpellName(142532)), ("|cFFFF0000%s|r"):format(mod:SpellName(142533)),("|cFFFFFF00%s|r"):format(mod:SpellName(142534))
local chooseCatalyst = EJ_GetSectionInfo(8036)
local results = {
	mantid = {}, sword = {}, staff = {}, ring = {}, amber = {},
	red = {}, purple = {}, blue = {}, green = {}, yellow = {},
	[1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {},
}
local raidParsed
local emoteTriggers = {}
local mutateCounter = 1
local redPlayers = {}
local parasiteCounter = 0
local mutateCastCounter = 1
local youAte = nil
-- marking
local markableMobs = {}
local marksUsed = {}
local markTimer = nil
local parasites = {}
local calculateCounter = 1
--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.catalyst_match = "Catalyst: |c%sMATCHES YOU|r" -- might not be best for colorblind?
	L.you_ate = "You ate a parasite!"
	L.dance = "Dance"
	L.prey_message = "Use Prey on parasite"
	-- for getting all those calculate emotes:
	-- cat Transcriptor.lua | sed "s/\t//g" | grep -E "(CHAT_MSG_RAID_BOSS_EMOTE].*Iyyokuk)" | sed "s/.*EMOTE//" | sed "s/#/\"/" | sed "s/#.*/\"/" | sort | uniq
	L.one = "Iyyokuk selects: One!"
	L.two = "Iyyokuk selects: Two!"
	L.three = "Iyyokuk selects: Three!"
	L.four = "Iyyokuk selects: Four!"
	L.five = "Iyyokuk selects: Five!"
	--------------------------------
	L.edge_message = "You're an edge"
	L.custom_off_edge_marks = "Edge marks"
	-- XXX these marks are not enough
	L.custom_off_edge_marks_desc = "Mark the players who will be edges based on the calculations {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
	L.injection_over_soon = "Injection over soon (%s)!"
	L.custom_off_parasite_marks = "Parasite marker"
	L.custom_off_parasite_marks_desc = "Mark the parasites for crowd control and Prey assignments with {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
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
		{142931, "TANK"}, {143939, "TANK_HEALER"}, {-8008, "FLASH", "SAY"}, --Kil'ruk the Wind-Reaver
		142929, {-8034, "PROXIMITY"}, 142803, 143576, --Xaril the Poisoned Mind
		142671, --Kaz'tik the Manipulator
		142564, {143974, "TANK_HEALER"}, --Korven the Prime
		{-8055, "FLASH"}, --Iyyokuk the Lucid
		"custom_off_edge_marks",
		{143701, "FLASH", "SAY"}, {143759, "FLASH"}, {143735, "FLASH"}, {148650, "FLASH"}, --Ka'roz the Locust
		{143275, "TANK"}, 143280, --Skeer the Bloodseeker
		{143279, "TANK"}, 143339, {-8065, "FLASH"}, {148589, "FLASH"}, 143337, --Rik'kal the Dissector
		"custom_off_parasite_marks",
		{-8073, "ICON", "FLASH"}, {143243, "FLASH"}, --Hisek the Swarmkeeper

		"berserk", "bosskill",
	}, {
		[142931] = -8004, --Kil'ruk the Wind-Reaver
		[142929] = -8009, --Xaril the Poisoned Mind
		[142671] = -8010, --Kaz'tik the Manipulator
		[142564] = -8011, --Korven the Prime
		[-8055] = -8012, --Iyyokuk the Lucid
		["custom_off_edge_marks"] = L.custom_off_edge_marks,
		[143701] = -8013, --Ka'roz the Locust
		[143275] = -8014, --Skeer the Bloodseeker
		[143279] = -8015, --Rik'kal the Dissector
		["custom_off_parasite_marks"] = L.custom_off_parasite_marks,
		[-8073] = -8016, --Hisek the Swarmkeeper
		["berserk"] = "general",
	}
end

function mod:OnBossEnable()
	for _, t in pairs(calculations) do
		for partial, v in pairs(t) do
			emoteTriggers[#emoteTriggers+1] = partial
		end
	end
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "MyEngage")

	--Kil'ruk the Wind-Reaver
	self:Log("SPELL_CAST_SUCCESS", "Impact", 142232) -- does not matter that there are events closer in time to the target change since we scan in a time interval before this
	self:Log("SPELL_AURA_APPLIED_DOSE", "ExposedVeins", 142931)
	self:Log("SPELL_CAST_SUCCESS", "Gouge", 143939)
	--Xaril the Poisoned Mind
	self:Log("SPELL_CAST_START", "Catalysts", 142725, 142726, 142727, 142729, 142730, 142728) -- blue red yellow purple green orange
	self:Log("SPELL_CAST_SUCCESS", "ToxicInjection", 142528)
	self:Log("SPELL_AURA_APPLIED", "ToxicInjectionsRemoved", 142532, 142533, 142534) -- blue red yellow
	self:Log("SPELL_AURA_APPLIED", "ToxicInjectionsApplied", 142532, 142533, 142534) -- blue red yellow
	self:Log("SPELL_AURA_APPLIED", "TenderizingStrike", 142929)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TenderizingStrike", 142929)
	self:Log("SPELL_PERIODIC_DAMAGE", "ExplosiveRing", 142803)
	self:Log("SPELL_PERIODIC_DAMAGE", "CannedHeat", 143576)

	--Kaz'tik the Manipulator
	self:Log("SPELL_AURA_APPLIED", "Mesmerize", 142671)
	--Korven the Prime
	self:Log("SPELL_CAST_SUCCESS", "EncaseInEmber", 142564)
	self:Log("SPELL_CAST_START", "ShieldBash", 143974)
	--Iyyokuk the Lucid
	self:Emote("CalculateEmotes", unpack(emoteTriggers))
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:Log("SPELL_AURA_REMOVED", "CalculationRemoved", 143605,143606,143607,143608,143609,143610,143611,143612,143613,143614,143615,143616,143617,143618,143619,143620,143621,143622,143623,143624,143627,143628,143629,143630,143631)
	--Ka'roz the Locust
	self:Log("SPELL_CAST_START", "StoreKineticEnergy", 143709)
	self:Log("SPELL_AURA_APPLIED", "HurlAmber", 143759)
	self:Log("SPELL_CAST_SUCCESS", "CausticAmber", 143735) -- this is half a sec faster than _DAMAGE
	self:Log("SPELL_PERIODIC_DAMAGE", "CausticAmber", 143735)
	--Skeer the Bloodseeker
	self:Log("SPELL_AURA_APPLIED_DOSE", "Hewn", 143275)
	self:Log("SPELL_CAST_START", "Bloodletting", 143280)
	--Rik'kal the Dissector
	self:Log("SPELL_CAST_SUCCESS" , "Prey", 144286)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GeneticAlteration", 143279)
	self:Log("SPELL_AURA_APPLIED", "Injection", 143339)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Injection", 143339)
	self:Log("SPELL_AURA_REMOVED", "InjectionRemoved", 143339)
	self:Log("SPELL_AURA_APPLIED", "ParasiteFixate", 143358)
	self:Log("SPELL_AURA_REMOVED", "FaultyMutationRemoved", 148589)
	self:Log("SPELL_AURA_APPLIED", "FaultyMutationApplied", 148589)
	self:Log("SPELL_AURA_APPLIED", "Mutate", 143337)
	--Hisek the Swarmkeeper
	self:Log("SPELL_AURA_APPLIED", "Aim", 142948)
	self:Log("SPELL_CAST_START", "RapidFire", 143243)

	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3", "boss4")
	self:Death("Deaths", 71161, 71157, 71156, 71155, 71160, 71154, 71152, 71158, 71153, 71578)
end

function mod:OnEngage()
	self:Berserk(720)
	wipe(redPlayers)
	deathCounter = 0
	wipe(bossesSeen)
	results = {
		mantid = {}, sword = {}, staff = {}, drum = {}, bomb = {},
		red = {}, purple = {}, blue = {}, green = {}, yellow = {},
		[1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {},
	}
	raidParsed = nil
	mutateCounter = 1
	mutateCastCounter = 1
	youAte = nil
	parasiteCounter = 0
	wipe(parasites)
	calculateCounter = 1
	self:StopWipeCheck()
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "StartWipeCheck")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "StopWipeCheck")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--Hisek the Swarmkeeper
function mod:RapidFire(args)
	self:Flash(args.spellId)
	self:Message(args.spellId, "Urgent", "Long", L["dance"])
	self:CDBar(args.spellId, 47, L["dance"])
end

function mod:Aim(args)
	self:CDBar(-8073, 42)
	self:SecondaryIcon(-8073, args.destName)
	self:TargetMessage(-8073, args.destName, "Important", "Warning", nil, nil, true)
	self:TargetBar(-8073, 5, args.destName)
	self:Flash(-8073) -- XXX Funkeh remove this if you think this is too much
end
--Rik'kal the Dissector
do
	local parasiteEater = mod:NewTargetList()
	function mod:Prey(args)
		if not parasites[args.destGUID] then
			parasiteCounter = parasiteCounter - 1
			parasites[args.destGUID] = true
			parasiteEater[1] = args.sourceName
			-- intentionally not :TargetMessage
			self:Message(143339, "Attention", nil, CL["other"]:format(CL["count"]:format(self:SpellName(8363), parasiteCounter), parasiteEater[1]), 99315) -- spell called parasite, worm look like icon
			parasiteEater[1] = nil
			if self:Me(args.sourceGUID) then
				self:Message(143339, "Positive", "Info", L["you_ate"])
				youAte = true
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
			self:Message(args.spellId, "Attention", (self:Healer() or (self:Tank() and UnitDebuff("player", self:SpellName(143339)))) and "Alert", CL["count"]:format(self:SpellName(-8068), mutateCastCounter))
			mutateCastCounter = mutateCastCounter + 1
			-- this text has "Amber Scorpion" in it's name, so it is more obvious
			self:Bar(args.spellId, 32, CL["count"]:format(args.spellName, mutateCastCounter))
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
		mod:Message(spellId, "Important", "Warning", L["prey_message"])
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
			scheduled = self:ScheduleTimer(announceMutationTargets, 0.1, args.spellId)
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
		if getBossByMobId(71158) then -- no more parasites spawn when boss is dead
			parasiteCounter = parasiteCounter + 8
			self:Message(143339, "Attention", nil, CL["count"]:format(self:SpellName(8363), parasiteCounter), 99315) -- spell called parasite, worm look like icon
		end
		self:CancelDelayedMessage(L["injection_over_soon"]:format(args.destName))
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
			self:Message(-8065, "Personal", "Info", CL["you"]:format(EJ_GetSectionInfo(8065)))
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
		self:StopBar(CL["count"]:format(args.spellName, amount-1), args.destName)
		self:TargetBar(args.spellId, 12, args.destName, CL["count"]:format(args.spellName, amount))
		self:DelayedMessage(args.spellId, 10, "Urgent", L["injection_over_soon"]:format(args.destName), args.spellId) -- might want to check what happens if player deis with debuff
	end
end

function mod:GeneticAlteration(args)
	if args.amount > 5 and args.amount%3 == 0 then -- XXX this probably needs adjustment
		self:StackMessage(args.spellId, args.destName, args.amount, "Attention")
	end
end
--Skeer the Bloodseeker
function mod:Bloodletting(args)
	self:Message(args.spellId, "Important", self:Damager() and "Warning")
	self:CDBar(args.spellId, 37)
end

function mod:Hewn(args)
	if args.amount > 5 and args.amount%3 == 0 then -- XXX this probably needs adjustment
		self:StackMessage(args.spellId, args.destName, args.amount, "Attention")
	end
end
--Ka'roz the Locust
do
	local prev = 0
	function mod:CausticAmber(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then
			prev = t
			self:Flash(args.spellId)
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
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
	local function warnWhilringTarget()
		local boss = getBossByMobId(71154)
		if not boss then return end
		local target = boss.."target"
		if not UnitExists(target) then return end
		if lastWhirlTarget and lastWhirlTarget ~= mod:UnitName(target) then
			lastWhirlTarget = mod:UnitName(target)
			if UnitIsUnit("player", target) then
				mod:Message(143701, "Personal", "Info", CL["you"]:format(mod:SpellName(143701)))
				mod:Flash(143701)
				mod:Say(143701)
				-- add range stuff
			else
				if mod:Range(target) < 10 then
					mod:RangeMessage(143701)
				end
			end
		end
	end
	function mod:StoreKineticEnergy(args)
		self:Message(143701, "Urgent")
		self:CDBar(143701, 63)
		lastWhirlTarget = ""
		if not whirlingTimer then
			whirlingTimer = self:ScheduleRepeatingTimer(warnWhilringTarget, 0.1)
			self:ScheduleTimer(stopScanning, 20)
		end
	end
end
--Iyyokuk the Lucid
function mod:CalculationRemoved(args)
	if not results.shape and not results.color and not results.number then return end -- No Fiery Edge yet, so the table is not populated
	for k, v in pairs(results) do
		if type(v) == "table" then
			v[args.destName] = nil -- we don't have to do name parsing magic for LFR ppl because GetRaidRosterInfo returs servered names too
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
	local count
	for i=1, 5 do
		count = select(4,UnitDebuff(player, sword[i]))
		if count then
			return "sword", colors[i], (count == 0) and 1 or count
		end

		count = select(4,UnitDebuff(player, drum[i]))
		if count then
			return "drum", colors[i], (count == 0) and 1 or count
		end

		count = select(4,UnitDebuff(player, bomb[i]))
		if count then
			return "bomb", colors[i], (count == 0) and 1 or count
		end

		count = select(4,UnitDebuff(player, mantid[i]))
		if count then
			return "mantid", colors[i], (count == 0) and 1 or count
		end

		count = select(4,UnitDebuff(player, staff[i]))
		if count then
			return "staff", colors[i], (count == 0) and 1 or count
		end
	end
	return false
end

local function isMatching(shape, color, number)
	if shape == results.shape or color == results.color or number == results.number then
		return true
	end
	return false
end

local function warnEdge()
	mod:Flash(-8055)
	mod:Message(-8055, "Personal", "Info", L["edge_message"])
	mod:Bar(-8055, 9, mod:SpellName(142809), 142809) -- Fiery Edge
end

local function iyyokukSelected()
	-- handle the player first
	local shape, color, number = parseDebuff("player")
	if shape then
		if isMatching(shape, color, number) then
			warnEdge()
		end
	end

	if mod.db.profile.custom_off_edge_marks then
		local name
		if not raidParsed then
			for i = 1, GetNumGroupMembers() do
				name = GetRaidRosterInfo(i)
				shape, color, number = parseDebuff(name)
				if shape then
					results[shape][name] = true
				end
				if color then
					results[color][name] = true
				end
				if number then
					results[number][name] = true
				end
			end
			raidParsed = true
		end

		local count = 1
		for i = 1, GetNumGroupMembers() do
			name = GetRaidRosterInfo(i)
			local match = nil
			if (results.shape and results[results.shape][name]) or (results.color and results[results.color][name]) or (results.number and results[results.number][name]) then
				match = true
			end

			if count < 9 and match then
				SetRaidTarget(name, count)
				count = count + 1
			end
		end
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(_, _, sender, _, _, target)
	-- Iyyokuk only have one MONSTER_EMOTE so this should be a safe method rather than having to translate the msg
	if sender == EJ_GetSectionInfo(8012) then -- hopefully no weird naming missmatch in different localization like for "Xaril the Poisoned Mind" vs "Xaril the Poisoned-Mind"
		local diff = self:Difficulty()
		self:Message(-8055, "Attention", nil, CL["count"]:format(self:SpellName(142514), calculateCounter), 142514)
		calculateCounter = calculateCounter + 1
		self:Bar(-8055, 35, CL["count"]:format(self:SpellName(142514), calculateCounter), 142514) -- Calculate
		if target == self:UnitName("player") then
			warnEdge()
		elseif diff == 5 or diff == 6 then -- Heroic
			results.shape, results.color, results.number = parseDebuff(target) -- we don't have to rely on emotes for heroic
			iyyokukSelected()
		else
			self:ScheduleTimer(iyyokukSelected, 0.2)
		end
	end
end

--Korven the Prime
function mod:ShieldBash(args)
	local target = getBossByMobId(71155)
	if not target then return end
	target = target .. "target"
	self:TargetMessage(args.spellId, self:UnitName(target), "Urgent", "Alarm", nil, nil, true)
	self:Bar(args.spellId, 17)
end

function mod:EncaseInEmber(args)
	if UnitDebuff("player", self:SpellName(148650)) then
		-- XXX for pulse, maybe should add a custom option description so people know to turn pulse on for this, or turn it on by default?
		self:Flash(148650) -- Strong Legs
	end
	self:TargetMessage(args.spellId, args.destName, "Important", self:Damager() and "Warning")
	self:CDBar(args.spellId, self:Heroic() and 30 or 25)
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
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
		end
	end
end

do
	local prev = 0
	function mod:ExplosiveRing(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
		end
	end
end

do
	local matches = {
		[mod:SpellName(142532)] = {[142725] = "ff0000ff", [142729] = "ff9900FF", [142730] = "ff008000"}, -- blue
		[mod:SpellName(142533)] = {[142726] = "ffff0000", [142729] = "ff9900FF", [142728] = "ffFF9900"}, -- red
		[mod:SpellName(142534)] = {[142727] = "ffFFFF00", [142730] = "ff008000", [142728] = "ffFF9900"} -- yellow
	}
	function mod:Catalysts(args)
		self:CDBar(-8034, 25, chooseCatalyst)
		local myDebuff = UnitDebuff("player", mod:SpellName(142532)) or UnitDebuff("player", mod:SpellName(142533)) or UnitDebuff("player", mod:SpellName(142534)) -- blue, red, yellow
		self:Message(-8034, "Neutral", "Alert", (myDebuff and matches[myDebuff][args.spellId]) and L.catalyst_match:format(matches[myDebuff][args.spellId]) or args.spellName, args.spellId)
	end
end

function mod:ToxicInjection(args)
	self:CDBar(-8034, 18, chooseCatalyst)
end

function mod:ToxicInjectionsRemoved(args)
	-- XXX keep an eye out if this conflicts with some other proximity
	if self:Me(args.destGUID) then
		self:CloseProximity(-8034)
	end
end

function mod:ToxicInjectionsApplied(args)
	if not self:Me(args.destGUID) then return end
	local name
	for i=1, GetNumGroupMembers() do
		name = GetRaidRosterInfo(i)
		if UnitDebuff(name, self:SpellName(142533)) and not UnitIsUnit("player", name) then
			redPlayers[#redPlayers+1] = name
		end
		if self:Heroic() and UnitDebuff(name, self:SpellName(142534)) and not UnitIsUnit("player", name) then -- add yellow too
			redPlayers[#redPlayers+1] = name
		end
	end
	local message
	if args.spellId == 142532 then -- blue
		message = blueToxin
		self:OpenProximity(-8034, 10, redPlayers)
	elseif args.spellId == 142533 then -- red
		message = redToxin
		self:OpenProximity(-8034, 10)
	elseif args.spellId == 142534 then -- yellow
		message = yellowToxin
		if self:Heroic() then
			self:OpenProximity(-8034, 10) -- cuz of orange
		else
			self:OpenProximity(-8034, 10, redPlayers)
		end
	end
	self:Message(-8034, "Personal", "Long", CL["you"]:format(message))
end

function mod:TenderizingStrike(args)
	local amount = args.amount or 1
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", nil, CL["count"]:format(args.spellName, amount))
	end
end
--Kil'ruk the Wind-Reaver
do
	-- Reave target scanning
	local UnitDetailedThreatSituation, UnitExists, UnitIsUnit = UnitDetailedThreatSituation, UnitExists, UnitIsUnit
	local reaveTimer, reaveStartTimer = nil, nil
	local initialTarget = nil
	local function checkReaveTarget()
		local boss = getBossByMobId(71161)
		if not boss then return end
		local target = boss.."target"
		if not UnitExists(target) or mod:Tank(target) or UnitDetailedThreatSituation(target, boss) then return end

		if initialTarget and UnitIsUnit(target, initialTarget) then return end

		local name = mod:UnitName(target)
		mod:TargetMessage(-8008, name, "Urgent", "Alarm")
		if UnitIsUnit("player", target) then
			mod:Flash(-8008)
			mod:Say(-8008)
		end
		mod:StopReaveScan()
	end

	function mod:StartReaveScan()
		if not reaveTimer then
			initialTarget = self:UnitName("boss1target")
			reaveTimer = self:ScheduleRepeatingTimer(checkReaveTarget, 0.2)
		end
	end
	function mod:StopReaveScan()
		self:CancelTimer(reaveStartTimer)
		self:CancelTimer(reaveTimer)
		reaveTimer = nil
	end

	function mod:Impact(args)
		if reaveTimer then -- didn't find a target
			self:Message(-8008, "Urgent")
		end
		self:StopReaveScan()
		self:CDBar(-8008, 22)
		reaveStartTimer = self:ScheduleTimer("StartReaveScan", 15)
	end
end

function mod:Gouge(args)
	-- timer varies way too much, no point for a bar 22-62
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm", nil, nil, true)
end

function mod:ExposedVeins(args)
	if args.amount > 5 and args.amount%3 == 0 then -- XXX this probably needs adjustment
		self:StackMessage(args.spellId, args.destName, args.amount, "Attention")
	end
end
-- General
function mod:MyEngage()
	-- have to do this because Jump to Center is not reliable for some of the bosses, noticably (Korven the Prime, Skeer the Bloodseeker, Hisek the Swarmpkeeper)
	for i=1, 5 do
		local guid = UnitGUID("boss"..i)
		if guid and not bossesSeen[guid] then
			bossesSeen[guid] = true
			local mobId = self:MobId(guid)
			if mobId == 71161 then --Kil'ruk the Wind-Reaver
				self:ScheduleTimer("StartReaveScan", 12) -- XXX timer he is assumed need to verify this once we encounter this boss being in the starter 3
			elseif mobId == 71155 then --Korven the Prime
				self:Bar(143974, 17)
			elseif mobId == 71152 then -- Skeer the Bloodseeker
				self:Bar(143280 ,10) -- Bloodletting
			elseif mobId == 71153 then --Hisek the Swarmkeeper
				self:Bar(-8073, 40) -- Aim
				if self:Heroic() then
					self:Bar(143243, 48) -- Rapid Fire
				end
			elseif mobId == 71157 then -- Xaril the Poisoned Mind
				self:Bar(-8034, 21, chooseCatalyst)
			end
		end
	end
	self:CheckBossStatus()
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unitId, spellName, _, _, spellId)
	if spellId == 143545 then -- Jump to center aka enter the fight, not so reliable for encounter engage aka boss 1-3
		local mobId = self:MobId(UnitGUID(unitId))
		if mobId == 71161 then --Kil'ruk the Wind-Reaver
			-- 19s is shortest between jump and impact seen so far 10PTR N
			self:ScheduleTimer("StartReaveScan", 12)
		elseif mobId == 71154 then -- Ka'roz the Locust
			self:Bar(143701, 11) -- Whirling
			self:Bar(143759, 43) -- Hurl Amber
		elseif mobId == 71152 then -- Skeer the Bloodseeker
			self:Bar(143280, 10) -- Bloodletting
		elseif mobId == 71158 then --Rik'kal the Dissector
			self:CDBar(143337, 34) -- Mutate
			parasiteCounter = 0
			if self.db.profile.custom_off_parasite_marks then
				wipe(markableMobs)
				wipe(marksUsed)
				markTimer = nil
				self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
			end
		end
	end
end

function mod:Deaths(args)
	if args.mobId == 71152 then --Skeer the Bloodseeker
		self:StopBar(143280) -- Bloodletting
		deathCounter = deathCounter + 1
	elseif args.mobId == 71154 then --Ka'roz the Locust
		self:StopBar(143759) -- HurlAmber
		self:StopBar(143701) -- StoreKineticEnergy
		deathCounter = deathCounter + 1
	elseif args.mobId == 71155 then --Korven the Prime
		self:StopBar(143974) -- ShieldBash
		self:StopBar(142564) -- EncaseInEmber
		deathCounter = deathCounter + 1
	elseif args.mobId == 71156 then --Kaz'tik the Manipulator
		self:StopBar(142671) -- Mesmerize
		deathCounter = deathCounter + 1
	elseif args.mobId == 71157 then --Xaril the Poisoned Mind
		self:StopBar(chooseCatalyst)
		deathCounter = deathCounter + 1
	elseif args.mobId == 71161 then --Kil'ruk the Wind-Reaver
		self:StopBar(-8008) --Impact
		deathCounter = deathCounter + 1
	elseif args.mobId == 71153 then --Hisek the Swarmkeeper
		self:StopBar(-8073) --Aim
		self:StopBar(L["dance"]) --Rapid Fire
		deathCounter = deathCounter + 1
	elseif args.mobId == 71158 then --Rik'kal the Dissector
		self:StopBar(CL["count"]:format((EJ_GetSectionInfo(8068)), mutateCounter)) --Mutate
		deathCounter = deathCounter + 1
	elseif args.mobId == 71160 then -- Iyyokuk the Lucid
		self:StopBar(CL["count"]:format(self:SpellName(142514), calculateCounter))
		deathCounter = deathCounter + 1
	elseif args.mobId == 71578 then -- Parasite -- XXX don't think this is even needed, but lets have it as a backup
		if not parasites[args.destGUID] then
			parasites[args.destGUID] = true
			parasiteCounter = parasiteCounter - 1
			self:Message(143339, "Attention", nil, CL["count"]:format(self:SpellName(8363), parasiteCounter), 99315) -- spell called parasite, worm look like icon
		end
		if self.db.profile.custom_off_parasite_marks then
			self:FreeMarkByGUID(args.destGUID)
		end
	end
	if deathCounter == 9 then
		self:Win()
	end
end
