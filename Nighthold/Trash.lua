
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nighthold Trash", 1088)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	--[[ Skorpyron to Chronomatic Anomaly ]]--
	115914, -- Torm the Brute
	111081, -- Fulminant
	111072, -- Pulsauron

	--[[ Chronomatic Anomaly to Trilliax ]]--
	112255, -- Sludgerax

	--[[ Trilliax to Aluriel ]]--
	116008, -- Kar'zun
	112712, -- Gilded Guardian
	112671, -- Duskwatch Battle-Magus
	113307, -- Chronowraith
	112665, -- Nighthold Protector

	--[[ Aluriel to Etraeus ]]--
	112803, -- Astrologer Jarin

	--[[ Aluriel to Telarn ]]--
	112638, -- Astral Defender
	112973, -- Duskwatch Weaver
	112595, -- Shal'dorei Archmage
	111295, -- Domesticated Manasaber
	112678, -- Shal'dorei Naturalist

	--[[ Aluriel to Krosus ]]--
	111210, -- Searing Infernal

	--[[ Aluriel to Tichondrius ]]--
	113012, -- Felsworn Chaos-Mage
	113043 -- Abyss Watcher
)

--------------------------------------------------------------------------------
-- Locals
--

local list = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	--[[ Skorpyron to Trilliax ]]--
	L.torm = "Torm the Brute"
	L.fulminant = "Fulminant"
	L.pulsauron = "Pulsauron"

	--[[ Chronomatic Anomaly to Trilliax ]]--
	L.sludgerax = "Sludgerax"

	--[[ Trilliax to Aluriel ]]--
	L.karzun = "Kar'zun"
	L.guardian = "Gilded Guardian"
	L.battle_magus = "Duskwatch Battle-Magus"
	L.chronowraith = "Chronowraith"
	L.protector = "Nighthold Protector"

	--[[ Aluriel to Etraeus ]]--
	L.jarin = "Astrologer Jarin"

	--[[ Aluriel to Telarn ]]--
	L.defender = "Astral Defender"
	L.weaver = "Duskwatch Weaver"
	L.archmage = "Shal'dorei Archmage"
	L.manasaber = "Domesticated Manasaber"
	L.naturalist = "Shal'dorei Naturalist"

	--[[ Aluriel to Krosos ]]--
	L.infernal = "Searing Infernal"

	--[[ Aluriel to Tichondrius ]]--
	L.chaosmage = "Felsworn Chaos-Mage"
	L.watcher = "Abyss Watcher"

	L.fear = "{224944} ({5782})"
	L.fear_desc = 224944
	L.fear_icon = 224944
end

--------------------------------------------------------------------------------
-- Initialization
--

local wrapMarker = mod:AddMarkerOption(true, "npc", 8, 230994, 8, 7, 6) -- Shadow Wrap
function mod:GetOptions()
	return {
		--[[ Skorpyron to Chronomatic Anomaly ]]--
		230438, -- Devastating Strike (Torm)
		{231086, "SAY", "FLASH"}, -- Bolder Strike (Torm)
		230482, -- Rumbling Blow (Torm)
		230488, -- Rumbling Ground (Torm)
		221164, -- Fulminate (Fulminant)
		221160, -- Compress the Void (Pulsauron)

		--[[ Chronomatic Anomaly to Trilliax ]]--
		{223655, "SAY", "FLASH", "ICON"}, -- Oozing Rush (Sludgerax)

		--[[ Trilliax to Aluriel ]]--
		{230994, "SAY"}, -- Shadow Wrap (Kar'zun)
		wrapMarker,
		231005, -- Arcane Emanations (Kar'zun)
		225927, -- Gravity Well (Gilded Guardian)
		{224440, "FLASH"}, -- Crushing Stomp (Gilded Guardian)
		224510, -- Crackling Slice (Duskwatch Battle-Magus)
		225412, -- Mass Siphon (Chronowraith)
		224568, -- Mass Suppress (Nighthold Protector)
		224572, -- Disrupting Energy (Nighthold Protector)

		--[[ Aluriel to Etraeus ]]--
		{224632, "SAY", "FLASH"}, -- Heavenly Crash (Astrologer Jarin)

		--[[ Aluriel to Telarn ]]--
		225390, -- Stellar Dust (Astral Defender)
		{225845, "FLASH"}, -- Chosen Fate (Duskwatch Weaver)
		{225105, "FLASH", "SAY", "PROXIMITY"}, -- Arcanic Release (Shal'dorei Archmage)
		225800, -- Greater Time Warp (Shal'dorei Archmage)
		{225857, "TANK"}, -- Arcane Wound (Domesticated Manasaber)
		225856, -- Poison Brambles (Shal'dorei Naturalist)

		--[[ Aluriel to Krosos ]]--
		{221344, "SAY", "FLASH"}, -- Annihilating Orb (Searing Infernal)

		--[[ Aluriel to Tichondrius ]]--
		{"fear", "SAY", "FLASH"}, -- Will of the Legion (Felsworn Chaos-Mage)
		{224982, "SAY", "FLASH"}, -- Fel Glare (Abyss Watcher)
	}, {
		[230438] = L.torm,
		[221164] = L.fulminant,
		[221160] = L.pulsauron,
		[223655] = L.sludgerax,
		[230994] = L.karzun,
		[225927] = L.guardian,
		[224510] = L.battle_magus,
		[225412] = L.chronowraith,
		[224568] = L.protector,
		[224632] = L.jarin,
		[225390] = L.defender,
		[225845] = L.weaver,
		[225105] = L.archmage,
		[225857] = L.manasaber,
		[225856] = L.naturalist,
		[221344] = L.infernal,
		["fear"] = L.chaosmage,
		[224982] = L.watcher,
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterMessage("BigWigs_OnBossEngage", "Disable")

	-- Rumbling Ground, Disrupting Energy, Poison Brambles, Stellar Dust
	self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", 230488, 224572, 225856, 225390)
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffectDamage", 230488, 224572, 225856, 225390)
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffectDamage", 230488, 224572, 225856, 225390)

	--[[ Skorpyron to Chronomatic Anomaly ]]--
	self:Log("SPELL_CAST_START", "DevastatingStrike", 230438)
	self:Log("SPELL_CAST_START", "BolderStrike", 231086)
	self:Log("SPELL_CAST_START", "RumblingBlow", 230482)
	self:Death("TormDeath", 115914)
	self:Log("SPELL_CAST_START", "Fulminate", 221164)
	self:Log("SPELL_CAST_SUCCESS", "CompressTheVoid", 221160)

	--[[ Chronomatic Anomaly to Trilliax ]]--
	self:Log("SPELL_CAST_START", "OozingRushStart", 223655)
	self:Log("SPELL_AURA_APPLIED", "OozingRush", 223655)
	self:Log("SPELL_AURA_REMOVED", "OozingRushRemoved", 223655)

	--[[ Trilliax to Aluriel ]]--
	self:Log("SPELL_AURA_APPLIED", "ShadowWrap", 230994)
	self:Log("SPELL_SUMMON", "ShadowWrapSummon", 230993)
	self:Log("SPELL_CAST_START", "ArcaneEmanations", 231005)
	self:Log("SPELL_CAST_START", "GravityWell", 225927)
	self:Log("SPELL_CAST_START", "CrushingStomp", 224440)
	self:Death("GuardianDeath", 112712)
	self:Log("SPELL_CAST_START", "CracklingSlice", 224510)
	self:Log("SPELL_CAST_SUCCESS", "MassSiphon", 225412)
	self:Death("ChronowraithDeath", 113307)
	self:Log("SPELL_CAST_START", "MassSuppress", 224568)

	--[[ Aluriel to Etraeus ]]--
	self:Log("SPELL_AURA_APPLIED", "HeavenlyCrash", 224632)

	--[[ Aluriel to Telarn ]]--
	self:Log("SPELL_AURA_APPLIED", "ChosenFate", 225845)
	self:Log("SPELL_AURA_APPLIED", "ArcanicRelease", 225105)
	self:Log("SPELL_AURA_REMOVED", "ArcanicReleaseRemoved", 225105)
	self:Log("SPELL_CAST_SUCCESS", "GreaterTimeWarp", 225800)
	self:Log("SPELL_AURA_APPLIED", "ArcaneWound", 225857)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ArcaneWound", 225857)

	--[[ Aluriel to Krosos ]]--
	self:Log("SPELL_AURA_APPLIED", "AnnihilatingOrb", 221344)
	self:Log("SPELL_AURA_REMOVED", "AnnihilatingOrbRemoved", 221344)
	self:Death("InfernalDeath", 111210)

	--[[ Aluriel to Tichondrius ]]--
	self:Log("SPELL_AURA_APPLIED", "WillOfTheLegion", 224944)
	self:Log("SPELL_AURA_REMOVED", "WillOfTheLegionRemoved", 224944)
	self:Log("SPELL_AURA_APPLIED", "FelGlare", 224982)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ General ]]--
do
	local prev = 0
	function mod:GroundEffectDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

--[[ Skorpyron to Chronomatic Anomaly ]]--
function mod:DevastatingStrike(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:CDBar(args.spellId, 7.5)
end

do
	local function printTarget(self, player, guid)
		self:TargetMessage(231086, player, "Urgent", "Long", nil, nil, true)
		if self:Me(guid) then
			self:Say(231086)
			self:Flash(231086)
		end
	end
	function mod:BolderStrike(args)
		self:GetUnitTarget(printTarget, 0.3, args.sourceGUID)
	end
end

function mod:RumblingBlow(args)
	self:Message(args.spellId, "Attention", "Info")
end

function mod:TormDeath()
	self:StopBar(230438) -- Devastating Strike
end

do
	local prev, fulminateCount = 0, 0
	function mod:Fulminate(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Important", "Alarm")
		end
		local pad = strrep(" ", fulminateCount) -- hack so i can have two bars/messages for the same thing up
		self:Bar(args.spellId, 5, CL.cast:format(args.spellName)..pad)
		fulminateCount = 1 - fulminateCount
	end
end

do
	local prev = 0
	function mod:CompressTheVoid(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Urgent", t-prev > 2 and "Long")
			self:Bar(args.spellId, 15)
		end
	end
end

--[[ Chronomatic Anomaly to Trilliax ]]--
do
	local prev = nil
	local function printTarget(self, player, guid)
		prev = player
		self:TargetMessage(223655, player, "Important", "Warning")
		self:PrimaryIcon(223655, player)
		if self:Me(guid) then
			self:Say(223655)
			self:Flash(223655)
		end
	end
	function mod:OozingRushStart(args)
		self:GetUnitTarget(printTarget, 0.5, args.sourceGUID)
	end

	function mod:OozingRush(args)
		self:TargetBar(args.spellId, 10, args.destName)
		if prev ~= args.destName then
			printTarget(self, args.destName, args.destGUID)
		end
	end

	function mod:OozingRushRemoved(args)
		self:StopBar(args.spellId, args.destName)
		self:PrimaryIcon(args.spellId)
	end
end

--[[ Trilliax to Aluriel ]]--
do
	local wraps = {}
	local wrapCount = 8
	function mod:MarkShadowWrap(event, unit, guid)
		if wraps[guid] then
			SetRaidTarget(unit, wraps[guid])
			wraps[guid] = nil
		end
	end
	function mod:ShadowWrapSummon(args)
		if self:GetOption(wrapMarker) then
			wraps[args.destGUID] = wrapCount
			wrapCount = wrapCount - 1
		end
	end
	function mod:ShadowWrap(args)
		list[#list+1] = args.destName
		if #list == 1 then
			if self:GetOption(wrapMarker) then
				wipe(wraps)
				wrapCount = 8
				self:RegisterTargetEvents("MarkShadowWrap")
				self:ScheduleTimer("UnregisterTargetEvents", 10)
			end
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Attention", "Warning", nil, nil, true)
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
	end
end

function mod:ArcaneEmanations(args)
	self:Message(args.spellId, "Important", "Long", CL.casting:format(args.spellName))
end

function mod:GravityWell(args)
	self:Message(args.spellId, "Attention", "Info")
	self:CDBar(args.spellId, 23)
end

function mod:CrushingStomp(args)
	self:Message(args.spellId, "Urgent", "Warning")
	self:CDBar(args.spellId, 23)
	self:Flash(args.spellId)
end

function mod:GuardianDeath()
	self:StopBar(225927) -- Gravity Well
	self:StopBar(224440) -- Crushing Stomp
end

do
	local prev = 0
	function mod:CracklingSlice(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Attention", "Long")
		end
	end
end

function mod:MassSiphon(args)
	self:Message(args.spellId, "Urgent", self:Interrupter(args.sourceGUID) and "Info", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 15)
end

function mod:ChronowraithDeath()
	self:StopBar(225412) -- Mass Siphon
end

function mod:MassSuppress(args)
	self:Message(args.spellId, "Attention", self:Interrupter(args.sourceGUID) and "Long")
end

--[[ Aluriel to Etraeus ]]--
function mod:HeavenlyCrash(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, true)

	local _, _, _, _, _, _, expires = UnitDebuff(args.destName, args.spellName)
	local t = expires - GetTime()
	self:TargetBar(args.spellId, t, args.destName)

	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, t)
	end
end

function mod:HeavenlyCrashRemoved(args)
	self:StopBar(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

--[[ Aluriel to Telarn ]]--
function mod:ChosenFate(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Warning")
		self:Flash(args.spellId)
	end
end

function mod:ArcanicRelease(args)
	list[#list+1] = args.destName
	if #list == 1 then
		self:ScheduleTimer("TargetMessage", 1, args.spellId, list, "Attention", "Alert", nil, nil, true)
	end
	self:TargetBar(args.spellId, 6, args.destName)
	if self:Me(args.destGUID) then
		self:OpenProximity(args.spellId, 8)
		self:Say(args.spellId)
		self:Flash(args.spellId)
	end
end

function mod:ArcanicReleaseRemoved(args)
	self:StopBar(args.spellName, args.destName)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

do
	local prev = 0
	function mod:GreaterTimeWarp(args)
		local t = GetTime()
		if t-prev > 0.5 then
			prev = t
			self:Message(args.spellId, "Important", self:Dispeller("magic", true) and "Info")
		end
	end
end

function mod:ArcaneWound(args)
	if self:Tank(args.destName) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "Important", amount > 3 and "Warning")
		self:StopBar(CL.count:format(args.spellName, amount-1), args.destName)
		self:TargetBar(args.spellId, 20, args.destName, CL.count:format(args.spellName, amount))
	end
end

--[[ Aluriel to Krosos ]]--
function mod:AnnihilatingOrb(args)
	self:TargetMessage(args.spellId, args.destName, "Important", "Warning")
	self:TargetBar(args.spellId, 5, args.destName, 230932, args.spellId) -- Orb
	self:Bar(args.spellId, 35)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:Flash(args.spellId)
	end
end

function mod:AnnihilatingOrbRemoved(args)
	self:StopBar(230932, args.destName) -- Orb
end

function mod:InfernalDeath()
	self:StopBar(221344) -- Annihilating Orb
end

--[[ Aluriel to Tichondrius ]]--
function mod:WillOfTheLegion(args)
	local fear = self:SpellName(5782) -- "Fear"
	self:TargetMessage("fear", args.destName, "Important", "Long", fear, args.spellId, true)
	self:TargetBar("fear", 10, args.destName, fear, args.spellId)
	if self:Me(args.destGUID) then
		self:Say("fear", fear)
	elseif self:Dispeller("magic") then
		self:Flash("fear", args.spellId)
	end
end

function mod:WillOfTheLegionRemoved(args)
	self:StopBar(5782, args.destName) -- "Fear"
end

function mod:FelGlare(args)
	self:TargetMessage(args.spellId, args.destName, "Important", "Warning", nil, nil, true)
	self:TargetBar(args.spellId, 10, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:Flash(args.spellId)
	end
end
