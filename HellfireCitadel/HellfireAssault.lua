
-- Notes --
-- vehicleData could be delayed a litte, since it takes some time between spawning and being attackable
-- some adds spawn from the vehicles, so we may not need 2 bars for one event (but skipping the add spawn looks weird too)

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Hellfire Assault", 1026, 1426)
if not mod then return end
mod:RegisterEnableMob(93023, 90019) -- Siegemaster Mar'tak, Reinforced Hellfire Door
mod.engageId = 1778
mod.respawnTime = 36 -- 30s respawn & 6s activation

--------------------------------------------------------------------------------
-- Locals
--
local engageTime = 0

local vehicleData = {
	-- normal / heroic, the data is from heroic, someone might need to do normal
	[1] = { -- left
		{137.6, "artillery"},
	},
	[2] = { -- center
		{38.0, "flamebelcher"},
		{109.2, "crusher"},
		{198.6, "demolisher"},
		{234.9, "flamebelcher"},
		{315.8, "demolisher"},
		{355.2, "flamebelcher"},
	},
	[3] = { -- right
		{296.2, "artillery"},
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
		{56.0, "artillery"},
		{73.7, "demolisher"},
		{125.2, "flamebelcher"},
		{161.4, "artillery"},
		{276.9, "flamebelcher"},
		{354.3, "demolisher"},
		{388.9, "flamebelcher"},
		{427.9, "demolisher"},
	},
	[2] = { -- center
		{173.5, "transporter"},
		{180.5, "crusher"},
		{204.2, "demolisher"},
	},
	[3] = { -- right
		{53.8, "artillery"},
		{81.3, "flamebelcher"},
		{132.2, "demolisher"},
		{166.3, "flamebelcher"},
		{277.6, "artillery"},
		{361.2, "transporter"},
		{395.9, "demolisher"},
		{433.6, "flamebelcher"},
	},
}

local addData = {
	-- normal / heroic, from heroic, normal may be less. some spawns are random, so no splitting to sides
	[1] = { -- left

	},
	[2] = { -- center
		{ 18, "dragoons"},
		{ 35, "adds"},
		{ 44, "adds"},
		{ 67, "adds"},
		{ 99, "adds"},
		{127, "adds"},
		{139, "adds"},
		{156, "adds"},
		{182, "adds"},
		{221, "adds"},
		{233, "adds"},
		{254, "adds"},
		{281, "adds"},
		{303, "adds"},
		{341, "adds"},
		{369, "adds"},
	},
	[3] = { -- right

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
		{ 84, "adds"}, -- 2 felcaster, 1 berserker
		{141, "adds"}, -- 2 engineers, 1 berserker
		{364, "adds"}, -- 2 felcaster, dragoons
		{403, "adds"}, -- 1 berserker, dragoons
		{441, "adds"}, -- 1 berserker, 2 engineers
	},
	[2] = { -- center
		{ 19, "dragoons"}, -- dragoons
		{ 30, "berserker"}, -- 1 berserker
		{ 34, "adds"}, -- 1 felcaster, 1 engineer, dragoons
		{ 45, "adds"}, -- 2 felcaster
		{195, "urogg"}, -- urogg, dragoons from transporter, felcasters and everything everywhere
		{215, "grute"}, -- grute, 2 felcaster, dragoons
		{254, "dragoons"}, -- dragoons
		{261, "adds"}, -- 2 felcaster,  berserker
	},
	[3] = { -- right
		{ 92, "adds"}, -- 1 berserker, dragoons
		{141, "adds"}, -- 1 berserker, 2 engineers
		{332, "adds"}, -- 1 felcaster, 1 engineer, dragoons
		{364, "adds"}, -- 1 berserker
		{403, "adds"}, -- 1 berserker, 2 felcaster
		{441, "adds"}, -- 1 berserker, 2 felcaster
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
		{190748, "FLASH", "SAY"}, -- Cannonball (Grute)
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
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Attention", "Alarm")
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
	if self:Range(args.destName) < 42 then
		self:StackMessage(args.spellId, args.destName, args.amount, "Urgent")
	end
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
		if self:Range(args.destName) < 42 then
			list[#list+1] = args.destName
			if #list == 1 then
				self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Attention")
			end
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

do
	local function printTarget(self, name, guid)
		self:TargetMessage(190748, name, "Attention", "Info", nil, nil, true)
		if self:Me(guid) then
			self:Say(190748)
			self:Flash(190748)
		end
	end
	function mod:Cannonball(args)
		self:GetBossTarget(printTarget, 0.3, args.sourceGUID)
		self:Bar(args.spellId, 12)
	end
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

