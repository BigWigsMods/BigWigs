if not C_ChatInfo then return end -- XXX Don't load outside of 8.0

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Zul", 1861, 2195)
if not mod then return end
mod:RegisterEnableMob(138967) -- XXX Needs checking
mod.engageId = 2145 -- XXX Needs checking
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		273365, -- Dark Revelation
		{269936, "SAY"}, -- Fixate
		273361, -- Pool of Darkness
		273889, -- Call of Blood
		273288, -- Thrumming Pulse
		273451, -- Congeal Blood
		273350, -- Bloodshard
		276299, -- Engorged Burst
		274168, -- Locus of Corruption
		{274358, "TANK"}, -- Rupturing Blood
		274271, -- Deathwish
	}
end

function mod:OnBossEnable()
	-- Stage 1
	self:Log("SPELL_AURA_APPLIED", "DarkRevelationApplied", 273365)
	self:Log("SPELL_AURA_APPLIED", "FixateApplied", 269936, 276020) -- XXX Might not need both
	self:Log("SPELL_CAST_START", "PoolofDarkness", 273361)
	self:Log("SPELL_CAST_START", "CallofBlood", 273889)
	self:Log("SPELL_CAST_START", "ThrummingPulse", 273288)
	self:Log("SPELL_CAST_SUCCESS", "CongealBlood", 273451)
	self:Log("SPELL_CAST_START", "Bloodshard", 273350)
	self:Log("SPELL_CAST_SUCCESS", "EngorgedBurst", 276299)

	-- Stage 2
	self:Log("SPELL_CAST_SUCCESS", "LocusofCorruption", 274168)
	self:Log("SPELL_AURA_APPLIED", "RupturingBloodApplied", 274358)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RupturingBloodApplied", 274358)
	self:Log("SPELL_AURA_APPLIED", "DeathwishApplied", 274271)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local playerList = mod:NewTargetList()
	function mod:DarkRevelationApplied(args)
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:CastBar(args.spellId, 10) -- XXX Change to an 'Exploding Bar' incase more appropriate
		end
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 5)
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end
end

function mod:FixateApplied(args)
	if self:Me(args.destGUID) then
		self:TargetMessage2(269936, "blue", args.destName)
		self:PlaySound(269936, "warning")
		self:Say(269936)
	end
end

function mod:PoolofDarkness(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "info")
end

function mod:CallofBlood(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
end

function mod:ThrummingPulse(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:CongealBlood(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end

function mod:Bloodshard(args)
	self:Message(args.spellId, "orange")
	if self:Interrupter() then
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:EngorgedBurst(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alarm")
end

function mod:LocusofCorruption(args)
	self:Message(args.spellId, "green")
	self:PlaySound(args.spellId, "long")
end

function mod:RupturingBloodApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, args.amount, "red")
	if self:Me(args.destGUID) or amount > 2 then
		self:PlaySound(args.spellId, "warning", args.destName)
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:DeathwishApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm")
		end
		self:TargetsMessage(args.spellId, "orange", playerList)
	end
end
