
--------------------------------------------------------------------------------
-- TODO List:
-- - P2 -> P3 Transition


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

local hornCount = 1
local runesUp = 0
local myAddGUID = ""
local isHymdallFighting, isHyrjaFighting = nil, nil
local revivifyBarTexts = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.odyn = -14003
	L.hymdall = -14005
	L.hyrja = -14006

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
		228012, -- Horn of Valor

		--[[ Hyrja ]]--
		{228029, "SAY", "ICON"}, -- Expel Light
		{228162, "SAY", "ICON"}, -- Shield of Light

		--[[ Odyn ]]--
		227503, -- Draw Power
		227629, -- Unerring Blast
		{227626, "TANK"}, -- Odyn's Test
		-14495, -- Runic Brand

		--[[ Stage Two: The Prime Designate ]]--
		-14404, -- Test of the Ages

		--[[ Stage Three: The Final Test ]]--
		{228918, "SAY"}, -- Stormforged Spear
		{227807, "SAY"}, -- Storm of Justice
		227475, -- Cleansing Flame
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
	self:Log("SPELL_CAST_SUCCESS", "ShieldOfLightEnd", 228162)
	self:Log("SPELL_CAST_START", "HornOfValor", 228012)
	self:Log("SPELL_AURA_APPLIED", "StormOfJustice", 227807)
	self:Log("SPELL_AURA_APPLIED", "ValarjarsBond", 228018, 229529, 228016, 229469) -- XXX
	self:Log("SPELL_AURA_APPLIED_DOSE", "OdynsTest", 227626)
	self:Log("SPELL_AURA_APPLIED", "StormforgedSpear", 228918)
	self:Log("SPELL_AURA_APPLIED", "ExpelLight", 228029)
	self:Log("SPELL_AURA_REMOVED", "ExpelLightRemoved", 228029)
	self:Log("SPELL_CAST_START", "Revivify", 228171)

	self:Log("SPELL_AURA_APPLIED", "DrawPower", 227976, 227974, 227961, 227975, 227973) -- Buffs on Odyn when Runes are up
	self:Log("SPELL_AURA_REMOVED", "DrawPowerRemoved", 227976, 227974, 227961, 227975, 227973) -- Buffs on Odyn when Runes are up
	self:Log("SPELL_AURA_APPLIED", "Branded", 227491, 227498, 227490, 227500, 227499) -- Debuffs on players
	self:Log("SPELL_AURA_APPLIED", "BrandedRemoved", 227491, 227498, 227490, 227500, 227499) -- Debuffs on players
	self:Log("SPELL_CAST_SUCCESS", "RunicShield", 227594, 227595, 227596, 227597, 227598) -- Add regains shield

	self:Log("SPELL_AURA_APPLIED", "CleansingFlameDamage", 227475) -- ?
	self:Log("SPELL_PERIODIC_DAMAGE", "CleansingFlameDamage", 227475) -- ?
	self:Log("SPELL_PERIODIC_MISSED", "CleansingFlameDamage", 227475) -- ?
end

function mod:OnEngage()
	hornCount = 1
	runesUp = 0
	myAddGUID = ""
	isHymdallFighting = true
	isHyrjaFighting = true
	wipe(revivifyBarTexts)
	self:Bar(228012, 8) -- Horn of Valor
	self:Bar(228162, 24) -- Shield of Light
	self:Bar(228028, 32) -- Expel Light
	self:Bar(227503, 40) -- Draw Power
	self:Bar(227629, 70) -- Unerring Blast
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, _, spellId)
	if spellId == 229168 then -- Test for Players (Phase 1 end)
		self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
		self:Message("stages", "Neutral", "Long", CL.stage:format(2), false)
		for _,barText in pairs(revivifyBarTexts) do
			self:StopBar(barText)
		end
		self:Bar("stages", 5.6, self:SpellName(L.odyn))
		isHymdallFighting = nil
		isHyrjaFighting = nil
	elseif spellId == 227882 then -- Leap into Battle (Phase 2 start)
		self:Bar(-14404, 16, L.hyrja) -- could be percentage based
		self:Bar(227503, 43) -- Draw Power
		self:Bar(227629, 73) -- Unerring Blast
	end
end

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
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
					self:Message(-14404, "Neutral", "Info", self:SpellName(L.hymdall), false)
					self:CDBar(228012, 10) -- Horn of Valor
				end
			elseif mobId == 114360 then
				hyrjaFound = true
				if not isHyrjaFighting then
					isHyrjaFighting = true
					self:Message(-14404, "Neutral", "Info", self:SpellName(L.hyrja), false)
					self:CDBar(228029, 5) -- Expel Light
					self:CDBar(228162, 9.5) -- Shield of Light
				end
			end
		end
	end
	if not hymdallFound then
		isHymdallFighting = nil
		self:StopBar(228012)
	end
	if not hyrjaFound then
		isHyrjaFighting = nil
		self:StopBar(228162) -- Shield of Light
		self:StopBar(228029) -- Expel Light
	end
end

function mod:UnerringBlast(args)
	self:Message(args.spellId, "Urgent", "Alert", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 3, CL.cast:format(args.spellName))
	self:Bar(227503, 40) -- Draw Power
	self:Bar(args.spellId, 70)
end

do
	local function printTarget(self, player, guid)
		if self:Me(guid) then
			self:Say(228162)
		end
		self:PrimaryIcon(228162, player)
		self:TargetMessage(228162, player, "Important", "Alarm", nil, nil, true)
		self:TargetBar(228162, 4, player)
	end

	function mod:ShieldOfLight(args)
		self:GetBossTarget(printTarget, 0.4, args.sourceGUID)
		self:CDBar(args.spellId, 32)
	end

	function mod:ShieldOfLightEnd(args)
		self:PrimaryIcon(args.spellId)
	end
end

function mod:HornOfValor(args)
	self:Message(args.spellId, "Urgent", "Alert", CL.casting:format(args.spellName))
	hornCount = hornCount + 1
	self:CDBar(args.spellId, hornCount % 2 == 0 and 27 or 43)
end

function mod:StormOfJustice(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
		self:Bar(args.spellId, 5)
		self:Say(args.spellId)
	end
end

function mod:ValarjarsBond(args)
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
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
end

do
	function mod:ExpelLight(args)
		self:TargetMessage(args.spellId, args.destName, "Important", "Alarm")
		self:PrimaryIcon(args.spellId, args.destName)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
	end

	function mod:ExpelLightRemoved(args)
		self:PrimaryIcon(args.spellId)
	end
end

function mod:Revivify(args)
	self:TargetMessage(args.spellId, args.sourceName, "Positive", "Long")
	local text = CL.other:format(args.sourceName, args.spellName)
	revivifyBarTexts[#revivifyBarTexts+1] = text
	self:Bar(args.spellId, 10, text)
end

do
	local prev = 0
	function mod:DrawPower()
		runesUp = runesUp + 1
		local t = GetTime()
		if t-prev > 5 then
			self:Message(227503, "Attention", "Long")
		end
	end
end

function mod:DrawPowerRemoved()
	runesUp = runesUp - 1
	self:Message(227503, "Positive", nil, CL.add_remaining:format(runesUp))
end

function mod:Branded(args)
	if self:Me(args.destGUID) then
		self:Message(-14495, "Personal", "Warning", L[args.spellId], args.spellId)
		myAddGUID = args.sourceGUID
	end
end

function mod:BrandedRemoved(args)
	if self:Me(args.destGUID) then
		myAddGUID = ""
	end
end

function mod:RunicShield(args)
	if args.sourceGUID == myAddGUID then
		self:Message(-14495, "Personal", "Warning", CL.on:format(args.spellName, args.sourceName), args.spellId)
	end
end

do
	local prev = 0
	function mod:CleansingFlameDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
		end
	end
end
