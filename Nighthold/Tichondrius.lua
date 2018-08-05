
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Tichondrius", 1530, 1762)
if not mod then return end
mod:RegisterEnableMob(103685)
mod.engageId = 1862
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local carrionPlagueCount = 1
local seekerSwarmCount = 1
local brandOfArgusCount = 1
local feastOfBloodCount = 1
local echoesOfTheVoidCount = 1
local illusionaryNightCount = 1
local addWaveCount = 1
local timers = {
	-- Carrion Plague, SPELL_CAST_SUCCESS for 212997
	[206480] = {7, 25, 35.5, 24.5, 75, 25.5, 35.5, 27, 75, 25.5, 40.5, 20.5},

	-- Seeker Swarm, SPELL_CAST_SUCCESS
	[213238] = {27, 25, 35, 25, 75, 25.5, 37.5, 25, 75, 25.5, 36, 22.5},

	-- Brand of Argus, SPELL_CAST_SUCCESS
	[212794] = {15, 25, 35, 25, 75, 25.5, 32.5, 30, 75, 25.5, 36, 22.5},

	-- Feast of Blood, SPELL_AURA_APPLIED
	[208230] = {20, 25, 35, 25, 75, 25.5, 37.5, 25, 75, 25.5, 36, 22.5},

	-- Echoes of the Void, SPELL_CAST_SUCCESS
	[213531] = {57.5, 65, 95.5, 67.5, 100.5, 59.5},

	-- Adds, CHAT_MSG_MONSTER_YELL
	["adds"] = {185.7, 47.5, 115, 35.5, 48.5},
}
local essenceTargets = {}
local addsKilled = 0
local argusMarks = {false, false, false, false, false, false}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.addsKilled = "Adds killed"
	L.gotEssence = "Got Essence"

	L.adds = CL.adds
	L.adds_desc = "Timers and warnings for the add spawns."
	L.adds_yell1 = "Underlings! Get in here!"
	L.adds_yell2 = "Show these pretenders how to fight!"
end

--------------------------------------------------------------------------------
-- Initialization
--

local argusMarker = mod:AddMarkerOption(false, "player", 1, 212794, 1, 2, 3, 4, 5, 6)
function mod:GetOptions()
	return {
		--[[ Stage One ]]--
		{206480, "SAY"}, -- Carrion Plague
		213238, -- Seeker Swarm
		{212794, "SAY"}, -- Brand of Argus
		argusMarker,
		208230, -- Feast of Blood
		213531, -- Echoes of the Void
		"adds",
		"berserk",

		--[[ Stage Two ]]--
		206365, -- Illusionary Night
		215988, -- Carrion Nightmare
		{206466, "INFOBOX"}, -- Essence of Night

		--[[ Felsworm Spellguard ]]--
		{216024, "SAY", "ME_ONLY"}, -- Volatile Wound
		216027, -- Nether Zone

		--[[ Sightless Watcher ]]--
		{216040, "SAY", "PROXIMITY"}, -- Burning Soul
	}, {
		[206480] = -13552, -- Stage One
		[206365] = -13553, -- Stage Two
		[216024] = -13515, -- Felsworm Spellguard
		[216040] = -13525, -- Sightless Watcher
	}
end

function mod:OnBossEnable()
	--[[ Stage One ]]--
	self:Log("SPELL_AURA_APPLIED", "CarrionPlague", 206480)
	self:Log("SPELL_CAST_SUCCESS", "CarrionPlagueSuccess", 212997)
	self:Log("SPELL_CAST_SUCCESS", "SeekerSwarm", 213238)
	self:Log("SPELL_AURA_APPLIED", "BrandOfArgus", 212794)
	self:Log("SPELL_AURA_REMOVED", "BrandOfArgusRemoved", 212794)
	self:Log("SPELL_CAST_SUCCESS", "BrandOfArgusSuccess", 212794)
	self:Log("SPELL_CAST_SUCCESS", "FeastOfBlood", 208230)
	self:Log("SPELL_CAST_START", "EchoesOfTheVoid", 213531)
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	--[[ Stage Two ]]--
	self:Log("SPELL_CAST_START", "IllusionaryNight", 206365)
	self:Log("SPELL_CAST_SUCCESS", "CarrionNightmare", 215988)
	self:Log("SPELL_AURA_APPLIED", "EssenceOfNight", 206466)
	self:Death("AddDeath", 104326)

	--[[ Felsworm Spellguard ]]--
	self:Log("SPELL_AURA_APPLIED", "VolatileWound", 216024)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VolatileWound", 216024)
	self:Log("SPELL_AURA_REMOVED", "VolatileWoundRemoved", 216024)
	self:Log("SPELL_AURA_APPLIED", "NetherZoneDamage", 216027)
	self:Log("SPELL_PERIODIC_DAMAGE", "NetherZoneDamage", 216027)
	self:Log("SPELL_PERIODIC_MISSED", "NetherZoneDamage", 216027)

	--[[ Sightless Watcher ]]--
	self:Log("SPELL_AURA_APPLIED", "BurningSoul", 216040)
	self:Log("SPELL_AURA_REMOVED", "BurningSoulRemoved", 216040)
end

function mod:OnEngage()
	carrionPlagueCount = 1
	seekerSwarmCount = 1
	brandOfArgusCount = 1
	feastOfBloodCount = 1
	echoesOfTheVoidCount = 1
	illusionaryNightCount = 1
	addWaveCount = 1
	addsKilled = 0
	argusMarks = {false, false, false, false, false, false}
	wipe(essenceTargets)
	self:Bar("adds", timers["adds"][addWaveCount], CL.count:format(L.adds, addWaveCount), 212552) -- 212552 = Wraith Walk, inv_helm_plate_raiddeathknight_p_01, id 1100041
	if GetLocale() ~= "enUS" and L.adds_yell1 == "Underlings! Get in here!" then -- Not translated
		self:ScheduleTimer("CHAT_MSG_MONSTER_YELL", timers["adds"][addWaveCount], "timer")
	end
	self:Bar(206480, timers[206480][carrionPlagueCount], CL.count:format(self:SpellName(206480), carrionPlagueCount))
	self:Bar(213238, timers[213238][seekerSwarmCount], CL.count:format(self:SpellName(213238), seekerSwarmCount))
	if not self:Easy() then
		self:Bar(212794, timers[212794][brandOfArgusCount], CL.count:format(self:SpellName(212794), brandOfArgusCount))
	end
	self:Bar(208230, timers[208230][feastOfBloodCount], CL.count:format(self:SpellName(208230), feastOfBloodCount))
	self:Bar(213531, timers[213531][echoesOfTheVoidCount], CL.count:format(self:SpellName(213531), echoesOfTheVoidCount))
	self:Bar(206365, 130, CL.count:format(self:SpellName(206365), illusionaryNightCount))
	if not self:LFR() then
		self:Berserk(self:Normal() and 523 or 463)
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
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "yellow", "Warning")
		end

		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
	end
end

function mod:CarrionPlagueSuccess(args)
	carrionPlagueCount = carrionPlagueCount + 1
	local timer = timers[206480][carrionPlagueCount]
	if timer then
		self:Bar(206480, timer, CL.count:format(args.spellName, carrionPlagueCount))
	end
end

function mod:SeekerSwarm(args)
	self:Message(args.spellId, "orange", "Info", CL.count:format(args.spellName, seekerSwarmCount))
	seekerSwarmCount = seekerSwarmCount + 1
	local timer = timers[args.spellId][seekerSwarmCount]
	if timer then
		self:Bar(args.spellId, timer, CL.count:format(args.spellName, seekerSwarmCount))
	end
end

do
	local list = mod:NewTargetList()
	function mod:BrandOfArgus(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "green", "Alarm", CL.count:format(args.spellName, brandOfArgusCount-1))
		end

		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end

		if self:GetOption(argusMarker) then
			for i = 1, 6 do
				if not argusMarks[i] then
					argusMarks[i] = args.destName
					SetRaidTarget(args.destName, i)
					break
				end
			end
		end
	end

	function mod:BrandOfArgusRemoved(args)
		if self:GetOption(argusMarker) then
			for i = 1, 6 do
				if argusMarks[i] == args.destName then
					argusMarks[i] = false
					SetRaidTarget(args.destName, 0)
					break
				end
			end
		end
	end
end

function mod:BrandOfArgusSuccess(args)
	brandOfArgusCount = brandOfArgusCount + 1
	local timer = timers[args.spellId][brandOfArgusCount]
	if timer then
		self:Bar(args.spellId, timer, CL.count:format(args.spellName, brandOfArgusCount))
	end
end

function mod:FeastOfBlood(args)
	self:TargetMessage(args.spellId, args.destName, "orange", "Long", CL.count:format(args.spellName, feastOfBloodCount), nil, true)
	feastOfBloodCount = feastOfBloodCount + 1
	local timer = timers[args.spellId][feastOfBloodCount]
	if timer then
		self:Bar(args.spellId, timer, CL.count:format(args.spellName, feastOfBloodCount))
	end
end

function mod:EchoesOfTheVoid(args)
	self:Message(args.spellId, "red", "Long", CL.count:format(args.spellName, echoesOfTheVoidCount))
	self:StopBar(CL.count:format(args.spellName, echoesOfTheVoidCount))
	self:Bar(args.spellId, 10, CL.count:format(args.spellName, echoesOfTheVoidCount))
	echoesOfTheVoidCount = echoesOfTheVoidCount + 1
	local timer = timers[args.spellId][echoesOfTheVoidCount]
	if timer then
		self:Bar(args.spellId, timer, CL.count:format(args.spellName, echoesOfTheVoidCount))
	end
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if event == "timer" or msg == L.adds_yell1 or msg == L.adds_yell2 then
		self:Message("adds", "cyan", "Alert", CL.count:format(L.adds, addWaveCount), 212552) -- 212552 = Wraith Walk, inv_helm_plate_raiddeathknight_p_01, id 1100041
		addWaveCount = addWaveCount + 1
		local timer = timers["adds"][addWaveCount]
		if timer then
			self:Bar("adds", timer, CL.count:format(L.adds, addWaveCount), 212552) -- 212552 = Wraith Walk, inv_helm_plate_raiddeathknight_p_01, id 1100041
			if self:Tank() then
				self:DelayedMessage("adds", timer-5, "cyan", CL.custom_sec:format(L.adds, 5))
			end
			if event == "timer" then
				self:ScheduleTimer("CHAT_MSG_MONSTER_YELL", timer, "timer")
			end
		end
	end
end

--[[ Stage Two ]]--
function mod:IllusionaryNight(args)
	addsKilled = 0
	wipe(essenceTargets)
	self:Message(args.spellId, "cyan", "Long", CL.count:format(args.spellName, illusionaryNightCount))
	self:CastBar(args.spellId, 32, CL.count:format(args.spellName, illusionaryNightCount))
	illusionaryNightCount = illusionaryNightCount + 1
	if illusionaryNightCount < 3 then
		self:Bar(args.spellId, 163, CL.count:format(args.spellName, illusionaryNightCount))
	end
	self:CastBar(215988, 8.5) -- Carrion Nightmare

	self:SetInfo(206466, 1, L.addsKilled)
	self:SetInfo(206466, 2, addsKilled)
	self:SetInfo(206466, 3, L.gotEssence)
	self:SetInfo(206466, 4, #essenceTargets)

	self:OpenInfo(206466, self:SpellName(206466))
	self:ScheduleTimer("CloseInfo", 40, 206466) -- some delay to look at the InfoBox after the phase
end

function mod:CarrionNightmare(args)
	self:CastBar(args.spellId, 4)
end

function mod:EssenceOfNight(args)
	essenceTargets[#essenceTargets+1] = args.destName
	self:SetInfo(206466, 4, #essenceTargets)

	if self:Me(args.destGUID) then
		self:Message(args.spellId, "blue", "Info", CL.you:format(args.spellName))
	end
end

function mod:AddDeath()
	addsKilled = addsKilled + 1
	self:SetInfo(206466, 2, addsKilled)
	if self:Mythic() and addsKilled % 5 == 0 then
		self:Message(206466, "cyan", nil, CL.mob_killed:format(CL.adds, addsKilled, 20))
	end
end

--[[ Felsworm Spellguard ]]--
do
	local list = mod:NewTargetList()
	function mod:VolatileWound(args)
		if UnitIsPlayer(args.destName) then
			if self:Me(args.destGUID) then
				if not args.amount then
					self:TargetMessage(args.spellId, args.destName, "blue", "Alarm")
				elseif args.amount % 2 == 0 then
					self:StackMessage(args.spellId, args.destName, args.amount, "blue", "Alarm")
				end
				self:TargetBar(args.spellId, 8, args.destName)
				self:CancelSayCountdown(args.spellId)
				self:SayCountdown(args.spellId, 8)
			elseif not args.amount then -- 1 stack
				list[#list+1] = args.destName
				if #list == 1 then
					self:ScheduleTimer("TargetMessage", 0.5, args.spellId, list, "orange", "Alarm")
				end
			end
		end
	end

	function mod:VolatileWoundRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
			self:StopBar(args.spellId, args.destName)
		end
	end
end

do
	local prev = 0
	function mod:NetherZoneDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "blue", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

--[[ Sightless Watcher ]]--
function mod:BurningSoul(args)
	self:TargetMessage(args.spellId, args.destName, "yellow", "Warning")
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:OpenProximity(args.spellId, 8)
	end
end

function mod:BurningSoulRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

