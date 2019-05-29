if not IsTestBuild() then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Abyssal Commander Sivara", 2164, 2352)
if not mod then return end
mod:RegisterEnableMob(151881) -- Abyssal Commander Sivara
mod.engageId = 2298
--mod.respawnTime = 31

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{294726, "FLASH", "PULSE"}, -- Chimeric Marks
		295332, -- Crushing Reverberation
		{-20300, "SAY_COUNTDOWN"}, -- Frostvenom Tipped
		296551, -- Overwhelming Barrage
		{-20006, "SAY", "SAY_COUNTDOWN", "FLASH"}, -- Overflow
		{295601, "SAY"}, -- Frostshock Bolts
		{295791, "SAY", "SAY_COUNTDOWN"}, -- Inversion
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "ToxicBrandApplied", 294715)
	self:Log("SPELL_AURA_APPLIED", "FrostMarkApplied", 294711)
	self:Log("SPELL_CAST_START", "CrushingReverberation", 295332)
	self:Log("SPELL_AURA_APPLIED", "FrostvenomTippedApplied", 300701, 300705) -- Rimefrost, Septic Taint
	self:Log("SPELL_AURA_APPLIED_DOSE", "FrostvenomTippedApplied", 300701, 300705)
	self:Log("SPELL_AURA_REMOVED", "FrostvenomTippedRemoved", 300701, 300705)
	self:Log("SPELL_CAST_START", "OverwhelmingBarrage", 296551, 298122) -- Overflowing Chill, Overflowing Venom
	self:Log("SPELL_AURA_APPLIED", "OverflowApplied", 295348, 295421)
	self:Log("SPELL_AURA_REMOVED", "OverflowRemoved", 295348, 295421)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1") -- Frostshock Bolts
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE") -- Frostshock Bolts
	self:Log("SPELL_CAST_START", "InversionStart", 295791)
	self:Log("SPELL_AURA_APPLIED", "InversionSicknessApplied", 300882, 300883)
	self:Log("SPELL_AURA_REMOVED", "InversionSicknessRemoved", 300882, 300883)
end

function mod:OnEngage()
	self:CDBar(295332, 11) -- Crushing Reverberation
	self:Bar(-20006, 15.3) -- Overflow
	self:Bar(296551, 40) -- Overwhelming Barrage
	self:Bar(295601, 48) -- Frostshock Bolts
	self:Bar(295791, 90) -- Inversion
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ToxicBrandApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(294726, nil, args.spellName, args.spellId)
		self:PlaySound(294726, "alarm")
		self:Flash(294726, args.spellId)
	end
end

function mod:FrostMarkApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(294726, nil, args.spellName, args.spellId)
		self:PlaySound(294726, "alarm")
		self:Flash(294726, args.spellId)
	end
end

function mod:CrushingReverberation(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 23)
end

function mod:FrostvenomTippedApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 2 == 1 then
			self:StackMessage(-20300, args.destName, amount, "purple", nil, args.spellName, args.spellId)
		end
		self:SayCountdown(-20300, 10)
	end
end

function mod:FrostvenomTippedRemoved(args)
	if self:Me(args.destGUID) then
		self:Message2(-20300, "green", CL.removed:format(args.spellName), args.spellId)
		self:PlaySound(-20300, "info")
		self:CancelSayCountdown(-20300)
	end
end

function mod:OverwhelmingBarrage(args)
	self:Message2(296551, "red")
	self:PlaySound(296551, "warning")
	self:Bar(296551, 40)
end

do
	local playerList = mod:NewTargetList()
	function mod:OverflowApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(-20006, "alarm")
			self:Say(-20006, args.spellName)
			self:SayCountdown(-20006, 8)
			self:Flash(-20006)
		end
		if #playerList == 1 then
			self:Bar(-20006, 30)
		end
		self:TargetsMessage(-20006, "yellow", playerList)
	end

	function mod:OverflowRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(-20006)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 295601 then -- Frostshock Bolts
		self:Bar(spellId, 60)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg, _, _, _, destName)
	local spellId = 0
	if msg:find("295607", nil, true) then -- Toxic Javelin
		spellId = 295607
	elseif msg:find("295606", nil, true) then -- Frost Javelin
		spellId = 295606
	end
	self:TargetMessage2(295601, "orange", destName, spellId, spellId)
	local guid = UnitGUID(destName)
	if self:Me(guid) then
		self:PlaySound(295601, "alarm")
		self:Say(295601, spellId)
	end
end

function mod:InversionStart(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "long")
	self:Bar(args.spellId, 92)
end

do
	local playerList = mod:NewTargetList()
	function mod:InversionSicknessApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(295791, 295791)
			self:SayCountdown(295791, 4)
		end
		self:TargetsMessage(295791, "yellow", playerList)
	end

	function mod:InversionSicknessRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(295791)
		end
	end
end
