if not IsTestBuild() then return end

--------------------------------------------------------------------------------
-- TODO List:


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



--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
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
		227629, -- Unerring Blast
		{228162, "SAY", "ICON"}, -- Shield of Light
		228012, -- Horn of Valor
		{227807, "SAY"}, -- Storm of Justice
		228018, -- Valarjar's Bond
		{227626, "TANK"}, -- Odyn's Test
		{228918, "SAY"}, -- Stormforged Spear
		228171, -- Revivify
		{228029, "SAY", "ICON"}, -- Expel Light
		-14495, -- Runic Brand
		227475, -- Cleansing Flame
	}
end

function mod:OnBossEnable()
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

	self:Log("SPELL_AURA_APPLIED", "Branded", 227491, 227498, 227490, 227500, 227499)

	self:Log("SPELL_AURA_APPLIED", "CleansingFlameDamage", 227475)
	self:Log("SPELL_PERIODIC_DAMAGE", "CleansingFlameDamage", 227475)
	self:Log("SPELL_PERIODIC_MISSED", "CleansingFlameDamage", 227475)
end

function mod:OnEngage()
	self:CDBar(228012, 8) -- Horn of Valor
	self:CDBar(228162, 24) -- Shield of Light
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UnerringBlast(args)
	self:Message(args.spellId, "Urgent", "Alert", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 3, CL.cast:format(args.spellName))
end

do
	local function printTarget(self, player, guid)
		if self:Me(guid) then
			self:Say(228162)
		end
		self:PrimaryIcon(228162, player)
		self:TargetMessage(228162, player, "Important", "Alarm", nil, nil, true)
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
	self:CDBar(args.spellId, 32)
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
end

function mod:Branded(args)
	if self:Me(args.destGUID) then
		self:Message(-14495, "Personal", "Warning", L[args.spellId], args.spellId)
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
