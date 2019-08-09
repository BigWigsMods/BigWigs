
--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Lucifron", 409, 1519)
if not mod then return end
mod:RegisterEnableMob(12118)
mod.toggleOptions = {19702, 19703, {20604, "ICON"}}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.mc_bar = "MC: %s"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_CAST_SUCCESS", "ImpendingDoom", 19702)
	self:Log("SPELL_CAST_SUCCESS", "LucifronsCurse", 19703)
	self:Log("SPELL_AURA_APPLIED", "MindControl", 20604)

	self:Death("Win", 12118)
end

function mod:OnEngage()
	self:Bar(19703, 11) -- Lucifron's Curse
	self:Bar(19702, 13) -- Impending Doom
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ImpendingDoom(args)
	self:CDBar(args.spellId, 20)
	self:Message(args.spellId, "red")
end

function mod:LucifronsCurse(args)
	self:Bar(args.spellId, 20)
	self:Message(args.spellId, "yellow")
end

function mod:MindControl(args)
	self:Bar(args.spellId, 15, L.mc_bar:format(args.destName))
	self:TargetMessage(args.spellId, args.destName, "yellow")
	self:PrimaryIcon(args.spellId, args.destName)
end

