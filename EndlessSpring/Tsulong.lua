
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Tsulong", 886, 742)
if not mod then return end
mod:RegisterEnableMob(62442)

--------------------------------------------------------------------------------
-- Locals
--
local bigAddCounter = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_yell = "You do not belong here! The waters must be protected... I will cast you out, or slay you!"

	L.phases = "Phases"
	L.phases_desc = "Warning for phase changes"

	L.unstable_sha, L.unstable_sha_desc = EJ_GetSectionInfo(6320)
	L.unstable_sha_icon = 122938

	L.breath, L.breath_desc = EJ_GetSectionInfo(6313)
	L.breath_icon = 122752

	L.day = EJ_GetSectionInfo(6315)
	L.night = EJ_GetSectionInfo(6310)
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"ej:6550",
		"breath", 122768, 122789, {122777, "PROXIMITY", "FLASHSHAKE", "SAY"},
		122855, "unstable_sha", 123011, "ej:6316",
		"berserk", "phases", "bosskill",
	}, {
		["ej:6550"] = "heroic",
		["breath"] = L["night"],
		[122855] = L["day"],
		berserk = "general",
	}
end

function mod:VerifyEnable(unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp > 8 and UnitCanAttack("player", unit) then
		return true
	end
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "SunBreath", 122855)
	self:Log("SPELL_CAST_SUCCESS", "ShadowBreath", 122752)
	self:Log("SPELL_CAST_SUCCESS", "Terrorize", 123011)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DreadShadows", 122768)
	self:Log("SPELL_AURA_APPLIED", "Sunbeam", 122789)
	self:Emote("SunbeamSpawn", "122789")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "EngageCheck")

	self:Log("SPELL_CAST_SUCCESS", "Win", 124176)
	self:Death("Deaths", 62969)
end

function mod:OnEngage(diff)
	self:OpenProximity(8, 122777)
	self:Berserk(self:LFR() and 600 or 490)
	self:Bar("phases", L["day"], 121, 122789)
	self:Bar(122777, 122777, 15.6, 122777) -- Nightmares
	self:Bar("breath", 122752, 10, 122752) -- Shadow Breath
	bigAddCounter = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SunbeamSpawn()
	self:Message(122789, spellName, "Positive", 122789)
	self:Bar(122789, 122789, 42, 122789)
end

function mod:EngageCheck()
	self:CheckBossStatus()
	-- assume only 1 Embodied Terror is up at a time, else you wipe
	if UnitExists("boss2") and self:GetCID(UnitGUID("boss2")) == 62969 then
		bigAddCounter = bigAddCounter + 1
		if bigAddCounter > (self:LFR() and 3 or 2) then
			bigAddCounter = 0
		else
			self:Bar("ej:6316", ("~%s (%d)"):format((UnitName("boss2")), bigAddCounter+1), 40, 123011) -- Not sure if cd also needs proper icon
		end
		self:Message("ej:6316", ("%s (%d)"):format((UnitName("boss2")), bigAddCounter), "Attention", 123011) -- needs proper icon
		self:Bar(123011, "~"..self:SpellName(123011), 5, 123011) -- Terrorize
	end
end

function mod:Terrorize(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Important", spellId)
	self:Bar(spellId, spellName, 41, spellId)
end

function mod:DreadShadows(player, spellId, _, _, spellName, buffStack)
	if UnitIsUnit("player", player) and buffStack > (self:Heroic() and 5 or 11) and buffStack % 3 == 0 then -- might need adjusting
		self:LocalMessage(spellId, ("%s (%d)"):format(spellName, buffStack), "Personal", spellId, "Info")
	end
end

function mod:Sunbeam(player, spellId, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:LocalMessage(spellId, spellName, "Positive", spellId)
	end
end

function mod:SunBreath(_, spellId, _, _, spellName)
	self:Bar(spellId, spellName, 29, spellId)
	self:Message(spellId, spellName, "Urgent", spellId)
end

function mod:ShadowBreath(player, spellId, _, _, spellName)
	self:Bar("breath", "~"..spellName, 25, spellId)
	self:Message("breath", spellName, "Urgent", spellId)
end

do
	local prev = 0
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, unitId, spellName, _, _, spellId)
		if not unitId:match("boss") then return end

		if spellId == 123252 then -- Dread Shadows Cancel (end of night phase)
			self:CloseProximity(122777)
			self:StopBar("~"..self:SpellName(122752)) -- Shadow Breath
			self:Message("phases", L["day"], "Positive", 122789)
			self:Bar("phases", L["night"], 121, 122768)
			self:Bar(122855, 122855, 32, 122855) -- Sun Breath
			self:Bar("unstable_sha", 122953, 18, 122938)
		elseif spellId == 122767 then -- Dread Shadows (start of night phase)
			self:StopBar(122953) -- Summon Unstable Sha
			self:StopBar(122855) -- Sun Breath
			self:OpenProximity(8, 122777)
			self:Message("phases", L["night"], "Positive", 122768)
			self:Bar("phases", L["day"], 121, 122789)
			self:Bar("breath", 122752, 10, 122752) -- Shadow Breath
		elseif spellId == 122953 then -- Summon Unstable Sha
			local t = GetTime()
			if t-prev > 2 then
				prev = t
				self:Message("unstable_sha", spellName, "Important", 122938, "Alert")
				self:Bar("unstable_sha", spellName, 18, 122938)
			end
		elseif spellId == 122775 then -- Nightmares
			self:Bar(122777, spellName, 15, 122777)
			self:Message(122777, spellName, "Attention", 122777)
		elseif spellId == 123813 then -- The Dark of Night (heroic)
			self:Bar("ej:6550", spellName, 30, 130013)
			self:Message("ej:6550", spellName, "Urgent", 130013, "Alarm")
		end
	end
end

function mod:Deaths()
	self:StopBar(123011) -- Terrorize, might be tricky if more than one add can be up
end

