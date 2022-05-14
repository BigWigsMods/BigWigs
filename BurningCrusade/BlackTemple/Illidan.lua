
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Illidan Stormrage", 564, 1590)
if not mod then return end
mod:RegisterEnableMob(22917, 23089, 22997) -- Illidan Stormrage, Akama, Flame of Azzinoth
mod:SetEncounterID(609)
mod:SetAllowWin(true)
mod:SetRespawnTime(10)

--------------------------------------------------------------------------------
-- Locals
--

local playerList = mod:NewTargetList()
local burstCount = 0
local flamesDead = 0
local barrageCount = 0
local inDemonPhase = false
local isCaged = false
local timer1, timer2 = nil, nil
local fixateList = {}
local castCollector = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.barrage_bar = "Barrage"
	L.warmup_trigger = "Akama. Your duplicity is hardly surprising. I should have slaughtered you and your malformed brethren long ago."

	L[-15735] = "Stage One: You Are Not Prepared"
	L[-15740] = "Stage Two: Flames of Azzinoth"
	L[-15751] = "Stage Three: The Demon Within"
	L[-15757] = "Stage Four: The Long Hunt"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"warmup",
		"stages",
		"berserk",

		--[[ Stage One: You Are Not Prepared ]]--
		41032, -- Shear
		{41917, "ICON", "SAY"}, -- Parasitic Shadowfiend
		40841, -- Flame Crash

		--[[ Stage Two: Flames of Azzinoth ]]--
		{40585, "ICON"}, -- Dark Barrage
		40018, -- Eye Blast
		39869, -- Uncaged Wrath
		40611, -- Blaze

		--[[ Stage Three: The Demon Within ]]--
		{40932, "PROXIMITY"}, -- Agonizing Flames
		41126, -- Flame Burst
		41117, -- Summon Shadow Demons
		40506, -- Demon Form

		--[[ Stage Four: The Long Hunt ]]--
		40683, -- Frenzy
		40695, -- Caged
	}, {
		[41032] = -15735, -- Stage One: You Are Not Prepared
		[40585] = -15740, -- Stage Two: Flames of Azzinoth
		[40932] = -15751, -- Stage Three: The Demon Within
		[40683] = -15757, -- Stage Four: The Long Hunt
	}
end

function mod:OnBossEnable()
	--[[ Stage One: You Are Not Prepared ]]--
	self:Log("SPELL_AURA_APPLIED", "Shear", 41032)
	self:Log("SPELL_AURA_APPLIED", "ParasiticShadowfiend", 41917)
	self:Log("SPELL_AURA_APPLIED", "ParasiticShadowfiendFailure", 41914)
	self:Log("SPELL_AURA_REMOVED", "ParasiticShadowfiendOver", 41917, 41914)

	--[[ Stage Two: Flames of Azzinoth ]]--
	self:Log("SPELL_CAST_START", "ThrowGlaive", 39849)
	self:Log("SPELL_AURA_APPLIED", "DarkBarrage", 40585)
	self:Log("SPELL_AURA_REMOVED", "DarkBarrageRemoved", 40585)
	self:Log("SPELL_AURA_APPLIED", "UncagedWrath", 39869)
	self:Log("SPELL_SUMMON", "EyeBlast", 40018)

	--[[ Stage Three: The Demon Within ]]--
	self:Death("FlameDeath", 22997) -- Flame of Azzinoth
	self:Log("SPELL_AURA_APPLIED", "AgonizingFlames", 40932)
	self:Log("SPELL_CAST_SUCCESS", "FlameBurst", 41126)
	self:Log("SPELL_CAST_START", "SummonShadowDemons", 41117)

	--[[ Stage Four: The Long Hunt ]]--
	self:Log("SPELL_CAST_SUCCESS", "ShadowPrison", 40647)
	self:Log("SPELL_AURA_REMOVED", "ShadowPrisonRemoved", 40647)
	self:Log("SPELL_CAST_SUCCESS", "Frenzy", 40683)
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("UNIT_AURA")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:Log("SPELL_DAMAGE", "Damage", 40841, 40611, 40018, 40030) -- Flame Crash, Blaze, Eye Blast, Demon Fire (Eye Blast)
	self:Log("SPELL_MISSED", "Damage", 40841, 40611, 40018, 40030) -- Flame Crash, Blaze, Eye Blast, Demon Fire (Eye Blast)
end

function mod:OnEngage()
	timer1, timer2 = nil, nil
	burstCount = 0
	flamesDead = 0
	barrageCount = 0
	inDemonPhase = false
	isCaged = false
	castCollector = {}
	playerList = self:NewTargetList()
	fixateList = {}

	self:Berserk(1500)
	self:RegisterTargetEvents("CheckForFixate")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CheckForFixate(_, unit, guid)
	local mobId = self:MobId(guid)
	if mobId == 23498 and not fixateList[guid] and self:Me(self:UnitGUID(unit.."target")) then -- Parasitic Shadowfiend
		fixateList[guid] = true
		self:Say(41917, 41951) -- 41951 = "Fixate"
		self:MessageOld(41917, "blue", "long", CL.you:format(self:SpellName(41951)), 41951)
	end
end

--[[ Stage One: You Are Not Prepared ]]--
function mod:Shear(args)
	self:TargetMessageOld(args.spellId, args.destName, "red", "alert")
	self:TargetBar(args.spellId, 7, args.destName)
end

function mod:ParasiticShadowfiend(args)
	self:TargetMessageOld(args.spellId, args.destName, "yellow", "long")
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetBar(args.spellId, 10, args.destName, 36469, args.spellId) -- 36469 = "Parasite"
	if self:Me(args.destGUID) then
		self:Say(args.spellId, 36469) -- 36469 = "Parasite"
	end
end

function mod:ParasiticShadowfiendFailure(args) -- The parasite reached someone new before it was killed
	self:TargetMessageOld(41917, args.destName, "yellow")
	self:TargetBar(41917, 10, args.destName, 36469, 41917) -- 36469 = "Parasite"
	if self:Me(args.destGUID) then
		self:Say(41917, 36469) -- 36469 = "Parasite"
	end
end

function mod:ParasiticShadowfiendOver(args)
	self:StopBar(args.spellName, args.destName)
end

--[[ Stage Two: Flames of Azzinoth ]]--
function mod:ThrowGlaive() -- Stage 2
	flamesDead = 0

	self:PrimaryIcon(41917) -- Parasitic Shadowfiend
	self:CDBar(40585, 95) -- Dark Barrage
	self:MessageOld("stages", "cyan", nil, CL.stage:format(2), false)
end

function mod:DarkBarrage(args)
	self:TargetMessageOld(args.spellId, args.destName, "red", "alert")
	self:PrimaryIcon(args.spellId, args.destName)
	barrageCount = barrageCount + 1
	self:CDBar(args.spellId, 50) -- Varies between 50 and 70 depending on Eye Blast
	self:TargetBar(args.spellId, 10, args.destName, L.barrage_bar)
end

function mod:DarkBarrageRemoved(args)
	self:PrimaryIcon(args.spellId)
	self:StopBar(L.barrage_bar, args.destName)
end

function mod:UncagedWrath(args)
	self:MessageOld(args.spellId, "orange", "warning")
end

do
	local prev = 0
	function mod:EyeBlast(args)
		local t = GetTime()
		if t-prev > 2 then
			self:MessageOld(args.spellId, "yellow", "info", args.spellName, "spell_fire_felflamebolt")
		end
		prev = t -- Continually spams every 1s during the cast
	end
end

--[[ Stage Three: The Demon Within ]]--
function mod:FlameDeath() -- Stage 3
	flamesDead = flamesDead + 1
	if flamesDead == 2 then
		self:StopBar(40585) -- Dark Barrage
		self:MessageOld("stages", "cyan", "alarm", CL.stage:format(3), false)
		self:Bar(40506, 75) -- Demon Form
		self:OpenProximity(40932, 5) -- Agonizing Flames
	end
end

function mod:AgonizingFlames(args)
	playerList[#playerList+1] = args.destName
	if #playerList == 1 then
		self:ScheduleTimer("TargetMessageOld", 0.3, args.spellId, playerList, "red", "alert")
	end
end

function mod:FlameBurst(args)
	burstCount = burstCount + 1
	self:MessageOld(args.spellId, "red", "alert")
	if burstCount < 3 then -- He'll only do three times before transforming again
		self:Bar(args.spellId, 20)
	end
end

function mod:SummonShadowDemons(args)
	self:MessageOld(args.spellId, "red", "alert")
end

--[[ Stage Four: The Long Hunt ]]--
function mod:ShadowPrison(args) -- Pre Stage 4 Intermission
	self:MessageOld("stages", "cyan", nil, CL.intermission, false)
	self:Bar("stages", 30, CL.intermission, args.spellId)
end

function mod:ShadowPrisonRemoved(args) -- Stage 4
	if self:MobId(args.destGUID) == 23089 then -- When debuff drops from Akama (downstairs)
		self:MessageOld("stages", "cyan", nil, CL.stage:format(4), false)

		self:Bar(40683, 45) -- Frenzy
		self:Bar(40506, 60) -- Demon Form
	end
end

function mod:Frenzy(args)
	self:MessageOld(args.spellId, "orange", "long")
	--self:Bar(args.spellId, ??) -- Frenzy
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, castGUID, spellId)
	if spellId == 40693 and not castCollector[castGUID] then -- Cage Trap
		self:MessageOld(40695, "red", "info", CL.spawned:format(self:SpellName(spellId)), 199341) -- 199341: ability_hunter_traplauncher / icon 461122
	end
end

function mod:UNIT_AURA(_, unit)
	if self:MobId(self:UnitGUID(unit)) == 22917 then
		if self:UnitBuff(unit, self:SpellName(40506), 40506) then -- Demon Form
			if not inDemonPhase then
				inDemonPhase = true
				burstCount = 0
				self:Bar(41117, 25) -- Summon Shadow Demons
				self:Bar(41126, 15) -- Flame Burst
				self:MessageOld(40506, "red", "alarm") -- Demon Form
				local demonFormOver = CL.over:format(self:SpellName(40506))
				self:Bar(40506, 60, demonFormOver)
				timer1 = self:ScheduleTimer("MessageOld", 60, 40506, "green", nil, demonFormOver) -- Demon Form
				timer2 = self:ScheduleTimer("Bar", 60, 40506, 60) -- Demon Form
			end
		elseif inDemonPhase then
			inDemonPhase = false
			self:CancelTimer(timer1)
			self:CancelTimer(timer2)
			timer1, timer2 = nil, nil
			self:StopBar(CL.over:format(self:SpellName(40506))) -- Demon Form
			self:StopBar(41117) -- Summon Shadow Demons
			self:StopBar(41126) -- Flame Burst
		end

		if self:UnitDebuff(unit, self:SpellName(40695)) then -- Caged
			if not isCaged then
				isCaged = true
				self:MessageOld(40695, "green", "warning")
				self:Bar(40695, 15)
			end
		elseif isCaged then
			isCaged = false
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg == L.warmup_trigger then
		self:Bar("warmup", 41.5, CL.active, "inv_weapon_glave_01")
	end
end

do
	local prev = 0
	function mod:Damage(args)
		if self:Me(args.destGUID) and GetTime()-prev > 1.5 then
			prev = GetTime()
			self:MessageOld(args.spellId == 40030 and 40018 or args.spellId, "blue", "alert", CL.underyou:format(args.spellId == 40030 and self:SpellName(40018) or args.spellName))
		end
	end
end
