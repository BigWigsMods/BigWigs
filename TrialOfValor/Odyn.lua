if not IsTestBuild() then return end

--------------------------------------------------------------------------------
-- TODO List:


--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Odyn-TrialOfValor", 1114, 1819)
if not mod then return end
mod:RegisterEnableMob(116760, 109969, 114982, 114263, 115323, 95676, 98196, 96589, 96469)
--mod.engageId = 0
--mod.respawnTime = 0

--------------------------------------------------------------------------------
-- Locals
--



--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		228162, -- Shield of Light
		228012, -- Horn of Valor
		227503, -- Draw Power
		227959, -- Storm of Justice
		228018, -- Valarjar's Bond
		{227626, "TANK"}, -- Odyn's Test
		{228915, "SAY"}, -- Stormforged Spear
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_CAST_START", "ShieldOfLight", 228162)
	self:Log("SPELL_CAST_START", "HornOfValor", 228012, 191284)
	self:Log("SPELL_CAST_SUCCESS", "DrawPower", 227503)
	self:Log("SPELL_AURA_APPLIED", "StormOfJustice", 227959, 227807, 227808)
	self:Log("SPELL_AURA_APPLIED", "ValarjarsBond", 228018, 229529, 228016, 229469)
	self:Log("SPELL_AURA_APPLIED_DOSE", "OdynsTest", 227626)
	self:Log("SPELL_AURA_APPLIED", "StormforgedSpear", 228915, 228914, 228932, 228918)
end

function mod:OnEngage()
	
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ShieldOfLight(args)
	self:Message(args.spellId, "Urgent", "Alert", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 4)
end

function mod:HornOfValor(args)
	self:Message(228012, "Urgent", "Alert", CL.casting:format(args.spellName))
	self:Bar(228012, 4)
end

function mod:DrawPower(args)
	self:Message(227503, "Attention", "Long")
	self:Bar(227503, 30)
end

function mod:StormOfJustice(args)
	if self:Me(guid) then
		self:TargetMessage(227959, args.destName, "Urgent", "Warning")
		self:Bar(227959, 6)
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
	self:TargetMessage(228915, args.destName, "Important", "Alarm")
	if self:Me(guid) then
		self:Say(228915)
	end
end

