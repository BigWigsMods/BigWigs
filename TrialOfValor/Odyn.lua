
--------------------------------------------------------------------------------
-- TODO List:
-- - Get/Confirm timers for all difficulties on live
--   LFR (✘) - Normal (✘) - Heroic (✔) - Mythic (✔)
-- - Horn of Valor CD in p2

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Odyn-TrialOfValor", 1114, 1819)
if not mod then return end
mod:RegisterEnableMob(114263, 114361, 114360) -- Odyn, Hymdall, Hyrja
mod.engageId = 1958
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local hornCount = 1
local shieldCount = 1
local expelCount = 1
local spearCount = 1
local stormCount = 1
local runesUp = 0
local myAddGUID = ""
local castingHorn = false
local addGUIDs = {}
local isHymdallFighting, isHyrjaFighting = nil, nil
local revivifyBarTexts = {}
local addFixates = {}
local proxLists = {
	[231311] = {}, -- Boss_OdunRunes_Purple
	[231342] = {}, -- Boss_OdunRunes_Orange
	[231344] = {}, -- Boss_OdunRunes_Yellow
	[231345] = {}, -- Boss_OdunRunes_Blue
	[231346] = {}, -- Boss_OdunRunes_Green
}
local timers = { -- Mythic P1 is timed
	[228012] = {8, 22, 20, 35, 53}, -- Horn of Valor
	[228162] = {20, 20, 33, 22, 20, 35}, -- Shield of Light
	[228029] = {25, 20, 15, 30, 20, 15}, -- ExpelLight
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.odyn = -14003
	L.odyn_icon = "inv_misc_horn_05" -- inv_misc_horn_05 = Item: Odyn's Horn
	L.hymdall = -14005
	L.hymdall_icon = "inv_helm_mail_vrykuldragonrider_b_01" -- 214382 / Follower: Hymdall
	L.hyrja = -14006
	L.hyrja_icon = "inv_shield_1h_hyrja_d_01"

	L.say = {}
	L.say[227490] = "{rt3} %s {rt3}" -- Boss_OdunRunes_Purple
	L.say[227491] = "{rt2} %s {rt2}" -- Boss_OdunRunes_Orange
	L.say[227498] = "{rt1} %s {rt1}" -- Boss_OdunRunes_Yellow
	L.say[227499] = "{rt6} %s {rt6}" -- Boss_OdunRunes_Blue
	L.say[227500] = "{rt4} %s {rt4}" -- Boss_OdunRunes_Green

	L.yields = "%s yields" -- used when Hymdall and Helya leave the fight in P2: "Hymdall yields"

	L[227490] = "|cFF800080Top Right|r (|T1323037:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Purple
	L[227491] = "|cFFFFA500Bottom Right|r (|T1323039:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Orange
	L[227498] = "|cFFFFFF00Bottom Left|r (|T1323038:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Yellow
	L[227499] = "|cFF0000FFTop Left|r (|T1323035:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Blue
	L[227500] = "|cFF008000Top|r (|T1323036:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Green
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ General ]]--
		"stages",

		--[[ Stage One: Might of the Valarjar ]]--
		228018, -- Valarjar's Bond
		228171, -- Revivify

		--[[ Hymdall ]]--
		{228012, "PROXIMITY"}, -- Horn of Valor

		--[[ Hyrja ]]--
		{228029, "SAY", "ICON", "PROXIMITY"}, -- Expel Light
		{228162, "SAY", "ICON"}, -- Shield of Light

		--[[ Odyn ]]--
		227503, -- Draw Power
		227629, -- Unerring Blast
		{227626, "TANK"}, -- Odyn's Test
		{-14495, "INFOBOX", "SAY", "PULSE"}, -- Runic Brand
		{229584, "EMPHASIZE"}, -- Protected

		--[[ Stage Two: The Prime Designate ]]--
		-14404, -- Test of the Ages

		--[[ Stage Three: The Final Test ]]--
		{228918, "SAY", "ICON"}, -- Stormforged Spear
		{227807, "SAY", "FLASH"}, -- Storm of Justice
		227475, -- Cleansing Flame
		{197961, "PROXIMITY", "SAY", "PULSE"}, -- Runic Brand
		231350, -- Radiant Smite
	},{
		["stages"] = "general",
		[228018] = -14002, -- Stage One: Might of the Valarjar
		[228012] = -14005, -- Hymdall
		[228029] = -14006, -- Hyrja
		[227503] = -14003, -- Odyn
		[-14404] = -14010, -- Stage Two: The Prime Designate
		[228918] = -14011, -- Stage Three: The Final Test
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_CAST_START", "UnerringBlast", 227629)
	self:Log("SPELL_CAST_START", "ShieldOfLight", 228162)
	self:Log("SPELL_CAST_SUCCESS", "ShieldOfLightSuccess", 228162)
	self:Log("SPELL_CAST_START", "HornOfValor", 228012)
	self:Log("SPELL_CAST_SUCCESS", "HornOfValorSuccess", 228012)
	self:Log("SPELL_AURA_APPLIED", "StormOfJustice", 227807)
	self:Log("SPELL_CAST_SUCCESS", "StormOfJusticeSuccess", 227807)
	self:Log("SPELL_AURA_APPLIED", "ValarjarsBond", 228018, 229529, 228016, 229469) -- XXX
	self:Log("SPELL_AURA_APPLIED_DOSE", "OdynsTest", 227626)
	self:Log("SPELL_AURA_APPLIED", "StormforgedSpear", 228918)
	self:Log("SPELL_AURA_APPLIED", "StormforgedSpearDebuff", 228932) -- Tank got hit
	self:Log("SPELL_CAST_SUCCESS", "ExpelLightSuccess", 228028)
	self:Log("SPELL_AURA_APPLIED", "ExpelLightApplied", 228029)
	self:Log("SPELL_AURA_REMOVED", "ExpelLightRemoved", 228029)
	self:Log("SPELL_CAST_START", "Revivify", 228171)

	self:Log("SPELL_AURA_APPLIED", "BrandedFixate", 227490, 227491, 227498, 227499, 227500) -- Add Fixates
	self:Log("SPELL_AURA_REMOVED", "BrandedFixateRemoved", 227490, 227491, 227498, 227499, 227500) -- Add Fixates
	self:Log("SPELL_CAST_SUCCESS", "RunicShield", 227594, 227595, 227596, 227597, 227598) -- Add regains shield
	self:Death("RunebearerDeath", 114996)
	self:Log("SPELL_AURA_APPLIED", "Branded", 229579, 229580, 229581, 229582, 229583) -- Mythic Debuffs
	self:Log("SPELL_AURA_APPLIED", "Protected", 229584) -- Mythic Debuffs
	self:Log("SPELL_AURA_APPLIED", "RunicBrand", 231311, 231342, 231344, 231345, 231346) -- Mythic P3 Debuffs
	self:Log("SPELL_AURA_REMOVED", "RunicBrandRemoved", 231311, 231342, 231344, 231345, 231346) -- Mythic P3 Debuffs
	self:Log("SPELL_CAST_SUCCESS", "RadiantSmite", 231350)

	self:Log("SPELL_AURA_APPLIED", "CleansingFlameDamage", 227475) -- different spellIds for aura and damage
	self:Log("SPELL_DAMAGE", "CleansingFlameDamage", 228683) -- different spellIds for aura and damage
	self:Log("SPELL_MISSED", "CleansingFlameDamage", 228683) -- different spellIds for aura and damage
end

function mod:OnEngage()
	phase = 1
	hornCount = 1
	shieldCount = 1
	expelCount = 1
	spearCount = 1
	stormCount = 1
	runesUp = 0
	myAddGUID = ""
	wipe(addGUIDs)
	isHymdallFighting = true
	isHyrjaFighting = true
	castingHorn = false
	wipe(revivifyBarTexts)
	wipe(addFixates)
	for _,t in pairs(proxLists) do
		wipe(t)
	end

	self:Bar(228012, self:Easy() and 10 or 8, CL.count:format(self:SpellName(228012), hornCount)) -- Horn of Valor
	self:Bar(228162, self:Easy() and 30 or self:Mythic() and 20 or 24, CL.count:format(self:SpellName(228162), shieldCount)) -- Shield of Light
	self:Bar(228029, self:Easy() and 40 or self:Mythic() and 25 or 32) -- Expel Light
	self:Bar(227503, self:Easy() and 45 or self:Mythic() and 35 or 40) -- Draw Power
	self:Bar(227629, self:Easy() and 78 or self:Mythic() and 68 or 73) -- Unerring Blast
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
	if spellId == 229168 then -- Test for Players (Phase 1 end)
		phase = 2
		self:Message("stages", "Neutral", "Long", CL.stage:format(2), false)
		for _,barText in pairs(revivifyBarTexts) do
			self:StopBar(barText)
		end
		self:StopBar(CL.count:format(self:SpellName(228162), shieldCount)) -- Shield of Light
		self:StopBar(228029) -- Expel Light
		self:StopBar(CL.count:format(self:SpellName(228012), hornCount)) -- Horn of Valor
		self:StopBar(227503) -- Draw Power
		self:CDBar("stages", 8, self:SpellName(L.odyn), L.odyn_icon)
		isHymdallFighting = nil
		isHyrjaFighting = nil
	elseif spellId == 227882 then -- Leap into Battle (Phase 2 start)
		if not self:Easy() then
			self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
			self:Bar(-14404, 16, L.hyrja, L.hyrja_icon)
		end
		self:Bar(227503, self:Mythic() and 37.5 or 43) -- Draw Power
		self:Bar(227629, self:Mythic() and 70 or 73) -- Unerring Blast
	elseif spellId == 228740 then
		phase = 3
		self:Message("stages", "Neutral", "Long", CL.stage:format(3), false)
		self:StopBar(L.hyrja)
		self:StopBar(L.hymdall)
		self:StopBar(227503) -- Draw Power
		self:StopBar(227629) -- Unerring Blast
		self:Bar(227807, 4) -- Storm of Justice
		self:Bar(228918, 9) -- Stormforged Spear
		if self:Mythic() then
			self:Bar(197961, 21) -- Runic Brand
		end
	elseif spellId == 229576 or spellId == 227503 then -- Draw Power, 229576 = mythic, 227503 = others
		runesUp = (self:Easy() and phase == 1 and 3) or 5 -- could be :Normal(), not sure about LFR
		self:Message(227503, "Attention", "Long")
	elseif spellId == 231297 then -- Runic Brand P3, Mythic
		self:Bar(231350, 7.5) -- Radiant Smite
	end
end

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	if phase ~= 2 then return end
	local hymdallFound, hyrjaFound = nil, nil
	for i = 1, 5 do
		local unit = ("boss%d"):format(i)
		local guid = UnitGUID(unit)
		if guid then
			local mobId = self:MobId(guid)
			if mobId == 114361 then -- Hymdall
				hymdallFound = true
				if not isHymdallFighting then
					isHymdallFighting = true
					hornCount = 1
					self:Message(-14404, "Neutral", "Info", self:SpellName(L.hymdall), false)
					self:CDBar(228012, 10) -- Horn of Valor
					self:CDBar(-14404, self:Mythic() and 66 or 69.5, L.hyrja, L.hyrja_icon)
				end
			elseif mobId == 114360 then -- Hyrja
				hyrjaFound = true
				if not isHyrjaFighting then
					isHyrjaFighting = true
					shieldCount = 1
					self:Message(-14404, "Neutral", "Info", self:SpellName(L.hyrja), false)
					self:CDBar(228029, 5) -- Expel Light
					self:CDBar(228162, 9.5) -- Shield of Light
					self:CDBar(-14404, self:Mythic() and 66 or 69.5, L.hymdall, L.hymdall_icon)
				end
			end
		end
	end
	if not hymdallFound and isHymdallFighting then
		if castingHorn then
			castingHorn = false
			self:CloseProximity(228012) -- Horn of Valor
		end
		self:Message(-14404, "Positive", "Info", L.yields:format(self:SpellName(L.hymdall)), false)
		isHymdallFighting = nil
		self:StopBar(CL.count:format(self:SpellName(228012), hornCount)) -- Horn of Valor
	end
	if not hyrjaFound and isHyrjaFighting then
		self:Message(-14404, "Positive", "Info", L.yields:format(self:SpellName(L.hyrja)), false)
		isHyrjaFighting = nil
		self:StopBar(CL.count:format(self:SpellName(228162), shieldCount)) -- Shield of Light
		self:StopBar(228029) -- Expel Light
	end
end

do
	local protected = mod:SpellName(229584)
	function mod:UnerringBlast(args)
		self:Message(args.spellId, "Urgent", "Alert", CL.casting:format(args.spellName))
		self:CastBar(args.spellId, 3)
		self:Bar(227503, self:Easy() and 45 or 35) -- Draw Power
		self:Bar(args.spellId, self:Easy() and 78 or (self:Mythic() and (phase == 2 and 69 or 68)) or 73)

		if self:Mythic() and not UnitDebuff("player", protected) then
			self:Message(229584, "Personal", nil, CL.no:format(protected))
		end
	end
end

do
	local function printTarget(self, player, guid)
		local t = self:Easy() and 5 or 4
		if self:Me(guid) then
			self:Say(228162)
			self:SayCountdown(228162, t)
		end
		self:PrimaryIcon(228162, player)
		self:TargetMessage(228162, player, "Important", "Alarm", nil, nil, true)
		self:TargetBar(228162, t, player)
	end

	function mod:ShieldOfLight(args)
		self:GetBossTarget(printTarget, 0.4, args.sourceGUID)
		shieldCount = shieldCount + 1

		local t = 0
		if self:Easy() then
			t = 75
		else
			t = (self:Mythic() and (timers[args.spellId][shieldCount] or 20)) or phase == 2 and 25.5 or shieldCount % 2 == 0 and 32 or 38
		end
		self:Bar(args.spellId, t, CL.count:format(args.spellName, shieldCount))
	end

	function mod:ShieldOfLightSuccess(args)
		self:PrimaryIcon(args.spellId)
	end
end

function mod:HornOfValor(args)
	castingHorn = true
	self:Message(args.spellId, "Urgent", "Alert", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, self:Easy() and 5 or 4.5, CL.count:format(args.spellName, hornCount))
	hornCount = hornCount + 1

	local t = 0
	if self:Easy() then
		t = 75
	else
		t = (self:Mythic() and (timers[args.spellId][hornCount] or 20)) or hornCount % 2 == 0 and 27 or 43 -- TODO phase 2 CD
	end
	self:Bar(args.spellId, t, CL.count:format(args.spellName, hornCount))
	self:OpenProximity(args.spellId, 5)
end

function mod:HornOfValorSuccess(args)
	castingHorn = false
	self:CloseProximity(args.spellId)
end

function mod:StormOfJustice(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
		self:TargetBar(args.spellId, 5, args.destName)
		self:Say(args.spellId)
		self:Flash(args.spellId)
	end
end

function mod:StormOfJusticeSuccess(args)
	self:Bar(args.spellId, stormCount % 3 == 0 and 13.5 or 11)
	stormCount = stormCount + 1
end

function mod:ValarjarsBond()
	self:TargetMessage(228018, "Positive", "Long")
end

function mod:OdynsTest(args)
	if args.amount % 3 == 0 then
		-- This is the buff the boss gains if he is hitting the same tank. It's not really a stack message on the tank, but this is a clearer way of presenting it.
		self:StackMessage(args.spellId, self:UnitName("boss1target"), args.amount, "Attention")
	end
end

function mod:StormforgedSpear(args)
	self:TargetMessage(args.spellId, args.destName, "Important", "Alarm")
	self:TargetBar(args.spellId, 6, args.destName)
	self:Bar(args.spellId, spearCount % 3 == 0 and 13.5 or 11)
	self:PrimaryIcon(args.spellId, args.destName)

	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
	spearCount = spearCount + 1
end

function mod:StormforgedSpearDebuff()
	self:PrimaryIcon(228918)
end

function mod:ExpelLightSuccess()
	expelCount = expelCount + 1

	local t = 0
	if self:Easy() then
		t = expelCount % 2 == 0 and 20 or 55
	else
		t = (self:Mythic() and (timers[228029][expelCount] or 20)) or phase == 2 and 18 or expelCount % 2 == 0 and 32 or 38
	end
	self:Bar(228029, t)
end

do
	function mod:ExpelLightApplied(args)
		self:TargetMessage(args.spellId, args.destName, "Important", "Alarm")
		self:PrimaryIcon(args.spellId, args.destName)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:OpenProximity(args.spellId, 8)
		else
			self:OpenProximity(args.spellId, 8, args.destName)
		end
	end

	function mod:ExpelLightRemoved(args)
		self:PrimaryIcon(args.spellId)
		self:CloseProximity(args.spellId)
	end
end

function mod:Revivify(args)
	if castingHorn and self:MobId(args.sourceGUID) == 114361 then -- Hymdall
		castingHorn = false
		self:CloseProximity(228012) -- Horn of Valor
	end
	self:TargetMessage(args.spellId, args.sourceName, "Positive", "Long")
	local text = CL.other:format(args.sourceName, args.spellName)
	revivifyBarTexts[#revivifyBarTexts+1] = text
	self:Bar(args.spellId, self:Easy() and 15 or 10, text)
end

local function updateInfoBox()
	local addsAlive = 0
	for i,spellId in pairs({227490, 227491, 227498, 227499, 227500}) do
		mod:SetInfo(-14495, i*2-1, L[spellId])
		if addFixates[spellId] then
			mod:SetInfo(-14495, i*2, addFixates[spellId])
			addsAlive = addsAlive + 1
		else
			mod:SetInfo(-14495, i*2, "")
		end
	end

	if addsAlive > 0 then
		mod:OpenInfo(-14495, mod:SpellName(227490))
	else
		mod:CloseInfo(-14495)
	end
end

function mod:BrandedFixate(args)
	if self:Me(args.destGUID) then
		self:Message(-14495, "Personal", "Warning", L[args.spellId], args.spellId)
		self:Flash(-14495, args.spellId)
		self:Say(-14495, L.say[args.spellId]:format(args.spellName))
		myAddGUID = args.sourceGUID
	end
	addFixates[args.spellId] = self:ColorName(args.destName)
	addGUIDs[args.spellId] = args.sourceGUID
	updateInfoBox()
end

function mod:BrandedFixateRemoved(args)
	if self:Me(args.destGUID) then
		myAddGUID = ""
	end
	addFixates[args.spellId] = nil
	updateInfoBox()
end

function mod:RunicShield(args)
	if args.sourceGUID == myAddGUID then
		self:Message(-14495, "Personal", "Warning", CL.on:format(args.spellName, args.sourceName), args.spellId)
	end
end

do
	local texTable = {
		[227490] = "|T1323037:15:15:0:0:64:64:4:60:4:60|t", -- Boss_OdunRunes_Purple
		[227491] = "|T1323039:15:15:0:0:64:64:4:60:4:60|t", -- Boss_OdunRunes_Orange
		[227498] = "|T1323038:15:15:0:0:64:64:4:60:4:60|t", -- Boss_OdunRunes_Yellow
		[227499] = "|T1323035:15:15:0:0:64:64:4:60:4:60|t", -- Boss_OdunRunes_Blue
		[227500] = "|T1323036:15:15:0:0:64:64:4:60:4:60|t", -- Boss_OdunRunes_Green
	}

	function mod:RunebearerDeath(args)
		local addsUp = ""
		for spellId,tex in pairs(texTable) do
			if addGUIDs[spellId] == args.destGUID then
				addGUIDs[spellId] = nil
			end
			if addGUIDs[spellId] then
				addsUp = addsUp .. tex
			end
		end
		runesUp = runesUp - 1
		self:ScheduleTimer("Message", 0.3, 227503, "Positive", nil, CL.add_remaining:format(runesUp) .. addsUp)
	end
end

do
	local lookupTable = {
		[229579] = 227490, -- Boss_OdunRunes_Purple
		[229580] = 227491, -- Boss_OdunRunes_Orange
		[229581] = 227498, -- Boss_OdunRunes_Yellow
		[229582] = 227499, -- Boss_OdunRunes_Blue
		[229583] = 227500, -- Boss_OdunRunes_Green
	}
	function mod:Branded(args)
		if self:Me(args.destGUID) then
			self:Message(-14495, "Personal", "Warning", L[lookupTable[args.spellId]], lookupTable[args.spellId])
			self:Flash(-14495, args.spellId)
		end
	end
end

function mod:Protected(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Positive", "Info", CL.you:format(args.spellName))
	end
end

do
	local isOnMe = 0

	local lookupTable = {
		[231311] = 227490, -- Boss_OdunRunes_Purple
		[231342] = 227491, -- Boss_OdunRunes_Orange
		[231344] = 227498, -- Boss_OdunRunes_Yellow
		[231345] = 227499, -- Boss_OdunRunes_Blue
		[231346] = 227500, -- Boss_OdunRunes_Green
	}

	local function updateProximity(self)
		local totalList = {} -- everyone who has another debuff
		for spellId,table in pairs(proxLists) do
			if isOnMe ~= spellId then
				for _,player in pairs(table) do
					totalList[#totalList+1] = player
				end
			end
		end
		if #totalList > 0 then
			self:OpenProximity(197961, 15, totalList)
		else
			self:CloseProximity(197961)
		end
	end

	local function wipeProxLists(self)
		for _,t in pairs(proxLists) do
			wipe(t)
		end
		updateProximity(self)
	end

	function mod:RunicBrand(args)
		if self:Me(args.destGUID) then
			local tanslatedSpellId = lookupTable[args.spellId]
			isOnMe = args.spellId
			self:Message(197961, "Personal", "Warning", CL.other:format(args.spellName, L[tanslatedSpellId]), args.spellId)
			self:Flash(197961, args.spellId)
			self:Say(197961, L.say[tanslatedSpellId]:format(args.spellName))
			self:TargetBar(197961, 10, args.destName, nil, args.spellId)
		end
		proxLists[args.spellId][#proxLists[args.spellId]+1] = args.destName
		updateProximity(self)
	end


	function mod:RunicBrandRemoved(args)
		if self:Me(args.destGUID) then
			isOnMe = 0
		end
		tDeleteItem(proxLists[args.spellId], args.destName)
		updateProximity(self)
	end

	function mod:RadiantSmite(args)
		self:Message(args.spellId, "Important", "Long")
		wipeProxLists(self)
		self:Bar(197961, 28)
	end
end

do
	local prev = 0
	function mod:CleansingFlameDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			prev = t
			self:Message(227475, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end
