
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Imperial Vizier Zor'lok", 897, 745)
if not mod then return end
mod:RegisterEnableMob(62980)

--------------------------------------------------------------------------------
-- Locals
--

local forceCount, platform = 0, 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.force, L.force_desc = EJ_GetSectionInfo(6427)
	L.force_icon = 122713
	L.force_message = "AoE Pulse"

	L.attenuation = EJ_GetSectionInfo(6426) .. " (Discs)"
	L.attenuation_desc = select(2, EJ_GetSectionInfo(6426))
	L.attenuation_icon = 127834
	L.attenuation_message = "Incoming Discs, Dance!"

	L.platform_emote = "platforms" -- Imperial Vizier Zor'lok flies to one of his platforms!
	L.platform_emote_final = "inhales"-- Imperial Vizier Zor'lok inhales the Pheromones of Zeal!
	L.platform_message = "Swapping Platform"
end
L = mod:GetLocale()
L.force = L.force .." (".. L.force_message ..")"

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{"attenuation", "FLASHSHAKE"}, {"force", "FLASHSHAKE"}, 122740, {122761, "ICON"},
		"stages", "bosskill",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED") -- Force and Verse pre-warn
	self:Log("SPELL_CAST_START", "Attenuation", 127834)
	self:Log("SPELL_AURA_APPLIED", "Convert", 122740)
	self:Log("SPELL_AURA_APPLIED", "Exhale", 122761)
	self:Log("SPELL_AURA_REMOVED", "ExhaleOver", 122761)
	self:Log("SPELL_CAST_START", "ForceAndVerse", 122713)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Emote("PlatformSwap", L["platform_emote"], L["platform_emote_final"])

	self:Death("Win", 62980)
end

function mod:OnEngage(diff)
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	forceCount, platform = 0, 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local convertList, scheduled = mod:NewTargetList(), nil
	local function convert(spellId)
		mod:TargetMessage(spellId, mod:SpellName(spellId), convertList, "Attention", spellId)
		scheduled = nil
	end
	function mod:Convert(player, spellId)
		convertList[#convertList + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(convert, 0.1, spellId)
		end
	end
end

function mod:Attenuation(_, spellId, _, _, spellName)
	self:Message("attenuation", L["attenuation_message"], "Urgent", spellId, "Alert")
	self:Bar("attenuation", L["attenuation_message"], 14, spellId)
	self:FlashShake("attenuation")
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, spellName, _, _, spellId)
	if spellId == 122933 and unit == "boss1" then -- Clear Throat
		self:Message("force", CL["soon"]:format(L["force_message"]), "Important", L.force_icon, "Long")
	end
end

function mod:ForceAndVerse(_, spellId, _, _, spellName)
	forceCount = forceCount + 1
	self:Message("force", ("%s (%d)"):format(L["force_message"], forceCount), "Urgent", spellId, "Alert")
	self:Bar("force", CL["cast"]:format(L["force_message"]), 12, spellId)
	self:FlashShake("force")
end

function mod:UNIT_HEALTH_FREQUENT(_, unitId)
	if unitId == "boss1" then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if platform == 0 and hp < 82 then
			self:Message("stages", CL["soon"]:format(L["platform_message"]), "Positive", "ability_vehicle_launchplayer", "Info")
			platform = 1
		elseif platform == 1 and hp < 63 then
			self:Message("stages", CL["soon"]:format(L["platform_message"]), "Positive", "ability_vehicle_launchplayer", "Info")
			platform = 2
		elseif platform == 2 and hp < 43 then
			self:Message("stages", CL["soon"]:format(CL["phase"]:format(2)), "Positive", "ability_vehicle_launchplayer", "Info")
			self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
			platform = 3
		end
	end
end

function mod:Exhale(player, spellId, _, _, spellName)
	self:TargetMessage(spellId, spellName, player, "Important", spellId)
	self:TargetBar(spellId, spellName, player, 6, spellId)
	self:PrimaryIcon(spellId, player)
end

function mod:ExhaleOver(_, spellId)
	self:PrimaryIcon(spellId)
end

function mod:PlatformSwap()
	forceCount = 0
	if platform == 3 then
		self:Message("stages", CL["phase"]:format(2), "Positive", "ability_vehicle_launchplayer", "Info")
	else
		self:Message("stages", L["platform_message"], "Positive", "ability_vehicle_launchplayer", "Info")
	end
end

