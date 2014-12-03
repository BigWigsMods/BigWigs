
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Beastlord Darmac", 988, 1122)
if not mod then return end
mod:RegisterEnableMob(76865)
mod.engageId = 1694

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local tantrumCount = 1
local activatedMounts, currentBosses = {}, {}
local spearList, marksUsed, markTimer = {}, {}, nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.next_mount = "Mounting soon!"

	L.custom_off_pinned_marker = "Pin Down marker"
	L.custom_off_pinned_marker_desc = "Mark pinning spears with {rt8}{rt7}{rt6}{rt5}{rt4}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, quickly mousing over the spears is the fastest way to mark them.|r"
	L.custom_off_pinned_marker_icon = 8

	L.custom_off_conflag_marker = "Conflagration marker"
	L.custom_off_conflag_marker_desc = "Mark conflagration targets with {rt1}{rt2}{rt3}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
	L.custom_off_conflag_marker_icon = 1
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{154960, "SAY"}, "custom_off_pinned_marker", 154975,
		{155061, "TANK"}, 155198,
		{155030, "TANK"}, {154989, "FLASH"}, {154981, "HEALER"}, "custom_off_conflag_marker", 155499, 155657,
		{155236, "TANK"}, 155222, 155247,
		155284, 159044, 155826,
		"stages", "proximity", "berserk", "bosskill",
	}, {
		[154960] = -9298, -- Stage 1
		[155061] = -9301, -- Cruelfang
		[155030] = -9302, -- Dreadwing
		[155236] = -9303, -- Ironcrusher
		[155284] = ("%s (%s)"):format(self:SpellName(-9304), CL.mythic), -- Faultline (Mythic)
		["stages"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")

	-- Stage 1
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2")
	self:Log("SPELL_AURA_APPLIED", "PinnedDown", 154960)
	self:Log("SPELL_SUMMON", "SpearSummon", 154956)
	self:Log("SPELL_CAST_START", "CallThePack", 154975)

	-- Stage 2
	-- Cruelfang
	self:Log("SPELL_AURA_APPLIED", "RendAndTear", 155061)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RendAndTear", 155061)
	self:Log("SPELL_CAST_START", "SavageHowl", 155198)
	-- Dreadwing
	self:Emote("InfernoBreath", "154989")
	self:Log("SPELL_DAMAGE", "InfernoBreathDamage", 154989)
	self:Log("SPELL_MISSED", "InfernoBreathDamage", 154989)
	self:Log("SPELL_AURA_APPLIED", "ConflagrationApplied", 154981)
	self:Log("SPELL_AURA_REMOVED", "ConflagrationRemoved", 154981)
	self:Log("SPELL_AURA_APPLIED", "SearedFlesh", 155030)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SearedFlesh", 155030)
	-- Ironcrusher
	self:Log("SPELL_CAST_SUCCESS", "Stampede", 155247)
	self:Log("SPELL_AURA_APPLIED", "CrushArmor", 155236)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CrushArmor", 155236)
	-- Faultline
	self:Log("SPELL_CAST_START", "CannonballBarrage", 155284)
	--self:Log("SPELL_CAST_SUCCESS", "Epicenter", 159044, 162277)
	self:Log("SPELL_PERIODIC_DAMAGE", "EpicenterDamage", 159044, 162277)
	self:Log("SPELL_PERIODIC_MISSED", "EpicenterDamage", 159044, 162277)
	--self:Log("SPELL_CAST_SUCCESS", "Unsteady", 155826, 162276)

	-- Stage 3
	self:Log("SPELL_DAMAGE", "ShrapnelDamage", 155499)
	self:Log("SPELL_MISSED", "ShrapnelDamage", 155499)
	self:Log("SPELL_PERIODIC_DAMAGE", "FlameInfusionDamage", 155657)
	self:Log("SPELL_PERIODIC_MISSED", "FlameInfusionDamage", 155657)

	self:Death("SpearDeath", 76796) -- Heavy Spear
	self:Death("Deaths", 76884, 76874, 76945, 76946) -- Cruelfang, Dreadwing, Ironcrusher, Faultline
end

function mod:OnEngage(diff)
	phase = 1
	wipe(activatedMounts)
	wipe(spearList)
	wipe(marksUsed)
	markTimer = nil

	self:Bar(154975, 8) -- Call the Pack
	self:Bar(154960, 11) -- Pin Down

	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1", "boss2")
	if self.db.profile.custom_off_pinned_marker then
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function openProxitiy()
	if mod:Healer() or mod:Damager() == "RANGED" then
		mod:OpenProximity("proximity", 8)
	end
end

local function deactivateMount(mobId)
	if mobId == 76884 then -- Cruelfang
		activatedMounts[mobId] = false
		mod:StopBar(155198) -- Savage Howl

		mod:CDBar(155061, 12) -- Rend and Tear
	elseif mobId == 76874 then -- Dreadwing
		activatedMounts[mobId] = false
		mod:StopBar(154981) -- Conflag

		mod:CDBar(155499, 15) -- Superheated Shrapnel
	elseif mobId == 76945 then -- Ironcrusher
		activatedMounts[mobId] = false
		mod:StopBar(155247) -- Stampede

		tantrumCount = 1
		mod:CDBar(155222, 23, CL.count:format(mod:SpellName(155222), tantrumCount)) -- Tantrum
	elseif mobId == 76946 then -- Faultline (Mythic)
		activatedMounts[mobId] = false
	end
	if activatedMounts[76884] == false then
		openProxitiy()
	else
		mod:CloseProximity()
	end
end

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	self:CheckForEncounterEngage()
	wipe(currentBosses)
	for i=1, 5 do
		local unit = ("boss%d"):format(i)
		local mobId = self:MobId(UnitGUID(unit))
		if mobId > 0 and mobId ~= 76865 then
			currentBosses[mobId] = true
			if activatedMounts[mobId] == nil then
				self:StopBar(155061) -- Rend and Tear
				self:StopBar(CL.count:format(self:SpellName(155222), tantrumCount)) -- Tantrum
				self:StopBar(155499) -- Superheated Shrapnel
				self:CloseProximity()

				activatedMounts[mobId] = true
				self:Message("stages", "Neutral", "Info", (UnitName(unit)), false)

				if mobId == 76884 then -- Cruelfang
					self:CDBar(155061, 13) -- Rend and Tear
					self:CDBar(155198, 17) -- Savage Howl
					openProxitiy()
				elseif mobId == 76874 then -- Dreadwing
					self:CDBar(154981, 12) -- Conflag
				elseif mobId == 76945 then -- Ironcrusher
					tantrumCount = 1
					self:CDBar(155247, 15) -- Stampede
					self:CDBar(155222, 30, CL.count:format(self:SpellName(155222), tantrumCount)) -- Tantrum
				elseif mobId == 76946 then -- Faultline (Mythic)
					--
				end
			end
		end
	end
	-- Darmac dismounts at 40% in Mythic
	if self:Mythic() then
		for mobId, active in next, activatedMounts do
			if active and not currentBosses[mobId] then
				deactivateMount(mobId)
			end
		end
	end
end

function mod:Deaths(args)
	deactivateMount(args.mobId)
end

function mod:UNIT_HEALTH_FREQUENT(unit)
	if self:MobId(UnitGUID(unit)) == 76865 then
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
		-- Warnings for 85%, 65%, 45%, and 25% for mythic
		if (phase == 1 and hp < 90) or (phase == 2 and hp < 70) or (phase == 3 and hp < 50) or (phase == 4 and hp < 30) then
			phase = phase + 1
			if phase > (self:Mythic() and 4 or 3) then
				self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1", "boss2")
			end
			self:Message("stages", "Neutral", "Info", L.next_mount, false)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 155365 then -- Pin Down
		self:Message(154960, "Urgent", "Warning", CL.incoming:format(spellName))
	elseif spellId == 155221 then -- Iron Crusher's Tantrum
		self:Message(155222, "Attention", nil, CL.count:format(spellName, tantrumCount))
		tantrumCount = tantrumCount + 1
		self:CDBar(155222, 26, CL.count:format(spellName, tantrumCount))
	elseif spellId == 155520 then -- Darmac's Tantrum
		self:Message(155222, "Attention", nil, CL.count:format(spellName, tantrumCount))
		tantrumCount = tantrumCount + 1
		self:CDBar(155222, 23, CL.count:format(spellName, tantrumCount))
	elseif spellId == 155497 then -- Superheated Shrapnel
		self:Message(155499, "Urgent")
		self:CDBar(155499, 25)
	elseif spellId == 159044 or spellId == 162277 then -- Epicenter (Faultline/Darmac)
		self:Message(159044, "Attention")
	elseif spellId == 155826 or spellId == 162276 then -- Unsteady (Faultline/Darmac)
		self:Message(155826, "Attention")
	end
end

-- Stage 1

do
	-- spear marking
	local function mark(unit, guid)
		for mark=8, 4, -1 do
			if not marksUsed[mark] then
				SetRaidTarget(unit, mark)
				spearList[guid] = mark
				marksUsed[mark] = guid
				return
			end
		end
	end

	local function markSpears()
		local continue = nil
		for guid, m in next, spearList do
			if m == true then
				local unit = mod:GetUnitIdByGUID(guid)
				if unit then
					mark(unit, guid)
				else
					continue = true
				end
			end
		end
		if not continue or not mod.db.profile.custom_off_pinned_marker then
			mod:CancelTimer(markTimer)
			markTimer = nil
		end
	end

	function mod:UPDATE_MOUSEOVER_UNIT()
		local guid = UnitGUID("mouseover")
		if guid and spearList[guid] == true then
			mark("mouseover", guid)
		end
	end

	function mod:SpearDeath(args)
		local mark = spearList[args.destGUID]
		if mark then
			marksUsed[mark] = nil
			spearList[args.destGUID] = nil
		end
	end

	local pinnedList, scheduled = mod:NewTargetList(), nil
	local function warnSpear(spellId)
		if #pinnedList > 0 then
			mod:TargetMessage(spellId, pinnedList, "Important", "Alarm", nil, nil, true)
		end
		scheduled = nil
	end

	function mod:PinnedDown(args)
		pinnedList[#pinnedList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId, 155365) -- Pin Down
		end
		if not spearList[args.sourceGUID] then
			spearList[args.sourceGUID] = true
			if self.db.profile.custom_off_pinned_marker and not markTimer then
				markTimer = self:ScheduleRepeatingTimer(markSpears, 0.2)
			end
		end
	end

	function mod:SpearSummon(args)
		if not scheduled then
			self:CDBar(154960, 20)
			scheduled = self:ScheduleTimer(warnSpear, 0.2, 154960)
		end
	end
end

function mod:CallThePack(args)
	self:Message(args.spellId, "Attention")
	self:CDBar(args.spellId, 31.5) -- can be delayed
end

-- Stage 2

do
	local prev = 0
	function mod:RendAndTear(args)
		if self:Tank(args.destName) then
			local amount = args.amount or 1
			self:StackMessage(args.spellId, args.destName, amount, "Attention", amount > 2 and "Warning")
		end
		local t = GetTime()
		if t-prev > 10 then -- XXX can hit multiple people at staggered times
			self:CDBar(args.spellId, 12) -- 12-16
			prev = t
		end
	end
end

function mod:SavageHowl(args)
	self:Message(args.spellId, "Important", self:Dispeller("ENRAGE", true) and "Alert")
	self:Bar(args.spellId, 26)
end

function mod:InfernoBreath()
	self:Message(154989, "Urgent", "Alert", CL.incoming:format(self:SpellName(154989)))
end

do
	local prev = 0
	function mod:InfernoBreathDamage(args)
		local t = GetTime()
		if t-prev > 3 and self:Me(args.destGUID) then
			self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
			self:Flash(args.spellId)
			prev = t
		end
	end
end

do
	local conflagList, conflagMark, scheduled = mod:NewTargetList(), 8, nil

	local function warnConflag(spellId)
		mod:TargetMessage(spellId, conflagList, "Urgent", mod:Dispeller("magic") and "Info")
		scheduled = nil
	end

	function mod:ConflagrationApplied(args)
		conflagList[#conflagList+1] = args.destName
		if not scheduled then
			conflagMark = 1
			self:Bar(args.spellId, 20)
			scheduled = self:ScheduleTimer(warnConflag, 0.1, args.spellId)
		end
		if self.db.profile.custom_off_conflag_marker and conflagMark < 4 then
			SetRaidTarget(args.destName, conflagMark)
			conflagMark = conflagMark + 1
		end
	end

	function mod:ConflagrationRemoved(args)
		if self.db.profile.custom_off_conflag_marker then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:SearedFlesh(args)
	local amount = args.amount or 1
	if amount % 3 == 0 then
		self:StackMessage(args.spellId, args.destName, amount, "Attention", amount > 5 and "Warning")
	end
end

function mod:Stampede(args)
	self:Message(args.spellId, "Attention")
	self:CDBar(args.spellId, 20)
end

function mod:CrushArmor(args)
	local amount = args.amount or 1
	if amount % 2 == 0 then
		self:StackMessage(args.spellId, args.destName, amount, "Attention", amount > 2 and "Warning")
	end
end

function mod:CannonballBarrage(args)
	self:Message(args.spellId, "Urgent", "Alarm")
end

do
	local prev = 0
	function mod:EpicenterDamage(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then
			self:Message(159044, "Personal", "Alarm", CL.underyou:format(args.spellName))
			prev = t
		end
	end
end

-- Stage 3

do
	local prev = 0
	function mod:ShrapnelDamage(args)
		local t = GetTime()
		if t-prev > 3 and self:Me(args.destGUID) then
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
			prev = t
		end
	end
end

do
	local prev = 0
	function mod:FlameInfusionDamage(args)
		local t = GetTime()
		if t-prev > 3 and self:Me(args.destGUID) then
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
			prev = t
		end
	end
end

