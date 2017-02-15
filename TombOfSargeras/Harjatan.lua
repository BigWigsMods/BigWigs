if not IsTestBuild() then return end -- XXX dont load on live
--------------------------------------------------------------------------------
-- TODO List:

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Harjatan the Bludger", 1147, 1856)
if not mod then return end
mod:RegisterEnableMob(116407)
mod.engageId = 2036
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local uncheckedRageCounter = 1
local uncheckedRageTimers = {20.5, 21.5, 55, 20.6, 74, 20.5}

local drawInCounter = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{231998, "TANK"}, -- Jagged Abrasion
		231854, -- Unchecked Rage 
		232192, -- Commanding Roar
		232061, -- Draw In
		233429, -- Frigid Blows
		232174, -- Frosty Discharge
		{231729, "SAY", "FLASH"}, -- Aqueous Burst
		231904, -- Tend Wounds
		{234128, "SAY", "FLASH"}, -- Driven Assault
		240319, -- Hatching
	},{
		[231998] = "general",
		[231729] = -14555,
		[234128] = -14722,
		[240319] = "mythic",
	}
end

function mod:OnBossEnable()
	-- Boss
	self:Log("SPELL_AURA_APPLIED", "JaggedAbrasion", 231998)
	self:Log("SPELL_AURA_APPLIED_DOSE", "JaggedAbrasion", 231998)
	self:Log("SPELL_CAST_START", "UncheckedRage", 231854)
	self:Log("SPELL_CAST_START", "CommandingRoar", 232192)	
	self:Log("SPELL_CAST_START", "DrawIn", 232061)	
	--self:Log("SPELL_AURA_APPLIED", "FrigidBlows", 233429)
	--self:Log("SPELL_AURA_APPLIED_DOSE", "FrigidBlows", 233429)
	self:Log("SPELL_AURA_REMOVED_DOSE", "FrigidBlows", 233429)
	--self:Log("SPELL_AURA_REMOVED", "FrigidBlowsRemoved", 233429)	
	self:Log("SPELL_CAST_START", "FrostyDischarge", 232174)
	
	-- Adds
	self:Log("SPELL_AURA_APPLIED", "AqueousBurst", 231729)
	self:Log("SPELL_CAST_START", "TendWounds", 231904)	
	self:Log("SPELL_AURA_APPLIED", "DrivenAssault", 234016)
	
	-- Mythic	
	self:Log("SPELL_CAST_START", "Hatching", 240319)
end

function mod:OnEngage()
	uncheckedRageCounter = 1
	drawInCounter = 1
	
	self:Bar(231854, uncheckedRageTimers[uncheckedRageCounter]) -- Unchecked Rage
	self:Bar(232061, 60) -- Draw In
	
end

--------------------------------------------------------------------------------
-- Event Handlers
--


function mod:JaggedAbrasion(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount > 4 and "Warning")
end

function mod:UncheckedRage(args)
	uncheckedRageCounter = uncheckedRageCounter + 1
	self:Message(args.spellId, "Attention", "Alert")
	self:Bar(args.spellId, uncheckedRageTimers[uncheckedRageCounter] or 20.5)
end

function mod:CommandingRoar(args)
	self:Message(args.spellId, "Important", "Warning")
end

function mod:DrawIn(args)
	drawInCounter = drawInCounter + 1
	self:Message(args.spellId, "Important", "Alert", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 10, CL.casting:format(args.spellName))
	self:Bar(args.spellId, drawInCounter == 2 and 76 or 94)
end

function mod:FrigidBlows(args)
	local amount = args.amount or 1
	if amount < 5 then
		self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount < 2 and "Warning")
	end
end

--function mod:FrigidBlowsRemoved(args)
--	self:Message(args.spellId, "Positive", "Info", CL.removed:format(args.spellName))
--end

function mod:FrostyDischarge(args)
	self:Message(args.spellId, "Urgent", "Alert", CL.casting:format(args.spellName))
end

function mod:AqueousBurst(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Warning")
	if self:Me(args.sourceGUID) then
		self:Say(args.spellId)
		self:Flash(args.spellId)
	end
end

function mod:TendWounds(args)
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "Important", "Alert")
	end
end

function mod:DrivenAssault(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Warning")
	if self:Me(args.sourceGUID) then
		self:Say(args.spellId)
		self:Flash(args.spellId)
	end
end

function mod:Hatching(args)
	self:Message(args.spellId, "Important", "Long")
end

