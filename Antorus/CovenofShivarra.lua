--------------------------------------------------------------------------------
-- TODO:
-- -- List which Titan abilities can be used next in the infobox?
-- -- Warnings when not in a safe area during Storm of Darkness

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Coven of Shivarra", nil, 1986, 1712)
if not mod then return end
mod:RegisterEnableMob(122468, 122467, 122469, 125436) -- Noura, Asara, Diima, Thu'raya
mod.engageId = 2073
mod.respawnTime = 15

--------------------------------------------------------------------------------
-- Locals
--

local L = mod:GetLocale()
if L then
	L.torment_of_the_titans = mod:SpellName(-16138) -- Torment of the Titans
	L.torment_of_the_titans_desc = "The Shivvara will force the titan souls to use their abilities against the players."
	L.torment_of_the_titans_icon = 245910 -- Spectral Army of Norgannon
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ General ]]--
		"stages",
		253203, -- Shivan Pact
		"torment_of_the_titans",

		--[[ Noura, Mother of Flame ]]--
		{244899, "TANK"}, -- Fiery Strike
		245627, -- Whirling Saber
		253429, -- Fulminating Pulse

		--[[ Asara, Mother of Night ]]--
		245303, -- Touch of Darkness
		246329, -- Shadow Blades
		252861, -- Storm of Darkness

		--[[ Diima, Mother of Gloom ]]--
		{245518, "TANK_HEALER"}, -- Flashfreeze
		245586, -- Chilled Blood
		253650, -- Orb of Frost

	},{
		[253203] = "general",
		[244899] = -15967, -- Noura, Mother of Flame
		[245303] = -15968, -- Asara, Mother of Night
		[245518] = -15969, -- Diima, Mother of Gloom
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterUnitEvent("UNIT_TARGETABLE_CHANGED", nil, "boss1", "boss2", "boss3", "boss4")
	self:Log("SPELL_AURA_APPLIED", "ShivanPact", 253203)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	--[[ Noura, Mother of Flame ]]--
	self:Log("SPELL_AURA_APPLIED", "FieryStrike", 244899)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FieryStrike", 244899)
	self:Log("SPELL_CAST_SUCCESS", "FieryStrikeSuccess", 244899)
	self:Log("SPELL_CAST_START", "WhirlingSaber", 245627)
	self:Log("SPELL_AURA_APPLIED", "FulminatingPulse", 253429)
	self:Log("SPELL_AURA_REMOVED", "FulminatingPulseRemoved", 253429)

	--[[ Asara, Mother of Night ]]--
	self:Log("SPELL_CAST_START", "TouchofDarkness", 245303)
	self:Log("SPELL_CAST_SUCCESS", "ShadowBlades", 246329)
	self:Log("SPELL_CAST_START", "StormofDarkness", 252861)

	--[[ Diima, Mother of Gloom ]]--
	self:Log("SPELL_CAST_SUCCESS", "Flashfreeze", 245518)
	self:Log("SPELL_AURA_APPLIED", "ChilledBlood", 245586)
	self:Log("SPELL_CAST_START", "OrbofFrost", 253650) -- XXX Bugged and not cast on PTR
end

function mod:OnEngage()
	self:Bar(245627, 8.5) -- Whirling Saber
	self:Bar(244899, 12.1) -- Fiery Strike
	self:Bar(253429, 20.6) -- Fulminating Pulse

	self:Bar(246329, 12.1) -- Shadow Blades
	self:Bar(252861, 27.9) -- Storm of Darkness

	self:CDBar("torment_of_the_titans", 82, L.torment_of_the_titans, L.torment_of_the_titans_icon)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ General ]]--
function mod:UNIT_TARGETABLE_CHANGED(unit)
	if self:MobId(UnitGUID(unit)) == 122468 then -- Noura
		if UnitCanAttack("player", unit) then
			self:Message("stages", "Positive", "Long", self:SpellName(-15967), false) -- Noura, Mother of Flame
			self:Bar(245627, 8.9) -- Whirling Saber
			self:Bar(244899, 12.5) -- Fiery Strike
			self:Bar(253429, 21.1) -- Fulminating Pulse
		else
			self:StopBar(244899) -- Fiery Strike
			self:StopBar(245627) -- Whirling Saber
			self:StopBar(253429) -- Fulminating Pulse
		end
	elseif self:MobId(UnitGUID(unit)) == 122467 then -- Asara
		if UnitCanAttack("player", unit) then
			self:Message("stages", "Positive", "Long", self:SpellName(-15968), false) -- Asara, Mother of Night
			self:Bar(246329, 12.6) -- Shadow Blades
			self:Bar(252861, 28.4) -- Storm of Darkness
		else
			self:StopBar(246329) -- Shadow Blades
			self:StopBar(252861) -- Storm of Darkness
		end
	elseif self:MobId(UnitGUID(unit)) == 122469 then -- Diima
		if UnitCanAttack("player", unit) then
			self:Message("stages", "Positive", "Long", self:SpellName(-15969), false) -- Diima, Mother of Gloom
			self:Bar(245586, 8) -- Chilled Blood
			self:Bar(245518, 12.2) -- Flashfreeze
			self:Bar(253650, 30) -- Orb of Frost
		else
			self:StopBar(245518) -- Flashfreeze
			self:StopBar(245586) -- Chilled Blood
			self:StopBar(253650) -- Orb of Frost
		end
	elseif self:MobId(UnitGUID(unit)) == 125436 then -- Thu'raya
		if UnitCanAttack("player", unit) then
			self:Message("stages", "Positive", "Long", self:SpellName(-16398), false) -- Thu'raya, Mother of the Cosmos
		end
	end
end

do
	local prev = 0
	function mod:ShivanPact(args)
		local t = GetTime()
		if t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Important", "Info")
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	if msg:find("250095", nil, true) then -- Machinations of Aman'thul
		self:Message("torment_of_the_titans", "Important", "Warning", CL.incoming:format(self:SpellName(250095)), 250095) -- Machinations of Aman'thul
		self:CDBar("torment_of_the_titans", 93.5, L.torment_of_the_titans, L.torment_of_the_titans_icon)
	elseif msg:find("245671", nil, true) then -- Flames of Khaz'goroth
		self:Message("torment_of_the_titans", "Important", "Warning", CL.incoming:format(self:SpellName(245671)), 245671) -- Machinations of Aman'thul
		self:CDBar("torment_of_the_titans", 93.5, L.torment_of_the_titans, L.torment_of_the_titans_icon)
	elseif msg:find("246763", nil, true) then -- Fury of Golganneth
		self:Message("torment_of_the_titans", "Important", "Warning", CL.incoming:format(self:SpellName(246763)), 246763) -- Machinations of Aman'thul
		self:CDBar("torment_of_the_titans", 93.5, L.torment_of_the_titans, L.torment_of_the_titans_icon)
	elseif msg:find("245910", nil, true) then -- Spectral Army of Norgannon
		self:Message("torment_of_the_titans", "Important", "Warning", CL.incoming:format(self:SpellName(245910)), 245910) -- Machinations of Aman'thul
		self:CDBar("torment_of_the_titans", 93.5, L.torment_of_the_titans, L.torment_of_the_titans_icon)
	end
end

--[[ Noura, Mother of Flame ]]--
function mod:FieryStrike(args)
	local amount = args.amount or 1
	if self:Me(args.destGUID) or amount > 4 then -- Swap above 4, always display stacks on self
		self:StackMessage(args.spellId, args.destName, amount, "Neutral", "Info")
	end
end

function mod:FieryStrikeSuccess(args)
	self:Bar(args.spellId, 12.2)
end

function mod:WhirlingSaber(args)
	self:Message(args.spellId, "Attention", "Alert", CL.incoming:format(args.spellName))
	self:Bar(args.spellId, 35.4)
end

do
	local playerList = mod:NewTargetList()
	function mod:FulminatingPulse(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 10)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Important", "Alarm")
			self:Bar(args.spellId, 40.1)
		end
	end

	function mod:FulminatingPulseRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

--[[ Asara, Mother of Night ]]--
function mod:TouchofDarkness(args)
	self:Message(args.spellId, "Neutral", "Info")
end

function mod:ShadowBlades(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:CDBar(args.spellId, 28)
end

function mod:StormofDarkness(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:Bar(args.spellId, 51)
end

--[[ Diima, Mother of Gloom ]]--
function mod:Flashfreeze(args)
	self:TargetMessage(args.spellId, args.destName, "Neutral", "Info", nil, nil, true)
	self:Bar(args.spellId, 25.5)
end

do
	local playerList = mod:NewTargetList()
	function mod:ChilledBlood(args)
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Positive", "Alarm", nil, nil, self:Healer() and true) -- Always play a sound for healers
			self:Bar(args.spellId, 25.5)
		end
	end
end

function mod:OrbofFrost(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:Bar(args.spellId, 30.5)
end
