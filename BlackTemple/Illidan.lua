------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Illidan Stormrage"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local pName = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Illidan",

	parasite = "Parasitic Shadowfiend",
	parasite_desc = "Warn who has Parasitic Shadowfiend.",
	parasite_trigger = "^([^%s]+) ([^%s]+) afflicted by Parasitic Shadowfiend%.$",
	parasite_you = "You have a Parasite!",
	parasite_other = "%s has a Parasite!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player with Parasitic Shadowfiend.",

	barrage = "Dark Barrage",
	barrage_desc = "Warn who has Dark Barrage.",
	barrage_trigger = "^([^%s]+) ([^%s]+) afflicted by Dark Barrage%.$",
	barrage_message = "%s is being Barraged!",

	eyeblast = "Eye Blast",
	eyeblast_desc = "Warn when Eye Blast is cast.",
	eyeblast_trigger = "Stare into the eyes of the Betrayer!",
	eyeblast_message = "Eye Blast!",

	flame = "Agonizing Flames",
	flame_desc = "Warn who has Agonizing Flames.",
	flame_trigger = "^([^%s]+) ([^%s]+) afflicted by Agonizing Flames%.$",
	flame_message = "%s has Agonizing Flames!",

	demons = "Shadow Demons",
	demons_desc = "Warn when Illidan is summoning Shadow Demons.",
	demons_trigger = "Summon Shadow Demons",
	demons_message = "Shadow Demons!",
} end )

L:RegisterTranslations("frFR", function() return {
	parasite = "Ombrefiel parasite",
	parasite_desc = "Préviens quand un joueur subit les effets de l'Ombrefiel parasite.",
	parasite_trigger = "^([^%s]+) ([^%s]+) les effets .* Ombrefiel parasite%.$", -- à vérifier
	parasite_you = "Vous avez un parasite !",
	parasite_other = "%s a un parasite !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par l'Ombrefiel parasite (nécessite d'être promu ou mieux).",

	barrage = "Barrage noir",
	barrage_desc = "Préviens quand un joueur subit les effets du Barrage noir.",
	barrage_trigger = "^([^%s]+) ([^%s]+) les effets .* Barrage noir%.$",
	barrage_message = "%s est dans le barrage !",

	eyeblast = "Energie oculaire",
	eyeblast_desc = "Préviens quand l'Energie oculaire est incanté.",
	eyeblast_trigger = "Stare into the eyes of the Betrayer!", -- à traduire
	eyeblast_message = "Energie oculaire !",

	flame = "Flammes déchirantes",
	flame_desc = "Préviens quand un joueur subit les effets des Flammes déchirantes.",
	flame_trigger = "^([^%s]+) ([^%s]+) les effets .* Flammes déchirantes%.$",
	flame_message = "%s a les Flammes déchirantes !",

	demons = "Démons des ombres",
	demons_desc = "Préviens quand Illidan invoque des démons des ombres.",
	demons_trigger = "Invocation de démons des ombres",
	demons_message = "Démons des ombres !",
} end )

L:RegisterTranslations("koKR", function() return {
	parasite = "어둠의 흡혈마귀",
	parasite_desc = "어둠의 흡혈마귀에 걸린 사람을 알림니다.",
	parasite_trigger = "^([^|;%s]*)(.*)어둠의 흡혈마귀에 걸렸습니다%.$",
	parasite_you = "당신에게 흡혈마귀!",
	parasite_other = "%s에게 흡혈마귀!",

	icon = "전술 표시",
	icon_desc = "어둠의 흡혈마귀에 걸린 사람에게 전술 표시를 지정합니다 (승급자 이상의 권한 필요).",

	barrage = "암흑의 탄막",
	barrage_desc = "암흑의 탄막에 걸린 사람을 알림니다.",
	barrage_trigger = "^([^|;%s]*)(.*)암흑의 탄막에 걸렸습니다%.$",
	barrage_message = "%s에게 탄막!",

	eyeblast = "Eye Blast",
	eyeblast_desc = "Warn when Eye Blast is cast.",
	eyeblast_trigger = "Stare into the eyes of the Betrayer!",
	eyeblast_message = "Eye Blast!",

	flame = "Agonizing Flames",
	flame_desc = "Warn who has Agonizing Flames.",
	flame_trigger = "^([^%s]+) ([^%s]+) afflicted by Agonizing Flames%.$",
	flame_message = "%s has Agonizing Flames!",

	demons = "Shadow Demons",
	demons_desc = "Warn when Illidan is summoning Shadow Demons.",
	demons_trigger = "Summon Shadow Demons",
	demons_message = "Shadow Demons!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = {"parasite", "eyeblast", "barrage", "flame", "demons", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "IliPara", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "IliBara", 2)

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
	end
end

function mod:AfflictEvent(msg)
	local pplayer, ptype = select(3, msg:find(L["parasite_trigger"]))
	if pplayer and ptype then
		if pplayer == L2["you"] and ptype == L2["are"] then
			pplayer = pName
		end
		self:Sync("IliPara "..pplayer)
	end

	local bplayer, btype = select(3, msg:find(L["barrage_trigger"]))
	if bplayer and btype then
		if bplayer == L2["you"] and btype == L2["are"] then
			bplayer = pName
		end
		self:Sync("IliBara "..bplayer)
	end

	local fplayer, ftype = select(3, msg:find(L["flame_trigger"]))
	if fplayer and ftype then
		if fplayer == L2["you"] and ftype == L2["are"] then
			fplayer = pName
		end
		self:Sync("IliFlame "..fplayer)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["eyeblast_trigger"] then
		self:Message(L["eyeblast_message"], "Important", nil, "Alert")
	end
end

function mod:UNIT_SPELLCAST_START(msg)
	if UnitName(msg) == boss and (UnitCastingInfo(msg)) == L["demons_trigger"] then
		self:Sync("IliDemons")
	end
end
