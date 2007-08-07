------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Illidan Stormrage"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local pName = nil

local p2deaths = 0

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Illidan",
	["Flame of Azzinoth"] = true,

	parasite = "Parasitic Shadowfiend",
	parasite_desc = "Warn who has Parasitic Shadowfiend.",
	parasite_you = "You have a Parasite!",
	parasite_other = "%s has a Parasite!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player with Parasitic Shadowfiend.",

	barrage = "Dark Barrage",
	barrage_desc = "Warn who has Dark Barrage.",
	barrage_message = "%s is being Barraged!",

	eyeblast = "Eye Blast",
	eyeblast_desc = "Warn when Eye Blast is cast.",
	eyeblast_trigger = "Stare into the eyes of the Betrayer!",
	eyeblast_message = "Eye Blast!",

	flame = "Agonizing Flames",
	flame_desc = "Warn who has Agonizing Flames.",
	flame_message = "%s has Agonizing Flames!",

	demons = "Shadow Demons",
	demons_desc = "Warn when Illidan is summoning Shadow Demons.",
	demons_trigger = "Summon Shadow Demons",
	demons_message = "Shadow Demons!",
	demons_warning = "Shadow Demons in 5 seconds!",
	
	landing_bar = "Landing",
	
	demon_bar = "~Demon phase",
	demon_message = "Demon phase in ~5 seconds!",
	demon_trigger = "Behold the power... of the demon within!",
	
	normal_bar = "Normal phase",
	normal_message = "Normal phase in ~5 seconds!",
	
	phase1_trigger = "You are not prepared!",
	phase4_trigger = "Is this it, mortals? Is this all the fury you can muster?",

	afflict_trigger = "^([^%s]+) ([^%s]+) afflicted by ([^%s]+)%.$",
} end )

L:RegisterTranslations("frFR", function() return {
	parasite = "Ombrefiel parasite",
	parasite_desc = "Préviens quand un joueur subit les effets de l'Ombrefiel parasite.",
	parasite_you = "Vous avez un parasite !",
	parasite_other = "%s a un parasite !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par l'Ombrefiel parasite (nécessite d'être promu ou mieux).",

	barrage = "Barrage noir",
	barrage_desc = "Préviens quand un joueur subit les effets du Barrage noir.",
	barrage_message = "%s est dans le barrage !",

	eyeblast = "Energie oculaire",
	eyeblast_desc = "Préviens quand l'Energie oculaire est incanté.",
	eyeblast_trigger = "Stare into the eyes of the Betrayer!", -- à traduire
	eyeblast_message = "Energie oculaire !",

	flame = "Flammes déchirantes",
	flame_desc = "Préviens quand un joueur subit les effets des Flammes déchirantes.",
	flame_message = "%s a les Flammes déchirantes !",

	demons = "Démons des ombres",
	demons_desc = "Préviens quand Illidan invoque des démons des ombres.",
	demons_trigger = "Invocation de démons des ombres",
	demons_message = "Démons des ombres !",

	afflict_trigger = "^([^%s]+) ([^%s]+) les effets .* ([^%s]+)%.$",
} end )

L:RegisterTranslations("koKR", function() return {
	parasite = "어둠의 흡혈마귀",
	parasite_desc = "어둠의 흡혈마귀에 걸린 플레이어를 알립니다.",
	parasite_you = "당신에 흡혈마귀!",
	parasite_other = "%s에 흡혈마귀!",

	icon = "전술 표시",
	icon_desc = "어둠의 흡혈마귀에 걸린 플레이어에 전술 표시를 지정합니다 (승급자 이상 권한 필요).",

	barrage = "암흑의 보호막",
	barrage_desc = "암흑의 보호막에 걸린 플레이어를 알립니다.",
	barrage_message = "%s에 탄막!",

	eyeblast = "안광",
	eyeblast_desc = "안광 시전 시 알립니다.",
	eyeblast_trigger = "배신자의 눈을 똑바로 쳐다봐라!",
	eyeblast_message = "안광!",

	flame = "고뇌의 불꽃",
	flame_desc = "고뇌의 불꽃에 걸린 플레이어를 알립니다.",
	flame_message = "%s에 고뇌의 불꽃!",

	demons = "어둠의 악마",
	demons_desc = "어둠의 악마 소환 시 알립니다.",
	demons_trigger = "어둠의 악마 소환",
	demons_message = "어둠의 악마!",

	afflict_trigger = "^([^|;%s]*)(%s+)(.*)에 걸렸습니다%.$",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = boss
mod.wipemobs = { boss, L["Flame of Azzinoth"] }
mod.toggleoptions = {"parasite", "eyeblast", "barrage", "flame", "demons", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "IliPara", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "IliBara", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "IliPhase3", 2)

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "AfflictEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "AfflictEvent")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_SPELLCAST_START")

	pName = UnitName("player")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "IliPara" and rest and self.db.profile.parasite then
		local other = L["parasite_other"]:format(rest)
		if rest == pName then
			self:Message(L["parasite_you"], "Personal", true, "Long")
			self:Message(other, "Attention", nil, nil, true)
			self:Bar(other, 10, "Spell_Shadow_SoulLeech_3")
		else
			self:Message(other, "Attention")
			self:Bar(other, 10, "Spell_Shadow_SoulLeech_3")
		end
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif sync == "IliBara" and rest and self.db.profile.barrage then
		self:Message(L["barrage_message"]:format(rest), "Important", nil, "Alert")
	elseif sync == "IliFlame" and rest and self.db.profile.flame then
		self:Message(L["flame_message"]:format(rest), "Important", nil, "Alert")
	elseif sync == "IliDemons" and self.db.profile.demons then
		self:Message(L["demons_message"], "Important", nil, "Alert")
	elseif sync == "IliPhase3" then
		self:Bar(L["landing_bar"], 15, "Spell_Shadow_FocusedPower")
		
		self:Bar(L["demon_bar"], 80, "Spell_Shadow_Metamorphosis")
		self:ScheduleEvent("demonwarn", "BigWigs_Message", 75, L["demon_message"], "Urgent")
	end
end

function mod:AfflictEvent(msg)
	local player, type, spell = select(3, msg:find(L["afflict_trigger"]))
	if player and type then
		if player == L2["you"] and type == L2["are"] then
			player = pName
		end
		if spell == L["parasite"] then
			self:Sync("IliPara "..player)
		elseif spell == L["barrage"] then
			self:Sync("IliBara "..player)
		elseif spell == L["flame"] then
			self:Sync("IliFlame "..player)
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.eyeblast and msg == L["eyeblast_trigger"] then
		self:Message(L["eyeblast_message"], "Important", nil, "Alert")
	elseif msg == L["phase1_trigger"] then
		p2deaths = 0
	elseif msg == L["phase4_trigger"] then
		self:CancelScheduledEvent("demonwarn")
		self:CancelScheduledEvent("normalwarn")
		self:CancelScheduledEvent("normaltrigger")
		self:CancelScheduledEvent("demonswarn")
		
		self:TriggerEvent("BigWigs_StopBar", self, L["normal_bar"])
		self:TriggerEvent("BigWigs_StopBar", self, L["demon_bar"])
		self:TriggerEvent("BigWigs_StopBar", self, L["demons_message"])
	elseif msg == L["demon_trigger"] then
		self:Bar(L["normal_bar"], 60, "Spell_Shadow_FocusedPower")
		self:ScheduleEvent("normalwarn", "BigWigs_Message", 65, L["normal_message"], "Important")
		self:ScheduleEvent("normaltrigger", self.NormalTrigger, 70, self)
		
		if self.db.profile.demons then
			self:Bar(L["demons_message"], 30, "Spell_Shadow_SoulLeech_3")
			self:ScheduleEvent("demonswarn", "BigWigs_Message", 25, L["demons_warning"], "Urgent")
		end
	end
end

function mod:UNIT_SPELLCAST_START(msg)
	if UnitName(msg) == boss and (UnitCastingInfo(msg)) == L["demons_trigger"] then
		self:Sync("IliDemons")
	end
end

function mod:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == UNITDIESOTHER:format(L["Flame of Azzinoth"]) then
		p2deaths = p2deaths + 1
		if p2deaths == 2 then
			self:Sync("IliPhase3")
		end
	else
		self:GenericBossDeath(msg)
	end
end

function mod:NormalTrigger()
	self:Bar(L["demon_bar"], 60, "Spell_Shadow_Metamorphosis")
	self:ScheduleEvent("demonwarn", "BigWigs_Message", 55, L["demon_message"], "Important")
end