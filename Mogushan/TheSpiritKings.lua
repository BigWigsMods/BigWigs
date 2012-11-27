
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

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
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
		"ej:5841", 119521, 117910, {117961, "FLASHSHAKE"}, -- qiang
		"ej:5852", {118303, "SAY", "ICON"}, {117697, "FLASHSHAKE"}, -- zian
		"ej:5846", 118047, 118122, 118094, {118162, "FLASHSHAKE"}, -- subetai
		"ej:5835", "cowardice", 117708, -- meng
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
	self:Log("SPELL_CAST_START", "Annihilate", 119521, 117948) -- Heroic, Norm/LFR
	self:Log("SPELL_CAST_SUCCESS", "FlankingOrders", 117910)
	self:Log("SPELL_CAST_START", "ImperviousShield", 117961)
	self:Log("SPELL_AURA_REMOVED", "ShieldRemoved", 117961)

	-- zian
	self:Log("SPELL_AURA_APPLIED", "Fixate", 118303)
	self:Log("SPELL_CAST_START", "ShieldofDarkness", 117697)
	self:Log("SPELL_AURA_REMOVED", "ShieldRemoved", 117697)

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

function mod:OnEngage()
	self:Berserk(600)
	wipe(bossActivated)
	if self:Heroic() then
		self:Bar(117961, 117961, 40, 117961) -- Impervious Shield
	end
	self:Bar(119521, 119521, 10, 119521) -- Annihilate
	self:Bar(117910, 117910, 26, 117910) -- Flanking Orders
	self:Message("ej:5841", qiang, "Positive", 117920)
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
do
	local prevPower = 0
	function mod:CowardiceApplied()
		prevPower = 0
		self:RegisterEvent("UNIT_POWER_FREQUENT")
	end
	function mod:CowardiceRemoved(_, spellId)
		self:UnregisterEvent("UNIT_POWER_FREQUENT")
		prevPower = 0
		self:Message("cowardice", CL["over"]:format(spellReflect), "Positive", spellId)
	end
	function mod:UNIT_POWER_FREQUENT(_, unitId)
		if not unitId:find("boss", nil, true) then return end
		local id = self:GetCID(UnitGUID(unitId))
		if id == 60708 then
			local power = UnitPower(unitId)
			if power > 74 and prevPower == 0 then
				prevPower = 75
				self:Message("cowardice", ("%s (%d%%)"):format(spellReflect, power), "Attention", 117756)
			elseif power > 84 and prevPower == 75 then
				prevPower = 85
				self:Message("cowardice", ("%s (%d%%)"):format(spellReflect, power), "Urgent", 117756)
			elseif power > 89 and prevPower == 85 then
				prevPower = 90
				self:Message("cowardice", ("%s (%d%%)"):format(spellReflect, power), "Personal", 117756)
			elseif power > 92 and prevPower == 90 then
				prevPower = 93
				self:Message("cowardice", ("%s (%d%%)"):format(spellReflect, power), "Personal", 117756)
			elseif power > 96 and prevPower == 93 then
				prevPower = 97
				self:Message("cowardice", ("%s (%d%%)"):format(spellReflect, power), "Personal", 117756)
			end
		end
	end
end

function mod:MaddeningShout(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Urgent", spellId, "Alarm")
	if isBossActiveById(60708) then
		self:Bar(spellId, "~"..spellName, self:Heroic() and 47 or 48.3, spellId)
	else
		self:Bar(spellId, "~"..spellName, 76, spellId)
	end
end

function mod:ShieldofDarkness(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Important", spellId, "Alert")
	self:Bar(spellId, "~"..spellName, 42.5, spellId)
	self:Bar("casting_shields", CL["cast"]:format(spellName), 2, spellId)
	self:FlashShake(spellId)
end

-- subetai
do
	local timer = nil
	local pinnedTargets = mod:NewTargetList()
	local function warnPinned(spellName)
		mod:TargetMessage(118122, spellName, pinnedTargets, "Important", 118122, "Alarm")
		timer = nil
	end
	function mod:PinnedDown(player, _, _, _, spellName)
		pinnedTargets[#pinnedTargets + 1] = player
		if not timer then
			timer = self:ScheduleTimer(warnPinned, 0.1, spellName)
		end
	end
end

function mod:Pillage(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Urgent", spellId, "Alarm")
	self:Bar(spellId, spellName, 41, spellId)
end

function mod:Volley(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Urgent", spellId)
	self:Bar(spellId, spellName, 37, spellId)
end

function mod:SleightofHand(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Important", spellId, "Alert")
	self:Bar(spellId, spellName, 42, spellId)
	self:FlashShake(spellId)
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
function mod:FlankingOrders(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Attention", spellId, "Long")
	if isBossActiveById(60709) then
		self:Bar(spellId, spellName, self:Heroic() and 46 or 41, spellId)
	else
		self:Bar(spellId, spellName, 75, spellId)
	end
end

function mod:Annihilate(_, _, _, _, spellName)
	self:Message(119521, spellName, "Urgent", 119521, "Alarm")
	self:Bar(119521, spellName, self:Heroic() and 32 or 39, 119521)
end

function mod:ImperviousShield(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Important", spellId, "Alert")
	self:Bar(spellId, spellName, 42, spellId)
	self:Bar("casting_shields", CL["cast"]:format(spellName), 2, spellId)
	self:FlashShake(spellId)
end

function mod:ShieldRemoved(_, spellId, _, _, spellName)
	self:Message(spellId, L["shield_removed"]:format(spellName), "Positive", spellId, "Info")
end

function mod:EngageCheck()
	self:CheckBossStatus()
	for i=1, 5 do
		local unitId = ("boss%d"):format(i)
		if UnitExists(unitId) then
			local id = self:GetCID(UnitGUID(unitId))
			-- this is needed because of heroic
			if (id == 60701 or id == 61421) and not bossActivated[60701] then -- zian
				bossActivated[60701] = true
				if self:Heroic() then
					self:Bar(117697, 117697, 40, 117697) -- Shield of Darkness
				end
				self:OpenProximity(8)
				self:Message("ej:5852", zian, "Positive", 117628)
			elseif (id == 60710 or id == 61427) and not bossActivated[60710] then -- subetai
				bossActivated[60710] = true
				if self:Heroic() then
					self:Bar(118162, 118162, 40, 118162) -- Sleight of Hand
				end
				self:OpenProximity(8)
				self:Bar(118094, 118094, 5, 118094) -- Volley
				self:Bar(118047, 118047, 26, 118047) -- Pillage
				self:Bar(118122, 118122, self:Heroic() and 40 or 21, 118122) -- Rain of Arrows
				self:Message("ej:5846", subetai, "Positive", 118122)
			elseif (id == 60708 or id == 61429) and not bossActivated[60708] then -- meng
				bossActivated[60708] = true
				self:Bar(117708, "~"..self:SpellName(117708), self:Heroic() and 40 or 21, 117708) -- Maddening Shout, on heroic: 44.2, 19.8, 48.7, 49.2, 40.2
				self:Message("ej:5835", meng, "Positive", 117833)
			end
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unitId, spellName, _, _, spellId)
	if unitId:find("boss", nil, true) then
		if spellId == 118205 then -- Inactive Visual
			local id = self:GetCID(UnitGUID(unitId))
			if (id == 60709 or id == 61423) then -- qiang
				self:StopBar(119521) -- Annihilate
				self:StopBar(117961) -- Impervious Shield
				self:Bar(117910, 117910, 30, 117910) -- Flanking Orders
			elseif (id == 60701 or id == 61421) then -- zian
				self:StopBar("~"..self:SpellName(117697)) -- Shield of Darkness
				if isBossActiveById(60710) then -- don't close if subetai is active
					self:CloseProximity()
				end
			elseif (id == 60710 or id == 61427) then -- subetai
				self:StopBar(118162) -- Sleight of Hand
				self:StopBar(118094) -- Volley
				self:StopBar(118122) -- Rain of Arrows
				self:Bar(118047, 118047, 30, 118047) -- Pillage
				if isBossActiveById(60701) then -- don't close if zian is active
					self:CloseProximity()
				end
			elseif (id == 60708 or id == 61429) then -- meng
				self:Bar(117708, "~"..self:SpellName(117708), 30, 117708) -- Maddening Shout
			end
		elseif spellId == 118121 then -- Rain of Arrows for Pinned Down
			self:Bar(118122, 118122, self:Heroic() and 41 or 50, 118122) -- Rain of Arrows
		end
	end
end

