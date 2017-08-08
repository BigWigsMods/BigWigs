if not IsTestBuild() then return end -- XXX dont load on live

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Coven of Shivarra", nil, 1986, 1712)
if not mod then return end
mod:RegisterEnableMob(122468, 122467, 122469, 125436) -- Noura, Asara, Diima, Thu'raya
mod.engageId = 2073
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ General ]]--
		253203, -- Shivan Pact

		--[[ Noura, Mother of Flame ]]--
		244899, -- Fiery Strike
		245627, -- Whirling Saber
		253429, -- Fulminating Pulse

		--[[ Asara, Mother of Night ]]--
		245303, -- Touch of Darkness
		245281, -- Shadow Blades
		252861, -- Storm of Darkness

		--[[ Diima, Mother of Gloom ]]--
		{245518, "TANK"}, -- Flashfreeze
		245586, -- Chilled Blood
		253650, -- Orb of Frost

		--[[ Torment of the Titans ]]--
		250095, -- Machinations of Aman'Thul
		246763, -- Fury of Golganneth
		245671, -- Flames of Khaz'goroth
		245910, -- Spectral Army of Norgannon
	},{
		[253203] = "general",
		[244899] = -15967, -- Noura, Mother of Flame
		[245303] = -15968, -- Asara, Mother of Night
		[245518] = -15969, -- Diima, Mother of Gloom
		[250095] = -16138, -- Torment of the Titans
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:Log("SPELL_AURA_APPLIED", "ShivanPact", 253203)

	--[[ Noura, Mother of Flame ]]--
	self:Log("SPELL_CAST_SUCCESS", "FieryStrike", 244899)
	self:Log("SPELL_CAST_START", "WhirlingSaber", 245627)
	self:Log("SPELL_CAST_SUCCESS", "FulminatingPulse", 253429)

	--[[ Asara, Mother of Night ]]--
	self:Log("SPELL_CAST_START", "TouchofDarkness", 245303)
	self:Log("SPELL_CAST_SUCCESS", "ShadowBlades", 245281)
	self:Log("SPELL_CAST_START", "StormofDarkness", 252861)

	--[[ Diima, Mother of Gloom ]]--
	self:Log("SPELL_CAST_SUCCESS", "Flashfreeze", 245518)
	self:Log("SPELL_CAST_SUCCESS", "ChilledBlood", 245586)
	self:Log("SPELL_CAST_START", "OrbofFrost", 253650)

	--[[ Torment of the Titans ]]--
	self:Log("SPELL_CAST_SUCCESS", "MachinationsofAmanThul", 250095)
	self:Log("SPELL_CAST_SUCCESS", "FuryofGolganneth", 246763)
	self:Log("SPELL_CAST_START", "FlamesofKhazgoroth", 245671)
	self:Log("SPELL_CAST_SUCCESS", "SpectralArmyofNorgannon", 245910)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ General ]]--
function mod:ShivanPact(args)
	self:Message(args.spellId, "Important", "Info")
end

--[[ Noura, Mother of Flame ]]--
function mod:FieryStrike(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:WhirlingSaber(args)
	self:Message(args.spellId, "Urgent", "Alarm")
end

function mod:FulminatingPulse(args)
	self:Message(args.spellId, "Important", "Warning")
end

--[[ Asara, Mother of Night ]]--
function mod:TouchofDarkness(args)
	self:Message(args.spellId, "Urgent", "Alarm")
end

function mod:ShadowBlades(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:StormofDarkness(args)
	self:Message(args.spellId, "Important", "Warning")
end

--[[ Diima, Mother of Gloom ]]--
function mod:Flashfreeze(args)
	self:TargetMessage(args.spellId, args.destName, "Important", "Warning", nil, nil, true)
end

do
	local playerList = mod:NewTargetList()
	function mod:ChilledBlood(args)
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Neutral", "Alarm", nil, nil, self:Healer() and true) -- Always play a sound for healers
		end
	end
end

function mod:OrbofFrost(args)
	self:Message(args.spellId, "Attention", "Alert")
end

--[[ Torment of the Titans ]]--
function mod:MachinationsofAmanThul(args)
	self:Message(args.spellId, "Attention", "Long")
end

function mod:FuryofGolganneth(args)
	self:Message(args.spellId, "Urgent", "Warning")
end

function mod:FlamesofKhazgoroth(args)
	self:Message(args.spellId, "Urgent", "Warning")
end

function mod:SpectralArmyofNorgannon(args)
	self:Message(args.spellId, "Important", "Alarm")
end
