
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

local darkRevelationMarker = mod:AddMarkerOption(false, "player", 1, 273365, 1, 2) -- Dark Revelation
local deathwishMarker = mod:AddMarkerOption(false, "player", 3, 274271, 3, 4) -- Deathwish
function mod:GetOptions()
	return {
		{273365, "SAY", "SAY_COUNTDOWN"}, -- Dark Revelation
		darkRevelationMarker,
		{269936, "SAY"}, -- Fixate
		273360, -- Pool of Darkness
		273889, -- Call of Blood
		273288, -- Thrumming Pulse
		273451, -- Congeal Blood
		273350, -- Bloodshard
		276299, -- Engorged Burst
		274168, -- Locus of Corruption
		{274358, "TANK"}, -- Rupturing Blood
		274271, -- Deathwish
		deathwishMarker,
	}
end

function mod:OnBossEnable()
	-- Stage 1
	self:Log("SPELL_CAST_SUCCESS", "DarkRevelation", 273365)
	self:Log("SPELL_AURA_APPLIED", "DarkRevelationApplied", 273365)
	self:Log("SPELL_AURA_REMOVED", "DarkRevelationRemoved", 273365)
	self:Log("SPELL_AURA_APPLIED", "FixateApplied", 269936, 276020)
	self:Log("SPELL_CAST_START", "PoolofDarkness", 273360)
	self:Log("SPELL_CAST_START", "CallofBlood", 273889, 274098, 274119)
	self:Log("SPELL_CAST_START", "ThrummingPulse", 273288)
	self:Log("SPELL_CAST_SUCCESS", "CongealBlood", 273451)
	self:Log("SPELL_CAST_START", "Bloodshard", 273350)
	self:Log("SPELL_CAST_SUCCESS", "EngorgedBurst", 276299)

	-- Stage 2
	self:Log("SPELL_CAST_SUCCESS", "LocusofCorruption", 274168)
	self:Log("SPELL_AURA_APPLIED", "RupturingBloodApplied", 274358)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RupturingBloodApplied", 274358)
	self:Log("SPELL_AURA_APPLIED", "DeathwishApplied", 274271)
	self:Log("SPELL_AURA_REMOVED", "DeathwishRemoved", 274271)
end

function mod:OnEngage()
	self:Bar(273360, 21) -- Pool of Darkness
	self:Bar(273365, 30) -- Dark Revelation
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:DarkRevelation(args)
	self:Bar(args.spellId, 45)
end

do
	local playerList, isOnMe = {}, nil

	local function announce()
		local meOnly = mod:CheckOption(273365, "ME_ONLY")

		if isOnMe and (meOnly or #playerList == 1) then
			mod:Message(273365, "blue", nil, CL.you:format(("|T13700%d:0|t%s"):format(isOnMe, mod:SpellName(273365))))
		elseif not meOnly then
			local msg = ""
			for i=1, #playerList do
				local icon = ("|T13700%d:0|t"):format(i)
				msg = msg .. icon .. mod:ColorName(playerList[i]) .. (i == #playerList and "" or ",")
			end

			mod:Message(273365, "yellow", nil, CL.other:format(mod:SpellName(273365), msg))
		end

		playerList = {}
		isOnMe = nil
	end

	function mod:DarkRevelationApplied(args)
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:SimpleTimer(announce, 0.3)
			self:CastBar(args.spellId, 10) -- XXX Change to an 'Exploding Bar' incase more appropriate
		end
		if self:Me(args.destGUID) then
			isOnMe = #playerList
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 10)
		end
		if self:GetOption(darkRevelationMarker) then
			SetRaidTarget(args.destName, #playerList)
		end
	end
end

function mod:DarkRevelationRemoved(args)
	if self:GetOption(darkRevelationMarker) then
		SetRaidTarget(args.destName, 0)
	end
end

do
	local prev = 0
	function mod:FixateApplied(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 2 then
				prev = t
				self:TargetMessage2(269936, "blue", args.destName)
				self:PlaySound(269936, "warning")
				self:Say(269936)
			end
		end
	end
end

function mod:PoolofDarkness(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "info")
	self:Bar(args.spellId, 31.5)
end

function mod:CallofBlood(args) -- XXX Add types each wave/wave timers
	self:Message(273889, "cyan")
	self:PlaySound(273889, "long")
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
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	if self:Me(args.destGUID) or amount > 2 then
		self:PlaySound(args.spellId, "warning", args.destName)
	end
end

do
	local playerList, isOnMe = {}, nil

	local function announce()
		local meOnly = mod:CheckOption(274271, "ME_ONLY")

		if isOnMe and (meOnly or #playerList == 1) then
			mod:Message(274271, "blue", nil, CL.you:format(("|T13700%d:0|t%s"):format(isOnMe + 2, mod:SpellName(274271))))
		elseif not meOnly then
			local msg = ""
			for i=1, #playerList do
				local icon = ("|T13700%d:0|t"):format(i + 2)
				msg = msg .. icon .. mod:ColorName(playerList[i]) .. (i == #playerList and "" or ",")
			end

			mod:Message(274271, "orange", nil, CL.other:format(mod:SpellName(274271), msg))
		end

		playerList = {}
		isOnMe = nil
	end

	function mod:DeathwishApplied(args)
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:SimpleTimer(announce, 0.3)
		end
		if self:Me(args.destGUID) then
			isOnMe = #playerList
			self:PlaySound(args.spellId, "alarm")
		end
		if self:GetOption(deathwishMarker) then
			SetRaidTarget(args.destName, #playerList + 2)
		end
	end
end

function mod:DeathwishRemoved(args)
	if self:GetOption(deathwishMarker) then
		SetRaidTarget(args.destName, 0)
	end
end
