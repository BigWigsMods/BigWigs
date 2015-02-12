
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Blast Furnace", 988, 1154)
if not mod then return end
mod:RegisterEnableMob(76809, 76808, 76806, 76815) -- Foreman Feldspar, Heat Regulator, Heart of the Mountain, Primal Elementalist
mod.engageId = 1690

--------------------------------------------------------------------------------
-- Locals
--

local regulatorDeaths = 0
local shamanDeaths = 0
local blastTime = 30
local volatileFireOnMe = nil
local volatileFireTargets = {}
local bombOnMe = nil
local bombTargets = {}
local engineerBombs = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.custom_on_shieldsdown_marker = "Shields Down marker"
	L.custom_on_shieldsdown_marker_desc = "Mark a vulnerable Primal Elementalist with {rt8}, requires promoted or leader."
	L.custom_on_shieldsdown_marker_icon = 8

	L.heat_increased_message = "Heat increased! Blast every %ss"

	L.bombs_dropped = "Bombs dropped! (%d)"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Adds ]]--
		-9650, -- Bellows Operator
		155179, -- Repair (Furnace Engineer)
		{155192, "SAY", "PROXIMITY", "FLASH"}, -- Bomb (Furnace Engineer)
		174731, -- Cluster of Lit Bombs (Furnace Engineer)
		--[[ Foreman Feldspar ]]--
		156937, -- Pyroclasm
		{175104, "TANK_HEALER"}, -- Melt Armor
		{156932, "SAY", "FLASH"}, -- Rupture
		--[[ Primal Elementalist ]]--
		-10325, -- Shields Down
		"custom_on_shieldsdown_marker",
		{155173, "DISPEL"}, -- Reactive Earth Shield
		-10324, -- Fixate (Slag Elemental)
		176133, -- Slag Bomb (Slag Elemental)
		155186, -- Cauterize Wounds (Firecaller)
		{176121, "SAY", "PROXIMITY", "FLASH"}, -- Volatile Fire (Firecaller)
		--[[ Heart of the Mountain ]]--
		155209, -- Blast
		{155242, "TANK"}, -- Heat
		{155225, "SAY", "FLASH"}, -- Melt
		163776, -- Superheated
		"stages",
		"berserk",
		"bosskill"
	}, {
		[-9650] = CL.adds,
		[156937] = -9640, -- Foreman Feldspar
		[-10325] = -9655, -- Primal Elementalist
		[155209] = -10808, -- Heart of the Mountain
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Loading", 155181) -- Bellows Operator
	-- Primal Elementalist
	self:Log("SPELL_AURA_APPLIED", "ShieldsDown", 158345)
	self:Log("SPELL_AURA_APPLIED", "DamageShield", 155176)
	self:Log("SPELL_AURA_APPLIED", "ReactiveEarthShield", 155173)
	-- Slag Elemental
	self:Log("SPELL_AURA_APPLIED", "Fixate", 155196)
	self:Log("SPELL_CAST_START", "SlagBomb", 176133)
	-- Furnace Engineer
	self:Log("SPELL_CAST_START", "Repair", 155179)
	self:Log("SPELL_AURA_APPLIED", "Bomb", 155192, 174716) -- Bomb, Cluster of Lit Bombs
	self:Log("SPELL_AURA_REMOVED", "BombRemoved", 155192, 174716)
	-- Firecaller
	self:Log("SPELL_CAST_START", "CauterizeWounds", 155186)
	self:Log("SPELL_AURA_APPLIED", "VolatileFireApplied", 176121)
	self:Log("SPELL_AURA_REMOVED", "VolatileFireRemoved", 176121)
	-- Foreman Feldspar
	self:Log("SPELL_CAST_START", "Pyroclasm", 156937)
	self:Log("SPELL_AURA_APPLIED", "MeltArmor", 175104)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MeltArmor", 175104)
	self:Log("SPELL_AURA_APPLIED", "Rupture", 156934)
	self:Log("SPELL_PERIODIC_DAMAGE", "RuptureDamage", 156932)
	self:Log("SPELL_PERIODIC_MISSED", "RuptureDamage", 156932)
	-- Heart of the Mountain
	self:Log("SPELL_AURA_APPLIED", "Heat", 155242)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Heat", 155242)
	self:Log("SPELL_AURA_APPLIED", "Melt", 155225) -- player will spawn puddle when the debuff expires
	self:Log("SPELL_PERIODIC_DAMAGE", "MeltDamage", 155223)
	self:Log("SPELL_PERIODIC_MISSED", "MeltDamage", 155223)
	self:Log("SPELL_AURA_APPLIED", "Superheated", 163776)

	self:Death("Deaths", 76808, 76815, 88820, 76810) -- Heat Regulator, Primal Elementalist, Furnace Engineer x2
end

function mod:OnEngage()
	regulatorDeaths, shamanDeaths = 0, 0
	blastTime = 30

	wipe(volatileFireTargets)
	wipe(bombTargets)
	volatileFireOnMe = nil
	bombOnMe = nil
	wipe(engineerBombs)

	self:Bar(155209, blastTime) -- Blast
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", nil, "boss1")
	if not self:LFR() then 
		self:Berserk(780) -- XXX not sure if 13min in Mythic aswell
	end
end

function mod:OnBossDisable()
	wipe(volatileFireTargets)
	wipe(bombTargets)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function updateProximity()
	-- open in reverse order so if you disable one it doesn't block others from showing
	if #volatileFireTargets > 0 then
		mod:OpenProximity(176121, 8, volatileFireTargets)
	end
	if #bombTargets > 0 then -- someone shouldn't be standing there without a bomb, so this might not be needed
		mod:OpenProximity(155192, 8, bombTargets) -- how big is the radius? i have no idea
	end
	if volatileFireOnMe then
		mod:OpenProximity(176121, 8)
	end
	if bombOnMe then
		mod:OpenProximity(155192, 8) -- how big is the radius? i have no idea
	end
end

-- Adds

do
	local prev = 0
	function mod:Loading(args)
		local t = GetTime()
		if t-prev > 5 then
			prev = t
			self:Message(-9650, "Attention", "Info") -- Bellows Operator
			self:Bar(-9650, 64, nil, 155181)
		end
	end
end

function mod:Repair(args)
	if not self:Healer() then
		self:Message(args.spellId, "Personal", "Alert", CL.other:format(args.sourceName, args.spellName))
	end
end

function mod:Bomb(args)
	engineerBombs[args.sourceGUID] = (engineerBombs[args.sourceGUID] or 5) - 1

	if self:Me(args.destGUID) then
		self:Message(155192, "Positive", "Alarm", CL.you:format(args.spellName)) -- is good thing
		local t = 15
		if args.spellId == 174716 then -- from the bomb sack
			local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
			t = expires - GetTime()
		end
		self:TargetBar(155192, t, args.destName)
		self:Flash(155192)
		self:Say(155192)
		bombOnMe = true
	end
	if not tContains(bombTargets, args.destName) then -- SPELL_AURA_REFRESH
		bombTargets[#bombTargets+1] = args.destName
	end

	updateProximity()
end

function mod:BombRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellId, args.destName)
		self:CloseProximity(args.spellId)
		bombOnMe = nil
	end
	tDeleteItem(bombTargets, args.destName)

	if #bombTargets == 0 then
		self:CloseProximity(args.spellId)
	end

	updateProximity()
end

-- Primal Elementalist

function mod:ShieldsDown(args)
	self:Message(-10325, "Positive", "Info", CL.removed:format(self:SpellName(155176))) -- Damage Shield Removed!
	self:Bar(-10325, self:Normal() and 40 or 30)

	if self.db.profile.custom_on_shieldsdown_marker then
		for i = 1, 5 do -- i have no idea if this works
			local boss = ("boss%d"):format(i)
			if UnitBuff(boss, args.spellName) then  -- Shields Down
				SetRaidTarget(boss, 8)
				break
			end
		end
	end
end

function mod:DamageShield(args)
	if self.db.profile.custom_on_shieldsdown_marker then
		for i = 1, 5 do
			local boss = ("boss%d"):format(i)
			if UnitGUID(boss) == args.sourceGUID and GetRaidTargetIndex(boss) == 8 then
				SetRaidTarget(boss, 0)
				break
			end
		end
	end
end

function mod:Fixate(args)
	if self:Me(args.destGUID) then
		self:Message(-10324, "Personal", "Alarm", CL.you:format(args.spellName))
		self:Flash(-10324)
	end
end

function mod:SlagBomb(args)
	self:Message(args.spellId, "Important", "Alarm", CL.casting:format(args.spellName))
end

function mod:ReactiveEarthShield(args)
	if self:MobId(args.destGUID) == "76815" and self:Dispeller("magic", nil, args.spellId) then
		self:Message(args.spellId, "Urgent", "Info")
	end
end

function mod:CauterizeWounds(args)
	self:Message(args.spellId, "Urgent", not self:Healer() and "Alert")
end

function mod:VolatileFireApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
		self:Bar(args.spellId, 8, CL.you:format(args.spellName))
		if not self:LFR() then
			self:Say(args.spellId)
		end
		self:Flash(args.spellId)
		volatileFireOnMe = true
	end

	if not tContains(volatileFireTargets, args.destName) then -- SPELL_AURA_REFRESH
		volatileFireTargets[#volatileFireTargets+1] = args.destName
	end

	updateProximity()
end

function mod:VolatileFireRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
		volatileFireOnMe = nil
	end
	tDeleteItem(volatileFireTargets, args.destName)

	if #volatileFireTargets == 0 then
		self:CloseProximity(args.spellId)
	end

	updateProximity()
end

-- Foreman Feldspar

function mod:Pyroclasm(args)
	self:Message(args.spellId, "Attention", nil, CL.casting:format(args.spellName))
end

function mod:MeltArmor(args)
	self:TargetMessage(args.spellId, args.destName, "Attention")
	self:Bar(args.spellId, 10)
end

function mod:Rupture(args)
	if self:Me(args.destGUID) then
		self:Message(156932, "Personal", "Alarm", CL.you:format(args.spellName))
		self:Bar(156932, 5, CL.you:format(args.spellName))
		self:Flash(156932)
		self:Say(156932)
	end
end

do
	local prev = 0
	function mod:RuptureDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL.underyou:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

-- Heart of the Mountain

do
	local warned = nil
	function mod:UNIT_POWER_FREQUENT(unit, powerType)
		if powerType == "ALTERNATE" then
			-- energy rate is based on altpower
			local altpower = UnitPower(unit, 10)
			local newTime = 30
			if altpower == 100 then
				newTime = 6
			elseif altpower > 74 then
				newTime = 9
			elseif altpower > 49 then
				newTime = 15
			elseif altpower > 24 then
				newTime = 20
			end

			-- adjust Blast timer
			if newTime ~= blastTime then
				if newTime < blastTime then
					self:Message(155209, "Attention", nil, L.heat_increased_message:format(newTime))
				end
				blastTime = newTime
				local t = ceil((100-UnitPower(unit))/(100/newTime))
				self:Bar(155209, t)
			end
			return
		end

		local power = UnitPower(unit)
		if power > 80 and power < 100 and not warned then
			if blastTime > 10 then
				-- XXX added this because there is an emote for it, not sure if needed since we have a bar
				self:Message(155209, "Urgent", "Alarm", CL.soon:format(self:SpellName(155209)))
			end
			warned = true
		elseif power == 0 and warned then
			self:Bar(155209, blastTime)
			warned = nil
		end
	end
end

function mod:Heat(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Attention", args.amount and "Warning")
	self:Bar(args.spellId, 10)
end

function mod:Melt(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
		self:Bar(args.spellId, 6, CL.you:format(args.spellName))
		self:Flash(args.spellId)
		self:Say(args.spellId)
	end
end

do
	local prev = 0
	function mod:MeltDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			prev = t
			self:Message(155225, "Personal", "Info", CL.underyou:format(args.spellName))
			self:Flash(155225)
		end
	end
end

function mod:Superheated(args)
	self:Message(args.spellId, "Important", "Long")

	self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", "boss1")

	-- adjust Blast timer
	local newTime = 6
	if blastTime ~= newTime then
		blastTime = newTime
		local t = ceil((100-UnitPower("boss1"))/(100/newTime))
		self:Bar(155209, t) -- Blast
	end
end


function mod:Deaths(args)
	if args.mobId == 88820 or args.mobId == 76810 then
		if regulatorDeaths < 2 then -- p1: pick up bombs
			local bombs = engineerBombs[args.destGUID] or 5
			self:Message(174731, "Positive", "Info", L.bombs_dropped:format(bombs))
			engineerBombs[args.destGUID] = nil
		end
	elseif args.mobId == 76808 then
		regulatorDeaths = regulatorDeaths + 1
		self:Message("stages", "Neutral", "Info", CL.mob_killed:format(args.destName, regulatorDeaths, 2), false)
		if regulatorDeaths > 1 then
			-- Primalists spawn
			self:StopBar(-9650) -- Bellows Operator
		end
	elseif args.mobId == 76815 then
		shamanDeaths = shamanDeaths + 1
		self:Message("stages", "Neutral", "Info", CL.mob_killed:format(args.destName, shamanDeaths, 4), false)
		if shamanDeaths > 3 then
			-- The Fury is free! (after the next Blast cast?)
		end
	end
end
