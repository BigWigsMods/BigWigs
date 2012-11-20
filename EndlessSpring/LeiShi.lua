
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lei Shi", 886, 729)
if not mod then return end
mod:RegisterEnableMob(62983)

--------------------------------------------------------------------------------
-- Locals
--

local hiding = false
local nextProtectWarning = 85

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "Wh-what are you doing here?! G-go away!"
	L.hp_to_go = "%d%% to go"
	L.end_hide = "Hiding ended"

	L.special = "Next special ability"
	L.special_desc = "Warning for next special ability"
	L.special_icon = 123263 -- I know it is icon for "Afraid", but since we don't warn for that, might as well use it

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		123461, 123250, 123244, "special", "berserk", "bosskill",
	}, {
		[123461] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "GetAwayApplied", 123461)
	self:Log("SPELL_AURA_REMOVED", "GetAwayRemoved", 123461)
	self:Log("SPELL_AURA_APPLIED", "Protect", 123250)
	self:Log("SPELL_CAST_START", "Hide", 123244)

	self:Yell("Engage", L["engage_trigger"])
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "EngageCheck") -- use this to detect him coming out of hide
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")

	self:Death("Win", 62983)
end

function mod:OnEngage(diff)
	hiding = false
	nextProtectWarning = 85
	self:Bar("special", "~"..L["special"], 33, 123263)
	self:Berserk(480)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- NOTE: Any timer related to "special" is inaccurate, still need to figure out how they work

function mod:EngageCheck()
	if hiding then
		hiding = false
		self:Bar("special", "~"..L["special"], 20, 123263)
		self:Message(123244, L["end_hide"], "Attention", 123244)
	end
end

function mod:Hide(_, spellId, _, _, spellName)
	hiding = true
	self:Message(spellId, spellName, "Attention", spellId)
end

do
	local getAwayStartHP
	function mod:GetAwayApplied(_, spellId, _, _, spellName)
		if UnitHealthMax("boss1") > 0 then
			getAwayStartHP = UnitHealth("boss1") / UnitHealthMax("boss1") * 100
			self:Message(spellId, spellName, "Important", spellId, "Alarm")
		end
	end
	function mod:GetAwayRemoved()
		getAwayStartHP = nil
		self:Bar("special", "~"..L["special"], 30, 123263)
	end

	local prev = 0
	local lastHpToGo
	function mod:UNIT_HEALTH_FREQUENT(_, unitId)
		if unitId == "boss1" then
			local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
			if hp < nextProtectWarning then
				self:Message(123250, CL["soon"]:format(self:SpellName(123250)), "Positive", 123250) -- Protect
				nextProtectWarning = hp - 20
				if nextProtectWarning < 20 then
					nextProtectWarning = 0
				end
			end
			if getAwayStartHP then
				local t = GetTime()
				if t-prev > 3 then -- warn max once every 3 sec
					prev = t
					local hpToGo = math.floor(4 - (getAwayStartHP - hp))
					if lastHpToGo ~= hpToGo and hpToGo > 0 then
						lastHpToGo = hpToGo
						self:Message(123461, L["hp_to_go"]:format(hpToGo), "Positive", 123461)
					end
				end
			end
		end
	end
end

function mod:Protect(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Important", spellId, "Alarm")
end

