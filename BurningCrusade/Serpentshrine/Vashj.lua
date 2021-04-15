--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Lady Vashj", 548, 1572)
if not mod then return end
mod:RegisterEnableMob(21212, 22055, 22056, 22009) --Vashj, Coilfang Elite, Coilfang Strider, Tainted Elemental
mod:SetAllowWin(true)
mod:SetEncounterID(2463)

local shieldsFaded = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger1 = "I did not wish to lower myself by engaging your kind, but you leave me little choice..."
	L.engage_trigger2 = "I spit on you, surface filth!"
	L.engage_trigger3 = "Victory to Lord Illidan! "
	L.engage_trigger4 = "I'll split you from stem to stern!"
	L.engage_trigger5 = "Death to the outsiders!"
	L.engage_message = "Entering Phase 1"

	L.phase = "Phase warnings"
	L.phase_desc = "Warn when Vashj goes into the different phases."
	L.phase2_trigger = "The time is now! Leave none standing! "
	L.phase2_soon_message = "Phase 2 soon!"
	L.phase2_message = "Phase 2, adds incoming!"
	L.phase3_trigger = "You may want to take cover. "
	L.phase3_message = "Phase 3 - Enrage in 4min!"

	L.elemental = "Tainted Elemental spawn"
	L.elemental_desc = "Warn when the Tainted Elementals spawn during phase 2."
	L.elemental_icon = 38132
	L.elemental_bar = "~Tainted Elemental"
	L.elemental_soon_message = "Tainted Elemental soon!"

	L.strider = "Coilfang Strider spawn"
	L.strider_desc = "Warn when the Coilfang Striders spawn during phase 2."
	L.strider_icon = "Spell_Nature_AstralRecal"
	L.strider_bar = "~Strider"
	L.strider_soon_message = "Strider soon!"

	L.naga = "Coilfang Elite Naga spawn"
	L.naga_desc = "Warn when the Coilfang Elite Naga spawn during phase 2."
	L.naga_icon = "INV_Misc_MonsterHead_02"
	L.naga_bar = "~Naga"
	L.naga_soon_message = "Naga soon!"

	L.barrier = mod:SpellName(38112)
	L.barrier_desc = "Alert when the barriers go down."
	L.barrier_icon = 38112
	L.barrier_down_message = "Barrier %d/4 down!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		{38280, "ICON", "PROXIMITY"},
		"elemental", "strider", "naga", "barrier",
		"berserk",
		"phase"
	}, {
		[38280] = CL["phase"]:format(1),
		elemental = CL["phase"]:format(2),
		berserk = CL["phase"]:format(3),
		phase = CL["general"],
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Charge", 38280)
	self:Log("SPELL_AURA_REMOVED", "ChargeRemoved", 38280)
	--It seems that there is no longer any events for barrier removal. (v4.2)
	self:Log("SPELL_AURA_REMOVED", "BarrierRemove", 38112)

	self:BossYell("Phase2", L["phase2_trigger"])
	self:BossYell("Phase3", L["phase3_trigger"])
	self:BossYell("Engage", L["engage_trigger1"], L["engage_trigger2"], L["engage_trigger3"], L["engage_trigger4"], L["engage_trigger5"])

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 21212)
	self:Death("ElementalDeath", 22009) -- Tainted Elemental
end

function mod:OnEngage()
	self:RegisterUnitEvent("UNIT_HEALTH", nil, "target", "focus")
	shieldsFaded = 0
	self:MessageOld("phase", "yellow", nil, L["engage_message"], false)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Phase2()
	self:PrimaryIcon(38280)
	shieldsFaded = 0
	self:MessageOld("phase", "red", "alarm", L["phase2_message"], false)
	self:Bar("elemental", 53, L["elemental_bar"], 38132)
	self:DelayedMessage("elemental", 48, "red", L["elemental_soon_message"])
	self:RepeatStrider()
	self:RepeatNaga()
end

function mod:Phase3()
	self:CancelAllTimers()
	self:StopBar(L["elemental_bar"])
	self:StopBar(L["strider_bar"])
	self:StopBar(L["naga_bar"])
	self:MessageOld("phase", "red", "alarm", L["phase3_message"], false)
	self:Berserk(240, true)
end

function mod:Charge(args)
	self:TargetMessageOld(args.spellId, args.destName, "red", "alert")
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetBar(args.spellId, 20, args.destName)
	if self:Me(args.destGUID) then
		self:OpenProximity(args.spellId, 10)
	end
end

function mod:ChargeRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
	self:StopBar(args.spellName, args.destName)
end

--It seems that there is no longer any events for barrier removal. (v4.2)
function mod:BarrierRemove(args)
	shieldsFaded = shieldsFaded + 1
	if shieldsFaded < 4 then
		self:MessageOld("barrier", "yellow", nil, L["barrier_down_message"]:format(shieldsFaded), args.spellId)
	end
end

function mod:ElementalDeath()
	self:Bar("elemental", 53, L["elemental_bar"], 38132)
	self:DelayedMessage("elemental", 48, "red", L["elemental_soon_message"])
end

function mod:RepeatStrider()
	self:Bar("strider", 63, L["strider_bar"], "Spell_Nature_AstralRecal")
	self:DelayedMessage("strider", 58, "yellow", L["strider_soon_message"])
	self:ScheduleTimer("RepeatStrider", 63)
end

function mod:RepeatNaga()
	self:Bar("naga", 47.5, L["naga_bar"], "INV_Misc_MonsterHead_02")
	self:DelayedMessage("naga", 42.5, "yellow", L["naga_soon_message"])
	self:ScheduleTimer("RepeatNaga", 47.5)
end

function mod:UNIT_HEALTH(event, unit)
	if self:MobId(self:UnitGUID(unit)) == 21212 then
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
		if hp > 70 and hp < 76 then
			self:MessageOld("phase", "yellow", nil, L["phase2_soon_message"], false)
			self:UnregisterUnitEvent(event, "target", "focus")
		end
	end
end

