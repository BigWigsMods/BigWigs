
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Ouro", 531)
if not mod then return end
mod:RegisterEnableMob(15517)
mod:SetAllowWin(true)
mod.engageId = 716

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Ouro"

	L.engage_message = "Ouro engaged! Possible Submerge in 90sec!"

	L.emerge = "Emerge"
	L.emerge_icon = "spell_nature_earthquake" -- misc_arrowlup
	L.emergewarn = "15 sec to possible submerge!"
	L.emergewarn2 = "15 sec to Ouro submerge!"
	L.emergebartext = "Ouro submerge"

	L.submerge = "Submerge"
	L.submerge_icon = "spell_nature_earthquake" -- misc_arrowdown
	L.possible_submerge_bar = "Possible submerge"

	L.scarab = "Scarab Despawn"
	L.scarab_desc = "Warn for Scarab Despawn."
	L.scarab_icon = "inv_misc_ahnqirajtrinket_01" -- Scarab Swarm
	L.scarabdespawn = "Scarabs despawn in 10 Seconds"
	L.scarabbar = "Scarabs despawn"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		26103, -- Sweep
		26102, -- Sand Blast
		26615, -- Berserk
		"scarab",
		"stages",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Sweep", 26103)
	self:Log("SPELL_CAST_START", "SandBlast", 26102)
	self:Log("SPELL_AURA_APPLIED", "BerserkApplied", 26615)
	self:Log("SPELL_CAST_SUCCESS", "SummonOuroMounds", 26058) -- Submerge
	self:Log("SPELL_SUMMON", "SummonOuroScarabs", 26060) -- Emerge

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 15517)
end

function mod:OnEngage()
	self:PossibleSubmerge()
	self:Message("stages", "yellow", L.engage_message, false)

	self:CDBar(26103, 22.7) -- Sweep
	self:CDBar(26102, 24.3) -- Sand Blast

	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "target", "focus")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:PossibleSubmerge()
	self:DelayedMessage("stages", 75, "red", L.emergewarn)
	self:DelayedMessage("stages", 165, "red", L.emergewarn2)
	self:Bar("stages", 90, L.possible_submerge_bar, L.submerge_icon)
	self:Bar("stages", 180, L.emergebartext, L.submerge_icon)
end

function mod:Sweep(args)
	self:Message(26103, "red")
	self:Bar(26103, 21)
	self:DelayedMessage(26103, 16, "red", CL.custom_sec:format(args.spellName, 5))
end

function mod:SandBlast(args)
	self:Message(26102, "yellow")
	self:Bar(26102, 22)
	self:DelayedMessage(26102, 17, "red", CL.custom_sec:format(args.spellName, 5))
end

function mod:BerserkApplied(args)
	self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "target", "focus")
	self:CancelDelayedMessage(L.emergewarn)
	self:CancelDelayedMessage(L.emergewarn2)
	self:StopBar(L.possible_submerge_bar)
	self:StopBar(L.emergebartext)

	self:Message(26615, "orange", "Long", CL.percent:format(20, args.spellName))
	self:PlaySound(26615, "long")
end

function mod:SummonOuroMounds() -- Submerge
	self:CancelDelayedMessage(L.emergewarn)
	self:CancelDelayedMessage(L.emergewarn2)
	self:CancelDelayedMessage(CL.custom_sec:format(self:SpellName(26103), 5)) -- Sweep
	self:CancelDelayedMessage(CL.custom_sec:format(self:SpellName(26102), 5)) -- Sand Blast
	self:StopBar(L.possible_submerge_bar)
	self:StopBar(L.emergebartext)
	self:StopBar(26103) -- Sweep
	self:StopBar(26102) -- Sand Blast

	self:Message("stages", "red", L.submerge, L.submerge_icon)
	self:DelayedMessage("stages", 25, "red", CL.custom_sec:format(L.emerge, 5))
	self:Bar("stages", 30, L.emerge, L.emerge_icon)
end

do
	local prev = 0
	function mod:SummonOuroScarabs() -- Emerge
		local t = GetTime()
		if t-prev > 5 then
			prev = t

			self:Message("stages", "red", L.emerge, L.emerge_icon)
			self:PossibleSubmerge()

			-- Sweep
			self:DelayedMessage(26103, 16, "red", CL.custom_sec:format(self:SpellName(26103), 5))
			self:Bar(26103, 21)

			-- Sand Blast
			self:DelayedMessage(26102, 17, "red", CL.custom_sec:format(self:SpellName(26102), 5))
			self:Bar(26102, 22)

			-- Scarab Despawn
			self:DelayedMessage("scarab", 50, "red", L.scarabdespawn)
			self:Bar("scarab", 60, L.scarabbar, L.scarab_icon)
		end
	end
end

function mod:UNIT_HEALTH_FREQUENT(event, unit)
	if self:MobId(self:UnitGUID(unit)) == 15517 then
		local hp = self:GetHealth(unit)
		if hp < 25 then
			self:UnregisterUnitEvent(event, "target", "focus")
			self:Message(26615, "green", CL.soon:format(self:SpellName(26615)), false)
		end
	end
end
