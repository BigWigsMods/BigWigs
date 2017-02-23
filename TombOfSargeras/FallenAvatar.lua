if not IsTestBuild() then return end -- XXX dont load on live
--------------------------------------------------------------------------------
-- TODO List:
-- - Shadowy Blades Proximity?

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Fallen Avatar", 1147, 1873)
if not mod then return end
mod:RegisterEnableMob(120436) -- Fallen Avatar
mod.engageId = 2038
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		239058, -- Touch of Sargeras
		239132, -- Rupture Realities
		{234059, "FLASH", "SAY"}, -- Unbound Chaos
		236604, -- Shadowy Blades
		{236494, "TANK"}, -- Desolate
		240594, -- Consume
		236528, -- Ripple of Darkness
		233856, -- Cleansing Protocol
		233556, -- Corrupted Matrix
		{239739, "FLASH", "SAY"}, -- Dark Mark
		235572, -- Rupture Realities
		242017, -- Black Winds
		--234418, -- Rain of the Destroyer
	},{
		[239058] = -14709, -- Stage One: A Slumber Disturbed
		[233856] = -14713, -- Maiden of Valor
		[233556] = -15123, -- Containment Pylon
		[239739] = -14719, -- Stage Two: An Avatar Awakened
		--[234418] = "mythic",
	}
end

function mod:OnBossEnable()
	-- Stage One: A Slumber Disturbed
	self:Log("SPELL_CAST_SUCCESS", "TouchofSargeras", 239058) -- Touch of Sargeras
	self:Log("SPELL_CAST_START", "RuptureRealities", 239132) -- Rupture Realities
	self:Log("SPELL_AURA_APPLIED", "UnboundChaos", 234059) -- Unbound Chaos
	self:Log("SPELL_CAST_SUCCESS", "ShadowyBlades", 236604) -- Shadowy Blades	
	self:Log("SPELL_CAST_START", "Desolate", 236494) -- Desolate
	self:Log("SPELL_AURA_APPLIED", "DesolateApplied", 236494) -- Desolate
	self:Log("SPELL_AURA_APPLIED_DOSE", "DesolateApplied", 236494) -- Desolate
	self:Log("SPELL_CAST_SUCCESS", "Consume", 240594) -- Consume
	self:Log("SPELL_CAST_SUCCESS", "RippleofDarkness", 236528) -- Ripple of Darkness
	
	-- Maiden of Valor
	self:Log("SPELL_CAST_START", "CleansingProtocol", 233856) -- Cleansing Protocol	
	
	-- Containment Pylon
	self:Log("SPELL_CAST_START", "CorruptedMatrix", 233556) -- Corrupted Matrix
	
	-- Stage Two: An Avatar Awakened
	self:Log("SPELL_AURA_APPLIED", "DarkMark", 239739) -- Dark Mark
	self:Log("SPELL_CAST_START", "RuptureRealitiesP2", 235572) -- Rupture Realities
	self:Log("SPELL_CAST_SUCCESS", "BlackWinds", 242017) -- Black Winds
	
	-- Mythic
	--self:Log("SPELL_CAST_SUCCESS", "RainoftheDestroyer", 234418) -- Rain of the Destroyer
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:TouchofSargeras(args)
	self:Message(args.spellId, "Attention", "Alert")
	--self:Bar(args.spellId, 10)
end

function mod:RuptureRealities(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
	--self:Bar(args.spellId, 10)
end

function mod:UnboundChaos(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
	end
	--self:Bar(args.spellId, 10)
end

function mod:ShadowyBlades(args)
	self:Message(args.spellId, "Attention", "Alert")
	--self:Bar(args.spellId, 10)
end

function mod:Desolate(args)
	self:Message(args.spellId, "Attention", "Alert", CL.casting:format(args.spellName))
	--self:Bar(args.spellId, 10)
end

function mod:DesolateApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Urgent", "Warning")
end

function mod:Consume(args)
	self:Message(args.spellId, "Attention", "Alert")
	--self:Bar(args.spellId, 10)
end

function mod:RippleofDarkness(args)
	self:Message(args.spellId, "Important", "Warning")
	--self:Bar(args.spellId, 10)
end

function mod:CleansingProtocol(args)
	self:Message(args.spellId, "Urgent", "Alarm", CL.casting:format(args.spellName))
	--self:Bar(args.spellId, 10)
end

function mod:CorruptedMatrix(args)
	self:Message(args.spellId, "Important", "Warning", CL.casting:format(args.spellName))
	--self:Bar(args.spellId, 10)
end

do
	local list = mod:NewTargetList()
	function mod:DarkMark(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Attention", "Alert")
			--self:Bar(args.spellId, 10)
		end
	end
end

function mod:RuptureRealitiesP2(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
	--self:Bar(args.spellId, 10)
end

function mod:BlackWinds(args)
	self:Message(args.spellId, "Important", "Alarm")
	--self:Bar(args.spellId, 10)
end

--function mod:RainoftheDestroyer(args)
--	self:Message(args.spellId, "Important", "Warning")
	--self:Bar(args.spellId, 10)
--end

