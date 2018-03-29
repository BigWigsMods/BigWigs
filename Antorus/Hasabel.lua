--------------------------------------------------------------------------------
-- TODO List:
-- -- initial Bars for the Platform mini bosses when engaged

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Portal Keeper Hasabel", 1712, 1985)
if not mod then return end
mod:RegisterEnableMob(122104)
mod.engageId = 2064
mod.respawnTime = 35

--------------------------------------------------------------------------------
-- Locals
--

local addsAlive = 0
local playerPlatform = 1 -- 1: Nexus, 2: Xoroth, 3: Rancora, 4: Nathreza
local nextPortalSoonWarning = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_stop_timers = "Always show ability bars"
	L.custom_on_stop_timers_desc = "Hasabel randomizes which off-cooldown ability she uses next. When this option is enabled, the bars for those abilities will stay on your screen."

	L.custom_on_filter_platforms = "Filter Side Platform Warnings and Bars"
	L.custom_on_filter_platforms_desc = "Removes unnecessary messages and bars if you are not on a side platform. It will always show bars and warnings from the main Platform: Nexus."

	L.worldExplosion = mod:SpellName(20476) -- Explosion
	L.worldExplosion_desc = "Show a timer for the Collapsing World explosion."
	L.worldExplosion_icon = 120637

	L.platform_active = "%s Active!" -- Platform: Xoroth Active!
	L.add_killed = "%s killed!"

	L.achiev = "'Portal Combat' achievement debuffs" -- Achievement 11928
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ General ]]--
		"stages",
		"custom_on_stop_timers",
		"custom_on_filter_platforms",
		"berserk",

		--[[ Platform: Nexus ]]--
		{244016, "TANK"}, -- Reality Tear
		243983, -- Collapsing World
		"worldExplosion",
		244000, -- Felstorm Barrage
		244689, -- Transport Portal
		245504, -- Howling Shadows
		246075, -- Catastrophic Implosion

		--[[ Platform: Xoroth ]]--
		244607, -- Flames of Xoroth
		244598, -- Supernova
		{244613, "SAY"}, -- Everburning Flames
		255805, -- Unstable Portal, every platform add casts it and i don't know where else to put it

		--[[ Platform: Rancora ]]--
		{244926, "SAY"}, -- Felsilk Wrap
		246316, -- Poison Essence
		{244849, "SAY"}, -- Caustic Slime

		--[[ Platform: Nathreza ]]--
		{245050, "HEALER"}, -- Delusions
		245040, -- Corrupt
		{245118, "SAY"}, -- Cloying Shadows
		245075, -- Hungering Gloom

		--[[ 'Portal Combat' achievement debuffs ]]--
		246911, -- Binding: Xoroth
		246925, -- Binding: Rancora
		246929, -- Binding: Nathreza
	},{
		["stages"] = "general",
		[244016] = -15799, -- Platform: Nexus
		[244607] = -15800, -- Platform: Xoroth
		[244926] = -15801, -- Platform: Rancora
		[245050] = -15802, -- Platform: Nathreza
		[246911] = L.achiev,
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "ActivatePortals", "boss1") -- Used when portals activate
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "TransferPortals", "player") -- Used to track which platform a player is on as the spells below have been removed from CLUE

	--self:Log("SPELL_CAST_SUCCESS", "PlatformPortal", 244073, 244136, 244146) -- Xoroth, Rancora, Nathreza
	--self:Log("SPELL_CAST_SUCCESS", "ReturnPortal", 244112, 244138, 244145) -- Xoroth, Rancora, Nathreza

	--[[ Platform: Nexus ]]--
	self:Log("SPELL_AURA_APPLIED", "RealityTear", 244016)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RealityTear", 244016)
	self:Log("SPELL_CAST_SUCCESS", "RealityTearSuccess", 244016)
	self:Log("SPELL_CAST_START", "CollapsingWorldStart", 243983)
	self:Log("SPELL_CAST_SUCCESS", "CollapsingWorld", 243983)
	self:Log("SPELL_CAST_START", "FelstormBarrageStart", 244000)
	self:Log("SPELL_CAST_SUCCESS", "FelstormBarrage", 244000)
	self:Log("SPELL_CAST_START", "TransportPortalStart", 244689)
	self:Log("SPELL_CAST_SUCCESS", "TransportPortal", 244689)
	self:Log("SPELL_CAST_START", "HowlingShadows", 245504)
	self:Log("SPELL_CAST_START", "CatastrophicImplosion", 246075)

	--[[ Platform: Xoroth ]]--
	self:Log("SPELL_CAST_START", "FlamesofXoroth", 244607)
	self:Log("SPELL_CAST_SUCCESS", "Supernova", 244598)
	self:Log("SPELL_AURA_APPLIED", "EverburningFlames", 244613)
	self:Log("SPELL_AURA_REMOVED", "EverburningFlamesRemoved", 244613)
	self:Log("SPELL_CAST_START", "UnstablePortal", 255805) -- Every platform add casts it and i don't know where else to put it
	self:Death("VulcanarDeath", 122211)

	--[[ Platform: Rancora ]]--
	self:Log("SPELL_CAST_SUCCESS", "FelsilkWrap", 244926)
	self:Log("SPELL_CAST_START", "PoisonEssence", 246316)
	self:Log("SPELL_AURA_APPLIED", "CausticSlime", 244849)
	self:Log("SPELL_AURA_REMOVED", "CausticSlimeRemoved", 244849)
	self:Death("LadyDacidionDeath", 122212)

	--[[ Platform: Nathreza ]]--
	self:Log("SPELL_CAST_START", "Delusions", 245050)
	self:Log("SPELL_AURA_APPLIED", "Corrupt", 245040)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Corrupt", 245040)
	self:Log("SPELL_CAST_SUCCESS", "CorruptSuccess", 245040)
	self:Log("SPELL_AURA_APPLIED", "CloyingShadows", 245118)
	self:Log("SPELL_AURA_REMOVED", "CloyingShadowsRemoved", 245118)
	self:Log("SPELL_AURA_APPLIED", "HungeringGloom", 245075)
	self:Log("SPELL_AURA_REMOVED", "HungeringGloomRemoved", 245075)
	self:Death("LordEilgarDeath", 122213)

	--[[ 'Portal Combat' achievement debuffs ]]--
	self:Log("SPELL_AURA_APPLIED", "Binding", 246911, 246925, 246929) -- Binding: Xoroth, Binding: Rancora, Binding: Nathreza

	self:RegisterMessage("BigWigs_BarCreated", "BarCreated")
end

function mod:OnEngage()
	addsAlive = 0
	playerPlatform = 1

	self:Bar(244016, 7) -- Reality Tear
	self:Bar(243983, 12.7) -- Collapsing World
	self:Bar(244689, self:Mythic() and 36.3 or 26.7) -- Transport Portal
	self:Bar(244000, self:Mythic() and 26.9 or 35.7) -- Felstorm Barrage
	self:Berserk(720)

	nextPortalSoonWarning = 92 -- happens at 90%
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local triggerCdForOtherSpells
do
	local abilitysToPause = {
		[243983] = true, -- Collapsing World
		[244689] = true, -- Transport Portal
		[244000] = true, -- Felstorm Barrage
	}

	local castPattern = CL.cast:gsub("%%s", ".+")

	function triggerCdForOtherSpells(self, spellId, castTime)
		for id,_ in pairs(abilitysToPause) do
			if id ~= spellId then
				local cd = (id == 244689 and 8.5 or 9) + (castTime or 0) -- Transport Portal cast is 0.5s shorter
				if self:BarTimeLeft(id) < cd then
					self:Bar(id, cd)
				end
			end
		end
	end

	local function stopAtZeroSec(bar)
		if bar.remaining < 0.15 then -- Pause at 0.0
			bar:SetDuration(0.01) -- Make the bar look full
			bar:Start()
			bar:Pause()
			bar:SetTimeVisibility(false)
		end
	end

	function mod:BarCreated(_, _, bar, _, key, text)
		if self:GetOption("custom_on_stop_timers") and abilitysToPause[key] and not text:match(castPattern) then
			bar:AddUpdateFunction(stopAtZeroSec)
		end
	end
end

function mod:UNIT_HEALTH_FREQUENT(unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < nextPortalSoonWarning then
		local platformName = (hp < 40 and self:SpellName(257942)) or (hp < 70 and self:SpellName(257941)) or self:SpellName(257939)
		local icon = (hp < 40 and "spell_mage_flameorb_purple") or (hp < 70 and "spell_mage_flameorb_green") or "spell_mage_flameorb"
		self:Message("stages", "green", nil, CL.soon:format(platformName), icon)
		nextPortalSoonWarning = nextPortalSoonWarning - 30
		if nextPortalSoonWarning < 30 then
			self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unit)
		end
	end
end

function mod:ActivatePortals(_, _, _, _, spellId)
	if spellId == 257939 then -- Gateway: Xoroth
		self:Message("stages", "green", "Long", L.platform_active:format(self:SpellName(257939)), "spell_mage_flameorb") -- Platform: Xoroth
		addsAlive = addsAlive + 1
		self:CDBar(255805, (self:LFR() and 60) or (self:Mythic() and 30) or 45) -- Unstable Portal
	elseif spellId == 257941 then -- Gateway: Rancora
		self:Message("stages", "green", "Long", L.platform_active:format(self:SpellName(257941)), "spell_mage_flameorb_green") -- Platform: Rancora
		addsAlive = addsAlive + 1
		self:CDBar(255805, (self:LFR() and 60) or (self:Mythic() and 30) or 45) -- Unstable Portal
	elseif spellId == 257942 then -- Gateway: Nathreza
		self:Message("stages", "green", "Long", L.platform_active:format(self:SpellName(257942)), "spell_mage_flameorb_purple") -- Platform: Nathreza
		addsAlive = addsAlive + 1
		self:CDBar(255805, (self:LFR() and 60) or (self:Mythic() and 30) or 45) -- Unstable Portal
	end
end

function mod:TransferPortals(_, _, _, _, spellId)
	if spellId == 244450 then -- Platform: Nexus
		playerPlatform = 1
	elseif spellId == 244455 then -- Xoroth
		playerPlatform = 2
	elseif spellId == 244512 then -- Rancora
		playerPlatform = 3
	elseif spellId == 244513 then -- Nathreza
		playerPlatform = 4
	end
end

--function mod:PlatformPortal(args)
--	if self:Me(args.sourceGUID) then
--		if args.spellId == 244073 then -- Xoroth
--			playerPlatform = 2
--		elseif args.spellId == 244136 then -- Rancora
--			playerPlatform = 3
--		elseif args.spellId == 244146 then -- Nathreza
--			playerPlatform = 4
--		end
--	end
--end

--function mod:ReturnPortal(args)
--	if self:Me(args.sourceGUID) then
--		playerPlatform = 1
--	end
--end

function mod:RealityTear(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "orange", amount > 1 and "Alarm", nil, nil, true)
end

function mod:RealityTearSuccess(args)
	self:Bar(args.spellId, addsAlive > 0 and 24.4 or 12.2) -- Cooldown increased when there are platforms active
end

function mod:CollapsingWorldStart(args)
	self:StopBar(args.spellId)
	triggerCdForOtherSpells(self, args.spellId, 2)
end

function mod:CollapsingWorld(args)
	self:Message(args.spellId, "red", "Warning")
	self:Bar("worldExplosion", 8, L.worldExplosion, L.worldExplosion_icon)
	self:Bar(args.spellId, (self:Easy() and 37.1) or (self:Mythic() and 27.5) or 32.75)
	triggerCdForOtherSpells(self, args.spellId)
end

function mod:FelstormBarrageStart(args)
	self:StopBar(args.spellId)
	triggerCdForOtherSpells(self, args.spellId, 2)
end

function mod:FelstormBarrage(args)
	self:Message(args.spellId, "orange", "Alert")
	self:Bar(args.spellId, (self:Easy() and 37.1) or (self:Mythic() and 27.5) or 32.75)
	triggerCdForOtherSpells(self, args.spellId)
end

function mod:TransportPortalStart(args)
	self:StopBar(args.spellId)
	triggerCdForOtherSpells(self, args.spellId, 1.5)
end

function mod:TransportPortal(args)
	self:Message(args.spellId, "cyan", "Info")
	self:Bar(args.spellId, (self:Mythic() and 36.5) or 41.7)
	self:CDBar(args.spellId, 12, CL.spawning:format(CL.adds))
	triggerCdForOtherSpells(self, args.spellId)
end

function mod:HowlingShadows(args)
	if playerPlatform == 1 then
		self:Message(args.spellId, "orange", "Alarm")
	end
end

do
	local prev = 0
	function mod:CatastrophicImplosion(args)
		local t = GetTime()
		if t-prev > 0.2 then
			prev = t
			self:Message(args.spellId, "red", "Alarm")
		end
	end
end

do
	local lastFlames = 0

	function mod:FlamesofXoroth(args)
		lastFlames = GetTime()
		if self:GetOption("custom_on_filter_platforms") and playerPlatform ~= 2 then return end
		if self:Interrupter(args.sourceGUID) then
			self:Message(args.spellId, "orange", "Alarm")
		end
		self:CDBar(args.spellId, 7.3) -- sometimes 8.5 (we adjust that timer in :Supernova())
		self:CDBar(244598, 4.8) -- Supernova
	end

	function mod:Supernova(args)
		if self:GetOption("custom_on_filter_platforms") and playerPlatform ~= 2 then return end
		self:Message(args.spellId, "yellow", "Alert")
		if (GetTime() - lastFlames) < 5.5 then -- 2nd Supernova before Flames very likely
			self:CDBar(args.spellId, 2.5)
			self:CDBar(244607, 3.65) -- Flames of Xoroth
		end
	end
end

function mod:EverburningFlames(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "blue", "Info", CL.you:format(args.spellName))
		self:SayCountdown(args.spellId, 10)
	end
end

function mod:EverburningFlamesRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:UnstablePortal(args)
	if self:GetOption("custom_on_filter_platforms") and playerPlatform == 1 then return end
	self:Message(args.spellId, "red", self:Interrupter(args.sourceGUID) and "Alarm")
end

function mod:VulcanarDeath(args)
	self:Message("stages", "green", nil, L.add_killed:format(args.destName), "spell_mage_flameorb")
	self:StopBar(244598) -- Supernova
	self:StopBar(244607) -- Flames of Xoroth
	self:StopBar(255805) -- Unstable Portal
	addsAlive = addsAlive - 1
end

function mod:FelsilkWrap(args)
	if self:GetOption("custom_on_filter_platforms") and playerPlatform ~= 3 then return end
	self:PlaySound(args.spellId, "Warning")
	self:TargetMessage2(args.spellId, "orange", args.destName)
	self:CDBar(args.spellId, 17)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
end

function mod:PoisonEssence(args)
	if self:GetOption("custom_on_filter_platforms") and playerPlatform ~= 3 then return end
	self:Message(args.spellId, "red", "Alarm")
	self:CDBar(args.spellId, 9.7)
end

function mod:CausticSlime(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "blue", "Info", CL.you:format(args.spellName))
		self:SayCountdown(args.spellId, 20)
	end
end

function mod:CausticSlimeRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:LadyDacidionDeath(args)
	self:Message("stages", "green", nil, L.add_killed:format(args.destName), "spell_mage_flameorb_green")
	self:StopBar(244926) -- Felsilk Wrap
	self:StopBar(246316) -- Poison Essence
	self:StopBar(255805) -- Unstable Portal
	addsAlive = addsAlive - 1
end

function mod:Delusions(args)
	if self:GetOption("custom_on_filter_platforms") and playerPlatform ~= 4 then return end
	self:Message(args.spellId, "yellow", "Alert", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 14.5)
end

function mod:Corrupt(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "yellow", amount > 2 and "Warning") -- Sound when stacks are 3 or higher
	end
end

function mod:CorruptSuccess(args)
	if self:GetOption("custom_on_filter_platforms") and playerPlatform ~= 4 then return end
	self:CDBar(args.spellId, 6.1)
end

function mod:CloyingShadows(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "Info")
		self:TargetMessage2(args.spellId, "blue", args.destName)
		self:SayCountdown(args.spellId, 30)
	end
end

function mod:CloyingShadowsRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:HungeringGloom(args)
	if self:GetOption("custom_on_filter_platforms") and playerPlatform == 1 then return end
	if UnitGUID("boss2") == args.destGUID or UnitGUID("boss3") == args.destGUID or UnitGUID("boss4") == args.destGUID then -- Should always be boss2, rest is safety
		self:PlaySound(args.spellId, "Info")
		self:Message(args.spellId, "orange", nil, CL.on:format(args.spellName, args.destName))
		self:Bar(args.spellId, 20, CL.onboss:format(args.spellName))
	end
end

function mod:HungeringGloomRemoved(args)
	if UnitGUID("boss2") == args.destGUID or UnitGUID("boss3") == args.destGUID or UnitGUID("boss4") == args.destGUID then -- Should always be boss2, rest is safety
		self:StopBar(CL.onboss:format(args.spellName))
	end
end

function mod:LordEilgarDeath(args)
	self:Message("stages", "green", nil, L.add_killed:format(args.destName), "spell_mage_flameorb_purple")
	self:StopBar(245050) -- Delusions
	self:StopBar(245040) -- Corrupt
	self:StopBar(255805) -- Unstable Portal
	addsAlive = addsAlive - 1
end

--[[ 'Portal Combat' achievement debuffs ]]--
function mod:Binding(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "Info")
		self:TargetMessage2(args.spellId, "blue", args.destName)
		self:TargetBar(args.spellId, 16, args.destName)
	end
end
