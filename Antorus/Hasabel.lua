--------------------------------------------------------------------------------
-- TODO List:
-- -- initial Bars for the Platform mini bosses when engaged

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Portal Keeper Hasabel", nil, 1985, 1712)
if not mod then return end
mod:RegisterEnableMob(122104)
mod.engageId = 2064
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local realityTearCount = 1
local collapsingWorldCount = 1
local felstormBarrageCount = 1
local playerPlatform = 1 -- 1: Nexus, 2: Xoroth, 3: Rancora, 4: Nathreza
local nextPortalSoonWarning = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_filter_platforms = "Filter Side Platform Warnings and Bars"
	L.custom_on_filter_platforms_desc = "Removes unnecessary messages and bars if you are not on a side platform. It will always show bars and warnings from the main Platform: Nexus."
	L.platform_active = "%s Active!" -- Platform: Xoroth Active!
	L.add_killed = "%s killed!"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ General ]]--
		"stages",
		"custom_on_filter_platforms",
		"berserk",

		--[[ Platform: Nexus ]]--
		{244016, "TANK"}, -- Reality Tear
		243983, -- Collapsing World
		244000, -- Felstorm Barrage
		244689, -- Transport Portal
		245504, -- Howling Shadows
		246075, -- Catastrophic Implosion

		--[[ Platform: Xoroth ]]--
		244607, -- Flames of Xoroth
		244598, -- Supernova
		{244613, "SAY"}, -- Everburning Flames

		--[[ Platform: Rancora ]]--
		{244926, "SAY"}, -- Felsilk Wrap
		246316, -- Poison Essence
		{244849, "SAY"}, -- Caustic Slime

		--[[ Platform: Nathreza ]]--
		{245050, "HEALER"}, -- Delusions
		245040, -- Corrupt
		{245118, "SAY"}, -- Cloying Shadows
	},{
		["stages"] = "general",
		[244016] = -15799, -- Platform: Nexus
		[244607] = -15800, -- Platform: Xoroth
		[244926] = -15801, -- Platform: Rancora
		[245050] = -15802, -- Platform: Nathreza
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_CAST_SUCCESS", "PlatformPortal", 244073, 244136, 244146) -- Xoroth, Rancora, Nathreza
	self:Log("SPELL_CAST_SUCCESS", "ReturnPortal", 244112, 244138, 244145) -- Xoroth, Rancora, Nathreza

	--[[ Platform: Nexus ]]--
	self:Log("SPELL_AURA_APPLIED", "RealityTear", 244016)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RealityTear", 244016)
	self:Log("SPELL_CAST_SUCCESS", "RealityTearSuccess", 244016)
	self:Log("SPELL_CAST_SUCCESS", "CollapsingWorld", 243983)
	self:Log("SPELL_CAST_START", "FelstormBarrage", 244000)
	self:Log("SPELL_CAST_SUCCESS", "TransportPortal", 244689)
	self:Log("SPELL_CAST_START", "HowlingShadows", 245504)
	self:Log("SPELL_CAST_START", "CatastrophicImplosion", 246075)

	--[[ Platform: Xoroth ]]--
	self:Log("SPELL_CAST_START", "FlamesofXoroth", 244607)
	self:Log("SPELL_CAST_SUCCESS", "Supernova", 244598)
	self:Log("SPELL_AURA_APPLIED", "EverburningFlames", 244613)
	self:Log("SPELL_AURA_REMOVED", "EverburningFlamesRemoved", 244613)
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
	self:Log("SPELL_AURA_APPLIED", "CloyingShadowsRemoved", 245118)
	self:Death("LordEilgarDeath", 122213)
end

function mod:OnEngage()
	realityTearCount = 1
	collapsingWorldCount = 1
	felstormBarrageCount = 1
	playerPlatform = 1

	self:Bar(244016, 7) -- Reality Tear
	self:Bar(243983, 12.7) -- Collapsing World
	self:Bar(244689, 21.9) -- Transport Portal
	self:Bar(244000, 29.0) -- Felstorm Barrage
	self:Berserk(720)

	nextPortalSoonWarning = 92 -- happens at 90%
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH_FREQUENT(unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < nextPortalSoonWarning then
		local platformName = (hp < 40 and self:SpellName(257942)) or (hp < 70 and self:SpellName(257941)) or self:SpellName(257939)
		local icon = (hp < 40 and "spell_mage_flameorb_purple") or (hp < 70 and "spell_mage_flameorb_green") or "spell_mage_flameorb"
		self:Message("stages", "Positive", nil, CL.soon:format(platformName), icon) -- Apocalypse Drive
		nextPortalSoonWarning = nextPortalSoonWarning - 30
		if nextPortalSoonWarning < 30 then
			self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unit)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
	if spellId == 257939 then -- Gateway: Xoroth
		self:Message("stages", "Positive", "Long", L.platform_active:format(self:SpellName(257939)), "spell_mage_flameorb") -- Platform: Xoroth
	elseif spellId == 257941 then -- Gateway: Rancora
		self:Message("stages", "Positive", "Long", L.platform_active:format(self:SpellName(257941)), "spell_mage_flameorb_green") -- Platform: Rancora
	elseif spellId == 257942 then -- Gateway: Nathreza
		self:Message("stages", "Positive", "Long", L.platform_active:format(self:SpellName(257942)), "spell_mage_flameorb_purple") -- Platform: Nathreza
	end
end

function mod:PlatformPortal(args)
	if self:Me(args.sourceGUID) then
		if args.spellId == 244073 then -- Xoroth
			playerPlatform = 2
		elseif args.spellId == 244136 then -- Rancora
			playerPlatform = 3
		elseif args.spellId == 244146 then -- Nathreza
			playerPlatform = 4
		end
	end
end

function mod:ReturnPortal(args)
	if self:Me(args.sourceGUID) then
		playerPlatform = 1
	end
end

function mod:RealityTear(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount > 1 and "Alarm", nil, nil, true)
end

function mod:RealityTearSuccess(args)
	realityTearCount = realityTearCount + 1
	self:Bar(args.spellId, 12.2) -- skips some casts for unknown reason
end

function mod:CollapsingWorld(args)
	self:Message(args.spellId, "Important", "Warning")
	collapsingWorldCount = collapsingWorldCount + 1
	self:Bar(args.spellId, self:Easy() and 37 or 32.8) -- XXX See if there is a pattern for delayed casts; normal: switches from 37 to 41.5 at some unknown point
end

function mod:FelstormBarrage(args)
	self:Message(args.spellId, "Urgent", "Alert")
	felstormBarrageCount = felstormBarrageCount + 1
	self:Bar(args.spellId, self:Easy() and 41.5 or 32.8) -- XXX See if there is a pattern for delayed casts; normal: sometimes 37 for the first few
end

function mod:TransportPortal(args)
	self:Message(args.spellId, "Neutral", "Info")
	self:Bar(args.spellId, 41.5) -- XXX See if there is a pattern for delayed casts
end

function mod:HowlingShadows(args)
	if self:Interrupter(args.sourceGUID) and playerPlatform == 1 then -- Can't interupt from other platforms
		self:Message(args.spellId, "Urgent", "Alarm")
	end
end

function mod:CatastrophicImplosion(args)
	self:Message(args.spellId, "Important", "Alarm")
end

function mod:FlamesofXoroth(args)
	if self:GetOption("custom_on_filter_platforms") and playerPlatform ~= 2 then return end
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "Urgent", "Alarm")
	end
	self:CDBar(args.spellId, 7.3) -- sometimes 8.5
end

function mod:Supernova(args)
	if self:GetOption("custom_on_filter_platforms") and playerPlatform ~= 2 then return end
	self:Message(args.spellId, "Attention", "Alert")
	self:CDBar(args.spellId, 2.5)
end

function mod:EverburningFlames(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Info", CL.you:format(args.spellName))
		self:SayCountdown(args.spellId, 10)
	end
end

function mod:EverburningFlamesRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:VulcanarDeath(args)
	self:Message("stages", "Positive", nil, L.add_killed:format(args.destName), "spell_mage_flameorb")
	self:StopBar(244598) -- Supernova
	self:StopBar(244607) -- Flames of Xoroth
end

function mod:FelsilkWrap(args)
	if self:GetOption("custom_on_filter_platforms") and playerPlatform ~= 3 then return end
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, true)
	self:CDBar(args.spellId, 17)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
end

function mod:PoisonEssence(args)
	if self:GetOption("custom_on_filter_platforms") and playerPlatform ~= 3 then return end
	self:Message(args.spellId, "Important", "Alarm")
	self:CDBar(args.spellId, 9.7)
end

function mod:CausticSlime(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Info", CL.you:format(args.spellName))
		self:SayCountdown(args.spellId, 20)
	end
end

function mod:CausticSlimeRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:LadyDacidionDeath(args)
	self:Message("stages", "Positive", nil, L.add_killed:format(args.destName), "spell_mage_flameorb_green")
	self:StopBar(244926) -- Felsilk Wrap
	self:StopBar(246316) -- Poison Essence
end

function mod:Delusions(args)
	if self:GetOption("custom_on_filter_platforms") and playerPlatform ~= 4 then return end
	self:Message(args.spellId, "Attention", "Alert", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 14.5)
end

function mod:Corrupt(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "Attention", amount > 2 and "Warning") -- Sound when stacks are 3 or higher
	end
end

function mod:CorruptSuccess(args)
	if self:GetOption("custom_on_filter_platforms") and playerPlatform ~= 4 then return end
	self:CDBar(args.spellId, 6.1)
end

function mod:CloyingShadows(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Info")
		self:SayCountdown(args.spellId, 30)
	end
end

function mod:CloyingShadowsRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:LordEilgarDeath(args)
	self:Message("stages", "Positive", nil, L.add_killed:format(args.destName), "spell_mage_flameorb_purple")
	self:StopBar(245050) -- Delusions
	self:StopBar(245040) -- Corrupt
end
