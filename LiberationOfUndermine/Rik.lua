if not BigWigsLoader.isTestBuild then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Rik Reverb", 2769, 2641)
if not mod then return end
mod:RegisterEnableMob(228648) -- Rik Reverb
mod:SetEncounterID(3011)
mod:SetPrivateAuraSounds({
	469380, -- Sound Cannon
})
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local amplificationCount = 1
local echoingChantCount = 1
local soundCannonCount = 1
local faultyZapCount = 1
local sparkblastIgnitionCount = 1
local blaringDropCount = 1

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
		"stages",
		-- Stage One: Party Starter
		473748, -- Amplification!
			1217122, -- Lingering Voltage
			468119, -- Resonant Echoes
				1214598, -- Entranced!
			-- 465795, -- Noise Pollution
			466093, -- Haywire -- XXX Check if this warning is needed
		466866, -- Echoing Chant
		{467606, "SAY"}, -- Sound Cannon
		466979, -- Faulty Zap
		472306, -- Sparkblast Ignition
			1214164, -- Excitement
		464518, -- Tinnitus
		-- Stage Two: Hype Hustle
		{473260, "CASTBAR"}, -- Blaring Drop
	},{ -- Sections

	},{ -- Renames

	}
end

function mod:OnRegister()
	--self:SetSpellRename(999999, CL.renameMe) -- Spell (Rename)
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Log("SPELL_CAST_START", "Amplification", 473748)
	self:Log("SPELL_AURA_APPLIED", "LingeringVoltageApplied", 1217122)
	self:Log("SPELL_AURA_APPLIED_DOSE", "LingeringVoltageApplied", 1217122)
	self:Log("SPELL_AURA_APPLIED", "ResonantEchoesApplied", 468119)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ResonantEchoesApplied", 468119)
	self:Log("SPELL_AURA_APPLIED", "EntrancedApplied", 1214598)
	self:Log("SPELL_AURA_APPLIED", "HaywireApplied", 466093)
	self:Log("SPELL_CAST_START", "EchoingChant", 466866)
	self:Log("SPELL_CAST_START", "SoundCannon", 467606)
	self:Log("SPELL_CAST_START", "FaultyZap", 466979)
	self:Log("SPELL_AURA_APPLIED", "FaultyZapApplied", 467108) -- pre debuffs
	-- self:Log("SPELL_CAST_START", "SparkblastIgnition", 472306) -- USCS
	self:Log("SPELL_AURA_APPLIED", "ExcitementApplied", 1214164)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ExcitementApplied", 1214164)
	self:Log("SPELL_AURA_APPLIED", "TinnitusApplied", 464518)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TinnitusApplied", 464518)

	-- Stage Two: Hype Hustle
	self:Log("SPELL_AURA_APPLIED", "SoundCloudApplied", 1213817)
	self:Log("SPELL_AURA_REMOVED", "SoundCloudRemoved", 1213817)
	self:Log("SPELL_CAST_START", "BlaringDropStart", 473260)
	self:Log("SPELL_AURA_APPLIED", "BlaringDropApplied", 467991)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlaringDropApplied", 467991)
end

function mod:OnEngage()
	self:SetStage(1)
	amplificationCount = 1
	echoingChantCount = 1
	soundCannonCount = 1
	faultyZapCount = 1
	sparkblastIgnitionCount = 1
	blaringDropCount = 1

	self:Bar(473748, 10.5, CL.count:format(self:SpellName(473748), amplificationCount)) -- Amplification!
	self:Bar(472306, 15, CL.count:format(self:SpellName(472306), sparkblastIgnitionCount)) -- Sparkblast Ignition
	self:Bar(466866, 21.5, CL.count:format(self:SpellName(466866), echoingChantCount)) -- Echoing Chant
	self:Bar(467606, 27.5, CL.count:format(self:SpellName(467606), soundCannonCount)) -- Sound Cannon
	self:Bar(466979, 39.5, CL.count:format(self:SpellName(466979), faultyZapCount)) -- Faulty Zap
	self:Bar("stages", 121, CL.stage:format(2), 66911) -- disco ball icon // until _applied
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 472306 then -- Sparkblast Ignition
		self:Message(spellId, "yellow", CL.count:format(self:SpellName(spellId), sparkblastIgnitionCount))
		self:PlaySound(spellId, "alert")
		sparkblastIgnitionCount = sparkblastIgnitionCount + 1
		local cdTable = {44.6, 64.9, 43.5}
		local cdCount = sparkblastIgnitionCount % 3 + 1
		local cd = cdTable[cdCount]
		if self:Mythic() then
			cd = sparkblastIgnitionCount % 2 == 0 and 82.5 or 66.5
		end
		self:Bar(spellId, cd, CL.count:format(self:SpellName(spellId), sparkblastIgnitionCount))
	end
end


-- Stage One: Party Starter

function mod:Amplification(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, amplificationCount))
	self:PlaySound(args.spellId, "alert") -- spawning amplifier
	amplificationCount = amplificationCount + 1
	local cd = amplificationCount % 3 == 1 and 73.0 or 40.2
	if self:Mythic() then
		cd = amplificationCount % 3 == 1 and 69.5 or 40.1
	end
	self:Bar(args.spellId, cd, CL.count:format(args.spellName, amplificationCount))
end

function mod:LingeringVoltageApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		local tooHigh = 10 -- XXX Check what is high enough
		if amount % 2 == 1 or amount > tooHigh then
			self:StackMessage(args.spellId, "cyan", args.destName, amount, tooHigh)
			if amount > tooHigh then
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
			-- self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:EchoingChant(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, echoingChantCount))
	self:PlaySound(args.spellId, "alert") -- watch amplifiers
	echoingChantCount = echoingChantCount + 1
	local cdTable = {28.5, 66.5, 58.0}
	if self:Mythic() then
		cdTable = {53.5, 63.0, 32.5}
	end
	local cdCount = echoingChantCount % 3 + 1
	self:Bar(args.spellId, cdTable[cdCount], CL.count:format(args.spellName, echoingChantCount))
end

do
	local function printTarget(self, player, guid)
		if self:Me(guid) then
			self:PersonalMessage(467606)
			self:PlaySound(467606, "warning")
			local englishText = "Sound Cannon"
			if self:Mythic() then -- soak
				self:Yell(467606, nil, nil, englishText)
			else -- avoid
				self:Say(467606, nil, nil, englishText)
			end
		end
	end

	function mod:SoundCannon(args)
		self:Message(args.spellId, "red", CL.count:format(args.spellName, soundCannonCount))
		self:PlaySound(args.spellId, "alert") -- watch facing/private aura
		soundCannonCount = soundCannonCount + 1
		local cd = soundCannonCount % 2 == 1 and 34.5 or 118.5
		if self:Mythic() then
			cd = soundCannonCount % 2 == 1 and 37.2 or 111.8
		end
		self:Bar(args.spellId, cd, CL.count:format(args.spellName, soundCannonCount))
		self:GetBossTarget(printTarget, 1, args.sourceGUID) -- targets player
	end
end

function mod:FaultyZap(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, faultyZapCount))
	faultyZapCount = faultyZapCount + 1
	local cdTable = {26.0, 91.6, 35.5}
	if self:Mythic() then
		cdTable = {26.0, 88.5, 34.5}
	end
	local cdCount = faultyZapCount % 3 + 1
	self:Bar(args.spellId, cdTable[cdCount], CL.count:format(args.spellName, faultyZapCount))
end

function mod:FaultyZapApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(466979)
		self:PlaySound(466979, "alarm")
	end
end

-- do
-- 	local prev = 0
-- 	function mod:SparkblastIgnition(args)
-- 		if args.time - prev > 10 then -- Will multiple spawn at the same time?
-- 			prev = args.time
-- 			self:Message(args.spellId, "orange")
-- 			self:PlaySound(args.spellId, "long") -- kill pyrotechnics?
-- 		end
-- 	end
-- end

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
function mod:SoundCloudApplied(args)
	self:SetStage(2)
	self:Message("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "long") -- stage 2
	self:Bar("stages", self:Mythic() and 28 or 36, CL.stage:format(1), args.spellId)
	blaringDropCount = 1

	-- XXX Stop All bars, restart on Removed?
end

function mod:SoundCloudRemoved(args)
	self:SetStage(1)
	self:Message("stages", "cyan", CL.stage:format(1), false)
	self:PlaySound("stages", "long") -- stage 1
	self:Bar("stages", 121, CL.stage:format(2), 66911) -- disco ball icon
end

function mod:BlaringDropStart(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName, blaringDropCount))
	self:PlaySound(args.spellId, "warning") -- go amplifier
	self:CastBar(args.spellId, 5, CL.count_amount:format(args.spellName, blaringDropCount, 4))
	blaringDropCount = blaringDropCount + 1
end

function mod:BlaringDropApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(473260, "blue", args.destName, args.amount, 1)
		self:PlaySound(473260, "warning") -- failed to avoid
	end
end
