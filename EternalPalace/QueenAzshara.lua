--------------------------------------------------------------------------------
-- Todo:
-- Adds in stage 2
-- Improve stage 3
-- All of Stage 4
-- Would we need Proximity for some spells? Static Shock/Lone Decree?

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Queen Azshara", 2164, 2361)
if not mod then return end
mod:RegisterEnableMob(152910, 153059, 153060) -- Queen Azshara, Aethanel, Cyranus
mod.engageId = 2299
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Local
--

local stage = 1
local portalCount = 1
local hulkCollection = {}
local drainedSoulList = {}

--------------------------------------------------------------------------------
-- Localization
--

--------------------------------------------------------------------------------
-- Initialization
--

local arcaneBurstMarker = mod:AddMarkerOption(false, "player", 1, 303657, 1, 2, 3) -- Arcane Burst
function mod:GetOptions()
	return {
		"stages",
		300074, -- Pressure Surge
		298569, -- Drained Soul
		297937, -- Painful Memories
		297934, -- Longing
		297912, -- Torment
		297907, -- Cursed Heart
		298121, -- Lightning Orbs
		297972, -- Chain Lightning
		{298014, "TANK_HEALER"}, -- Cold Blast
		{298021, "TANK_HEALER"}, -- Ice Shard
		{298756, "ME_ONLY"}, -- Serrated Edge
		{301078, "SAY", "SAY_COUNTDOWN", "FLASH"}, -- Charged Spear
		-20480, -- Overzealous Hulk
		298531, -- Ground Pound
		300428, -- Infuriated
		298787, -- Arcane Orbs
		{299094, "SAY", "FLASH", "PULSE"}, -- Beckon
		299250, -- Queen's Decree
		302999, -- Arcane Vulnerability
		{304475, "TANK"}, -- Arcane Jolt
		300519, -- Arcane Detonation
		297371, -- Reversal of Fortune
		{303657, "SAY", "SAY_COUNTDOWN"}, -- Arcane Burst
		arcaneBurstMarker,
		{300492, "SAY", "FLASH"}, -- Static Shock
		300620, -- Crystalline Shield
		297372, -- Greater Reversal of Fortune
		300768, -- Piercing Gaze
		{300743, "TANK"}, -- Void Touched
		303982, -- Nether Portal
		301431, -- Overload
	},{
		["stages"] = "general",
		[297937] = -20250, -- Stage One: Cursed Lovers
		[298121] = -20261, -- Aethanel
		[298756] = -20266, -- Cyranus
		[-20480] = CL.adds, -- Cyranus
		[298787] = -20450, -- Queen Azshara
		[299250] = CL.intermission, -- Intermission One: Queen's Decree
		[302999] = -20323, -- Stage Two: Hearts Unleashed
		[300492] = -20340, -- Stage Three: Song of the Tides
		[300768] = -20361, -- Stage Four: My Palace Is a Prison
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("RAID_BOSS_WHISPER")
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3", "boss4", "boss5")
	self:Log("SPELL_DAMAGE", "PressureSurge", 300074)
	self:Log("SPELL_AURA_APPLIED", "DrainedSoulApplied", 298569)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DrainedSoulApplied", 298569)
	self:Log("SPELL_AURA_REMOVED", "DrainedSoulRemoved", 298569)

	-- Stage 1
	self:Log("SPELL_CAST_START", "PainfulMemories", 297937)
	self:Log("SPELL_CAST_START", "Longing", 297934)
	self:Log("SPELL_AURA_APPLIED", "Torment", 297912)

	-- Aethane
	self:Log("SPELL_CAST_START", "LightningOrbs", 298121)
	self:Log("SPELL_CAST_START", "ChainLightning", 297972)
	self:Log("SPELL_CAST_START", "ColdBlast", 298014)
	self:Log("SPELL_AURA_APPLIED", "ColdBlastApplied", 298014)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ColdBlastApplied", 298014)
	self:Log("SPELL_CAST_START", "IceShard", 298021)

	-- Cyranus
	self:Log("SPELL_AURA_APPLIED", "SerratedEdgeApplied", 298756)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SerratedEdgeApplied", 298756)
	self:Log("SPELL_CAST_SUCCESS", "ChargedSpear", 301078)
	self:Log("SPELL_AURA_APPLIED", "ChargedSpearApplied", 301078)

	-- Overzealous Hulk
	self:Log("SPELL_CAST_SUCCESS", "GroundPound", 298531)
	self:Log("SPELL_AURA_APPLIED", "Infuriated", 300428)

	-- Queen Azshara
	self:Log("SPELL_CAST_SUCCESS", "ArcaneOrbs", 298787)
	self:Log("SPELL_CAST_SUCCESS", "Beckon", 299094, 302141, 303797) -- Stage 1, Stage 2, Stage 3
	--self:Log("SPELL_AURA_APPLIED", "BeckonApplied", 299094, 302141, 303797)

	-- Intermission
	self:Log("SPELL_CAST_START", "QueensDecree", 299250)
	self:Log("SPELL_AURA_APPLIED", "PersonalDecrees", 299249, 299251, 299254, 299255, 299252, 299253) -- Suffer!, Obey!, Stand Together!, Stand Alone!, March!, Stay!

	-- Stage 2
	self:Log("SPELL_AURA_APPLIED", "ArcaneMasteryApplied", 300502)
	self:Log("SPELL_AURA_APPLIED", "ArcaneVulnerabilityApplied", 302999)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ArcaneVulnerabilityApplied", 302999)
	self:Log("SPELL_CAST_SUCCESS", "ArcaneJolt", 304475)

	self:Log("SPELL_CAST_START", "ArcaneDetonation", 300519)
	self:Log("SPELL_AURA_APPLIED", "ArcaneBurstApplied", 303657)
	self:Log("SPELL_AURA_REMOVED", "ArcaneBurstRemoved", 303657)

	-- Stage 3
	self:Log("SPELL_CAST_START", "GreaterReversalofFortune", 297372)
	self:Log("SPELL_AURA_APPLIED", "StaticShock", 300492)
	self:Log("SPELL_AURA_APPLIED", "CrystallineShield", 300620)

	-- Stage 4
	self:Log("SPELL_CAST_SUCCESS", "PiercingGaze", 300768)
	self:Log("SPELL_CAST_SUCCESS", "VoidTouchedSuccess", 300743)
	self:Log("SPELL_AURA_APPLIED", "VoidTouchedApplied", 300743)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VoidTouchedApplied", 300743)
	self:Log("SPELL_CAST_START", "Overload", 301431)

	-- Ground Effects
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 297907) -- Cursed Heart
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 297907)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 297907)
end

function mod:OnEngage()
	stage = 1
	portalCount = 1
	hulkCollection = {}
	drainedSoulList = {}
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")

	self:CDBar(297937, 14.2) -- Painful Memories
	self:CDBar(298121, 18.5) -- Lightning Orbs
	self:Bar(299094, 49.5) -- Beckon
	self:Bar(298787, 65) -- Arcane Orbs
	self:CDBar(-20480, 35, nil, "achievement_boss_nagabruteboss") -- Overzealous Hulk
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	local unit, guid = self:GetBossId(153064) -- Overzealous Hulk
	if unit and not hulkCollection[guid] then
		hulkCollection[guid] = true
		self:Message2(-20480, "cyan", self:SpellName(-20480), "achievement_boss_nagabruteboss")
		self:PlaySound(-20480, "long")
		self:CDBar(-20480, self:Easy() and 84 or 59, nil, "achievement_boss_nagabruteboss") -- Overzealous Hulk
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 297371 then -- Reversal of Fortune
		self:PlaySound(spellId, "long")
		self:Message2(spellId, "cyan")
		self:CDBar(spellId, 80)
	elseif spellId == 297372 then -- Greater Reversal of Fortune
		self:PlaySound(spellId, "long")
		self:Message2(spellId, "cyan")
		self:CDBar(spellId, 70)
	elseif spellId == 303629 then -- Arcane Burst
		self:CDBar(303657, 70)
	elseif spellId == 302034 then -- Adjure // 2nd Intermission Start / Stage 3
		stage = 3
		self:PlaySound("stages", "long")
		self:Message2("stages", "green", CL.intermission, false)
		self:StopBar(304475) -- Arcane Jolt
		self:StopBar(299094) -- Beckon
		self:StopBar(303657) -- Arcane Burst
		self:StopBar(297371) -- Reversal of Fortune
		self:StopBar(300519) -- Arcane Detonation

		-- XXX See if there is a real 'stage 3 start' event, this would belong there instead
		self:Bar(304475, 36) -- Arcane Jolt
		self:Bar(299094, 48.5) -- Beckon
		self:Bar(300519, 59.5) -- Arcane Detonation
		self:Bar(303657, 90) -- Arcane Burst
		self:Bar(297372, 80) -- Greater Reversal of Fortune
	elseif spellId == 302860 then -- Queen Azshara (Stage 4)
		stage = 4
		self:PlaySound("stages", "long")
		self:Message2("stages", "cyan", CL.stage:format(stage), false)
		self:StopBar(304475) -- Arcane Jolt
		self:StopBar(299094) -- Beckon
		self:StopBar(303657) -- Arcane Burst
		self:StopBar(297372) -- Greater Reversal of Fortune
		self:StopBar(300519) -- Arcane Detonation
		portalCount = 1

		self:Bar(300743, 12) -- Void Touched
		self:Bar(301431, 17) -- Overload
		self:Bar(303982, 24) -- Nether Portal
		self:Bar(300768, 44) -- Pirecing Gaze
		self:Bar(299094, 68.5) -- Beckon
	elseif spellId == 303982 then -- Nether Portal
		self:Message2(303982, "yellow")
		self:PlaySound(303982, "alert")
		portalCount = portalCount + 1
		self:Bar(303982, portalCount == 2 and 40 or portalCount == 3 and 44 or 35) -- XXX Make a Table for more data
	end
end

-- General
do
	local prev = 0
	function mod:PressureSurge(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message2(args.spellId, "orange")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:DrainedSoulApplied(args)
	drainedSoulList[args.destName] = args.amount or 1
	self:SetInfoByTable(args.spellId, drainedSoulList)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 2 == 0 or amount >= 7 then
			self:StackMessage(args.spellId, args.destName, amount, "blue")
			self:PlaySound(args.spellId, amount > 7 and "warning" or "alarm", nil, args.destName)
		end
	end
end

function mod:DrainedSoulRemoved(args)
	drainedSoulList[args.destName] = nil
	self:SetInfoByTable(args.spellId, drainedSoulList)
end

-- Stage 1
do
	local prev = 0
	function mod:PainfulMemories(args)
		local t = GetTime()
		if t-prev > 1.5 then
			prev = t
			self:Message2(args.spellId, "orange")
			self:PlaySound(args.spellId, "long")
			self:CDBar(297934, 65) -- Longing
		end
	end

	function mod:Longing(args)
		local t = GetTime()
		if t-prev > 1.5 then
			prev = t
			self:Message2(args.spellId, "orange")
			self:PlaySound(args.spellId, "long")
			self:CDBar(297937, 20) -- Painful Memories
		end
	end
end

do
	local prev = 0
	function mod:Torment(args)
		local t = GetTime()
		if t-prev > 1.5 then
			prev = t
			self:Message2(args.spellId, "red")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

-- Aethane
function mod:LightningOrbs(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	self:CDBar(args.spellId, 18.5)
end

function mod:ChainLightning(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message2(args.spellId, "orange")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:ColdBlast(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 11)
end

function mod:ColdBlastApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	if amount == 3 then
		self:PlaySound(args.spellId, "warning", nil, args.destName)
	end
end

function mod:IceShard(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "warning")
end

-- Cyranus
function mod:SerratedEdgeApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	self:PlaySound(args.spellId, "alert", nil, args.destName)
end

function mod:ChargedSpear(args)
	self:CDBar(args.spellId, stage == 3 and 13.5 or 40)
end

function mod:ChargedSpearApplied(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName)
	self:PlaySound(args.spellId, "alert", nil, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 5)
	end
end

-- Overzealous Hulk
function mod:GroundPound(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end

function mod:Infuriated(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

-- Queen Azshara
function mod:ArcaneOrbs(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:Beckon(args)
	self:Message2(299094, "yellow")
	self:CDBar(299094, stage > 2 and 70 or 85) -- XXX Stage 4 unkown timer
end

function mod:RAID_BOSS_WHISPER(_, msg)
	if msg:find("299094", nil, true) then -- Beckon
		self:PersonalMessage(299094)
		self:PlaySound(299094, "Alarm")
		self:Flash(299094)
		self:Say(299094)
	end
end

-- Intermission
function mod:QueensDecree(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
	self:StopBar(297937) -- Painful Memories
	self:StopBar(297934) -- Longing
	self:StopBar(298121) -- Lightning Orbs
	self:StopBar(299094) -- Beckon
	self:StopBar(298787) -- Arcane Orbs
	self:StopBar(-20480) -- Overzealous Hulk
	self:StopBar(301078) -- Charged Spear
	self:CDBar("stages", 36.2, CL.intermission, 299250) -- Queens Decree
end

do
	local debuffs = {}
	local comma = (GetLocale() == "zhTW" or GetLocale() == "zhCN") and "，" or ", "
	local tconcat =  table.concat
	local function announce()
		local msg = tconcat(debuffs, comma, 1, #debuffs)
		mod:PersonalMessage(299250, nil, msg)
		mod:PlaySound(299250, "alarm")
		debuffs = {}
	end

	function mod:PersonalDecrees(args)
		if self:Me(args.destGUID) then
			debuffs[#debuffs+1] = args.spellName
			if #debuffs == 1 then
				self:SimpleTimer(announce, 0.1)
			end
		end
	end
end

-- Stage 2
function mod:ArcaneMasteryApplied(args)
	stage = 2
	self:PlaySound("stages", "long")
	self:Message2("stages", "cyan", CL.stage:format(stage), false)

	self:Bar(304475, 5) -- Arcane Jolt
	self:Bar(299094, 13) -- Beckon
	self:Bar(303657, 40) -- Arcane Burst
	self:Bar(297371, 56) -- Reversal of Fortune
	self:Bar(300519, 68) -- Arcane Detonation
end

function mod:ArcaneVulnerabilityApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 5 == 0 then
			self:StackMessage(args.spellId, args.destName, amount, "blue")
			if amount > 19 then
				self:PlaySound(args.spellId, "alarm")
			end
		end
	end
end

function mod:ArcaneJolt(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	self:CDBar(args.spellId, 6.1)
end

function mod:ArcaneDetonation(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	self:CDBar(args.spellId, 75)
	self:CastBar(args.spellId, self:Mythic() and 4 or self:Heroic() and 5 or 6) -- Mythic 4s, Heroic 5s, Normal/LFR 6s
end

do
	local playerList = mod:NewTargetList()
	function mod:ArcaneBurstApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 30)
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)
		if self:GetOption(arcaneBurstMarker) then
			SetRaidTarget(args.destName, #playerList)
		end
	end

	function mod:ArcaneBurstRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		if self:GetOption(arcaneBurstMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

-- Stage 3
function mod:StaticShock(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alert", nil, args.destName)
		self:Flash(args.spellId)
		self:Say(args.spellId)
	end
end

function mod:CrystallineShield(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName)
	self:PlaySound(args.spellId, "long", nil, args.destName)
end

function mod:GreaterReversalofFortune(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
end

-- Stage 4
function mod:PiercingGaze(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "long")
	self:Bar(args.spellId, 45)
end

function mod:VoidTouchedSuccess(args)
	self:CDBar(args.spellId, 7.5)
end

function mod:VoidTouchedApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	self:PlaySound(args.spellId, amount > 2 and "warning" or "alert", nil, args.destName)
end

function mod:Overload(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	self:CDBar(args.spellId, 45)
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
