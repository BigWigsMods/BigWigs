
-- Notes --
-- Bore damage?
-- Burn?

--------------------------------------------------------------------------------
-- Module Declaration
--

if not IsTestBuild() then return end

local mod, CL = BigWigs:NewBoss("Hellfire Assault", 1026, 1426)
if not mod then return end
mod:RegisterEnableMob(95068, 94515, 93023)
--mod.engageId = 0

--------------------------------------------------------------------------------
-- Locals
--



--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{184369, "FLASH", "SAY"}, -- Howling Axe
		184394, -- Shockwave
		185090, -- Inspiring Presence
		{184243, "TANK"}, -- Slam
		184238, -- Cower!
		185816, -- Repair
		185806, -- Conducted Shock Pulse
		181968, -- Metamorphosis
		180417, -- Felfire Volley
		188576, -- Siege Nova
		185649, -- Artillery Blast
		186845, -- Flameorb
		188101, -- Belch Flame
		180184, -- Crush
		"berserk",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_APPLIED", "HowlingAxe", 184369)
	self:Log("SPELL_CAST_START", "Shockwave", 184394)
	self:Log("SPELL_AURA_APPLIED", "InspiringPresence", 185090)
	self:Log("SPELL_AURA_APPLIED", "Slam", 184243)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Slam", 184243)
	self:Log("SPELL_CAST_START", "Cower", 184238)
	self:Log("SPELL_CAST_START", "Repair", 185816)
	self:Log("SPELL_AURA_APPLIED", "ConductedShockPulse", 185806)
	self:Log("SPELL_CAST_START", "Metamorphosis", 181968)
	self:Log("SPELL_CAST_START", "FelfireVolley", 180417, 183452)
	self:Log("SPELL_CAST_START", "SiegeNova", 188576, 188579, 181094, 180945)
	self:Log("SPELL_CAST_START", "ArtilleryBlast", 185649, 180080)
	self:Log("SPELL_CAST_START", "Flameorb", 186845)
	self:Log("SPELL_CAST_START", "BelchFlame", 188101, 186883)
	self:Log("SPELL_CAST_START", "Crush", 180184)
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Hellfire Assault (beta) engaged", false)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local list = mod:NewTargetList()
	function mod:HowlingAxe(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, "Attention", "Alarm")
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:Flash(args.spellId)
		end
	end
end

function mod:Shockwave(args)
	self:Message(args.spellId, "Urgent", "Info", CL.casting:format(args.spellName))
end

do
	local prev = 0
	function mod:InspiringPresence(args)
		local t = GetTime()
		if t-prev > 3 then
			prev = t
			self:Message(args.spellId, "Positive")
			self:Bar(args.spellId, 15)
		end
	end
end

function mod:Slam(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Urgent")
end

function mod:Cower(args)
	self:Message(args.spellId, "Urgent", "Info", CL.casting:format(args.spellName))
end

function mod:Repair(args)
	self:Message(args.spellId, "Important", "Alert", CL.casting:format(args.spellName))
end

do
	local list = mod:NewTargetList()
	function mod:ConductedShockPulse(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, "Attention")
		end
	end
end

function mod:Metamorphosis(args)
	self:Message(args.spellId, "Positive")
end

function mod:FelfireVolley(args)
	self:Message(180417, "Urgent", "Info", CL.casting:format(args.spellName))
end

function mod:SiegeNova(args)
	self:Message(188576, "Urgent", "Long", CL.incoming:format(args.spellName))
end

function mod:ArtilleryBlast(args)
	self:Message(185649, "Urgent", "Long")
end

function mod:Flameorb(args)
	self:Message(args.spellId, "Important")
end

function mod:BelchFlame(args)
	self:Message(188101, "Important")
end

function mod:Crush(args)
	self:Message(args.spellId, "Urgent", "Long", CL.incoming:format(args.spellName))
end

