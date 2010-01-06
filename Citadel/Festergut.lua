--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Festergut", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36626)
mod.toggleOptions = {69279, 69165, 71219, 72551, {71218, "WHISPER", "ICON", "FLASHSHAKE"},"proximity", "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local sporeTargets = mod:NewTargetList()
local doprint = 0
local count = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.inhale_warning = "Inhale Blight %d in ~5sec!"
	L.inhale_message = "Inhale Blight %d"
	L.inhale_bar = "~Next Inhale %d"

	L.blight_warning = "Pungent Blight in ~5sec!"
	L.blight_bar = "~Next Blight"

	L.bloat_message = "%2$dx Gastric Bloat on %1$s"
	L.bloat_bar = "~Next Bloat"

	L.vilegas_other = "Vile Gas on %s!"

	L.spore_bar = "~Next Gas Spores"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "InhaleCD", 69165)
	self:Log("SPELL_CAST_START", "Blight", 69195, 71219, 73031, 73032)
	self:Log("SPELL_AURA_APPLIED", "VileGas", 71218, 72272, 72273, 73019, 73020)
	self:Log("SPELL_AURA_APPLIED", "Bloat", 72551, 72219)
	self:Death("Win", 36626)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:Log("SPELL_AURA_APPLIED", "Spores", 69279)

	if doprint < 2 then
		doprint = doprint + 1
		print("|cFF33FF99BigWigs_Festergut|r: Mod is alpha, timers may be wrong.")
	end
end

function mod:OnEngage()
	count = 1
	self:Berserk(300, true)
	self:Bar(69279, L["spore_bar"], 20, 69279)
	self:DelayedMessage(69165, 28.5, L["inhale_warning"], "Attention")
	self:Bar(69165, L["inhale_bar"], 33.5, 69165)
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
	local function sporeNext(spellName)
		mod:Bar(69279, L["spore_bar"], 16, 69279)
	end
	function mod:Spores(player, spellId, _, _, spellName)
		sporeTargets[#sporeTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(sporeWarn, 0.2, spellName)
			self:ScheduleTimer(sporeNext, 12, spellName)
			self:Bar(69279, spellName, 12, spellId)
		end
	end
end

function mod:InhaleCD(_, spellId, _, _, spellName)
	self:Message(69165, L["inhale_message"]:format(count), "Important", spellId)
	count = count + 1
	self:DelayedMessage(69165, 28.5, L["inhale_warning"]:format(count), "Attention")
	if count == 4 then
		count = 1
		self:Bar(69165, L["inhale_bar"]:format(count+1), 68, spellId)
	else
		self:Bar(69165, L["inhale_bar"]:format(count+1), 33.5, spellId)
	end
end

function mod:Blight(_, spellId, _, _, spellName)
	self:Message(71219, spellName, "Important", spellId)
	self:DelayedMessage(71219, 133, L["blight_warning"], "Attention")
	self:Bar(71219, L["blight_bar"], 138, spellId)
end

function mod:Bloat(player, spellId, _, _, spellName)
	local _, _, icon, stack = UnitDebuff(player, spellName)
	if stack and stack > 6 then
		self:TargetMessage(72551, L["bloat_message"], player, "Urgent", icon, "Info", stack)
	end
	self:Bar(72551, L["bloat_bar"], 9, spellId)
end

function mod:VileGas(player, spellId, _, _, spellName)
	self:TargetMessage(71218, spellName, player, "Personal", spellId, "Alert")
	self:Whisper(71218, player, spellName)
	self:Bar(71218, L["vilegas_other"]:format(player), 6, spellId)
	self:PrimaryIcon(71218, player)
	if UnitIsUnit(player, "player") then self:FlashShake(71218) end
end

