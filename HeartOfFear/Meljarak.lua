
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Wind Lord Mel'jarak", 897, 741)
if not mod then return end
mod:RegisterEnableMob(
	62397, 62408, 62402, 62405, -- Mel'jarak, Zar'thik Battle-Mender, Kor'thik Elite Blademaster, Sra'thik Amber-Trapper
	62452, 62447, 62451 -- The Zar'thik, The Kor'thik, The Sra'thik
)
--------------------------------------------------------------------------------
-- Locales
--

local korthikStrikeWarned = {}
local primaryAmberIcon, secondaryAmberIcon, phase = nil, nil, 0
local firstKorthikStrikeDone = nil

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

	L.mending = EJ_GetSectionInfo(6306)
	L.mending_desc = "|cFFFF0000WARNING: Only the timer for your 'focus' target will show because all Zar'thik Battle-Menders have separate heal cooldowns.|r "
	L.mending_warning = "Your focus is casting Mending!"
	L.mending_bar = "Focus: Mending"
	L.mending_icon = 122193
end
L = mod:GetLocale()
--same spell name with different EJ entries for normal/heroic
L.recklessness_desc = ("%s\n\n(%s) %s"):format(L.recklessness_desc, CL.heroic, select(2, EJ_GetSectionInfo(6555)))
L.mending_desc = L.mending_desc .. select(2, EJ_GetSectionInfo(6306))

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"next_pack", {122064, "FLASH", "SAY"}, {122125, "FLASH"}, {121881, "SAY", "PROXIMITY", "ICON"}, 122055,
		{122409},
		{122149, "DISPEL_MAGIC"}, "mending",
		122406, {122224, "FLASH"}, {121896, "FLASH"}, {131830, "SAY", "FLASH", "PROXIMITY"}, "recklessness",
		"stages", "berserk", "bosskill",
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
	self:Log("SPELL_AURA_APPLIED_DOSE", "Recklessness", 122354)
	self:Log("SPELL_AURA_APPLIED", "RecklessnessHeroic", 125873)
	self:Log("SPELL_SUMMON", "WindBomb", 131814)
	self:Log("SPELL_CAST_START", "WhirlingBlade", 121896)
	self:Log("SPELL_AURA_APPLIED", "Quickening", 122149)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Quickening", 122149)
	self:Log("SPELL_CAST_START", "Mending", 122193)
	self:Log("SPELL_CAST_START", "RainOfBlades", 122406)
	self:Log("SPELL_AURA_APPLIED", "ImpalingSpear", 122224)
	self:Log("SPELL_AURA_REFRESH", "ImpalingSpear", 122224)
	self:Log("SPELL_AURA_REMOVED", "ImpalingSpearRemoved", 122224)

	self:Log("SPELL_DAMAGE", "WhirlingBladeDamage", 121898)
	self:Log("SPELL_MISSED", "WhirlingBladeDamage", 121898)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")

	self:Death("Win", 62397)
	self:Death("AddDeaths", 62452, 62447, 62451) -- The Zar'thik, The Kor'thik, The Sra'thik
end

function mod:OnEngage(diff)
	self:Bar(121896, 121896, 36, 121896) -- Whirling Blade
	self:Bar(122406, "~"..self:SpellName(122406), 60, 122406) -- Rain of Blades
	self:Bar(122409, "~"..self:SpellName(122409), 19, 122409) -- Korthik Strike
	self:Berserk(self:LFR() and 600 or 480)
	wipe(korthikStrikeWarned)
	primaryAmberIcon, secondaryAmberIcon, phase = nil, nil, 0
	firstKorthikStrikeDone = nil

	self:RegisterEvent("UNIT_AURA")
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "PhaseChange", "boss1", "boss2", "boss3", "boss4")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	self:CheckBossStatus()
	for i = 1, 5 do
		-- Random spawn, check for unit
		local guid = UnitGUID(("boss%d"):format(i))
		if guid and self:MobId(guid) == 62451 then -- The Sra'thik
			if phase == 2 then
				self:CloseProximity(131830)
			end
			self:OpenProximity(121881, 2)
			break
		end
	end
end

function mod:WhirlingBladeDamage(args)
	if not self:LFR() and UnitIsUnit("player", args.destName) then
		self:LocalMessage(args.spellId, CL["you"]:format(args.spellName), "Personal", args.spellId, "Info")
		self:Flash(args.spellId) -- we flash on cast too, but some more can't hurt
	end
end

do
	local korthikStrike = mod:SpellName(122409)
	local UnitDebuff = UnitDebuff
	local function allowKorthikStrike(player)
		korthikStrikeWarned[player] = nil
	end
	function mod:UNIT_AURA(_, unitId)
		if UnitDebuff(unitId, korthikStrike) then
			local player, server = UnitName(unitId)
			if server then
				player = player .. "-" .. server
			end
			if not korthikStrikeWarned[player] then
				korthikStrikeWarned[player] = true
				self:ScheduleTimer(allowKorthikStrike, 10, player)
				self:TargetMessage(122409, korthikStrike, player, "Urgent", 122409, "Alarm")
				self:Bar(122409, "~"..korthikStrike, firstKorthikStrikeDone and 50 or 30, 122409) -- 2nd one ~30, then cooldown 50 sec
				firstKorthikStrikeDone = true
			end
		end
	end
end

function mod:ResidueRemoved(args)
	if UnitIsUnit("player", args.destName) then
		self:LocalMessage(122055, L["residue_removed"]:format(args.spellName), "Positive", 122055)
	end
end

do
	local prisonList, scheduled = mod:NewTargetList(), nil
	local function prison(spellId)
		mod:TargetMessage(spellId, spellId, prisonList, "Important", spellId, "Info")
		scheduled = nil
	end
	function mod:AmberPrison(args)
		if UnitIsUnit("player", args.destName) then
			self:Say(args.spellId, args.spellName)
		end
		prisonList[#prisonList + 1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(prison, 0.1, args.spellId)
		end
		if self:LFR() then return end
		if not primaryAmberIcon then
			self:PrimaryIcon(args.spellId, args.destName)
			primaryAmberIcon = args.destName
		elseif not secondaryAmberIcon then -- leave the icon on the second person hit
			self:SecondaryIcon(args.spellId, args.destName)
			secondaryAmberIcon = args.destName
		end
	end
end

function mod:AmberPrisonRemoved(args)
	if self:LFR() then return end
	if args.destName == primaryAmberIcon then
		self:PrimaryIcon(args.spellId)
		primaryAmberIcon = nil
	elseif args.destName == secondaryAmberIcon then
		self:SecondaryIcon(args.spellId)
		secondaryAmberIcon = nil
	end
end

function mod:RainOfBlades(args)
	self:Message(args.spellId, args.spellName, "Important", args.spellId, "Alert")
	self:Bar(args.spellId, "~"..args.spellName, phase == 2 and 48 or 60, args.spellId)
end

do
	local prev = 0
	function mod:Quickening(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(args.spellId, args.spellName, "Attention", args.spellId, "Alert")
		end
	end
end

function mod:Mending(args)
	if UnitGUID("focus") == args.sourceGUID then
		self:LocalMessage("mending", L["mending_warning"], "Personal", args.spellId, "Alert")
		self:Bar("mending", L["mending_bar"], 37, args.spellId)
	end
end

function mod:WhirlingBlade(args)
	self:Message(args.spellId, args.spellName, "Urgent", args.spellId, "Alarm")
	self:Bar(args.spellId, "~"..args.spellName, phase == 2 and 30 or 45, args.spellId)
	if not self:LFR() then
		self:Flash(args.spellId)
	end
end

function mod:WindBomb(args)
	self:TargetMessage(131830, args.spellName, args.sourceName, "Urgent", 131830, "Alarm")
	if UnitIsUnit("player", args.sourceName) then
		self:Flash(131830)
		self:Say(131830, args.spellName)
	end
end

function mod:Recklessness(args)
	self:Message("recklessness", ("%s (%d)"):format(args.spellName, args.amount or 1), "Attention", args.spellId)
end

function mod:RecklessnessHeroic(args)
	self:Message("recklessness", args.spellName, "Attention", args.spellId)
	self:Bar("recklessness", args.spellName, 30, args.spellId)
end

do
	local prev = 0
	function mod:ResinPoolDamage(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(args.spellId, CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Info")
			self:Flash(args.spellId)
		end
	end
end

function mod:Resin(args)
	if UnitIsUnit("player", args.destName) then
		self:Say(args.spellId, args.spellName)
		self:Flash(args.spellId)
		self:LocalMessage(args.spellId, CL["you"]:format(args.spellName), "Personal", args.spellId, "Info")
	end
end

function mod:ImpalingSpear(args)
	if UnitIsUnit(args.sourceName, "player") then
		self:Bar(args.spellId, args.spellName, 50, args.spellId)
	end
end

function mod:ImpalingSpearRemoved(args)
	if UnitIsUnit(args.sourceName, "player") then
		self:StopBar(args.spellName)
		self:LocalMessage(args.spellId, L["spear_removed"], "Personal", args.spellId, "Info")
		self:Flash(args.spellId)
	end
end

function mod:PhaseChange(unitId)
	if self:MobId(UnitGUID(unitId)) == 62397 then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp < 79 and phase == 0 then -- phase starts at 75
			self:Message("stages", CL["soon"]:format(CL["phase"]:format(2)), "Positive", 131830, "Info")
			phase = 1
		elseif hp < 75 and phase ~= 2 then
			phase = 2
			self:Message("stages", "75% - "..CL["phase"]:format(2), "Positive", 131830, "Info")
			self:Bar(121896, "~"..self:SpellName(121896), 30, 121896) -- Whirling Blade (reset cd)
			self:StopBar("~"..self:SpellName(122406)) -- Rain of Blades, first after p2 seems random
			self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1", "boss2", "boss3", "boss4")
			for i = 1, 5 do
				local guid = UnitGUID(("boss%d"):format(i))
				if guid and self:MobId(guid) == 62451 then -- The Sra'thik
					return
				end
			end
			self:OpenProximity(131830, 5) -- Wind Bomb
		end
	end
end

function mod:AddDeaths(args)
	if args.mobId == 62451 then -- The Sra'thik
		self:CloseProximity(121881)
		if phase == 2 then
			self:OpenProximity(131830, 5) -- if in phase 2 open the wind bomb proximity meter back up
		end
	elseif args.mobId == 62452 then -- The Zar'thik
		self:StopBar(L["mending_bar"])
	elseif args.mobId == 62447 then -- The Kor'thik
		self:StopBar("~"..self:SpellName(122409)) -- Kor'thik Strike
	end
	if self:Heroic() then
		self:Bar("next_pack", CL["other"]:format(L["next_pack"], args.destName), 50, L.next_pack_icon)
		self:DelayedMessage("next_pack", 50, CL["other"]:format(L["next_pack"], args.destName), "Attention", L.next_pack_icon)
	end
end

