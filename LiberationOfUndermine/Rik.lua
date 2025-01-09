if not BigWigsLoader.isTestBuild then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Rik Reverb", 2769, 2641)
if not mod then return end
mod:RegisterEnableMob(228652) -- Rik Reverb XXX Confirm on ptr
mod:SetEncounterID(3011)
mod:SetPrivateAuraSounds({
	469380, -- Sound Cannon
})
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

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
		-- Stage One: Party Starter
		473748, -- Amplification!
			1217122, -- Lingering Voltage
			468119, -- Resonant Echoes
				472298, -- Entranced!
			-- 465795, -- Noise Pollution
			466093, -- Haywire -- XXX Check if this warning is needed
		466866, -- Echoing Chant
		467606, -- Sound Cannon
		{467044, "SAY"}, -- Faulty Zap
		472293, -- Sparkblast Ignition
			1214164, -- Excitement
		-- 464488, -- Sonic Blast
			464518, -- Tinnitus
		-- Stage Two: Hype Hustle
		{464584, "CASTBAR"}, -- Hype Hustle!
		-- 466722, -- Blowout! -- Can we detect when you got hit and are immune?
		-- 1213817, -- Sound Cloud
		467991, -- Blaring Drop
		473655, -- Hype Fever!
	},{ -- Sections

	},{ -- Renames

	}
end

function mod:OnRegister()
	--self:SetSpellRename(999999, CL.renameMe) -- Spell (Rename)
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Amplification", 473748)
	self:Log("SPELL_AURA_APPLIED", "LingeringVoltageApplied", 1217122)
	self:Log("SPELL_AURA_APPLIED_DOSE", "LingeringVoltageApplied", 1217122)
	self:Log("SPELL_AURA_APPLIED", "ResonantEchoesApplied", 468119)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ResonantEchoesApplied", 468119)
	self:Log("SPELL_AURA_APPLIED", "EntrancedApplied", 472298)
	self:Log("SPELL_AURA_APPLIED", "HaywireApplied", 466093)
	self:Log("SPELL_CAST_START", "EchoingChant", 466866)
	self:Log("SPELL_CAST_START", "SoundCannon", 467606)
	-- self:Log("SPELL_CAST_SUCCESS", "FaultyZap", 466961) -- XXX Success cast?
	self:Log("SPELL_AURA_APPLIED", "FaultyZapApplied", 467044) -- 467108 pre debuff?
	self:Log("SPELL_CAST_START", "SparkblastIgnition", 472293)
	self:Log("SPELL_AURA_APPLIED", "ExcitementApplied", 1214164)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ExcitementApplied", 1214164)
	self:Log("SPELL_AURA_APPLIED", "TinnitusApplied", 464518)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TinnitusApplied", 464518)

	-- Stage Two: Hype Hustle
	self:Log("SPELL_CAST_START", "HypeHustle", 464584)
	self:Log("SPELL_AURA_REMOVED", "HypeHustleRemoved", 464584)
	self:Log("SPELL_AURA_APPLIED", "BlaringDropApplied", 467991)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlaringDropApplied", 467991)
	self:Log("SPELL_CAST_START", "HypeFever", 473655)
end

function mod:OnEngage()
	self:SetStage(1)
	-- self:Bar(473748, 5) -- Amplification!
	-- self:Bar(466866, 20) -- Echoing Chant
	-- self:Bar(464488, 30) -- Sound Cannon
	-- self:Bar(467044, 40) -- Faulty Zap
	-- self:Bar(472293, 50) -- Sparkblast Ignition
	-- self:Bar(464584, 120) -- Hype Hustle!
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage One: Party Starter

function mod:Amplification(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert") -- spawning amplifier
	-- self:Bar(args.spellId, 30)
end

function mod:LingeringVoltageApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		local tooHigh = 10
		if amount % 2 == 1 or amount > tooHigh then
			self:StackMessage(args.spellId, "cyan", args.destName, amount, tooHigh)
			if amount > tooHigh then -- XXX Check what is high enough
				self:PlaySound(args.spellId, "alarm") -- watch stacks
			end
		end
	end
end

function mod:ResonantEchoesApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "cyan", args.destName, args.amount, 1)
		if self:Easy() then -- Warning sound in heroic+ from Entranced!
			self:PlaySound(args.spellId, "alarm") -- watch stacks
		end
	end
end

function mod:EntrancedApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning") -- lured in
	end
end

do
	local prev = 0
	function mod:HaywireApplied(args)
		if args.time - prev > 2 then -- Throttle incase of multiple going haywire at the same time
			prev = args.time
			self:Message(args.spellId, "red")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:EchoingChant(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert") -- watch amplifiers
	-- self:Bar(args.spellId, 30)
end

function mod:SoundCannon(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alert") -- watch facing/private aura
	-- self:Bar(args.spellId, 30)
end

do
	local prev = 0
	function mod:FaultyZapApplied(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Message(args.spellId, "yellow")
			-- self:Bar(args.spellId, 30)
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "alarm")
			self:Say(args.spellId, nil, nil, "Faulty Zap")
		end
	end
end

do
	local prev = 0
	function mod:SparkblastIgnition(args)
		if args.time - prev > 10 then -- Will multiple spawn at the same time?
			prev = args.time
			self:Message(args.spellId, "orange")
			self:PlaySound(args.spellId, "long") -- kill pyrotechnics?
		end
	end
end

function mod:ExcitementApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 2 == 1 then
			self:StackMessage(args.spellId, "cyan", args.destName, amount, 0)
			self:PlaySound(args.spellId, "info") -- buffs!
		end
	end
end

function mod:TinnitusApplied(args)
	if self:Tank() and self:Tank(args.destName) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "purple", args.destName, amount, 0)
		if amount > 5 and amount % 2 == 0 then -- 6, 8...
			self:PlaySound(args.spellId, "warning") -- swap?
		end
	elseif self:Me(args.destGUID) then -- Not a tank
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 0)
		self:PlaySound(args.spellId, "warning")
	end
end

-- Stage Two: Hype Hustle

function mod:HypeHustle(args)
	self:StopBar(473748) -- Amplification!
	self:StopBar(466866) -- Echoing Chant
	self:StopBar(464488) -- Sound Cannon
	self:StopBar(467044) -- Faulty Zap
	self:StopBar(472293) -- Sparkblast Ignition
	self:StopBar(464584) -- Hype Hustle!
	self:StopBar(473655) -- Hype Fever!

	self:SetStage(2)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long") -- stage 2
	self:CastBar(args.spellId, 33) -- 5s cast, 28s duration
end

function mod:HypeHustleRemoved(args)
	self:SetStage(1)
	self:Message(args.spellId, "cyan", CL.over:format(args.spellName))
	self:PlaySound(args.spellId, "long") -- stage 1

	-- self:Bar(473748, 5) -- Amplification!
	-- self:Bar(466866, 20) -- Echoing Chant
	-- self:Bar(464488, 30) -- Sound Cannon
	-- self:Bar(467044, 40) -- Faulty Zap
	-- self:Bar(472293, 50) -- Sparkblast Ignition
	-- self:Bar(464584, 120) -- Hype Hustle! -- XXX 3rd time bar to Hype Fever
end

function mod:BlaringDropApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
		self:PlaySound(args.spellId, "warning") -- failed to avoid
	end
end

function mod:HypeFever(args)
	self:StopBar(473748) -- Amplification!
	self:StopBar(466866) -- Echoing Chant
	self:StopBar(464488) -- Sound Cannon
	self:StopBar(467044) -- Faulty Zap
	self:StopBar(472293) -- Sparkblast Ignition
	self:StopBar(464584) -- Hype Hustle!
	self:StopBar(473655) -- Hype Fever!

	self:SetStage(2)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long") -- stage 2
	-- self:CastBar(args.spellId, 33) -- is there a soft end?
end
