
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
-- Locales
--

local annihilate, flankingOrders, pillage, cowardice, maddening = (GetSpellInfo(119521)), (GetSpellInfo(117910)), (GetSpellInfo(118047)), (GetSpellInfo(117756)), (GetSpellInfo(117708))
local imperviousShield, shieldOfDarkness, sleightOfHand = (GetSpellInfo(117961)), (GetSpellInfo(117697)), (GetSpellInfo(118162))
local meng, qiang, subetai, zian = (EJ_GetSectionInfo(5835)), (EJ_GetSectionInfo(5841)), (EJ_GetSectionInfo(5846)), (EJ_GetSectionInfo(5852)) -- bosses
local undyingShadows = (EJ_GetSectionInfo(5853))
local pinnedTargets = mod:NewTargetList()

local bossActivated = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.shield_removed = "Shield removed!"
	L.casting_shields = "Casting shields"
	L.casting_shields_desc = "Warning for when shields are casted for all bosses"
	L.casting_shields_icon = 871
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"ej:5841", 119521, 117910, {117961, "FLASHSHAKE"},   -- qiang
		"ej:5852", {118303, "SAY", "ICON"}, {117697, "FLASHSHAKE"}, -- zian
		"ej:5846", 118047, 118122, 118094, {118162, "FLASHSHAKE"}, -- subetai
		"ej:5835", 117756, 117708, -- meng
		"proximity", "casting_shields", "berserk", "bosskill",
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
	self:Log("SPELL_CAST_START", "ShieldofDarkness", 117697)

	-- subetai
	self:Log("SPELL_CAST_SUCCESS", "Pillage", 118047)
	self:Log("SPELL_AURA_APPLIED", "PinnedDown", 118135)
	self:Log("SPELL_CAST_START", "SleightofHand", 118162)
	self:Log("SPELL_CAST_START", "Volley", 118094)

	-- meng
	self:Log("SPELL_CAST_START", "MaddeningShout", 117708)
	self:Log("SPELL_AURA_APPLIED", "CowardiceApplied", 117756) -- only add spellId that is on the Boss
	self:Log("SPELL_AURA_REMOVED", "CowardiceRemoved", 117756) -- only add spellId that is on the Boss

	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "EngageCheck")

	self:Death("Win", 60701, 60708, 60709, 60710)
end

function mod:OnEngage(diff)
	self:Berserk(600)
	wipe(bossActivated)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function isBossActiveById(bossId)
	for i=1, 5 do
		local unitId = ("boss%d"):format(i)
		if UnitExists(unitId) then
			local id = mod:GetCID(UnitGUID(unitId))
			if id == bossId then
				return true
			end
		end
	end
	return false
end

-- meng
function mod:CowardiceApplied()
	self:RegisterEvent("UNIT_POWER_FREQUENT")
end

function mod:CowardiceRemoved()
	self:UnregisterEvent("UNIT_POWER_FREQUENT")
end

function mod:UNIT_POWER_FREQUENT(_, unitId)
	if not unitId:find("boss", nil, true) then return end
	local id = self:GetCID(UnitGUID(unitId))
	if id == 60708 then
		local power = UnitPower(unitId)
		if power > 75 then
			self:UnregisterEvent("UNIT_POWER_FREQUENT")
			self:Message(117756, ("%s (%d)"):format(cowardice, power), "Attention", 117756)
		end
	end
end

function mod:MaddeningShout(_, _, _, _, spellName)
	self:Message(117708, spellName, "Urgent", 117708, "Alarm")
	if isBossActiveById(60708) then
		self:Bar(117708, "~"..spellName, 45, 117708)
	else
		self:Bar(117708, "~"..spellName, 76, 117708)
	end
end

function mod:ShieldofDarkness(_, _, _, _, spellName)
	self:Message(117697, spellName, "Important", 117697, "Alert")
	self:Bar(117697, spellName.."~", 42.5, 117697)
	self:Bar("casting_shields", CL["cast"]:format(spellName), 2, 117697)
	self:FlashShake(117697)
end

-- subetai
do
	local scheduled = nil
	local function warnPinned(spellName)
		mod:TargetMessage(118122, spellName, pinnedTargets, "Important", 118122, "Alarm")
		scheduled = nil
	end
	function mod:PinnedDown(player, _, _, _, spellName)
		self:Bar(118122, spellName, 41, 118122)
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

function mod:Volley(_, _, _, _, spellName)
	self:Message(118094, spellName, "Urgent", 118094)
	self:Bar(118094, spellName, 37, 118094)
end

function mod:SleightofHand(_, _, _, _, spellName)
	self:Message(118162, spellName, "Important", 118162, "Alert")
	self:Bar(118162, spellName, 42, 118162)
	self:FlashShake(118162)
end

-- zian
function mod:Fixate(player, spellId, _, _, spellName)
	self:PrimaryIcon(spellId, player)
	if UnitIsUnit("player", player) then
		self:LocalMessage(spellId, spellName, "Personal", spellId, "Info")
		self:Say(spellId, CL["say"]:format(spellName))
	end
end

-- qiang
function mod:FlankingOrders(_, _, _, _, spellName)
	self:Message(117910, spellName, "Attention", 117910, "Long")
	if isBossActiveById(60709) then
		self:Bar(117910, spellName, 40, 117910)
	else
		self:Bar(117910, spellName, 75, 117910)
	end
end

function mod:Annihilate(_, _, _, _, spellName)
	self:Message(119521, spellName, "Urgent", 119521, "Alarm")
	self:Bar(119521, spellName, 39, 119521)
end

function mod:Shield(_, _, _, _, spellName)
	self:Message(117961, spellName, "Important", 117961, "Alert")
	self:Bar(117961, spellName, 42, 117961)
	self:Bar("casting_shields", CL["cast"]:format(spellName), 2, 117961)
	self:FlashShake(117961)
end

function mod:ShieldRemoved()
	self:Message(117961, L["shield_removed"], "Positive", 117961, "Info")
end

	60701, 61421, -- Zian of the Endless Shadows
	60708, 61429, -- Meng the Demented
	60709, 61423, -- Qiang the Merciless
	60710, 61427 -- Subetai the Swift


function mod:EngageCheck()
	for i=1, 5 do
		local unitId = ("boss%d"):format(i)
		if UnitExists(unitId) then
			local id = self:GetCID(UnitGUID(unitId))
			-- this is needed because of heroic
			if (id == 60709 or id == 61423) and not bossActivated[60709] then -- qiang
				bossActivated[60709] = true
				if self:Heroic() then
					self:Bar(117961, imperviousShield, 40, 117961)
				end
				self:Bar(119521, annihilate, 10, 119521)
				self:Bar(117910, flankingOrders, 26, 117910)
				self:Message("ej:5841", qiang, "Positive", 117920)
			elseif (id == 60701 or id == 61421) and not bossActivated[60701] then -- zian
				bossActivated[60701] = true
				if self:Heroic() then
					self:Bar(117697, shieldOfDarkness, 40, 117697)
				end
				self:OpenProximity(8)
				self:Message("ej:5852", zian, "Positive", 117628)
			elseif (id == 60710 or id == 61427) and not bossActivated[60710] then -- subetai
				bossActivated[60710] = true
				if self:Heroic() then
					self:Bar(118162, sleightOfHand, 40, 118162)
				end
				self:OpenProximity(8)
				self:Bar(118047, pillage, 26, 118047)
				self:Message("ej:5846", subetai, "Positive", 118122)
			elseif (id == 60708 or id == 61429) and not bossActivated[60708] then
				bossActivated[60708] = true
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

