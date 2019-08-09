
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Shazzrah", 409)
if not mod then return end
mod:RegisterEnableMob(12264)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		19714, -- Magic Grounding
		23138, -- Gate of Shazzrah
		19715, -- Counterspell
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_CAST_SUCCESS", "Blink", self:SpellName(23138))
	self:Log("SPELL_CAST_SUCCESS", "MagicGrounding", self:SpellName(19714))
	self:Log("SPELL_CAST_SUCCESS", "Counterspell", self:SpellName(19715))

	self:Death("Win", 12264)
end

function mod:OnEngage()
	self:Bar(19715, 10.7) -- Counterspell
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Blink(args)
	self:Bar(23138, 45)
	self:Message(23138, "red")
end

function mod:MagicGrounding(args)
	-- Self buff
	self:Message(19714, "orange", self:Dispeller("magic", true) and "Alarm", CL.onboss:format(args.spellName))
end

function mod:Counterspell(args)
	self:CDBar(19715, 15) -- 15-19
	self:Message(19715, "yellow", "Info")
end

