
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Garrosh Hellscream", 953, 869)
if not mod then return end
mod:RegisterEnableMob(71865)
mod.engageId = 1623

--------------------------------------------------------------------------------
-- Locals
--

local UnitHealth, UnitHealthMax, UnitPower, GetTime = UnitHealth, UnitHealthMax, UnitPower, GetTime
local markableMobs = {}
local marksUsed = {}
local markTimer = nil
local mcCounter = 1
local farseerCounter = 1
local engineerCounter = 1
local desecrateCounter = 1
local phase = 1
local waveTimer, waveCounter = nil, 1
local whirlingCounter = 1
local bombardmentCounter, maliceCounter = 1, 1
local hopeTimer = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.manifest_rage = "Manifest Rage"
	L.manifest_rage_desc = "When Garrosh reaches 100 energy he'll pre cast Manifest Rage for 2 seconds, then channel it. While it's channelled it summons big adds. Kite the Iron Star into Garrosh to stun and interrupt his cast."
	L.manifest_rage_icon = 147011

	L.phase_3_end_trigger = "You think you have WON?"

	L.clump_check = 147126 -- "Clump Check"
	L.clump_check_desc = "Check every 3 seconds during bombardment for clumped up players, if a clump is found a Kor'kron Iron Star will spawn."
	L.clump_check_warning = "Clump found: Star Incoming!"
	L.clump_check_icon = 147126

	L.bombardment = "Bombardment"
	L.bombardment_desc = "Bombards Stormwind, leaving patches of fire on the ground. The Kor'kron Iron Star can only spawn during bombardment."
	L.bombardment_icon = 147120

	L.empowered_message = "%s is now empowered!"

	L.ironstar_impact = 144653 -- "Iron Star Impact"
	L.ironstar_impact_desc = "A timer bar for when the Iron Star will impact the wall at the other side."
	L.ironstar_impact_icon = 144653
	L.ironstar_rolling = "Iron Star Rolling!"

	L.chain_heal = 144583 -- "Ancestral Chain Heal"
	L.chain_heal_desc = "{focus}Heals a friendly target for 40% of their max health, chaining to nearby friendly targets."
	L.chain_heal_icon = 144583
	L.chain_heal_message = "Your focus is casting Chain Heal!"
	L.chain_heal_bar = "Focus: Chain Heal"

	L.farseer_trigger = "Farseers, mend our wounds!"

	L.custom_off_shaman_marker = "Farseer marker"
	L.custom_off_shaman_marker_desc = "To help interrupt assignments, mark the Farseer Wolf Rider with {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, quickly mousing over the farseers is the fastest way to mark them.|r"
	L.custom_off_shaman_marker_icon = 1

	L.custom_off_minion_marker = "Minion marker"
	L.custom_off_minion_marker_desc = "To help separate Empowered Whirling Corruption adds, mark them with {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}, requires promoted or leader."
	L.custom_off_minion_marker_icon = 1
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		-8298, 144616, "ironstar_impact", -8292, 144821, -- phase 1
		-8294, "chain_heal", "custom_off_shaman_marker", -- Farseer
		-8305, 144945, 144969, -- Intermissions
		145065, {144985, "FLASH"}, {145183, "TANK"}, -- phase 2
		-8325, -- phase 3
		"custom_off_minion_marker",
		{147209, "FLASH", "ICON", "SAY"}, 147235, "bombardment", {147665, "FLASH", "ICON"}, {"clump_check", "FLASH", "PROXIMITY"}, "manifest_rage", -- phase 4
		{144758, "SAY", "FLASH", "ICON"},
		"stages", "berserk", "bosskill",
	}, {
		[-8298] = -8288, -- phase 1
		[-8294] = -8294, -- Farseer
		[-8305] = -8305, -- Intermissions
		[145065] = -8307, -- phase 2
		[-8325] = -8319, -- phase 3
		["custom_off_minion_marker"] = L.custom_off_minion_marker,
		[147209] = ("%s (%s)"):format(CL.stage:format(4), CL.mythic),
		[144758] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3")
	self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "IronStarRolling", "boss1", "boss2", "boss3")

	-- Phase 4
	self:Yell("Phase3End", L.phase_3_end_trigger)
	self:Emote("ClumpFailIronStarSpawn", "147047")
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
	self:Log("SPELL_SUMMON", "SummonEmpoweredAdd", 145033)
	-- Intermissions
	self:Log("SPELL_CAST_START", "Annihilate", 144969)
	self:Log("SPELL_AURA_REMOVED", "YShaarjsProtection", 144945)
	self:Log("SPELL_AURA_APPLIED", "Hope", 149004, 148983, 148994) -- Hope, Courage, Faith
	-- Phase 1
	self:Log("SPELL_CAST_START", "Warsong", 144821)
	self:Log("SPELL_AURA_APPLIED", "AddMarkedMob", 144585) -- Ancestral Fury
	self:Log("SPELL_CAST_START", "AddMarkedMob", 144584) -- Chain Lightning
	self:Log("SPELL_CAST_START", "ChainHeal", 144583)
	self:Log("SPELL_CAST_SUCCESS", "PowerIronStar", 144616)
	self:Yell("Farseer", L.farseer_trigger)
	self:Emote("SiegeEngineer", "144616")
	self:Log("SPELL_CAST_SUCCESS", "Desecrate", 144748, 144749)

	self:Death("EngineerDeath", 71984) -- Siege Engineer
	self:Death("RiderDeath", 71983) -- Farseer Wolf Rider
end

function mod:OnEngage(diff)
	waveCounter = 1
	waveTimer = self:ScheduleTimer("NewWave", 2)
	self:Bar(-8292, 2, nil, 144582) -- Kor'kron Warbringer aka add waves
	self:Berserk(1500)
	self:Bar(144758, 11) -- Desecrate
	self:Bar(-8298, 20, nil, 144616) -- Siege Engineer
	self:Bar(-8294, 30, nil, 144584) -- Farseer
	self:Bar(144821, 22) -- Warsong
	farseerCounter = 1
	engineerCounter = 1
	desecrateCounter = 1
	whirlingCounter = 1
	mcCounter = 1
	phase = 1
	bombardmentCounter, maliceCounter = 1, 1
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
	local prev, castTime = 0, 0
	function mod:UNIT_POWER_FREQUENT(unit)
		local power = UnitPower(unit)
		if power == prev then return end
		prev = power

		local t = (100 - power) * 0.9 -- 90s
		if power == 1 then
			self:Bar("manifest_rage", t, 147011)
			castTime = GetTime() + t
		elseif power > 1 and power < 100 then
			local newTime = GetTime() + t
			if newTime+0.3 < castTime then
				self:Bar("manifest_rage", t, 147011)
				castTime = newTime
			end
		end
	end
end

function mod:ManifestRage(args)
	self:Message("manifest_rage", "Important", "Warning", 147011, 147011)
end

function mod:Phase3End()
	bombardmentCounter = 1
	maliceCounter = 1
	self:Bar("stages", 19, CL.phase:format(4), 147126)
	-- stop bars here too, but since this needs localization we need to do it at the actual pull into the phase 4
	self:StopBar(CL.intermission)
	self:StopBar(CL.count:format(self:SpellName(144985), whirlingCounter)) -- Whirling Corruption
	self:StopBar(144758) -- Desecrate
	self:StopBar(67229) -- Mind Control
end

function mod:ClumpFailIronStarSpawn()
	self:Message("clump_check", "Important", "Long", L.clump_check_warning, 147126)
	self:Flash("clump_check", 147126)
end

do
	local prev = 0
	function mod:MaliciousBlastApplied(args)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Personal", "Alert", CL.you:format(CL.count:format(args.spellName, args.amount or 1)))
			self:Bar(args.spellId, 2) -- Next tick
		end

		local t = GetTime()
		if t-prev > 1 and UnitDebuff("player", self:SpellName(147209)) then -- Malice Debuff
			prev = t
			self:Bar(args.spellId, 2) -- Bar for when you as the player with Malice will spread Malicious Blast to others
		end
	end
end

function mod:MaliceRemoved(args)
	self:SecondaryIcon(args.spellId)
end

function mod:MaliceApplied(args)
	self:SecondaryIcon(args.spellId, args.destName)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	self:TargetBar(args.spellId, 14, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
	end
	maliceCounter = maliceCounter + 1
	self:Bar(args.spellId, 30, CL.count:format(args.spellName, maliceCounter))
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

do
	local bombardmentTimers = { 55, 40, 40, 25, 25, 15 }
	function mod:Bombardment(args)
		self:Message("bombardment", "Attention", nil, CL.count:format(L.bombardment, bombardmentCounter), args.spellId)
		self:Bar("bombardment", bombardmentTimers[bombardmentCounter] or 15, CL.count:format(L.bombardment, bombardmentCounter+1), args.spellId)
		bombardmentCounter = bombardmentCounter + 1
		self:Bar("bombardment", 13, CL.casting:format(args.spellName), args.spellId)
		self:Bar("clump_check", 3, 147126) -- Clump Check
		self:OpenProximity("clump_check", 10)
		self:ScheduleTimer("CloseProximity", 13, "clump_check")
	end
end

-- phase 2
function mod:GrippingDespair(args)
	local amount = args.amount or 1
	-- force Gripping Despair text to keep it short
	self:StackMessage(145183, args.destName, amount, "Attention", amount > 2 and not self:Me(args.destGUID) and "Warning")
	if args.spellId == 145195 then -- Empowered (Explosive Despair)
		self:TargetBar(-8325, 10, args.destName)
	end
end

function mod:MindControl(args)
	self:Message(145065, "Urgent", "Alert", 67229, 145065) -- 67229 = "Mind Control"
	if phase == 3 then
		self:Bar(145065, (mcCounter == 1) and 35 or 42, 67229, 145065) -- 67229 = "Mind Control"
	elseif mcCounter < 3 then -- Only enough time for 3 in phase 2 between each intermission
		self:Bar(145065, 45, 67229, 145065) -- 67229 = "Mind Control"
	end
	mcCounter = mcCounter + 1
end

-- Phase 1
function mod:Warsong(args)
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 42)
end

do
	local waveTimers = { 43, 45 }
	function mod:NewWave()
		self:Message(-8292, "Attention", nil, nil, 144582)
		self:Bar(-8292, waveTimers[waveCounter] or 40, nil, 144582)
		waveTimer = self:ScheduleTimer("NewWave", waveTimers[waveCounter] or 40)
		waveCounter = waveCounter + 1
	end
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
		if not continue then
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
	function mod:SummonEmpoweredAdd(args)
		if not markableMobs[args.destGUID] then
			markableMobs[args.destGUID] = true
			if self.db.profile.custom_off_minion_marker and not markTimer then
				markTimer = self:ScheduleRepeatingTimer(markMobs, 0.1)
			end
		end
	end
	function mod:WhirlingCorruption(args)
		self:Flash(144985)
		self:Message(144985, "Important", "Long", CL.count:format(args.spellName, whirlingCounter))
		whirlingCounter = whirlingCounter + 1
		if phase == 2 then
			if whirlingCounter < 4 then -- Only enough time for 3 in phase 2 between each intermission
				self:Bar(144985, 50, CL.count:format(self:SpellName(144985), whirlingCounter))
			end
			if desecrateCounter == 3 and whirlingCounter == 3 then -- Whirling arrived first, delay Desecrate to the end of the cast
				self:CDBar(144758, 8.5) -- Desecrate, delayed by Whirling: 2.5s cast and 6s channel = 8.5s
			end
		else
			self:Bar(144985, 50, CL.count:format(self:SpellName(144985), whirlingCounter))
		end

		if args.spellId == 145037 and self.db.profile.custom_off_minion_marker then
			wipe(markableMobs)
			wipe(marksUsed)
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

function mod:ChainHeal(args)
	if UnitGUID("focus") == args.sourceGUID then
		self:Message("chain_heal", "Personal", "Alert", L.chain_heal_message, args.spellId)
	end
end

do
	local farseerTimers = { 50, 50, 40 } -- XXX need more data
	-- cat Transcriptor.lua | sed "s/\t//g" | cut -d ' ' -f 2-300 | grep -E "(YELL].*Farseers)|(DED.*144489)|(DED.*144866)"
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
			self:StopBar(144616) -- Power Iron Star
		end
	end
end

function mod:PowerIronStar(args)
	self:Bar(args.spellId, self:Mythic() and 10 or 15)
end

function mod:IronStarRolling(_, _, _, _, spellId)
	if spellId == 144616 then -- Power Iron Star
		self:Message(spellId, "Important", nil, L.ironstar_rolling)
		self:Bar("ironstar_impact", 9, 144653) -- Iron Star Impact
	end
end

-- Intermission

do
	local hope, courage, faith = mod:SpellName(149004), mod:SpellName(148983), mod:SpellName(148994)
	local hopeList = mod:NewTargetList()
	local function announceHopeless()
		for unit in mod:IterateGroup() do
			if UnitAffectingCombat(unit) and not UnitDebuff(unit, hope) and not UnitDebuff(unit, courage) and not UnitDebuff(unit, faith) then
				hopeList[#hopeList+1] = mod:UnitName(unit)
			end
		end
		-- this is so people know they'll take extra damage
		if #hopeList > 0 then
			mod:TargetMessage(144945, hopeList, "Attention", "Warning", CL.count:format(mod:SpellName(29125), #hopeList), 149004) -- maybe add it's own option key? 29125 spell called "Hopeless"
		else
			mod:Message(144945, "Attention", nil, CL.count:format(mod:SpellName(29125), 0), 149004)
		end
		hopeTimer = nil
	end
	function mod:Hope()
		if hopeTimer == nil then -- Purposely a nil check. Set as false when intermission begins.
			hopeTimer = self:ScheduleTimer(announceHopeless, 2)
		end
	end
	function mod:YShaarjsProtection(args)
		if self:MobId(args.destGUID) == 71865 then
			self:Message(args.spellId, "Positive", "Long", CL.over:format(args.spellName))
			if not self:LFR() then
				hopeTimer = self:ScheduleTimer(announceHopeless, 6)
			end
		end
	end
end

do
	local warnPower = 25
	local abilities = { [25] = mod:SpellName(144985), [50] = mod:SpellName(67229), [75] = mod:SpellName(144748), [100] = mod:SpellName(145183) }

	local annihilateCounter = 1
	function mod:Annihilate(args)
		self:Message(args.spellId, "Attention", nil, CL.casting:format(CL.count:format(args.spellName, annihilateCounter)))
		annihilateCounter = annihilateCounter + 1
	end

	function mod:UNIT_SPELLCAST_SUCCEEDED(unitId, spellName, _, _, spellId)
		if spellId == 145235 then -- throw axe at heart , transition into first intermission
			if phase == 1 then
				self:Bar(-8305, 25, CL.intermission, "SPELL_HOLY_PRAYEROFSHADOWPROTECTION")
				self:CancelTimer(waveTimer)
				waveTimer = nil
				self:StopBar(-8292) -- Kor'kron Warbringer aka add waves
				self:StopBar(-8298) -- Siege Engineer
				self:StopBar(-8294) -- Farseer
				self:StopBar(144758) -- Desecrate
				self:StopBar(144821) -- Warsong
				self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
			end
		elseif spellId == 144866 then -- Enter Realm of Y'Shaarj -- actually being pulled
			self:StopBar(144758) -- Desecrate
			self:StopBar(67229) -- Mind Control
			self:StopBar(CL.count:format(self:SpellName(144985), whirlingCounter)) -- Whirling Corruption
			self:Message(-8305, "Neutral", nil, CL.intermission, "SPELL_HOLY_PRAYEROFSHADOWPROTECTION")
			self:Bar(-8305, 210, CL.intermission, "SPELL_HOLY_PRAYEROFSHADOWPROTECTION")
			self:Bar(-8305, 62, CL.over:format(CL.intermission), "SPELL_HOLY_PRAYEROFSHADOWPROTECTION")
			whirlingCounter = 1
			annihilateCounter = 1
			hopeTimer = false
		elseif spellId == 144956 then -- Jump To Ground -- exiting intermission
			if phase == 2 then
				if hopeTimer then self:CancelTimer(hopeTimer) hopeTimer = nil end
				desecrateCounter = 1
				mcCounter = 1
				self:Bar(144758, 10) -- Desecrate
				if not self:Solo() then
					self:Bar(145065, 15, 67229, 145065) -- Mind Control
				end
				self:Bar(144985, 30, CL.count:format(self:SpellName(144985), whirlingCounter)) -- Whirling Corruption
				self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1", "boss2", "boss3")
				-- warn for empowered abilities
				local power = UnitPower("boss1")
				while power >= warnPower do -- can he hit 100 energy before p3? that would be some shenanigans
					self:DelayedMessage("stages", 2, "Attention", L.empowered_message:format(abilities[warnPower]), false, "Info")
					warnPower = warnPower + 25
				end
			else -- first time, don't start timers yet
				phase = 2
				warnPower = 25
			end
		elseif spellId == 145647 then -- Realm of Y'Shaarj -- phase 3
			if hopeTimer then self:CancelTimer(hopeTimer) hopeTimer = nil end
			phase = 3
			mcCounter = 1
			desecrateCounter = 1
			self:Message("stages", "Neutral", nil, CL.phase:format(phase), false)
			self:StopBar(CL.intermission)
			self:Bar(144985, 45, CL.count:format(self:SpellName(144985), whirlingCounter)) -- Whirling Corruption
			if not self:Solo() then
				self:Bar(145065, 29, 67229, 145065) -- Mind Control
			end
			self:CDBar(144758, 20) -- Desecrate
		elseif spellId == 146984 then -- phase 4 Enter Realm of Garrosh
			phase = 4
			self:Message("stages", "Neutral", nil, CL.phase:format(phase), false)
			self:StopBar(CL.intermission)
			self:StopBar(CL.count:format(self:SpellName(144985), whirlingCounter)) -- Whirling Corruption
			self:StopBar(144758) -- Desecrate
			self:StopBar(67229) -- Mind Control
			self:Bar(147209, 30, CL.count:format(self:SpellName(147209), 1)) -- Malice
			self:Bar("bombardment", 69, CL.count:format(L.bombardment, 1), 147120) -- Bombardment
			self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "boss1")
		elseif spellId == 147126 then -- Clump Check
			self:Bar("clump_check", 3, spellName, spellId)
		end
	end
end

-- General
function mod:UNIT_HEALTH_FREQUENT(unitId)
	if self:MobId(UnitGUID(unitId)) ~= 71865 then return end
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if hp < 16 then -- 10%
		self:Message("stages", "Neutral", "Info", CL.soon:format(CL.phase:format(phase+1)), false)
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1", "boss2", "boss3")
	end
end

do
	local function bossTarget(self, name, guid)
		self:SecondaryIcon(144758, name)
		self:ScheduleTimer("SecondaryIcon", 7, 144758)
		if self:Me(guid) then
			self:Flash(144758)
			self:Say(144758)
		elseif self:Range(name) < 15 then
			self:Flash(144758)
			self:RangeMessage(144758, "Urgent", "Alarm")
			return
		end
		self:TargetMessage(144758, name, "Urgent", "Alarm")
	end

	function mod:Desecrate(args)
		self:GetBossTarget(bossTarget, 1, args.sourceGUID)

		local cd = 40
		if phase == 2 then
			if desecrateCounter > 3 then
				cd = 0 -- Only enough time for 4 in phase 2 between each intermission
			else
				 -- The 3rd Desecrate (during p2 only) always aligns with Whirling and which he casts first seems random.
				 -- Choosing Whirling will delay that Desecrate. We "fix" this by starting a new Desecrate timer in the Whirling function if Whirling arrived first.
				cd = 35
			end
		elseif phase == 3 then
			cd = desecrateCounter == 1 and 34 or 25
		end
		if cd > 0 then
			self:CDBar(144758, cd)
		end
		desecrateCounter = desecrateCounter + 1
	end
end

