
--------------------------------------------------------------------------------
-- TODO List:
-- - Add Marker for BrandOfArgus targets

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Tichondrius", 1088, 1762)
if not mod then return end
mod:RegisterEnableMob(103685)
mod.engageId = 1862
--mod.respawnTime = 0

--------------------------------------------------------------------------------
-- Locals
--

local carrionPlagueCount = 1
local seekerSwarmCount = 1
local brandOfArgusCount = 1
local feastOfBloodCount = 1
local echoesOfTheVoidCount = 1
local illusionaryNightCount = 1
local timers = {
	-- Carrion Plague, SPELL_CAST_SUCCESS for 212997
	[206480] = {7, 25, 35.5, 24.5, 75, 25.5, 35.5, 27, 75, 25.5, 40.5, 20.5, 53.5, 25.5},

	-- Seeker Swarm, SPELL_CAST_SUCCESS
	[213238] = {27, 25, 35, 25, 75, 25.5, 37.5, 25, 75, 25.5, 36, 22.5, 56},

	-- Brand of Argus, SPELL_CAST_SUCCESS
	[212794] = {15, 25, 35, 25, 75, 25.5, 32.5, 30, 75, 25.5, 36, 22.5, 56, 25.5},

	-- Feast of Blood, SPELL_AURA_APPLIED
	[208230] = {20, 25, 35, 25, 75, 25.5, 37.5, 25, 75, 25.5, 36, 22.5, 56, 25.5},

	-- Echoes of the Void, SPELL_CAST_SUCCESS
	[213531] = {57.5, 65, 95.5, 67.5, 100.5, 59.5},
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Stage One ]]--
		{206480, "SAY"}, -- Carrion Plague
		213238, -- Seeker Swarm
		{212794, "SAY"}, -- Brand of Argus
		208230, -- Feast of Blood
		213531, -- Echoes of the Void
		"berserk",

		--[[ Stage Two ]]--
		206365, -- Illusionary Night
		215988, -- Carrion Nightmare
		206466, -- Essence of Night

		--[[ Felsworm Spellguard ]]--
		216027, -- Nether Zone

		--[[ Sightless Watcher ]]--
		{216024, "SAY"}, -- Volatile Wound
	}, {
		[206480] = -13552, -- Stage One
		[206365] = -13553, -- Stage Two
		[216027] = -13515, -- Felsworm Spellguard
		[216024] = -13525, -- Sightless Watcher
	}
end

function mod:OnBossEnable()
	--[[ Stage One ]]--
	self:Log("SPELL_AURA_APPLIED", "CarrionPlague", 206480)
	self:Log("SPELL_CAST_SUCCESS", "CarrionPlagueSuccess", 212997)
	self:Log("SPELL_CAST_SUCCESS", "SeekerSwarm", 213238)
	self:Log("SPELL_AURA_APPLIED", "BrandOfArgus", 212794)
	self:Log("SPELL_CAST_SUCCESS", "BrandOfArgusSuccess", 212794)
	self:Log("SPELL_AURA_APPLIED", "FeastOfBlood", 208230)
	self:Log("SPELL_CAST_START", "EchoesOfTheVoid", 213531)

	--[[ Stage Two ]]--
	self:Log("SPELL_CAST_START", "IllusionaryNight", 206365)
	self:Log("SPELL_CAST_SUCCESS", "CarrionNightmare", 215988)
	self:Log("SPELL_AURA_APPLIED", "EssenceOfNight", 206466)

	--[[ Felsworm Spellguard ]]--
	self:Log("SPELL_AURA_APPLIED", "NetherZoneDamage", 216027)
	self:Log("SPELL_PERIODIC_DAMAGE", "NetherZoneDamage", 216027)
	self:Log("SPELL_PERIODIC_MISSED", "NetherZoneDamage", 216027)

	--[[ Sightless Watcher ]]--
	self:Log("SPELL_AURA_APPLIED", "VolatileWound", 216024)
end

function mod:OnEngage()
	carrionPlagueCount = 1
	seekerSwarmCount = 1
	brandOfArgusCount = 1
	feastOfBloodCount = 1
	echoesOfTheVoidCount = 1
	illusionaryNightCount = 1
	self:Bar(206480, timers[206480][carrionPlagueCount], CL.count:format(self:SpellName(206480), carrionPlagueCount))
	self:Bar(213238, timers[213238][seekerSwarmCount], CL.count:format(self:SpellName(213238), seekerSwarmCount))
	if not self:Easy() then
		self:Bar(212794, timers[212794][brandOfArgusCount], CL.count:format(self:SpellName(212794), brandOfArgusCount))
	end
	self:Bar(208230, timers[208230][feastOfBloodCount], CL.count:format(self:SpellName(208230), feastOfBloodCount))
	self:Bar(213531, timers[213531][echoesOfTheVoidCount], CL.count:format(self:SpellName(213531), echoesOfTheVoidCount))
	self:Bar(206365, 130, CL.count:format(self:SpellName(206365), illusionaryNightCount))
	if self:Normal() or self:Heroic() then
		self:Berserk(463)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ Stage One ]]--
do
	local list = mod:NewTargetList()
	function mod:CarrionPlague(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Attention", "Warning")
		end

		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
	end
end

function mod:CarrionPlagueSuccess(args)
	carrionPlagueCount = carrionPlagueCount + 1
	self:Bar(206480, timers[206480][carrionPlagueCount] or 20, CL.count:format(args.spellName, carrionPlagueCount))
end

function mod:SeekerSwarm(args)
	self:Message(args.spellId, "Urgent", "Info", CL.count:format(args.spellName, carrionPlagueCount))
	seekerSwarmCount = seekerSwarmCount + 1
	self:Bar(args.spellId, timers[args.spellId][seekerSwarmCount] or 22, CL.count:format(args.spellName, seekerSwarmCount))
end

do
	local list = mod:NewTargetList()
	function mod:BrandOfArgus(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Positive", "Alarm", CL.count:format(args.spellName, brandOfArgusCount-1))
		end

		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
	end
end

function mod:BrandOfArgusSuccess(args)
	brandOfArgusCount = brandOfArgusCount + 1
	self:Bar(args.spellId, timers[args.spellId][brandOfArgusCount] or 22, CL.count:format(args.spellName, brandOfArgusCount))
end

function mod:FeastOfBlood(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Long", CL.count:format(args.spellName, feastOfBloodCount), nil, true)
	feastOfBloodCount = feastOfBloodCount + 1
	self:Bar(args.spellId, timers[args.spellId][feastOfBloodCount] or 22, CL.count:format(args.spellName, feastOfBloodCount))
end

function mod:EchoesOfTheVoid(args)
	self:Message(args.spellId, "Important", "Long", CL.count:format(args.spellName, echoesOfTheVoidCount))
	self:StopBar(CL.count:format(args.spellName, echoesOfTheVoidCount))
	self:Bar(args.spellId, 10, CL.count:format(args.spellName, echoesOfTheVoidCount))
	echoesOfTheVoidCount = echoesOfTheVoidCount + 1
	self:Bar(args.spellId, timers[args.spellId][echoesOfTheVoidCount] or 60, CL.count:format(args.spellName, echoesOfTheVoidCount))
end

--[[ Stage Two ]]--
function mod:IllusionaryNight(args)
	self:Message(args.spellId, "Neutral", "Long", CL.count:format(args.spellName, illusionaryNightCount))
	self:Bar(args.spellId, 32, CL.cast:format(CL.count:format(args.spellName, illusionaryNightCount)))
	illusionaryNightCount = illusionaryNightCount + 1
	self:Bar(args.spellId, 163, CL.count:format(args.spellName, illusionaryNightCount))
	self:Bar(215988, 8.5, CL.cast:format(self:SpellName(215988))) -- Carrion Nightmare
end

function mod:CarrionNightmare(args)
	self:Bar(args.spellId, 4, CL.cast:format(args.spellName))
end

function mod:EssenceOfNight(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Info", CL.you:format(args.spellName))
	end
end

--[[ Felsworm Spellguard ]]--
do
	local prev = 0
	function mod:NetherZoneDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

--[[ Sightless Watcher ]]--
do
	local list = mod:NewTargetList()
	function mod:VolatileWound(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.5, args.spellId, list, "Urgent", "Alarm", nil, nil, self:Dispeller("magic"))
		end

		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
	end
end
