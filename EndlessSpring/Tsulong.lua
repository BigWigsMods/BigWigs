
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
	L.kill_yell = "I thank you, strangers. I have been freed."

	L.phases = "Phases"
	L.phases_desc = "Warning for phase changes."

	L.unstable_sha, L.unstable_sha_desc = EJ_GetSectionInfo(6320)
	L.unstable_sha_icon = 122938

	L.breath, L.breath_desc = EJ_GetSectionInfo(6313)
	L.breath_icon = 122752

	L.embodied_terror, L.embodied_terror_desc = EJ_GetSectionInfo(6316)
	L.embodied_terror_icon = 130142 -- white and black sha-y icon

	L.day = EJ_GetSectionInfo(6315)
	L.night = EJ_GetSectionInfo(6310)
	L.sunbeam_spawn = "New Sunbeam!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"ej:6550",
		"breath", 122768, 122789, {122777, "PROXIMITY", "FLASH", "SAY"},
		122855, "unstable_sha", 123011, "embodied_terror",
		"phases", "berserk", "bosskill",
	}, {
		["ej:6550"] = "heroic",
		["breath"] = L["night"],
		[122855] = L["day"],
		phases = "general",
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
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "target", "boss1", "boss2", "boss3")
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "EngageCheck")

	self:Yell("Win", L["kill_yell"])
	self:Death("EmbodiedTerrorDeath", 62969)
end

function mod:OnEngage(diff)
	self:OpenProximity(122777, 8)
	self:Berserk(self:LFR() and 900 or 490)
	self:Bar("phases", 121, L["day"], 122789)
	self:Bar(122777, 15.6) -- Nightmares
	self:Bar("breath", 10, 122752) -- Shadow Breath
	bigAddCounter = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SunbeamSpawn()
	self:Message(122789, "Positive", nil, L["sunbeam_spawn"])
	self:Bar(122789, 42)
end

function mod:EngageCheck()
	self:CheckBossStatus()
	if UnitExists("boss2") and self:MobId(UnitGUID("boss2")) == 62969 then
		bigAddCounter = bigAddCounter + 1
		if bigAddCounter < 3 then
			self:CDBar("embodied_terror", 40, CL["count"]:format(L["embodied_terror"], bigAddCounter+1), L.embodied_terror_icon)
		end
		self:Message("embodied_terror", "Attention", nil, CL["count"]:format(L["embodied_terror"], bigAddCounter), L.embodied_terror_icon)
		self:CDBar(123011, 5) -- Terrorize (overwrites the previous bar)
	end
end

function mod:Terrorize(args)
	self:Message(args.spellId, "Important", self:Dispeller("magic") and "Alert")
	self:CDBar(args.spellId, 41)
end

function mod:DreadShadows(args)
	if UnitIsUnit("player", args.destName) and args.amount > (self:Heroic() and 5 or 11) and args.amount % 3 == 0 then -- might need adjusting
		self:Message(args.spellId, "Personal", "Info", CL["count"]:format(args.spellName, args.amount))
	end
end

function mod:Sunbeam(args)
	if UnitIsUnit("player", args.destName) then
		self:Message(args.spellId, "Positive")
	end
end

function mod:SunBreath(args)
	self:Bar(args.spellId, 29)
	self:Message(args.spellId, "Urgent")
end

function mod:ShadowBreath(args)
	self:CDBar("breath", 25, args.spellId)
	self:Message("breath", "Urgent", nil, args.spellId)
end

do
	local function checkForHoTs() -- well any magic actually not just HoTs
		for i=1, 40 do
			local name, _, _, _, buffType, _, _, _, _, _, spellId = UnitBuff("boss1", i)
			if name and buffType == "Magic" then
				mod:Message("phases", "Attention", "Alert", ("%s - %s"):format((UnitName("boss1")), name), spellId) -- maybe should not be tied to "phases" option
				break
			end
		end
	end
	local prev = 0
	function mod:UNIT_SPELLCAST_SUCCEEDED(unitId, spellName, _, _, spellId)
		if spellId == 124176 then
			self:Win() -- Gold Active
		elseif unitId:find("boss", nil, true) then
			if spellId == 123252 then -- Dread Shadows Cancel (end of night phase)
				bigAddCounter = 0
				self:CloseProximity(122777)
				self:StopBar(122777) -- Nightmares
				self:StopBar(122752) -- Shadow Breath
				self:Message("phases", "Positive", nil, L["day"], 122789)
				self:Bar("phases", 121, L["night"], 122768)
				self:Bar(122855, 32) -- Sun Breath
				self:Bar("unstable_sha", 18, 122953, 122938)
				self:Bar("embodied_terror", 11, ("~%s (%d)"):format(L["embodied_terror"], 1), L.embodied_terror_icon)
			elseif spellId == 122767 then -- Dread Shadows (start of night phase)
				self:StopBar(122953) -- Summon Unstable Sha
				self:StopBar(122855) -- Sun Breath
				self:OpenProximity(122777, 8)
				self:Bar(122777, 15) -- Nightmares
				self:Message("phases", "Positive", nil, L["night"], 122768)
				self:Bar("phases", 121, L["day"], 122789)
				self:Bar("breath", 10, 122752) -- Shadow Breath
				if self:Dispeller("magic", true) then
					checkForHoTs()
				end
			elseif spellId == 122953 then -- Summon Unstable Sha
				local t = GetTime()
				if t-prev > 2 then
					prev = t
					self:Message("unstable_sha", "Important", "Alert", spellName, 122938)
					self:Bar("unstable_sha", 18, spellName, 122938)
				end
			elseif spellId == 122775 then -- Nightmares
				self:Bar(122777, 15)
				self:Message(122777, "Attention")
			elseif spellId == 123813 then -- The Dark of Night (heroic)
				self:Bar("ej:6550", 30, 130013)
				self:Message("ej:6550", "Urgent", "Alarm", 130013)
			end
		end
	end
end

function mod:EmbodiedTerrorDeath()
	self:StopBar(123011) -- Terrorize, might be tricky if more than one add can be up
end

