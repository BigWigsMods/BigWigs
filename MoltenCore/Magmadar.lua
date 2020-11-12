
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Magmadar", 409)
if not mod then return end
mod:RegisterEnableMob(11982)
mod:SetAllowWin(true)
mod.engageId = 664

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Magmadar"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		19408, -- Panic
		19451, -- Enrage
		19428, -- Conflagration
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Panic", self:SpellName(19408))
	self:Log("SPELL_CAST_SUCCESS", "Enrage", self:SpellName(19451))
	self:Log("SPELL_AURA_APPLIED", "Conflagration", self:SpellName(19428))
end

function mod:OnEngage()
	self:Bar(19451, 8.5) -- Enrage
	self:Bar(19408, 9.7) -- Panic
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Panic(args)
	self:CDBar(19408, 31) -- 31-38
	self:Message(19408, "green")
end

function mod:Enrage(args)
	self:Bar(19451, 8, CL.cast:format(args.spellName))
	self:Message(19451, "yellow")
	self:PlaySound(19451, "info")
end

function mod:Conflagration(args)
	if self:Me(args.destGUID) then
		self:Message(19428, "blue", CL.underyou:format(args.spellName))
		self:PlaySound(19428, "alert")
	end
end
