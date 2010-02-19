--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Koralon the Flame Watcher", "Vault of Archavon")
if not mod then return end
mod.otherMenu = "Northrend"
mod:RegisterEnableMob(35013)
mod.toggleOptions = {66725, {67332, "FLASHSHAKE"}, 66665, "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local count = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.cinder_message = "Flame on YOU!"

	L.breath_bar = "Breath %d"
	L.breath_message = "Breath %d soon!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Fists", 66725, 66808, 68160, 68161)
	self:Log("SPELL_AURA_APPLIED", "Cinder", 67332, 66684)
	self:Log("SPELL_CAST_START", "Breath", 66665, 67328)
	self:Death("Win", 35013)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Fists(_, spellId, _, _, spellName)
	self:Message(66725, spellName, "Attention", spellId)
	self:Bar(66725, spellName, 15, spellId)
end

function mod:Cinder(player, spellId)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(67332, L["cinder_message"], "Personal", spellId, "Alarm")
		self:FlashShake(67332)
	end
end

function mod:Breath(_, spellId, _, _, spellName)
	self:Message(66665, spellName, "Positive", spellId)
	count = count + 1
	self:Bar(66665, L["breath_bar"]:format(count), 45, spellId)
	self:DelayedMessage(66665, 40, L["breath_message"]:format(count), "Attention")
end

