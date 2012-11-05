
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Wind Lord Mel'jarak", 897, 741)
if not mod then return end
mod:RegisterEnableMob(62397, 62408, 62402, 62405) -- boss, mender, battlemaster, trapper

--------------------------------------------------------------------------------
-- Locales
--

local whirlingBlade, korthikStrike, rainOfBlades = (GetSpellInfo(121896)), (GetSpellInfo(122409)), (GetSpellInfo(122406))
local prisonList = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.next_pack = "Next pack"
	L.next_pack_desc = "Warning for when a new pack will land after you killed a pack."
	L.next_pack_icon = 125873

	L.spear_removed = "Your Impaling Spear was removed!"
	L.residue_removed = "%s removed!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{ 122064, "FLASHSHAKE", "SAY" }, {122125, "FLASHSHAKE"}, {121881, "SAY", "PROXIMITY", "ICON"}, 122055,
		{ 122409, "ICON", "SAY" },
		122149, 122193,
		122406, {122224, "FLASHSHAKE"}, { 121896, "SAY", "FLASHSHAKE", "ICON" }, { 131830, "SAY", "FLASHSHAKE" }, 125873, "next_pack",
		"berserk", "bosskill",
	}, {
		[122064] = "ej:6300",
		[122409] = "ej:6334",
		[122149] = "ej:6305",
		[122406] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "AmberPrison", 121881) -- initial cast only
	self:Log("SPELL_AURA_REMOVED", "ResidueRemoved", 122055)
	self:Log("SPELL_AURA_APPLIED", "Resin", 122064)
	self:Log("SPELL_PERIODIC_DAMAGE", "ResinPoolDamage", 122125)
	self:Log("SPELL_AURA_APPLIED", "Recklessness", 125873)
	self:Log("SPELL_SUMMON", "WindBomb", 131814)
	self:Log("SPELL_CAST_START", "WhirlingBlade", 121896)
	self:Log("SPELL_CAST_START", "KorthikStrike", 122409)
	self:Log("SPELL_CAST_START", "Quickening", 122149)
	self:Log("SPELL_CAST_START", "Mending", 122193)
	self:Log("SPELL_CAST_START", "RainOfBlades", 122406)
	self:Log("SPELL_AURA_APPLIED", "ImpalingSpear", 122224)
	self:Log("SPELL_AURA_REFRESH", "ImpalingSpear", 122224)
	self:Log("SPELL_AURA_REMOVED", "ImpalingSpearRemoved", 122224)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 62397)
end

function mod:OnEngage(diff)
	self:Bar(121896, whirlingBlade, 36, 121896)
	self:Bar(122406, "~"..rainOfBlades, 60, 122406)
	self:OpenProximity(4, 121881) -- for amber prison EJ says 2 yards, but it might be bigger range -- 4 should be more than safe
	self:Berserk(480)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ResidueRemoved(player, _, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:LocalMessage(122055, L["residue_removed"]:format(spellName), "Positive", 122055)
	end
end

do
	local scheduled = nil
	local function prison(spellName)
		mod:TargetMessage(121881, spellName, prisonList, "Important", 122740, "Info")
		scheduled = nil
	end
	function mod:AmberPrison(player, _, _, _, spellName)
		if UnitIsUnit("player", player) then
			self:Say(121881, CL["say"]:format(spellName))
		end
		prisonList[#prisonList + 1] = player
		if #prisonList < 2 then
			self:PrimaryIcon(121881, player)
		else
			self:SecondaryIcon(121881, player)
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(prison, 0.1, spellName)
		end
	end
end

function mod:RainOfBlades(_, _, _, _, spellName)
	self:Message(122406, spellName, "Important", 122406, "Alert")
	self:Bar(122406, "~"..spellName, 60, 122406)
end

function mod:Quickening(_, _, _, _, spellName)
	self:Message(122149, spellName, "Attention", 122149)
end

function mod:Mending(_, _, source, _, spellName)
	if UnitIsUnit("focus", source) then
		self:LocalMessage(122193, CL["cast"]:format(spellName), "Personal", 122193, "Info")
		self:Bar(122193, spellName, 37, 122193)
	end
end

do
	local function checkTarget(sGUID)
		local mobId = mod:GetUnitIdByGUID(sGUID)
		if mobId then
			local player = UnitName(mobId.."target")
			if not player then return end
			if UnitIsUnit("player", player) then
				mod:Say(122409, CL["say"]:format(korthikStrike))
			end
			mod:TargetMessage(122409, korthikStrike, player, "Urgent", 122409, "Alarm")
			--mod:SecondaryIcon(122409, player)  -- lets not use it till the warning is not working properly
		end
	end
	function mod:KorthikStrike(...)
		local sGUID = select(11, ...)
		self:ScheduleTimer(checkTarget, 0.2, sGUID)
	end
end

do
	local timer, fired = nil, 0
	local whirlingBlade = mod:SpellName(121896)
	local function bladeWarn(sGUID)
		fired = fired + 1
		local unitId = mod:GetUnitIdByGUID(sGUID)
		if not unitId then return end
		local unitIdTarget = unitId.."target"
		local player = UnitName(unitIdTarget)
		if player and (not UnitDetailedThreatSituation(unitIdTarget, unitId) or fired > 13) then
			-- If we've done 14 (0.7s) checks and still not passing the threat check, it's probably being cast on the tank
			mod:Bar(121896, "~"..whirlingBlade, 45, 121896)
			mod:TargetMessage(121896, whirlingBlade, player, "Urgent", 121896, "Alarm")
			--mod:PrimaryIcon(121896, player) -- lets not use it till the warning is not working properly
			mod:CancelTimer(timer, true)
			timer = nil
			if UnitIsUnit(unitIdTarget, "player") then
				mod:Say(121896, CL["say"]:format(whirlingBlade))
				mod:FlashShake(121896)
			end
			return
		end
		-- 19 == 0.95sec
		-- Safety check if the unit doesn't exist
		if fired > 18 then
			mod:CancelTimer(timer, true)
			timer = nil
		end
	end
	function mod:WhirlingBlade(...)
		local sGUID = select(11, ...)
		fired = 0
		if not timer then
			timer = self:ScheduleRepeatingTimer(bladeWarn, 0.05, sGUID)
		end
	end
end

function mod:WindBomb(_, _, player, _, spellName)
	self:TargetMessage(131830, spellName, player, "Urgent", 131830, "Alarm")
	if UnitIsUnit("player", player) then
		self:FlashShake(131830)
		self:Say(131830, CL["say"]:format(spellName))
	end
end

function mod:Recklessness(_, _, _, _, spellName)
	self:Message(125873, spellName, "Attention", 125873)
	self:Bar(125873, spellName, 30, 125873)
	self:Bar("next_pack", L["next_pack"], 50, 125873)
	self:DelayedMessage("next_pack", 50, L["next_pack"], "Attention", 125873)
end

do
	local prev = 0
	function mod:ResinPoolDamage(player, _, _, _, spellName)
		if not UnitIsUnit(player, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(122125, CL["underyou"]:format(spellName), "Personal", 122125, "Info")
			self:FlashShake(122125)
		end
	end
end

function mod:Resin(player, _, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:Say(122064, CL["say"]:format(spellName))
		self:FlashShake(122064)
		self:LocalMessage(122064, CL["you"]:format(spellName), "Personal", 122064, "Info")
	end
end

function mod:ImpalingSpear(_, spellId, source, _, spellName)
	if UnitIsUnit(source, "player") then
		self:Bar(122224, spellName, 50, 122224)
	end
end

function mod:ImpalingSpearRemoved(_, _, source, _, spellName)
	if UnitIsUnit(source, "player") then
		self:StopBar(spellName)
		self:LocalMessage(122224, L["spear_removed"], "Personal", 122224, "Info")
		self:FlashShake(122224)
	end
end
