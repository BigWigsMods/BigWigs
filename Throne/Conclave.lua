if not GetSpellInfo(90000) then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Conclave of Wind", "Throne of the Four Winds")
if not mod then return end
mod:RegisterEnableMob(45870, 45871, 45872) -- Anshal, Nezir, Rohash
mod.toggleOptions = {{84645, "FLASHSHAKE"}, 85422, 86307, "full_power", "bosskill"}
mod.optionHeaders = {
	[84645] = "Nezir",
	[85422] = "Anshal",
	[86307] = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.gather_strength = "%s is Gathering Strength"
	
	L.full_power = "Full Power"
	L.full_power_desc = "Warning for when the bosses reach full power and start to cast the special abilities."
	L.gather_strength_emote = "%s begins to gather strength from the remaining Wind Lords!"
	
	L.wind_chill = "YOU have %s stacks of Wind Chill"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()

--[[ Lets leave these in for now in case on heroic they don't gain power at the same rate
	self:Log("SPELL_CAST_SUCCESS", "WindBlast", 86193)
	self:Log("SPELL_CAST_SUCCESS", "Zephyr", 84638)
	self:Log("SPELL_AURA_APPLIED", "SleetStorm", 84644)
]]--

--	self:Log("SPELL_CAST_SUCCESS", "FullPower", 86193)
	self:Log("SPELL_CAST_SUCCESS", "FullPower", 84638)
--	self:Log("SPELL_AURA_APPLIED", "FullPower", 84644)
	
	self:Emote("GatherStrength", L["gather_strength_emote"])
	
	self:Log("SPELL_AURA_APPLIED_DOSE", "WindChill", 84645)

	self:Log("SPELL_CAST_SUCCESS", "Nurture", 85422)
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	
	self:Death("Win", 45872) -- They die at the same time, enough to check for one
end


function mod:OnEngage(diff)
	self:Bar("full_power", L["full_power"], 90, 86193)
	self:Bar(85422, (GetSpellInfo(85422)), 30, 85422)
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:FullPower(_, spellId)
	-- this is actually based on the power bar of the boss so might need to use that to adjust timer
	self:Bar("full_power", L["full_power"], 113, spellId)
	self:Message("full_power", L["full_power"], "Attention", spellId)
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

--[[ Lets leave these in for now in case on heroic they don't gain power at the same rate
function mod:WindBlast(_, spellId, _, _, spellName)
	-- this is actually based on the power bar of the boss so might need to use that to adjust timer
	self:Bar(86193, spellName, 113, spellId)
	self:Message(86193, spellName, "Attention", spellId) -- Might need sound
end

function mod:SleetStorm(_, spellId, _, _, spellName)
	-- this is actually based on the power bar of the boss so might need to use that to adjust timer
	self:Bar(84644, spellName, 113, spellId)
	self:Message(84644, spellName, "Attention", spellId) -- Might need sound
end

function mod:Zephyr(_, spellId, _, _, spellName)
-- this is actually based on the power bar of the boss so might need to use that to adjust timer
	self:Bar(84638, spellName, 113, spellId)
	self:Message(84638, spellName, "Attention", spellId)
end
]]--

function mod:Nurture(_, spellId, _, _, spellName)
	self:Bar(85422, spellName, 113, spellId)
	self:Message(85422, spellName, "Urgent", spellId)
end

function mod:GatherStrength(msg, sender)
	self:Message(86307, L["gather_strength"]:format(sender), "Important", 86307, "Long")
	self:Bar(86307, L["gather_strength"]:format(sender), 60, 86307)
end