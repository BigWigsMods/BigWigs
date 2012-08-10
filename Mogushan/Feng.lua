if not GetNumGroupMembers then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Feng the Accursed", 896, 689)
if not mod then return end
mod:RegisterEnableMob(60009)


local epicenter, drawflame, arcanevelocity = (GetSpellInfo(116018)), (GetSpellInfo(116711)), (GetSpellInfo(116364))
local allowBarrier = true

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.phases = "Phases"
	L.phases_desc = "Warning for phase changes"
	L.phases_icon = 116363

	L.phase_flame_trigger = "Oh exalted one! Through me you shall melt flesh from bone!"
	L.phase_lightning_trigger = "Oh great spirit! Grant me the power of the earth!"
	L.phase_arcane_trigger =  "Oh sage of the ages! Instill to me your arcane wisdom!"
	L.phase_shadow_trigger = "Great soul of champions past! Bear to me your shield!"

	L.phase_flame = "Flame phase!"
	L.phase_lightning = "Lightning phase!"
	L.phase_arcane = "Arcane phase!"
	L.phase_shadow = "Shadow phase!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		116295, 116018,
		{116784, "ICON", "FLASHSHAKE"}, 116711,
		{116417, "ICON", "SAY", "FLASHSHAKE", "PROXIMITY"}, 116364,
		"phases", 115856, "berserk", "bosskill",
	}, {
		[116295] = L["phase_lightning"],
		[116784] = L["phase_flame"],
		[116417] = L["phase_arcane"],
		phases = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "LightningFists", 116295)
	self:Log("SPELL_CAST_START", "Epicenter", 116018)

	self:Log("SPELL_AURA_APPLIED", "WildfireSparkApplied", 116784)
	self:Log("SPELL_AURA_REMOVED", "WildfireSparkRemoved", 116784)
	self:Log("SPELL_AURA_APPLIED", "DrawFlame", 116711)

	self:Log("SPELL_AURA_APPLIED", "ArcaneResonanceApplied", 116417)
	self:Log("SPELL_AURA_REMOVED", "ArcaneResonanceRemoved", 116417)
	self:Log("SPELL_AURA_APPLIED", "ArcaneVelocity", 116364)

	self:Log("SPELL_CAST_SUCCESS", "NullificationBarrier", 115856)

	-- needed so we can have bars up for abilities used straight after phase switches
	self:Yell("FlamePhase", L["phase_flame_trigger"])
	self:Yell("LightningPhase", L["phase_lightning_trigger"])
	self:Yell("ArcanePhase", L["phase_arcane_trigger"])
	self:Yell("ShadowPhase", L["phase_shadow_trigger"]) -- heroic only

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 60009)
end

function mod:OnEngage(diff)
	allowBarrier = true
	self:Berserk(360) -- assume

end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local function resetAllowBarrier()
		allowBarrier = true
	end

	function mod:NullificationBarrier(_, _, _, _, spellName)
		if allowBarrier then
			allowBarrier = false
			self:Message(115856, spellName, "Positive", 115856, "Info") -- maybe want to use Personal to separte the color from phase switches
			self:ScheduleTimer(resetAllowBarrier, 10)
		end
	end
end

-- LIGHTNING
function mod:LightningPhase()
	self:Message("phases", L["phase_lightning"], "Positive", 116363)
	self:Bar(116018, "~"..epicenter, 32, 116018)
end

function mod:LightningFists(_, _, _, _, spellName)
	self:Message(116295, spellName, "Urgent", 118077)
	self:Bar(116295, "~"..spellName, 11, 116295) -- might need to disable this if it feels unnecesary
end

function mod:Epicenter(_, _, _, _, spellName)
	self:Message(116018, spellName, "Important", 116018, "Alarm")
	self:Bar(116018, "~"..spellName, 32, 116018)
end

-- FLAME
function mod:FlamePhase()
	self:Message("phases", L["flame_lightning"], "Positive", 116363)
	self:Bar(116711, "~"..drawflame, 35, 116711)
end

function mod:WildfireSparkApplied(player, _, _, _, spellName)
	self:TargetMessage(116784, spellName, player, "Urgent", 116784, "Alert")
	self:PrimaryIcon(116784, player)
	if UnitIsUnit("player", player) then
		self:FlashShake(116784)
		self:Bar(116784, spellName, 5, 116784)
	end
end

function mod:WildfireSparkRemoved(player)
	SetRaidTarget(player, 0)
end

function mod:DrawFlame(_, _, _, _, spellName)
	self:Message(116711, spellName, "Important", 116711, "Alarm")
	self:Bar(116711, "~"..spellName, 35, 116711)
end


-- ARCANE
function mod:ArcanePhase()
	self:Bar(116364, "~"..arcanevelocity, 13, 116364)
end

function mod:ArcaneResonanceApplied(player, _, _, _, spellName)
	self:TargetMessage(116417, spellName, player, "Urgent", 116417, "Alert")
	self:PrimaryIcon(116417, player)
	if UnitIsUnit("player", player) then
		self:FlashShake(116417)
		self:OpenProximity(6, 116417)
		self:Say(116417, CL["say"]:format(spellName))
	end
end

function mod:ArcaneResonanceRemoved(player)
	SetRaidTarget(player, 0)
	self:CloseProximity(116417)
end

function mod:ArcaneVelocity(_, _, _, _, spellName)
	self:Message(116364, spellName, "Important", 116364, "Alarm")
	self:Bar(116364, "~"..spellName, 30, 116364)
end

-- SHADOW
function mod:ShadowPhase()

end
