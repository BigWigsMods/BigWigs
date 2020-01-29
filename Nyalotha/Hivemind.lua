--------------------------------------------------------------------------------
-- TODO:
-- - Confirm Volatile Eruption and Accelerated Evolution working, spells might've got hidden
-- - Add icons to empowered adds (IEEU?)
--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Hivemind", 2217, 2372)
if not mod then return end
mod:RegisterEnableMob(157253, 157254) -- Ka'zir, Tek'ris
mod.engageId = 2333
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--
local acidicAqirCount = 1
local nullificationBlastCount = 1
local echoingVoidCount = 1

local timersHeroic = {
	[310340] = {56.3, 65.0, 60.0, 62.5, 62.5, 62.5, 62.5}, -- Spawn Acidic Aqir
	[307968] = {26.3, 27.5, 23.8, 50.0, 25.0, 25.0, 26.3, 25.1, 24.9, 30.0, 25.0, 25.0, 25.0, 24.9, 25.0, 25.0}, -- Nullification Blast
	[307232] = {33.9, 66.1, 37.5, 72.6, 65.0, 68.7, 68.8, 13.8}, -- Echoing Void
}
local timersMythic = {
	[310340] = {45.0, 52.0, 48.0, 50.0, 50.0, 50.0, 50.0, 52.0}, -- Spawn Acidic Aqir
	[307968] = {22.0, 20.0, 20.0, 40.0, 20.0, 20.0, 21.0, 20.0, 20.0, 24.1, 19.9, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 30.0}, -- Nullification Blast
	[307232] = {27.0, 53.0, 30.0, 58.0, 52.0, 55.0, 66.0, 44.0} -- Echoing Void
}

local timers = mod:Mythic() and timersMythic or timersHeroic

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- General
		307201, -- Ka'zir's Hivemind Control
		307213, -- Tek'ris's Hivemind Control
		313672, -- Acid Pool
		307569, -- Dark Reconstitution
		-- Ka'zir
		314583, -- Volatile Eruption
		310340, -- Spawn Acidic Aqir
		313652, -- Mind-Numbing Nova
		-- Tek'ris
		308227, -- Accelerated Evolution
		307968, -- Nullification Blast
		{307232, "PROXIMITY"}, -- Echoing Void
	},{
		[307201] = "general",
		[314583] = self:SpellName(-20710), -- Ka'zir
		[308227] = self:SpellName(-20713), -- Ka'zir
	}
end

function mod:OnBossEnable()
	-- General
	self:Log("SPELL_CAST_START", "KazirsHivemindControl", 307201)
	self:Log("SPELL_CAST_START", "TekrissHivemindControl", 307213)
	self:Log("SPELL_CAST_START", "DarkReconstitution", 307569)

	-- Ka'zir
	self:Log("SPELL_CAST_START", "VolatileEruption", 308178)
	self:Log("SPELL_CAST_START", "SpawnAcidicAqir", 310340)
	self:Log("SPELL_CAST_START", "MindNumbingNovaStart", 313652)

	-- Tek'ris
	self:Log("SPELL_CAST_START", "AcceleratedEvolution", 308227)
	self:Log("SPELL_CAST_START", "NullificationBlast", 307968)
	self:Log("SPELL_CAST_START", "EchoingVoid", 307232)
	self:Log("SPELL_CAST_SUCCESS", "EchoingVoidSuccess", 307232)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 313672) -- Acid Pool
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 313672)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 313672)
end

function mod:OnEngage()
	acidicAqirCount = 1
	nullificationBlastCount = 1
	echoingVoidCount = 1
	timers = mod:Mythic() and timersMythic or timersHeroic

	self:Bar(310340, timers[310340][acidicAqirCount], CL.count:format(self:SpellName(310340), acidicAqirCount)) -- Spawn Acidic Aqir
	self:Bar(313652, self:Mythic() and 12 or 15) -- Mind-Numbing Nova
	self:Bar(307968, timers[307968][nullificationBlastCount]) -- Nullification Blast
	self:Bar(308227, self:Mythic() and 15 or 21.5) -- Accelerated Evolution
	self:Bar(307232, timers[307232][echoingVoidCount], CL.count:format(self:SpellName(307232), echoingVoidCount)) -- Echoing Void
	self:Bar(314583, self:Mythic() and 85 or 107) -- Volatile Eruption
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:KazirsHivemindControl(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "long")
	self:Bar(307213, self:Mythic() and 74.5 or 93.5) -- Tek'ris's Hivemind Control
end


function mod:TekrissHivemindControl(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "long")
	self:Bar(307201, self:Mythic() and 74.5 or 93.5) -- Ka'zir's Hivemind Control
end

do
	local prev = 0
	function mod:DarkReconstitution(args)
		local t = args.time
		if t-prev > 10 then -- prevent message on kill
			prev = t
			self:Message2(args.spellId, "red")
			self:PlaySound(args.spellId, "info")
			self:Bar(args.spellId, 10)
		end
	end
end

function mod:VolatileEruption(args)
	self:Message2(314583, "red")
	self:PlaySound(314583, "warning")
	self:CDBar(314583, self:Mythic() and 148 or 185)
end

function mod:SpawnAcidicAqir(args)
	self:StopBar(CL.count:format(args.spellName, acidicAqirCount))
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	acidicAqirCount = acidicAqirCount + 1
	self:Bar(args.spellId, timers[args.spellId][acidicAqirCount], CL.count:format(args.spellName, acidicAqirCount))
end

function mod:MindNumbingNovaStart(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message2(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alarm")
		end
	end
	self:Bar(args.spellId, self:Mythic() and 12 or 15)
end

function mod:AcceleratedEvolution(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, self:Mythic() and 147 or 181)
end

function mod:NullificationBlast(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alarm")
	nullificationBlastCount = nullificationBlastCount + 1
	self:Bar(args.spellId, timers[args.spellId][nullificationBlastCount])
end

function mod:EchoingVoid(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	echoingVoidCount = echoingVoidCount + 1
	self:Bar(args.spellId, timers[args.spellId][echoingVoidCount], CL.count:format(args.spellName, acidicAqirCount))
	self:OpenProximity(args.spellId, 4)
	self:CastBar(args.spellId, 4)
end

function mod:EchoingVoidSuccess(args)
	self:CloseProximity(args.spellId)
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 1.5 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
