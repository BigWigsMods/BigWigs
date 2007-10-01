------------------------------
--      Are you local?      --
------------------------------

local BB = AceLibrary("Babble-Boss-2.2")
local boss = BB["The Illidari Council"]
local malande = BB["Lady Malande"]
local gathios = BB["Gathios the Shatterer"]
local zerevor = BB["High Nethermancer Zerevor"]
local veras = BB["Veras Darkshadow"]
BB = nil

local fmt = string.format
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local death = AceLibrary("AceLocale-2.2"):new("BigWigs")fmt("%s has been defeated", boss)

local pName = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "TheIllidariCouncil",

	engage_trigger1 = "You wish to test me?",
	engage_trigger2 = "Common... such a crude language. Bandal!",
	engage_trigger3 = "I have better things to do..",
	engage_trigger4 = "Flee, or die!",

	immune = "Immunity Warning",
	immune_desc = "Warn when Malande becomes immune to spells or melee attacks.",
	immune_spell_trigger = "Lady Malande gains Blessing of Spell Warding.",
	immune_melee_trigger = "Lady Malande gains Blessing of Protection.",
	immune_message = "Malande: %s Immune for 15sec!",
	immune_bar = "%s Immune!",

	spell = "Spell",
	melee = "Melee",

	shield = "Reflective Shield",
	shield_desc = "Warn when Malande Gains Reflective Shield.",
	shield_trigger = "Lady Malande gains Reflective Shield.",
	shield_message = "Reflective Shield on Malande!",

	poison = "Deadly Poison",
	poison_desc = "Warn for Deadly Poison on players.",
	poison_trigger = "^(%S+) (%S+) afflicted by Deadly Poison%.$",
	poison_other = "%s has Deadly Poison!",
	poison_you = "Deadly Poison on YOU!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player with Deadly Poison.",

	circle = "Circle of Healing",
	circle_desc = "Warn when Malande begins to cast Circle of Healing.",
	circle_trigger = "Lady Malande begins to cast Circle of Healing.",
	circle_message = "Casting Circle of Healing!",
	circle_heal_trigger = "^Lady Malande 's Circle of Healing heals",
	circle_fail_trigger = "^(%S+) interrupts Lady Malande's Circle of Healing%.$",
	circle_heal_message = "Healed! - Next in ~20sec",
	circle_fail_message = "%s Interrupted! - Next in ~12sec",
	circle_bar = "~Circle of Healing Cooldown",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger1 = "Vous voulez me tester ?", -- à vérifier
	engage_trigger2 = "Allons donc... quelle grossièreté. Bandal !", -- à vérifier
	engage_trigger3 = "J'ai mieux à faire...", -- à vérifier
	engage_trigger4 = "Fuyez, ou mourrez !", -- à vérifier

	immune = "Immunité",
	immune_desc = "Préviens quand Malande devient insensible aux sorts ou aux attaques de mêlée.",
	immune_spell_trigger = "Dame Malande gagne Bénédiction de protection contre les sorts.",
	immune_melee_trigger = "Dame Malande gagne Bénédiction de protection.",
	immune_message = "Malande : insensible %s pendant 15 sec. !",
	immune_bar = "Insensible %s !",

	spell = "aux sorts",
	melee = "en mêlée",

	shield = "Bouclier réflecteur",
	shield_desc = "Préviens quand Malande gagne son Bouclier réflecteur.",
	shield_trigger = "Dame Malande gagne Bouclier réflecteur.",
	shield_message = "Bouclier réflecteur sur Malande !",

	poison = "Poison mortel",
	poison_desc = "Préviens quand un joueur subit les effets du Poison mortel.",
	poison_trigger = "^(%S+) (%S+) les effets .* Poison mortel%.$",
	poison_other = "%s a le Poison mortel !",
	poison_you = "Poison mortel sur VOUS !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par le Poison mortel (nécessite d'être promu ou mieux).",

	circle = "Cercle de soins",
	circle_desc = "Préviens quand Malande commence à lancer son Cercle de soins.",
	circle_trigger = "Dame Malande commence à lancer Cercle de soins.",
	circle_message = "Cercle de soins en incantation !",
	circle_heal_trigger = "^Cercle de soins .* Dame Malande soigne",
	circle_fail_trigger = "^(%S+) interrompt Dame Malande qui lance Cercle de soins%.$", -- + "Dame Malande lance un Cercle de soins que vous interrompez." ?
	circle_heal_message = "Soigné ! - Prochain dans ~20 sec.",
	circle_fail_message = "Interrompu par %s ! - Prochain dans ~12 sec.",
	circle_bar = "~Cooldown Cercle de soins",
} end )

L:RegisterTranslations("koKR", function() return {
	--engage_trigger1 = "You wish to test me?",
	--engage_trigger2 = "Common... such a crude language. Bandal!",
	--engage_trigger3 = "I have better things to do..",
	--engage_trigger4 = "Flee, or die!",

	immune = "면역 경고",
	immune_desc = "말란데가 주문 혹은 근접 공격에 면역 시 알립니다.",
	immune_spell_trigger = "여군주 말란데|1이;가; 주문 수호의 축복 효과를 얻었습니다.",
	immune_melee_trigger = "여군주 말란데|1이;가; 보호의 축복 효과를 얻었습니다.",
	immune_message = "말란데: 15초간 %s 면역!",
	immune_bar = "%s 면역!",

	spell = "주문",
	melee = "근접",

	shield = "반사의 보호막",
	shield_desc = "말란데가 반사의 보호막을 얻었을 때 알립니다.",
	shield_trigger = "여군주 말란데|1이;가; 반사의 보호막 효과를 얻었습니다.",
	shield_message = "말란데에 반사의 보호막!",

	poison = "맹독",
	poison_desc = "맹독에 걸린 플레이어를 알립니다.",
	poison_trigger = "^([^|;%s]*)(.*)맹독에 걸렸습니다%.$",
	poison_other = "%s에 맹독!",
	poison_you = "당신에 맹독!",

	icon = "전술 표시",
	icon_desc = "맹독에 걸린 플레이어에 전술 표시를 지정합니다 (승급자 이상 권한 필요).",

	circle = "치유의 마법진",
	circle_desc = "말란데가 치유의 마법진 시전 시 알립니다.",
	circle_trigger = "여군주 말란데|1이;가; 치유의 마법진 시전을 시작합니다.",
	circle_message = "치유의 마법진 시전!",
	circle_heal_trigger = "^여군주 말란데의 치유의 마법진|1으로;로;",
	circle_fail_trigger = "^([^%s]+)|1이;가; 여군주 말란데의 치유의 마법진|1을;를; 차단했습니다%.$",
	circle_heal_message = "치유됨! - 다음은 약 20초 이내",
	circle_fail_message = "%s 차단됨! - 다음은 약 12초 이내",
	circle_bar = "~치유의 마법진 대기 시간",
} end )

--Chinese Translate by 月色狼影@CWDG
--CWDG site: http://Cwowaddon.com
--伊利达雷议会
L:RegisterTranslations("zhCN", function() return {
	--engage_trigger1 = "You wish to test me?",
	--engage_trigger2 = "Common... such a crude language. Bandal!",
	--engage_trigger3 = "I have better things to do..",
	--engage_trigger4 = "Flee, or die!",

	immune = "免疫警报",
	immune_desc = "当玛兰德免疫法术活近战攻击时发出警报",
	immune_spell_trigger = "女公爵玛兰德获得了法术结界祝福",--女公爵玛兰德
	immune_melee_trigger = "女公爵玛兰德获得了保护祝福",
	immune_message = "玛兰德: %s 免疫——15秒!",
	immune_bar = "%s 免疫!",

	spell = "法术",
	melee = "近战",

	shield = "反射护盾",
	shield_desc = "当玛兰德获得反射护盾时发出警报",
	shield_trigger = "女公爵玛兰德获得了反射护盾",
	shield_message = "反射护盾! 注意!",

	poison = "致命毒药",
	poison_desc = "当玩家受到致命毒药时发出警报.",
	poison_trigger = "^([^%s]+)受([^%s]+)了致命毒药效果的影响。$",
	poison_other = "%s 中了 致命毒药!",
	poison_you = ">你<——致命毒药!",

	icon = "团队标记",
	icon_desc = "为中致命毒药的玩家打上团队标记.",

	circle = "治疗之环",
	circle_desc = "当玛兰德开始施放治疗之环时发出警报",
	circle_trigger = "女公爵玛兰德开始施放治疗之环",
	circle_message = "正在施放 治疗之环!",
	circle_heal_trigger = "^女公爵玛兰德的治疗之环治疗",
	circle_fail_trigger = "^([^%s]+)打断了公爵玛兰德的治疗之环",
	circle_heal_message = "治疗 成功! - ~20秒后再次发动",
	circle_fail_message = "%s 打断! - ~12s秒后再次发动 治疗之环",
	circle_bar = "~治疗之环 CD",
} end )


L:RegisterTranslations("deDE", function() return {
	--engage_trigger1 = "You wish to test me?",
	--engage_trigger2 = "Common... such a crude language. Bandal!",
	--engage_trigger3 = "I have better things to do..",
	--engage_trigger4 = "Flee, or die!",

	immune = "Immunitäts Warnung",
	immune_desc = "Warnen wenn Malande immun gegen Zauber oder Nahkampfangriffe wird.",
	immune_spell_trigger = "Lady Malande bekommt Segen des Zauberschutzes.",
	immune_melee_trigger = "Lady Malande bekommt Segen des Schutzes.",
	immune_message = "Malande: %s Immun für 15sec!",
	immune_bar = "%s Immun!",

	spell = "Zauber",
	melee = "Nahkampf",

	shield = "Reflektierender Schild",
	shield_desc = "Warnt wenn Malande Reflektierender Schild bekommt.",
	shield_trigger = "Lady Malande bekommt Reflektierender Schild.",
	shield_message = "Reflektierender Schild auf Malande!",

	poison = "Tödliches Gift",
	poison_desc = "Warnt wenn Tödliches Gift auf Spielern ist .",
	poison_trigger = "^([^%s]+) ([^%s]+) ist von Tödliches Gift betroffen%.$",
	poison_other = "%s hat Tödliches Gift!",
	poison_you = "Tödliches Gift on DIR!",

	icon = "Schlachtgruppen Symbol",
	icon_desc = "Plaziert ein Schlachtgruppen Symbol auf Spielern mit Tödliches Gift.",

	circle = "Kreis der Heilung",
	circle_desc = "Warnt wenn Malande anfängt Kreis der Heilung zu zaubern.",
	circle_trigger = "Lady Malande beginnt Kreis der Heilung zu wirken.",
	circle_message = "Zaubert Kreis der Heilung!",
	circle_heal_trigger = "^Lady Malande 's Kreis der Heilung heilt",
	circle_fail_trigger = "^([^%s]+) unterbricht Lady Malande's Kreis der Heilung%.$",
	circle_heal_message = "Geheilt! - Nächster in ~20sek",
	circle_fail_message = "%s Unterbrochen! - Nächster in ~12sek",
	circle_bar = "~Kreis der Heilung Cooldown",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = {malande, gathios, zerevor, veras}
mod.toggleoptions = {"immune", "shield", "circle", -1, "poison", "icon", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Poison")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Poison")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Poison")

	self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE", "Interrupt")
	self:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE", "Interrupt")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "Interrupt") -- might not be needed?
	self:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE", "Interrupt")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MalSpell", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MalMelee", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MalShield", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MalCCast", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MalCHeal", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "ICKick", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "CouncilPoison", 2)

	pName = UnitName("player")
end

------------------------------
--      Event Handlers      --
------------------------------


function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "MalSpell" and self.db.profile.immune then
		self:Message(fmt(L["immune_message"], L["spell"]), "Positive", nil, "Alarm")
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["immune_message"], L["melee"]))
		self:Bar(fmt(L["immune_bar"], L["spell"]), 15, "Spell_Holy_SealOfRighteousness")
	elseif sync == "MalMelee" and self.db.profile.immune then
		self:Message(fmt(L["immune_message"], L["melee"]), "Positive", nil, "Alert")
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["immune_message"], L["spell"]))
		self:Bar(fmt(L["immune_bar"], L["melee"]), 15, "Spell_Holy_SealOfProtection")
	elseif sync == "MalShield" and self.db.profile.shield then
		self:Message(L["shield_message"], "Important", nil, "Long")
		self:Bar(L["shield_message"], 20, "Spell_Holy_PowerWordShield")
	elseif sync == "MalCCast" and self.db.profile.circle then
		self:Message(L["circle_message"], "Attention", nil, "Info")
		self:Bar(L["circle"], 2.5, "Spell_Holy_CircleOfRenewal")
	elseif sync == "MalCHeal" and self.db.profile.circle then
		self:Message(L["circle_heal_message"], "Urgent")
		self:Bar(L["circle_bar"], 20, "Spell_Holy_CircleOfRenewal")
	elseif sync == "ICKick" and rest and self.db.profile.circle then
		self:Message(fmt(L["circle_fail_message"], rest), "Urgent")
		self:Bar(L["circle_bar"], 12, "Spell_Holy_CircleOfRenewal")
	elseif sync == "TICWin" and self.db.profile.bosskill then
		self:Message(death, "Bosskill", nil, "Victory")
		BigWigs:ToggleModuleActive(self, false)
	elseif sync == "CouncilPoison" and rest and self.db.profile.poison then
		local other = fmt(L["poison_other"], rest)
		if rest == pName then
			self:Message(L["poison_you"], "Personal", true, "Long")
			self:Message(other, "Attention", nil, nil, true)
		else
			self:Message(other, "Attention")
		end
		if self.db.profile.icon then
			self:Icon(rest)
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.enrage and (msg == L["engage_trigger1"] or msg == L["engage_trigger2"] or msg == L["engage_trigger3"] or msg == L["engage_trigger4"]) then
		self:Message(fmt(L2["enrage_start"], boss, 15), "Attention")
		self:DelayedMessage(300, fmt(L2["enrage_min"], 10), "Positive")
		self:DelayedMessage(600, fmt(L2["enrage_min"], 5), "Positive")
		self:DelayedMessage(840, fmt(L2["enrage_min"], 1), "Positive")
		self:DelayedMessage(870, fmt(L2["enrage_sec"], 30), "Positive")
		self:DelayedMessage(890, fmt(L2["enrage_sec"], 10), "Urgent")
		self:DelayedMessage(895, fmt(L2["enrage_sec"], 5), "Urgent")
		self:DelayedMessage(900, fmt(L2["enrage_end"], boss), "Attention", nil, "Alarm")
		self:Bar(L2["enrage"], 900, "Spell_Shadow_UnholyFrenzy")
	end
end

function mod:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	local die = UNITDIESOTHER
	if msg == fmt(die, malande) then
		self:Sync("TICWin")
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["immune_spell_trigger"] then
		self:Sync("MalSpell")
	elseif msg == L["immune_melee_trigger"] then
		self:Sync("MalMelee")
	elseif msg == L["shield_trigger"] then
		self:Sync("MalShield")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["circle_trigger"] then
		self:Sync("MalCCast")
	elseif msg == L["circle_heal_trigger"] then
		self:Sync("MalCHeal")
	end
end

function mod:Poison(msg)
	local pplayer, ptype = select(3, msg:find(L["poison_trigger"]))
	if pplayer and ptype then
		if pplayer == L2["you"] and ptype == L2["are"] then
			pplayer = pName
		end
		self:Sync("CouncilPoison "..pplayer)
	end
end

function mod:Interrupt(msg)
	local player = select(3, msg:find(L["circle_fail_trigger"]))
	if player then
		if player == L2["you"] then --prob need something better than this
			player = pName
		end
		self:Sync("ICKick "..player)
	end
end
