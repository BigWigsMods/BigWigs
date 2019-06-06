if not IsTestBuild() then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Za'qul, Herald of Ny'alotha", 2164, 2349)
if not mod then return end
mod:RegisterEnableMob(150859) -- Za'qul
mod.engageId = 2293
--mod.respawnTime = 31


--------------------------------------------------------------------------------
-- Localization
--

-- local L = mod:GetLocale()
-- if L then
-- end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- General
		298192, -- Dark Beyond
		292971, -- Hysteria
		{295444, "TANK"}, -- Mind Tether
		292565, -- Crushing Grasp
		292963, -- Dread
		{293509, "SAY", "SAY_COUNTDOWN"}, -- Manifest Nightmares
		292996, -- Maddening Eruption
		295099, -- Punctured Darkness
		303971, -- Dark Pulse
		296018, -- Manic Dread
	},{
		[298192] = "general",
		[295444] = CL.stage:format(1),
		[293509] = CL.stage:format(2),
		[303971] = CL.stage:format(4),
	}
end

function mod:OnBossEnable()
	-- General
	self:Log("SPELL_AURA_APPLIED", "HysteriaApplied", 292971)
	self:Log("SPELL_AURA_APPLIED_DOSE", "HysteriaApplied", 292971)

	-- Stage 1
	self:Log("SPELL_CAST_SUCCESS", "MindTether", 292971)
	self:Log("SPELL_AURA_APPLIED", "MindTetherApplied", 295495, 295480) -- Main Target, Secondary Target
	self:Log("SPELL_CAST_START", "CrushingGrasp", 292565)
	self:Log("SPELL_AURA_APPLIED", "DreadApplied", 292963, 296018) -- Dread, Manic Dread

	-- Stage 2
	self:Log("SPELL_AURA_APPLIED", "ManifestNightmaresApplied", 293509)
	self:Log("SPELL_AURA_REMOVED", "ManifestNightmaresRemoved", 293509)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE") -- Maddening Eruption
	self:Log("SPELL_AURA_APPLIED", "PuncturedDarkness", 295099)

	-- Stage 4
	self:Log("SPELL_CAST_START", "DarkPulse", 303971)


	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 298192) -- Dark Beyond
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 298192)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 298192)
end

function mod:OnEngage()
	self:CDBar(292971, 5.5) -- Mind Tether
	self:CDBar(292565, 31.5) -- Crushing Grasp
	self:CDBar(292963, 14.2) -- Dread
end

--------------------------------------------------------------------------------
-- Event Handlers
--

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
		self:PersonalMessage(292971, CL.link:format(args.sourceName))
		self:PlaySound(292971, "alert")
	end
end

function mod:CrushingGrasp(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "warning")
	self:CDBar(args.spellId, 30)
	self:CastBar(args.spellId, 8)
end

do
	local playerList = mod:NewTargetList()
	function mod:DreadApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alert")
		end
		if #playerList == 1 then
			self:CDBar(args.spellId, 75)
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end
end

-- Stage 2
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
		self:CDBar(292996, 30)
		self:CDBar(295099, 25) -- Punctured Darkness
	end
end

function mod:PuncturedDarkness(args)
	self:TargetMessage2(args.spellId, "green", args.destName)
	self:PlaySound(args.spellId, "long", args.destName)
	self:TargetBar(args.spellId, 20, args.destName)
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
