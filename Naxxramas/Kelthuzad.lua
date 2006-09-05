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

	mc_trigger1 = "Your soul is bound to me, now!",
	mc_trigger2 = "There will be no escape!",
	mc_warning = "Mind Control!",
	
    	start_trigger = "Minions, servants, soldiers of the cold dark! Obey the call of Kel'Thuzad!",
	start_warning = "Kel'Thuzad encounter started! ~5min till he is active!",
	start_bar = "Phase 2",

    	phase2_trigger = "Pray for mercy!",
	phase2_warning = "Phase 2, Kel'Thuzad incoming!",
	phase2_bar = "Kel'Thuzad Active!",

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

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsKelThuzad = BigWigs:NewModule(boss)
BigWigsKelThuzad.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsKelThuzad.enabletrigger = boss
BigWigsKelThuzad.toggleoptions = { "frostbolt", "fissure", "mc", "detonate", "phase", "bosskill" }
BigWigsKelThuzad.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

--[[

you enter room, Kel'Thuzad says bla blah blah
	<N-NmE>	and phase 1 begins
	<N-NmE>	you cant target Kel at this phase
	<N-NmE>	adds from the surrounding rooms move towards you
	<N-NmE>	and you have to stop em before they do
	<N-NmE>	after approx 5 minutes of waves
	<N-NmE>	phase 2 begins
	<N-NmE>	and Kel "spawns"
	<N-NmE>	hes got ALOT of abilities
	<vhaarr>	:S
	<N-NmE>	http://www.thottbot.com/?sp=28410 - Mind control ability
	<N-NmE>	http://thottbot.com/?sp=28478 > his interruptable frost 9k frost bolt
	<N-NmE>	http://thottbot.com/?sp=28479 this is propably his aoe frostbolt that you gotta eat
	<N-NmE>	http://www.thottbot.com/?sp=27820
	<N-NmE>	got that as well
	<N-NmE>	or atleast we think its those spells
--]]

function BigWigsKelThuzad:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "DetonateEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "DetonateEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "DetonateEvent")
end

------------------------------
--      Event Handlers      --
------------------------------

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
	elseif msg == L["mc_trigger1"] or msg == L["mc_trigger2"] then
		if self.db.profile.mc then self:TriggerEvent("BigWigs_Message", L["mc_warning"], "Orange") end
	end
end

function BigWigsKelThuzad:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE( msg )
	if msg == L["fissure_trigger"] then
		if self.db.profile.fissure then
			self:TriggerEvent("BigWigs_Message", L["fissure_warning"], "Red")
		end
	elseif msg == L["frostbolt_trigger"] tehn
		if self.db.profile.frostbolt then
			self:TriggerEvent("BigWigs_Message", L["frostbolt_warning"], "Yellow")
		end
	end
end

function BigWigsKelThuzad:DetonateEvent( msg )
	local _,_, player, type = string.find( msg, L["detonate_trigger"])
	if player and type then
		if player == L["you"] and type == L["are"] then
			player = UnitName("player")
		end
		self:TriggerEvent("BigWigs_Message", player .. L["detonate_warning"], "Yellow")
		self:TriggerEvent("BigWigs_SetRaidIcon", player )
		self:TriggerEvent("BigWigs_StartBar", self, player .. L["detonate_bar"], 5, "Interface\\Icons\\Spell_Nature_WispSplode" )
	end
end
