
-- GLOBALS: tDeleteItem

--------------------------------------------------------------------------------
-- TODO List:
-- - Shattering Scream: Find target before debuffs, without spamming? (current method allows for kicks before warnings)
-- - Add wave timers (no spell info)
-- - Stop Bars when initial bosses die (Spear/Bind/Collapsing Fissure)

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
local stage = 1
local tormentedCriesCounter = 1
local wailingSoulsCounter = 1
local boneArmorCounter = 0
local spearCount = 1
local updateProximity = nil
local updateRealms = nil
local armorAppliedTimer, armorRemovedTimer = nil, nil
local soulList = mod:NewTargetList()
local nextWailingSouls, nextTormentedCries = 0, 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.infobox_players = "Players"
	L.armor_remaining = "%s Remaining (%d)" -- Bonecage Armor Remaining (#)
	L.custom_on_mythic_armor = "Ignore Bonecage Armor on Reanimated Templars in Mythic Difficulty"
	L.custom_on_mythic_armor_desc = "Leave this option enabled if you are offtanking Reanimated Templars to ignore warnings and counting the Bonecage Armor on the Ranimated Templars"
	L.custom_on_armor_plates = "Bonecage Armor icon on Enemy Nameplate"
	L.custom_on_armor_plates_desc = "Show an icon on the nameplate of Reanimated Templars who have Bonecage Armor.\nRequires the use of Enemy Nameplates. This feature is currently only supported by KuiNameplates."
	L.custom_on_armor_plates_icon = 236513
	L.tormentingCriesSay = "Cries" -- Tormenting Cries (short say)
end
--------------------------------------------------------------------------------
-- Initialization
--

local soulBindMarker = mod:AddMarkerOption(false, "player", 3, 236459, 3,4)
function mod:GetOptions()
	return {
		"infobox",
		{239006, "PROXIMITY"}, -- Dissonance
		236678, -- Quietus
		{235924, "SAY"}, -- Spear of Anguish
		235907, -- Collapsing Fissure
		{238570, "SAY", "ICON"}, -- Tormented Cries
		235927, -- Rupturing Slam
		236513, -- Bonecage Armor
		"custom_on_armor_plates",
		"custom_on_mythic_armor",
		236131, -- Wither
		{236459, "ME_ONLY"}, -- Soulbind
		soulBindMarker,
		236072, -- Wailing Souls
		{236515, "ME_ONLY"}, -- Shattering Scream
		236361, -- Spirit Chains
		236241, -- Soul Rot
		236542, -- Sundering Doom
		236544, -- Doomed Sundering
		236548, -- Torment
	},{
		["infobox"] = "general",
		[235933] = -14856,-- Corporeal Realm
		[235927] = CL.adds,-- Adds
		[236131] = -14857,-- Spirit Realm
		[236515] = CL.adds,-- Adds
		[236542] = -14970, -- Tormented Souls
	}
end

function mod:OnBossEnable()
	-- General
	updateRealms(self)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3")
	self:Log("SPELL_AURA_APPLIED", "Quietus", 236678)
	self:Log("SPELL_AURA_APPLIED", "SpiritualBarrier", 235732)
	self:Log("SPELL_AURA_REMOVED", "SpiritualBarrierRemoved", 235732)

	self:Log("SPELL_AURA_APPLIED", "GroundEffectDamage", 235907, 236241) -- Collapsing Fissure, Soul Rot
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffectDamage", 235907, 236241) -- Collapsing Fissure, Soul Rot
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffectDamage", 235907, 236241) -- Collapsing Fissure, Soul Rot


	-- Corporeal Realm
	self:Log("SPELL_AURA_APPLIED", "SpearofAnguish", 235924)
	self:Log("SPELL_AURA_REMOVED", "SpearofAnguishRemoved", 235924)
	self:Log("SPELL_CAST_START", "TormentedCries", 238570)
	self:Log("SPELL_AURA_APPLIED", "TormentedCriesApplied", 238018)
	self:Log("SPELL_AURA_REMOVED", "TormentedCriesRemoved", 238018)
	self:Log("SPELL_AURA_APPLIED", "TormentedCriesDamage", 236011)
	self:Log("SPELL_PERIODIC_DAMAGE", "TormentedCriesDamage", 236011, 238018)
	self:Log("SPELL_PERIODIC_MISSED", "TormentedCriesDamage", 236011, 238018)
	-- Adds
	self:Log("SPELL_CAST_START", "RupturingSlam", 235927)
	self:Log("SPELL_AURA_APPLIED", "BonecageArmor", 236513)
	self:Log("SPELL_AURA_REMOVED", "BonecageArmorRemoved", 236513)

	-- Spirit Realm
	self:Log("SPELL_AURA_APPLIED", "Wither", 236131, 236138) -- Both ids are used
	self:Log("SPELL_AURA_APPLIED", "Soulbind", 236459)
	self:Log("SPELL_AURA_REMOVED", "SoulbindRemoved", 236459)
	self:Log("SPELL_CAST_SUCCESS", "WailingSouls", 236072)
	-- Adds
	self:Log("SPELL_AURA_APPLIED", "ShatteringScream", 236515)
	self:Log("SPELL_AURA_APPLIED", "SpiritChains", 236361)

	-- Tormented Souls
	self:Log("SPELL_CAST_START", "SunderingDoom", 236542)
	self:Log("SPELL_CAST_START", "DoomedSundering", 236544)
	self:Log("SPELL_AURA_APPLIED", "Torment", 236548)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Torment", 236548)

	self:Death("EngineDies", 118460)
end

function mod:OnEngage()
	updateRealms(self)

	if not self:Easy() then -- No Dissonance in LFR/Normal
		updateProximity(self)
	end

	stage = 1
	boneArmorCounter = 0
	tormentedCriesCounter = 1
	wailingSoulsCounter = 1
	spearCount = 1
	armorAppliedTimer, armorRemovedTimer = nil, nil
	nextWailingSouls, nextTormentedCries = GetTime() + 60, GetTime() + 120
	wipe(soulList)

	if self:Easy() then
		self:OpenInfo("infobox", L.infobox_players)
		self:SetInfo("infobox", 1, self:SpellName(-14857)) -- Spirit Realm
		self:SetInfo("infobox", 2, #phasedList)
		self:SetInfo("infobox", 3, self:SpellName(-14856)) -- Corporeal Realm
		self:SetInfo("infobox", 4, #unphasedList)
	else
		self:OpenInfo("infobox")
		self:SetInfo("infobox", 1, self:SpellName(55336)) -- Bone Armor (Shorter Text)
		self:SetInfo("infobox", 2, boneArmorCounter)
		self:SetInfo("infobox", 6, L.infobox_players)
		self:SetInfo("infobox", 7, self:SpellName(-14857)) -- Spirit Realm
		self:SetInfo("infobox", 8, #phasedList)
		self:SetInfo("infobox", 9, self:SpellName(-14856)) -- Corporeal Realm
		self:SetInfo("infobox", 10, #unphasedList)
	end


	self:CDBar(235907, 6) -- Collapsing Fissure
	self:CDBar(236459, 16) -- Soulbind
	if not self:Easy() then -- Heroic+ only
		self:CDBar(235924, 20, CL.count:format(self:SpellName(235924), spearCount)) -- Spear of Anguish
	end
	self:CDBar(236072, 60) -- Wailing Souls
	self:CDBar(238570, 120) -- Tormented Cries
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, spellName, _, _, spellId)
	if spellId == 235885 then -- Collapsing Fissure
		self:Message(235907, "Attention", "Alert", spellName)
		local t = stage == 2 and 15.8 or 30.5
		local remaining = nextTormentedCries - GetTime()
		if stage ~= 2 and remaining < 30.5 and remaining > 0 then
			t = 65 + remaining -- Time Left + 60s channel + 5s~ cooldown
		end
		self:Bar(235907, t)
	elseif spellId == 239978 then -- Soul Pallor // Stage 2
		stage = 2

		self:StopBar(236072) -- Wailing Souls
		self:StopBar(238570) -- Tormented Cries
		self:StopBar(CL.cast:format(self:SpellName(236072))) -- <cast: Wailing Souls>
		self:StopBar(CL.cast:format(self:SpellName(238570))) -- <cast: Tormented Cries>

		self:CDBar(235907, 2.5) -- Collapsing Fissure
		if not self:Easy() then
			self:CDBar(235924, 8, CL.count:format(self:SpellName(235924), spearCount)) -- Spear of Anguish
		end
		self:CDBar(236459, 9) -- Soulbind

		self:CDBar(236542, 17) -- Sundering Doom
		self:CDBar(236544, 28) -- Doomed Sundering
	end
end

function updateRealms(self)
	-- Dissonance Handling
	wipe(phasedList)
	wipe(unphasedList)
	for unit in self:IterateGroup() do
		local buffCheck = UnitDebuff(unit, self:SpellName(235621)) -- Spirit Realm
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
end

function updateProximity(self)
	if myRealm == 0 then -- Corporeal Realm
		self:OpenProximity(239006, 8, phasedList) -- Avoid people in Spirit Realm
	else
		self:OpenProximity(239006, 8, unphasedList) -- Avoid people not in Spirit Realm
	end
end

do
	local function updateInfoBox(self)
		if self:Easy() then
			self:SetInfo("infobox", 2, #phasedList)
			self:SetInfo("infobox", 4, #unphasedList)
		else
			self:SetInfo("infobox", 8, #phasedList)
			self:SetInfo("infobox", 10, #unphasedList)
		end
	end

	function mod:SpiritualBarrier(args)
		phasedList[#phasedList+1] = args.destName
		tDeleteItem(unphasedList, args.destName)
		if self:Me(args.destGUID) then
			myRealm = 1
			self:Message(239006, "Neutral", "Info", self:SpellName(-14857), false) -- Dissonance // Spirit Realm
		end
		if not self:Easy() then -- No Dissonance in LFR/Normal
			updateProximity(self)
		end
		updateInfoBox(self)
	end

	function mod:SpiritualBarrierRemoved(args)
		unphasedList[#unphasedList+1] = args.destName
		tDeleteItem(phasedList, args.destName)
		if self:Me(args.destGUID) then
			myRealm = 0 -- Corporeal Realm
			self:Message(239006, "Neutral", "Info", self:SpellName(-14856), false) -- Dissonance // Corporeal Realm
		end
		if not self:Easy() then -- No Dissonance in LFR/Normal
			updateProximity(self)
		end
		updateInfoBox(self)
	end
end

do
	local prev = 0
	function mod:GroundEffectDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

function mod:Quietus(args)
	self:Message(args.spellId, "Important", "Warning")
end

function mod:SpearofAnguish(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm", CL.count:format(args.spellName, spearCount), nil, true)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 6)
	end
	spearCount = spearCount + 1
	local t = 21
	local remaining = nextTormentedCries - GetTime()
	if remaining < 20.5 and remaining > 0 then
		t = 80.5 + remaining -- Time Left + 60s channel + 20.5s cooldown
	end
	self:Bar(args.spellId, t, CL.count:format(args.spellName, spearCount))
end

function mod:SpearofAnguishRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:TormentedCries(args)
	self:Message(args.spellId, "Attention", "Info", CL.incoming:format(args.spellName))
	tormentedCriesCounter = tormentedCriesCounter + 1
	if tormentedCriesCounter <= 2 then -- Does a 3rd cast exist?
		nextTormentedCries = GetTime() + 120
		self:Bar(args.spellId, 120)
	end
	self:CastBar(args.spellId, 60)
end

function mod:TormentedCriesApplied(args)
	self:TargetMessage(238570, args.destName, "Urgent", "Alarm")
	if self:Me(args.destGUID) then
		self:Say(238570, L.tormentingCriesSay)
		self:SayCountdown(238570, 4)
	end
	self:PrimaryIcon(238570, args.destName)
end

function mod:TormentedCriesRemoved(args)
	self:PrimaryIcon(238570)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(238570)
	end
end

do
	local prev = 0
	function mod:TormentedCriesDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(238570, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

do
	local prev = 0
	function mod:RupturingSlam(args)
		local t = GetTime()
		if t-prev > 3 then
			prev = t
			self:Message(args.spellId, "Attention", "Alert", CL.incoming:format(args.spellName))
		end
	end
end

do
	local function printArmorApplied(self, spellId, spellName)
		armorAppliedTimer = nil
		self:Message(spellId, "Attention", "Warning", CL.count:format(spellName, boneArmorCounter))
	end
	local function printArmorRemoved(self, spellId, spellName)
		armorRemovedTimer = nil
		self:Message(spellId, "Positive", "Info", L.armor_remaining:format(spellName, boneArmorCounter))
	end

	function mod:BonecageArmor(args)
		if self:Mythic() and self:GetOption("custom_on_mythic_armor") and self:MobId(args.destGUID) == 118715 then return end -- Reanimated Templar
		boneArmorCounter = boneArmorCounter + 1
		self:SetInfo("infobox", 2, boneArmorCounter)
		if self:GetOption("custom_on_armor_plates") then
			self:AddPlateIcon(236513, args.sourceGUID) -- Display an armor icon above targets with armor
		end
		if not armorAppliedTimer then
			armorAppliedTimer = self:ScheduleTimer(printArmorApplied, 0.1, self, args.spellId, args.spellName)
		end
	end

	function mod:BonecageArmorRemoved(args)
		if self:Mythic() and self:GetOption("custom_on_mythic_armor") and self:MobId(args.destGUID) == 118715 then return end -- Reanimated Templar
		boneArmorCounter = boneArmorCounter - 1
		self:SetInfo("infobox", 2, boneArmorCounter)
		if self:GetOption("custom_on_armor_plates") then
			self:RemovePlateIcon(236513, args.sourceGUID) -- Remove the armor icon
		end
		if not armorRemovedTimer then
			armorRemovedTimer = self:ScheduleTimer(printArmorRemoved, 0.1, self, args.spellId, args.spellName)
		end
	end
end

function mod:Wither(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(236131, args.destName, "Personal", "Alarm")
	end
end

do
	local linkOnMe = false
	function mod:Soulbind(args)
		soulList[#soulList+1] = args.destName
		if #soulList == 1 then
			local t = stage == 2 and 19.4 or 24.3
			if self:Easy() then
				t = stage == 2 and 24 or 34
			end
			local remaining = nextWailingSouls - GetTime()
			if stage ~= 2 and remaining < 24.3 and remaining > 0 then
				t = 74.5 + remaining -- Time Left + 60s channel + 14.5s cooldown
			end
			self:Bar(args.spellId, t)
			if self:GetOption(soulBindMarker) then
				SetRaidTarget(args.destName, 3)
			end
			linkOnMe = self:Me(args.destGUID)
		elseif #soulList == 2 then -- Announce at 2
			if self:GetOption(soulBindMarker) then
				SetRaidTarget(args.destName, 4)
			end
			if self:Me(args.destGUID) then
				self:Message(args.spellId, "Personal", "Warning", CL.link:format(soulList[1]))
			elseif linkOnMe then
				self:Message(args.spellId, "Personal", "Warning", CL.link:format(soulList[2]))
			elseif not self:CheckOption(args.spellId, "ME_ONLY") then
				self:Message(args.spellId, "Positive", "Info", CL.link_both:format(soulList[1], soulList[2]))
			end
			wipe(soulList)
		end
	end
end

function mod:SoulbindRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Long", CL.link_removed)
	end
	if self:GetOption(soulBindMarker) then
		SetRaidTarget(args.destName, 0)
	end
end

function mod:WailingSouls(args)
	self:Message(args.spellId, "Important", "Warning")
	wailingSoulsCounter = wailingSoulsCounter + 1
	if wailingSoulsCounter <= 2 then -- XXX Does a 3rd cast exist?
		nextWailingSouls = GetTime() + 120
		self:Bar(args.spellId, 120)
	end
	self:CastBar(args.spellId, 60)
end

do
	local list = mod:NewTargetList()
	function mod:ShatteringScream(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.5, args.spellId, list, "Attention", "Warning")
		end
	end
end

function mod:SpiritChains(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alert")
	end
end

function mod:SunderingDoom(args)
	self:Message(args.spellId, "Important", "Warning")
	self:Bar(args.spellId, self:Easy() and 26.5 or 25)
	self:CastBar(args.spellId, self:Easy() and 6 or self:Heroic() and 5 or 4)
end

function mod:DoomedSundering(args)
	self:Message(args.spellId, "Important", "Warning")
	self:Bar(args.spellId, self:Easy() and 26.5 or 25)
	self:CastBar(args.spellId, self:Easy() and 6 or self:Heroic() and 5 or 4)
end

do
	local prev = 0
	function mod:Torment(args)
		local t = GetTime()
		if t-prev > 1 then
			prev = t
			self:StackMessage(args.spellId, args.destName, args.amount, "Attention", "Info")
		end
	end
end

function mod:EngineDies()
	self:StopBar(236459) -- Soulbind
	self:StopBar(235907) -- Collapsing Fissure
	self:StopBar(CL.count:format(self:SpellName(235924), spearCount)) -- Spear of Anguish
end
