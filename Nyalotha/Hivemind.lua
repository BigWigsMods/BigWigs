if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- TODO:
--
--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Hivemind", 2217, 2372)
if not mod then return end
mod:RegisterEnableMob(157253, 157254) -- Ka'zir, Tek'ris
mod.engageId = 2333
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--
local acidicAqirCount = 1
local acidicAqirTimers = {15.0, 30.0, 40.0, 20.0, 25.0, 35.0, 30.0, 100.5, 30.0, 40.0, 20.0, 25.0, 35.0, 30.0}

local mindNumbingNovaCount = 1
local mindNumbingNovaTimers = {10.0, 50.0, 40.0, 45.0, 45.0, 100.5, 50.0, 40.0, 45.0, 45.0}

local nullificationBlastCount = 1
local nullificationBlastTimers = {27.0, 28.0, 45.0, 25.0, 25.0, 32.0, 18.0, 25.0, 82.5, 28.0, 45.0, 25.0, 25.0, 32.0}

local echoingVoidCount = 1
local echoingVoidTimers = {64.0, 16.0, 40.0, 45.0, 95.0, 84.5, 16.0, 40.0, 45.0}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- General
		307201, -- Ka'zir's Hivemind Control
		307213, -- Tek'ris's Hivemind Control
		-- Ka'zir
		308178, -- Volatile Eruption
		310340, -- Spawn Acidic Aqir
		313652, -- Mind-Numbing Nova
		-- Tek'ris
		308227, -- Accelerated Evolution
		307968, -- Nullification Blast
		307232, -- Echoing Void
	}
end

function mod:OnBossEnable()
	-- General
	self:Log("SPELL_CAST_START", "KazirsHivemindControl", 307201)
	self:Log("SPELL_CAST_START", "TekrissHivemindControl", 307213)

	-- Ka'zir
	self:Log("SPELL_CAST_START", "VolatileEruption", 308178)
	self:Log("SPELL_CAST_START", "SpawnAcidicAqir", 310340)
	self:Log("SPELL_CAST_START", "MindNumbingNovaStart", 313652)

	-- Tek'ris
	self:Log("SPELL_CAST_START", "AcceleratedEvolution", 308227)
	self:Log("SPELL_CAST_START", "NullificationBlast", 307968)
	self:Log("SPELL_CAST_START", "EchoingVoid", 307232)
end

function mod:OnEngage()
	acidicAqirCount = 1
	mindNumbingNovaCount = 1
	nullificationBlastCount = 1
	echoingVoidCount = 1

	self:Bar(310340, acidicAqirTimers[acidicAqirCount]) -- Spawn Acidic Aqir
	self:Bar(313652, mindNumbingNovaTimers[mindNumbingNovaCount]) -- Mind-Numbing Nova
	self:Bar(313652, nullificationBlastTimers[nullificationBlastCount]) -- Mind-Numbing Nova
	self:Bar(313652, echoingVoidTimers[echoingVoidCount]) -- Mind-Numbing Nova
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:KazirsHivemindControl(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "long")
	self:Bar(307213, 70) -- Tek'ris's Hivemind Control
end


function mod:TekrissHivemindControl(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "long")
	self:Bar(307201, 70) -- Ka'zir's Hivemind Control
end

function mod:VolatileEruption(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:SpawnAcidicAqir(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	acidicAqirCount = acidicAqirCount + 1
	self:Bar(args.spellId, acidicAqirTimers[acidicAqirCount])
end

function mod:MindNumbingNovaStart(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message2(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alarm")
		end
	end
	mindNumbingNovaCount = mindNumbingNovaCount + 1
	self:Bar(args.spellId, mindNumbingNovaTimers[mindNumbingNovaCount])
end

function mod:AcceleratedEvolution(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:NullificationBlast(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alarm")
	nullificationBlastCount = nullificationBlastCount + 1
	self:Bar(args.spellId, nullificationBlastTimers[nullificationBlastCount])
end

function mod:EchoingVoid(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	echoingVoidCount = echoingVoidCount + 1
	self:Bar(args.spellId, echoingVoidTimers[echoingVoidCount])
end
