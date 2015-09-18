
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Gorefiend", 1026, 1372)
if not mod then return end
mod:RegisterEnableMob(90199)
mod.engageId = 1783
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local fixateOnMe = nil
local phase = 1
local fatePlayer
local fateCount = 1
local shadowOfDeathInfo = {
	["icon"] = {
		["tank"] = INLINE_TANK_ICON,
		["healer"] = INLINE_HEALER_ICON,
		["dps"] = INLINE_DAMAGER_ICON,
	},
	["heroic"] = {
		["healer"] = 36, -- only 2 times per phase (although a 3rd would fit in)
		["dps"] = 36, -- only 3 times per phase (although a 4th would fit in)
	},
	["mythic"] = {
		["tank"] = 60,
		["healer"] = 46, -- only 2 times per phase (although a 3rd would fit in)
		["dps"] = 27, -- only 4 times per phase (although a 5th would fit in)
	},
	["count"] = {
		["tank"] = 0,
		["healer"] = 0,
		["dps"] = 0,
	},
	["maxCount"] = {
		["heroic"] = {
			["tank"] = 1,
			["healer"] = 2,
			["dps"] = 3,
		},
		["mythic"] = {
			["tank"] = 2,
			["healer"] = 2,
			["dps"] = 4,
		},
	}
}
--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.fate_root_you = "Shared Fate - You are rooted!"
	L.fate_you = "Shared Fate on YOU! - Root on %s"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Gorefiend ]]--
		{179977, "PROXIMITY", "FLASH", "SAY"}, -- Touch of Doom
		179995, -- Doom Well
		{179909, "PROXIMITY", "FLASH", "SAY", "ICON"}, -- Shared Fate
		181973, -- Feast of Souls
		{181295, "COUNTDOWN"}, -- Digest
		179864, -- Shadow of Death
		--[[ Enraged Spirit ]]--
		182601, -- Fel Fury
		181582, -- Bellowing Shout
		--[[ Gorebound Construct ]]--
		{180148, "FLASH"}, -- Hunger for Life
		--[[ Gorebound Spirit ]]--
		-11020, -- Gorebound Spirit
		187814, -- Raging Charge
		{185189, "TANK"}, -- Fel Flames
		--[[ General ]]--
		"proximity",
	}, {
		[179977] = self.displayName, -- Gorefiend
		[182601] = -11378, -- Enraged Spirit
		[180148] = -11018, -- Gorebound Construct
		[-11020] = -11020, -- Gorebound Spirit
		["proximity"] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "TouchOfDoom", 189434, 179977) -- LFR, all others
	self:Log("SPELL_AURA_REMOVED", "TouchOfDoomRemoved", 189434, 179977) -- LFR, all others
	self:Log("SPELL_AURA_APPLIED", "SharedFateRoot", 179909)
	self:Log("SPELL_AURA_REMOVED", "SharedFateRootRemoved", 179909)
	self:Log("SPELL_AURA_APPLIED", "SharedFateRun", 179908)
	self:Log("SPELL_AURA_REMOVED", "SharedFateRunRemoved", 179908)
	self:Log("SPELL_AURA_APPLIED", "FeastOfSoulsStart", 181973)
	self:Log("SPELL_AURA_REMOVED", "FeastOfSoulsOver", 181973)
	self:Log("SPELL_AURA_APPLIED", "Digest", 181295)
	self:Log("SPELL_AURA_REMOVED", "DigestRemoved", 181295)
	self:Log("SPELL_AURA_APPLIED", "ShadowOfDeath", 179864)

	self:Log("SPELL_CAST_START", "BellowingShout", 181582)
	self:Log("SPELL_AURA_APPLIED", "HungerForLife", 180148)
	self:Log("SPELL_AURA_REMOVED", "HungerForLifeOver", 180148)
	self:Log("SPELL_CAST_START", "RagingCharge", 187814)

	self:Log("SPELL_AURA_APPLIED_DOSE", "FelFlames", 185189)

	self:Log("SPELL_AURA_APPLIED", "DoomWellDamage", 179995)
	self:Log("SPELL_PERIODIC_DAMAGE", "DoomWellDamage", 179995)
	self:Log("SPELL_PERIODIC_MISSED", "DoomWellDamage", 179995)
	self:Log("SPELL_AURA_APPLIED", "FelFuryDamage", 182601)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FelFuryDamage", 182601)
	self:Log("SPELL_AURA_REMOVED", "GoreboundFortitude", 185982) -- Add spawning on the 'real' realm
	self:Death("GoreboundSpiritDeath", 90570)
end

local function showProximity()
	if mod:Ranged() and not mod:LFR() then
		mod:OpenProximity("proximity", 5)
	end
end

function mod:OnEngage()
	fixateOnMe = nil
	fateCount = 1

	if not self:LFR() then
		self:Bar(179909, 18) -- Shared Fate
	end
	self:Bar(179864, self:Mythic() and 3 or 2, shadowOfDeathInfo.icon.dps.." "..self:SpellName(179864)) -- DPS Shadow of Death
	self:Bar(179864, self:Mythic() and 9 or 13, shadowOfDeathInfo.icon.tank.." "..self:SpellName(179864)) -- Tank Shadow of Death
	self:Bar(179864, self:Mythic() and 20 or 30, shadowOfDeathInfo.icon.healer.." "..self:SpellName(179864)) -- Healer Shadow of Death
	self:Bar(181973, 123) -- Feast of Souls, based on heroic logs
	self:CDBar(179977, 8.3) -- Touch of Doom
	showProximity()

	shadowOfDeathInfo.count.tank = 0
	shadowOfDeathInfo.count.dps = 0
	shadowOfDeathInfo.count.healer = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local list = mod:NewTargetList()
	function mod:TouchOfDoom(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, 179977, list, "Important", "Alarm")
			self:Bar(179977, 25)
		end
		if self:Me(args.destGUID) then
			self:TargetBar(179977, 8, args.destName)
			if not self:LFR() then
				self:OpenProximity(179977, 20) -- XXX Range is up for debate
				self:Flash(179977)
				self:Say(179977)
			end
		end
	end
end

function mod:TouchOfDoomRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellName, args.destName)
		if not self:LFR() then
			self:CloseProximity(179977)
			showProximity()
		end
	end
end

function mod:GoreboundSpiritDeath(args)
	self:StopBar(181582) -- Bellowing Shout
end

function mod:GoreboundFortitude()
	-- Enraged Spirit moving to the 'real' realm (becomes Gorebound Spirit)
	self:Message(-11020, "Neutral", self:Tank() and "Warning" or "Info", CL.spawning:format(self:SpellName(-11020)), false)
end

do
	local timers = {0, 28, 25, 22}
	function mod:SharedFateRoot(args)
		fatePlayer = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId, 135484) -- 135484 = "Rooted"
			self:Message(args.spellId, "Personal", "Alert", L.fate_root_you)
		else
			self:TargetMessage(args.spellId, fatePlayer, "Attention", nil, self:SpellName(135484)) -- 135484 = "Rooted"
		end
		self:PrimaryIcon(args.spellId, fatePlayer)

		fateCount = fateCount + 1
		local timer = timers[fateCount]
		if timer then
			self:CDBar(args.spellId, timer)
		end
	end
end

function mod:SharedFateRootRemoved(args)
	fatePlayer = nil
	self:PrimaryIcon(args.spellId)
end

function mod:SharedFateRun(args)
	if self:Me(args.destGUID) then
		self:Flash(179909)
		if fatePlayer then -- Failsafe for whenever root doesn't end up first in the combat log
			self:Message(179909, "Personal", "Warning", L.fate_you:format(self:ColorName(fatePlayer)))
			self:OpenProximity(179909, 6, fatePlayer, true)
		else
			self:TargetMessage(179909, args.destName, "Personal", "Warning")
		end
	end
end

function mod:SharedFateRunRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(179909)
		showProximity()
	end
end

function mod:FeastOfSoulsStart(args)
	self:CloseProximity("proximity")
	self:Message(args.spellId, "Positive", "Long")
	self:Bar(args.spellId, 60, self:SpellName(117847))
	-- cancel timers
	self:StopBar(shadowOfDeathInfo.icon.dps.." "..self:SpellName(179864))
	self:StopBar(shadowOfDeathInfo.icon.healer.." "..self:SpellName(179864))
	self:StopBar(shadowOfDeathInfo.icon.tank.." "..self:SpellName(179864))
	self:StopBar(179909) -- Shared Fate
	self:StopBar(179977) -- Touch of Doom
end

function mod:FeastOfSoulsOver(args)
	showProximity()
	self:Message(args.spellId, "Positive", nil, CL.over:format(self:SpellName(117847))) -- Weakened
	self:StopBar(117847) -- If it finishes early due to failing
	self:Bar(args.spellId, 123) -- Based on pull->first feast
	self:Bar(179864, self:Mythic() and 3 or 2, shadowOfDeathInfo.icon.dps.." "..self:SpellName(179864)) -- DPS Shadow of Death
	self:Bar(179864, self:Mythic() and 9 or 13, shadowOfDeathInfo.icon.tank.." "..self:SpellName(179864)) -- Tank Shadow of Death
	self:Bar(179864, self:Mythic() and 20 or 30, shadowOfDeathInfo.icon.healer.." "..self:SpellName(179864)) -- Healer Shadow of Death
	self:Bar(179977, 9) -- Touch of Doom
	if not self:LFR() then
		self:Bar(179909, 19) -- Shared Fate
	end

	fateCount = 1
	shadowOfDeathInfo.count.tank = 0
	shadowOfDeathInfo.count.dps = 0
	shadowOfDeathInfo.count.healer = 0
end

function mod:Digest(args)
	if self:Me(args.destGUID) then
		self:CloseProximity("proximity")
		self:Message(args.spellId, "Attention", "Long", CL.custom_sec:format(args.spellName, self:Mythic() and 30 or 40))
		if not self:Mythic() then -- you don't have any control over it on mythic
			self:DelayedMessage(args.spellId, 20, "Attention", CL.custom_sec:format(args.spellName, 20))
			self:DelayedMessage(args.spellId, 30, "Attention", CL.custom_sec:format(args.spellName, 10), nil, "Alert")
			self:DelayedMessage(args.spellId, 35, "Urgent", CL.custom_sec:format(args.spellName, 5), nil, "Alert")
		end
		self:TargetBar(args.spellId, self:Mythic() and 35 or 40, args.destName)
	end
end

function mod:DigestRemoved(args)
	if self:Me(args.destGUID) then
		showProximity()
		self:CancelDelayedMessage(CL.custom_sec:format(args.spellName, 20))
		self:CancelDelayedMessage(CL.custom_sec:format(args.spellName, 10))
		self:CancelDelayedMessage(CL.custom_sec:format(args.spellName, 5))
		self:StopBar(args.spellName, args.destName)
	end
end

do
	local list = mod:NewTargetList()
	function mod:ShadowOfDeath(args)
		if self:Me(args.destGUID) then
			self:TargetBar(args.spellId, 5, args.destName)
		end

		local role = self:Tank(args.destName) and "tank" or self:Healer(args.destName) and "healer" or "dps"
		local text = shadowOfDeathInfo.icon[role].." "..args.spellName

		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Urgent", "Alarm", text)

			local count = shadowOfDeathInfo.count[role]
			count = count + 1
			shadowOfDeathInfo.count[role] = count
			local maxCount = shadowOfDeathInfo.maxCount[self:Mythic() and "mythic" or "heroic"][role]

			if count < maxCount then
				local timer = shadowOfDeathInfo[self:Mythic() and "mythic" or "heroic"][role]
				if timer then
					self:Bar(179864, timer, text)
				end
			end
		end
	end
end

--function mod:CrushingDarkness(args)
--	self:Message(args.spellId, "Important", "Info", CL.incoming:format(args.spellName))
--end

do
	local prev = 0
	function mod:DoomWellDamage(args)
		local t = GetTime()
		if t-prev > 1.5 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

do
	local prev = 0
	function mod:FelFuryDamage(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
		end
	end
end

function mod:HungerForLife(args)
	if self:Me(args.destGUID) and not fixateOnMe then -- Multiple debuffs, warn for the first.
		fixateOnMe = true
		self:TargetMessage(args.spellId, args.destName, "Personal", "Warning")
		self:Flash(args.spellId)
	end
end

function mod:HungerForLifeOver(args)
	if self:Me(args.destGUID) and not UnitDebuff("player", args.spellName) then
		fixateOnMe = nil
		self:Message(args.spellId, "Personal", "Alarm", CL.over:format(args.spellName))
	end
end

function mod:BellowingShout(args)
	self:CDBar(args.spellId, 13.5)
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "Important", "Alert", CL.casting:format(args.spellName))
	end
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(187814, name, "Important", "Alert", nil, nil, self:Tank() or self:Damager())
	end
	function mod:RagingCharge(args)
		self:GetUnitTarget(printTarget, 0.2, args.sourceGUID)
	end
end

function mod:FelFlames(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Positive", args.amount > 3 and "Warning")
end

