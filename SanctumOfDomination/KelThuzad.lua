--------------------------------------------------------------------------------
-- Module Declaration
--

if not IsTestBuild() then return end
local mod, CL = BigWigs:NewBoss("Kel'Thuzad", 2450, 2440)
if not mod then return end
mod:RegisterEnableMob(175559, 176703, 176973, 176974, 176929) -- Kel'Thuzad, Frostbound Devoted, Unstoppable Abomination, Soul Reaver, Remnant of Kel'Thuzad
mod:SetEncounterID(2422)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local tankList = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.spikes = "Spikes" -- Short for Glacial Spikes
	L.spike = "Spike"
	L.silence = mod:SpellName(226452) -- Silence
	L.miasma = "Miasma" -- Short for Necrotic Miasma
end

--------------------------------------------------------------------------------
-- Initialization
--


local glacialWrathMarker = mod:AddMarkerOption(false, "player", 1, 346459, 1, 2, 3, 4, 5) -- Malevolence
function mod:GetOptions()
	return {
		"stages",
		-- Stage One: Chains and Ice
		354198, -- Howling Blizzard
		352530, -- Dark Evocation
		{355389, "SAY"}, -- Corpse Detonation
		348071, -- Soul Fracture // Tank hit but spawns Soul Shards for DPS
		{348978, "TANK"}, -- Soul Exhaustion
		{346459, "SAY", "SAY_COUNTDOWN"}, -- Glacial Wrath
		glacialWrathMarker,
		{346530, "ME_ONLY"}, -- Shatter
		{347292, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Oblivion's Echo
		{348756, "SAY", "SAY_COUNTDOWN", "FLASH", "ME_ONLY_EMPHASIZE"}, -- Frost Blast
		-- Stage Two: The Phylactery Opens
		354289, -- Necrotic Miasma
		352051, -- Necrotic Surge
		352293, -- Necrotic Destruction
		352379, -- Freezing Blast
		355055, -- Glacial Winds
		352355, -- Necrotic Obliteration
		-- Stage Three: The Final Stand
		354639, -- Deep Freeze
	},{
		["stages"] = "general",
		[354198] = mod:SpellName(-22884), -- Stage One: Chains and Ice
		[354289] = mod:SpellName(-22885), -- Stage Two: The Phylactery Opens
		[354639] = mod:SpellName(-23201) -- Stage Three: The Final Stand
	},{
		[355389] = CL.fixate, -- Corpse Detonation (Fixate)
		[346459] = L.spikes, -- Glacial Wrath (Spikes)
		[347292] = L.silence, -- Oblivion's Echo (Silence)
		[354289] = L.miasma, -- Necrotic Miasma (Miasma)
	}
end

function mod:OnBossEnable()
	-- Stage One - Thirst for Blood
	self:Log("SPELL_CAST_START", "HowlingBlizzardStart", 354198)
	self:Log("SPELL_CAST_SUCCESS", "DarkEvocation", 352530)
	self:Log("SPELL_AURA_APPLIED", "CorpseDetonationFixateApplied", 355389)
	self:Log("SPELL_CAST_START", "SoulFractureStart", 348071)
	self:Log("SPELL_AURA_APPLIED", "SoulExhaustionApplied", 348978)
	self:Log("SPELL_AURA_REMOVED", "SoulExhaustionRemoved", 348978)
	self:Log("SPELL_CAST_START", "GlacialWrath", 346459)
	self:Log("SPELL_AURA_APPLIED", "GlacialWrathApplied", 353808)
	self:Log("SPELL_AURA_REMOVED", "GlacialWrathRemoved", 353808)
	self:Log("SPELL_AURA_APPLIED", "ShatterApplied", 346530)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShatterApplied", 346530)
	self:Log("SPELL_AURA_APPLIED", "OblivionsEchoApplied", 347292)
	self:Log("SPELL_AURA_REMOVED", "OblivionsEchoRemoved", 347292)
	self:Log("SPELL_CAST_START", "FrostBlastStart", 348756)

	-- Stage Two: The Phylactery Opens
	self:Log("SPELL_AURA_APPLIED", "NecroticMiasmaApplied", 354289)
	self:Log("SPELL_AURA_APPLIED_DOSE", "NecroticMiasmaApplied", 354289)
	self:Log("SPELL_AURA_APPLIED", "NecroticSurgeApplied", 352051)
	self:Log("SPELL_AURA_APPLIED_DOSE", "NecroticSurgeApplied", 352051)
	self:Log("SPELL_CAST_START", "NecroticDestruction", 352293)
	self:Log("SPELL_CAST_START", "FreezingBlast", 352379)
	self:Log("SPELL_CAST_START", "GlacialWinds", 355055)
	self:Log("SPELL_CAST_START", "NecroticObliteration", 352355)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 354198, 354639) -- Howling Blizzard, Deep Freeze
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 354198, 354639)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 354198, 354639)

	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:GROUP_ROSTER_UPDATE()
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:GROUP_ROSTER_UPDATE() -- Compensate for quitters (LFR)
	tankList = {}
	for unit in self:IterateGroup() do
		if self:Tank(unit) then
			tankList[#tankList+1] = unit
		end
	end
end

-- Stage One: Chains and Ice
function mod:HowlingBlizzardStart(args)
	self:Message(args.spellId, "cyan", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "long")
end

function mod:DarkEvocation(args)
	self:Message(args.spellId, "cyan", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "long")
end

function mod:CorpseDetonationFixateApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.fixate)
		self:PlaySound(args.spellId, "alarm")
		self:Say(args.spellId, CL.fixate)
	end
end

function mod:SoulFractureStart(args)
	if self:Tank() then
		self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
		self:PlaySound(args.spellId, "alarm")
	else
		self:Message(args.spellId, "purple", CL.incoming:format(self:SpellName(-23224))) -- Soul Shard
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:SoulExhaustionApplied(args)
	if self:Tank() and self:Tank(args.destName) then
		local unit = self:GetBossId(args.sourceGUID) -- Check if its always boss1, then we dont have to GetBossId
		if not self:Me(args.destGUID) and not self:Tanking(unit) then
			self:TargetMessage(args.spellId, "purple", args.destName)
			self:PlaySound(args.spellId, "warning", "taunt", args.destName) -- Not taunted? Play warning sound.
		elseif self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "alarm")
			self:TargetBar(args.spellId, 60, args.destName)
		end
	end
end

function mod:SoulExhaustionRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
		self:StopBar(args.spellId, args.destName)
	end
end

function mod:GlacialWrath(args)
	self:Message(args.spellId, "orange", CL.casting:format(L.spikes))
	self:PlaySound(args.spellId, "alert")
end

do
	local playerList = {}
	local prev = 0
	function mod:GlacialWrathApplied(args)
		local t = args.time -- new set of debuffs
		if t-prev > 5 then
			prev = t
			playerList = {}
		end
		local count = #playerList+1
		local icon = count
		playerList[count] = args.destName
		playerList[args.destName] = icon -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(346459, CL.count_rticon:format(L.spike, count, count))
			self:SayCountdown(346459, 6, count)
			self:PlaySound(346459, "warning")
		end
		self:NewTargetsMessage(346459, "orange", playerList, nil, L.spike)
		self:CustomIcon(glacialWrathMarker, args.destName, icon)
	end

	function mod:GlacialWrathRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(346459)
		end
		self:CustomIcon(glacialWrathMarker, args.destName)
	end
end


do
	local playerName = mod:UnitName("player")
	local stacks = 1
	local scheduled = nil

	local function ShatterStackMessage()
		mod:NewStackMessage(346530, "blue", playerName, stacks)
		mod:PlaySound(346530, stacks > 4 and "warning" or "info") -- How many stacks is too much?
		scheduled = nil
	end

	function mod:ShatterApplied(args) -- Throttle incase several die at the same time
		if self:Me(args.destGUID) then
			stacks = args.amount or 1
			if not scheduled then
				scheduled = self:ScheduleTimer(ShatterStackMessage, 0.1)
			end
		end
	end
end

do
	local playerList = {}
	local prev = 0

	function mod:OblivionsEchoApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
		end
		local count = #playerList+1
		playerList[count] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId, L.silence)
			self:SayCountdown(args.spellId, 6)
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "yellow", playerList, nil, L.silence)
	end
end

function mod:OblivionsEchoRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end
do
	local function printTarget(self, player, guid)
		if self:Me(guid) then
			self:PlaySound(348756, "warning")
			self:Yell(348756)
			self:Flash(348756)
			self:YellCountdown(348756, 3, nil, 2)
		else
			self:PlaySound(348756, "alert")
		end
		self:TargetMessage(348756, "orange", player)
	end

	function mod:FrostBlastStart(args)
		self:GetNextBossTarget(printTarget, args.sourceGUID)
	end
end

function mod:NecroticMiasmaApplied(args) -- Tune stack numbers
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 2 == 0 and amount > 7 then -- 7+ every 2
			self:NewStackMessage(args.spellId, "blue", args.destName, amount, 10, L.miasma)
			if amount > 9 then
				self:PlaySound(args.spellId, "alert")
			end
		end
	end
end

function mod:NecroticSurgeApplied(args)
	self:NewStackMessage(args.spellId, "cyan", args.destName, args.amount)
	self:PlaySound(args.spellId, "info")
end

function mod:NecroticDestruction(args)
	self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "long")
	--self:CastBar(args.spellId, 45)
end

function mod:FreezingBlast(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end

function mod:GlacialWinds(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:NecroticObliteration(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 10)
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
