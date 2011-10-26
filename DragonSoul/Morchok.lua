if tonumber((select(4, GetBuildInfo()))) < 40300 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Morchok", 824, 311)
if not mod then return end
mod:RegisterEnableMob(55265)

--------------------------------------------------------------------------------
-- Locales
--
local stomp, crystal, blackBlood = (GetSpellInfo(108571)), (GetSpellInfo(103640)), (GetSpellInfo(103851))

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.crush = "Crush Armor"
	L.crush_desc = "Tank alert only. Count the stacks of crush armor and show a duration bar."
	L.crush_icon = 103687
	L.crush_message = "%2$dx Crush on %1$s"

	L.explosion = "Explosion"
end
L = mod:GetLocale()
L.crush = L.crush.." "..INLINE_TANK_ICON

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		108571, "crush", 103640, { 103851, "FLASHSHAKE" }, 103846, "bosskill",
	}, {
		[108571] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	self:Log("SPELL_CAST_START", "Stomp", 108571)
	self:Log("SPELL_CAST_START", "BlackBlood", 103851)
	self:Log("SPELL_AURA_APPLIED", "Furious", 103846)
	self:Log("SPELL_AURA_APPLIED", "Crush", 103687)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Crush", 103687)
	self:Log("SPELL_CAST_SUCCESS", "ResonatingCrystal", 103640)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	--self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus") -- boss is missing engage trigger on ptr

	self:Death("Win", 55265)
end

function mod:OnEngage(diff)
	self:Bar(108571, stomp, 10, 108571)
	self:Bar(103640, crystal, 16, 103640)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- I know it is ugly to use this, but if we were to start bars at :BlackBlood then we are subject to BlackBlood duration changes
function mod:UNIT_SPELLCAST_CHANNEL_STOP(_, _, spellName)
	if spellName == blackBlood then
		self:Bar(108571, "~"..stomp, 5, 108571)
		self:Bar(103640, crystal, 29, 103640)
	end
end

function mod:Stomp(_, spellId, _, _, spellName)
	self:Bar(108571, "~"..spellName, 12, spellId)
end

function mod:Furious(_, spellId, _, _, spellName)
	self:Message(103846, spellName, "Positive", spellId) -- Positive?
end

function mod:BlackBlood(_, spellId, _, _, spellName)
	self:FlashShake(103851)
	self:Message(103851, spellName, "Personal", spellId, "Long") -- not really personal, but we tend to associate personal with fns
end

function mod:ResonatingCrystal(_, spellId, _, _, spellName)
	self:Message(103640, spellName, "Urgent", spellId, "Alarm")
	self:Bar(103640, L["explosion"], 12, spellId)
end

function mod:Crush(player, spellId, _, _, spellName, buffStack)
	if UnitGroupRolesAssigned("player") ~= "TANK" then return end
	if not buffStack then buffStack = 1 end
	self:SendMessage("BigWigs_StopBar", self, L["crush_message"]:format(player, buffStack - 1))
	self:Bar("crush", L["crush_message"]:format(player, buffStack), 20, spellId)
	self:TargetMessage("crush", L["crush_message"], player, "Urgent", spellId, buffStack > 2 and "Info" or nil, buffStack)
end

