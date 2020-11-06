
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Shazzrah", 409)
if not mod then return end
mod:RegisterEnableMob(12264)
mod:SetAllowWin(true)
mod.engageId = 667

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Shazzrah"
end
L = mod:GetLocale()

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

function mod:OnRegister()
	self.displayName = L.bossName
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
	self:CDBar(23138, 41) -- 41-50
	self:Message(23138, "red")
end

function mod:MagicGrounding(args)
	-- Self buff
	self:Message(19714, "orange", CL.onboss:format(args.spellName))
	if self:Dispeller("magic", true) then
		self:PlaySound(19714, "alarm")
	end
end

function mod:Counterspell(args)
	self:CDBar(19715, 15) -- 15-19
	self:Message(19715, "yellow")
	self:PlaySound(19715, "info")
end
