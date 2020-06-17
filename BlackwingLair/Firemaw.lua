--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Firemaw", 469)
if not mod then return end
mod:RegisterEnableMob(11983)
mod:SetAllowWin(true)
mod.engageId = 613

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Firemaw"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		23339, -- Wing Buffet
		22539, -- Shadow Flame
	}
end

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "WingBuffet", self:SpellName(23339))
	self:Log("SPELL_CAST_START", "ShadowFlame", self:SpellName(22539))
end

function mod:OnEngage()
	self:Bar(23339, 29) -- Wing Buffet
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:WingBuffet(args)
	self:Message(23339, "red")
	self:DelayedMessage(23339, 27, "orange", CL.custom_sec:format(args.spellName, 5))
	self:Bar(23339, 32)
end

function mod:ShadowFlame(args)
	self:Message(22539, "red")
end

