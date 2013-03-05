
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
		{"attenuation", "FLASH"}, {"force", "FLASH"}, 122740, {122761, "ICON"},
		"stages", "berserk", "bosskill",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "PreForceAndVerse", "boss1")
	self:Log("SPELL_CAST_START", "Attenuation", 122496, 122497, 122474, 122479, 123721, 123722)
	--self:Log("SPELL_CAST_START", "AttenuationEcho", 127834) --echo's cast (0.5s after boss triggers it)
	self:Log("SPELL_AURA_APPLIED", "Convert", 122740)
	self:Log("SPELL_AURA_APPLIED", "Exhale", 122761)
	self:Log("SPELL_AURA_REMOVED", "ExhaleOver", 122761)
	self:Log("SPELL_CAST_START", "ForceAndVerse", 122713)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Emote("PlatformSwap", L["platform_emote"])
	self:Emote("Phase2", L["platform_emote_final"])

	self:Death("Win", 62980)
end

function mod:OnEngage()
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
	forceCount, platform, danceTracker = 0, 0, true
	self:Berserk(self:Heroic() and 660 or 600)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local convertList, scheduled = mod:NewTargetList(), nil
	local function warnConvert(spellId)
		mod:TargetMessage(spellId, convertList, "Attention")
		scheduled = nil
	end
	function mod:Convert(args)
		convertList[#convertList + 1] = args.destName
		if not scheduled then
			self:CDBar(args.spellId, 36)
			scheduled = self:ScheduleTimer(warnConvert, 0.1, args.spellId)
		end
	end
end

function mod:Attenuation(args)
	if UnitCastingInfo("boss1") == self:SpellName(122713) then danceTracker = false end -- boss can't be casting Attenuation when it's casting Force and Verve
	local target = danceTracker and L["zorlok"] or L["echo"]
	if args.spellId == 122497 or args.spellId == 122479 or args.spellId == 123722 then -- right
		self:Message("attenuation", "Urgent", "Alarm", L["attenuation_message"]:format(target, L["right"]), "misc_arrowright")
	elseif args.spellId == 122496 or args.spellId == 122474 or args.spellId == 123721 then -- left
		self:Message("attenuation", "Attention", "Alert", L["attenuation_message"]:format(target, L["left"]), "misc_arrowleft")
	end
	self:Bar("attenuation", 14, L["attenuation_bar"], args.spellId)
	self:Flash("attenuation", args.spellId)

	--p2 heroic initial order: boss dance, force and verve, boss dance, echo dance, force and verve
	--this still gets messed up, not sure if its a range issue or just gets out of sync after a few minutes
	if platform == 3 and self:Heroic() and forceCount > 0 then
		danceTracker = not danceTracker
	end
end

function mod:PreForceAndVerse(_, _, _, _, spellId)
	if spellId == 122933 then -- Clear Throat
		self:Message("force", "Important", "Long", CL["soon"]:format(L["force_message"]), L.force_icon)
	end
end

function mod:ForceAndVerse(args)
	forceCount = forceCount + 1
	self:Message("force", "Urgent", nil, CL["count"]:format(L["force_message"], forceCount), args.spellId)
	self:Bar("force", 12, CL["cast"]:format(L["force_message"]), args.spellId)
	self:Flash("force", args.spellId)
end

function mod:UNIT_HEALTH_FREQUENT(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if platform == 0 then
		if hp < 83 then
			self:Message("stages", "Positive", "Info", CL["soon"]:format(L["platform_message"]), "ability_vehicle_launchplayer")
			platform = 1
		end
	elseif platform == 1 then
		if hp < 63 then
			self:Message("stages", "Positive", "Info", CL["soon"]:format(L["platform_message"]), "ability_vehicle_launchplayer")
			platform = 2
		end
	elseif platform == 2 and hp < (self:Heroic() and 47 or 43) then
		self:Message("stages", "Positive", "Info", CL["soon"]:format(CL["phase"]:format(2)), "ability_vehicle_launchplayer")
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unitId)
	end
end

function mod:Exhale(args)
	self:TargetMessage(args.spellId, args.destName, "Important")
	self:TargetBar(args.spellId, 6, args.destName)
	self:PrimaryIcon(args.spellId, args.destName)
end

function mod:ExhaleOver(args)
	self:PrimaryIcon(args.spellId)
end

function mod:PlatformSwap()
	if platform == 2 then
		danceTracker = false
	end
	self:Message("stages", "Positive", "Info", L["platform_message"], "ability_vehicle_launchplayer")
end

function mod:Phase2()
	self:StopBar(122740) -- Convert
	forceCount = 0
	platform = 3
	danceTracker = true
	self:Message("stages", "Positive", "Info", CL["phase"]:format(2), "ability_vehicle_launchplayer")
end

