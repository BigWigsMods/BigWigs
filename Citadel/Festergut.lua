--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Festergut", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36626)
mod.toggleOptions = {69279, 69165, 71219, 72551, 71218, "proximity", "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local sporeTargets = mod:NewTargetList()
local count = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "Fun time?"

	L.inhale_message = "Inhale Blight %d"
	L.inhale_bar = "~Next Inhale %d"

	L.blight_warning = "Pungent Blight in ~5sec!"
	L.blight_bar = "~Next Blight"

	L.bloat_message = "%2$dx Gastric Bloat on %1$s"
	L.bloat_bar = "~Next Bloat"

	L.spore_bar = "~Next Gas Spores"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

-- XXX validate spell IDs in triggers, especially vile gas

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "InhaleCD", 69165)
	self:Log("SPELL_CAST_START", "Blight", 69195, 71219, 73031, 73032)
	self:Log("SPELL_CAST_SUCCESS", "VileGas", 71218, 72272, 72273, 73019, 73020, 69240)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Bloat", 72551, 72219)
	self:Death("Win", 36626)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Yell("Engage", L["engage_trigger"])

	self:Log("SPELL_AURA_APPLIED", "Spores", 69279)
end

function mod:OnEngage()
	count = 1
	self:Berserk(300, true)
	self:Bar(69279, L["spore_bar"], 20, 69279)
	self:Bar(69165, L["inhale_bar"]:format(count), 33.5, 69165)
	self:OpenProximity(9)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local scheduled = nil
	local function sporeWarn(spellName)
		mod:TargetMessage(69279, spellName, sporeTargets, "Urgent", 69279, "Alert")
		scheduled = nil
	end
	local function sporeNext()
		mod:Bar(69279, L["spore_bar"], 28, 69279)
	end
	function mod:Spores(player, spellId, _, _, spellName)
		sporeTargets[#sporeTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(sporeWarn, 0.2, spellName)
			self:ScheduleTimer(sporeNext, 12)
			local explodeName = GetSpellInfo(67729) --"Explode"
			self:Bar(69279, explodeName, 12, spellId)
		end
	end
end

function mod:InhaleCD(_, spellId, _, _, spellName)
	self:Message(69165, L["inhale_message"]:format(count), "Attention", spellId)
	count = count + 1
	if count == 4 then
		self:Bar(71219, L["blight_bar"], 33.5, 71219)
	else
		self:Bar(69165, L["inhale_bar"]:format(count), 33.5, spellId)
	end
end

function mod:Blight(_, spellId, _, _, spellName)
	count = 1
	self:Message(71219, spellName, "Attention", spellId)
	self:Bar(69165, L["inhale_bar"]:format(count), 33.5, 69165)
end

function mod:Bloat(player, spellId, _, _, spellName, stack)
	if stack > 5 then
		self:TargetMessage(72551, L["bloat_message"], player, "Positive", icon, nil, stack)
		self:Bar(72551, L["bloat_bar"], 10, spellId)
	end
end

do
	local t = 0
	function mod:VileGas(_, spellId, _, _, spellName)
		local time = GetTime()
		if (time - t) > 2 then
			t = time
			self:Message(71218, spellName, "Important", spellId)
		end
	end
end

