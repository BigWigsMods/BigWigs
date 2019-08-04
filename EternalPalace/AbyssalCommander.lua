--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Abyssal Commander Sivara", 2164, 2352)
if not mod then return end
mod:RegisterEnableMob(151881) -- Abyssal Commander Sivara
mod.engageId = 2298
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local markList = {}
local overwhelmingCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"berserk",
		{294726, "FLASH", "PULSE", "INFOBOX"}, -- Chimeric Marks
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
	self:Log("SPELL_AURA_APPLIED_DOSE", "MarkAppliedDose", 294715, 294711)
	self:Log("SPELL_AURA_REMOVED", "MarkRemoved", 294715, 294711)
	self:Log("SPELL_CAST_START", "CrushingReverberation", 295332)
	self:Log("SPELL_AURA_APPLIED", "FrostvenomTippedApplied", 300701, 300705) -- Rimefrost, Septic Taint
	self:Log("SPELL_AURA_APPLIED_DOSE", "FrostvenomTippedApplied", 300701, 300705)
	self:Log("SPELL_AURA_REMOVED", "FrostvenomTippedRemoved", 300701, 300705)
	self:Log("SPELL_CAST_START", "OverwhelmingBarrage", 296551, 298122)
	self:Log("SPELL_AURA_APPLIED", "OverflowApplied", 295348, 295421) -- Overflowing Chill, Overflowing Venom
	self:Log("SPELL_AURA_REMOVED", "OverflowRemoved", 295348, 295421)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1") -- Frostshock Bolts
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE") -- Frostshock Bolts
	self:Log("SPELL_CAST_START", "InversionStart", 295791)
	self:Log("SPELL_AURA_APPLIED", "InversionSicknessApplied", 300882, 300883) -- Frost, Toxic
	self:Log("SPELL_AURA_REMOVED", "InversionSicknessRemoved", 300882, 300883)
end

function mod:OnEngage()
	markList = {}
	overwhelmingCount = 1
	self:CDBar(295332, 11) -- Crushing Reverberation
	self:Bar(-20006, self:Mythic() and 19 or 16) -- Overflow
	self:Bar(296551, 40, CL.count:format(self:SpellName(296551), overwhelmingCount)) -- Overwhelming Barrage
	self:CDBar(295601, 50) -- Frostshock Bolts
	if not self:LFR() then
		self:CDBar(295791, 70) -- Inversion
	end
	self:Berserk(self:Easy() and 390 or 360)
	self:OpenInfo(294726, self:SpellName(294726)) -- Chimeric Marks
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	function mod:ToxicBrandApplied(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 3 then
				self:PersonalMessage(294726, nil, args.spellName, args.spellId)
				self:PlaySound(294726, "alarm")
				self:Flash(294726, args.spellId)
			end
		end
	end
end

do
	local prev = 0
	function mod:FrostMarkApplied(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 3 then
				self:PersonalMessage(294726, nil, args.spellName, args.spellId)
				self:PlaySound(294726, "alarm")
				self:Flash(294726, args.spellId)
			end
		end
	end
end

function mod:MarkAppliedDose(args)
	markList[args.destName] = args.amount
	self:SetInfoByTable(294726, markList)
end

function mod:MarkRemoved(args)
	markList[args.destName] = nil
	self:SetInfoByTable(294726, markList)
end

function mod:CrushingReverberation(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, self:Mythic() and 29 or 23) -- XXX review all dificulties for what causes the variance
end

function mod:FrostvenomTippedApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 2 == 1 then
			self:StackMessage(-20300, args.destName, amount, "purple", nil, args.spellName, args.spellId)
		end
		self:CancelSayCountdown(-20300)
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
	self:Message2(296551, "red",  CL.count:format(self:SpellName(296551), overwhelmingCount))
	self:PlaySound(296551, "warning")
	overwhelmingCount = overwhelmingCount + 1
	self:Bar(296551, 40, CL.count:format(self:SpellName(296551), overwhelmingCount))
end

do
	local playerList = mod:NewTargetList()
	function mod:OverflowApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(-20006, "alarm")
			self:Say(-20006, args.spellName)
			self:SayCountdown(-20006, self:Mythic() and 6 or 7)
			self:Flash(-20006)
		end
		if #playerList == 1 then
			self:CDBar(-20006, self:Mythic() and 40 or 30) -- XXX Check if this is always the case: 16.8, 33, 40, 40, 30, 30, 35, 30
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
		self:CDBar(spellId, 80) -- XXX as low as 75?
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
	self:Bar(args.spellId, 73)
end

function mod:InversionSicknessApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(295791)
		self:Say(295791, 295791)
		self:SayCountdown(295791, 4)
	end
end

function mod:InversionSicknessRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(295791)
	end
end
