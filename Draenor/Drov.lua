
--------------------------------------------------------------------------------
-- Module Declaration
--

if not BigWigs.isWOD then return end -- XXX compat
local mod, CL = BigWigs:NewBoss("Drov the Ruiner", 949, 1212)
if not mod then return end
mod:RegisterEnableMob(81252)
mod.otherMenu = 962
mod.worldBoss = 81252

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		175791, 175953, 175827, {175915, "FLASH"}, "bosskill"
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Log("SPELL_CAST_START", "ColossalSlam", 175791)
	self:Log("SPELL_CAST_START", "GigaSmash", 175953)
	self:Log("SPELL_CAST_START", "CallOfEarth", 175827)
	self:Log("SPELL_AURA_APPLIED", "AcidBreath", 175915)

	self:Death("Win", 81252)
end

function mod:OnEngage()

end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ColossalSlam(args)
	self:Message(args.spellId, "Urgent", "Alarm")
end

function mod:GigaSmash(args)
	self:Message(args.spellId, "Urgent")
end

function mod:CallOfEarth(args)
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 20, CL.cast:format(args.spellName))
end

function mod:AcidBreath(args)
	if not self:Tank() and self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
		self:Flash(args.spellId)
	end
end

