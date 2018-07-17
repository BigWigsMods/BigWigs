
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Na'zak the Fiend", -680, 1783)
if not mod then return end
mod:RegisterEnableMob(110321)
mod.otherMenu = -619
mod.worldBoss = 110321

--------------------------------------------------------------------------------
-- Locals
--

local wraps = {}
local wrapCount = 8

--------------------------------------------------------------------------------
-- Initialization
--

local wrapMarker = mod:AddMarkerOption(true, "npc", 8, 219861, 8, 7, 6) -- Web Wrap
function mod:GetOptions()
	return {
		219349, -- Corroding Spray
		219591, -- Foundational Collapse
		219813, -- Absorb Leystones
		{219861, "SAY"}, -- Web Wrap
		wrapMarker,
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "CorrodingSpray", 219349)
	self:Log("SPELL_CAST_SUCCESS", "FoundationalCollapse", 219591)
	self:Log("SPELL_CAST_START", "AbsorbLeystones", 219813)
	self:Log("SPELL_CAST_SUCCESS", "WebWrap", 219861)
	self:Log("SPELL_SUMMON", "WebWrapSummon", 228369)

	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()
	self:CheckForWipe()
	self:CDBar(219349, 5.5) -- Corroding Spray
	self:CDBar(219591, 30) -- Foundational Collapse
	if self:GetOption(wrapMarker) then
		wraps = {}
		wrapCount = 8
		self:RegisterTargetEvents("MarkWebWrap")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MarkWebWrap(event, unit, guid)
	if wraps[guid] then
		SetRaidTarget(unit, wraps[guid])
		wraps[guid] = nil
	end
end

function mod:CorrodingSpray(args)
	self:Message(args.spellId, "Urgent", "Info", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 23)
end

function mod:FoundationalCollapse(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:CDBar(args.spellId, 57)
end

function mod:AbsorbLeystones(args)
	self:Message(args.spellId, "Important", "Long", CL.incoming:format(args.spellName))
	self:Bar(args.spellId, 8)
end

function mod:WebWrap(args)
	if self:GetOption(wrapMarker) then
		wipe(wraps)
		wrapCount = 8
	end
	self:RegisterUnitEvent("UNIT_AURA", nil, "player")
	self:ScheduleTimer("UnregisterUnitEvent", 5, "UNIT_AURA", "player")
	self:Message(args.spellId, "Positive", "Warning")
end

function mod:WebWrapSummon(args)
	if self:GetOption(wrapMarker) then
		wraps[args.destGUID] = wrapCount
		wrapCount = wrapCount - 1
	end
end

do
	local spellName = mod:SpellName(219861)
	function mod:UNIT_AURA(unit)
		if self:UnitDebuff(unit, spellName) then
			self:UnregisterUnitEvent("UNIT_AURA", unit)
			self:Say(219861)
		end
	end
end

function mod:BOSS_KILL(_, id)
	if id == 1950 then
		self:Win()
	end
end
