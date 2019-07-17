--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Za'qul, Herald of Ny'alotha", 2164, 2349)
if not mod then return end
mod:RegisterEnableMob(150859) -- Za'qul
mod.engageId = 2293
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.stage3_early = "Za'qul tears open the pathway to Delirium Realm!"  -- Yell is 14.5s before the actual cast start
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- General
		"stages",
		298192, -- Dark Beyond
		292971, -- Hysteria
		{295444, "TANK"}, -- Mind Tether
		294535, -- Portal of Madness
		301141, -- Crushing Grasp
		292963, -- Dread
		{293509, "SAY", "SAY_COUNTDOWN"}, -- Manifest Nightmares
		292996, -- Maddening Eruption
		295099, -- Punctured Darkness
		304733, -- Delirium's Descent
		303971, -- Dark Pulse
		299702, -- Dark Passage
		296018, -- Manic Dread
		295814, -- Psychotic Split
	},{
		["stages"] = "general",
		[295444] = CL.stage:format(1),
		[293509] = CL.stage:format(2),
		[304733] = CL.stage:format(3),
		[303971] = CL.stage:format(4),
		[295814] = CL.mythic,
	},{
		[301141] = self:SpellName(285205), -- Crushing Grasp (Tentacle)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	-- General
	self:Log("SPELL_AURA_APPLIED", "HysteriaApplied", 292971)
	self:Log("SPELL_AURA_APPLIED_DOSE", "HysteriaApplied", 292971)

	-- Stage 1
	self:Log("SPELL_CAST_SUCCESS", "MindTether", 295444)
	self:Log("SPELL_AURA_APPLIED", "MindTetherApplied", 295495, 295480) -- Main Target, Secondary Target
	self:Log("SPELL_CAST_START", "CrushingGrasp", 301141)
	self:Log("SPELL_AURA_APPLIED", "DreadApplied", 292963, 296018) -- Dread, Manic Dread

	-- Stage 2
	self:Log("SPELL_CAST_START", "OpeningFearRealm", 296257)
	self:Log("SPELL_AURA_APPLIED", "ManifestNightmaresApplied", 293509)
	self:Log("SPELL_AURA_REMOVED", "ManifestNightmaresRemoved", 293509)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE") -- Maddening Eruption
	self:Log("SPELL_AURA_APPLIED", "PuncturedDarkness", 295099)

	-- Stage 3
	self:Log("SPELL_CAST_START", "DeliriumsDescent", 304733)

	-- Stage 4
	self:Log("SPELL_CAST_START", "DarkPulse", 303971)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 298192) -- Dark Beyond
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 298192)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 298192)

	-- Mythic
	self:Log("SPELL_CAST_START", "PsychoticSplit", 295814)

end

function mod:OnEngage()
	stage = 1

	self:CDBar(295444, 5.5) -- Mind Tether
	self:CDBar(292963, 14.2) -- Dread
	self:CDBar(294535, 20) -- Portal of Madness
	self:CDBar(301141, 30.5, self:SpellName(285205)) -- Crushing Grasp (Tentacle)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	if msg:find(L.stage3_early) then -- No event here, but a spell is cast 4s later as fallback
		stage = 3
		self:PlaySound("stages", "long")
		self:Message2("stages", "cyan", CL.stage:format(stage), false)

		self:StopBar(294535) -- Portal of Madness

		self:Bar(304733, 4.5) -- Delirium's Descent
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 299711 then -- Pick a Portal
		if stage == 1 then -- Portal of Madness
			self:Message2(294535, "yellow")
			self:PlaySound(294535, "alert")
			self:Bar(294535, 84)
		elseif stage == 4 then
			self:Message2(299702, "yellow")
			self:PlaySound(299702, "alert")
			self:Bar(299702, 84)
		end
	elseif spellId == 295361 then -- Cancel All Phases (Encounter Reset) (Stage 4 start) Alternative: Energy Tracker-296465
		stage = 4
		self:PlaySound("stages", "long")
		self:Message2("stages", "cyan", CL.stage:format(stage), false)

		self:StopBar(292963) -- Dread
		self:StopBar(304733) -- Delirium's Descent

		self:CDBar(296018, 15) -- Manic Dread
		self:Bar(299702, 84) -- Portal of Madness
		self:Bar(292996, 34) -- Maddening Eruption
		self:CDBar(301141, 30.5, self:SpellName(285205)) -- Crushing Grasp (Tentacle)

		if self:Mythic() then
			self:Bar(295814, 45) -- Psychotic Split
		else
			self:Bar(303971, 75) -- Dark Pulse
		end
	elseif spellId == 299974 then -- Pick a Dread
		if stage < 4 then
			self:CDBar(292963, 75) -- Dread
		else
			self:CDBar(296018, 75) -- Manic Dread
		end
	end
end


-- General
function mod:HysteriaApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 3 == 0 then
			self:StackMessage(args.spellId, args.destName, args.amount, "blue")
			self:PlaySound(args.spellId, "alarm", nil, args.destName)
		end
	end
end

-- Stage 1
function mod:MindTether(args)
	self:CDBar(args.spellId, 48.5)
end

function mod:MindTetherApplied(args) -- XXX Make it better perhaps? this is very simple atm.
	if self:Me(args.destGUID) then
		self:PersonalMessage(295444, CL.link:format(args.sourceName))
		self:PlaySound(295444, "alert")
	end
end

function mod:CrushingGrasp(args) -- Tentacle
	self:Message2(args.spellId, "orange", self:SpellName(285205))
	self:PlaySound(args.spellId, "warning")
	self:CDBar(args.spellId, 31.5, self:SpellName(285205))
	--self:CastBar(args.spellId, 8) XXX Mythic has 3 casts, figure out a clever way if needed
end

do
	local playerList = mod:NewTargetList()
	function mod:DreadApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alert")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end
end

-- Stage 2

function mod:OpeningFearRealm(args)
	stage = 2
	self:PlaySound("stages", "long")
	self:Message2("stages", "cyan", CL.stage:format(stage), false)
	self:StopBar(294535) -- Portal of Madness

	self:CDBar(292996, 3.5) -- Maddening Eruption
	self:Bar(293509, 32.5) -- Manifest Nightmares
end

do
	local playerList = mod:NewTargetList()
	function mod:ManifestNightmaresApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 6)
			self:PlaySound(args.spellId, "alert")
		end
		if #playerList == 1 then
			self:CDBar(args.spellId, 30)
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end

	function mod:ManifestNightmaresRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	if msg:find("292996", nil, true) then -- Maddening Eruption
		self:Message2(292996, "cyan")
		self:PlaySound(292996, "info")
		self:CDBar(292996, stage == 4 and 90.5 or 60)
		self:CDBar(295099, 25) -- Punctured Darkness
	end
end

function mod:PuncturedDarkness(args)
	self:TargetMessage2(args.spellId, "green", args.destName)
	self:PlaySound(args.spellId, "long", args.destName)
	self:TargetBar(args.spellId, 20, args.destName)
end

-- Stage 3
function mod:DeliriumsDescent(args)
	if stage < 3 then -- Stage 3 Emote was not found
		stage = 3
		self:Message2("stages", "cyan", CL.stage:format(stage), false)
		self:StopBar(294535) -- Portal of Madness
	end

	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "long")
	self:Bar(args.spellId, 35)
end

-- Stage 4
function mod:DarkPulse(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end

-- Mythic
function mod:PsychoticSplit(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end
