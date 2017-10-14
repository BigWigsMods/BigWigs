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

local stage = 1
local realityTearCount = 1
local collapsingWorldCount = 1
local felstormBarrageCount = 1
local playerPlatform = 1 -- 1: Nexus, 2: Xoroth, 3: Rancora, 4: Nathreza

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_filter_platforms = "Filter Side Platform Warnings and Bars"
	L.custom_on_filter_platforms_desc = "Removes unnecessary messages and bars if you are not on a side platform. It will always show bars and warnings from the main Platform: Nexus."
	L.platform_active = "%s Active!" -- Platform: Xoroth Active!
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
		244613, -- Everburning Flames

		--[[ Platform: Rancora ]]--
		{244926, "SAY"}, -- Felsilk Wrap
		246316, -- Poison Essence
		244849, -- Caustic Slime

		--[[ Platform: Nathreza ]]--
		{245050, "HEALER"}, -- Delusions
		245040, -- Corrupt
		245118, -- Cloying Shadows
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

	--[[ Platform: Rancora ]]--
	self:Log("SPELL_CAST_SUCCESS", "FelsilkWrap", 244926)
	self:Log("SPELL_CAST_START", "PoisonEssence", 246316)
	self:Log("SPELL_AURA_APPLIED", "CausticSlime", 244849)

	--[[ Platform: Nathreza ]]--
	self:Log("SPELL_CAST_START", "Delusions", 245050)
	self:Log("SPELL_AURA_APPLIED", "Corrupt", 245040)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Corrupt", 245040)
	self:Log("SPELL_CAST_SUCCESS", "CorruptSuccess", 245040)
	self:Log("SPELL_AURA_APPLIED", "CloyingShadows", 245040)
end

function mod:OnEngage()
	stage = 1
	realityTearCount = 1
	collapsingWorldCount = 1
	felstormBarrageCount = 1
	playerPlatform = 1

	self:Bar(244016, 7) -- Reality Tear
	self:Bar(243983, 12.7) -- Collapsing World
	self:Bar(244689, 21.9) -- Transport Portal
	self:Bar(244000, 29.0) -- Felstorm Barrage
	self:Berserk(750) -- Heroic PTR
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
	if spellId == 257939 then -- Gateway: Xoroth
		self:Message("stages", "Positive", "Long", L.platform_active:format(self:SpellName(257939)), false) -- Platform: Xoroth
	elseif spellId == 257941 then -- Gateway: Rancora
		self:Message("stages", "Positive", "Long", L.platform_active:format(self:SpellName(257941)), false) -- Platform: Rancora
	elseif spellId == 257942 then -- Gateway: Nathreza
		self:Message("stages", "Positive", "Long", L.platform_active:format(self:SpellName(257942)), false) -- Platform: Nathreza
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
	self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount > 4 and "Alarm", nil, nil, true) -- Start sound warning at 5+
end

function mod:RealityTearSuccess(args)
	realityTearCount = realityTearCount + 1
	self:Bar(args.spellId, realityTearCount % 4 == 0 and 14.6 or 12.2)
end

function mod:CollapsingWorld(args)
	self:Message(args.spellId, "Important", "Warning")
	collapsingWorldCount = collapsingWorldCount + 1
	self:Bar(args.spellId, 32.8) -- XXX See if there is a pattern for delayed casts
end

function mod:FelstormBarrage(args)
	self:Message(args.spellId, "Urgent", "Alert")
	felstormBarrageCount = felstormBarrageCount + 1
	self:Bar(args.spellId, 32.8) -- XXX See if there is a pattern for delayed casts
end

function mod:TransportPortal(args)
	self:Message(args.spellId, "Neutral", "Info")
	self:Bar(args.spellId, 41.5) -- XXX See if there is a pattern for delayed casts
end

function mod:HowlingShadows(args)
	if self:Interrupter(args.sourceGUID) and platform == 1 then -- Can't interupt from other platforms
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
	self:CDBar(args.spellId, 7.3)
end

function mod:Supernova(args)
	if self:GetOption("custom_on_filter_platforms") and playerPlatform ~= 2 then return end
	self:Message(args.spellId, "Attention", "Alert")
	self:CDBar(args.spellId, 6.5)
end

function mod:EverburningFlames(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Info", CL.you:format(args.spellName))
	end
end

function mod:FelsilkWrap(args)
	if self:GetOption("custom_on_filter_platforms") and playerPlatform ~= 3 then return end
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, true)
	self:CDBar(args.spellId, 17.5)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
end

function mod:PoisonEssence(args)
	if self:GetOption("custom_on_filter_platforms") and playerPlatform ~= 3 then return end
	self:Message(args.spellId, "Important", "Alarm")
	self:CDBar(args.spellId, 9.5)
end

function mod:CausticSlime(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Info", CL.you:format(args.spellName))
	end
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
	self:CDBar(args.spellId, 8.5)
end

function mod:CloyingShadows(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Info")
	end
end
