
--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Fankriss the Unyielding", 531)
if not mod then return end
mod:RegisterEnableMob(15510)
mod:SetAllowWin(true)
mod:SetEncounterID(712)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Fankriss the Unyielding"

	L.worm = 25832 -- Summon Worm
	L.worm_icon = "inv_misc_monstertail_03"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		25646, -- Mortal Wound
		"worm", -- Summon Worm
		720, -- Entangle
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED_DOSE", "MortalWound", 25646)
	self:Log("SPELL_CAST_SUCCESS", "SummonWorm", 25832)
	self:Log("SPELL_AURA_APPLIED", "Entangle", 720)

	self:Death("Win", 15510)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MortalWound(args)
	self:StackMessage(25646, args.destName, args.amount, "yellow")
	self:TargetBar(25646, 15, args.destName)
end

function mod:SummonWorm()
	self:Message("worm", "orange", L.worm, L.worm_icon)
	self:PlaySound("worm", "info")
end

function mod:Entangle(args)
	self:TargetMessage(720, "red", args.destName)
	self:PlaySound(720, "alert")
end

