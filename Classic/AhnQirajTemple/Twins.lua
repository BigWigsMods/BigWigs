
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("The Twin Emperors", 531)
if not mod then return end
mod:RegisterEnableMob(15275, 15276) -- Emperor Vek'nilash, Emperor Vek'lor
mod:SetAllowWin(true)
mod:SetEncounterID(715)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "The Twin Emperors"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		7393, -- Heal Brother
		800, -- Twin Teleport
		802, -- Mutate Bug
		26607, -- Blizzard
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "TwinTeleport", 800)
	self:Log("SPELL_HEAL", "HealBrother", 7393)
	self:Log("SPELL_CAST_SUCCESS", "MutateBug", 802)

	self:Log("SPELL_PERIODIC_DAMAGE", "BlizzardDamage", 26607)
	self:Log("SPELL_PERIODIC_MISSED", "BlizzardDamage", 26607)
	self:Log("SPELL_AURA_APPLIED", "BlizzardDamage", 26607)
end

function mod:OnEngage()
	self:Berserk(900)
	self:DelayedMessage(800, 20, "orange", CL.custom_sec:format(self:SpellName(800), 10))
	self:DelayedMessage(800, 25, "red", CL.custom_sec:format(self:SpellName(800), 5))
	self:Bar(800, 30)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	function mod:TwinTeleport(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(800, "yellow")
			self:PlaySound(800, "info")
			self:DelayedMessage(800, 20, "orange", CL.custom_sec:format(args.spellName, 10))
			self:DelayedMessage(800, 25, "red", CL.custom_sec:format(args.spellName, 5))
			self:Bar(800, 30)
		end
	end
end

do
	local prev = 0
	function mod:HealBrother(args)
		local t = GetTime()
		if t-prev > 10 then
			prev = t
			self:Message(7393, "red", CL.casting:format(args.spellName))
			self:PlaySound(7393, "warning")
		end
	end
end

function mod:MutateBug(args)
	self:Message(802, "cyan")
end

do
	local prev = 0
	function mod:BlizzardDamage(args)
		local t = GetTime()
		if t-prev > 2 and self:Me(args.destGUID) then
			prev = t
			self:Message(26607, "blue", CL.you:format(args.spellName))
			self:PlaySound(26607, "alarm")
		end
	end
end
