------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Kel'Thuzad")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

local mcTime
local frostBlastTime

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
	mc_name = "Mind Control Alert",
	mc_desc = "Alerts when people are mind controlled.",

	fissure_cmd = "fissure",
	fissure_name = "Shadow Fissure Alert",
	fissure_desc = "Alerts about incoming Shadow Fizzures.",

	frostblast_cmd = "frostblast",
	frostblast_name = "Frost Blast Alert",
	frostblast_desc = "Alerts when people get Frost Blasted.",

	detonate_cmd = "detonate",
	detonate_name = "Detonate Mana Warning",
	detonate_desc = "Warns about Detonate Mana soon.",

	detonateicon_cmd = "detonateicon",
	detonateicon_name = "Raid Icon on Detonate",
	detonateicon_desc = "Place a raid icon on people with Detonate Mana.",

	guardians_cmd = "guardians",
	guardians_name = "Guardian Spawns",
	guardians_desc = "Warn for incoming Icecrown Guardians in phase 3.",

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

	frostblast_trigger = "^([^%s]+) ([^%s]+) afflicted by Frost Blast",
	frostblast_warning = "Frost Blast!",

	detonate_trigger = "^([^%s]+) ([^%s]+) afflicted by Detonate Mana",
	detonate_bar = "Detonate Mana - ",
	detonate_possible_bar = "Possible Detonate",
	detonate_warning = " has Detonate Mana!",

	you = "You",
	are = "are",
} end )

-- 12, 32, 42, 72, 93, 127, 140, 193, 205, 238, 250, 267, 285, 310, 337
--[[
Detonate timers:
348, 36, 31, 51, 22, 22, 37, 34, 30, 24, 48, 24, 22
]]
--[[
frost blast:
30, 161, 42, 46, 47, 63, 70
]]
----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsKelThuzad = BigWigs:NewModule(boss)
BigWigsKelThuzad.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsKelThuzad.enabletrigger = boss
BigWigsKelThuzad.toggleoptions = { "frostblast", "fissure", "mc", -1, "detonate", "detonateicon", -1 ,"guardians", "phase", "bosskill" }
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

	frostBlastTime = nil
	mcTime = nil

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Affliction")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Affliction")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Affliction")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "KelDetonate", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "KelFrostBlast", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "KelFizzure", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "KelMindControl", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsKelThuzad:MINIMAP_ZONE_CHANGED(msg)
	if GetMinimapZoneText() ~= L["KELTHUZADCHAMBERLOCALIZEDLOLHAX"] or self.core:IsModuleActive(boss) then return end
	-- Activate the Kel'Thuzad mod!
	self.core:EnableModule(boss)
end

function BigWigsKelThuzad:UNIT_HEALTH(msg)
	if not self.db.profile.phase then return end

	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 40 and health <= 43 and not self.warnedAboutPhase3Soon then
			self:TriggerEvent("BigWigs_Message", L["phase3_soon_warning"], "Yellow")
			self.warnedAboutPhase3Soon = true
		elseif health > 40 and self.warnedAboutPhase3Soon then
			self.warnedAboutPhase3Soon = nil
		end
	end
end

function BigWigsKelThuzad:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.phase and msg == L["start_trigger"] then
		self:TriggerEvent("BigWigs_Message", L["start_warning"], "Yellow")
		self:TriggerEvent("BigWigs_StartBar", self, L["start_bar"], 300 )
	elseif self.db.profile.phase and msg == L["phase2_trigger"] then
		self:TriggerEvent("BigWigs_StopBar", self, L["start_bar"] )
		self:TriggerEvent("BigWigs_Message", L["phase2_warning"], "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L["phase2_bar"], 20 )
	elseif self.db.profile.phase and msg == L["phase3_trigger"] then
		self:TriggerEvent("BigWigs_Message", L["phase3_warning"], "Yellow")
	elseif msg == L["mc_trigger1"] or msg == L["mc_trigger2"] then
		if not mcTime or (mcTime + 2) < GetTime() then
			self:TriggerEvent("BigWigs_SendSync", "KelMindControl")
			mcTime = GetTime()
		end
	elseif self.db.profile.guardians and msg == L["guardians_trigger"] then
		self:TriggerEvent("BigWigs_Message", L["guardians_warning"], "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L["guardians_bar"], 10)
	end
end

function BigWigsKelThuzad:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE( msg )
	if msg == L["fissure_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "KelFizzure")
	end
end

function BigWigsKelThuzad:BigWigs_RecvSync(sync, rest, nick)
	if sync == "KelDetonation" and rest and self.db.profile.detonate then
		self:TriggerEvent("BigWigs_Message", rest .. L["detonate_warning"], "Yellow")	
		if self.db.profile.detonateicon then self:TriggerEvent("BigWigs_SetRaidIcon", rest ) end
		self:TriggerEvent("BigWigs_StartBar", self, L["detonate_bar"] .. rest, 5, "Interface\\Icons\\Spell_Nature_WispSplode", "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L["detonate_possible_bar"], 20, "Interface\\Icons\\Spell_Nature_WispSplode")
	elseif sync == "KelFrostBlast" and self.db.profile.frostblast then
		self:TriggerEvent("BigWigs_Message", L["frostblast_warning"], "Yellow")
	elseif sync == "KelFizzure" and self.db.profile.fissure then
		self:TriggerEvent("BigWigs_Message", L["fissure_warning"], "Red")
	elseif sync == "KelMindControl" and self.db.profile.mc then
		self:TriggerEvent("BigWigs_Message", L["mc_warning"], "Orange")
	end
end

function BigWigsKelThuzad:Affliction( msg )
	if string.find(msg, L["detonate_trigger"]) then
		local _,_, dplayer, dtype = string.find( msg, L["detonate_trigger"])
		if dplayer and dtype then
			if dplayer == L["you"] and dtype == L["are"] then
				dplayer = UnitName("player")
			end
			self:TriggerEvent("BigWigs_SendSync", "KelDetonate "..dplayer)
		end
	elseif string.find(msg, L["frostblast_trigger"]) then
		if not frostBlastTime or (frostBlastTime + 2) < GetTime() then
			self:TriggerEvent("BigWigs_SendSync", "KelFrostBlast")
			frostBlastTime = GetTime()
		end
	end
end

