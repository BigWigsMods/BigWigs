--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Flame Leviathan", "Ulduar")
if not mod then return end
mod:RegisterEnableMob(33113)
mod.toggleOptions = {"engage", 68605, 62396, {"pursue", "FLASHSHAKE"}, 62475, "bosskill"}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage = "Engage warning"
	L.engage_desc = "Warn when Flame Leviathan is engaged."
	L.engage_trigger = "^Hostile entities detected."
	L.engage_message = "%s Engaged!"

	L.pursue = "Pursuit"
	L.pursue_desc = "Warn when Flame Leviathan pursues a player."
	L.pursue_trigger = "^%%s pursues"
	L.pursue_other = "Leviathan pursues %s!"

	L.shutdown_message = "Systems down!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Flame", 62396)
	self:Log("SPELL_AURA_APPLIED", "Shutdown", 62475)
	self:Log("SPELL_AURA_REMOVED", "FlameFailed", 62396)

	self:Log("SPELL_AURA_APPLIED", "Pyrite", 68605)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Pyrite", 68605)
	self:Log("SPELL_AURA_REFRESH", "Pyrite", 68605)

	self:Death("Win", 33113)

	self:Emote("Pursue", L["pursue_trigger"])
	self:Yell("Engage", L["engage_trigger"])
end

function mod:OnEngage()
	self:Message("engage", L["engage_message"]:format(self.displayName), "Attention")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Pyrite(_, spellId, _, _, spellName, _, _, sFlags)
	if bit.band(sFlags, COMBATLOG_OBJECT_AFFILIATION_MINE or 0x1) ~= 0 then
		self:Bar(68605, spellName, 10, spellId)
	end
end

function mod:Flame(_, spellId, _, _, spellName)
	self:Message(62396, spellName, "Urgent", spellId)
	self:Bar(62396, spellName, 10, spellId)
end

function mod:FlameFailed(_, _, _, _, spellName)
	self:SendMessage("BigWigs_StopBar", self, spellName)
end

function mod:Shutdown(unit, spellId, _, _, spellName)
	if unit ~= self.displayName then return end
	self:Message(62475, L["shutdown_message"], "Positive", spellId, "Long")
	self:Bar(62475, spellName, 20, spellId)
end

function mod:Pursue(_, _, _, _, player)
	self:TargetMessage("pursue", L["pursue"], player, "Personal", 62374, "Alarm")
	if UnitIsUnit(player, "player") then self:FlashShake("pursue") end
	self:Bar("pursue", L["pursue_other"]:format(player), 30, 62374)
end

