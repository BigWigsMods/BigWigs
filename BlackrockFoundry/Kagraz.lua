
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Flamebender Ka'graz", 988, 1123)
if not mod then return end
mod:RegisterEnableMob(76814, 77337) -- Flamebender Ka'graz, Aknor Steelbringer
mod.engageId = 1689
mod.respawnTime = 29.5

--------------------------------------------------------------------------------
-- Locals
--

local firestormCount = 1
local fixateOnMe = nil
local wolvesMarker, wolvesMarked = 3, {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.molten_torrent_self = "Molten Torrent on you"
	L.molten_torrent_self_desc = "Special countdown when Molten Torrent is on you."
	L.molten_torrent_self_icon = "spell_burningbladeshaman_molten_torrent"
	L.molten_torrent_self_bar = "You explode!"

	L.custom_off_wolves_marker = "Cinder Wolves marker"
	L.custom_off_wolves_marker_desc = "Mark Cinder Wolves with {rt3}{rt4}{rt5}{rt6}, requires promoted or leader."
	L.custom_off_wolves_marker_icon = 3
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Aknor Steelbringer ]]--
		156018, -- Devastating Slam
		156040, -- Drop the Hammer
		--[[ Ka'graz ]]--
		155318, -- Lava Slash
		-9352, -- Summon Enchanted Armaments
		{154932, "ICON", "FLASH", "SAY", "PROXIMITY"}, -- Molten Torrent
		{"molten_torrent_self", "SAY", "COUNTDOWN"},
		155776, -- Summon Cinder Wolves
		{155277, "ICON", "SAY", "FLASH", "PROXIMITY"}, -- Blazing Radiance
		155493, -- Firestorm
		{163284, "TANK"}, -- Rising Flames
		--[[ Cinder Wolf ]]--
		"custom_off_wolves_marker",
		{154952, "FLASH"}, -- Fixate
		{154950, "TANK"}, -- Overheated
		{155074, "TANK_HEALER"}, -- Charring Breath
		155064, -- Rekindle
		"proximity",
		"berserk",
	}, {
		[156018] = -9354, -- Aknor Steelbringer
		[155318] = -9350, -- Ka'graz
		["custom_off_wolves_marker"] = -9345, -- Cinder Wolf
		["proximity"] = "general"
	}
end

function mod:OnBossEnable()
	-- Aknor
	self:Log("SPELL_CAST_START", "DevastatingSlam", 156018)
	self:Log("SPELL_CAST_START", "DropTheHammer", 156040)
	-- Ka'graz
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_AURA_APPLIED", "LavaSlashDamage", 155314)
	self:Log("SPELL_PERIODIC_DAMAGE", "LavaSlashDamage", 155314)
	self:Log("SPELL_PERIODIC_MISSED", "LavaSlashDamage", 155314)
	self:Log("SPELL_AURA_APPLIED", "MoltenTorrentApplied", 154932)
	self:Log("SPELL_AURA_REMOVED", "MoltenTorrentRemoved", 154932)
	self:Log("SPELL_CAST_SUCCESS", "CinderWolves", 155776)
	self:Log("SPELL_AURA_APPLIED", "BlazingRadiance", 155277)
	self:Log("SPELL_AURA_REMOVED", "BlazingRadianceRemoved", 155277)
	self:Log("SPELL_AURA_APPLIED", "RisingFlames", 163284)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RisingFlames", 163284)
	-- Cinder Wolves
	self:Log("SPELL_AURA_APPLIED", "Fixate", 154952)
	self:Log("SPELL_AURA_REMOVED", "FixateOver", 154952)
	self:Log("SPELL_AURA_APPLIED", "Overheated", 154950)
	self:Log("SPELL_CAST_SUCCESS", "CharringBreathCast", 155074)
	self:Log("SPELL_AURA_APPLIED", "CharringBreath", 155074)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CharringBreath", 155074)
	self:Log("SPELL_CAST_START", "Rekindle", 155064)
	self:Log("SPELL_CAST_SUCCESS", "WolfDies", 181089) -- Encounter Event

	--self:Death("AknorDeath", 77337) -- Aknor Steelbringer
end

function mod:OnEngage()
	fixateOnMe = nil
	wolvesMarker = 3
	wipe(wolvesMarked)
	firestormCount = 1
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	if self:Ranged() then
		self:Bar(155318, 11) -- Lava Slash
		if not self:LFR() then
			self:OpenProximity("proximity", 6)
		end
	end
	self:Bar(154932, 31) -- Molten Torrent
	self:Bar(155776, 60) -- Summon Cinder Wolves
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	if self:GetOption("custom_off_wolves_marker") then
		for i=1, 5 do
			local unit = ("boss%d"):format(i)
			local guid = UnitGUID(unit)
			if guid and not wolvesMarked[guid] and self:MobId(guid) == 76794 then
				wolvesMarked[guid] = true
				SetRaidTarget(unit, wolvesMarker)
				wolvesMarker = wolvesMarker + 1
			end
		end
	end
end

do
	local prev = 0
	function mod:WolfDies()
		local t = GetTime()
		if t-prev > 5 then -- They all die at the same time
			prev = t
			self:StopBar(154952) -- Fixate
			self:StopBar(154950) -- Overheated
			self:StopBar(155064) -- Rekindle
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 154914 then -- Lava Slash
		self:Message(155318, "Urgent")
		if self:Ranged() then
			self:Bar(155318, 14.5)
		end
	elseif spellId == 163644 then -- Summon Enchanted Armaments
		self:Message(-9352, "Attention", nil, 175007, "inv_sword_1h_firelandsraid_d_04")
		self:Bar(-9352, self:Mythic() and 20 or 46, 175007, "inv_sword_1h_firelandsraid_d_04")
	elseif spellId == 155564 then -- Firestorm
		self:Message(155493, "Important", "Long", CL.count:format(self:SpellName(155493), firestormCount))
		firestormCount = firestormCount + 1
		self:Bar(155493, 14, CL.cast:format(spellName))

		--self:StopBar(155277) -- Blazing Radiance
		self:Bar(-9352, 18, 175007, "inv_sword_1h_firelandsraid_d_04") -- Summon Enchanted Armaments
		if self:Ranged() then
			self:Bar(155318, 28) -- Lava Slash
		end
		self:Bar(154932, 47) -- Molten Torrent
		self:Bar(155776, 76) -- Cinder Wolves
	end
end

do
	local prev = 0
	function mod:LavaSlashDamage(args)
		local t = GetTime()
		if t-prev > 1.5 and self:Me(args.destGUID) then
			prev = t
			self:Message(155318, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end

do
	local timeLeft, timer, timeLeft = 6, nil
	local function countdown(self)
		timeLeft = timeLeft - 1
		if timeLeft < 5 then
			self:Say("molten_torrent_self", timeLeft, true)
			if timeLeft < 2 then
				self:CancelTimer(timer)
				timer = nil
			end
		end
	end
	function mod:MoltenTorrentApplied(args)
		self:TargetMessage(args.spellId, args.destName, "Positive", "Warning") -- positive for wanting to stack
		self:Bar(args.spellId, 14.5)
		self:SecondaryIcon(args.spellId, args.destName)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
			timeLeft = 6
			self:Bar("molten_torrent_self", timeLeft, L.molten_torrent_self_bar, args.spellId)
			if not self:LFR() then
				if timer then self:CancelTimer(timer) end
				timer = self:ScheduleRepeatingTimer(countdown, 1, self)
			end
			self:OpenProximity(args.spellId, 8, nil, true)
		end
	end
	function mod:MoltenTorrentRemoved(args)
		self:SecondaryIcon(args.spellId)
		if self:Me(args.destGUID) then
			self:CloseProximity(args.spellId)
			if not self:LFR() and self:Ranged() then
				self:OpenProximity("proximity", 6)
			end
		end
	end
end

function mod:CinderWolves(args)
	if self:GetOption("custom_off_wolves_marker") then
		wolvesMarker = 3
		wipe(wolvesMarked)
	end

	self:Message(args.spellId, "Important", "Alarm")

	--self:Bar(155277, 32) -- Blazing Radiance
	self:Bar(155493, 62, CL.count:format(self:SpellName(155493), firestormCount)) -- Firestorm
	self:DelayedMessage(155493, 55, "Neutral", CL.soon:format(self:SpellName(155493)), nil, "Info") -- Firestorm
end

function mod:Fixate(args)
	if self:Me(args.destGUID) and not fixateOnMe then -- Multiple debuffs, warn for the first.
		fixateOnMe = true
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
		self:Flash(args.spellId)
		-- If we want a personal bar we will need to compensate for multiple debuffs
	end
end

function mod:FixateOver(args)
	if self:Me(args.destGUID) and not UnitDebuff("player", args.spellName) then
		fixateOnMe = nil
		self:Message(args.spellId, "Personal", "Alarm", CL.over:format(args.spellName))
	end
end

function mod:Overheated(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Info", nil, nil, true)
	self:Bar(args.spellId, 20)
	self:CDBar(155074, 6) -- Charring Breath
end

function mod:CharringBreathCast(args)
	self:CDBar(args.spellId, 6)
end

function mod:CharringBreath(args)
	if self:Tank(args.destName) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "Attention", amount > 2 and "Warning")
	end
end

function mod:Rekindle(args)
	self:TargetMessage(args.spellId, args.sourceName, "Positive", "Warning")
	self:Bar(args.spellId, 8)
end

do
	local blazingTargets = mod:NewTargetList()
	function mod:BlazingRadiance(args)
		--self:Bar(args.spellId, 12)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:OpenProximity(args.spellId, 10)
		end
		if self:Mythic() then -- Multiple targets in Mythic
			blazingTargets[#blazingTargets+1] = args.destName
			if #blazingTargets == 1 then
				self:ScheduleTimer("TargetMessage", 0.2, args.spellId, blazingTargets, "Attention", "Alert")
			end
		else
			self:TargetMessage(args.spellId, args.destName, "Attention", "Alert")
			self:PrimaryIcon(args.spellId, args.destName)
		end
	end

	function mod:BlazingRadianceRemoved(args)
		if self:Me(args.destGUID) then
			self:CloseProximity(args.spellId)
			if not self:LFR() and self:Ranged() then
				self:OpenProximity("proximity", 6)
			end
		end
		if not self:Mythic() then
			self:PrimaryIcon(args.spellId)
		end
	end
end

function mod:RisingFlames(args)
	local amount = args.amount or 1
	if amount % 3 == 0 then
		self:StackMessage(args.spellId, args.destName, amount, "Attention", amount > 5 and "Warning")
	end
end

-- Aknor Steelbringer

function mod:DevastatingSlam(args)
	self:Message(args.spellId, "Attention")
	--self:CDBar(args.spellId, 6) -- 6-10.9
end

function mod:DropTheHammer(args)
	self:Message(args.spellId, "Attention")
	--self:CDBar(args.spellId, 11) -- 11.3-14.4
end

--function mod:AknorDeath(args)
--	self:StopBar(156018)
--	self:StopBar(156040)
--end

