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
local bossDead = 0
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
	L.loa_spirit = "Loa spirit"
	L.loa_spirits = "Loa spirits"
	L.loa_spirits_desc = "Warning for both kinds of Loa spirit adds"
	L.loa_spirits_icon = 137203
end
L = mod:GetLocale()
L.assault = L.assault.." "..INLINE_TANK_ICON..INLINE_HEALER_ICON
L.assault_desc = CL.tankhealer..L.assault_desc

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"loa_spirits", {137359, "FLASHSHAKE"},
		{"ej:7062", "FLASHSHAKE"}, 136878, {136857, "FLASHSHAKE"}, 136894,
		{137122, "FLASHSHAKE"},
		"assault", {136992, "ICON", "SAY", "PROXIMITY"}, {136990, "ICON"},
		136442, "proximity", "berserk", "bosskill",
	}, {
		["loa_spirits"] = "ej:7050",
		["ej:7062"] = "ej:7049",
		[137122] = "ej:7048",
		["assault"] = "ej:7047",
		[136442] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	-- High Priestess Mar'li
	self:Log("SPELL_CAST_START", "LoaSpirit", 137203, 137350) -- Blessed, Shadowed -- don't need two different handlers
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
	self:Log("SPELL_AURA_APPLIED", "FrostbiteApplied", 136990)
	self:Log("SPELL_AURA_REMOVED", "FrostbiteRemoved", 136990)
	self:Log("SPELL_AURA_APPLIED", "BitingColdApplied", 136992)
	self:Log("SPELL_AURA_REMOVED", "BitingColdRemoved", 136992)
	self:Log("SPELL_AURA_APPLIED", "Assault", 136904)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Assault", 136904)
	-- General
	self:Log("SPELL_AURA_APPLIED", "PossessedApplied", 136442)
	self:Log("SPELL_AURA_REMOVED", "PossessedRemoved", 136442)

	self:Death("Deaths", 69132, 69131, 69134, 69078)
end

function mod:OnEngage()
	bossDead = 0
	for _, v in pairs(lingeringTracker) do v = 0 end
	self:OpenProximity(self:Heroic() and 7 or 5)
	self:Bar("loa_spirits", "~"..L["loa_spirit"], 27, 137203)
	self:Bar(136860, "~"..self:SpellName(136860), 7, 136860) -- Quicksand
	self:Bar(136992, 136992, 60, 136992) -- Biting Cold -- not sure if 1 min is right feels too long
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- High Priestess Mar'li
function mod:MarkedSoul(player, spellId, _, _, spellName)
	self:TargetMessage(spellId, spellName, player, "Urgent", spellId, "Alert")
	self:Bar(spellId, L["loa_kills"]:format(player), 20, spellId)
	if UnitIsUnit(player, "player") then
		self:FlashShake(spellId)
	end
end

function mod:LoaSpirit(_, spellId, _, _, spellName)
	-- maybe make this a ranged dps only warning?
	self:Message("loa_spirits", spellName, "Important", spellId, "Alarm")
	self:Bar("loa_spirits", "~"..L["loa_spirit"], 33, spellId)
	-- we use a localized string so we don't have to bother with stopping and restarting bars on posess, since Bless and Shadowed Loa spirits share cooldown
end

-- Sul the Sandcrawler
function mod:Sandstorm(_, spellId, _, _, spellName)
	-- Ability is used about 1 sec after the boss gets possessed, so no point to makea bar
	self:Message(spellId, spellName, "Urgent", spellId, "Alert")
end

function mod:Entrapped(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:FlashShake(136857)
		self:LocalMessage(136857, spellName, "Personal", spellId, "Info")
	else
		if self:Dispeller("magic") then
			self:LocalMessage(136857, spellName, "Attention", spellId, nil, player)
		end
	end
end

function mod:Ensnared(player, spellId, _, _, spellName, stack)
	stack = stack or 1
	if UnitIsUnit(player, "player") then
		self:LocalMessage(136878, ("%s (%d)"):format(spellName, stack), "Attention", spellId)
		if self.db.profile[self:SpellName(136878)] == 0 then return end -- don't play sound if warning is turned off
		local sound = ("BigWigs: %d"):format(5-stack)
		self:PlaySound(136878, sound)
	end
end

function mod:Quicksand(player, spellId, _, _, spellName)
	self:Bar(spellId, "~"..spellName, 33, spellId)
	if UnitIsUnit(player, "player") then
		self:LocalMessage("ej:7062", CL["underyou"]:format(spellName), "Personal", spellId, "Info")
		self:FlashShake("ej:7062")
	end
end

-- Kazra'jin
function mod:RecklessCharge(_, spellId, _, _, spellName)
	-- Not sure how useful this is, might want to remove it later
	self:Bar(spellId, spellName, 6, spellId)
end

do
	local prev = 0
	function mod:RecklessChargeDamage(player, spellId, _, _, spellName)
		if not UnitIsUnit(player, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(137122, CL["underyou"]:format(spellName), "Personal", spellId, "Info")
			self:FlashShake(137122)
		end
	end
end

--Frost King Malakk

function mod:FrostbiteApplied(player, spellId, _, _, spellName)
	self:TargetMessage(spellId, spellName, player, "Positive", spellId, "Info")
	self:Bar(spellId, spellName, 45, spellId)
	if UnitIsUnit(player, "player") then
		self:SecondaryIcon(spellId, player)
	end
end

function mod:FrostbiteRemoved(player, spellId)
	if UnitIsUnit(player, "player") then
		self:PrimaryIcon(spellId)
	end
end

function mod:BitingColdApplied(player, spellId, _, _, spellName)
	self:TargetMessage(spellId, spellName, player, "Urgent", spellId, "Alert")
	self:Bar(spellId, spellName, 47, spellId)
	if UnitIsUnit(player, "player") then
		self:SaySelf(spellId, spellName)
		self:OpenProximity(4, spellId)
		self:PrimaryIcon(spellId, player)
	end
end

function mod:BitingColdRemoved(player, spellId)
	if UnitIsUnit(player, "player") then
		self:CloseProximity(spellId)
		self:PrimaryIcon(spellId)
	end
end

-- General

function mod:Assault(player, spellId, _, _, _, stack)
	if self:Tank() or self:Healer() then
		stack = stack or 1
		if stack % 5 == 0 or stack > 10 then -- don't spam on low stacks, but spam close to 15
			self:LocalMessage("assault", CL["stack"], "Urgent", spellId, "Info", player, stack, L["assault_message"])
		end
	end
end

do
	local fullPower = 66 -- 66 seconds till full power without any lingering presences stacks
	function mod:PossessedApplied(player, spellId, _, _, spellName, _, _, _, _, dGUID)
		local mobId = self:GetCID(dGUID)
		local difficultyRegenMultiplier = self:Heroic() and 15 or self:LFR() and 5 or 10
		local duration = lingeringTracker[mobId] == 0 and fullPower or fullPower*(100-lingeringTracker[mobId]*difficultyRegenMultiplier)/100
		self:Message(spellId, ("%s (%s)"):format(spellName, player), "Attention", spellId, "Long")
		self:Bar(spellId, L["full_power"], duration, spellId)
		-- leave in all the elseif statements to be ready in case they are needed on heroic
		if mobId == 69132 then -- Priestess
		elseif mobId == 69131 then -- Frost King
			self:Bar(136990, 136990, 9.7, 136990) -- Frostbite -- might be 7.5?
		elseif mobId == 69134 then -- Kazra'jin
		elseif mobId == 69078 then -- Sandcrawler
		end
	end
end

function mod:PossessedRemoved(_, _, _, _, _, _, _, _, _, dGUID)
	local mobId = self:GetCID(dGUID)
	lingeringTracker[mobId] = lingeringTracker[mobId] + 1 -- this is needed because Lingering Presence have no CLEU event
	-- leave in all the elseif statements to be ready in case they are needed on heroic
	if mobId == 69132 then -- Priestess
	elseif mobId == 69131 then -- Frost King
		self:StopBar(136990) -- Frostbite
	elseif mobId == 69134 then -- Kazra'jin
	elseif mobId == 69078 then -- Sandcrawler
	end
end

function mod:Deaths(mobId)
	-- stopbars
	-- leave in all the elseif statements to be ready in case they are needed on heroic
	if mobId == 69132 then -- Priestess
	elseif mobId == 69131 then -- Frost King
		self:StopBar(136992)
		self:StopBar(136990)
	elseif mobId == 69134 then -- Kazra'jin
	elseif mobId == 69078 then -- Sandcrawler
		self:StopBar("ej:7062")
		self:CloseProximity(5)
	end
	bossDead = bossDead + 1
	if bossDead > 4 then self:Win() end
end
