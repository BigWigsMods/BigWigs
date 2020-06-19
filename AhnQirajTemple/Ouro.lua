
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
	L.possible_submerge_bar = "Possible submerge"

	L.emergeannounce = "Ouro has emerged!"
	L.emergewarn = "15 sec to possible submerge!"
	L.emergewarn2 = "15 sec to Ouro sumberge!"
	L.emergebartext = "Ouro submerge"

	L.submerge = "Submerge"
	L.emberge = "Emerge"
	L.submergeannounce = "Ouro has submerged!"
	L.submergewarn = "5 seconds until Ouro Emerges!"
	L.submergebartext = "Ouro Emerge"

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

function mod:OnRegister()
	self.displayName = L.bossName
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Sweep", 26103)
	self:Log("SPELL_CAST_START", "SandBlast", 26102)
	self:Log("SPELL_AURA_APPLIED", "BerserkApplied", 26615)
	self:Log("SPELL_CAST_SUCCESS", "SummonOuroMounds", 26058) -- Submerge
	self:Log("SPELL_SUMMON", "SummonOuroScarabs", 26060) -- Emerge

	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "target", "focus")
end

function mod:OnEngage()
	self:PossibleSubmerge()
	self:Message2("stages", "yellow", L.engage_message, false)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:PossibleSubmerge()
	self:DelayedMessage("stages", 75, "red", L.emergewarn)
	self:DelayedMessage("stages", 165, "red", L.emergewarn2)
	self:Bar("stages", 90, L.possible_submerge_bar, "misc_arrowdown")
	self:Bar("stages", 180, L.emergebartext, "misc_arrowdown")
end

function mod:Sweep(args)
	self:Message2(26103, "red")
	self:Bar(26103, 21)
	self:DelayedMessage(26103, 16, "red", CL.custom_sec:format(args.spellName, 5))
end

function mod:SandBlast(args)
	self:Message2(26102, "yellow")
	self:Bar(26102, 22)
	self:DelayedMessage(26102, 17, "red", CL.custom_sec:format(args.spellName, 5))
end

function mod:BerserkApplied(args)
	self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "target", "focus")
	self:CancelDelayedMessage(L.emergewarn)
	self:CancelDelayedMessage(L.emergewarn2)
	self:StopBar(L.possible_submerge_bar)
	self:StopBar(L.emergebartext)

	self:Message2(26615, "orange", "Long", CL.percent:format(20, args.spellName))
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

	self:Message2("stages", "red", L.submerge, "misc_arrowdown")
	self:DelayedMessage("stages", 25, "red", CL.custom_sec:format(L.emberge, 5))
	self:Bar("stages", 30, L.emberge, "misc_arrowlup")
end

do
	local prev = 0
	function mod:SummonOuroScarabs() -- Emerge
		local t = GetTime()
		if t-prev > 5 then
			prev = t

			self:Message2("stages", "red", L.emberge, "misc_arrowlup")
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
	if self:MobId(UnitGUID(unit)) == 15517 then
		local hp = UnitHealth(unit)
		if hp < 25 then
			self:UnregisterUnitEvent(event, "target", "focus")
			self:Message2(26615, "green", CL.soon:format(self:SpellName(26615)), false)
		end
	end
end

