--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Shurrai, Atrocity of the Undersea", -2215, 2636)
if not mod then return end
mod:RegisterEnableMob(221224) -- Shurrai, Atrocity of the Undersea
mod.otherMenu = -2274
mod.worldBoss = 221224

--------------------------------------------------------------------------------
-- Locals
--

local abyssalStrikeCount = 1
local brinyVomitCount = 1
local darkTideCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:SetSpellRename(453607, CL.heal_absorb) -- Abyssal Strike (Heal Absorb) [cast]
	self:SetSpellRename(453618, CL.heal_absorb) -- Abyssal Strike (Heal Absorb) [debuff]
	self:SetSpellRename(453875, CL.adds) -- Regurgitate Souls (Adds)
	self:SetSpellRename(453733, CL.dodge) -- Briny Vomit (Dodge) [cast]
	self:SetSpellRename(453761, CL.dodge) -- Briny Vomit (Dodge) [channel]
	self:SetSpellRename(455275, CL.waves) -- Dark Tide (Waves)
end

function mod:GetOptions()
	return {
		453618, -- Abyssal Strike
		453875, -- Regurgitate Souls
		453733, -- Briny Vomit
		455275, -- Dark Tide
	},nil,{
		[453618] = CL.heal_absorb, -- Abyssal Strike (Heal Absorb)
		[453875] = CL.adds, -- Regurgitate Souls (Adds)
		[453733] = CL.dodge, -- Briny Vomit (Dodge)
		[455275] = CL.waves, -- Dark Tide (Waves)
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()
	abyssalStrikeCount = 1
	brinyVomitCount = 1
	darkTideCount = 1
	self:CheckForWipe()

	-- World bosses will wipe but keep listening to events if you fly away, so we only register OnEngage
	self:Log("SPELL_CAST_SUCCESS", "AbyssalStrike", 453607)
	self:Log("SPELL_AURA_APPLIED", "AbyssalStrikeApplied", 453618)
	self:Log("SPELL_CAST_START", "RegurgitateSouls", 453875)
	self:Log("SPELL_CAST_START", "BrinyVomit", 453733)
	self:Log("SPELL_CAST_START", "DarkTide", 455275)

	self:CDBar(453618, 7.5, CL.heal_absorb) -- Abyssal Strike
	self:CDBar(453733, 10, CL.dodge) -- Briny Vomit
	self:CDBar(455275, 17.3, CL.waves) -- Dark Tide
	self:CDBar(453875, 35, CL.adds) -- Regurgitate Souls
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 2994 then
		self:Win()
	end
end

do
	local timers = {7.5, 19.2, 38}
	function mod:AbyssalStrike()
		abyssalStrikeCount = abyssalStrikeCount + 1
		self:CDBar(453618, timers[abyssalStrikeCount], CL.heal_absorb)
	end
end

function mod:AbyssalStrikeApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName, CL.heal_absorb)
	if self:Healer() or (self:Tank() and not self:Me(args.destGUID)) then
		self:PlaySound(args.spellId, "warning", nil, args.destName)
	end
end

function mod:RegurgitateSouls(args)
	self:Message(args.spellId, "red", CL.adds_spawning)
	self:CDBar(args.spellId, 50, CL.adds)
	self:PlaySound(args.spellId, "long")
end

do
	local timers = {10, 19, 25.3, 21}
	function mod:BrinyVomit(args)
		brinyVomitCount = brinyVomitCount + 1
		self:Message(args.spellId, "orange", CL.extra:format(args.spellName, CL.dodge))
		self:CDBar(args.spellId, timers[brinyVomitCount], CL.dodge)
		self:PlaySound(args.spellId, "info")
	end
end

do
	local timers = {17.3, 30, 22}
	function mod:DarkTide(args)
		darkTideCount = darkTideCount + 1
		self:Message(args.spellId, "yellow", CL.waves)
		self:CDBar(args.spellId, timers[darkTideCount], CL.waves)
		self:PlaySound(args.spellId, "alarm")
	end
end
