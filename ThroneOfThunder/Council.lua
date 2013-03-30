--[[
TODO:
	watch out in case Chilled to the Bone gets CLEU
	consider marking Twisted Fate targets or atleast announcing them
]]--

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
local frostBiteStart, bitingColdStart = nil, nil
local sandGuyDead = nil
local fixated = mod:SpellName(40415)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.priestess_adds = "Priestess adds"
	L.priestess_adds_desc = "Warnings for when High Priestess Mar'li starts to summon adds."
	L.priestess_adds_icon = "inv_misc_tournaments_banner_troll"
	L.priestess_adds_message = "Priestess add"

	L.custom_on_markpossessed = "Mark Possessed Boss"
	L.custom_on_markpossessed_desc = "Mark the possessed boss with a skull, requires promoted or leader."
	L.custom_on_markpossessed_icon = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_8"

	L.assault_stun = "Tank Stunned!"
	L.assault_message = "Assault"
	L.full_power = "Full power"
	L.hp_to_go_power = "%d%% HP to go! (Power: %d)"
	L.hp_to_go_fullpower = "%d%% HP to go! (Full power)"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"priestess_adds", 137203, {137350, "FLASH"}, -- High Priestess Mar'li
		{-7062, "FLASH"}, 136878, {136857, "FLASH", "DISPEL"}, 136894, -- Sul the Sandcrawler
		{137122, "FLASH"}, -- Kazra'jin
		{-7054, "TANK_HEALER"}, {136992, "ICON", "SAY", "PROXIMITY"}, 136990, {137085, "FLASH"}, -- Frost King Malakk
		136442, "custom_on_markpossessed", {137650, "FLASH"}, "proximity", "berserk", "bosskill",
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
	self:Log("SPELL_CAST_SUCCESS", "BlessedGift", 137303) -- Spirit heals a boss
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
	self:Log("SPELL_AURA_APPLIED", "FrigidAssaultStun", 136910)
	-- General
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShadowedSoul", 137650) -- Heroic
	self:Log("SPELL_AURA_APPLIED", "PossessedApplied", 136442)
	self:Log("SPELL_AURA_REMOVED", "PossessedRemoved", 136442)

	self:Death("BlessedGift", 69480) -- Blessed Loa Spirit
	self:Death("Deaths", 69132, 69131, 69134, 69078) -- Priestess, Frost King, Kazra'jin, Sandcrawler
end

function mod:OnEngage()
	self:Berserk(self:LFR() and 720 or 600) -- XXX assumed. 12 min or higher on LFR, prob 15
	bossDead = 0
	if not self:LFR() then
		self:OpenProximity("proximity", 7) -- for Quicksand
	end
	self:CDBar("priestess_adds", 27, L["priestess_adds_message"], L.priestess_adds_icon)
	self:CDBar(-7062, 7) -- Quicksand
	self:Bar(136990, 9.7) -- Frostbite -- might be 7.5?
	hasChilledToTheBone = nil
	frostBiteStart, bitingColdStart = nil, nil
	sandGuyDead = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- High Priestess Mar'li

function mod:MarkedSoul(args)
	self:TargetMessage(137350, args.destName, "Urgent", "Alert", fixated)
	self:TargetBar(137350, 20, args.destName, fixated)
	if self:Me(args.destGUID) then
		self:Flash(137350)
	end
end

function mod:MarkedSoulRemoved(args)
	self:StopBar(fixated, args.destName)
end

function mod:BlessedLoaSpirit(args)
	local lowest, lowestHP = nil, 1
	for i=1,5 do
		local boss = ("boss%d"):format(i)
		local mobId = self:MobId(UnitGUID(boss))
		if mobId == 69134 or mobId == 69078 or mobId == 69131 then -- Kazra'jin, Sandcrawler, Frost King
			local hp = UnitHealth(boss) / UnitHealthMax(boss)
			if hp > 0 and hp < lowestHP then
				lowest = boss
				lowestHP = hp
			end
		end
	end
	if not lowest then return end -- just in case of weirdness if priestess is last
	self:Message(args.spellId, "Attention", nil, CL["other"]:format(fixated, UnitName(lowest)))
	self:Bar(args.spellId, 20, CL["other"]:format(fixated, args.spellName))
end

function mod:BlessedGift()
	self:StopBar(CL["other"]:format(fixated, self:SpellName(137203)))
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

do
	local mastersCall = select(2, UnitClass("player")) == "HUNTER" and mod:SpellName(53271)
	function mod:Entrapped(args)
		if self:Me(args.destGUID) then
			self:Flash(136857)
			self:Message(136857, "Personal", "Info")
		elseif self:Dispeller("magic", nil, 136857) or (mastersCall and GetSpellCooldown(mastersCall) == 0) then -- Master's Call works on it, too
			self:TargetMessage(136857, args.destName, "Attention", nil, nil, nil, true)
		end
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
	if spellId == 137107 and UnitBuff(unit, self:SpellName(136442)) then
		self:Bar(137122, 21) -- Show timer when possessed
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
	elseif sandGuyDead then
		self:OpenProximity(args.spellId, 4, args.destName)
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
	self:Message(-7054, "Attention", "Warning", args.spellName)
	self:Bar(-7054, 30)
end

function mod:FrigidAssault(args)
	if args.amount % 5 == 0 or args.amount > 10 then -- don't spam on low stacks, but spam close to 15 (spam so hard)
		self:StackMessage(-7054, args.destName, args.amount, "Urgent", "Info", L["assault_message"])
	end
end

function mod:FrigidAssaultStun(args)
	self:Message(-7054, "Important", "Warning", L["assault_stun"])
end

-- General

function mod:ShadowedSoul(args)
	if self:Me(args.destGUID) and UnitDebuff("player", self:SpellName(137641)) and args.amount > 9 then -- Soul Fragment on, aka gaining more stacks, 10 stacks = 20% extra damage taken
		self:Message(args.spellId, "Personal", "Info", CL["count"]:format(args.spellName, args.amount))
	end
end

do
	local prevPower = 0
	local possessed = mod:SpellName(136442)
	local function warnFullPower(guid, lastPercHPToGo)
		if prevPower < 100 then return end

		local unitId
		for i=1,5 do
			local boss = ("boss%d"):format(i)
			if UnitGUID(boss) == guid then
				unitId = boss
				break
			end
		end
		if not unitId then return end

		local maxHealth, currHealth = UnitHealthMax(unitId), UnitHealth(unitId)
		local percHPToGo = 25 - math.floor((posessHPStart - currHealth) / maxHealth * 100)
		if percHPToGo < 1 then return end

		if percHPToGo < lastPercHPToGo then
			mod:Message(136442, "Important", "Alert", L["hp_to_go_fullpower"]:format(percHPToGo))
		end
		mod:ScheduleTimer(warnFullPower, 3, guid, percHPToGo)
	end

	function mod:PossessedHPToGo(unitId)
		if not UnitBuff(unitId, possessed) then return end
		local maxHealth, currHealth = UnitHealthMax(unitId), UnitHealth(unitId)
		local percHPToGo = 25 - math.floor((posessHPStart - currHealth) / maxHealth * 100)
		if percHPToGo < 1 then return end

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
			self:Message(136442, "Important", "Alert", L["hp_to_go_fullpower"]:format(percHPToGo))
			self:ScheduleTimer(warnFullPower, 3, UnitGUID(unitId), percHPToGo)
		end
	end

	function mod:PossessedApplied(args)
		prevPower = 0
		self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "PossessedHPToGo", "boss1", "boss2", "boss3", "boss4", "boss5") -- need to register all, because they jump around like crazy during the encounter

		local lingeringCount = 0
		for i=1,5 do
			local boss = ("boss%d"):format(i)
			if UnitGUID(boss) == args.destGUID then
				lingeringCount = select(4, UnitBuff(boss, self:SpellName(136467))) or 0
				posessHPStart = UnitHealth(boss)
				if self.db.profile.custom_on_markpossessed then
					SetRaidTarget(boss, 8)
				end
			end
		end

		local regenMultiplier = self:Heroic() and 15 or self:LFR() and 5 or 10
		local duration = 66 * (100 - lingeringCount * regenMultiplier) / 100 -- 66 seconds till full power without any lingering presences stacks
		self:Message(args.spellId, "Neutral", "Long", CL["other"]:format(args.spellName, args.destName))
		self:Bar(args.spellId, duration, L["full_power"])

		local mobId = self:MobId(args.destGUID)
		if mobId == 69131 then -- Frost King
			self:StopBar(136992) -- Biting Cold
			if bitingColdStart then
				self:CDBar(136990, 45 - (GetTime() - bitingColdStart)) -- Frostbite -- CD bar because of Possessed buff travel time
			end
			if self:Heroic() then
				self:RegisterUnitEvent("UNIT_AURA", "ChilledToTheBone", "player")
			end
		end
	end

	function mod:PossessedRemoved(args)
		prevPower = 0
		self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", "boss1", "boss2", "boss3", "boss4", "boss5")
		if self.db.profile.custom_on_markpossessed then
			for i=1,5 do
				local boss = ("boss%d"):format(i)
				if UnitGUID(boss) == args.destGUID then
					SetRaidTarget(boss, 0) -- clear the icon because posses have travel time, so people know when something is no longer possessed
				end
			end
		end

		-- leave in all the elseif statements to be ready in case they are needed on heroic
		local mobId = self:MobId(args.destGUID)
		if mobId == 69131 then -- Frost King
			self:StopBar(136990) -- Frostbite
			if frostBiteStart then
				self:Bar(136992, 45 - (GetTime() - frostBiteStart)) -- Biting Cold
			end
			if self:Heroic() then self:UnregisterUnitEvent("UNIT_AURA", "player") end
		end
	end
end

function mod:Deaths(args)
	if args.mobId == 69131 then -- Frost King
		self:StopBar(136992) -- Frostbite
		self:StopBar(136990) -- Biting Cold
		self:StopBar(-7054) -- Frigid Assault
	elseif args.mobId == 69078 then -- Sandcrawler
		sandGuyDead = true
		self:StopBar(-7062) -- Quicksand
		self:StopBar(136894) -- Sandstorm
		self:CloseProximity()
	end

	bossDead = bossDead + 1
	if bossDead > 4 then
		self:Win()
	end
end

