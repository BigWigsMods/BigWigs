
--------------------------------------------------------------------------------
-- Module Declaration
--

if not BigWigs.isWOD then return end -- XXX compat
local mod, CL = BigWigs:NewBoss("Ko'ragh", 994, 1153)
if not mod then return end
mod:RegisterEnableMob(79015)
--mod.engageId = 1691

--------------------------------------------------------------------------------
-- Locals
--

local fieldCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.suppression_field_trigger1 = "Quiet!"
	L.suppression_field_trigger2 = "I will tear you in half!"
	L.suppression_field_trigger3 = "I will crush you!"
	L.suppression_field_trigger4 = "Silence!"

	L.fire_bar = "Everyone Explodes!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		160734, {161328, "SAY", "FLASH"}, {162184, "HEALER"}, {162185, "PROXIMITY"}, {162186, "ICON", "FLASH"}, 172747,
		"bosskill"
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_APPLIED", "VulnerabilityApplied", 160734)
	self:Log("SPELL_AURA_REMOVED", "VulnerabilityRemoved", 160734)
	self:Log("SPELL_CAST_START", "ExpelMagicShadow", 162184)
	self:Log("SPELL_CAST_SUCCESS", "ExpelMagicFire", 162185)
	self:Log("SPELL_AURA_APPLIED", "ExpelMagicArcane", 162186)
	self:Log("SPELL_CAST_START", "ExpelMagicFrost", 172747)
	--self:Log("SPELL_CAST_SUCCESS", "SuppressionField", 161328)
	self:Yell("SuppressionField", L.suppression_field_trigger1, L.suppression_field_trigger2, L.suppression_field_trigger3, L.suppression_field_trigger4)

	self:Death("Win", 79015)
end

function mod:OnEngage()
	fieldCount = 1
	-- pretty consistant early cast for fire, but everything else is all over the place :\
	--self:CDBar(162185, 7) -- Expel Magic: Fire
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:VulnerabilityApplied(args)
	self:Message(args.spellId, "Positive", "Info")
	self:Bar(args.spellId, 20)
	fieldCount = 1
	self:StopBar(161328) -- Suppression Field
end

function mod:VulnerabilityRemoved(args)
	self:Message(args.spellId, "Positive", nil, CL.over:format(args.spellName))
end

function mod:ExpelMagicShadow(args)
	self:Message(args.spellId, "Attention", "Alert")
end

function mod:ExpelMagicArcane(args)
	self:PrimaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
	end
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	self:TargetBar(args.spellId, 10, args.destName)
end

function mod:ExpelMagicFire(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:Bar(args.spellId, 10, L.fire_bar)
	self:OpenProximity(args.spellId, 5)
	self:ScheduleTimer("CloseProximity", 10, args.spellId)
end

function mod:ExpelMagicFrost(args)
	self:Message(args.spellId, "Attention") --, self:Dispeller("magic") and "Info"
end

function mod:SuppressionField(msg, sender, _, _, target)
	-- shooooould incorporate trample into the warning since he charges to the target, hmm
	if self:Me(target) then
		self:Flash(161328)
		self:Say(161328)
	end
	self:TargetMessage(161328, target, "Attention", "Alarm")
	self:CDBar(161328, fieldCount == 2 and 15 or 20)  -- 21.7 15.7 19.6 / 21.8 15.6 / 19.7 15.2 20.5
	fieldCount = fieldCount + 1
end

