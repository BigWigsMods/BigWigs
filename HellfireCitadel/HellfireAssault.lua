
-- Notes --
-- vehicleData could be delayed a litte, since it takes some time between spawning and being attackable
-- some adds spawn from the vehicles, so we may not need 2 bars for one event (but skipping the add spawn looks weird too)

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Hellfire Assault", 1026, 1426)
if not mod then return end
mod:RegisterEnableMob(93023, 90019, 90018) -- Siegemaster Mar'tak, Reinforced Hellfire Door, Hellfire Cannon
mod.engageId = 1778
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--
local engageTime = 0

local vehicleData = {
	-- normal / heroic
	[1] = { -- left
		{169.3, "artillery"},
	},
	[2] = { -- center
		{38.7, "flamebelcher"},
		{110.0, "crusher"},
		{233.7, "demolisher"},
		{285.2, "flamebelcher"},
		{395.5, "demolisher"},
		{416.8, "flamebelcher"},
	},
	[3] = { -- right
		{350.0, "artillery"},
	},
}

local vehicleDataLFR = {
	[1] = { -- left

	},
	[2] = { -- center

	},
	[3] = { -- right

	},
}

local vehicleDataMythic = { -- SPELL_AURA_APPLIED 180927
	[1] = { -- left
		{56.4, "artillery"},
		{73.5, "demolisher"},
		{128.3, "flamebelcher"},
		{173.0, "artillery"},
		{302.9, "flamebelcher"},
		{353.0, "demolisher"},
	},
	[2] = { -- center
		{185.4, "transporter"},
		{196.2, "crusher"},
		{235.6, "demolisher"},
	},
	[3] = { -- right
		{53.9, "artillery"},
		{80.8, "flamebelcher"},
		{135.2, "demolisher"},
		{180.8, "flamebelcher"},
		{306.1, "artillery"},
	},
	--	{361.1, "transporter"}, captured spawn event, but position unknown
}

local addData = {
	-- normal / heroic
	[1] = { -- left
		{ 67, "adds"},
		{ 76, "adds"},
		{108, "adds"},
		{119, "berserker"},
		{140, "adds"},
		{178, "berserker"},
		{231, "berserker"},
		{257, "adds"},
		{267, "adds"},
		{295, "adds"},
		{399, "berserker"},
	},
	[2] = { -- center
		{ 18, "dragoons"},
		{ 30, "berserker"},
		{ 82, "berserker"},
		{104, "berserker"},
		{225, "adds"}, -- earlier?
		{367, "adds"},
		{399, "adds"},
	},
	[3] = { -- right
		{ 35, "adds"},
		{ 44, "adds"},
		{ 73, "adds"},
		{142, "berserker"},
		{153, "dragoons"},
		{180, "adds"},
		{295, "berserker"},
		{304, "adds"},
		{329, "dragoons"},
		{367, "adds"},
	},
}

local addDataLFR = {
	[1] = { -- left

	},
	[2] = { -- center

	},
	[3] = { -- right

	},
}

local addDataMythic = {
	[1] = { -- left
		{ 19, "dragoons"}, -- dragoons
		{ 35, "adds"}, -- 1 felcaster, 1 engineer, dragoons
		{ 84, "adds"}, -- 2 felcaster, 1 berserker
		{145, "adds"}, -- 2 engineers, 1 berserker
		{268, "adds"}, -- 1 felcaster, 1 engineer, dragoons
		{286, "adds"}, -- 1 felcaster, dragoons
		{332, "adds"}, -- 2 felcaster, 1 berserker
	},
	[2] = { -- center
		{ 30, "berserker"}, -- 1 berserker
		{195, "urogg"}, -- urogg, dragoons from transporter
		{245, "grute"}, -- grute, 2 felcaster
		{291, "berserker"}, -- 1 berserker
	},
	[3] = { -- right
		{ 45, "adds"}, -- 2 felcaster
		{ 96, "adds"}, -- 1 berserker, dragoons
		{145, "adds"}, -- 1 berserker, 2 engineers
		{258, "dragoons"}, -- dragoons
		{301, "adds"}, -- 2 felcaster
		{332, "adds"}, -- 1 felcaster, 1 berserker, 1 engineer, dragoons
	},
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	-- Siege Verhicles
	L.siegevehicles = -11428
	L.siegevehicles_icon = 125914 -- ability_vehicle_siegeenginecannon

	L.crusher = -11439
	L.crusher_icon = 180022 -- Bore / spell_nature_lightningoverload

	L.flamebelcher = -11437
	L.flamebelcher_icon = 186883 -- Belch Flame / spell_fire_felflamebolt

	L.artillery = -11435
	L.artillery_icon = 180080 -- Artillery Blast / inv_misc_missilelarge_red

	L.demolisher = -11429
	L.demolisher_icon = 180945 -- Siege Nova / spell_fire_felfirenova

	L.transporter = -11712
	L.transporter_icon = 185021 -- Call to Arms! / achievement_bg_killflagcarriers_grabflag_capit

	-- Add types
	L.adds = CL.adds
	L.adds_icon = 186782 -- Render the Orc Crowd / achievement_character_orc_male_brn

	L.dragoons = -11407
	L.dragoons_icon = 150456 -- Shadowmoon Orc Disguise / achievement_character_orc_male

	L.berserker = -11425
	L.berserker_icon = 184243 -- Slam / inv_misc_volatileearth

	L.urogg = -11912
	L.urogg_icon = 184065 -- Corruption Bolt / spell_warlock_demonbolt

	L.grute = -11916
	L.grute_icon = 190748 -- Cannonball / ability_vehicle_launchplayer

	-- Spawn Positions
	L.left   = "Left: %s"
	L.middle = "Middle: %s"
	L.right  = "Right: %s"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Mar'tak ]]--
		{184369, "FLASH", "SAY"}, -- Howling Axe
		184394, -- Shockwave
		185090, -- Inspiring Presence
		--[[ Reinforcements ]]--
		"adds",
		{184243, "TANK"}, -- Slam
		184238, -- Cower!
		185816, -- Repair
		185806, -- Conducted Shock Pulse
		181968, -- Metamorphosis
		180417, -- Felfire Volley
		--[[ Siege Vehicles ]]--
		"siegevehicles",
		180945, -- Siege Nova
		--186845, -- Flameorb  got removed?!
		188101, -- Belch Flame
		180184, -- Crush
		190748, -- Cannonball (Grute)
		185021, -- Call to Arms (Transporter)
	}, {
		[184369] = -11484, -- Mar'tak
		["adds"] = -11406, -- Reinforcements
		["siegevehicles"] = -11428, -- Siege Vehicles
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "HowlingAxe", 184369)
	self:Log("SPELL_AURA_REMOVED", "HowlingAxeRemoved", 184369)
	self:Log("SPELL_CAST_START", "Shockwave", 184394)
	--self:Log("SPELL_AURA_APPLIED", "InspiringPresence", 185090)
	self:Log("SPELL_AURA_APPLIED", "Slam", 184243)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Slam", 184243)
	self:Log("SPELL_CAST_START", "Cower", 184238)
	self:Log("SPELL_CAST_START", "Repair", 185816)
	self:Log("SPELL_AURA_APPLIED", "ConductedShockPulse", 185806)
	self:Log("SPELL_CAST_START", "Metamorphosis", 181968)
	--self:Log("SPELL_CAST_START", "FelfireVolley", 180417, 183452)
	self:Log("SPELL_CAST_START", "SiegeNova", 180945)
	--self:Log("SPELL_CAST_START", "Flameorb", 186845)  got removed?!
	self:Log("SPELL_CAST_START", "BelchFlame", 188101, 186883)
	self:Log("SPELL_CAST_START", "Crush", 180184)
	self:Log("SPELL_CAST_START", "Cannonball", 190748)
	self:Log("SPELL_CAST_START", "CallToArms", 185021)
	self:Death("Deaths", 93023, 95653, 93435)
end

function mod:OnEngage()
	engageTime = GetTime()

	self:Bar(184369, 7) -- Howling Axe
	self:Bar(184394, 6) -- Shockwave

	for i = 1,3 do
		self:StartVehicleTimer(i, 1)
		self:StartAddTimer(i, 1)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local list = mod:NewTargetList()
	function mod:HowlingAxe(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, "Attention", "Alarm")
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:Flash(args.spellId)
			self:TargetBar(args.spellId, 7, args.destName)
			self:OpenProximity(args.spellId, 8)
		else
			self:CDBar(args.spellId, 8)
		end
	end
end

function mod:HowlingAxeRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

function mod:Shockwave(args)
	self:Message(args.spellId, "Urgent", "Info", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 8.5)
end

do
	local prev = 0
	function mod:InspiringPresence(args)
		local t = GetTime()
		if t-prev > 3 then
			prev = t
			self:Message(args.spellId, "Positive")
			self:Bar(args.spellId, 15)
		end
	end
end

function mod:Slam(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Urgent")
end

function mod:Cower(args)
	self:Message(args.spellId, "Urgent", "Info", CL.casting:format(args.spellName))
end

function mod:Repair(args)
	self:Message(args.spellId, "Important", "Alert", CL.casting:format(args.spellName))
end

do
	local list = mod:NewTargetList()
	function mod:ConductedShockPulse(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, "Attention")
		end
	end
end

function mod:Metamorphosis(args)
	self:Message(args.spellId, "Positive")
end

function mod:FelfireVolley(args)
	self:Message(180417, "Urgent", "Info", CL.casting:format(args.spellName))
end

function mod:SiegeNova(args)
	self:Message(args.spellId, "Urgent", "Long", CL.incoming:format(args.spellName))
end

function mod:Flameorb(args)
	self:Message(args.spellId, "Important")
end

function mod:BelchFlame(args)
	self:Message(188101, "Important")
end

function mod:CallToArms(args)
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 9)
end

function mod:Crush(args)
	self:Message(args.spellId, "Urgent", "Long", CL.incoming:format(args.spellName))
end

function mod:Cannonball(args)
	self:Message(args.spellId, "Attention", "Info")
	self:Bar(args.spellId, 12)
end

function mod:StartVehicleTimer(lane, count)
	local data = self:Mythic() and vehicleDataMythic or self:LFR() and vehicleDataLFR or vehicleData
	local info = data and data[lane][count]
	if not info then
		-- all out of vehicle data
		return
	end

	local time, type = unpack(info)
	local length = floor(time - (GetTime() - engageTime))
	local pos = lane == 1 and L.left or lane == 2 and L.middle or L.right

	self:DelayedMessage("siegevehicles", length, "Neutral", CL.incoming:format(pos:format(self:SpellName(L[type]))), L[type.."_icon"], "Info")
	self:Bar("siegevehicles", length, pos:format(self:SpellName(L[type])), L[type.."_icon"])
	self:ScheduleTimer("StartVehicleTimer", length, lane, count+1)
end

function mod:StartAddTimer(lane, count)
	local data = self:Mythic() and addDataMythic or self:LFR() and addDataLFR or addData
	local info = data and data[lane][count]
	if not info then
		-- all out of add data
		return
	end

	local time, type = unpack(info)
	local length = floor(time - (GetTime() - engageTime))
	local pos = lane == 1 and L.left or lane == 2 and L.middle or L.right

	self:DelayedMessage("adds", length, "Neutral", CL.spawned:format(pos:format(type == "adds" and L[type] or self:SpellName(L[type]))), L[type.."_icon"])
	self:Bar("adds", length, pos:format(type == "adds" and L[type] or self:SpellName(L[type])), L[type.."_icon"])
	self:ScheduleTimer("StartAddTimer", length, lane, count+1)
end

function mod:Deaths(args)
	if args.mobId == 93023 then -- Siegemaster Mar'tak
		self:StopBar(184394) -- Shockwave
		self:StopBar(184369) -- Howling Axe
	elseif args.mobId == 95653 then -- Grute
		self:StopBar(190748) -- Cannonball
	elseif args.mobId == 93435 then -- Transporter
		self:StopBar(185021) -- Call To Arms
	end
end

