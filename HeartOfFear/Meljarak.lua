
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Wind Lord Mel'jarak", 897, 741)
if not mod then return end
mod:RegisterEnableMob(62397, 62408, 62402, 62405) -- boss, mender, battlemaster, trapper

--------------------------------------------------------------------------------
-- Locales
--

local korthikStrikeWarned = {}
local primaryAmberIcon, secondaryAmberIcon, phase
local firstKorthikStrikeDone

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.next_pack, L.next_pack_desc = EJ_GetSectionInfo(6554) --reinforcements
	L.next_pack_icon = "ACHIEVEMENT_RAID_MANTIDRAID04"

	L.recklessness, L.recklessness_desc = EJ_GetSectionInfo(6331)
	L.recklessness_icon = 125873

	L.spear_removed = "Your Impaling Spear was removed!"
	L.residue_removed = "%s removed!"

	L.trapper = "The Sra'thik" -- name on the boss frame for the trappers
end
L = mod:GetLocale()
--same spell name with different EJ entries for normal/heroic
L.recklessness_desc = ("%s\n\n(%s) %s"):format(L.recklessness_desc, CL.heroic, select(2, EJ_GetSectionInfo(6555)))

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"next_pack", { 122064, "FLASHSHAKE", "SAY" }, {122125, "FLASHSHAKE"}, {121881, "SAY", "PROXIMITY", "ICON"}, 122055,
		{ 122409 },
		122149, 122193,
		122406, {122224, "FLASHSHAKE"}, { 121896, "FLASHSHAKE" }, { 131830, "SAY", "FLASHSHAKE", "PROXIMITY" }, "recklessness",
		"berserk", "bosskill",
	}, {
		["next_pack"] = "heroic",
		[122064] = "ej:6300",
		[122409] = "ej:6334",
		[122149] = "ej:6305",
		[122406] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "AmberPrison", 121881) -- initial cast only
	self:Log("SPELL_AURA_REMOVED", "AmberPrisonRemoved", 121881) -- initial cast only
	self:Log("SPELL_AURA_REMOVED", "ResidueRemoved", 122055)
	self:Log("SPELL_AURA_APPLIED", "Resin", 122064)
	self:Log("SPELL_PERIODIC_DAMAGE", "ResinPoolDamage", 122125)
	self:Log("SPELL_AURA_APPLIED", "Recklessness", 122354)
	self:Log("SPELL_AURA_APPLIED", "RecklessnessHeroic", 125873)
	self:Log("SPELL_SUMMON", "WindBomb", 131814)
	self:Log("SPELL_CAST_START", "WhirlingBlade", 121896)
	self:Log("SPELL_CAST_START", "Quickening", 122149)
	self:Log("SPELL_CAST_START", "Mending", 122193)
	self:Log("SPELL_CAST_START", "RainOfBlades", 122406)
	self:Log("SPELL_AURA_APPLIED", "ImpalingSpear", 122224)
	self:Log("SPELL_AURA_REFRESH", "ImpalingSpear", 122224)
	self:Log("SPELL_AURA_REMOVED", "ImpalingSpearRemoved", 122224)
	self:Log("SPELL_DAMAGE", "WhirlingBladeDamage", 121898)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")

	self:Death("Deaths", 62397, 62405) -- Boss, Trapper
end

function mod:OnEngage(diff)
	self:Bar(121896, 121896, 36, 121896) --Whirling Blade
	self:Bar(122406, "~"..mod:SpellName(122406), 60, 122406) --Rain of Blades
	self:Bar(122409, "~"..mod:SpellName(122409), 19, 122409) --Korthik Strike
	self:Berserk(480)
	wipe(korthikStrikeWarned)
	primaryAmberIcon, secondaryAmberIcon, phase = nil, nil, nil
	firstKorthikStrikeDone = nil

	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	self:CheckBossStatus()
	for i = 2, MAX_BOSS_FRAMES do
		if UnitName("boss"..i) == L["trapper"] then
			self:OpenProximity(4, 121881) -- for amber prison EJ says 2 yards, but it might be bigger range -- 4 should be more than safe
		end
	end
end

function mod:WhirlingBladeDamage(player, spellId, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:LocalMessage(spellId, CL["you"]:format(spellName), "Personal", spellId, "Info")
		self:FlashShake(spellId) -- we FNS on cast too, but some more can't hurt
	end
end

do
	local korthikStrike = mod:SpellName(122409)
	local function allowKortikStrike(player)
		korthikStrikeWarned[player] = nil
	end
	function mod:UNIT_AURA(_, unitId)
		local player = UnitName(unitId)
		if UnitDebuff(unitId, korthikStrike) and not korthikStrikeWarned[player] then
			korthikStrikeWarned[player] = true
			self:ScheduleTimer(allowKortikStrike, 10, player)
			self:TargetMessage(122409, korthikStrike, player, "Urgent", 122409, "Alarm") -- does this need a bar? (2nd one ~30, then cooldown 50 sec)
			self:Bar(122409, "~"..korthikStrike, firstKorthikStrikeDone and 50 or 30, 122409)
			firstKorthikStrikeDone = true
		end
	end
end

function mod:ResidueRemoved(player, _, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:LocalMessage(122055, L["residue_removed"]:format(spellName), "Positive", 122055)
	end
end

do
	local prisonList, scheduled = mod:NewTargetList(), nil
	local function prison(spellName)
		mod:TargetMessage(121881, spellName, prisonList, "Important", 122740, "Info")
		scheduled = nil
	end
	function mod:AmberPrison(player, _, _, _, spellName)
		if UnitIsUnit("player", player) then
			self:Say(121881, CL["say"]:format(spellName))
		end
		prisonList[#prisonList + 1] = player
		if not primaryAmberIcon then
			self:PrimaryIcon(121881, player)
			primaryAmberIcon = player
		else
			self:SecondaryIcon(121881, player)
			secondaryAmberIcon = player
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(prison, 0.1, spellName)
		end
	end
end

function mod:AmberPrisonRemoved(player)
	if UnitIsUnit(player, primaryAmberIcon) then
		self:PrimaryIcon(121881)
	elseif UnitIsUnit(player, secondaryAmberIcon) then
		self:SecondaryIcon(121881)
	end
end

function mod:RainOfBlades(_, _, _, _, spellName)
	self:Message(122406, spellName, "Important", 122406, "Alert")
	self:Bar(122406, "~"..spellName, 60, 122406)
end

function mod:Quickening(_, _, _, _, spellName)
	self:Message(122149, spellName, "Attention", 122149)
end

function mod:Mending(_, _, source, _, spellName, _, _, _, _, _, sGUID)
	if UnitGUID("focus") == sGUID then
		self:LocalMessage(122193, CL["cast"]:format(spellName), "Personal", 122193, "Info")
		self:Bar(122193, spellName, 37, 122193)
	end
end

function mod:WhirlingBlade(_, _, _, _, spellName)
	self:Message(121896, spellName, "Urgent", 121896, "Alarm")
	self:Bar(121896, "~"..spellName, 45, 121896)
	self:FlashShake(121896)
end


function mod:WindBomb(_, _, player, _, spellName)
	self:TargetMessage(131830, spellName, player, "Urgent", 131830, "Alarm")
	if UnitIsUnit("player", player) then
		self:FlashShake(131830)
		self:Say(131830, CL["say"]:format(spellName))
	end
end

function mod:Recklessness(_, spellId, _, _, spellName, buffStacks)
	self:Message("recklessness", ("%s (%d)"):format(spellName, buffStacks or 1), "Attention", spellId)
end

function mod:RecklessnessHeroic(_, spellId, _, _, spellName)
	self:Message("recklessness", spellName, "Attention", spellId)
	self:Bar("recklessness", spellName, 30, spellId)
	self:Bar("next_pack", L["next_pack"], 50, L["next_pack_icon"]) --cd isn't 45 like the ej says?
	self:DelayedMessage("next_pack", 50, L["next_pack"], "Attention", L["next_pack_icon"])
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

function mod:UNIT_HEALTH_FREQUENT(_, unitId)
	if unitId == "boss1" then -- hopefully always the boss
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp < 78 and not phase then -- phase starts at 75
			self:Message(131830, CL["soon"]:format(CL["phase"]:format(2)), "Positive", 131830, "Info") -- should it maybe have it's own option key?
			phase = 1
		elseif hp < 75 then
			self:Message(131830, CL["phase"]:format(2), "Positive", 131830, "Info")
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
			phase = 2
			local trappersNotPresent = true
			for i = 2, MAX_BOSS_FRAMES do
				if UnitName("boss"..i) == L["trapper"] then
					trappersNotPresent = false
				end
			end
			if trappersNotPresent then
				self:OpenProximity(5, 131830)
			end
		end
	end
end

function mod:Deaths(unitId)
	if unitId == 62397 then -- boss
		self:Win()
	elseif unitId == 62405 then -- trapper
		if phase == 2 then
			self:OpenProximity(5, 131830) -- if in phase 2 open the wind bomb proximity meter back up
		else
			self:CloseProximity(121881)
		end
	elseif unitId == 62408 then
		self:StopBar(self:SpellName(122193)) -- mending
		self:StopBar(self:SpellName(122149)) -- quickening
	end
end
