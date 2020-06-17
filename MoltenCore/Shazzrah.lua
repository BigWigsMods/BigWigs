
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Shazzrah", 409)
if not mod then return end
mod:RegisterEnableMob(12264)
mod:SetAllowWin(true)
mod.engageId = 667

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
	self:Log("SPELL_CAST_SUCCESS", "Blink", self:SpellName(23138))
	self:Log("SPELL_CAST_SUCCESS", "MagicGrounding", self:SpellName(19714))
	self:Log("SPELL_CAST_SUCCESS", "Counterspell", self:SpellName(19715))
end

function mod:OnEngage()
	self:Bar(19715, 10.7) -- Counterspell
	self:Bar(23138, 30)   -- Blink
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Blink(args)
	self:Bar(23138, 41)
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

