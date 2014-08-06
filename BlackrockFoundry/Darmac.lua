
--------------------------------------------------------------------------------
-- Module Declaration
--

if not BigWigs.isWOD then return end -- XXX compat
local mod, CL = BigWigs:NewBoss("Beastlord Darmac", 988, 1122)
if not mod then return end
mod:RegisterEnableMob(76796)
mod.engageId = 1694

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local activatedMounts = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.next_mount = "Mounting soon!"

	L.custom_on_pinned_marker = "Pin Down marker"
	L.custom_on_pinned_marker_desc = "Mark pinned players with {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
	L.custom_on_pinned_marker_icon = 1
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		154960, "custom_on_pinned_marker", 154975,
		{155061, "TANK"}, 155198,
		{155030, "TANK"}, 154989, {154981, "HEALER", "ICON"}, 155499, 155657,
		{155236, "TANK"}, 155222, 155247,
		---9316, -9333, -9334, -9335,
		"stages", "proximity", "berserk", "bosskill",
	}, {
		[154960] = -9298, -- Stage 1
		[155061] = -9301, -- Cruelfang
		[155030] = -9302, -- Dreadwing
		[155236] = -9303, -- Ironcrusher
		--[-9316] = ("%s (%s)"):format(EJ_GetSectionInfo(9304), (GetDifficultyInfo(16))), -- Faultline (Mythic)
		["stages"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")

	-- Stage 1
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2")
	self:Log("SPELL_AURA_APPLIED", "PinDownApplied", 154960)
	self:Log("SPELL_AURA_REMOVED", "PinDownRemoved", 154960)
	self:Log("SPELL_SUMMON", "PinDownSpear", 154956)
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

	-- Stage 3
	self:Log("SPELL_DAMAGE", "ShrapnelDamage", 155499)
	self:Log("SPELL_MISSED", "ShrapnelDamage", 155499)
	self:Log("SPELL_PERIODIC_DAMAGE", "FlameInfusion", 155657)
	self:Log("SPELL_MISSED", "FlameInfusion", 155657)

	self:Death("Deaths", 76884, 76874, 76945) -- Cruelfang, Dreadwing, Ironcrusher
	self:Death("Win", 76796) -- Beastlord Darmac
end

function mod:OnEngage(diff)
	phase = 1
	wipe(activatedMounts)

	self:Bar(154975, 8) -- Call the Pack
	self:Bar(154960, 11) -- Pin Down

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

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	self:CheckBossStatus()
	for i=1, 5 do
		local unit = ("boss%d"):format(i)
		local mobId = self:MobId(UnitGUID(unit))
		if mobId > 0 and mobId ~= 76796 and activatedMounts[mobId] == nil then
			self:StopBar(155061) -- Rend and Tear
			self:StopBar(155222) -- Tantrum
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
				self:CDBar(155247, 15) -- Stampede
				self:CDBar(155222, 30) -- Tantrum
			elseif mobId == 76946 then -- Faultline (Mythic)
				--
			end
		end
	end
end

function mod:Deaths(args)
	if args.mobId == 76884 then -- Cruelfang
		activatedMounts[args.mobId] = false
		self:StopBar(155198) -- Savage Howl

		self:CDBar(155061, 12) -- Rend and Tear
	elseif args.mobId == 76874 then -- Dreadwing
		activatedMounts[args.mobId] = false
		self:StopBar(154981) -- Conflag

		self:CDBar(155499, 15) -- Superheated Shrapnel
	elseif args.mobId == 76945 then -- Ironcrusher
		activatedMounts[args.mobId] = false
		self:StopBar(155247) -- Stampede

		self:CDBar(155222, 23) -- Tantrum
	elseif args.mobId == 76946 then -- Faultline (Mythic)
		activatedMounts[args.mobId] = false
	end
	if activatedMounts[76884] == false then
		openProxitiy()
	else
		self:CloseProximity()
	end
end

function mod:UNIT_HEALTH_FREQUENT(unit)
	if self:MobId(UnitGUID(unit)) == 76796 then
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
		-- Warnings for 85%, 65%, 45%, and 25% for mythic
		if (phase == 1 and hp < 90) or (phase == 2 and hp < 70) or (phase == 3 and hp < 50) or (phase == 4 and hp < 30) then
			phase = phase + 1
			self:Message("stages", "Neutral", "Info", L.next_mount, false)
			if phase > (self:Mythic() and 4 or 3) then
				self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1", "boss2")
			end
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 155365 then -- Pin Down
		self:Message(spellId, "Urgent", "Warning", CL.incoming:format(spellName))
	elseif spellId == 155221 then -- Iron Crusher's Tantrum
		self:Message(155222, "Attention")
		self:CDBar(spellId, 26)
	elseif spellId == 155520 then -- Darmac's Tantrum
		self:Message(155222, "Attention")
		self:CDBar(spellId, 23)
	elseif spellId == 155497 then -- Superheated Shrapnel
		self:Message(155499, "Urgent", nil, CL.incoming:format(spellName))
		self:CDBar(155499, 25)
	end
end

-- Stage 1

do
	local pinnedList, scheduled = mod:NewTargetList(), nil

	-- TODO figure out who got hit and use mouseover marking to mark the spear instead of the players
	local function mark(name, index)
		if mod.db.profile.custom_on_pinned_marker and index < 7 then
			SetRaidTarget(name, index)
		end
	end

	local function warnSpear(spellId)
		if #pinnedList > 0 then
			mod:TargetMessage(spellId, pinnedList, "Important", "Alarm", nil, true)
		else
			mod:Message(spellId, "Attention")
		end
		scheduled = nil
	end

	function mod:PinDownApplied(args)
		pinnedList[#pinnedList+1] = args.destName
		mark(args.destName, #pinnedList)
	end

	function mod:PinDownRemoved(args)
		mark(args.destName, 0)
	end

	function mod:PinDownSpear(args)
		if not scheduled then
			self:CDBar(154960, 20)
			scheduled = self:ScheduleTimer(warnSpear, 0.2, 154960)
		end
	end
end

function mod:CallThePack(args)
	self:Message(args.spellId, "Attention")
	self:CDBar(args.spellId, 20) -- 20-30
end

-- Stage 2

do
	local scheduled = nil
	local function reset() scheduled = nil end

	function mod:RendAndTear(args)
		if self:Tank(args.destName) then
			local amount = args.amount or 1
			self:StackMessage(args.spellId, args.destName, amount, "Attention", amount > 2 and "Warning")
		end
		if not scheduled then
			-- XXX can hit multiple people at staggered times :\ SPELL_CAST_SUCCESS triggers multiple times, too
			self:CDBar(args.spellId, 12) -- 12-16
			scheduled = self:ScheduleTimer(reset, 10)
		end
	end
end

function mod:SavageHowl(args)
	self:Message(args.spellId, "Important", self:Dispeller("ENRAGE", true) and "Alert")
	self:Bar(args.spellId, 26)
end

function mod:InfernoBreath(args)
	self:Message(args.spellId, "Urgent", nil, CL.incoming(args.spellName))
end

do
	local prev = 0
	function mod:InfernoBreathDamage(args)
		local t = GetTime()
		if t-prev > 3 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

do
	local conflagList, conflagMarks, scheduled = mod:NewTargetList(), {}, nil
	
	local function warnConflag(spellId)
		mod:PrimaryIcon(spellId, conflagMarks[1])
		conflagList[1] = conflagMarks[1]
		if conflagMarks[2] then
			mod:SecondaryIcon(spellId, conflagMarks[2])
			conflagList[2] = conflagMarks[2]
		end
		mod:TargetMessage(spellId, conflagList, "Urgent", mod:Dispeller("MAGIC") and "Alert")
		scheduled = nil
	end

	function mod:ConflagrationApplied(args)
		conflagMarks[#conflagMarks+1] = args.destName
		if not scheduled then
			self:Bar(args.spellId, 20)
			scheduled = self:ScheduleTimer(warnConflag, 0.1, args.spellId)
		end
	end

	function mod:ConflagrationRemoved(args)
		if args.destName == conflagMarks[1] then
			self:PrimaryIcon(args.spellId)
			conflagMarks[1] = nil
		elseif args.destName == conflagMarks[2] then
			mod:SecondaryIcon(args.spellId, conflagMarks[2])
			conflagMarks[2] = nil
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
	self:Bar(args.spellId, 20)
end

function mod:CrushArmor(args)
	local amount = args.amount or 1
	if amount % 2 == 0 then
		self:StackMessage(args.spellId, args.destName, amount, "Attention", amount > 2 and "Warning")
	end
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
	function mod:FlameInfusion(args)
		local t = GetTime()
		if t-prev > 3 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

