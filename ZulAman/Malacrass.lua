------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Hex Lord Malacrass"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local pName = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Malacrass",

	engage_trigger = "Da shadow gonna fall on you....",

	bolts = "Spirit Bolts",
	bolts_desc = "Warn when Malacrass starts channelling Spirit Bolts.",
	bolts_trigger = "Your soul gonna bleed!",
	bolts_message = "Incoming Spirit Bolts!",

	soul = "Siphon Soul",
	soul_desc = "Warn who is afflicted by Siphon Soul.",
	soul_trigger = "^(%S+) (%S+) afflicted by Siphon Soul%.$",
	soul_message = "Siphon: %s",

	totem = "Totem",
	totem_desc = "Warn when a Fire Nova Totem is casted.",
	totem_trigger = "Hex Lord Malacrass casts Fire Nova Totem.",
	totem_message = "Fire Nova Totem!",

	heal = "Heal",
	heal_desc = "Warn when Malacrass casts a heal.",
	heal_flash = "Hex Lord Malacrass begins to cast Flash Heal.",
	heal_light = "Hex Lord Malacrass begins to cast Holy Light.",
	heal_wave = "Hex Lord Malacrass begins to cast Healing Wave.",
	heal_message = "Casting Heal!",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "네게 그림자가 드리우리라...",  -- 어둠이 네게 다가온다

	bolts = "영혼의 화살",
	bolts_desc = "말라크라스의 영혼의 화살 시전을 알립니다.",
	bolts_trigger = "네 영혼이 피를 흘리리라!",
	bolts_message = "영혼의 화살 시전!",

	soul = "영혼 착취",
	soul_desc = "누가 영혼 착취에 걸렸는지 알립니다.",
	soul_trigger = "^([^|;%s]*)(.*)영혼 착취에 걸렸습니다%.$",
	soul_message = "착취: %s",

	totem = "토템",
	totem_desc = "불꽃 회오리 토템 시전시 알립니다.",
	totem_trigger = "주술 군주 말라크라스|1이;가; 불꽃 회오리 토템|1을;를; 시전합니다.",
	totem_message = "불꽃 회오리 토템!",

	heal = "치유",
	heal_desc = "말라크라스의 치유 마법 시전을 알립니다.",
	heal_flash = "주술 군주 말라크라스|1이;가; 순간 치유 시전을 시작합니다.",
	heal_light = "주술 군주 말라크라스|1이;가; 성스러운 빛 시전을 시작합니다.",
	heal_wave = "주술 군주 말라크라스|1이;가; 치유의 물결 시전을 시작합니다.",
	heal_message = "치유 마법 시전!",
} end )

L:RegisterTranslations("frFR", function() return {
	--engage_trigger = "Da shadow gonna fall on you....",

	bolts = "Eclairs spirituels",
	bolts_desc = "Previens quand Malacrass commence a canaliser ses Eclairs spirituels.",
	--bolts_trigger = "Your soul gonna bleed!",
	bolts_message = "Arrivee des Eclairs spirituels !",

	soul = "Siphonner l'ame",
	soul_desc = "Previens quand un joueur subit les effets de Siphonner l'ame.",
	soul_trigger = "^(%S+) (%S+) les effets .* Siphonner l'ame%.$",
	soul_message = "Siphon : %s",

	totem = "Totem",
	totem_desc = "Previens quand un Totem Nova de feu est incante.",
	totem_trigger = "Seigneur des malefices Malacrass lance Totem Nova de feu.",
	totem_message = "Totem Nova de feu !",

	heal = "Soin",
	heal_desc = "Previens quand Malacrass incante un soin.",
	heal_flash = "Seigneur des malefices Malacrass commence a lancer Soins rapides.",
	heal_light = "Seigneur des malefices Malacrass commence a lancer Lumiere sacree.",
	heal_wave = "Seigneur des malefices Malacrass commence a lancer Vague de soins.",
	heal_message = "Incante un soin !",
} end )


----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Aman"]
mod.enabletrigger = boss
mod.toggleoptions = {"bolts", "soul", "totem", "heal", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Siphon")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Siphon")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Siphon")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	pName = UnitName("player")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MalaHeal", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "MalaTotem", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.bolts and msg == L["bolts_trigger"] then
		self:Message(L["bolts_message"], "Important")
		self:Bar(L["bolts"], 10, "Spell_Shadow_ShadowBolt")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["totem_trigger"] then
		self:Sync("MalaTotem")
	elseif msg == L["heal_flash"] or msg == L["heal_wave"] or msg == L["heal_light"] then
		self:Sync("MalaHeal")
	end
end

function mod:Siphon(msg)
	if not self.db.profile.soul then return end

	local splayer, stype = select(3, msg:find(L["soul_trigger"]))
	if splayer and stype then
		if splayer == L2["you"] and stype == L2["are"] then
			splayer = pName
		end
		self:Message(L["soul_message"]:format(splayer), "Urgent")
	end
end

function mod:BigWigs_RecvSync(sync)
	if sync == "MalaHeal" and self.db.profile.heal then
		local show = L["heal_message"]
		self:Message(show, "Positive")
		self:Bar(show, 2, "Spell_Nature_MagicImmunity")
	elseif sync == "MalaTotem" and self.db.profile.totem then
		self:Message(L["totem_message"], "Urgent")
	end
end
