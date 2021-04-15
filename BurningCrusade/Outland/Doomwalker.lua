--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Doomwalker", -1948)
if not mod then return end
mod:RegisterEnableMob(17711)
mod:SetAllowWin(true)
mod.worldBoss = 17711
mod.otherMenu = -1945

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.name = "Doomwalker"

	L.engage_trigger = "Do not proceed. You will be eliminated."
	L.engage_message = "Doomwalker engaged, Earthquake in ~30sec!"

	L.overrun = mod:SpellName(32637)
	L.overrun_desc = "Doomwalker will randomly charge someone, knocking them back. Doomwalker will also reset his threat table."
	L.overrun_icon = 32637

	L.earthquake = mod:SpellName(32686)
	L.earthquake_desc = "Doomwalker channels an Earthquake doing 2000 damage every 2 seconds, lasting 8 seconds, and stunning players in his proximity."
	L.earthquake_icon = 32686
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"overrun", "earthquake", "proximity", 33653
	}
end

function mod:OnRegister()
	self.displayName = L.name
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Overrun", 32637)
	self:Log("SPELL_CAST_SUCCESS", "Earthquake", 32686)
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 33653)

	self:BossYell("Engage", L["engage_trigger"])
	self:Death("Win", 17711)
end

function mod:OnEngage()
	self:RegisterUnitEvent("UNIT_HEALTH", nil, "target", "focus")
	self:OpenProximity("proximity", 10)

	self:MessageOld("earthquake", "yellow", nil, L["engage_message"], false)
	self:CDBar("earthquake", 30, 32686)

	self:CDBar("overrun", 26, 32637)
	self:DelayedMessage("overrun", 24, "yellow", CL["soon"]:format(L["overrun"]))
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	function mod:Overrun(args)
		local t = GetTime()
		if (t-prev) > 20 then
			prev = t
			self:MessageOld("overrun", "red", nil, args.spellId)
			self:CDBar("overrun", 30, args.spellId)
			self:DelayedMessage("overrun", 28, "yellow", CL["soon"]:format(args.spellName))
		end
	end
end

function mod:Earthquake(args)
	self:MessageOld("earthquake", "red", nil, args.spellId)
	self:DelayedMessage("overrun", 65, "yellow", CL["soon"]:format(args.spellName))
	self:CDBar("earthquake", 70, args.spellId)
end

function mod:Frenzy(args)
	self:MessageOld(args.spellId, "red", "alarm", "20% - "..args.spellName)
end

function mod:UNIT_HEALTH(event, unit)
	if self:MobId(self:UnitGUID(unit)) == 17711 then
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
		if hp > 20 and hp < 27 then
			self:MessageOld(33653, "orange", nil, CL["soon"]:format(self:SpellName(33653)), false) -- Frenzy
			self:UnregisterUnitEvent(event, "target", "focus")
		end
	end
end

