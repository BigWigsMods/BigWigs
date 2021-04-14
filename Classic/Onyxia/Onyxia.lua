--------------------------------------------------------------------------------
-- Locals
--

local mod = BigWigs:NewBoss("Onyxia", 249)
if not mod then return end
mod:RegisterEnableMob(10184)
mod:SetAllowWin(true)
mod.engageId = 1084

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Onyxia"

	L.phase = "Phases"
	L.phase_desc = "Warn for phase changes."
	L.phase2_message = "Phase 2 incoming!"
	L.phase3_message = "Phase 3 incoming!"

	L.phase1_trigger = "How fortuitous"
	L.phase2_trigger = "from above"
	L.phase3_trigger = "It seems you'll need another lesson"

	L.deepbreath_message = "Deep Breath incoming!"
	L.fear_message = "Fear incoming!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"phase",
		{17086, "FLASH"}, -- Breath
		18431, -- Bellowing Roar
		18435, -- Flame Breath
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Fear", self:SpellName(18431))
	self:Log("SPELL_CAST_START", "DeepBreath", self:SpellName(17086))
	self:Log("SPELL_CAST_START", "FlameBreath", self:SpellName(18435))
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Fear(args)
	self:Message(18431, "yellow", L["fear_message"])
end

function mod:DeepBreath()
	self:Message(17086, "orange", L["deepbreath_message"])
	self:PlaySound(17086, "alarm")
	self:Bar(17086, 8)
	self:Flash(17086)
end

function mod:FlameBreath(args)
	self:Message(18435, "red")
	self:PlaySound(18435, "alert")
end

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg:find(L.phase2_trigger, nil, true) then
		self:Message("phase", "green", L["phase2_message"], false)
	elseif msg:find(L.phase3_trigger, nil, true) then
		self:Message("phase", "green", L["phase3_message"], false)
	end
end
