--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Al'Akir", "Throne of the Four Winds")
if not mod then return end
mod:RegisterEnableMob(46753)
mod.toggleOptions = {{88427, "FLASHSHAKE"}, "phase_change", 87770, 87904, {89668, "FLASHSHAKE"}, 93286, "bosskill"}
mod.optionHeaders = {
	phase_change = "Phase Change",
	bosskill = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.WindBurst = (GetSpellInfo(87770))
	L.LightningRod = (GetSpellInfo(89668))
	
	L.Phase = "Phase %d"
	L.phase_change = "Phase Change"
	L.phase_change_desc = "Announce Phase changes"
	
	L.you = "%s on YOU!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Electrocute", 88427)
	self:Log("SPELL_CAST_START", "WindBurst1", 87770, 93261)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Feedback", 87904)
	self:Log("SPELL_AURA_APPLIED", "Feedback", 87904)
	self:Log("SPELL_AURA_APPLIED", "Phase2", 93279) -- Acid Rain is applied at P2 transition
	self:Log("SPELL_AURA_REMOVED", "Phase3", 93279) -- Acid Rain is removed at P3 transition
	self:Log("SPELL_AURA_APPLIED", "LightningRod", 89668) -- drycoded, need to verify if messages and whisper work
	
	self:Log("SPELL_DAMAGE", "WindBurst3", 93286) -- Wind Burst in Phase 3 is instant cast

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:Death("Win", 46753)
end


function mod:OnEngage(diff)
	self:Bar(87770, L["WindBurst"], 22, 87770) -- this is a try to guess the Wind Burst cooldown at fight start
	
	phase = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:WindBurst3(_, spellId, _, _, spellName)
	-- TODO: start Bar for 22sec and make sure, it does not get started multiple times, since the whole raid gets SPELL_DAMAGE
	
	-- self:Bar(93286, L["WindBurst"], 22, spellId)
	-- self:Message(93286, L["WindBurst"], "Important", spellId, "Alert")
end

function mod:LightningRod(player, spellId, _, _, spellName) -- drycoded, please verify
	if UnitIsUnit(player, "player") then
		self:FlashShake(89668)
		self:LocalMessage(89668, spellName, "Personal", spellId, "Info")
	end
	self:TargetMessage(89668, spellName, player, "Urgent", spellId)
	self:Whisper(89668, player, L["you"]:format(L["LightningRod"]))
	self:PrimaryIcon(89668, player)
end

function mod:Phase2(_, spellId)
	if phase >= 2 then return end
	self:Message("phase_change", L["Phase"]:format(2), "Important", spellId, "Alert")
	mod:SendMessage("BigWigs_StopBar", mod, L["WindBurst"]) -- stop Wind Burst bar at P2
	phase = 2
end

function mod:Phase3(_, spellId)
	if phase >= 3 then return end
	self:Message("phase_change", L["Phase"]:format(3), "Important", spellId, "Alert")
	self:Bar(93286, L["WindBurst"], 24, 93286) -- this is a estimated timer, need more accurate values
	phase = 3
end

function mod:Feedback(_, spellId, _, _, spellName, buffStack)
	self:Bar(87904, spellName, 20, spellId)
	
	if not buffStack then buffStack = 1 end
	self:Message(87904, spellName.." ("..buffStack..")", "Important", spellId, "Alert")
end

function mod:Electrocute(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:FlashShake(88427)
	end
	self:TargetMessage(88427, spellName, player, "Personal", spellId, "Alarm")
end

function mod:WindBurst1(_, spellId, _, _, spellName)
	self:Bar(87770, L["WindBurst"], 26, spellId)
	self:Message(87770, L["WindBurst"], "Important", spellId, "Alert")
end
