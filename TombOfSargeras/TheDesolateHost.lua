
--------------------------------------------------------------------------------
-- TODO List:
-- - Shattering Scream: Find target before debuffs, without spamming? (current method allows for kicks before warnings)
-- - Add wave timers (no spell info)

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Desolate Host", 1147, 1896)
if not mod then return end
mod:RegisterEnableMob(118460, 118462, 119072) -- Engine of Souls, Soul Queen Dejahna, The Desolate Host
mod.engageId = 2054
mod.respawnTime = 40

--------------------------------------------------------------------------------
-- Locals
--

local myRealm = 0 -- 1 = Spirit Realm, 0 = Corporeal Realm
local phasedList = {}
local unphasedList = {}
local phasedCheckList = {}
local phase = 1
local tormentedCriesCounter = 1
local wailingSoulsCounter = 1
local boneArmorCounter = 0
local updateProximity = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.infobox_players = "Players"
end
--------------------------------------------------------------------------------
-- Initialization
--

local soulBindMarker = mod:AddMarkerOption(false, "player", 3, 236459, 3,4)
function mod:GetOptions()
	return {
		"infobox",
		{239006, "PROXIMITY"}, -- Dissonance
		236507, -- Quietus
		{235924, "SAY"}, -- Spear of Anguish
		235907, -- Collapsing Fissure
		{238570, "SAY"}, -- Tormented Cries
		235927, -- Rupturing Slam
		{236513, "INFOBOX"}, -- Bonecage Armor
		236131, -- Wither
		236459, -- Soulbind
		soulBindMarker,
		236072, -- Wailing Souls
		236515, -- Shattering Scream
		236361, -- Spirit Chains
		236542, -- Sundering Doom
		236544, -- Doomed Sundering
		236548, -- Torment
	},{
		["infobox"] = "general",
		[235933] = -14856,-- Corporeal Realm
		[235927] = CL.adds,-- Adds
		[236340] = -14857,-- Spirit Realm
		[236515] = CL.adds,-- Adds
		[236542] = -14970, -- Tormented Souls
	}
end

function mod:OnBossEnable()
	-- General
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3")
	self:Log("SPELL_CAST_SUCCESS", "Quietus", 236507) -- Quietus
	self:Log("SPELL_AURA_APPLIED", "SpiritualBarrier", 235732) -- SpiritualB arrier
	self:Log("SPELL_AURA_REMOVED", "SpiritualBarrierRemoved", 235732) -- Spiritual Barrier

	-- Corporeal Realm
	self:Log("SPELL_AURA_APPLIED", "SpearofAnguish", 235924) -- Spear of Anguish
	self:Log("SPELL_CAST_START", "TormentedCries", 238570) -- Tormented Cries
	self:Log("SPELL_AURA_APPLIED", "TormentedCriesApplied", 238018) -- Tormented Cries (Debuff)
	-- Adds
	self:Log("SPELL_CAST_START", "RupturingSlam", 235927) -- Rupturing Slam
	self:Log("SPELL_AURA_APPLIED", "BonecageArmor", 236513) -- Bonecage Armor
	self:Log("SPELL_AURA_REMOVED", "BonecageArmorRemoved", 236513) -- Bonecage Armor

	-- Spirit Realm
	self:Log("SPELL_AURA_APPLIED", "Wither", 236131, 236138) -- Wither
	self:Log("SPELL_AURA_APPLIED", "Soulbind", 236459) -- Soulbind
	self:Log("SPELL_AURA_REMOVED", "SoulbindRemoved", 236459) -- Soulbind
	self:Log("SPELL_CAST_SUCCESS", "WailingSouls", 236072) -- Wailing Souls
	-- Adds
	self:Log("SPELL_AURA_APPLIED", "ShatteringScream", 236515) -- Shattering Scream
	self:Log("SPELL_AURA_APPLIED", "SpiritChains", 236361) -- Spirit Chains

	-- Tormented Souls
	self:Log("SPELL_CAST_START", "SunderingDoom", 236542) -- Sundering Doom
	self:Log("SPELL_CAST_START", "DoomedSundering", 236544) -- Doomed Sundering
	self:Log("SPELL_AURA_APPLIED", "Torment", 236548) -- Torment
	self:Log("SPELL_AURA_APPLIED_DOSE", "Torment", 236548) -- Torment
end

function mod:OnEngage()
	-- Dissonance Handling
	wipe(phasedList)
	wipe(unphasedList)
	for unit in self:IterateGroup() do
		local buffCheck = UnitBuff(unit, self:SpellName(235732)) -- Spiritual Barrier
		local guid = UnitGUID(unit)
		if buffCheck then
			phasedList[#phasedList+1] = self:UnitName(unit)
			if self:Me(guid) then
				myRealm = 1 -- Spirit Realm
			end
		else
			unphasedList[#unphasedList+1] = self:UnitName(unit)
			if self:Me(guid) then
				myRealm = 0 -- Corporeal Realm
			end
		end
	end
	updateProximity(self)

	-- XXX Delete if not needed on Live
	--wipe(phasedCheckList)
	--self:RegisterEvent("UNIT_AURA") -- Spirit Realm Tracking
	--for unit in self:IterateGroup() do
	--	local n = self:UnitName(unit)
	--	unphasedList[#unphasedList+1] = n
	--	phasedCheckList[n] = true -- Assume everyone is unphased
	--	self:UNIT_AURA(nil, unit)
	--end

	phase = 1
	boneArmorCounter = 0
	tormentedCriesCounter = 1
	wailingSoulsCounter = 1

	self:OpenInfo("infobox")
	self:SetInfo("infobox", 1, self:SpellName(55336)) -- Bone Armor (Shorter Text)
	self:SetInfo("infobox", 2, boneArmorCounter)
	self:SetInfo("infobox", 6, L.infobox_players)
	self:SetInfo("infobox", 7, self:SpellName(-14857)) -- Spirit Realm
	self:SetInfo("infobox", 8, #phasedList)
	self:SetInfo("infobox", 9, self:SpellName(-14856)) -- Corporeal Realm
	self:SetInfo("infobox", 10, #unphasedList)


	self:Bar(235907, 7.3) -- Collapsing Fissure
	self:Bar(236459, 15.5) -- Soulbind
	if self:Heroic() or self:Mythic() then -- Heroic+ only
		self:Bar(235924, 22) -- Spear of Anguish
	end
	self:Bar(236072, 60) -- Wailing Souls
	self:Bar(238570, 120) -- Tormented Cries
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 235885 then -- Collapsing Fissure
		self:Message(235907, "Attention", "Alert", spellName)
		local t = phase == 2 and 15.8 or 30.5
		if not phase == 2 and self:BarTimeLeft(238570) < 30.5 and self:BarTimeLeft(238570) > 0 then -- Tormented Cries
			t = 65 + self:BarTimeLeft(238570) -- Time Left + 60s channel + 5s~ cooldown
		end
		self:Bar(235907, t)
	elseif spellId == 239978 then -- Soul Palour // Phase 2
		phase = 2

		self:CDBar(236542, 8) -- Sundering Doom
		self:CDBar(236544, 19) -- Doomed Sundering
	end
end

-- XXX Delete if not needed on Live
--function mod:UNIT_AURA(event, unit)
--	if not unit:match("raid%d+$") then return end
--	local name = UnitDebuff(unit, self:SpellName(235621)) -- Spirit Realm
--	local n = self:UnitName(unit)
--	if not phasedCheckList[n] and not name then -- Not in Spirit Realm
--		local guid = UnitGUID(unit)
--		phasedCheckList[n] = true
--		unphasedList[#unphasedList+1] = n
--		tDeleteItem(phasedList, n)
--		if self:Me(guid) then
--			myRealm = 0 -- Corporeal Realm
--			self:Message(239006, "Neutral", "Info", self:SpellName(-14856), false) -- Corporeal Realm
--		end
--		if myRealm == 0 then -- Corporeal Realm
--			self:OpenProximity(239006, 8, phasedList) -- Avoid people in Spirit Realm
--		else
--			self:OpenProximity(239006, 8, unphasedList) -- Avoid people not in Spirit Realm
--		end
--		self:SetInfo("infobox", 8, #phasedList)
--		self:SetInfo("infobox", 10, #unphasedList)
--	elseif name and phasedCheckList[n] then -- In Spirit Realm
--		local guid = UnitGUID(unit)
--		phasedList[#phasedList+1] = n
--		tDeleteItem(unphasedList, n)
--		if self:Me(guid) then
--			myRealm = 1
--		end
--		if myRealm == 1 then -- Spirit Realm
--			self:OpenProximity(239006, 8, unphasedList) -- Avoid people not in Spirit Realm
--		else
--			self:OpenProximity(239006, 8, phasedList) -- Avoid people in Spirit Realm
--		end
--		phasedCheckList[n] = nil
--		self:SetInfo("infobox", 8, #phasedList)
--		self:SetInfo("infobox", 10, #unphasedList)
--	end
--end

function updateProximity(self)
	if myRealm == 0 then -- Corporeal Realm
		self:OpenProximity(239006, 8, phasedList) -- Avoid people in Spirit Realm
	else
		self:OpenProximity(239006, 8, unphasedList) -- Avoid people not in Spirit Realm
	end
end

do
	local function updateInfoBox()
		mod:SetInfo("infobox", 8, #phasedList)
		mod:SetInfo("infobox", 10, #unphasedList)
	end

	function mod:SpiritualBarrier(args)
		phasedList[#phasedList+1] = args.destName
		tDeleteItem(unphasedList, args.destName)
		if self:Me(args.destGUID) then
			myRealm = 1
			self:Message(239006, "Neutral", "Info", self:SpellName(-14857), false) -- Dissonance // Spirit Realm
		end
		updateProximity(self)
		updateInfoBox()
	end

	function mod:SpiritualBarrierRemoved(args)
		unphasedList[#unphasedList+1] = args.destName
		tDeleteItem(phasedList, args.destName)
		if self:Me(args.destGUID) then
			myRealm = 0 -- Corporeal Realm
			self:Message(239006, "Neutral", "Info", self:SpellName(-14856), false) -- Dissonance // Corporeal Realm
		end
		updateProximity(self)
		updateInfoBox()
	end
end

function mod:Quietus(args)
	self:Message(args.spellId, "Important", "Warning")
end

function mod:SpearofAnguish(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm", nil, nil, true)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
	local t = 20.5 -- XXX Need more P2 Data
	if self:BarTimeLeft(238570) < 20.5 and self:BarTimeLeft(238570) > 0 then -- Tormented Cries
		t = 80.5 + self:BarTimeLeft(238570) -- Time Left + 60s channel + 20.5s cooldown
	end
	self:Bar(args.spellId, t)
end

function mod:TormentedCries(args)
	tormentedCriesCounter = tormentedCriesCounter + 1
	self:Message(args.spellId, "Attention", "Info", CL.incoming:format(args.spellName))
	if tormentedCriesCounter <= 2 then -- XXX Need data for cast 3+
		self:Bar(args.spellId, 120)
	end
	self:CastBar(args.spellId, 60)
end

function mod:TormentedCriesApplied(args)
	self:TargetMessage(238570, args.destName, "Urgent", "Alarm")
	if self:Me(args.destGUID) then
		self:Say(238570)
	end
end

function mod:RupturingSlam(args)
	self:Message(args.spellId, "Attention", "Alert", CL.incoming:format(args.spellName))
end

function mod:BonecageArmor(args)
	boneArmorCounter = boneArmorCounter + 1
	self:Message(args.spellId, "Important", "Alert", CL.count:format(args.spellName, boneArmorCounter))
	self:SetInfo("infobox", 2, boneArmorCounter)
end

function mod:BonecageArmorRemoved(args)
	boneArmorCounter = boneArmorCounter - 1
	self:Message(args.spellId, "Positive", "Info", CL.count:format(CL.removed:format(args.spellName), boneArmorCounter))
	self:SetInfo("infobox", 2, boneArmorCounter)
end

function mod:Wither(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
	end
end

do
	local list = mod:NewTargetList()
	function mod:Soulbind(args)
		list[#list+1] = args.destName
		if #list == 2 then -- Announce at 2
			if self:GetOption(soulBindMarker) then
				SetRaidTarget(args.destName, 4)
			end
			self:TargetMessage(args.spellId, list, "Positive", "Warning")
			local t = phase == 2 and 17 or 24.3
			if not phase == 2 and self:BarTimeLeft(236072) < 24.3 and self:BarTimeLeft(236072) > 0 then -- Wailing Souls
				t = 74.5 + self:BarTimeLeft(236072) -- Time Left + 60s channel + 14.5s cooldown
			end
			self:Bar(args.spellId, t)
		elseif #list ==  1 and self:GetOption(soulBindMarker) then
			SetRaidTarget(args.destName, 3)
		end
	end

	function mod:SoulbindRemoved(args)
		if self:Me(args.destGUID) then
			self:TargetMessage(args.spellId, args.destName, "Positive", "Long", CL.removed:format(args.spellName))
		end
		if self:GetOption(soulBindMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:WailingSouls(args)
	wailingSoulsCounter = wailingSoulsCounter + 1
	self:Message(args.spellId, "Important", "Warning")
	if wailingSoulsCounter <= 2 then -- XXX Need data for cast 3+
		self:Bar(args.spellId, 120)
	end
	self:CastBar(args.spellId, 60)
end

function mod:ShatteringScream(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Warning")
end

function mod:SpiritChains(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alert")
	end
end

function mod:SunderingDoom(args)
	self:Message(args.spellId, "Important", "Warning")
	self:Bar(args.spellId, 23.1)
	self:CastBar(args.spellId, 4)
end

function mod:DoomedSundering(args)
	self:Message(args.spellId, "Important", "Warning")
	self:Bar(args.spellId, 23.1)
	self:CastBar(args.spellId, 4)
end

do
	local prev = 0
	function mod:Torment(args)
		local t = GetTime()
		if t-prev > 1 then
			local amount = args.amount or 1
			self:StackMessage(args.spellId, args.destName, amount, "Attention", "Info")
		end
	end
end