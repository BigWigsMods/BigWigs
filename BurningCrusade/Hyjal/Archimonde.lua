--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("ArchimondeHyjal", 534, 1581)
if not mod then return end
mod:RegisterEnableMob(17968)
mod:SetEncounterID(2472)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "Your resistance is insignificant."
	L.grip_other = "Grip"
	L.fear_message = "Fear, next in ~42sec!"

	L.killable = "Becomes Killable"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		31972, 31970, {32014, "SAY", "ICON", "PROXIMITY"}, "berserk"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "GripOfTheLegion", 31972)
	self:Log("SPELL_CAST_START", "AirBurst", 32014)
	self:Log("SPELL_CAST_START", "Fear", 31970)

	self:Log("SPELL_CAST_SUCCESS", "ProtectionOfElune", 38528)

	self:BossYell("Engage", L["engage_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 17968)
end

function mod:OnEngage()
	self:Berserk(600)
	self:OpenProximity(32014, 15)
	self:CDBar(31970, 40)
	self:DelayedMessage(31970, 40, "orange", CL["soon"]:format(self:SpellName(31970))) -- Fear
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:GripOfTheLegion(args)
	self:TargetMessageOld(args.spellId, args.destName, "yellow", "alert", L["grip_other"])
end

function mod:Fear(args)
	self:CDBar(args.spellId, 41.5)
	self:MessageOld(args.spellId, "red", nil, L["fear_message"])
	self:DelayedMessage(args.spellId, 41.5, "orange", CL["soon"]:format(args.spellName))
end

do
	local function printTarget(self, name, guid)
		self:TargetMessageOld(32014, name, "red", "long")
		self:PrimaryIcon(32014, name)
		self:ScheduleTimer("PrimaryIcon", 5, 32014)
		if self:Me(guid) then
			self:Say(32014)
		end
	end

	function mod:AirBurst(args)
		self:GetUnitTarget(printTarget, 0.7, args.sourceGUID)
	end
end

function mod:ProtectionOfElune()
	self:CancelAllTimers()
	self:PrimaryIcon(32014)
	self:StopBar(31970) -- Fear
	-- Use berserk instead of making a toggle option for this.
	self:Bar("berserk", 36, L["killable"], 149144) -- "achievement_boss_archimonde-"
end

