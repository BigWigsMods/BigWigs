
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
		--[[ Cruelfang ]]--
		{155061, "TANK"}, -- Rend and Tear
		155198, -- Savage Howl
		--[[ Dreadwing ]]--
		{155030, "TANK"}, -- Seared Flesh
		{154989, "FLASH"}, -- Inferno Breath
		{154981, "HEALER"}, -- Conflagration
		"custom_off_conflag_marker",
		155499, -- Shrapnel
		155657, -- Flame Infusion
		--[[ Ironcrusher ]]--
		{155236, "TANK"}, -- Crush Armor
		155222, -- Tantrum
		155247, -- Stampede
		--[[ Faultline (Mythic) ]]--
		159043, -- Epicenter
		155321, -- Unstoppable
		--[[ General ]]--
		{154960, "SAY"}, -- Pinned Down
		"custom_off_pinned_marker",
		154975, -- Call the Pack
		"stages",
		"proximity",
		"berserk",
		"bosskill",
	}, {
		[155061] = -9301, -- Cruelfang
		[155030] = -9302, -- Dreadwing
		[155236] = -9303, -- Ironcrusher
		[155284] = ("%s (%s)"):format(self:SpellName(-9304), CL.mythic), -- Faultline (Mythic)
		[154960] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")

	-- Stage 1
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2")
	self:Log("SPELL_AURA_APPLIED", "PinnedDown", 154960)
	self:Log("SPELL_SUMMON", "SpearSummon", 154956) -- no cast event, so I choose you!
	self:Log("SPELL_CAST_START", "CallThePack", 154975)

	-- Stage 2
	-- Cruelfang
	self:Log("SPELL_AURA_APPLIED", "RendAndTear", 155061, 162283)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RendAndTear", 155061, 162283)
	self:Log("SPELL_CAST_START", "SavageHowl", 155198)
	-- Dreadwing
	self:Emote("InfernoBreath", "154989")
	self:Log("SPELL_DAMAGE", "InfernoBreathDamage", 154989)
	self:Log("SPELL_MISSED", "InfernoBreathDamage", 154989)
	self:Log("SPELL_AURA_APPLIED", "ConflagrationApplied", 154981)
	self:Log("SPELL_AURA_REMOVED", "ConflagrationRemoved", 154981)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SearedFlesh", 155030)
	-- Ironcrusher
	self:Log("SPELL_CAST_SUCCESS", "Stampede", 155247)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CrushArmor", 155236)
	-- Faultline
	self:Log("SPELL_CAST_START", "Epicenter", 159043, 159045)
	self:Log("SPELL_PERIODIC_DAMAGE", "EpicenterDamage", 159044, 162277)
	self:Log("SPELL_PERIODIC_MISSED", "EpicenterDamage", 159044, 162277)
	self:Log("SPELL_AURA_APPLIED", "Unstoppable", 155321)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Unstoppable", 155321)

	-- Stage 3
	self:Log("SPELL_DAMAGE", "ShrapnelDamage", 155499)
	self:Log("SPELL_MISSED", "ShrapnelDamage", 155499)
	self:Log("SPELL_PERIODIC_DAMAGE", "FlameInfusionDamage", 155657)
	self:Log("SPELL_PERIODIC_MISSED", "FlameInfusionDamage", 155657)

	self:Death("Deaths", 76884, 76874, 76945, 76946) -- Cruelfang, Dreadwing, Ironcrusher, Faultline
end

function mod:OnEngage(diff)
	phase = 1
	wipe(activatedMounts)
	wipe(spearList)
	markTimer = nil

	self:Bar(154975, 8) -- Call the Pack
	self:Bar(154960, 11) -- Pin Down
	self:Berserk(720)

	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1", "boss2")
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
		mod:StopBar(154989)

		mod:CDBar(155499, 15) -- Superheated Shrapnel
	elseif mobId == 76945 then -- Ironcrusher
		activatedMounts[mobId] = false
		mod:StopBar(155247) -- Stampede

		--tantrumCount = 1
		mod:CDBar(155222, 23, CL.count:format(mod:SpellName(155222), tantrumCount)) -- Tantrum
	elseif mobId == 76946 then -- Faultline (Mythic)
		activatedMounts[mobId] = false
		mod:StopBar(159043) -- Epicenter

		mod:CDBar(155321, 12) -- Unstoppable
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
		if mobId > 1 and mobId ~= 76865 then
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
					self:CDBar(155222, 25, CL.count:format(self:SpellName(155222), tantrumCount)) -- Tantrum
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
		self:Message(154960, "Urgent", (self:Healer() or self:Damager() == "RANGED") and "Warning", CL.incoming:format(spellName))
	elseif spellId == 155221 then -- Iron Crusher's Tantrum
		self:StopBar(CL.count:format(spellName, tantrumCount))
		self:Message(155222, "Attention", nil, CL.count:format(spellName, tantrumCount))
		tantrumCount = tantrumCount + 1
		self:CDBar(155222, 23, CL.count:format(spellName, tantrumCount))
	elseif spellId == 155520 then -- Darmac's Tantrum
		self:StopBar(CL.count:format(spellName, tantrumCount))
		self:Message(155222, "Attention", nil, CL.count:format(spellName, tantrumCount))
		tantrumCount = tantrumCount + 1
		self:CDBar(155222, 23, CL.count:format(spellName, tantrumCount))
	elseif spellId == 155497 then -- Superheated Shrapnel
		self:Message(155499, "Urgent")
		self:CDBar(155499, 25)
	end
end

-- Stage 1

do
	-- spear marking
	function mod:UNIT_TARGET(_, firedUnit)
		local unit = firedUnit and firedUnit.."target" or "mouseover"
		local guid = UnitGUID(unit)
		if spearList[guid] then
			for i = 8, 4, -1 do
				if not marksUsed[i] then
					SetRaidTarget(unit, i)
					spearList[guid] = nil
					marksUsed[i] = guid
					if not next(spearList) then
						self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
						self:UnregisterEvent("UNIT_TARGET")
					end
					return
				end
			end
		end
	end

	local pinnedList, scheduled = mod:NewTargetList(), nil
	local function warnSpear(self, spellId)
		if #pinnedList > 0 then
			self:TargetMessage(spellId, pinnedList, "Important", "Alarm", nil, nil, true)
		end
		if self.db.profile.custom_off_pinned_marker then
			wipe(marksUsed)
			self:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "UNIT_TARGET")
			self:RegisterEvent("UNIT_TARGET")
		end
		scheduled = nil
	end

	function mod:PinnedDown(args)
		pinnedList[#pinnedList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId, 155365) -- Pin Down
		end
		if self.db.profile.custom_off_pinned_marker and not spearList[args.sourceGUID] then
			spearList[args.sourceGUID] = true
		end
	end

	function mod:SpearSummon(args)
		if not scheduled then
			self:CDBar(154960, 20)
			scheduled = self:ScheduleTimer(warnSpear, 0.1, self, 154960)
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
			self:StackMessage(155061, args.destName, amount, "Attention", amount > 2 and "Warning")
		end
		local t = GetTime()
		if t-prev > 10 then -- XXX can hit multiple people at staggered times
			prev = t
			self:CDBar(155061, 12) -- 12-16
		end
	end
end

function mod:SavageHowl(args)
	self:Message(args.spellId, "Important", self:Dispeller("enrage", true) and "Alert")
	self:Bar(args.spellId, 26)
end

function mod:InfernoBreath()
	self:Message(154989, "Urgent", "Alert", self:SpellName(154989))
	self:CDBar(154989, 20)
end

do
	local prev = 0
	function mod:InfernoBreathDamage(args)
		local t = GetTime()
		if t-prev > 3 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

do
	local conflagList, conflagMark, scheduled = mod:NewTargetList(), 8, nil
	local function warnConflag(self, spellId)
		self:TargetMessage(spellId, conflagList, "Urgent", self:Dispeller("magic") and "Info")
		scheduled = nil
	end

	function mod:ConflagrationApplied(args)
		conflagList[#conflagList+1] = args.destName
		if not scheduled then
			conflagMark = 1
			self:Bar(args.spellId, 20)
			scheduled = self:ScheduleTimer(warnConflag, 0.1, self, args.spellId)
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
	if args.amount % 3 == 0 then
		self:StackMessage(args.spellId, args.destName, args.amount, "Attention", args.amount > 8 and "Warning")
	end
end

function mod:Stampede(args)
	self:Message(args.spellId, "Attention")
	self:CDBar(args.spellId, 20)
end

function mod:CrushArmor(args)
	if args.amount % 2 == 0 then
		self:StackMessage(args.spellId, args.destName, args.amount, "Attention", args.amount > 2 and "Warning")
	end
end

function mod:Epicenter(args)
	self:Message(159043, "Urgent")
	self:CDBar(159043, 19)
end

do
	local prev = 0
	function mod:EpicenterDamage(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then
			prev = t
			self:Message(159043, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

function mod:Unstoppable(args)
	self:Message(args.spellId, "Attention", nil, CL.count:format(args.spellName, args.amount or 1))
	self:Bar(args.spellId, 15)
end

-- Stage 3

do
	local prev = 0
	function mod:ShrapnelDamage(args)
		local t = GetTime()
		if t-prev > 3 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

do
	local prev = 0
	function mod:FlameInfusionDamage(args)
		local t = GetTime()
		if t-prev > 3 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

