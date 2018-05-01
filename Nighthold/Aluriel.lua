
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Spellblade Aluriel", 1530, 1751)
if not mod then return end
mod:RegisterEnableMob(104881)
mod.engageId = 1871
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local heroicTimers = {
	-- Annihilate
	[212492] = {8, 45, 40, 44, 38, 37, 33, 47, 41, 44, 38, 37},
}
local mythicTimers = {
	-- Annihilate
	[212492] = {8, 45, 30, 37, 35, 43, 27, 37, 41, 37, 35, 43, 27},

	-- Fel Lash
	[230403] = {5.5, 11, 6, 12, 6},
}
local timers = mod:Mythic() and mythicTimers or heroicTimers
local phase = 0 -- will immediately get incremented by mod:Stages()
local annihilateCount = 1
local felLashCount = 1
local searingBrandTargets = {}
local markOfFrostTargets = {}
local proxList = {} -- Mark of Frost and Searing Brand
local frostbittenStacks = {}
local mobCollector = {}
local isInfoOpen = false
local markOfFrostOnMe = nil
local searingBrandOnMe = nil

--------------------------------------------------------------------------------
-- Upvalues
--

local tDeleteItem, tContains = tDeleteItem, tContains

--------------------------------------------------------------------------------
-- Initialization
--

local searingBrandMarker = mod:AddMarkerOption(false, "player", 1, 213166, 1, 2, 3, 4, 5, 6)
local fieryAddMarker = mod:AddMarkerOption(false, "npc", 1, 213867, 1, 2, 3, 4, 5, 6)
function mod:GetOptions()
	return {
		--[[ General ]]--
		{212492, "TANK_HEALER"}, -- Annihilate
		"stages",
		"berserk",

		--[[ Master of Frost ]]--
		{212531, "SAY", "FLASH"}, -- Pre Mark of Frost
		{212587, "SAY", "FLASH", "PROXIMITY"}, -- Mark of Frost
		{212647, "INFOBOX"}, -- Frostbitten
		212530, -- Replicate: Mark of Frost
		{212735, "SAY"}, -- Detonate: Mark of Frost
		213853, -- Animate: Mark of Frost"
		213083, -- Frozen Tempest
		212736, -- Pool of Frost

		--[[ Master of Fire ]]--
		{213148, "SAY"}, -- Pre Searing Brand
		{213166, "PROXIMITY"}, -- Searing Brand
		searingBrandMarker,
		{213275, "SAY"}, -- Detonate: Searing Brand
		213567, -- Animate: Searing Brand
		fieryAddMarker,
		213278, -- Burning Ground

		--[[ Master of the Arcane ]]--
		213520, -- Arcane Orb
		213852, -- Replicate: Arcane Orb
		213390, -- Detonate: Arcane Orb
		213564, -- Animate: Arcane Orb
		213569, -- Armageddon
		213504, -- Arcane Fog

		--[[ Mythic ]]--
		230901, -- Fel Soul
		{230504, "TANK"}, -- Decimate
		230414, -- Fel Stomp
		230403, -- Fel Lash
	}, {
		[212492] = "general",
		[212531] = -13376, -- Master of Frost
		[213148] = -13379, -- Master of Fire
		[213520] = -13380, -- Master of the Arcane
		[230901] = "mythic",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	--[[ General ]]--
	self:Log("SPELL_CAST_START", "AnnihilateCast", 212492)
	self:Log("SPELL_AURA_APPLIED", "AnnihilateApplied", 215458)
	self:Log("SPELL_AURA_APPLIED_DOSE", "AnnihilateApplied", 215458)
	self:Log("SPELL_AURA_APPLIED", "Stages", 216389, 213867, 213869, 213864) -- Icy / Fiery / Magic / Icy² Enchantment

	--[[ Master of Frost ]]--
	self:Log("SPELL_AURA_APPLIED", "PreMarkOfFrostApplied", 212531)
	self:Log("SPELL_AURA_APPLIED", "MarkOfFrostApplied", 212587)
	self:Log("SPELL_AURA_REMOVED", "MarkOfFrostRemoved", 212587)
	self:Log("SPELL_AURA_APPLIED", "Frostbitten", 212647)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Frostbitten", 212647)
	self:Log("SPELL_CAST_START", "ReplicateMarkOfFrost", 212530)
	self:Log("SPELL_CAST_START", "DetonateMarkOfFrost", 212735) -- Detonate: Mark of Frost
	self:Log("SPELL_CAST_START", "AnimateMarkOfFrost", 213853)
	self:Log("SPELL_CAST_START", "FrozenTempest", 213083)
	self:Death("IcyEnchantmentDeath", 107237)

	--[[ Master of Fire ]]--
	self:Log("SPELL_AURA_APPLIED", "PreSearingBrandApplied", 213148)
	self:Log("SPELL_AURA_APPLIED", "SearingBrandApplied", 213166)
	self:Log("SPELL_AURA_REMOVED", "SearingBrandRemoved", 213166)
	self:Log("SPELL_CAST_START", "DetonateSearingBrand", 213275) -- Detonate: Searing Brand
	self:Log("SPELL_CAST_SUCCESS", "DetonateSearingBrandSuccess", 213275)
	self:Log("SPELL_CAST_START", "AnimateSearingBrand", 213567)

	--[[ Master of the Arcane ]]--
	self:Log("SPELL_CAST_START", "ReplicateArcaneOrb", 213852)
	self:Log("SPELL_CAST_START", "AnimateArcaneOrb", 213564)
	self:Log("SPELL_AURA_APPLIED", "Armageddon", 213569)

	--[[ Mythic ]]--
	self:Log("SPELL_CAST_SUCCESS", "SeveredSoul", 230951)
	self:Log("SPELL_AURA_REMOVED", "SeveredSoulRemoved", 230951)
	self:Log("SPELL_CAST_START", "Decimate", 230504)
	self:Log("SPELL_CAST_SUCCESS", "FelLash", 230403)

	--[[ Many ground effects, handle it! ]]--
	self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", 212736, 213278, 213504, 230414) -- Pool of Frost / Burning Ground / Arcane Fog / Fel Stomp
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffectDamage", 212736, 213278, 213504, 230414)
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffectDamage", 212736, 213278, 213504, 230414)
	self:Log("SPELL_DAMAGE", "GroundEffectDamage", 213520) -- Arcane Orb
	self:Log("SPELL_MISSED", "GroundEffectDamage", 213520)
end

function mod:OnEngage()
	phase = 0 -- will immediately get incremented by mod:Stages()
	annihilateCount = 1
	isInfoOpen = false
	wipe(searingBrandTargets)
	wipe(markOfFrostTargets)
	wipe(frostbittenStacks)
	wipe(mobCollector)
	wipe(proxList)
	markOfFrostOnMe = nil
	searingBrandOnMe = nil

	timers = self:Mythic() and mythicTimers or heroicTimers
	self:Bar(212492, timers[212492][annihilateCount]) -- Annihilate
	-- other bars are in mod:Stages()

	if self:Normal() then
		self:Berserk(645)
	elseif self:Heroic() then
		self:Berserk(490)
	elseif self:Mythic() then
		self:Berserk(450)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function updateProximity(self)
	local showMark = self:CheckOption(212587, "PROXIMITY") -- Mark of Frost Radius: 8 yards
	local showBrand = self:CheckOption(213166, "PROXIMITY") -- Searing Brand http://www.wowhead.com/spell=213276 Radius: 10 yards
	if showMark and markOfFrostOnMe then
		self:OpenProximity(212587, 8)
	elseif showBrand and searingBrandOnMe then
		self:OpenProximity(213166, 10)
	elseif showMark and showBrand and #markOfFrostTargets > 0 and #searingBrandTargets > 0 then
		self:OpenProximity(213166, 10, proxList)
	elseif showMark and #markOfFrostTargets > 0 then
		self:OpenProximity(212587, 8, markOfFrostTargets)
	elseif showBrand and #searingBrandTargets > 0 then
		self:OpenProximity(213166, 10, searingBrandTargets)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
	if spellId == 215455 then -- Arcane Orb
		self:Message(213520, "Important")
	elseif spellId == 213390 then -- Detonate: Arcane Orb
		self:Message(spellId, "Important", "Alarm")
	end
end

--[[ General ]]--
function mod:AnnihilateCast(args)
	self:Message(args.spellId, "Important", self:Tank() and "Alarm", CL.casting:format(CL.count:format(args.spellName, annihilateCount)))
	self:StopBar(CL.count:format(args.spellName, annihilateCount))
	self:CastBar(args.spellId, 7, CL.count:format(args.spellName, annihilateCount))
	annihilateCount = annihilateCount + 1
	self:Bar(args.spellId, timers[args.spellId][annihilateCount] or 37, CL.count:format(args.spellName, annihilateCount))
end

function mod:AnnihilateApplied(args)
	if self:Tank() then
		local amount = args.amount or 1
		self:StackMessage(212492, args.destName, amount, "Important", amount > 1 and "Warning") -- check sound amount
	end
end

do
	function mod:Stages(args)
		phase = phase + 1
		self:Message("stages", "Neutral", "Long", args.spellName, args.spellId)

		if args.spellId == 216389 then -- Icy
			if self:Mythic() then -- Fel Soul
				self:Bar(230901, 18)
			end
			self:Bar(212587, 18) -- Mark of Frost (timer is the "pre" mark of frost aura applied)
			self:Bar(212530, self:Mythic() and 28 or 41) -- Replicate: Mark of Frost
			self:Bar(212735, self:Mythic() and 48 or 71) -- Detonate: Mark of Frost
			self:Bar(213853, self:Mythic() and 65 or 75, nil, 31687) -- Animate: Mark of Frost, Water Elemental icon
			self:Bar("stages", self:Mythic() and 75 or 85, self:SpellName(213867), 213867) -- Next: Fiery
		elseif args.spellId == 213864 then -- Icy after the first one, different timers in mythic
			if self:Mythic() then -- Fel Soul
				self:Bar(230901, 15)
			end
			self:Bar(212587, 2) -- Mark of Frost (timer is the "pre" mark of frost aura applied)
			self:Bar(212530, 15) -- Replicate: Mark of Frost
			self:Bar(212735, self:Mythic() and 35 or 45) -- Detonate: Mark of Frost
			self:Bar(213853, self:Mythic() and 52 or 62, nil, 31687) -- Animate: Mark of Frost, Water Elemental icon
			self:Bar("stages", self:Mythic() and 75 or 85, self:SpellName(213867), 213867) -- Next: Fiery
		elseif args.spellId == 213867 then -- Fiery
			wipe(searingBrandTargets)
			if self:Mythic() then -- Fel Soul
				self:Bar(230901, 18)
			end
			self:Bar(213166, 18) -- Searing Brand
			self:Bar(213275, self:Mythic() and 40 or 48) -- Detonate: Searing Brand
			self:Bar(213567, self:Mythic() and 55 or 65) -- Animate: Searing Brand
			self:Bar("stages", self:Mythic() and 75 or 85, self:SpellName(213869), 213869) -- Next: Magic
		else -- Magic
			if self:Mythic() then -- Fel Soul
				self:Bar(230901, 15)
			end
			self:Bar(213852, self:Mythic() and 15 or 16) -- Replicate: Arcane Orb
			self:Bar(213390, 38) -- Detonate: Arcane Orb
			self:Bar(213564, 55) -- Animate: Arcane Orb
			self:Bar("stages", 70, self:SpellName(216389), 216389) -- Next: Frost
		end
	end
end

--[[ Master of Frost ]]--
do
	local preDebuffApplied = 0
	-- The "pre" and actual debuffs for Mark of Frost and Searing Brand are separate
	-- because of customization (emphasize and stuff).
	function mod:PreMarkOfFrostApplied(args)
		if self:Me(args.destGUID) then
			preDebuffApplied = GetTime()
			self:TargetMessage(args.spellId, args.destName, "Attention", "Alert")
			self:Say(args.spellId)
			self:Flash(args.spellId)
			markOfFrostOnMe = true
		end

		if not tContains(markOfFrostTargets, args.destName) then
			markOfFrostTargets[#markOfFrostTargets+1] = args.destName
		end

		if not tContains(proxList, args.destName) then
			proxList[#proxList+1] = args.destName
		end

		updateProximity(self)
	end

	local list = mod:NewTargetList()
	function mod:MarkOfFrostApplied(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 1, args.spellId, list, "Urgent")
		end

		if self:Me(args.destGUID) then
			markOfFrostOnMe = true
			local t = GetTime()
			if t-preDebuffApplied > 5.5 then
				self:TargetMessage(args.spellId, args.destName, "Attention", "Alert")
				self:Say(args.spellId)
				self:Flash(args.spellId)
			end
		end

		if not tContains(markOfFrostTargets, args.destName) then
			markOfFrostTargets[#markOfFrostTargets+1] = args.destName
		end

		if not tContains(proxList, args.destName) then
			proxList[#proxList+1] = args.destName
		end

		updateProximity(self)
	end
end

function mod:MarkOfFrostRemoved(args)
	if self:Me(args.destGUID) then
		markOfFrostOnMe = nil
	end

	tDeleteItem(markOfFrostTargets, args.destName)
	tDeleteItem(proxList, args.destName)

	if #markOfFrostTargets == 0 then
		self:CloseProximity(args.spellId)
	end

	updateProximity(self)

	-- Mark of Frost is removed immediately, Frostbitten waits until the debuff expires, use the former for a clearer infobox.
	frostbittenStacks[args.destName] = nil
	if next(frostbittenStacks) then
		self:SetInfoByTable(212647, frostbittenStacks)
	elseif isInfoOpen then
		isInfoOpen = false
		self:CloseInfo(212647)
	end
end

function mod:Frostbitten(args)
	local amount = args.amount or 1
	if self:Me(args.destGUID) and amount % 2 == 0 and amount > 5 then
		self:StackMessage(args.spellId, args.destName, amount, "Important", amount > 7 and "Warning")
	end

	frostbittenStacks[args.destName] = amount

	if not isInfoOpen then
		isInfoOpen = true
		self:OpenInfo(args.spellId, args.spellName)
	end

	self:SetInfoByTable(args.spellId, frostbittenStacks)
end

function mod:DetonateMarkOfFrost(args)
	self:Message(args.spellId, "Important", "Alarm")
	if markOfFrostOnMe then
		self:Say(args.spellId, 151913) -- "Detonate"
	end
end

function mod:AnimateMarkOfFrost(args)
	self:Message(args.spellId, "Important", "Info", nil, 31687) -- Water Elemental icon
end

function mod:ReplicateMarkOfFrost(args)
	self:Message(args.spellId, "Important", "Alarm")
end

do
	local guid = ""
	function mod:FrozenTempest(args)
		guid = args.sourceGUID
		self:Message(args.spellId, "Important")
		self:CastBar(args.spellId, self:Mythic() and 10 or 12)
	end

	function mod:IcyEnchantmentDeath(args)
		if args.destGUID == guid then
			self:StopBar(CL.cast:format(self:SpellName(213083))) -- Frozen Tempest
		end
	end
end

--[[ Master of Fire ]]--
do
	local list = mod:NewTargetList()
	function mod:PreSearingBrandApplied(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Urgent")
		end

		if not tContains(searingBrandTargets, args.destName) then
			searingBrandTargets[#searingBrandTargets+1] = args.destName
			if self:GetOption(searingBrandMarker) then
				SetRaidTarget(args.destName, #searingBrandTargets)
			end
		end

		if not tContains(proxList, args.destName) then
			proxList[#proxList+1] = args.destName
		end

		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			searingBrandOnMe = true
		end

		updateProximity(self)
	end
end

function mod:SearingBrandApplied(args)
	if self:Me(args.destGUID) then
		searingBrandOnMe = true
		local _, _, _, expires = self:UnitDebuff("player", args.spellName)
		if expires and expires > 0 then
			local timeLeft = expires - GetTime()
			self:TargetBar(args.spellId, timeLeft, args.destName)
		end
	end

	if not tContains(searingBrandTargets, args.destName) then
		searingBrandTargets[#searingBrandTargets+1] = args.destName
		if self:GetOption(searingBrandMarker) then
			SetRaidTarget(args.destName, #searingBrandTargets)
		end
	end

	if not tContains(proxList, args.destName) then
		proxList[#proxList+1] = args.destName
	end

	updateProximity(self)
end

function mod:SearingBrandRemoved(args)
	if self:Me(args.destGUID) then
		searingBrandOnMe = nil
	end

	tDeleteItem(searingBrandTargets, args.destName)
	tDeleteItem(proxList, args.destName)

	if self:GetOption(searingBrandMarker) then
		SetRaidTarget(args.destName, 0)
	end

	if #searingBrandTargets == 0 then
		self:CloseProximity(args.spellId)
	end

	updateProximity(self)
end

function mod:DetonateSearingBrand(args)
	self:Message(args.spellId, "Important", "Alarm")
	if searingBrandOnMe then
		self:Say(args.spellId, 151913) -- "Detonate"
	end
end

function mod:DetonateSearingBrandSuccess()
	-- At this point there will be no more Mark of Frost targets and you no
	-- longer need to stay away from Searing Brand targets, so wipe everything!
	wipe(markOfFrostTargets) -- empty anyway
	wipe(searingBrandTargets)
	wipe(proxList)
	self:CloseProximity(213166) -- Searing Brand
end

do
	local fieryAddMarks = {}
	function mod:FieryAddMark(event, unit, guid)
		if self:MobId(guid) == 107285 and not mobCollector[guid] then
			for i = 1, 6 do
				if not fieryAddMarks[i] then
					SetRaidTarget(unit, i)
					fieryAddMarks[i] = guid
					mobCollector[guid] = true
					if i == 6 then
						self:UnregisterTargetEvents()
					end
					return
				end
			end
		end
	end

	function mod:AnimateSearingBrand(args)
		self:Message(args.spellId, "Important", "Info")

		if self:GetOption(fieryAddMarker) then
			wipe(fieryAddMarks)
			self:RegisterTargetEvents("FieryAddMark")
			self:ScheduleTimer("UnregisterTargetEvents", 10)
		end
	end
end

--[[ Master of the Arcane ]]--
function mod:ReplicateArcaneOrb(args)
	self:Message(args.spellId, "Important", "Alarm")
end

function mod:AnimateArcaneOrb(args)
	self:Message(args.spellId, "Important", "Info")
end

do
	local prev = 0
	function mod:Armageddon(args)
		local t = GetTime()
		if t-prev > 1 then -- Throttle because 8 adds cast it simultaneously
			prev = t
			self:Message(args.spellId, "Urgent", "Info")
			self:CastBar(args.spellId, self:Mythic() and 15 or 30)
		end
	end
end

--[[ Mythic ]]--
function mod:SeveredSoul()
	self:Message(230901, "Positive", "Info")
	self:Bar(230901, 45, CL.over:format(self:SpellName(230901))) -- Fel Soul
	self:CDBar(230504, phase % 3 == 1 and 18 or phase % 3 == 2 and 11 or 10) -- Decimate
	if phase % 3 == 0 then -- Magic
		felLashCount = 1
		self:CDBar(230403, timers[230403][felLashCount], CL.count:format(self:SpellName(230403), felLashCount)) -- Fel Lash
	end
end

function mod:SeveredSoulRemoved()
	self:StopBar(230504)
	self:StopBar(CL.count:format(self:SpellName(230403), felLashCount))
end

function mod:Decimate(args)
	self:Message(args.spellId, "Urgent")
	self:CDBar(args.spellId, phase % 3 == 1 and 20.5 or phase % 3 == 2 and 17 or 18)
end

function mod:FelLash(args)
	self:Message(args.spellId, "Positive", "Long", CL.count:format(args.spellName, felLashCount))
	felLashCount = felLashCount + 1
	local timer = timers[args.spellId][felLashCount]
	if timer then
		self:Bar(args.spellId, timer, CL.count:format(args.spellName, felLashCount))
	end
end

--[[ Many ground effects, handle it! ]]--
do
	local prev = 0
	function mod:GroundEffectDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end
