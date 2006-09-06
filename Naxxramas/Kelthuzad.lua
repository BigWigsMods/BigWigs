------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Kel'Thuzad")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Kelthuzad",

	KELTHUZADCHAMBERLOCALIZEDLOLHAX = "Kel'Thuzad Chamber",

	phase_cmd = "phase",
	phase_name = "Phase Warnings",
	phase_desc = "Warn for phases.",

	mc_cmd = "mindcontrol",
	mc_name = "Mind Control",
	mc_desc = "Warn for mind control.",

	fissure_cmd = "fissure",
	fissure_name = "Shadow Fissure warning,",
	fissure_desc = "Warn for Shadow Fissure",

	frostbolt_cmd = "frostbolt",
	frostbolt_name = "Frostbolt Warning",
	frostbolt_desc = "Warn for Frost bolt",

	detonate_cmd = "detonate",
	detonate_name = "Detonate Mana Warning",
	detonate_desc = "Warn for Detonate Mana",

	guardians_cmd = "guardians",
	guardians_name = "Guardian adds in phase 3",
	guardians_desc = "Warn for incoming Icecrown Guardians in phase 3",

	mc_trigger1 = "Your soul is bound to me, now!",
	mc_trigger2 = "There will be no escape!",
	mc_warning = "Mind Control!",

	start_trigger = "Minions, servants, soldiers of the cold dark! Obey the call of Kel'Thuzad!",
	start_warning = "Kel'Thuzad encounter started! ~5min till he is active!",
	start_bar = "Phase 2",

	phase2_trigger = "Pray for mercy!",
	phase2_warning = "Phase 2, Kel'Thuzad incoming!",
	phase2_bar = "Kel'Thuzad Active!",

	phase3_soon_warning = "Phase 3 soon!",
	phase3_trigger = "Master, I require aid!",
	phase3_warning = "Phase 3, Guardians in ~15sec!",

	guardians_trigger = "Very well. Warriors of the frozen wastes, rise up! I command you to fight, kill and die for your master! Let none survive!",
	guardians_warning = "Guardians incoming in ~10sec!",
	guardians_bar = "Guardians incoming!",

	fissure_trigger = "Kel'Thuzad casts Shadow Fissure.",
	fissure_warning = "Shadow Fissure!",

	frostbolt_trigger = "Kel'Thuzad begins to cast Frostbolt.",
	frostbolt_warning = "Frost Bolt!",

	detonate_trigger = "^([^%s]+) ([^%s]+) afflicted by Detonate Mana",
	detonate_bar = "Detonate Mana - ",
	detonate_warning = " has Detonate Mana!",

	you = "You",
	are = "are",
} end )

-- 12, 32, 42, 72, 93, 127, 140, 193, 205, 238, 250, 267, 285, 310, 337

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsKelThuzad = BigWigs:NewModule(boss)
BigWigsKelThuzad.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsKelThuzad.enabletrigger = boss
BigWigsKelThuzad.toggleoptions = { "frostbolt", "fissure", "mc", "detonate", "phase", "guardians", "bosskill" }
BigWigsKelThuzad.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsKelThuzad:OnInitialize()
	-- Big evul hack to enable the module when entering Kel'Thuzads chamber.
	self:RegisterEvent("MINIMAP_ZONE_CHANGED")
end

function BigWigsKelThuzad:OnEnable()
	self.warnedAboutPhase3Soon = nil

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "DetonateEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "DetonateEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "DetonateEvent")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsKelThuzad:MINIMAP_ZONE_CHANGED(msg)
	if not GetMinimapZoneText() == L["KELTHUZADCHAMBERLOCALIZEDLOLHAX"] then return end
	-- Activate the Kel'Thuzad mod!
	self.core:EnableModule(self)
end

function BigWigsKelThuzad:UNIT_HEALTH(msg)
	if not self.db.profile.phase or self.warnedAboutPhase3Soon then return end

	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 40 and health <= 43 then
			self:TriggerEvent("BigWigs_Message", L["phase3_soon"], "Yellow")
			self.warnedAboutPhase3Soon = true
		end
	end
end

function BigWigsKelThuzad:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["start_trigger"] then
		if self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["start_warning"], "Yellow")
			self:TriggerEvent("BigWigs_StartBar", self, L["start_bar"], 300 )
		end
	elseif msg == L["phase2_trigger"] then
		if self.db.profile.phase then
			self:TriggerEvent("BigWigs_StopBar", self, L["start_bar"] )
			self:TriggerEvent("BigWigs_Message", L["phase2_warning"], "Red")
			self:TriggerEvent("BigWigs_StartBar", self, L["phase2_bar"], 20 )
		end
	elseif msg == L["phase3_trigger"] then
		if self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["phase3_warning"], "Yellow")
		end
	elseif msg == L["mc_trigger1"] or msg == L["mc_trigger2"] then
		if self.db.profile.mc then self:TriggerEvent("BigWigs_Message", L["mc_warning"], "Orange") end
	elseif msg == L["guardians_trigger"] then
		if self.db.profile.guardians then
			self:TriggerEvent("BigWigs_Message", L["guardians_warning"], "Red")
			self:TriggerEvent("BigWigs_StartBar", self, L["guardians_bar"], 10)
		end
	end
end

function BigWigsKelThuzad:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE( msg )
	if msg == L["fissure_trigger"] then
		if self.db.profile.fissure then
			self:TriggerEvent("BigWigs_Message", L["fissure_warning"], "Red")
		end
	elseif msg == L["frostbolt_trigger"] then
		if self.db.profile.frostbolt then
			self:TriggerEvent("BigWigs_Message", L["frostbolt_warning"], "Yellow")
		end
	end
end

function BigWigsKelThuzad:DetonateEvent( msg )
	local _,_, dplayer, dtype = string.find( msg, L["detonate_trigger"])
	if dplayer and dtype then
		if dplayer == L["you"] and dtype == L["are"] then
			dplayer = UnitName("player")
		end
		self:TriggerEvent("BigWigs_Message", dplayer .. L["detonate_warning"], "Yellow")
		self:TriggerEvent("BigWigs_SetRaidIcon", dplayer )
		self:TriggerEvent("BigWigs_StartBar", self, L["detonate_bar"] .. dplayer, 5, "Interface\\Icons\\Spell_Nature_WispSplode" )
	end
end

