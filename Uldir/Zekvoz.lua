if not C_ChatInfo then return end -- XXX Don't load outside of 8.0

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Zek'voz, Herald of N'zoth", 1861, 2169)
if not mod then return end
mod:RegisterEnableMob(134445) -- Zek'vhozj
mod.engageId = 2136
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ General ]]--
		265451, -- Surging Darkness
		265231, -- Void Lash
		{265248, "TANK"}, -- Shatter

		--[[ Stage 1 ]]--
		264382, -- Eye Beam
		264219, -- Fixate

		--[[ Stage 2 ]]--
		265360, -- Roiling Deceit
		267180, -- Void Bolt

		--[[ Stage 3 ]]--
		267239, -- Orb of Corruption
		265662, -- Corruptor's Pact
	},{
		[265451] = "general",
		[264382] = CL.stage:format(1),
		[265360] = CL.stage:format(2),
		[267239] = CL.stage:format(3),
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:Log("SPELL_CAST_SUCCESS", "SurgingDarkness", 265451)
	self:Log("SPELL_CAST_START", "VoidLash", 265231)
	self:Log("SPELL_CAST_START", "Shatter", 265248)

	--[[ Stage 1 ]]--
	self:Log("SPELL_CAST_START", "EyeBeam", 264382)
	self:Log("SPELL_AURA_APPLIED", "Fixate", 264219)

	--[[ Stage 2 ]]--
	self:Log("SPELL_AURA_APPLIED", "RoilingDeceit", 265360)
	self:Log("SPELL_AURA_REMOVED", "RoilingDeceitRemoved", 265360)
	self:Log("SPELL_CAST_START", "VoidBolt", 267180)

	--[[ Stage 3 ]]--
	self:Log("SPELL_CAST_START", "OrbofCorruption", 267239)
	self:Log("SPELL_AURA_APPLIED", "CorruptorsPact", 265662)
	self:Log("SPELL_AURA_REMOVED", "CorruptorsPactRemoved", 265662)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ General ]]--
function mod:SurgingDarkness(args)
	self:PlaySound(args.spellId, "warning")
	self:Message(args.spellId, "red")
end

function mod:VoidLash(args)
	self:PlaySound(args.spellId, "alarm")
	self:Message(args.spellId, "orange")
end

function mod:Shatter(args)
	self:PlaySound(args.spellId, "alert")
	self:Message(args.spellId, "cyan") -- XXX purple for tank?
end

--[[ Stage 1 ]]--
function mod:EyeBeam(args)
	self:PlaySound(args.spellId, "alert")
	self:Message(args.spellId, "yellow")
end

function mod:Fixate(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:TargetMessage2(args.spellId, "blue", args.destName)
	end
end

--[[ Stage 2 ]]--
function mod:RoilingDeceit(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:TargetMessage2(args.spellId, "blue", args.destName)
		self:SayCountdown(args.spellId, 12)
	end
end

function mod:RoilingDeceitRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:VoidBolt(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

--[[ Stage 3 ]]--
function mod:OrbofCorruption(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:CorruptorsPact(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "long")
		self:TargetMessage2(args.spellId, "blue", args.destName)
		self:SayCountdown(args.spellId, 20)
	end
end

function mod:CorruptorsPactRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end
