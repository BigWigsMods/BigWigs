
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Ossirian the Unscarred", 509)
if not mod then return end
mod:RegisterEnableMob(15339)
mod:SetAllowWin(true)
mod:SetEncounterID(723)

--------------------------------------------------------------------------------
-- Locals
--

local icons = {
	[mod:SpellName(25181)] = "inv_misc_qirajicrystal_01",
	[mod:SpellName(25177)] = "inv_misc_qirajicrystal_02",
	[mod:SpellName(25178)] = "inv_misc_qirajicrystal_04",
	[mod:SpellName(25180)] = "inv_misc_qirajicrystal_03",
	[mod:SpellName(25183)] = "inv_misc_qirajicrystal_05",
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Ossirian the Unscarred"

	L.debuff = "Weakness"
	L.debuff_desc = "Warn for various weakness types."
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"debuff",
		25176, -- Strength of Ossirian
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Weakness", 25181, 25177, 25178, 25180, 25183)
	self:Log("SPELL_AURA_REMOVED", "WeaknessRemoved", 25181, 25177, 25178, 25180, 25183)
	self:Log("SPELL_AURA_APPLIED", "StrengthOfOssirian", 25176)
end

function mod:OnEngage()
	self:Message(25176, "red") -- Strength of Ossirian
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Weakness(args)
	self:Message("debuff", "yellow", args.spellName, icons[args.spellName])
	self:PlaySound("debuff", "info")
	self:Bar("debuff", 45, args.spellName, icons[args.spellName])

	self:DelayedMessage(25176, 30, "yellow", CL.custom_sec:format(self:SpellName(25176), 15))
	self:DelayedMessage(25176, 35, "orange", CL.custom_sec:format(self:SpellName(25176), 10))
	self:DelayedMessage(25176, 40, "red", CL.custom_sec:format(self:SpellName(25176), 5))
	self:Bar(25176, 45)
end

function mod:WeaknessRemoved(args)
	self:Message("debuff", "yellow", CL.over:format(args.spellName), icons[args.spellName])
end

function mod:StrengthOfOssirian(args)
	self:Message(25176, "red")
end
