--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nymue, Weaver of the Cycle", 2549, 2556)
if not mod then return end
mod:RegisterEnableMob(206172) -- Nymue
mod:SetEncounterID(2708)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local viridianRainCount = 1
local continuumCount = 1
local impendingLoomCount = 1
local surgingGrowthCount = 1
local fullBloomCount = 1
local radialFlourishCount = 1
local inflorescenceOnMe = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.continuum = "New Lines"
	L.impending_loom = "Dodges"
	L.viridian_rain = "Damage + Bombs"
	L.lumbering_slam = "Frontal Cone"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		420554, -- Verdant Matrix
		-- Stage One: Rapid Iteration
		420846, -- Continuum
		429615, -- Impending Loom
		--420971, -- Surging Growth
		420907, -- Viridian Rain
		{427722, "PRIVATE", "SAY"}, -- Weaver's Burden
		-- Stage Two: Creation Complete
		426855, -- Full Bloom (Stage 2)
		413443, -- Life Ward
		429108, -- Lumbering Slam
		422721, -- Radial Flourish
		429798, -- Verdent Rend
	},{
		[420554] = "general",
		[420846] = -28355, -- Stage One: Rapid Iteration
		[426855] = -28356, -- Stage Two: Creation Complete
		[413443] = -27432, -- Cycle Warden
	},{
		[420846] = L.continuum, -- Continuum (New Lines)
		[429615] = L.impending_loom, -- Impending Loom (Dodges)
		[420907] = L.viridian_rain, -- Viridian Rain (Raid Damage)
		[427722] = CL.bombs, -- Weaver's Burden (Bombs)
		[426855] = CL.stage:format(2), -- Full Bloom (Stage 2)
		[429108] = L.lumbering_slam, -- Lumbering Slam (Frontal Cone)
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER") -- Weaver's Burden (existed all of testing, sooooo)

	-- Stage One: Rapid Iteration
	self:Log("SPELL_AURA_APPLIED", "VerdantMatrixApplied", 420554)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VerdantMatrixApplied", 420554)
	self:Log("SPELL_CAST_START", "Continuum", 420846)
	self:Log("SPELL_CAST_START", "ImpendingLoom", 429615)
	self:Log("SPELL_CAST_SUCCESS", "ViridianRain", 420907)
	self:Log("SPELL_AURA_APPLIED", "InflorescenceApplied", 423195)
	self:Log("SPELL_AURA_REMOVED", "InflorescenceRemoved", 423195)

	-- Stage Two: Creation Complete
	self:Log("SPELL_CAST_START", "FullBloom", 426855)
	self:Log("SPELL_AURA_APPLIED", "LifeWardApplied", 413443)
	self:Log("SPELL_AURA_REMOVED_DOSE", "LifeWardRemoved", 413443)
	self:Log("SPELL_CAST_START", "LumberingSlam", 429108)
	self:Log("SPELL_CAST_SUCCESS", "RadialFlourish", 422721)
	self:Log("SPELL_AURA_APPLIED", "VerdantRendApplied", 429798)
end

function mod:OnEngage()
	viridianRainCount = 1
	continuumCount = 1
	impendingLoomCount = 1
	fullBloomCount = 1
	radialFlourishCount = 1
	inflorescenceOnMe = false

	self:Bar(420907, 20, CL.count:format(L.viridian_rain, viridianRainCount)) -- Viridian Rain
	self:Bar(429615, 24.0, CL.count:format(L.impending_loom, impendingLoomCount)) -- Impending Loom
	self:Bar(426855, 76.1, CL.stage:format(2)) -- Full Bloom

	-- self:SetPrivateAuraSound(427722) -- Weaver's Burden
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage One: Rapid Iteration
function mod:VerdantMatrixApplied(args)
	if self:Me(args.destGUID) and not inflorescenceOnMe then -- Don't warn when you should be crossing
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, amount, 3)
		self:PlaySound(args.spellId, "underyou")
		if amount > 2 then
			self:PlaySound(args.spellId, "underyou")
		end
	end
end

function mod:Continuum(args)
	self:Message(args.spellId, "cyan", CL.count:format(L.continuum, continuumCount))
	self:PlaySound(args.spellId, "info")
	continuumCount = continuumCount + 1

	self:StopBar(429108) -- Lumbering Slam
	self:StopBar(422721) -- Radial Flourish

	self:SetStage(1)
	impendingLoomCount = 1
	viridianRainCount = 1

	self:Bar(420907, 36.6, CL.count:format(L.viridian_rain, viridianRainCount)) -- Viridian Rain
	self:Bar(429615, 41.5, CL.count:format(L.impending_loom, impendingLoomCount)) -- Impending Loom
	self:Bar(426855, 87.5, CL.stage:format(2)) -- Full Bloom
end

function mod:ImpendingLoom(args)
	self:StopBar(CL.count:format(L.impending_loom, impendingLoomCount))
	self:Message(args.spellId, "cyan", CL.soon:format(CL.count:format(L.impending_loom, impendingLoomCount)))
	self:PlaySound(args.spellId, "info")
	impendingLoomCount = impendingLoomCount + 1
	if impendingLoomCount < 3 then
		self:Bar(args.spellId, 24, CL.count:format(L.impending_loom, impendingLoomCount))
	end
end

-- function mod:SurgingGrowth(args)
-- 	self:StopBar(CL.count:format(L.surging_growth, surgingGrowthCount))
-- 	self:Message(args.spellId, "cyan", CL.count:format(L.surging_growth, surgingGrowthCount))
-- 	self:PlaySound(args.spellId, "info")
-- 	surgingGrowthCount = surgingGrowthCount + 1
-- 	--self:Bar(args.spellId, 90, CL.count:format(L.surging_growth, surgingGrowthCount))
-- end

function mod:ViridianRain(args)
	self:StopBar(CL.count:format(L.viridian_rain, viridianRainCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.viridian_rain, viridianRainCount))
	self:PlaySound(args.spellId, "alarm")
	viridianRainCount = viridianRainCount + 1
	if viridianRainCount < 4 then
		self:Bar(args.spellId, 20, CL.count:format(L.viridian_rain, viridianRainCount))
	end
end

function mod:CHAT_MSG_RAID_BOSS_WHISPER(_, msg)
	-- "|TInterface\\ICONS\\INV_10_Enchanting2_MagicSwirl_Green.BLP:20|t You are marked with |cFFFF0000|Hspell:427722|h[Weaver's Burden]|h|r!"
	if msg:find("spell:427722", nil, true) then
		self:PersonalMessage(427722, nil, CL.bomb)
		self:PlaySound(427722, "warning")
		self:Say(427722, CL.bomb)
	end
end

function mod:InflorescenceApplied(args)
	if self:Me(args.destGUID) then
		inflorescenceOnMe = true
	end
end

function mod:InflorescenceRemoved(args)
	if self:Me(args.destGUID) then
		inflorescenceOnMe = false
	end
end

-- Stage Two: Creation Complete
function mod:FullBloom(args)
	self:StopBar(CL.count:format(L.viridian_rain, viridianRainCount)) -- Viridian Rain
	self:StopBar(CL.count:format(L.impending_loom, impendingLoomCount)) -- Impending Loom
	self:StopBar(CL.stage:format(2)) -- Full Bloom

	radialFlourishCount = 1

	self:Bar(413443, 6.9) -- Life Ward
	self:Bar(422721, 12.6) -- Radial Flourish
	self:Bar(429108, 19) -- Lumbering Slam

	self:StopBar(CL.stage:format(2))
	self:Message(args.spellId, "green", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "long")
	fullBloomCount = fullBloomCount + 1
	self:SetStage(2)
end

function mod:LifeWardApplied(args)
	self:Message(args.spellId, "yellow", CL.onboss:format(args.spellName))
	self:PlaySound(args.spellId, "info")
end

function mod:LifeWardRemoved(args)
	local total = 2
	self:Message(args.spellId, "green", ("%s (%d/%d)"):format(CL.removed:format(args.spellName), total - args.amount, total))
	self:PlaySound(args.spellId, "info")
end

do
	local prev = 0
	function mod:LumberingSlam(args)
		if args.time - prev > 3 then
			prev = args.time
			self:Message(args.spellId, "purple")
			self:PlaySound(args.spellId, "alert")
			self:Bar(args.spellId, 19.5) -- 19~20
		end
	end
end

do
	local prev = 0
	function mod:RadialFlourish(args)
		if args.time - prev > 3 then
			prev = args.time
			self:Message(args.spellId, "yellow")
			self:PlaySound(args.spellId, "alarm")
			radialFlourishCount = radialFlourishCount + 1
			self:Bar(args.spellId, radialFlourishCount == 2 and 11.5 or radialFlourishCount == 5 and 8.6 or 5.8) -- 10.2~12.7 / 5.6~6.1
		end
	end
end

function mod:VerdantRendApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "red")
		self:PlaySound(args.spellId, "alarm")
	end
end
