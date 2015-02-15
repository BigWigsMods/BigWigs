
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Flamebender Ka'graz", 988, 1123)
if not mod then return end
mod:RegisterEnableMob(76814, 77337) -- Flamebender Ka'graz, Aknor Steelbringer
mod.engageId = 1689


--------------------------------------------------------------------------------
-- Locals
--

local wolvesActive = nil
local moltenTorrentOnMe = nil
local blazingTarget = nil
local firestormCount = 1
local fixateOnMe = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.molten_torrent_self = "Molten Torrent on you"
	L.molten_torrent_self_desc = "Special countdown when Molten Torrent is on you."
	L.molten_torrent_self_icon = "spell_burningbladeshaman_molten_torrent"
	L.molten_torrent_self_bar = "You explode!"
end
L = mod:GetLocale()

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
		{"molten_torrent_self", "SAY"},
		155776, -- Summon Cinder Wolves
		{155277, "ICON", "SAY", "FLASH", "PROXIMITY"}, -- Blazing Radiance
		155493, -- Firestorm
		{163284, "TANK"}, -- Rising Flames
		--[[ Cinder Wolf ]]--
		{154952, "FLASH"}, -- Fixate
		{154950, "TANK"}, -- Overheated
		{155074, "TANK_HEALER"}, -- Charring Breath
		155064, -- Rekindle
		"berserk",
		"bosskill"
	}, {
		[156018] = -9354, -- Aknor Steelbringer
		[155318] = -9350, -- Ka'graz
		[154952] = -9345, -- Cinder Wolf
		["berserk"] = "general"
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")

	-- Aknor
	self:Log("SPELL_CAST_START", "DevastatingSlam", 156018)
	self:Log("SPELL_CAST_START", "DropTheHammer", 156040)
	-- Ka'graz
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_AURA_APPLIED", "LavaSlashDamage", 155314)
	self:Log("SPELL_DAMAGE", "LavaSlashDamage", 155318)
	self:Log("SPELL_MISSED", "LavaSlashDamage", 155318)
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
	self:Log("SPELL_AURA_APPLIED", "CharringBreath", 155074)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CharringBreath", 155074)
	self:Log("SPELL_CAST_START", "Rekindle", 155064)

	--self:Death("AknorDeath", 77337) -- Aknor Steelbringer
end

function mod:OnEngage()
	wolvesActive = nil
	moltenTorrentOnMe, blazingTarget, fixateOnMe = nil, nil, nil
	firestormCount = 1
	--self:Bar(155318, 11) -- Lava Slash
	self:Bar(154938, 31) -- Molten Torrent
	self:Bar(155776, 60) -- Summon Cinder Wolves
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	self:CheckForEncounterEngage()
	-- XXX wolves don't have UNIT_DIED or other events to indicate they were killed afaik
	if wolvesActive then
		for i=1, 5 do
			local unit = ("boss%d"):format(i)
			if self:MobId(UnitGUID(unit)) == 76794 then
				return
			end
		end
		-- still here so no wolves up!
		wolvesActive = nil
		self:StopBar(154952) -- Fixate
		self:StopBar(154950) -- Overheated
		self:StopBar(155064) -- Rekindle
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 154914 then -- Lava Slash
		self:Message(155318, "Urgent")
		--self:Bar(155318, 14.5)
	elseif spellId == 163644 then -- Summon Enchanted Armaments
		self:Message(-9352, "Attention", nil, 175007, "inv_sword_1h_firelandsraid_d_04")
		self:Bar(-9352, self:Mythic() and 20 or 46, 175007, "inv_sword_1h_firelandsraid_d_04")
	elseif spellId == 155564 then -- Firestorm
		self:Message(155493, "Important", "Long", CL.count:format(self:SpellName(155493), firestormCount))
		firestormCount = firestormCount + 1
		self:Bar(155493, 14, CL.cast:format(spellName))

		--self:StopBar(155277) -- Blazing Radiance
		self:Bar(-9352, 18, 175007, "inv_sword_1h_firelandsraid_d_04") -- Summon Enchanted Armaments
		--self:Bar(155318, 28) -- Lava Slash
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
	local timeLeft, timer, timeLeft = 5, nil
	local function countdown(self)
		timeLeft = timeLeft - 1
		self:Say("molten_torrent_self", timeLeft, true)
		if timeLeft < 2 then
			self:CancelTimer(timer)
			timer = nil
		end
	end
	function mod:MoltenTorrentApplied(args)
		self:TargetMessage(args.spellId, args.destName, "Positive", "Warning") -- positive for wanting to stack
		self:Bar(args.spellId, 14.5)
		self:SecondaryIcon(args.spellId, args.destName)
		self:ScheduleTimer("SecondaryIcon", 5, args.spellId)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
			if not self:LFR() then
				timeLeft = 5
				if timer then self:CancelTimer(timer) end
				timer = self:ScheduleRepeatingTimer(countdown, 1, self)
			end
			self:OpenProximity(args.spellId, 8, nil, true)
			moltenTorrentOnMe = true
		end
	end
	function mod:MoltenTorrentRemoved(args)
		if self:Me(args.destGUID) then
			moltenTorrentOnMe = nil
			self:CloseProximity(args.spellId)
			if blazingTarget then
				self:OpenProximity(155277, 10, blazingTarget)
			end
		end
	end
end

function mod:CinderWolves(args)
	self:Message(args.spellId, "Important", "Alarm")
	wolvesActive = true

	--self:Bar(155277, 32) -- Blazing Radiance
	self:Bar(155493, 62, CL.count:format(self:SpellName(155493), firestormCount)) -- Firestorm
	self:DelayedMessage(155493, 55, "Neutral", CL.soon:format(self:SpellName(155493)), nil, "Info") -- Firestorm
end

do
	local scheduled = nil
	local function startBar(self, spellId)
		if not fixateOnMe and (self:Healer() or self:Damager() == "RANGED") then
			self:Bar(spellId, 10)
		end
		fixateOnMe = nil
		scheduled = nil
	end
	function mod:Fixate(args)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
			self:TargetBar(args.spellId, 10, args.destName)
			self:Flash(args.spellId)
			fixateOnMe = true
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(startBar, 0.1, self, args.spellId)
		end
	end
end

function mod:FixateOver(args)
	self:StopBar(args.spellId, args.destName)
end

function mod:Overheated(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Info")
	self:Bar(args.spellId, 20)
	--self:CDBar(155074, 5) -- Charring Breath
end

function mod:CharringBreath(args)
	local amount = args.amount or 1
	if self:Mythic() or amount % 2 == 0 then
		self:StackMessage(args.spellId, args.destName, amount, "Attention", amount > 2 and "Warning")
	end
end

function mod:Rekindle(args)
	self:TargetMessage(args.spellId, args.sourceName, "Positive", "Warning")
	self:Bar(args.spellId, 8)
end

function mod:BlazingRadiance(args)
	--self:Bar(args.spellId, 12)
	self:PrimaryIcon(args.spellId, args.destName)
	blazingTarget = args.destName
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
		self:OpenProximity(args.spellId, 10)
	else
		if not moltenTorrentOnMe then
			self:OpenProximity(args.spellId, 10, args.destName)
		end
		if self:Range(args.destName) < 10 then
			self:RangeMessage(args.spellId)
			self:Flash(args.spellId)
			return
		end
	end
	self:TargetMessage(args.spellId, args.destName, "Attention", "Alert")
end

function mod:BlazingRadianceRemoved(args)
	self:PrimaryIcon(args.spellId)
	blazingTarget = nil
	if not moltenTorrentOnMe then
		self:CloseProximity(args.spellId)
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

function mod:AknorDeath(args)
	self:StopBar(156018)
	self:StopBar(156040)
end

