
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Imperial Vizier Zor'lok", 897, 745)
if not mod then return end
mod:RegisterEnableMob(62980)

--------------------------------------------------------------------------------
-- Locals
--

local forceCount, platform, danceTracker = 0, 0, true

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_yell = "The Divine chose us to give mortal voice to Her divine will. We are but the vessel that enacts Her will."

	L.force, L.force_desc = EJ_GetSectionInfo(6427)
	L.force_icon = 122713
	L.force_message = "AoE Pulse"

	L.attenuation = EJ_GetSectionInfo(6426) .. " (Discs)"
	L.attenuation_desc = select(2, EJ_GetSectionInfo(6426))
	L.attenuation_icon = 127834
	L.attenuation_bar = "Discs... Dance!"
	L.attenuation_message = "%s Dancing %s"
	L.echo = "|c001cc986Echo|r"
	L.zorlok = "|c00ed1ffaZor'lok|r"
	L.left = "|c00008000<- Left <-|r"
	L.right = "|c00FF0000-> Right ->|r"

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
		"stages", "berserk", "bosskill",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED") -- Force and Verse pre-warn
	self:Log("SPELL_CAST_START", "Attenuation", 122496, 122497, 122474, 122479, 123721, 123722)
	self:Log("SPELL_AURA_APPLIED", "Convert", 122740)
	self:Log("SPELL_AURA_APPLIED", "Exhale", 122761)
	self:Log("SPELL_AURA_REMOVED", "ExhaleOver", 122761)
	self:Log("SPELL_CAST_START", "ForceAndVerse", 122713)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Emote("PlatformSwap", L["platform_emote"], L["platform_emote_final"])

	self:Death("Win", 62980)
end

function mod:OnEngage()
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	forceCount, platform, danceTracker = 0, 0, true
	if not self:LFR() then
		self:Berserk(self:Heroic() and 720 or 600) -- Verify
	end
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
	function mod:Convert(player, spellId, _, _, spellName)
		self:Bar(spellId, "~"..spellName, 36, spellId)
		convertList[#convertList + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(convert, 0.1, spellId)
		end
	end
end

function mod:Attenuation(_, spellId, source, _, spellName)
	local target
	if self:Heroic() then
		if platform == 3 then -- this is code section is untested
			if danceTracker then
				if type(danceTracker) == "number" then
					if danceTracker == 2 then -- there have been two dances from boss in start of p2
						danceTracker = false -- it is now the echos turn then rotation starts
					end
					danceTracker = danceTracker + 1
				else
					danceTracker = false
				end
			else -- assuming echo does not cast two dances in between the two dances of the boss
				danceTracker = true
			end
		end
		-- Figure out a way to do this that works for heroic
		if danceTracker then
			target = L["zorlok"]
		else
			target = L["echo"]
		end
	else
		target = L["zorlok"]
	end
	if spellId == 122497 or spellId == 122479 or spellId == 123722 then -- right
		self:Message("attenuation", L["attenuation_message"]:format(target, L["right"]), "Urgent", "misc_arrowright", "Alarm")
	elseif spellId == 122496 or spellId == 122474 or spellId == 123721 then -- left
		self:Message("attenuation", L["attenuation_message"]:format(target, L["left"]), "Attention", "misc_arrowleft", "Alert")
	end
	self:Bar("attenuation", L["attenuation_bar"], 14, spellId)
	self:FlashShake("attenuation")
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, spellName, _, _, spellId)
	if spellId == 122933 and unit == "boss1" then -- Clear Throat
		self:Message("force", CL["soon"]:format(L["force_message"]), "Important", L.force_icon, "Long")
	end
end

function mod:ForceAndVerse(_, spellId, _, _, spellName)
	forceCount = forceCount + 1
	self:Message("force", ("%s (%d)"):format(L["force_message"], forceCount), "Urgent", spellId)
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
		elseif platform == 2 and hp < 47 then
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
	if platform == 2 then
		danceTracker = false
	end
	if platform == 3 then
		self:Message("stages", CL["phase"]:format(2), "Positive", "ability_vehicle_launchplayer", "Info")
		self:StopBar("~"..self:SpellName(122740)) -- Convert
		danceTracker = 1 -- Start a counter here because there are 2 dances from boss before echo does one
	else
		self:Message("stages", L["platform_message"], "Positive", "ability_vehicle_launchplayer", "Info")
	end
end

