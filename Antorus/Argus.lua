--------------------------------------------------------------------------------
-- Todo:
-- -- Seperate Cooldown bar and castbar for Edge of Annihilation for countdown purposes

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Argus the Unmaker", 1712, 2031)
if not mod then return end
mod:RegisterEnableMob(124828)
mod.engageId = 2092
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local coneOfDeathCounter = 1
local soulBlightOrbCounter = 1
local torturedRageCounter = 1
local sweepingScytheCounter = 1
local avatarCounter = 1
local soulBombCounter = 1
local initializationCount = 3
local sargerasGazeCount = 0
local skyName, seaName = nil, nil
local scanningTargets = nil
local vulnerabilityCollector = {}
local vulnerabilityIcons = {
	[255419] = 1, -- Holy Vulnerability (Yellow Star)
	[255429] = 2, -- Fire Vulnerability (Orange Circle)
	[255430] = 3, -- Shadow Vulnerability (Purple Diamond)
	[255422] = 4, -- Nature Vulnerability (Green Triangle)
	[255433] = 5, -- Arcane Vulnerability (Blue Moon)
	[255425] = 6, -- Frost Vulnerability (Blue Square)
	[255418] = 7, -- Physical Vulnerability (Red Cross)
}
local annihilationCount = 0
local sentenceofSargerasCount = 0

local timersHeroic = {
	[1] = { -- Stage
		-- Cone of Death
		[248165] = {31, 20.5, 22.7, 20.2, 20.5, 23.5},
		-- Soulblight Orb
		[248317] = {35.5, 25.5, 26.8, 23.2, 31},
		-- Tortured Rage
		[257296] = {12, 13.5, 13.5, 15.9, 13.5, 13.5, 15.9, 20.9, 13.5, 13.3},
		-- Sweeping Scythe
		[248499] = {5.8, 11.7, 6.6, 10.3, 10.0, 5.6, 10.3, 5.9, 11.5, 10.1, 5.6, 10.3, 5.6, 15.2},
	},
}

local timersNormal = {
	[1] = { -- Stage
		-- Soulblight Orb
		[248317] = {36, 33, 28, 26.5, 26.6},
		-- Sweeping Scythe
		[248499] = {7, 9.5, 7.3, 8.4, 9, 6.8, 7.3, 9.5, 7.5, 7.3, 13.1, 7.5, 8.4, 7.3, 11.5, 6.5, 10.9},
	},
}
local timersMythic = {
	[1] = { -- Stage
		-- Soul Blight Orb
		[248317] = {35.1, 24.4, 25.6, 26.4, 24, 24.4},
	},
	[4] = {
		-- Tortured Rage
		[257296] = {40, 40, 50, 30, 35, 10, 8, 35, 10, 8, 35},
		-- Sargeras Gaze
		[258068] = {23, 75, 70, 53, 53},
		-- Sentence of Sargeras
		[257966] = {53, 57.0, 60.0, 53, 53},
		--Initialization Sequence
		[256388] = {30, 47.5, 46, 45.5, 52.5, 52.5},
		-- Edge of Annihilation
		[258834] = {5, 5, 90, 5, 45, 5}
	}
}
local timers = mod:Mythic() and timersMythic or mod:Easy() and timersNormal or timersHeroic

--------------------------------------------------------------------------------
-- Localization
--
local vulnerabilityOptionDesc
do
	local icons, desc = "", ""
	for spell,icon in pairs(vulnerabilityIcons) do
		local tex = ("|T13700%d:15|t"):format(icon)
		icons = icons .. tex
		desc = desc .. tex .. mod:SpellName(spell) .. ", "
	end
	vulnerabilityOptionDesc = CL.marker_npc_desc:format(mod:SpellName(-17070), icons) .. "\n" .. desc:sub(0, desc:len() - 2)
end

local L = mod:GetLocale()
if L then
	L.combinedBurstAndBomb = "Combine Soulburst and Soulbomb"
	L.combinedBurstAndBomb_desc = "|cff71d5ffSoulbombs|r are always applied in combination with |cff71d5ffSoulbursts|r. Enable this option to combine those two messages into one."

	L.custom_off_always_show_combined = "Always show the combined Soulburst and Soulbomb message"
	L.custom_off_always_show_combined_desc = "The combined message won't be displayed if you get the |cff71d5ffSoulbomb|r or the |cff71d5ffSoulburst|r. Enable this option to always show the combined message, even when you're affected. |cff33ff99Useful for raid leaders.|r"

	L.custom_off_252516 = CL.marker:format(mod:SpellName(170967)) -- Vulnerability Marker
	L.custom_off_252516_desc = vulnerabilityOptionDesc
	L.custom_off_252516_icon = 1

	L.fear_help = "Sargeras' Fear Combination"
	L.fear_help_desc = "Say a special message if you're afflicted by |cff71d5ffSargeras' Fear|r and |cff71d5ffSoulblight|r/|cff71d5ffSoulburst|r/|cff71d5ffSoulbomb|r/|cff71d5ffSentence of Sargeras|r."
	L.fear_help_icon = 5782

	L[257931] = "Fear" -- Sargeras' Fear
	L[248396] = "Blight" -- Soulblight
	L[251570] = "Bomb" -- Soulbomb
	L[250669] = "Burst" -- Soulburst
	L[257966] = "Sentence" -- Sentence of Sargeras

	L.stage2_early = "Let the fury of the sea wash away this corruption!" -- Yell is 6s before the actual cast start
	L.stage3_early = "No hope. Just pain. Only pain!"  -- Yell is 14.5s before the actual cast start

	L.gifts = "Gifts: %s (Sky), %s (Sea)"
	L.burst = "|T1778229:15:15:0:0:64:64:4:60:4:60|tBurst:%s" -- short for Soulburst
	L.bomb = "|T1778228:15:15:0:0:64:64:4:60:4:60|tBomb (%d):|T137002:0|t%s - " -- short for Soulbomb

	L.sky_say = "{rt5} Crit/Mast"
	L.sea_say = "{rt6} Haste/Versa"

	L.countx = "%s (%dx)"
	L.stacks = "%dx %s" -- for Withering Roots, the target is obvious (and has a rather long name)

	L.bomb_explosions = "Bomb Explosions"
	L.bomb_explosions_desc = "Show a timer for Soulburst and Soulbomb exploding."
	L.bomb_explosions_icon = 251570
end

--------------------------------------------------------------------------------
-- Initialization
--

local seaMarker = mod:AddMarkerOption(false, "player", 5, 255594, 5, 6) -- Sky and Sea
local burstMarker = mod:AddMarkerOption(false, "player", 3, 250669, 3, 7) -- Soul Burst
local bombMarker = mod:AddMarkerOption(false, "player", 2, 251570, 2) -- Soul Bomb
local sentenceMarker = mod:AddMarkerOption(false, "player", 1, 257966, 1, 4) -- Sentence of Sargeras
function mod:GetOptions()
	return {
		"stages",
		"berserk",
		--[[ Stage 1 ]]--
		248165, -- Cone of Death
		248317, -- Soulblight Orb
		{248396, "ME_ONLY", "SAY", "FLASH"}, -- Soul Blight
		248167, -- Death Fog
		257296, -- Tortured Rage
		248499, -- Sweeping Scythe
		{255594, "SAY"}, -- Sky and Sea
		seaMarker,

		--[[ Stage 2 ]]--
		{250669, "SAY"}, -- Soulburst
		burstMarker,
		{251570, "SAY"}, -- Soulbomb
		bombMarker,
		"bomb_explosions",
		"combinedBurstAndBomb",
		"custom_off_always_show_combined",
		255826, -- Edge of Obliteration
		255199, -- Avatar of Aggramar
		255200, -- Aggramar's Boon

		--[[ Stage 3 ]]--
		252516, -- The Discs of Norgannon
		"custom_off_252516", -- Vulnerability Marker
		{252729, "SAY"}, -- Cosmic Ray
		{252616, "SAY"}, -- Cosmic Beacon
		-17077, -- Stellar Armory
		255935, -- Cosmic Power

		--[[ Stage 4 ]]--
		{256399, "HEALER"}, -- Withering Roots
		256544, -- End of All Things
		258039, -- Deadly Scythe
		256388, -- Initialization Sequence
		257214, -- Titanforging

		--[[ Mythic ]]--
		{258068, "SAY", "FLASH", "PULSE"}, -- Sargeras' Gaze
		{"fear_help", "SAY"},
		257911, -- Unleased Rage
		{257966, "FLASH"}, -- Sentence of Sargeras
		sentenceMarker,
		258838, -- Soulrending Scythe
		258834, -- Edge of Annihilation
	},{
		["stages"] = "general",
		[248165] = CL.stage:format(1),
		[250669] = CL.stage:format(2),
		[252516] = CL.stage:format(3),
		[256399] = CL.stage:format(4),
		[258068] = "mythic",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	--[[ Stage 1 ]]--
	self:Log("SPELL_CAST_START", "ConeofDeath", 248165)
	self:Log("SPELL_CAST_START", "SoulBlightOrb", 248317)
	self:Log("SPELL_AURA_APPLIED", "SoulBlight", 248396)
	self:Log("SPELL_AURA_REMOVED", "SoulBlightRemoved", 248396)
	self:Log("SPELL_CAST_START", "TorturedRage", 257296)
	self:Log("SPELL_CAST_START", "SweepingScythe", 248499)
	self:Log("SPELL_AURA_APPLIED", "SweepingScytheStack", 248499)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SweepingScytheStack", 248499)
	self:Log("SPELL_CAST_SUCCESS", "SkyandSea", 255594)
	self:Log("SPELL_AURA_APPLIED", "GiftoftheSea", 258647)
	self:Log("SPELL_AURA_APPLIED", "GiftoftheSky", 258646)
	self:Log("SPELL_AURA_REMOVED", "GiftRemoved", 258647, 258646) -- Sea, Sky
	self:Log("SPELL_AURA_APPLIED", "StrengthoftheSkyandSea", 253901, 253903) -- Strength of the Sea, Strength of the Sky
	self:Log("SPELL_AURA_APPLIED_DOSE", "StrengthoftheSkyandSea", 253901, 253903) -- Strength of the Sea, Strength of the Sky

	--[[ Stage 2 ]]--
	self:Log("SPELL_CAST_START", "GolgannethsWrath", 255648)
	self:Log("SPELL_AURA_APPLIED", "Soulburst", 250669)
	self:Log("SPELL_AURA_REMOVED", "SoulburstRemoved", 250669)
	self:Log("SPELL_AURA_APPLIED", "Soulbomb", 251570)
	self:Log("SPELL_AURA_REMOVED", "SoulbombRemoved", 251570)
	self:Log("SPELL_CAST_SUCCESS", "EdgeofObliteration", 255826)
	self:Log("SPELL_AURA_APPLIED", "AvatarofAggramar", 255199)
	self:Log("SPELL_AURA_APPLIED", "AggramarsBoon", 255200)

	--[[ Stage 3 ]]--
	self:Log("SPELL_CAST_START", "TemporalBlast", 257645)
	self:Log("SPELL_AURA_APPLIED", "VulnerabilityApplied", 255433, 255429, 255425, 255419, 255422, 255418, 255430)

	self:Log("SPELL_AURA_APPLIED", "CosmicRayApplied", 252729)
	self:Log("SPELL_CAST_START", "CosmicBeacon", 252616)
	self:Log("SPELL_AURA_APPLIED", "CosmicBeaconApplied", 252616)
	self:Log("SPELL_AURA_APPLIED", "StellarArmoryBuffs", 255496, 255478) -- Sword of the Cosmos, Blades of the Eternal
	self:Log("SPELL_CAST_START", "CosmicPower", 255935)

	--[[ Stage 4 ]]--
	self:Log("SPELL_CAST_START", "ReapSoul", 256542)
	self:Log("SPELL_CAST_SUCCESS", "GiftoftheLifebinder", 257619)
	self:Log("SPELL_AURA_APPLIED", "WitheringRoots", 256399)
	self:Log("SPELL_AURA_APPLIED_DOSE", "WitheringRootsStacks", 256399)

	self:Log("SPELL_CAST_START", "EndofAllThings", 256544)
	self:Log("SPELL_INTERRUPT", "EndofAllThingsInterupted", "*")
	self:Log("SPELL_CAST_START", "DeadlyScythe", 258039)
	self:Log("SPELL_AURA_APPLIED", "DeadlyScytheStack", 258039)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DeadlyScytheStack", 258039)
	self:Log("SPELL_CAST_SUCCESS", "InitializationSequence", 256388, 258029) -- Heroic, Mythic
	self:Log("SPELL_CAST_SUCCESS", "Titanforging", 257214)

	--[[ Mythic ]]--
	self:Log("SPELL_AURA_APPLIED", "SargerasFear", 257931)
	self:Log("SPELL_AURA_APPLIED", "SargerasRage", 257869)
	self:Log("SPELL_AURA_APPLIED", "SentenceofSargeras", 257966)
	self:Log("SPELL_AURA_REMOVED", "SentenceofSargerasRemoved", 257966)
	self:Log("SPELL_CAST_START", "SoulrendingScythe", 258838)
	self:Log("SPELL_AURA_APPLIED", "SoulrendingScytheStack", 258838)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SoulrendingScytheStack", 258838)

	-- Ground Effects
	self:Log("SPELL_AURA_APPLIED", "GroundEffects", 248167, 257911) -- Death Fog, Unleashed Rage
	self:Log("SPELL_AURA_APPLIED_DOSE", "GroundEffects", 257911) -- Unleashed Rage
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffects", 248167) -- Death Fog
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffects", 248167) -- Death Fog
end

function mod:OnEngage()
	timers = self:Mythic() and timersMythic or self:Easy() and timersNormal or timersHeroic
	stage = 1
	coneOfDeathCounter = 1
	soulBlightOrbCounter = 1
	torturedRageCounter = 1
	sweepingScytheCounter = 1
	soulBombCounter = 1
	sargerasGazeCount = 1
	sentenceofSargerasCount = 1
	skyName, seaName = nil, nil

	self:Bar(255594, 16) -- Sky and Sea
	self:Bar(257296, self:Heroic() and timers[stage][257296][torturedRageCounter] or 13.5, CL.count:format(self:SpellName(257296), torturedRageCounter)) -- Tortured Rage
	self:Bar(248165, self:Mythic() and 30.5 or self:Easy() and 39 or timers[stage][248165][coneOfDeathCounter], CL.count:format(self:SpellName(248165), coneOfDeathCounter)) -- Cone of Death
	self:Bar(248317, timers[stage][248317][soulBlightOrbCounter]) -- Soulblight Orb
	self:Bar(248499, self:Mythic() and 5.9 or timers[stage][248499][sweepingScytheCounter]) -- Sweeping Scythe

	if self:Mythic() then
		self:Bar(258068, 8.2) -- Sargeras' Gaze
		self:Berserk(660)
	else
		self:Berserk(720)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--
local checkForFearHelp
do
	local fearName = mod:SpellName(257931) -- Sargeras' Fear
	local spells = {
		[248396] = mod:SpellName(248396), -- Soulblight
		[251570] = mod:SpellName(251570), -- Soulbomb
		[250669] = mod:SpellName(250669), -- Soulburst
		[257966] = mod:SpellName(257966), -- Sentence of Sargeras
	}

	function checkForFearHelp(self, icon)
		if self:GetOption("fear_help") == 0 then return end
		if UnitDebuff("player", fearName) then
			for id, name in pairs(spells) do
				if UnitDebuff("player", name) then
					icon = icon or GetRaidTargetIndex("player") or 8
					local msg = ("{rt%d} %s + %s {rt%d}"):format(icon, L[257931], L[id], icon)
					self:Say("fear_help", msg)
					return true
				end
			end
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	if msg:find("258068", nil, true) then -- Sargeras' Gaze
		self:Message(258068, "Urgent", nil)
		sargerasGazeCount = sargerasGazeCount + 1
		self:Bar(258068, stage == 4 and timers[stage][258068][sargerasGazeCount] or stage == 2 and 60.5 or 35.1, CL.count:format(self:SpellName(258068), sargerasGazeCount))
	end
end

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg:find(L.stage2_early) then -- We start bars for stage 2 later
		stage = 2
		self:Message("stages", "Positive", "Long", CL.stage:format(stage), false)
		self:StopBar(CL.count:format(self:SpellName(248165), coneOfDeathCounter)) -- Cone of Death
		self:StopBar(248317) -- Blight Orb
		self:StopBar(CL.count:format(self:SpellName(257296), torturedRageCounter)) -- Tortured Rage
		self:StopBar(248499) -- Sweeping Scythe
		self:StopBar(255594) -- Sky and Sea
		self:StopBar(CL.count:format(self:SpellName(258068), sargerasGazeCount)) -- Sargeras' Gaze
		self:Bar("stages", 10.5, self:SpellName(255648), 255648) -- Golganneths Wrath
	elseif msg:find(L.stage3_early) then -- We start bars for stage 3 later
		stage = 3
		wipe(vulnerabilityCollector)
		scanningTargets = nil
		self:Message("stages", "Positive", "Long", CL.stage:format(stage), false)
		self:StopBar(248499) -- Sweeping Scythe
		self:StopBar(255826) -- Edge of Obliteration
		self:StopBar(CL.count:format(self:SpellName(255199), avatarCounter)) -- Avatar of Aggramar
		self:StopBar(CL.count:format(self:SpellName(251570), soulBombCounter)) -- Soulbomb
		self:StopBar(250669) -- Soulburst
		self:StopBar(CL.count:format(self:SpellName(258068), sargerasGazeCount)) -- Sargeras' Gaze
		self:StopBar(CL.count:format(self:SpellName(250669), 2)) -- Soulburst (2)
	end
end

--[[ Stage 1 ]]--
function mod:ConeofDeath(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(CL.count:format(args.spellName, coneOfDeathCounter)))
	coneOfDeathCounter = coneOfDeathCounter + 1
	self:CDBar(args.spellId, self:Mythic() and 20.5 or self:Easy() and 24 or timers[stage][248165][coneOfDeathCounter], CL.count:format(args.spellName, coneOfDeathCounter)) -- normal: 24-26
end

function mod:SoulBlightOrb(args)
	self:Message(args.spellId, "Neutral", "Alert", CL.casting:format(args.spellName))
	soulBlightOrbCounter = soulBlightOrbCounter + 1
	self:CDBar(args.spellId, timers[stage][args.spellId][soulBlightOrbCounter])
end

function mod:SoulBlight(args)
	self:TargetMessage(args.spellId, args.destName, "Neutral", "Warning")
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:TargetBar(args.spellId, 8, args.destName)
		self:SayCountdown(args.spellId, 8)
		checkForFearHelp(self)
	end
end

function mod:SoulBlightRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	self:StopBar(args.spellId, args.destName)
end

function mod:TorturedRage(args)
	self:Message(args.spellId, "Attention", "Alarm", CL.casting:format(CL.count:format(args.spellName, torturedRageCounter)))
	torturedRageCounter = torturedRageCounter + 1
	self:CDBar(args.spellId, self:Mythic() and (stage == 4 and timers[stage][args.spellId][torturedRageCounter] or 13.5) or stage == 4 and 13.5 or self:Easy() and 15.8 or timers[stage][args.spellId][torturedRageCounter], CL.count:format(self:SpellName(257296), torturedRageCounter))
end

function mod:SweepingScythe(args)
	if self:Tank() then
		self:Message(args.spellId, "Neutral", "Alert")
	end
	sweepingScytheCounter = sweepingScytheCounter + 1

	local timer = 6.1
	if stage == 1 and not self:Mythic() then
		timer = timers[stage][args.spellId][sweepingScytheCounter] or 5.5
	elseif stage == 4 then -- normal mode only
		timer = sweepingScytheCounter == 2 and 8.3 or sweepingScytheCounter % 2 == 0 and 7.1 or 6.1
	end

	self:CDBar(args.spellId, timer)
end

function mod:SweepingScytheStack(args)
	if self:Me(args.destGUID) or (self:Tank() and self:Tank(args.destName)) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "Attention", self:Tank() and (amount > 2 and "Alarm") or not self:Tank() and "Warning") -- Warning sound for non-tanks, 3+ stacks warning for tanks
	end
end

function mod:SkyandSea(args)
	self:CDBar(args.spellId, self:Easy() and 30.3 or 27)
end

do
	local function announce(self)
		if skyName and seaName then
			local text = L.gifts:format(self:ColorName(skyName), self:ColorName(seaName))
			self:Message(255594, "Positive", "Long", text, 255594)
			skyName = nil
			seaName = nil
		end
	end

	function mod:GiftoftheSea(args)
		local meOnly = self:CheckOption(255594, "ME_ONLY")
		if self:Me(args.destGUID) then
			self:Say(255594, L.sea_say)
			if meOnly then
				self:Message(255594, "Positive", "Long", CL.you:format(args.spellName), args.spellId)
			end
		elseif not meOnly then
			seaName = args.destName
			announce(self)
		end
		if self:GetOption(seaMarker) then
			SetRaidTarget(args.destName, 6)
		end
	end

	function mod:GiftoftheSky(args)
		local meOnly = self:CheckOption(255594, "ME_ONLY")
		if self:Me(args.destGUID) then
			self:Say(255594, L.sky_say)
			if meOnly then
				self:Message(255594, "Positive", "Long", CL.you:format(args.spellName), args.spellId)
			end
		elseif not meOnly then
			skyName = args.destName
			announce(self)
		end
		if self:GetOption(seaMarker) then
			SetRaidTarget(args.destName, 5)
		end
	end
end

function mod:GiftRemoved(args)
	if self:GetOption(seaMarker) then
		SetRaidTarget(args.destName, 0)
	end
end

function mod:StrengthoftheSkyandSea(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:Message(255594, "Positive", "Info", CL.stackyou:format(amount, args.spellName))
	end
end

--[[ Stage 2 ]]--
function mod:GolgannethsWrath()
	if stage ~= 2 then -- We already set stage 2 from the yell
		stage = 2
		self:Message("stages", "Positive", "Long", CL.stage:format(stage), false)
		self:StopBar(CL.count:format(self:SpellName(248165), coneOfDeathCounter)) -- Cone of Death
		self:StopBar(248317) -- Blight Orb
		self:StopBar(CL.count:format(self:SpellName(257296), torturedRageCounter)) -- Tortured Rage
		self:StopBar(248499) -- Sweeping Scythe
		self:StopBar(255594) -- Sky and Sea
		self:StopBar(258068) -- Sargeras' Gaze
	end
	avatarCounter = 1
	soulBombCounter = 1

	self:Bar("stages", 5, self:SpellName(255648), 255648) -- Golganneths Wrath correction bar
	self:Bar(248499, 17) -- Sweeping Scythe
	self:Bar(255826, self:Mythic() and 25 or 24) -- Edge of Obliteration
	self:Bar(255199, 20.8, CL.count:format(self:SpellName(255199), avatarCounter)) -- Avatar of Aggramar
	self:Bar(251570, 30, CL.count:format(self:SpellName(251570), soulBombCounter)) -- Soulbomb
	self:Bar(250669, 30) -- Soulburst
	if self:Mythic() then
		self:Bar(258068, 26.3) -- Sargeras' Gaze
	end
end

do
	local burstList, bombName, isOnMe, scheduled = {}, nil, 0, nil

	local function announce(self)
		if isOnMe > 0 then -- Burst (3 or 7)
			local positionNumber = isOnMe == 3 and 1 or 2 -- Either 1 or 2
			self:Message(250669, "Personal", "Alarm", CL.you:format(CL.count_icon:format(self:SpellName(250669), positionNumber, isOnMe))) -- Soulburst (1{3}) on you, Soulburst (2{7}) on you
		elseif isOnMe < 0 then -- Bomb (-1)
			self:Message(251570, "Personal", "Warning", CL.you:format(CL.count:format("|T137002:0|t" .. self:SpellName(251570), soulBombCounter - 1))) -- {2}Soulbomb (soulBombCounter) on you
		end
		if self:CheckOption("combinedBurstAndBomb", "MESSAGE") then
			if isOnMe == 0 or self:GetOption("custom_off_always_show_combined") then
				local msg = ""
				if bombName then
					msg = L.bomb:format(soulBombCounter, self:ColorName(bombName))
				end

				local burstMsg = ""
				for i=1, #burstList do
					local player = burstList[i]
					local icon = i == 1 and "|T137003:0|t" or "|T137007:0|t"
					burstMsg = burstMsg .. icon .. self:ColorName(player) .. (i == #burstList and "" or ",")
				end
				msg = msg .. L.burst:format(burstMsg)

				self:Message("combinedBurstAndBomb", "Important", nil, msg, false)
			end
		else
			if isOnMe > -1 then -- No bomb on you (0, 3 or 7)
				self:TargetMessage(251570, bombName, "Urgent", nil, CL.count:format(self:SpellName(251570), soulBombCounter))
			end
			if isOnMe < 3 then -- No burst on you (0 or -1)
				self:TargetMessage(250669, self:ColorName(burstList), "Important")
			end
		end
		wipe(burstList)
		scheduled = nil
		bombName = nil
		isOnMe = 0
	end

	function mod:Soulburst(args)
		burstList[#burstList+1] = args.destName
		if self:Me(args.destGUID) then
			isOnMe = #burstList == 1 and 3 or 7 -- Soulburst on you (3 or 7)
			self:SayCountdown(args.spellId, self:Mythic() and 12 or 15, isOnMe)
			if not checkForFearHelp(self, #burstList == 1 and 3 or 7) then
				self:Say(args.spellId, CL.count_rticon:format(args.spellName, #burstList, isOnMe))
			end
		end
		if #burstList == 1 then
			if not scheduled then
				scheduled = self:ScheduleTimer(announce, 0.1, self)
			end
			self:Bar("bomb_explosions", self:Mythic() and 12 or 15, L.bomb_explosions, L.bomb_explosions_icon) -- Bomb Explosions
			if self:GetOption(burstMarker) then
				SetRaidTarget(args.destName, 3)
			end
		elseif self:GetOption(burstMarker) then
			SetRaidTarget(args.destName, 7)
		end
	end

	function mod:SoulburstRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		if self:GetOption(burstMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end

	function mod:Soulbomb(args)
		if self:Me(args.destGUID) then
			self:SayCountdown(args.spellId, self:Mythic() and 12 or 15, 2)
			isOnMe = -1 -- Soulbomb on you (-1)
			if not checkForFearHelp(self, 2) then
				self:Say(args.spellId, args.spellName .. " {rt2}")
			end
		end

		bombName = args.destName

		if not scheduled then
			scheduled = self:ScheduleTimer(announce, 0.1, self)
		end

		soulBombCounter = soulBombCounter + 1
		self:Bar(args.spellId, stage == 4 and (self:Easy() and 80.5 or 54) or 42, CL.count:format(args.spellName, soulBombCounter))

		self:Bar(250669, stage == 4 and (self:Easy() and 80.5 or 54) or 42) -- Soulburst
		self:Bar(250669, stage == 4 and (self:Easy() and 40.2 or 24.5) or 20, CL.count:format(self:SpellName(250669), 2)) -- Soulburst (2)

		if self:GetOption(burstMarker) then
			SetRaidTarget(args.destName, 2)
		end
	end
end

function mod:SoulbombRemoved(args)
	self:StopBar(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	if self:GetOption(burstMarker) then
		SetRaidTarget(args.destName, 0)
	end
end

function mod:EdgeofObliteration(args)
	self:Message(args.spellId, "Attention", "Alarm")
	self:Bar(args.spellId, 34)
end

function mod:AvatarofAggramar(args)
	self:TargetMessage(args.spellId, args.destName, "Positive", "Long")
	avatarCounter = avatarCounter + 1
	if stage == 2 then -- Don't trigger if it procs after stage 3 RP has started
		self:Bar(args.spellId, 60, CL.count:format(args.spellName, avatarCounter))
	end
end

do
	local prev = 0
	function mod:AggramarsBoon(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 0.5 then -- Throttle incase you are on the edge/tank moves around slightly
				prev = t
				self:TargetMessage(args.spellId, args.destName, "Personal", "Info")
			end
		end
	end
end

--[[ Stage 3 ]]--
function mod:TemporalBlast()
	if self:Mythic() then -- Skips Stage 3
		self:Bar("stages", 55.8, 257619, 257619) -- Gift of the Lifebinder
	else
		if stage ~= 3 then
			stage = 3
			wipe(vulnerabilityCollector)
			scanningTargets = nil
			self:Message("stages", "Positive", "Long", CL.stage:format(stage), false)
			self:StopBar(248499) -- Sweeping Scythe
			self:StopBar(255826) -- Edge of Obliteration
			self:StopBar(CL.count:format(self:SpellName(255199), avatarCounter)) -- Avatar of Aggramar
			self:StopBar(CL.count:format(self:SpellName(251570), soulBombCounter)) -- Soulbomb
			self:StopBar(250669) -- Soulburst
			self:StopBar(CL.count:format(self:SpellName(250669), 2)) -- Soulburst (2)
		end

		self:Bar("stages", 16.6, CL.adds, "achievement_boss_algalon_01") -- The Constellar Designates
		self:Bar(-17077, self:Easy() and 30.5 or 26.3, nil, "inv_sword_2h_pandaraid_d_01") -- The Stellar Armory
		self:Bar(252516, 27.3) -- The Discs of Norgannon
		self:Bar(252729, self:Easy() and 38 or 30.4) -- Cosmic Ray
		self:Bar(252616, self:Easy() and 53 or 41.3) -- Cosmic Beacon
	end
end

function mod:VulnerabilityApplied(args)
	if self:GetOption("custom_off_252516") then
		vulnerabilityCollector[args.destGUID] = vulnerabilityIcons[args.spellId]
		if not scanningTargets then
			self:RegisterTargetEvents("ConstellarMark")
			scanningTargets = true
		end
	end
end

function mod:ConstellarMark(_, unit, guid)
	if vulnerabilityCollector[guid] then
		SetRaidTarget(unit, vulnerabilityCollector[guid])
		vulnerabilityCollector[guid] = nil
		if not next(vulnerabilityCollector) then
			scanningTargets = nil
			self:UnregisterTargetEvents()
		end
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:CosmicRayApplied(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:Flash(args.spellId)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Urgent", "Warning", nil, nil, true)
			self:Bar(args.spellId, self:Easy() and 30 or 20)
		end
	end
end

do
	local prev = 0
	function mod:CosmicBeacon(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Important", "Alarm", CL.casting:format(args.spellName))
			self:Bar(args.spellId, self:Easy() and 30 or 20)
		end
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:CosmicBeaconApplied(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:Flash(args.spellId)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Urgent", "Alarm", nil, nil, true)
		end
	end
end

do
	local prev = 0
	function mod:StellarArmoryBuffs()
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(-17077, "Attention", "Alert", nil, "inv_sword_2h_pandaraid_d_01")
			if not self:Easy() then
				self:Bar(-17077, 40, nil, "inv_sword_2h_pandaraid_d_01")
			end
		end
	end
end

function mod:CosmicPower(args)
	self:Message(args.spellId, "Attention", "Alert")
end

--[[ Stage 4 ]]--
function mod:ReapSoul()
	self:UnregisterTargetEvents()

	stage = 4
	self:Message("stages", "Positive", "Long", CL.stage:format(stage), false)
	self:StopBar(-17077) -- The Stellar Armory
	self:StopBar(252616) -- Cosmic Beacon
	self:StopBar(252729) -- Cosmic Ray

	self:Bar("stages", 35.5, 257619, 257619) -- Gift of the Lifebinder
end

function mod:GiftoftheLifebinder(args)
	self:Message("stages", "Positive", "Long", args.spellName, args.spellId)
	self:RegisterUnitEvent("UNIT_POWER", nil, "boss3") -- boss1 = Argus, boss2 = Khaz'goroth, boss3 = Gift of the Lifebinder
end

function mod:UNIT_POWER(unit)
	local power = UnitPower(unit) / UnitPowerMax(unit) * 100
	if power <= 10 then
		self:UnregisterUnitEvent("UNIT_POWER", unit)
		self:Message("stages", "Positive", "Long", CL.soon:format(self:SpellName(256399)), 256399) -- Withering Roots
	end
end

do
	local prev, lastAnnouncedStacks, stacks, scheduled = 0, 0, nil
	function mod:WitheringRoots(args)
		if self:GetOption(args.spellId) ~= 0 and (self:CheckOption(args.spellId, "HEALER") == false or self:Healer()) then -- follow the same format as WitheringRootsStacks for healers
			prev = GetTime()
			lastAnnouncedStacks = 1
			self:Message(args.spellId, "Attention", "Alert", L.stacks:format(1, args.spellName))
		else -- for others: just warn that the tree is now withering
			self:Message("stages", "Positive", "Long", args.spellId)
		end
	end

	-- helper function with access to a local variable to avoid
	-- passing by value and rescheduling the timer
	local function announce(self, spellId, spellName)
		self:Message(spellId, "Attention", "Alert", L.stacks:format(stacks, spellName))
		lastAnnouncedStacks = stacks
		prev = GetTime()
		scheduled = nil
	end

	function mod:WitheringRootsStacks(args)
		if args.amount - lastAnnouncedStacks > 2 then -- normally it'll be 1, 4, 7...
			local t = GetTime()
			stacks = args.amount
			if t - prev > 1 then -- on Mythic players usually revive themselves simultaneously, we don't want to show multiple messages
				if scheduled then self:CancelTimer(scheduled) end
				announce(self, args.spellId, args.spellName)
			else
				if not scheduled then
					scheduled = self:ScheduleTimer(announce, 1 - (t - prev), self, args.spellId, args.spellName)
				end
			end
		end
	end
end

function mod:EndofAllThings(args)
	self:Message(args.spellId, "Important", "Warning", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 15)
end

function mod:EndofAllThingsInterupted(args)
	if args.extraSpellId == 256544 then
		self:Message(256544, "Positive", "Info", CL.interrupted:format(args.extraSpellName))
		self:StopBar(CL.cast:format(args.extraSpellName))
		initializationCount = self:Mythic() and 1 or 3
		torturedRageCounter = 1
		sweepingScytheCounter = 1

		if self:Mythic() then
			annihilationCount = 1
			sargerasGazeCount = 1
			sentenceofSargerasCount = 1
			self:Bar(258838, 3.8) -- Soulrending Scythe
			self:Bar(258068, timers[stage][258068][sargerasGazeCount], CL.count:format(self:SpellName(258068), sargerasGazeCount)) -- Sargeras' Gaze
			self:StartScytheTimer(timers[stage][258834][annihilationCount])
			self:Bar(257966, timers[stage][257966][sentenceofSargerasCount], CL.count:format(self:SpellName(257966), sentenceofSargerasCount)) -- Sentence of Sargeras
		else
			soulBombCounter = 1
			if self:Easy() then
				self:Bar(248499, 5.1) -- Sweeping Scythe
			else
				self:Bar(258039, 6) -- Deadly Scythe
			end
			self:Bar(251570, 20.1, CL.count:format(self:SpellName(251570), soulBombCounter)) -- Soulbomb
			self:Bar(250669, 20.1) -- Soulburst
		end
		self:Bar(257296, self:Mythic() and timers[stage][257296][torturedRageCounter] or 11) -- Tortured Rage
		self:Bar(256388, self:Mythic() and timers[stage][256388][initializationCount] or 18.5, L.countx:format(self:SpellName(256388), initializationCount)) -- Initialization Sequence
	end
end

function mod:DeadlyScythe(args)
	if self:Tank() then
		self:Message(args.spellId, "Neutral", "Alert")
	end
	self:Bar(args.spellId, 6.6)
end

function mod:DeadlyScytheStack(args)
	if self:Me(args.destGUID) or self:Tank() then -- Always Show for Tanks and when on Self
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "Attention", self:Tank() and (self:Me(args.destGUID) and "Alarm") or "Warning") -- Warning sound for non-tanks, only on self when a tank
	end
end

do
	local prev = 0
	function mod:InitializationSequence(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(256388, "Important", "Warning", L.countx:format(args.spellName, initializationCount))
			initializationCount = initializationCount + 1
			self:CDBar(256388, self:Mythic() and timers[stage][256388][initializationCount] or 50, L.countx:format(args.spellName, initializationCount))
		end
	end
end

function mod:Titanforging(args)
	self:Message(args.spellId, "Positive", "Long", CL.casting:format(args.spellName))
end

--[[ Mythic ]]--

function mod:SargerasRage(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(258068, args.destName, "Personal", "Warning", args.spellName, args.spellId)
		self:Flash(258068)
		self:Say(258068, self:SpellName(6612)) -- Rage
	end
end

function mod:SargerasFear(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(258068, args.destName, "Personal", "Warning", args.spellName, args.spellId)
		checkForFearHelp(self)
	end
end

do
	local playerList, isOnMe = {}, 0

	local function announce(self, spellId, spellName)
		local meOnly = self:CheckOption(spellId, "ME_ONLY")

		if isOnMe > 0 and (meOnly or #playerList == 1) then
			self:Message(spellId, "Personal", "Warning", CL.you:format(("|T13700%d:0|t%s"):format(isOnMe == 1 and 1 or 4, spellName)))
		elseif not meOnly then
			local msg = ""
			for i=1, #playerList do
				local icon = i == 1 and "|T137001:0|t" or "|T137004:0|t"
				msg = msg .. icon .. self:ColorName(playerList[i]) .. (i == #playerList and "" or ",")
			end

			self:Message(spellId, "Urgent", isOnMe > 0 and "Warning", CL.other:format(spellName, msg))
		end

		wipe(playerList)
		isOnMe = 0
	end

	function mod:SentenceofSargeras(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			isOnMe = #playerList
			self:Flash(args.spellId, isOnMe == 1 and 1 or 4)
			checkForFearHelp(self)
		end
		if #playerList == 1 then
			self:ScheduleTimer(announce, 0.3, self, args.spellId, args.spellName)
			sentenceofSargerasCount = sentenceofSargerasCount + 1
			self:Bar(args.spellId, timers[stage][args.spellId][sentenceofSargerasCount], CL.count:format(args.spellName, sentenceofSargerasCount))
			if self:GetOption(sentenceMarker) then
				SetRaidTarget(args.destName, 1)
			end
		elseif self:GetOption(sentenceMarker) then
			SetRaidTarget(args.destName, 4)
		end
	end

	function mod:SentenceofSargerasRemoved(args)
		if self:GetOption(sentenceMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:SoulrendingScythe(args)
	if self:Tank() then
		self:Message(args.spellId, "Neutral", "Alert")
	end
	self:CDBar(args.spellId, 8.5)
end

function mod:SoulrendingScytheStack(args)
	if self:Me(args.destGUID) or (self:Tank() and self:Tank(args.destName)) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "Attention", self:Tank() and (amount > 2 and "Alarm") or "Warning") -- Warning sound for non-tanks, 3+ stacks warning for tanks
	end
end

-- Edge of Annihilation
function mod:StartScytheTimer(t)
	self:Bar(258834, t, CL.count:format(self:SpellName(258834), annihilationCount))
	self:ScheduleTimer("Message", t, 258834, "Attention", "Info", CL.count:format(self:SpellName(258834), annihilationCount))
	self:ScheduleTimer("CastBar", t, 258834, 10, CL.count:format(self:SpellName(258834), annihilationCount))
	annihilationCount = annihilationCount + 1
	if timers[stage][258834][annihilationCount] then
		self:ScheduleTimer("StartScytheTimer", t, timers[stage][258834][annihilationCount])
	end
end

-- Ground Effects
do
	local prev = 0
	function mod:GroundEffects(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName)) -- Death Fog
		end
	end
end
