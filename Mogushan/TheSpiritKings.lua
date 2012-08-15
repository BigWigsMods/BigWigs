if not GetNumGroupMembers then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Spirit Kings", 896, 687)
if not mod then return end
mod:RegisterEnableMob(60701, 60708, 60709, 60710) -- Zian of the Endless Shadows, Meng the Demented, Qiang the Merciless, Subetai the Swift

--------------------------------------------------------------------------------
-- Locales
--

local annihilate, flankingOrders, pillage, cowardice, imperviousShield = (GetSpellInfo(119521)), (GetSpellInfo(117910)), (GetSpellInfo(118047)), (GetSpellInfo(117756)), (GetSpellInfo(117961))
local meng, qiang, subetai, zian = (EJ_GetSectionInfo(5835)), (EJ_GetSectionInfo(5841)), (EJ_GetSectionInfo(5846)), (EJ_GetSectionInfo(5852)) -- bosses
local undyingShadows = (EJ_GetSectionInfo(5853))
local pinnedTargets = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.shield_removed = "Shield removed!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"ej:5841", 119521, 117910, 117961, -- qiang
		"ej:5852", 118303, -- zian
		"ej:5846", 118047, 118122, -- subetai
		"ej:5835", 117708, -- meng
		"proximity", "berserk", "bosskill",
	}, {
		["ej:5841"] = qiang,
		["ej:5852"] = zian,
		["ej:5846"] = subetai,
		["ej:5835"] = meng,
		proximity = "general",
	}
end

function mod:OnBossEnable()
	-- qiang
	self:Log("SPELL_CAST_START", "Annihilate", 119521, 117948)
	self:Log("SPELL_CAST_SUCCESS", "FlankingOrders", 117910)
	self:Log("SPELL_CAST_START", "Shield", 117961)
	self:Log("SPELL_AURA_REMOVED", "ShieldRemoved", 117961)

	-- zian
	self:Log("SPELL_AURA_APPLIED", "Fixate", 118303)

	-- subetai
	self:Log("SPELL_CAST_SUCCESS", "Pillage", 118047)
	self:Log("SPELL_AURA_APPLIED", "PinnedDown", 118135)

	-- meng
	self:Log("SPELL_CAST_START", "MaddeningShout", 117708)
	self:Log("SPELL_AURA_APPLIED", "CowardiceApplied", 117756) -- only add spellId that is on the Boss
	self:Log("SPELL_AURA_REMOVED", "CowardiceRemoved", 117756) -- only add spellId that is on the Boss

	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "EngageCheck")

	self:Death("Win", 60701)
end

function mod:OnEngage(diff)
	self:Berserk(360) -- assume
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function isBossActiveById(bossId)
	for i=1, 4 do
		if UnitExists("boss"..i) then
			local id = tonumber((UnitGUID("boss"..i)):sub(7, 10), 16)
			if id == bossId then
				return true
			end
		end
	end
	return false
end

-- meng
function mod:CowardiceApplied()
	self:RegisterEvent("UNIT_POWER")
end

function mod:CowardiceRemoved()
	self:UnregisterEvent("UNIT_POWER")
end

function mod:UNIT_POWER(unitId)
	if not UnitExists(unitId) then return end
	local id = self:GetCID(UnitGUID(unitId))
	if id == 60708 then
		local power = UnitPower(unitId)
		if power > 75 then
			self:UnregisterEvent("UNIT_POWER")
			self:Message(117756, ("%s (%d)"):format(cowardice, power), "Attention", 117756)
		end
	end
end

function mod:MaddeningShout(_, _, _, _, spellName)
	self:Message(117708, spellName, "Important", 119521, "Alert")
	if isBossActiveById(60708) then
		self:Bar(117708, "~"..spellName, 45, 117708)
	else
		self:Bar(117708, "~"..spellName, 76, 117708)
	end
end

-- subetai
do
	local scheduled = nil
	local function warnPinned(spellName)
		mod:TargetMessage(118122, spellName, pinnedTargets, "Important", 118122, "Alarm")
		scheduled = nil
	end
	function mod:PinnedDown(player, _, _, _, spellName)
		pinnedTargets[#pinnedTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(warnPinned, 0.1, spellName)
		end
	end
end

function mod:Pillage(_, _, _, _, spellName)
	self:Message(118047, spellName, "Urgent", 118047, "Alarm")
	self:Bar(118047, spellName, 41, 118047)
end

-- zian
function mod:Fixate(player, _, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:LocalMessage(118303, spellName, "Personal", 118303, "Info")
	end
end

-- qiang
function mod:FlankingOrders(_, _, _, _, spellName)
	self:Message(117910, spellName, "Attention", 117910, "Long")
	if isBossActiveById(60709) then
		self:Bar(117910, "~"..spellName, 45, 117910)
	else
		self:Bar(117910, "~"..spellName, 76, 117910)
	end
end

function mod:Annihilate(_, _, _, _, spellName)
	self:Message(119521, spellName, "Important", 119521, "Alert")
	self:Bar(119521, spellName, 35, 119521)
end

function mod:Shield(_, _, _, _, spellName)
	self:Message(117961, spellName, "Important", 117961, "Alert")
	self:Bar(117961, spellName, 42, 117961)
end

function mod:ShieldRemoved()
	self:Message(117961, L["shield_removed"], "Positive", 117961, "Info")
end

function mod:EngageCheck(diff)
	for i=1, 4 do
		if UnitExists("boss"..i) then
			local id = tonumber((UnitGUID("boss"..i)):sub(7, 10), 16)
			-- this is needed because of heroic
			local hp = UnitHealth("boss"..i) / UnitHealthMax("boss"..i) * 100
			if hp < 35 then return end --35 to be safe EJ says 30
			if id == 60709 then -- qiang
				if diff > 2 then
					self:Bar(117961, imperviousShield, 40, 117961)
				end
				self:Bar(119521, annihilate, 10, 119521)
				self:Bar(117910, flankingOrders, 26, 117910)
				self:Message("ej:5841", qiang, "Positive", 117920)
			elseif id == 60701 then -- zian
				self:OpenProximity(8)
				self:Message("ej:5852", zian, "Positive", 117628)
			elseif id == 60710 then -- subetai
				self:OpenProximity(8)
				self:Bar(118047, pillage, 26, 118047)
				self:Message("ej:5846", subetai, "Positive", 118122)
			elseif id == 60708 then
				self:Bar(117708, maddening, 21, 117708)
				self:Message("ej:5835", meng, "Positive", 117833)
			end
		end
	end
	self:CheckBossStatus()
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unitId, spellName, _, _, spellId)
	if spellId == 118219 and unitId:match("boss") then
		local id = self:GetCID(UnitGUID(unitId))
		if id == 60701 or id == 60710 then
			self:CloseProximity()
		end
	end
end

