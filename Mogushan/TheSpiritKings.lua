
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Spirit Kings", 896, 687)
if not mod then return end
mod:RegisterEnableMob(
	60701, 61421, -- Zian of the Endless Shadows
	60708, 61429, -- Meng the Demented
	60709, 61423, -- Qiang the Merciless
	60710, 61427 -- Subetai the Swift
)

--------------------------------------------------------------------------------
-- Locals
--

local spellReflect = mod:SpellName(69901)

local meng = EJ_GetSectionInfo(5835)
local qiang = EJ_GetSectionInfo(5841)
local subetai = EJ_GetSectionInfo(5846)
local zian = EJ_GetSectionInfo(5852)

local bossActivated = {}
local bossWarned = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bosses = "Bosses"
	L.bosses_desc = "Warnings for when a boss becomes active."

	L.shield_removed = "Shield removed! (%s)"
	L.casting_shields = "Casting shields"
	L.casting_shields_desc = "Warnings for when shields are casted for all bosses."
	L.casting_shields_icon = 871

	L.cowardice = EJ_GetSectionInfo(5838) .." (".. spellReflect ..")"
	L.cowardice_desc = select(2, EJ_GetSectionInfo(5838))
	L.cowardice_icon = 117756
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		117921, 119521, 117910, {117961, "FLASH"}, -- Qiang
		{118303, "SAY", "ICON"}, {117697, "FLASH"}, -- Zian
		118047, 118122, 118094, {118162, "FLASH"}, -- Subetai
		"cowardice", 117708, {117837, "DISPEL"}, -- Meng
		"bosses", "proximity", "casting_shields", "berserk", "bosskill",
	}, {
		[117921] = -5841,
		[118303] = -5852,
		[118047] = -5846,
		cowardice = -5835,
		bosses = "general",
	}
end

function mod:OnBossEnable()
	-- Qiang
	self:Log("SPELL_CAST_START", "Annihilate", 119521, 117948) -- Heroic, Norm/LFR
	self:Log("SPELL_CAST_SUCCESS", "FlankingOrders", 117910)
	self:Log("SPELL_CAST_START", "ImperviousShield", 117961)
	self:Log("SPELL_AURA_REMOVED", "ShieldRemoved", 117961)
	self:Log("SPELL_DAMAGE", "MassiveAttack", 117921)
	self:Log("SPELL_MISSED", "MassiveAttack", 117921)

	-- Zian
	self:Log("SPELL_AURA_APPLIED", "Fixate", 118303)
	self:Log("SPELL_CAST_START", "ShieldofDarkness", 117697)
	self:Log("SPELL_AURA_REMOVED", "ShieldRemoved", 117697)

	-- Subetai
	self:Log("SPELL_CAST_SUCCESS", "Pillage", 118047)
	self:Log("SPELL_AURA_APPLIED", "PinnedDown", 118135)
	self:Log("SPELL_CAST_START", "SleightofHand", 118162)
	self:Log("SPELL_CAST_START", "Volley", 118094)

	-- Meng
	self:Log("SPELL_CAST_START", "MaddeningShout", 117708)
	self:Log("SPELL_AURA_APPLIED", "CowardiceApplied", 117756)
	self:Log("SPELL_AURA_REMOVED", "CowardiceRemoved", 117756)
	self:Log("SPELL_AURA_APPLIED", "Delirious", 117837)

	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3", "boss4")
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "EngageCheck")

	self:Death("Win", 60701, 60708, 60709, 60710)
end

function mod:OnEngage()
	self:Berserk(600)
	wipe(bossActivated)
	if self:Heroic() then
		self:Bar(117961, 40) -- Impervious Shield
		self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "BossSwap", "boss1", "boss2", "boss3", "boss4")
		bossWarned = 0
	end
	self:Bar(119521, 10) -- Annihilate
	self:Bar(117910, 25) -- Flanking Orders
	self:Message("bosses", "Positive", nil, qiang, 117920) -- Massive Attack icon
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function isBossActiveById(bossId, bossIdTwo)
	for i=1, 5 do
		local unitId = ("boss%d"):format(i)
		if UnitExists(unitId) then
			local id = mod:MobId(UnitGUID(unitId))
			if id == bossId or id == bossIdTwo then
				return true
			end
		end
	end
	return false
end

-- Meng
do
	local prevPower = 0
	function mod:CowardiceApplied()
		prevPower = 0
		self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "SpellReflectWarn", "boss1", "boss2", "boss3", "boss4")
	end
	function mod:CowardiceRemoved(args)
		self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", "boss1", "boss2", "boss3", "boss4")
		prevPower = 0
		self:Message("cowardice", "Positive", nil, CL["over"]:format(spellReflect), L.cowardice_icon)
	end
	function mod:SpellReflectWarn(unitId)
		local id = self:MobId(UnitGUID(unitId))
		if id == 60708 or id == 61429 then
			local power = UnitPower(unitId)
			if power > 74 and prevPower == 0 then
				prevPower = 75
				self:Message("cowardice", "Attention", nil, ("%s (%d%%)"):format(spellReflect, power), L.cowardice_icon)
			elseif power > 84 and prevPower == 75 then
				prevPower = 85
				self:Message("cowardice", "Urgent", nil, ("%s (%d%%)"):format(spellReflect, power), L.cowardice_icon)
			elseif power > 89 and prevPower == 85 then
				prevPower = 90
				self:Message("cowardice", "Personal", nil, ("%s (%d%%)"):format(spellReflect, power), L.cowardice_icon)
			elseif power > 92 and prevPower == 90 then
				prevPower = 93
				self:Message("cowardice", "Personal", nil, ("%s (%d%%)"):format(spellReflect, power), L.cowardice_icon)
			elseif power > 96 and prevPower == 93 then
				prevPower = 97
				self:Message("cowardice", "Personal", nil, ("%s (%d%%)"):format(spellReflect, power), L.cowardice_icon)
			end
		end
	end
end

function mod:MaddeningShout(args)
	self:Message(args.spellId, "Urgent", "Alarm")
	self:CDBar(args.spellId, isBossActiveById(60708, 61429) and 46.7 or 76)
end

function mod:Delirious(args)
	if self:Dispeller("enrage", true, args.spellId) then
		self:Message(args.spellId, "Urgent", "Alert")
		self:Bar(args.spellId, 20)
	end
end

-- Subetai
do
	local pinnedTargets, scheduled = mod:NewTargetList(), nil
	local function warnPinned(spellName)
		mod:TargetMessage(118122, pinnedTargets, "Important", "Alarm", spellName)
		scheduled = nil
	end
	function mod:PinnedDown(args)
		pinnedTargets[#pinnedTargets + 1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(warnPinned, 0.1, args.spellName)
		end
	end
end

function mod:Pillage(args)
	self:Message(args.spellId, "Urgent", "Alarm")
	if isBossActiveById(60710, 61427) then
		self:CDBar(args.spellId, 40)
	else
		self:Bar(args.spellId, 75.5)
	end
end

function mod:Volley(args)
	self:Message(args.spellId, "Urgent")
	self:Bar(args.spellId, 41)
end

function mod:SleightofHand(args)
	self:Message(args.spellId, "Important", "Alert")
	self:Bar(args.spellId, 42)
	self:Flash(args.spellId)
end

-- Zian
function mod:Fixate(args)
	self:PrimaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Info")
		self:Say(args.spellId, args.spellName)
	end
end

function mod:ShieldofDarkness(args)
	self:Message(args.spellId, "Important", "Alert")
	self:Bar(args.spellId, 42)
	self:Bar("casting_shields", 2, CL["cast"]:format(args.spellName), args.spellId)
	self:Flash(args.spellId)
end

-- Qiang
function mod:FlankingOrders(args)
	self:Message(args.spellId, "Attention", "Long")
	if isBossActiveById(60709, 61423) then
		self:Bar(args.spellId, self:Heroic() and 45.7 or 41)
	else
		self:Bar(args.spellId, 75)
	end
end

function mod:Annihilate(args)
	self:Message(119521, "Urgent", "Alarm")
	self:Bar(119521, self:Difficulty() == 6 and 32 or 39)
	self:Bar(117921, 8) -- Massive Attack
end

function mod:MassiveAttack(args)
	self:Bar(args.spellId, 5)
end

function mod:ImperviousShield(args)
	self:Message(args.spellId, "Important", "Alert")
	self:Bar(args.spellId, self:Difficulty() == 5 and 62 or 42)
	self:Bar("casting_shields", 2, CL["cast"]:format(args.spellName), args.spellId)
	self:Flash(args.spellId)
end

function mod:ShieldRemoved(args)
	self:Message(args.spellId, "Positive", "Info", L["shield_removed"]:format(args.spellName))
end

function mod:EngageCheck()
	self:CheckBossStatus()
	for i=1, 5 do
		local unitId = ("boss%d"):format(i)
		if UnitExists(unitId) then
			local id = self:MobId(UnitGUID(unitId))
			-- this is needed because of heroic
			if (id == 60701 or id == 61421) and not bossActivated[60701] then -- Zian
				bossActivated[60701] = true
				if self:Heroic() then
					self:Bar(117697, 40) -- Shield of Darkness
				end
				self:OpenProximity("proximity", 8)
				self:Message("bosses", "Positive", nil, zian, 117628) -- Shadow Blast icon
			elseif (id == 60710 or id == 61427) and not bossActivated[60710] then -- Subetai
				bossActivated[60710] = true
				if self:Heroic() then
					self:Bar(118162, 15) -- Sleight of Hand
				end
				self:OpenProximity("proximity", 8)
				self:Bar(118094, 5) -- Volley
				self:Bar(118047, 26) -- Pillage
				self:Bar(118122, self:Heroic() and 40 or 15) -- Rain of Arrows
				self:Message("bosses", "Positive", nil, subetai, 118122) -- Rain of Arrows icon
			elseif (id == 60708 or id == 61429) and not bossActivated[60708] then -- Meng
				bossActivated[60708] = true
				self:CDBar(117708, self:Heroic() and 40 or 21) -- Maddening Shout
				if self:Heroic() then
					self:Bar(117837, 20) -- Delirious
				end
				self:Message("bosses", "Positive", nil, meng, 117833) -- Crazy Thought icon
			end
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unitId, spellName, _, _, spellId)
	if spellId == 118205 then -- Inactive Visual
		local id = self:MobId(UnitGUID(unitId))
		if (id == 60709 or id == 61423) then -- Qiang
			self:StopBar(119521) -- Annihilate
			self:StopBar(117961) -- Impervious Shield
			self:StopBar(117921) -- Massive Attack
			self:Bar(117910, 30) -- Flanking Orders
		elseif (id == 60701 or id == 61421) then -- Zian
			self:StopBar(117697) -- Shield of Darkness
			if not isBossActiveById(60710, 61427) then -- don't close if Subetai is active
				self:CloseProximity()
			end
		elseif (id == 60710 or id == 61427) then -- Subetai
			self:StopBar(118162) -- Sleight of Hand
			self:StopBar(118094) -- Volley
			self:StopBar(118122) -- Rain of Arrows
			self:StopBar(118047) -- Pillage
			self:Bar(118047, 30) -- Pillage
			if not isBossActiveById(60701, 61421) then -- don't close if Zian is active
				self:CloseProximity()
			end
		elseif (id == 60708 or id == 61429) then -- Meng
			self:StopBar(117837)
			self:CDBar(117708, 30) -- Maddening Shout
		end
	elseif spellId == 118121 then -- Rain of Arrows for Pinned Down
		if self:Heroic() then
			self:Bar(118122, 41) -- Rain of Arrows
		else
			self:CDBar(118122, 51) -- Rain of Arrows
		end
	end
end

function mod:BossSwap(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if hp < 38 then -- next boss at 30% (Qiang -> Subetai -> Zian -> Meng)
		local id = self:MobId(UnitGUID(unitId))
		if bossWarned == 0 and (id == 60709 or id == 61423) then -- Qiang
			self:Message("bosses", "Positive", "Info", CL["soon"]:format(subetai), false)
			bossWarned = 1
		elseif bossWarned == 1 and (id == 60710 or id == 61427) then -- Subetai
			self:Message("bosses", "Positive", "Info", CL["soon"]:format(zian), false)
			bossWarned = 2
		elseif bossWarned == 2 and (id == 60701 or id == 61421) then -- Zian
			self:Message("bosses", "Positive", "Info", CL["soon"]:format(meng), false)
			bossWarned = 3
			self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1", "boss2", "boss3", "boss4")
		end
	end
end

