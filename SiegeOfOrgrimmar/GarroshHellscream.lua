--[[
TODO:

]]--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Garrosh Hellscream", 953, 869)
if not mod then return end
mod:RegisterEnableMob(71865)

--------------------------------------------------------------------------------
-- Locals
--

local UnitHealth, UnitHealthMax, GetTime = UnitHealth, UnitHealthMax, GetTime
local annihilateCounter
local markableMobs = {}
local marksUsed = {}
local markTimer = nil
local mcCounter = 1
local farseerCounter = 1
local engineerCounter = 1
local desecrateCD = 41
local desecrateCounter = 1
local phase = 1
local function getBossByMobId(mobId)
	for i=1, 5 do
		if mod:MobId(UnitGUID("boss"..i)) == mobId then
			return "boss"..i
		end
	end
	return
end
local waveTimers = { 45, 45, 40 }
local waveTimer, waveCounter = nil, 1
local whirlingCounter = 1
local malicious = {}
local weaponTimer = nil
local maliciousSpreader
local clumpCheckAllowed
local mindControl = nil
local bombardmentCounter = 1
local bombardmentTimers = { 55, 40, 40, 25 } -- XXX need more data
--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.manifest_rage = "Manifest Rage"
	L.manifest_rage_desc = "When Garrosh reaches 100 energy he'll pre cast Manifest Rage for 2 seconds, then channel it. While it's channelled it summons big adds. Kite the Iron Star into Garrosh to stun and interrupt his cast."
	L.manifest_rage_icon = 147011

	L.phase_3_end_trigger = "You think you have WON?  You are BLIND.  I WILL FORCE YOUR EYES OPEN."

	L.clump_check = "Clump check"
	L.clump_check_desc = "Check every 3 seconds during bombardment for clumped up players, if a clump is found a Kor'kron Iron Star will spawn."
	L.clump_check_icon = 147126

	L.bombardment = "Bombardment"
	L.bombardment_desc = "Bombarding Stormwind and leaving fires on the ground. Kor'kron Iron Star can only spawn during bombardment."
	L.bombardment_icon = 147120

	L.spread = "Spread!"
	L.intermission = "Intermission"
	L.mind_control = "Mind Control"

	L.ironstar_impact = mod:SpellName(144653)
	L.ironstar_impact_desc = "A timer bar for when the Iron Star will impact the wall at the other side."
	L.ironstar_impact_icon = 144653
	L.ironstar_rolling = "Iron Star Rolling!"

	L.chain_heal = mod:SpellName(144583)
	L.chain_heal_desc = "Heals a friendly target for 40% of their max health, chaining to nearby friendly targets."
	L.chain_heal_message = "Your focus is casting Chain Heal!"
	L.chain_heal_bar = "Focus: Chain Heal"

	L.farseer_trigger = "Farseers, mend our wounds!"
	L.custom_off_shaman_marker = "Farseer marker"
	L.custom_off_shaman_marker_desc = "To help interrupt assignments, mark the Farseer Wolf Rider with {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, quickly mousing over the farseers is the fastest way to mark them.|r"

	L.custom_off_minion_marker = "Minion marker"
	L.custom_off_minion_marker_desc = "To help separating minions, mark them with {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8}, requires promoted or leader."

	L.focus_only = "|cffff0000Focus target alerts only.|r "
end
L = mod:GetLocale()
L.chain_heal_desc = L.focus_only..L.chain_heal_desc

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	-- XXX Funkeh clean "FLASH" up as you see fit
	return {
		{147209, "FLASH", "ICON"}, 147235, "bombardment", {147665, "FLASH", "ICON"}, {"clump_check", "FLASH"}, "manifest_rage", -- phase 4 .. fix descriptions
		-8298, 144616, "ironstar_impact", -8292, 144821, -- phase 1
		-8294, "chain_heal", "custom_off_shaman_marker", -- Farseer
		-8305, 144945, 144969, -- Intermissions
		"custom_off_minion_marker",
		145065, {144985, "FLASH"}, 145183, -- phase 2
		{144758, "SAY", "FLASH", "ICON"},
		"stages", "berserk", "bosskill",
	}, {
		[147209] = CL["phase"]:format(4),
		[-8298] = -8288, -- phase 1
		[-8294] = -8294, -- Farseer
		[-8305] = -8305, "custom_off_minion_marker", -- Intermissions
		[145065] = -8307, -- phase 2
		[144758] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3")
	self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "IronStarRolling", "boss2", "boss3")

	-- Phase 4
	self:Yell("Phase3End", L.phase_3_end_trigger)
	self:Emote("IronStar", "147047")
	self:Log("SPELL_CAST_START", "ManifestRage", 147011)
	self:Log("SPELL_AURA_APPLIED", "IronStarFixateApplied", 147665)
	self:Log("SPELL_AURA_REMOVED", "IronStarFixateRemoved", 147665)
	self:Log("SPELL_AURA_APPLIED", "MaliciousBlastApplied", 147235)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MaliciousBlastApplied", 147235)
	self:Log("SPELL_AURA_APPLIED", "MaliceApplied", 147209)
	self:Log("SPELL_AURA_REMOVED", "MaliceRemoved", 147209)
	self:Log("SPELL_CAST_START", "Bombardment", 147120)
	-- Phase 2
	self:Log("SPELL_CAST_SUCCESS", "MindControl", 145065, 145171)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GrippingDespair", 145183, 145195)
	self:Log("SPELL_AURA_APPLIED", "GrippingDespair", 145183, 145195)
	self:Log("SPELL_CAST_START", "WhirlingCorruption", 144985, 145037)
	self:Log("SPELL_SUMMON", "SummonEmpowredAdd", 145033)
	-- Intermissions
	self:Log("SPELL_CAST_START", "Annihilate", 144969)
	self:Log("SPELL_AURA_REMOVED", "YShaarjsProtection", 144945)
	-- Phase 1
	self:Log("SPELL_CAST_START", "Warsong", 144821)
	self:Log("SPELL_AURA_APPLIED", "AddMarkedMob", 144585) -- Ancestral Fury
	self:Log("SPELL_CAST_START", "AddMarkedMob", 144584) -- Chain Lightning
	self:Log("SPELL_CAST_START", "ChainHeal", 144583)
	self:Log("SPELL_CAST_SUCCESS", "PowerIronStar", 144616)
	self:Yell("Farseer", L["farseer_trigger"])
	self:Emote("SiegeEngineer", "144616")
	self:Log("SPELL_CAST_SUCCESS", "DesecratedWeapon", 144748, 144749)

	self:Death("EngineerDeath", 71984) -- Siege Engineer
	self:Death("RiderDeath", 71983) -- Farseer Wolf Rider
	self:Death("Win", 71865) -- Garrosh
end

function mod:OnEngage(diff)
	waveCounter = 1
	waveTimer = self:ScheduleTimer("NewWave", waveTimers[waveCounter])
	self:Bar(-8292, waveTimers[waveCounter], nil, 144582)
	self:Berserk(960, nil, nil, "Berserk (assumed)") -- XXX assumed (more than 15:13 on 25H)
	annihilateCounter = 1
	self:Bar(144758, 11) -- Desecrated Weapon
	self:ScheduleTimer("StartWeaponScan", 5)
	self:Bar(-8298, 20, nil, 144616) -- Siege Engineer
	self:Bar(-8294, 30, nil, 144584) -- Farseer
	self:Bar(144821, 22) -- Warsong
	whirlingCounter = 1
	farseerCounter = 1
	engineerCounter = 1
	desecrateCD = 41
	phase = 1
	wipe(markableMobs)
	wipe(marksUsed)
	markTimer = nil
	if self.db.profile.custom_off_shaman_marker then
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	end
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1", "boss2", "boss3")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- phase 4
do
	local lastMilestone = nil
	function mod:UNIT_POWER(unit)
		-- let's try to not start a new bar if not necessary. Power gain speed is 1 power ever 0.8 exactly.
		local power = UnitPower(unit)
		if power == 1 then
			lastMilestone = GetTime()
			self:Bar("manifest_rage", 79.2, 147011, 147011)
		elseif power == 25 then
			lastMilestone = GetTime()
			if (GetTime() - lastMilestone) < 19.2 then -- there were extra power gain need to update the bar 24*0.8
				self:Bar("manifest_rage", 60, 147011, 147011)
			end
		elseif power == 50 then
			lastMilestone = GetTime()
			if (GetTime() - lastMilestone) < 20 then -- there were extra power gain need to update the bar 25*0.8
				self:Bar("manifest_rage", 40, 147011, 147011)
			end
		elseif power == 75 then
			lastMilestone = GetTime()
			if (GetTime() - lastMilestone) < 20 then -- there were extra power gain need to update the bar 25*0.8
				self:Bar("manifest_rage", 20, 147011, 147011)
			end
		elseif power == 95 then
			lastMilestone = GetTime()
			if (GetTime() - lastMilestone) < 16 then -- there were extra power gain need to update the bar 20*0.8
				self:Bar("manifest_rage", 4, 147011, 147011) -- 4 should be enough since there is still a 2 sec cast time before the channel
			end
		end
	end
end

function mod:ManifestRage(args)
	self:Message("manifest_rage", "Important", "Warning", 147011, 147011)
end

function mod:Phase3End()
	bombardmentCounter = 1
	self:Bar("stages", 19, CL["phase"]:format(4), 147126)
	-- stop bars here too, but since this needs localization we need to do it at the actual pull into the phase 4
	self:StopBar(L["intermission"])
	self:StopBar(CL["count"]:format(self:SpellName(144985), whirlingCounter)) -- whirling corruption -- just to be safe for the future of overgearing the fight
	self:StopBar(CL["count"]:format(self:SpellName(145037), whirlingCounter)) -- empowered whirling corruption
	self:StopBar(144758) -- desecrate weapon
	self:StopBar(L["mind_control"]) -- Mind Control
end

function mod:IronStar()
	self:Message("clump_check", "Important", "Long", L["spread"], 147126)
	self:Flash("clump_check", 147126)
end

do
	local prev = 0
	function mod:MaliciousBlastApplied(args)
		local t = GetTime()
		if t-prev > 1 and UnitDebuff("player", self:SpellName(147209)) then -- malice
			prev = t
			self:Bar(args.spellId, 2)
		elseif self:Me(args.destGUID) and args.amount and args.amount > 1 then
			self:StackMessage(args.spellId, args.destName, args.amount) -- so people know they are taking extra damage
		end
	end
end

function mod:MaliceRemoved(args)
	self:SecondaryIcon(args.spellId)
end

function mod:MaliceApplied(args)
	self:SecondaryIcon(args.spellId, args.destName)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	self:Bar(args.spellId, 30)
	maliciousSpreader = args.destName
	if self:Me(args.destGUID) then
		self:Bar(args.spellId, 14, CL["you"]:format(args.spellName))
		self:Flash(args.spellId)
	end
end

function mod:IronStarFixateRemoved(args)
	self:PrimaryIcon(args.spellId)
end

function mod:IronStarFixateApplied(args)
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Warning")
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
	end
end

function mod:Bombardment(args)
	self:Message("bombardment", "Attention", nil, L["bombardment"], args.spellId)
	self:Bar("bombardment", bombardmentTimers[bombardmentCounter] and bombardmentTimers[bombardmentCounter] or 25, L["bombardment"], args.spellId)
	bombardmentCounter = bombardmentCounter + 1
	self:Bar("bombardment", 13, CL["casting"]:format(args.spellName), args.spellId)
	self:Bar("clump_check", 3, L["clump_check"], 147126) -- Clump Check
end

-- phase 2
function mod:GrippingDespair(args)
	local amount = args.amount or 1
	local sound
	if amount > 3 and not self:Me(args.destGUID) then
		sound = "Warning"
	end
	if args.spellId == 145195 then -- XXX do tanks need a bar for non empowered?
		self:TargetBar(145183, 10, args.destName, 145195) -- text might be too long
	end
	if self:Tank() then
		self:StackMessage(145183, args.destName, amount, "Attention", sound) -- force Gripping Despair text to keep it short
	end
end

function mod:MindControl(args)
	mindControl = true
	self:Message(145065, "Urgent", "Alert", CL["casting"]:format(L["mind_control"]))
	if phase == 3 then
		self:Bar(145065, (mcCounter == 1) and 35 or 42, L["mind_control"])
		mcCounter = mcCounter + 1 -- XXX might need more data
	else
		self:Bar(145065, 45, L["mind_control"])
	end
end

-- Phase 1
function mod:Warsong(args)
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 42)
end

function mod:NewWave()
	self:Message(-8292, "Attention", CL["count"]:format(self:SpellName(-8292), waveCounter), nil, 144582) -- XXX the count message is only in for debugging
	waveCounter = waveCounter + 1
	self:Bar(-8292, waveTimers[waveCounter] or 40, nil, 144582)
	waveTimer = self:ScheduleTimer("NewWave", waveTimers[waveCounter] or 40)
end

-- marking
do
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
		if not continue or not mod.db.profile.custom_off_shaman_marker then
			mod:CancelTimer(markTimer)
			markTimer = nil
		end
	end

	function mod:UPDATE_MOUSEOVER_UNIT()
		local guid = UnitGUID("mouseover")
		if guid and markableMobs[guid] == true then
			setMark("mouseover", guid)
		end
	end

	function mod:AddMarkedMob(args)
		if not markableMobs[args.destGUID] then
			markableMobs[args.destGUID] = true
			if self.db.profile.custom_off_shaman_marker and not markTimer then
				markTimer = self:ScheduleRepeatingTimer(markMobs, 0.2)
			end
		end
	end
	function mod:SummonEmpowredAdd(args)
		if not markableMobs[args.destGUID] then
			markableMobs[args.destGUID] = true
			if self.db.profile.custom_off_minion_marker and not markTimer then
				markTimer = self:ScheduleRepeatingTimer(markMobs, 0.1)
			end
		end
	end
	function mod:WhirlingCorruption(args)
		self:Flash(144985)
		self:Message(144985, "Important", "Long", CL["count"]:format(args.spellName, whirlingCounter))
		whirlingCounter = whirlingCounter + 1
		self:Bar(144985, 50, CL["count"]:format(args.spellName, whirlingCounter))
		if args.spellId == 145037 and self.db.profile.custom_off_minion_marker then
			markableMobs = {}
			marksUsed = {}
			markTimer = nil
			self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
			if not markTimer then
				markTimer = self:ScheduleRepeatingTimer(markMobs, 0.1)
			end
		end
	end
	function mod:RiderDeath(args)
		if self.db.profile.custom_off_shaman_marker then
			markableMobs[args.destGUID] = nil
			for i=1, 7 do
				if marksUsed[i] == args.destGUID then
					marksUsed[i] = nil
					break
				end
			end
		end
	end
end

do
	local prev = 0
	function mod:ChainHeal(args)
		mod:AddMarkedMob(args)
		local t = GetTime()
		if t-prev > 3 and UnitGUID("focus") == args.sourceGUID then -- don't spam
			prev = t
			self:Message("chain_heal", "Personal", "Alert", L["chain_heal_message"], args.spellId)
		end
	end
end

do
	local farseerTimers = { 50, 50, 40 } -- XXX need more data
	--  cat Transcriptor.lua | sed "s/\t//g" | cut -d ' ' -f 2-300 | grep -E "(YELL].*Farseers)|(DED.*144489)|(DED.*144866)"
	function mod:Farseer()
		self:Message(-8294, "Urgent", self:Damager() and "Alert", nil, 144584)
		self:Bar(-8294, farseerTimers[farseerCounter] or 40, nil, 144584) -- chain lightning icon cuz that is some shaman spell
		farseerCounter = farseerCounter + 1
	end
end

do
	local dead = 0
	function mod:SiegeEngineer()
		self:Message(-8298, "Attention", nil, nil, 144616)
		self:Bar(-8298, engineerCounter == 1 and 45 or 40, nil, 144616)
		engineerCounter = engineerCounter + 1
		dead = 0
	end
	function mod:EngineerDeath()
		dead = dead + 1
		if dead > 1 then
			self:StopBar(144616)
		end
	end
end

function mod:PowerIronStar(args)
	self:Bar(args.spellId, 15)
end

function mod:IronStarRolling(_, _, _, _, spellId)
	if spellId == 144616 then -- Power Iron Star
		self:Message(spellId, "Important", L["ironstar_rolling"])
		self:Bar("ironstar_impact", 9, 144653) -- Iron Star Impact
	end
end

-- Intermission
function mod:Annihilate(args)
	self:Message(args.spellId, "Attention", nil, CL["casting"]:format(CL["count"]:format(args.spellName, annihilateCounter)))
	annihilateCounter = annihilateCounter + 1
end

do
	local hopeList = mod:NewTargetList()
	local function announceHopeless()
		local diff = mod:Difficulty()
		for i=1, GetNumGroupMembers() do
			local name, _, subgroup = GetRaidRosterInfo(i)
			-- 149004 hope
			-- 148983 courage
			-- 148994 faith
			local debuffed = (UnitDebuff(name, mod:SpellName(149004))) or (UnitDebuff(name, mod:SpellName(148983))) or (UnitDebuff(name, mod:SpellName(148994)))
			if not debuffed then
				if diff == 3 or diff == 5 then -- 10 man
					if subgroup < 3 then
						hopeList[#hopeList+1] = name
					end
				else
					if subgroup < 6 then
						hopeList[#hopeList+1] = name
					end
				end
			end
		end
		-- this is so people know they'll take extra damage
		if #hopeList > 0 then
			mod:TargetMessage(144945, hopeList, "Attention", "Warning", CL["count"]:format(mod:SpellName(29125), #hopeList), 149004) -- maybe add it's own option key? 29125 spell called "Hopeless"
		end
	end
	function mod:YShaarjsProtection(args)
		if self:MobId(args.destGUID) ~= 71865 then return end
		whirlingCounter = 1
		annihilateCounter = 1
		self:ScheduleTimer(announceHopeless, 5)
		self:Message(args.spellId, "Positive", "Long", CL["over"]:format(args.spellName))
	end
end

do
	local function mindControlMagic(spellId)
		if not mindControl then -- there has not been an MC for more than 32 sec
			mod:Bar(spellId, 8, L["mind_control"])
		end
	end
	function mod:UNIT_SPELLCAST_SUCCEEDED(unitId, spellName, _, _, spellId)
		if spellId == 145235 then -- throw axe at heart , transition into first intermission
			if phase == 1 then
				self:Bar(-8305, 25, L["intermission"], "SPELL_HOLY_PRAYEROFSHADOWPROTECTION")
				self:CancelTimer(waveTimer)
				waveTimer = nil
				self:StopBar(-8292) -- Kor'kron Warbringer aka add waves
				self:StopBar(-8298) -- Siege Engineer
				self:StopBar(-8294) -- Farseer
				self:StopBar(144758) -- Desecrated Weapon
				self:StopBar(144821) -- Warsong
				self:StopWeaponScan()
			end
		elseif spellId == 144866 then -- Enter Realm of Y'Shaarj -- actually being pulled
			self:StopBar(144758) -- Desecrated Weapon
			self:StopWeaponScan()
			self:StopBar(L["mind_control"]) -- Mind Control
			self:StopBar(144985) -- Whirling Corruption
			self:Message(-8305, "Neutral", nil, L["intermission"], "SPELL_HOLY_PRAYEROFSHADOWPROTECTION")
			self:Bar(-8305, 210, L["intermission"], "SPELL_HOLY_PRAYEROFSHADOWPROTECTION")
			self:Bar(-8305, 62, CL["over"]:format(L["intermission"]), "SPELL_HOLY_PRAYEROFSHADOWPROTECTION")
		elseif spellId == 144956 then -- Jump To Ground -- exiting intermission
			if phase == 2 then
				desecrateCounter = 1
				self:Bar(144758, 10) -- Desecrated Weapon
				self:Bar(145065, 15, L["mind_control"]) -- Mind Control
				self:Bar(144985, 30, CL["count"]:format(self:SpellName(144985), whirlingCounter)) -- Whirling Corruption
				self:ScheduleTimer("StartWeaponScan", 5)
				local hp = UnitHealth("boss1") / UnitHealthMax("boss1") * 100
				if hp < 50 then -- XXX might need adjusting
					self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1", "boss2", "boss3") -- don't really need this till 2nd intermission phase
				end
			else -- first time, don't start timers yet
				phase = 2
			end
		elseif spellId == 145647 then -- Realm of Y'Shaarj -- phase 3
			phase = 3
			mcCounter = 1
			desecrateCounter = 1
			self:Message("stages", "Neutral", nil, CL["phase"]:format(phase), false)
			self:StopBar(L["intermission"])
			self:StopBar(144985) -- stop Whirling Corruption bar in case it was not empowered already
			self:Bar(144985, 48, CL["count"]:format(self:SpellName(145037), whirlingCounter)) -- Empowered Whirling Corruption
			if self:Heroic() then
				-- XXX lets try to improve this, because it looks like if it is not cast within 32 sec, then it is going to be closer to 40 than to 30 need more Transcriptor log
				mindControl = nil
				self:ScheduleTimer(mindControlMagic, 32, 145065)
				self:Bar(145065, 31, L["mind_control"]) -- Mind Control
			else
				self:Bar(145065, 29, L["mind_control"]) -- Mind Control
			end
			self:CDBar(144758, 21) -- Desecrated Weapon -- on heroic 21-23
		elseif spellId == 146984 then -- phase 4 Enter Realm of Garrosh
			phase = 4
			self:Message("stages", "Neutral", nil, CL["phase"]:format(phase), false)
			self:StopBar(L["intermission"])
			self:StopBar(CL["count"]:format(self:SpellName(144985), whirlingCounter)) -- whirling corruption -- just to be safe for the future of overgearing the fight
			self:StopBar(CL["count"]:format(self:SpellName(145037), whirlingCounter)) -- empowered whirling corruption
			self:StopBar(144758) -- desecrate weapon
			self:StopBar(L["mind_control"]) -- Mind Control
			self:Bar(147209, 30) -- Malice
			self:Bar("bombardment", 69, L["bombardment"], 147120) -- Bombardment
			self:RegisterUnitEvent("UNIT_POWER", nil, "boss1")
			self:StopWeaponScan()
		elseif spellId == 147126 and clumpCheckAllowed then -- Clump Check
			self:Bar("clump_check", 3, L["clump_check"], 147126)
		end
	end
end

-- General
function mod:UNIT_HEALTH_FREQUENT(unitId)
	if self:MobId(UnitGUID(unitId)) ~= 71865 then return end
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if (hp < 15 and phase == 1) or (hp < 13 and phase == 2) then -- 10%
		self:Message("stages", "Neutral", "Info", CL["soon"]:format(CL["phase"]:format(phase+1)), false)
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1", "boss2", "boss3")
	end
end

do
	local UnitDetailedThreatSituation, UnitExists, UnitIsUnit = UnitDetailedThreatSituation, UnitExists, UnitIsUnit
	local function checkWeaponTarget()
		local boss = getBossByMobId(71865)
		if not boss then return end
		local target = boss.."target"
		-- added UnitCastingInfo(boss), UnitChannelInfo(boss), if it turns out to be too restrictive could just disable weaponTarget check while whirling corruption is being casted
		if not UnitExists(target) or mod:Tank(target) or UnitDetailedThreatSituation(target, boss) or UnitCastingInfo(boss) or UnitChannelInfo(boss) then return end

		local name = mod:UnitName(target)
		mod:SecondaryIcon(144758, name) -- so we don't use skull as that might be used for marking the healing add
		if UnitIsUnit("player", target) then
			mod:TargetMessage(144758, name, "Urgent", "Alarm")
			mod:Flash(144758)
			mod:Say(144758)
		elseif mod:Range(name) < 15 then
			mod:Flash(144758)
			mod:RangeMessage(144758, "Urgent", "Alarm")
		else
			mod:TargetMessage(144758, name, "Urgent", "Alarm")
		end
		mod:StopWeaponScan()
	end
	function mod:StartWeaponScan()
		if not weaponTimer then
			weaponTimer = self:ScheduleRepeatingTimer(checkWeaponTarget, 0.05)
		end
	end
	function mod:StopWeaponScan()
		self:CancelTimer(weaponTimer)
		weaponTimer = nil
	end
	local phase2DesecreteCDs = {36, 45, 36}
	function mod:DesecratedWeapon(args)
		if phase == 2 then
			local diff = self:Difficulty()
			if diff == 3 or diff == 5 then -- 10 man
				desecrateCD = phase2DesecreteCDs[desecrateCounter] or 45
			else
				desecrateCD = 35
			end
		elseif phase == 3 then
			desecrateCD = (desecrateCounter == 1) and 35 or 25
		end
		self:CDBar(144758, desecrateCD)
		desecrateCounter = desecrateCounter + 1
		self:ScheduleTimer("StopWeaponScan", 2) -- delay it a bit just to be safe
		self:ScheduleTimer("StartWeaponScan", desecrateCD-7)
	end
end

