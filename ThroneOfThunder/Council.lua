--[[
TODO:
	look out for lingering presence CLEU in case it gets added by blizzard ( not yet in 10 N ptr )
	watch out in case Chilled to the Bone gets CLEU
	full power bar needs heavy testing
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
local hasChilledToTheBone = false
local UnitIsUnit = UnitIsUnit
local bossDead = 0
local posessHPStart = 0
local lingeringTracker = {
	[69132] = 0,
	[69131] = 0,
	[69134] = 0,
	[69078] = 0,
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.full_power = "Full power"

	L.assault, L.assault_desc = EJ_GetSectionInfo(7054)
	L.assault_icon = 136904
	L.assault_message = "Assault"

	L.loa_kills = "Loa kills: %s"
	L.priestess_add = "Priestess add"
	L.priestess_adds = "Priestess adds"
	L.priestess_adds_desc = "Warning for all kinds of adds from High Priestess Mar'li"
	L.priestess_adds_icon = 137203
	L.hp_to_go_power = "HP to go: %d%% - Power: %d"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"priestess_adds", {137359, "FLASH"}, -- High Priestess Mar'li
		{"ej:7062", "FLASH"}, 136878, {136857, "FLASH"}, 136894, -- Sul the Sandcrawler
		{137122, "FLASH"}, -- Kazra'jin
		{"assault", "TANK_HEALER"}, {136992, "ICON", "SAY", "PROXIMITY"}, 136990, {137085, "FLASH"}, --Frost King Malakk
		136442, "proximity", "berserk", "bosskill",
	}, {
		["priestess_adds"] = "ej:7050",
		["ej:7062"] = "ej:7049",
		[137122] = "ej:7048",
		["assault"] = "ej:7047",
		[136442] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	-- High Priestess Mar'li
	self:Log("SPELL_CAST_START", "PriestessAdds", 137203, 137350, 137891) -- Blessed, Shadowed, Twisted Fate -- don't need different handlers
	self:Log("SPELL_AURA_APPLIED", "MarkedSoul", 137359)
	-- Sul the Sandcrawler
	self:Log("SPELL_AURA_APPLIED", "Quicksand", 136860)
	self:Log("SPELL_AURA_APPLIED", "Ensnared", 136878)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Ensnared", 136878)
	self:Log("SPELL_AURA_APPLIED", "Entrapped", 136857)
	self:Log("SPELL_CAST_START", "Sandstorm", 136894)
	-- Kazra'jin
	self:Log("SPELL_CAST_SUCCESS", "RecklessCharge", 137122)
	self:Log("SPELL_DAMAGE", "RecklessChargeDamage", 137133)
	--Frost King Malakk
	self:Log("SPELL_AURA_APPLIED", "FrostbiteApplied", 136990, 136922)
	self:Log("SPELL_AURA_APPLIED", "BitingColdApplied", 136992)
	self:Log("SPELL_AURA_REMOVED", "BitingColdRemoved", 136992)
	self:Log("SPELL_AURA_APPLIED", "Assault", 136903)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Assault", 136903)
	-- General
	self:Log("SPELL_AURA_APPLIED", "PossessedApplied", 136442)
	self:Log("SPELL_AURA_REMOVED", "PossessedRemoved", 136442)

	self:Death("Deaths", 69132, 69131, 69134, 69078)
end

function mod:OnEngage()
	self:Berserk(600) -- XXX assumed
	bossDead = 0
	for _, v in pairs(lingeringTracker) do v = 0 end
	self:OpenProximity("proximity", self:Heroic() and 7 or 5)
	self:Bar("priestess_adds", "~"..L["priestess_add"], 27, 137203)
	self:Bar("ej:7062", "~"..self:SpellName(136860), 7, 136860) -- Quicksand
	self:Bar(136992, 136992, 60, 136992) -- Biting Cold -- XXX not sure if 1 min is right feels too long
	hasChilledToTheBone = false
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- High Priestess Mar'li
function mod:MarkedSoul(args)
	self:TargetMessage(args.spellId, args.spellName, args.destName, "Urgent", args.spellId, "Alert")
	self:Bar(args.spellId, L["loa_kills"]:format(args.destName), 20, args.spellId)
	if UnitIsUnit(args.destName, "player") then
		self:Flash(args.spellId)
	end
end

function mod:PriestessAdds(args)
	self:Message("priestess_adds", args.spellName, "Important", args.spellId, "Alarm")
	self:Bar("priestess_adds", "~"..L["priestess_add"], 33, args.spellId)
	-- we use a localized string so we don't have to bother with stopping and restarting bars on posess, since priestess adds share cooldown
end

-- Sul the Sandcrawler
function mod:Sandstorm(args)
	-- Ability is used about 1 sec after the boss gets possessed, so no point to makea bar
	self:Message(args.spellId, args.spellName, "Urgent", args.spellId, "Alert")
end

function mod:Entrapped(args)
	if UnitIsUnit(args.destName, "player") then
		self:Flash(136857)
		self:LocalMessage(136857, args.spellName, "Personal", args.spellId, "Info")
	elseif self:Dispeller("magic") or ((select(2, UnitClass("player")) == "HUNTER") and (GetSpellCooldown(self:SpellName(53271)) == 0))then -- Master's call works on it too
		self:LocalMessage(136857, args.spellName, "Attention", args.spellId, nil, args.destName)
	end
end

function mod:Ensnared(args)
	if UnitIsUnit(args.destName, "player") then
		self:LocalMessage(136878, ("%s (%d)"):format(args.spellName, args.amount or 1), "Attention", args.spellId)
	end
end

function mod:Quicksand(args)
	self:Bar("ej:7062", "~"..args.spellName, 33, args.spellId)
	if UnitIsUnit(args.destName, "player") then
		self:LocalMessage("ej:7062", CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Info")
		self:Flash("ej:7062")
	end
end

-- Kazra'jin
function mod:RecklessCharge(args)
	-- XXX Not sure how useful this is, might want to remove it later
	self:Bar(args.spellId, args.spellName, 6, args.spellId)
end

do
	local prev = 0
	function mod:RecklessChargeDamage(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(137122, CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Info")
			self:Flash(137122)
		end
	end
end

--Frost King Malakk

-- We only use Icon on Biting cold, so people know that if someone has icon over their head, you need to stay away
function mod:FrostbiteApplied(args)
	self:TargetMessage(136990, args.spellName, args.destName, "Positive", args.spellId, "Info")
	self:Bar(136990, args.spellName, 45, args.spellId)
end

function mod:BitingColdApplied(args)
	self:TargetMessage(args.spellId, args.spellName, args.destName, "Urgent", args.spellId, "Alert")
	self:Bar(args.spellId, args.spellName, 47, args.spellId)
	self:SecondaryIcon(args.spellId, args.destName)
	if UnitIsUnit(args.destName, "player") then
		self:Say(args.spellId)
		self:OpenProximity(args.spellId, 4)
	end
end

function mod:BitingColdRemoved(args)
	self:SecondaryIcon(args.spellId)
	if UnitIsUnit(args.destName, "player") then
		self:CloseProximity(args.spellId)
	end
end

function mod:ChilledToTheBone()
	if not hasChilledToTheBone and UnitDebuff("player", self:SpellName(137085)) then
		self:LocalMessage(137085, 137085, "Personal", 137085, "Info")
		self:Flash(137085)
		hasChilledToTheBone = true
	elseif not UnitDebuff("player", self:SpellName(137085)) then
		hasChilledToTheBone = false
	end
end

-- General

function mod:Assault(args)
	args.amount = args.amount or 1
	if args.amount % 5 == 0 or args.amount > 10 then -- don't spam on low stacks, but spam close to 15
		self:LocalMessage("assault", CL["stack"], "Urgent", args.spellId, "Info", args.destName, args.amount, L["assault_message"])
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
			self:Message(136442, L["hp_to_go_power"]:format(percHPToGo, power), "Attention", 136442)
		elseif power > 49 and prevPower == 33 then
			prevPower = 50
			self:Message(136442, L["hp_to_go_power"]:format(percHPToGo, power), "Attention", 136442)
		elseif power > 69 and prevPower == 50 then
			prevPower = 70
			self:Message(136442, L["hp_to_go_power"]:format(percHPToGo, power), "Urgent", 136442)
		elseif power > 79 and prevPower == 70 then
			prevPower = 80
			self:Message(136442, L["hp_to_go_power"]:format(percHPToGo, power), "Important", 136442)
		elseif power > 89 and prevPower == 80 then
			prevPower = 90
			self:Message(136442, L["hp_to_go_power"]:format(percHPToGo, power), "Important", 136442)
		end
	end
	local fullPower = 66 -- 66 seconds till full power without any lingering presences stacks
	function mod:PossessedApplied(args)
		prevPower = 0
		for i = 1, 5 do
			local id = ("boss%d"):format(i)
			local bossGUID = UnitGUID(id)
			if bossGUID == args.destGUID then
				posessHPStart = UnitHealth(id)
				SetRaidTarget(id, 8)
			end
		end
		self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "PossessedHPToGo", "boss1", "boss2", "boss3", "boss4", "boss5") -- need to register all, because they jump around like crazy during the encounter
		local mobId = self:GetCID(args.destGUID)
		local difficultyRegenMultiplier = self:Heroic() and 15 or self:LFR() and 5 or 10
		local duration = (lingeringTracker[mobId] == 0) and fullPower or (fullPower*(100-lingeringTracker[mobId]*difficultyRegenMultiplier)/100)
		self:Message(args.spellId, ("%s (%s)"):format(args.spellName, args.destName), "Attention", args.spellId, "Long")
		self:Bar(args.spellId, L["full_power"], duration, args.spellId)
		-- leave in all the elseif statements to be ready in case they are needed on heroic
		if mobId == 69132 then -- Priestess
		elseif mobId == 69131 then -- Frost King
			self:Bar(136990, 136990, 9.7, 136990) -- Frostbite -- might be 7.5?
			if self:Heroic() then self:RegisterUnitEvent("UNIT_AURA", "ChilledToTheBone", "player") end
		elseif mobId == 69134 then -- Kazra'jin
		elseif mobId == 69078 then -- Sandcrawler
		end
	end
end

function mod:PossessedRemoved(args)
	self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", "boss1", "boss2", "boss3", "boss4", "boss5") -- for a little bit of performance increase
	local mobId = self:GetCID(args.destGUID)
	for i = 1, 5 do
		local id = ("boss%d"):format(i)
		local bossGUID = UnitGUID(id)
		if bossGUID == args.destGUID then
			SetRaidTarget(id, 0) -- clear the icon because posses have travel time, so people know when something is no longer possessed
		end
	end
	lingeringTracker[mobId] = lingeringTracker[mobId] + 1 -- this is needed because Lingering Presence have no CLEU event
	-- leave in all the elseif statements to be ready in case they are needed on heroic
	if mobId == 69132 then -- Priestess
	elseif mobId == 69131 then -- Frost King
		self:StopBar(136990) -- Frostbite
		if self:Heroic() then self:UnregisterUnitEvent("UNIT_AURA", "player") end
	elseif mobId == 69134 then -- Kazra'jin
	elseif mobId == 69078 then -- Sandcrawler
	end
end

function mod:Deaths(args)
	-- stopbars
	-- leave in all the elseif statements to be ready in case they are needed on heroic
	if args.mobId == 69132 then -- Priestess
	elseif args.mobId == 69131 then -- Frost King
		self:StopBar(136992)
		self:StopBar(136990)
	elseif args.mobId == 69134 then -- Kazra'jin
	elseif args.mobId == 69078 then -- Sandcrawler
		self:StopBar("~"..self:SpellName(136860)) -- Quicksand
		self:CloseProximity()
	end
	bossDead = bossDead + 1
	if bossDead > 4 then self:Win() end
end
