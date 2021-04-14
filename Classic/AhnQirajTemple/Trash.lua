
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Ahn'Qiraj Trash", 531)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	15264, -- Anubisath Sentinel
	15277, -- Anubisath Defender
	15240 -- Vekniss Hive Crawler
)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.anubisath = "Anubisath"
	L.sentinel = "Anubisath Sentinel"
	L.defender = "Anubisath Defender"
	L.crawler = "Vekniss Hive Crawler"

	L.guard = 17430 -- Summon Anubisath Swarmguard
	L.guard_icon = "spell_nature_insectswarm"

	L.warrior = 17431 -- Summon Anubisath Warrior
	L.warrior_icon = "ability_warrior_savageblow"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Anubisath (shared)
		26555, -- Shadow Storm
		26554, -- Thunderclap
		-- Anubisath Sentinel
		{24573, "TANK_HEALER"}, -- Mortal Strike
		25779, -- Mana Burn
		25778, -- Knock Away
		-- Anubisath Defender
		{26556, "PROXIMITY", "SAY"}, -- Plague
		26558, -- Meteor
		8269, -- Frenzy
		{25698, "FLASH"}, -- Explode
		"guard",
		"warrior",
		-- Vekniss Hive Crawler
		25051, -- Sunder Armor
	}, {
		[26555] = L.anubisath,
		[24573] = L.sentinel,
		[26556] = L.defender,
		[25051] = L.crawler,
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	self:Log("SPELL_AURA_APPLIED", "MortalStrike", 24573)
	self:Log("SPELL_MISSED", "MortalStrike", 24573)

	self:Log("SPELL_DAMAGE", "KnockAway", 25778)
	self:Log("SPELL_MISSED", "KnockAway", 25778)

	self:Log("SPELL_DAMAGE", "ManaBurn", 25779)
	self:Log("SPELL_MISSED", "ManaBurn", 25779)

	self:Log("SPELL_AURA_APPLIED", "Plague", 26556)
	self:Log("SPELL_AURA_REFRESH", "Plague", 26556)
	self:Log("SPELL_AURA_REMOVED", "PlagueRemoved", 26556)

	self:Log("SPELL_AURA_APPLIED", "Frenzy", 8269)
	self:Log("SPELL_AURA_APPLIED", "Explode", 25698)

	self:Log("SPELL_DAMAGE", "Meteor", 26558)
	self:Log("SPELL_MISSED", "Meteor", 26558)

	-- XXX Shadow Storm has no (miss) event?
	self:Log("SPELL_DAMAGE", "ShadowStorm", 26555)
	self:Log("SPELL_MISSED", "ShadowStorm", 26555)

	self:Log("SPELL_DAMAGE", "Thunderclap", 26554)
	self:Log("SPELL_MISSED", "Thunderclap", 26554)


	self:Log("SPELL_SUMMON", "SummonAnubisathSwarmguard", 17430)
	self:Log("SPELL_SUMMON", "SummonAnubisathWarrior", 17431)

	self:Log("SPELL_AURA_APPLIED", "SunderArmor", 25051)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SunderArmor", 25051)
	self:Log("SPELL_AURA_REMOVED", "SunderArmorRemoved", 25051)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ Shared ]]--

do
	local prev = 0
	function mod:ShadowStorm(args)
		local t = GetTime()
		if t-prev > 5 then
			prev = t
			self:Message(26555, "yellow")
			-- self:Bar(26555, 7)
		end
	end
end

do
	local prev = 0
	function mod:Thunderclap(args)
		local t = GetTime()
		if t-prev > 5 then
			prev = t
			self:Message(26554, "cyan")
			self:Bar(26554, 7)
		end
	end
end

--[[ Anubisath Sentinel ]]--

do
	local prev = 0
	function mod:MortalStrike(args)
		local t = GetTime()
		if t-prev > 9 then
			self:Message(24573, "purple")
			self:Bar(24573, 11)
		end
	end
end

do
	local prev = 0
	function mod:KnockAway(args)
		local t = GetTime()
		if t-prev > 11 then
			prev = t
			self:Message(25778, "orange")
			self:Bar(25778, 13)
		end
	end
end

do
	local prev = 0
	function mod:ManaBurn(args)
		local t = GetTime()
		if t-prev > 9 then
			prev = t
			self:Message(25778, "blue")
			self:Bar(25778, 11)
		end
	end
end

--[[ Anubisath Defender ]]--

function mod:Plague(args)
	self:TargetMessage(26556, "yellow", args.destName)
	if self:Me(args.destGUID) then
		self:Say(26556)
		self:TargetBar(26556, 40, args.destName)
		self:OpenProximity(26556, 5) -- Will actually open one for 10~11
	end
end

function mod:PlagueRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(26556)
		self:StopBar(26556, args.destName)
	end
end

do
	local prev = 0
	function mod:Meteor(args)
		local t = GetTime()
		if t-prev > 12 then
			prev = t
			self:Message(26558, "cyan")
		end
	end
end

function mod:Frenzy(args)
	self:Message(8269, "red")
	self:PlaySound(8269, "long")
end

function mod:Explode(args)
	self:Message(25698, "orange", CL.casting:format(args.spellName))
	self:PlaySound(25698, "alert")
	self:Bar(25698, 6) -- Duration is 7s but it expires after 6s
	self:Flash(25698)
end

function mod:SummonAnubisathSwarmguard(args)
	self:Message("guard", "green", args.spellName, L.guard_icon)
end

function mod:SummonAnubisathWarrior(args)
	self:Message("warrior", "green", args.spellName, L.warrior_icon)
end

--[[ Vekniss Hive Crawler ]]--

function mod:SunderArmor(args)
	self:StackMessage(25051, args.destName, args.amount, "yellow")
	self:TargetBar(25051, 20, args.destName)
end

function mod:SunderArmorRemoved(args)
	self:StopBar(args.spellName, args.destName)
end

