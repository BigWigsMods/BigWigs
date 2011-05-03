--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Conclave of Wind", 773)
if not mod then return end
mod:RegisterEnableMob(45870, 45871, 45872) -- Anshal, Nezir, Rohash

--------------------------------------------------------------------------------
-- Locals
--

local firstWindBlast = true
local toxicSporesWarned = false
local toxicSpores = GetSpellInfo(86281)
local soothingBreeze = GetSpellInfo(86205)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.gather_strength = "%s is Gathering Strength"

	L.storm_shield = "Storm Shield"
	L.storm_shield_desc = "Absorption Shield"

	L.full_power = "Full Power"
	L.full_power_desc = "Warning for when the bosses reach full power and start to cast the special abilities."
	L.gather_strength_emote = "%s begins to gather strength"

	L.wind_chill = "%sx Wind Chill on YOU!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		86193, "storm_shield",
		{84645, "FLASHSHAKE"},
		85422, 86281, 86205,
		86307, "full_power", "berserk", "bosskill"
	}, {
		[86193] = "Rohash",
		[84645] = "Nezir",
		[85422] = "Anshal",
		[86307] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "FullPower", 84638)

	self:Emote("GatherStrength", L["gather_strength_emote"])

	self:Log("SPELL_AURA_APPLIED", "StormShield", 95865, 93059)
	self:Log("SPELL_CAST_SUCCESS", "WindBlast", 86193)
	self:Log("SPELL_AURA_APPLIED_DOSE", "WindChill", 84645)
	self:Log("SPELL_CAST_SUCCESS", "Nurture", 85422)
	self:Log("SPELL_AURA_APPLIED", "ToxicSpores", 86281)
	self:Log("SPELL_CAST_START", "SoothingBreeze", 86205)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 45872) -- They die at the same time, enough to check for one
end

function mod:OnEngage(diff)
	self:Berserk(480)
	firstWindBlast = true
	toxicSporesWarned = false
	self:Bar("full_power", L["full_power"], 90, 86193)
	self:Bar(86205, soothingBreeze, 16.2, 86205)

	local flag = BigWigs.C.BAR
	local stormShield, nurture, windBlast = GetSpellInfo(95865), GetSpellInfo(85422), GetSpellInfo(86193)
	if bit.band(self.db.profile.storm_shield, flag) == flag and bit.band(self.db.profile[nurture], flag) == flag and bit.band(self.db.profile[windBlast], flag) == flag then
		self:Bar(85422, nurture.."/"..windBlast.."/"..stormShield, 30, "achievement_boss_murmur")
	else
		self:Bar(85422, nurture, 30, 85422)
		self:Bar(86193, windBlast, 30, 86193)
		self:Bar("storm_shield", stormShield, 30, 95865)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:FullPower(_, spellId)
	self:Bar("full_power", L["full_power"], 113, spellId)
	self:Message("full_power", L["full_power"], "Attention", spellId)
	self:Bar(86205, soothingBreeze, 31.3, 86205)
end

function mod:WindChill(player, spellId, _, _, _, stack)
	if UnitIsUnit(player, "player") then
	-- probably need to adjust stack numbers
		if stack == 4 then
			self:LocalMessage(84645, L["wind_chill"]:format(stack), "Personal", spellId)
		elseif stack == 8 then
			self:LocalMessage(84645, L["wind_chill"]:format(stack), "Personal", spellId, "Alarm")
			self:FlashShake(84645)
		end
	end
end

function mod:StormShield(_, spellId, _, _, spellName)
	self:Bar("storm_shield", spellName, 113, spellId)
	self:Message("storm_shield", spellName, "Urgent", spellId)
end

function mod:WindBlast(_, spellId, _, _, spellName)
	if firstWindBlast then
		self:Bar(86193, spellName, 82, spellId)
		self:Message(86193, spellName, "Important", spellId)
		firstWindBlast = false
	else
		self:Bar(86193, spellName, 60, spellId)
		self:Message(86193, spellName, "Important", spellId)
	end
end

function mod:ToxicSpores(_, spellId, _, _, spellName)
	if not toxicSporesWarned then
		self:Bar(86281, spellName, 20, spellId)
		self:Message(86281, spellName, "Urgent", spellId)
		toxicSporesWarned = true
	end
end

function mod:SoothingBreeze(_, spellId, _, _, spellName)
	self:Bar(86205, spellName, 32.5, spellId)
	self:Message(86205, spellName, "Urgent", spellId)
end

function mod:Nurture(_, spellId, _, _, spellName)
	self:Bar(85422, spellName, 113, spellId)
	self:Message(85422, spellName, "Urgent", spellId)
	self:Bar(86281, toxicSpores, 23, 86281)
	toxicSporesWarned = false
end

function mod:GatherStrength(msg, sender)
	self:Message(86307, L["gather_strength"]:format(sender), "Important", 86307, "Long")
	self:Bar(86307, L["gather_strength"]:format(sender), 60, 86307)
end

