--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Magmaw", "Blackwing Descent")
if not mod then return end
mod:RegisterEnableMob(41570)
mod.toggleOptions = {"slump", 79011, 89773, 78006, 91931, "inferno", "bosskill"}
mod.optionHeaders = {
	slump = "normal",
	inferno = "heroic",
	bosskill = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

local lavaSpew = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.inferno = (GetSpellInfo(92191))
	L.inferno_desc = "Summons Blazing Bone Construct."

	L.pillar_of_flame_cd = "~Pillar of Flame"

	L.slump = "Slump"
	L.slump_desc = "Magmaw slumps forward exposing itself."

	L.slump_trigger = "%s slumps forward, exposing his pincers!"

	L.expose_trigger = "head",
	L.expose_message = "Head Explosed!",
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	--heroic
	self:Log("SPELL_SUMMON", "BlazingInferno", 92191)

	--normal
	self:Log("SPELL_AURA_APPLIED", "PillarOfFlame", 78006)
	self:Log("SPELL_AURA_APPLIED", "Mangle", 89773, 91912, 94616, 94617) -- check IDs
	self:Log("SPELL_CAST_SUCCESS", "LavaSpew", 91931)
	self:Emote("Slump", L["slump_trigger"])
	self:Emote("Vulnerability", L["expose_trigger"])

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 41570)
end

function mod:OnEngage(diff)
	if diff > 2 then
		self:Bar("inferno", (GetSpellInfo(92191)), 20, 92191)
	end
	self:Bar("slump", L["slump"], 100, 94678)
	self:Bar(78006, (GetSpellInfo(78006)), 30, 78006)
	lavaSpew = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Vulnerability()
	self:Message(79011, L["expose_message"], "Attention", 79011)
	self:Bar(79011, L["expose_message"], 30, 79011)
	self:Bar(78006, L["pillar_of_flame_cd"], 40, 78006) -- 10 sec after vulnerability ends, might not be accurate
end

function mod:LavaSpew(_, spellId, _, _, spellName)
	if (GetTime() - lavaSpew) > 6 then
		self:Message(91931, spellName, "Important", spellId)
		self:Bar(91931, spellName, 26, spellId)
	end
	lavaSpew = GetTime()
end

function mod:BlazingInferno(_, spellId, _, _, spellName)
	self:Message("inferno", spellName, "Urgent", spellId, "Info")
	self:Bar("inferno", spellName, 35, spellId)
end

function mod:PillarOfFlame(_, spellId, _, _, spellName)
	self:Message(78006, spellName, "Urgent", spellId, "Alert")
	self:Bar(78006, L["pillar_of_flame_cd"], 32, spellId)
end

function mod:Slump()
	self:SendMessage("BigWigs_StopBar", self,  L["pillar_of_flame_cd"])
	self:Bar("slump", L["slump"], 95, 94678)
	self:Message("slump", L["slump"], "Important", 94678, "Info")
end

function mod:Mangle(_, spellId, _, _, spellName)
	self:Bar(89773, spellName, 30, spellId)
end

