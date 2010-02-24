--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("XT-002 Deconstructor", "Ulduar")
if not mod then return end
mod:RegisterEnableMob(33293)
mod.toggleOptions = {{63024, "WHISPER", "ICON", "FLASHSHAKE"}, {63018, "WHISPER", "ICON", "FLASHSHAKE"}, 62776, 64193, 63849, "proximity", "berserk", "bosskill"}
mod.optionHeaders = {
	[63024] = "normal",
	[64193] = "hard",
	proximity = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

local phase = nil
local exposed1 = nil
local exposed2 = nil
local exposed3 = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.exposed_warning = "Exposed soon"
	L.exposed_message = "Heart exposed!"

	L.gravitybomb_other = "Gravity on %s!"

	L.lightbomb_other = "Light on %s!"

	L.tantrum_bar = "~Tantrum Cooldown"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Exposed", 63849)
	self:Log("SPELL_AURA_APPLIED", "Heartbreak", 64193, 65737)
	self:Log("SPELL_AURA_APPLIED", "GravityBomb", 63024, 64234)
	self:Log("SPELL_AURA_APPLIED", "LightBomb", 63018, 65121)
	self:Log("SPELL_AURA_REMOVED", "GravityRemoved", 63024, 64234)
	self:Log("SPELL_AURA_REMOVED", "LightRemoved", 63018, 65121)
	self:Log("SPELL_CAST_START", "Tantrum", 62776)
	self:Death("Win", 33293)
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	phase = 1
	exposed1 = nil
	exposed2 = nil
	exposed3 = nil
	self:Berserk(600)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Exposed(_, spellId, _, _, spellName)
	self:Message(63849, L["exposed_message"], "Attention", spellId)
	self:Bar(63849, spellName, 30, spellId)
end

function mod:Heartbreak(_, spellId, _, _, spellName)
	phase = 2
	self:Message(64193, spellName, "Important", spellId)
end

function mod:Tantrum(_, spellId, _, _, spellName)
	if phase == 2 then
		self:Message(62776, spellName, "Attention", spellId)
		self:Bar(62776, L["tantrum_bar"], 65, spellId)
	end
end

function mod:GravityBomb(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:OpenProximity(10)
		self:FlashShake(63024)
	end
	self:TargetMessage(63024, spellName, player, "Personal", spellId, "Alert")
	self:Whisper(63024, player, spellName)
	self:Bar(63024, L["gravitybomb_other"]:format(player), 9, spellId)
	self:SecondaryIcon(63024, player)
end

function mod:LightBomb(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:OpenProximity(10)
		self:FlashShake(63018)
	end
	self:TargetMessage(63018, spellName, player, "Personal", spellId, "Alert")
	self:Whisper(63018, player, spellName)
	self:Bar(63018, L["lightbomb_other"]:format(player), 9, spellId)
	self:PrimaryIcon(63018, player)
end

function mod:GravityRemoved(player)
	if UnitIsUnit(player, "player") then
		self:CloseProximity()
	end
	self:SecondaryIcon(63024, false)
end

function mod:LightRemoved(player)
	if UnitIsUnit(player, "player") then
		self:CloseProximity()
	end
	self:PrimaryIcon(63018, false)
end

function mod:UNIT_HEALTH(event, msg)
	if phase == 1 and UnitName(msg) == mod.displayName then
		local health = UnitHealth(msg) / UnitHealthMax(msg) * 100
		if not exposed1 and health > 86 and health <= 88 then
			exposed1 = true
			self:Message(63849, L["exposed_warning"], "Attention")
		elseif not exposed2 and health > 56 and health <= 58 then
			exposed2 = true
			self:Message(63849, L["exposed_warning"], "Attention")
		elseif not exposed3 and health > 26 and health <= 28 then
			exposed3 = true
			self:Message(63849, L["exposed_warning"], "Attention")
		end
	end
end

