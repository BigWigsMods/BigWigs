--[[
TODO:
	look out for lingering presence CLEU in case it gets added by blizzard ( not yet in 25 H ptr )
	watch out in case Chilled to the Bone gets CLEU
	full power bar needs heavy testing
	consider marking Twisted Fate targets
]]--

if select(4, GetBuildInfo()) < 50200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Council of Elders", 930, 816)
if not mod then return end
mod:RegisterEnableMob(69132, 69131, 69134, 69078) -- High Priestess Mar'li, Frost King Malakk, Kazra'jin, Sul the Sandcrawler

--------------------------------------------------------------------------------
-- Locals
--
local hasChilledToTheBone = nil
local bossDead = 0
local posessHPStart = 0
local lingeringTracker = {
	[69132] = 0,
	[69131] = 0,
	[69134] = 0,
	[69078] = 0,
}
local frostBiteStart, bitingColdStart = nil, nil
local sandGuyDead = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.priestess_adds = "Priestess adds"
	L.priestess_adds_desc = "Warnings for when High Priestess Mar'li starts to summon adds."
	L.priestess_adds_icon = "inv_misc_tournaments_banner_troll" --137203
	L.priestess_adds_message = "Priestess add"

	L.full_power = "Full power"
	L.assault_message = "Assault"
	L.hp_to_go_power = "HP to go: %d%% - Power: %d"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"priestess_adds", 137203, {137350, "FLASH"}, -- High Priestess Mar'li
		{-7062, "FLASH"}, 136878, {136857, "FLASH"}, 136894, -- Sul the Sandcrawler
		{137122, "FLASH"}, -- Kazra'jin
		{-7054, "TANK_HEALER"}, {136992, "ICON", "SAY", "PROXIMITY"}, 136990, {137085, "FLASH"}, -- Frost King Malakk
		136442, {137650, "FLASH"}, "proximity", "berserk", "bosskill",
	}, {
		["priestess_adds"] = -7050,
		[-7062] = -7049,
		[137122] = -7048,
		[-7054] = -7047,
		[136442] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	-- High Priestess Mar'li
	self:Log("SPELL_CAST_START", "PriestessAdds", 137203, 137350, 137891) -- Blessed, Shadowed, Twisted Fate
	self:Log("SPELL_CAST_SUCCESS", "BlessedLoaSpirit", 137203)
	self:Log("SPELL_CAST_SUCCESS", "BlessedGift", 137303) -- Loa hits a boss
	self:Log("SPELL_AURA_APPLIED", "MarkedSoul", 137359)
	self:Log("SPELL_AURA_REMOVED", "MarkedSoulRemoved", 137359)
	-- Sul the Sandcrawler
	self:Log("SPELL_AURA_APPLIED", "Quicksand", 136860)
	self:Log("SPELL_AURA_APPLIED", "Ensnared", 136878)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Ensnared", 136878)
	self:Log("SPELL_AURA_APPLIED", "Entrapped", 136857)
	self:Log("SPELL_CAST_START", "Sandstorm", 136894)
	-- Kazra'jin
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "RecklessCharge", "boss1", "boss2", "boss3", "boss4", "boss5")
	self:Log("SPELL_DAMAGE", "RecklessChargeDamage", 137133)
	--Frost King Malakk
	self:Log("SPELL_AURA_APPLIED", "FrostbiteApplied", 136990, 136922)
	self:Log("SPELL_AURA_APPLIED", "BitingColdApplied", 136992)
	self:Log("SPELL_AURA_REMOVED", "BitingColdRemoved", 136992)
	self:Log("SPELL_CAST_SUCCESS", "FrigidAssaultStart", 136904)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FrigidAssault", 136903)
	-- General
	self:Log("SPELL_AURA_APPLIED", "PossessedApplied", 136442)
	self:Log("SPELL_AURA_REMOVED", "PossessedRemoved", 136442)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShadowedSoul", 137650)

	self:Death("Deaths", 69480, 69132, 69131, 69134, 69078) -- Blessed Loa Spirit, Priestess, Frost King, Kazra'jin, Sandcrawler
end

function mod:OnEngage()
	self:Berserk(self:LFR() and 720 or 600) -- XXX assumed. 12 min or higher on LFR, prob 15
	bossDead = 0
	for k in next, lingeringTracker do lingeringTracker[k] = 0 end
	self:OpenProximity("proximity", 7) -- for Quicksand
	self:CDBar("priestess_adds", 27, L["priestess_adds_message"], L.priestess_adds_icon)
	self:CDBar(-7062, 7) -- Quicksand
	self:Bar(136990, 9.7) -- Frostbite -- might be 7.5?
	hasChilledToTheBone = nil
	frostBiteStart, bitingColdStart = nil, nil
	sandGuyDead = false
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- High Priestess Mar'li

function mod:MarkedSoul(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alert", 40415, args.spellId)
	self:TargetBar(args.spellId, 20, args.destName, 40415, args.spellId) -- 40415 = Fixated
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
	end
end

function mod:MarkedSoulRemoved(args)
	self:StopBar(40415, args.destName)
end

function mod:BlessedLoaSpirit(args)
	local lowest, lowestHP = nil, 1
	for i=1, 5 do
		local boss = ("boss%d"):format(i)
		local mobId = self:MobId(UnitGUID(boss))
		if mobId == 69134 or mobId == 69078 or mobId == 69131 then -- Kazra'jin, Sandcrawler, Frost King
			local hp = UnitHealth(boss) / UnitHealthMax(boss)
			if hp < lowestHP then
				lowest = boss
				lowestHP = hp
			end
		end
	end
	self:TargetMessage(args.spellId, UnitName(lowest), "Attention", "Alert", 40415, args.spellId) -- yellow text!
	self:TargetBar(args.spellId, args.spellName, 20, 40415, args.spellId) -- 40415 = Fixated
end

function mod:BlessedGift(args)
	self:StopBar(40415, self:SpellName(137203))
end

function mod:PriestessAdds(args)
	self:Message("priestess_adds", "Important", "Alarm", args.spellId)
	self:CDBar("priestess_adds", 33, L["priestess_adds_message"], L.priestess_adds_icon)
end

-- Sul the Sandcrawler

function mod:Sandstorm(args)
	self:Bar(args.spellId, 38)
	self:Message(args.spellId, "Urgent", "Alert")
end

function mod:Entrapped(args)
	if self:Me(args.destGUID) then
		self:Flash(136857)
		self:Message(136857, "Personal", "Info")
	elseif self:Dispeller("magic") or ((select(2, UnitClass("player")) == "HUNTER") and (GetSpellCooldown(self:SpellName(53271)) == 0))then -- Master's call works on it too
		self:TargetMessage(136857, args.destName, "Attention", nil, nil, nil, true)
	end
end

function mod:Ensnared(args)
	if self:Me(args.destGUID) then
		self:Message(136878, "Attention", nil, CL["count"]:format(args.spellName, args.amount or 1))
	end
end

function mod:Quicksand(args)
	self:CDBar(-7062, 33, args.spellId)
	if self:Me(args.destGUID) then
		self:Message(-7062, "Personal", "Info", CL["underyou"]:format(args.spellName))
		self:Flash(-7062)
	end
end

-- Kazra'jin

function mod:RecklessCharge(unit, spellName, _, _, spellId)
	if spellId == 137107 then
		if UnitBuff(unit, self:SpellName(136442)) then -- Show timer when possessed
			self:Bar(137122, 21)
		end
		local target = unit.."target"
		if UnitIsUnit(target, "player") then
			self:Message(137122, "Urgent", "Alarm", CL["you"]:format(spellName))
		elseif self:Range(target) < 6 then
			self:RangeMessage(137122)
		end
	end
end

do
	local prev = 0
	function mod:RecklessChargeDamage(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(137122, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(137122)
		end
	end
end

--Frost King Malakk

-- We only use Icon on Biting cold, so people know that if someone has icon over their head, you need to stay away
function mod:FrostbiteApplied(args)
	self:TargetMessage(136990, args.destName, "Positive", "Info")
	self:Bar(136990, 45)
	frostBiteStart = GetTime()
end

function mod:BitingColdApplied(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alert")
	self:Bar(args.spellId, 45)
	self:SecondaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		if sandGuyDead then
			self:OpenProximity(args.spellId, 4)
		end
	else
		if sandGuyDead then
			self:OpenProximity(args.spellId, 4, args.destName)
		end
	end
	bitingColdStart = GetTime()
end

function mod:BitingColdRemoved(args)
	self:SecondaryIcon(args.spellId)
	if sandGuyDead then
		self:CloseProximity(args.spellId)
	end
end

function mod:ChilledToTheBone()
	if not hasChilledToTheBone and UnitDebuff("player", self:SpellName(137085)) then
		self:Message(137085, "Personal", "Info")
		self:Flash(137085)
		hasChilledToTheBone = true
	elseif not UnitDebuff("player", self:SpellName(137085)) then
		hasChilledToTheBone = nil
	end
end

-- Tank alerts so you know when you should be watching for stacks (if you're not avoiding hits, it can stack really fast)
function mod:FrigidAssaultStart(args)
	self:Message(-7054, "Attention", "Alarm", args.spellName)
	self:Bar(-7054, 30)
end

function mod:FrigidAssault(args)
	if args.amount % 5 == 0 or args.amount > 10 then -- don't spam on low stacks, but spam close to 15 (spam so hard)
		self:StackMessage(-7054, args.destName, args.amount, "Urgent", "Info", L["assault_message"])
	end
end

-- General

function mod:ShadowedSoul(args)
	if self:Me(args.destGUID) and UnitDebuff("player", self:SpellName(137641)) and args.amount > 9 then -- Soul Fragment on, aka gaining more stacks, 10 stacks = 20% extra damage taken
		self:Message(args.spellId, "Personal", "Info", CL["count"]:format(args.spellName, args.amount))
	end
end

do
	local prevPower = 0
	function mod:PossessedHPToGo(unitId)
		if not UnitBuff(unitId, self:SpellName(136442)) then return end -- possessed
		local maxHealth, currHealth = UnitHealthMax(unitId), UnitHealth(unitId)
		local percHPToGo = 25-((posessHPStart - currHealth) / maxHealth * 100)
		local power = UnitPower(unitId)
		if power > 32 and prevPower == 0 then
			prevPower = 33
			self:Message(136442, "Attention", nil, L["hp_to_go_power"]:format(percHPToGo, power))
		elseif power > 49 and prevPower == 33 then
			prevPower = 50
			self:Message(136442, "Attention", nil, L["hp_to_go_power"]:format(percHPToGo, power))
		elseif power > 69 and prevPower == 50 then
			prevPower = 70
			self:Message(136442, "Urgent", nil, L["hp_to_go_power"]:format(percHPToGo, power))
		elseif power > 79 and prevPower == 70 then
			prevPower = 80
			self:Message(136442, "Important", nil, L["hp_to_go_power"]:format(percHPToGo, power))
		elseif power > 89 and prevPower == 80 then
			prevPower = 90
			self:Message(136442, "Important", nil, L["hp_to_go_power"]:format(percHPToGo, power))
		elseif power > 99 and prevPower == 90 then
			prevPower = 100
			self:Message(136442, "Important", nil, L["hp_to_go_power"]:format(percHPToGo, power).." "..L["full_power"]) -- could probably make thise be a less awkward message with some more localization
			-- then might as well consider doing some scheduled warning till hp to go is less than 2%
		end
	end

	local fullPower = 66 -- 66 seconds till full power without any lingering presences stacks
	function mod:PossessedApplied(args)
		prevPower = 0
		self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "PossessedHPToGo", "boss1", "boss2", "boss3", "boss4", "boss5") -- need to register all, because they jump around like crazy during the encounter

		for i = 1, 5 do
			local boss = ("boss%d"):format(i)
			if UnitGUID(boss) == args.destGUID then
				posessHPStart = UnitHealth(boss)
				SetRaidIcon(boss, 8)
			end
		end

		local mobId = self:MobId(args.destGUID)
		local lingering = lingeringTracker[mobId]
		local difficultyRegenMultiplier = self:Heroic() and 15 or self:LFR() and 5 or 10
		local duration = (lingering == 0) and fullPower or (fullPower*(100-lingering*difficultyRegenMultiplier)/100)
		self:Message(args.spellId, "Attention", "Long", ("%s (%s)"):format(args.spellName, args.destName))
		self:Bar(args.spellId, duration, L["full_power"])

		-- leave in all the elseif statements to be ready in case they are needed on heroic
		if mobId == 69132 then -- Priestess
		elseif mobId == 69131 then -- Frost King
			self:StopBar(136992) -- Biting Cold
			if bitingColdStart then
				self:CDBar(136990, 45-(GetTime()-bitingColdStart))-- Frostbite -- CD bar because of Possessed buff travel time
			end
			if self:Heroic() then
				self:RegisterUnitEvent("UNIT_AURA", "ChilledToTheBone", "player")
			end
		elseif mobId == 69134 then -- Kazra'jin
		elseif mobId == 69078 then -- Sandcrawler
		end
	end
end

function mod:PossessedRemoved(args)
	self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", "boss1", "boss2", "boss3", "boss4", "boss5") -- for a little bit of performance increase
	for i = 1, 5 do
		local boss = ("boss%d"):format(i)
		if UnitGUID(boss) == args.destGUID then
			SetRaidIcon(boss, 0) -- clear the icon because posses have travel time, so people know when something is no longer possessed
		end
	end

	local mobId = self:MobId(args.destGUID)
	lingeringTracker[mobId] = lingeringTracker[mobId] + 1 -- this is needed because Lingering Presence have no CLEU event

	-- leave in all the elseif statements to be ready in case they are needed on heroic
	if mobId == 69132 then -- Priestess
	elseif mobId == 69131 then -- Frost King
		self:StopBar(136990) -- Frostbite
		if frostBiteStart then
			self:Bar(136992, 45-(GetTime()-frostBiteStart)) -- Biting Cold
		end
		if self:Heroic() then self:UnregisterUnitEvent("UNIT_AURA", "player") end
	elseif mobId == 69134 then -- Kazra'jin
	elseif mobId == 69078 then -- Sandcrawler
	end
end

function mod:Deaths(args)
	-- leave in all the elseif statements to be ready in case they are needed on heroic
	if args.mobId == 69480 then -- Blessed Loa Spirit
		self:StopBar(40415, self:SpellName(137203))
		return
	elseif args.mobId == 69132 then -- Priestess
	elseif args.mobId == 69131 then -- Frost King
		self:StopBar(136992) -- Frostbite
		self:StopBar(136990) -- Biting Cold
	elseif args.mobId == 69134 then -- Kazra'jin
	elseif args.mobId == 69078 then -- Sandcrawler
		sandGuyDead = true
		self:StopBar(-7062) -- Quicksand
		self:CloseProximity()
	end

	bossDead = bossDead + 1
	if bossDead > 4 then
		self:Win()
	end
end

