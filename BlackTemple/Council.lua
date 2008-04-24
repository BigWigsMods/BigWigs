------------------------------
--      Are you local?      --
------------------------------

local boss = BB["The Illidari Council"]
local malande = BB["Lady Malande"]
local gathios = BB["Gathios the Shatterer"]
local zerevor = BB["High Nethermancer Zerevor"]
local veras = BB["Veras Darkshadow"]

local fmt = string.format
local db = nil
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "TheIllidariCouncil",

	engage_trigger1 = "You wish to test me?",
	engage_trigger2 = "Common... such a crude language. Bandal!",
	engage_trigger3 = "I have better things to do...",
	engage_trigger4 = "Flee or die!",

	vanish = "Vanish",
	vanish_desc = "Estimated timers for Vanish.",
	vanish_message = "Veras: Vanished! Back in ~30sec",
	vanish_warning = "Vanish Over - %s back!",
	vanish_bar = "Veras Stealthed",

	immune = "Immunity Warning",
	immune_desc = "Warn when Malande becomes immune to spells or melee attacks.",
	immune_message = "Malande: %s Immune for 15sec!",
	immune_bar = "%s Immune!",

	spell = "Spell",
	melee = "Melee",

	shield = "Reflective Shield",
	shield_desc = "Warn when Malande Gains Reflective Shield.",
	shield_message = "Reflective Shield on Malande!",

	poison = "Deadly Poison",
	poison_desc = "Warn for Deadly Poison on players.",
	poison_other = "%s has Deadly Poison!",
	poison_you = "Deadly Poison on YOU!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player with Deadly Poison.",

	circle = "Circle of Healing",
	circle_desc = "Warn when Malande begins to cast Circle of Healing.",
	circle_trigger = "Lady Malande begins to cast Circle of Healing.",
	circle_message = "Casting Circle of Healing!",
	circle_heal_message = "Healed! - Next in ~20sec",
	circle_fail_message = "%s Interrupted! - Next in ~12sec",
	circle_bar = "~Circle of Healing Cooldown",

	res = "Resistance Aura",
	res_desc = "Warn when Gathios the Shatterer gains Chromatic Resistance Aura.",
	res_message = "Gathios: Resistance for 30 sec!",
	res_bar = "Resistance Aura",

	blizzard = "Blizzard on You",
	blizzard_desc = "Warn when you are in a Blizzard.",
	blizzard_message = "Blizzard on YOU!",
} end )

L:RegisterTranslations("esES", function() return {
	engage_trigger1 = "¿Deseáis ponerme a prueba?",
	engage_trigger2 = "¡Lengua común... qué lenguaje tan ordinario! ¡Bandal!",
	engage_trigger3 = "Tengo cosas mejores que hacer...",
	engage_trigger4 = "¡Huid o morid!",

	vanish = "Esfumarse (Vanish)",
	vanish_desc = "Contadores estimados para Esfumarse.",
	vanish_message = "Veras: ¡Esfumarse! Vuelve en ~30seg",
	vanish_warning = "Esfumarse finalizado - ¡%s ha vuelto!",
	vanish_bar = "Veras entra en sigilo",

	immune = "Aviso Inmunidad",
	immune_desc = "Avisar cuando Malande se vuelve inmune a hechizos y ataques cuerpo a cuerpo.",
	immune_message = "Malande: ¡%s Inmune durante 15 seg!",
	immune_bar = "¡%s Inmune!",

	spell = "Hechizo",
	melee = "Cuerpo a cuerpo",

	shield = "Escudo reflectante (Reflective Shield)",
	shield_desc = "Avisar cuando Malande gana Escudo reflectante.",
	shield_message = "¡Escudo reflectante en Malande!",

	poison = "Veneno mortal (Deadly Poison)",
	poison_desc = "Avisar Veneno mortal sobre jugadores.",
	poison_other = "¡%s tiene Veneno mortal!",
	poison_you = "¡Veneno mortal en TI!",

	icon = "Icono de banda",
	icon_desc = "Poner icono de banda en jugadores con Veneno mortal.",

	circle = "Círculo de sanación (Circle of Healing)",
	circle_desc = "Avisar cuando Malande empiece a lanzar Círculo de sanación.",
	circle_trigger = "Lady Malande empieza a lanzar Círculo de sanación.",
	circle_message = "¡Lanzando Círculo de sanación!",
	circle_heal_message = "¡Se ha curado! - Prox. en ~20seg",
	circle_fail_message = "¡%s Interrumpido! - Prox. en ~12seg",
	circle_bar = "~Círculo de sanación",

	res = "Aura de Resistencia cromática (Chromatic Resistance Aura)",
	res_desc = "Avisar cuando Gathios el Despedazador gana Aura de Resistencia cromática.",
	res_message = "Gathios: ¡Resistencia durante 30 seg!",
	res_bar = "Aura de Resistencia cromática",

	blizzard = "Ventisca (Blizzard)",
	blizzard_desc = "Avisar cuando estás en una Ventisca.",
	blizzard_message = "¡Ventisca en TI!",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger1 = "Vous voulez me tester ?",
	engage_trigger2 = "Allons donc... quelle grossièreté. Bandal !", -- à vérifier
	engage_trigger3 = "J'ai mieux à faire...", -- à vérifier
	engage_trigger4 = "Fuyez ou mourez !", -- à vérifier

	vanish = "Disparition",
	vanish_desc = "Délais estimés concernant la Disparition de Veras.",
	vanish_message = "Veras : Disparu ! De retour dans ~30 sec.",
	vanish_warning = "Fin de la Disparition - %s est de retour !",
	vanish_bar = "Veras camouflé",

	immune = "Immunité",
	immune_desc = "Préviens quand Malande devient insensible aux sorts ou aux attaques de mêlée.",
	immune_message = "Malande : insensible %s pendant 15 sec. !",
	immune_bar = "Insensible %s !",

	spell = "aux sorts",
	melee = "en mêlée",

	shield = "Bouclier réflecteur",
	shield_desc = "Préviens quand Malande gagne son Bouclier réflecteur.",
	shield_message = "Bouclier réflecteur sur Malande !",

	poison = "Poison mortel",
	poison_desc = "Préviens quand un joueur subit les effets du Poison mortel.",
	poison_other = "%s a le Poison mortel !",
	poison_you = "Poison mortel sur VOUS !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par le Poison mortel (nécessite d'être promu ou mieux).",

	circle = "Cercle de soins",
	circle_desc = "Préviens quand Malande commence à lancer son Cercle de soins.",
	circle_trigger = "Dame Malande commence à lancer Cercle de soins.",
	circle_message = "Cercle de soins en incantation !",
	circle_heal_message = "Soigné ! - Prochain dans ~20 sec.",
	circle_fail_message = "Interrompu par %s ! - Prochain dans ~12 sec.",
	circle_bar = "~Cooldown Cercle de soins",

	res = "Aura de résistance",
	res_desc = "Préviens quand Gathios le Briseur gagne son Aura de résistance chromatique.",
	res_message = "Gathios : Résistance pendant 30 sec. !",
	res_bar = "Aura de résistance",

	blizzard = "Blizzard sur vous",
	blizzard_desc = "Préviens quand vous êtes dans un Blizzard.",
	blizzard_message = "Blizzard sur VOUS !",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger1 = "날 시험하겠다고?",  --check
	engage_trigger2 = "수준 낮은 언어를 쓰는 족속이로군. 반달!",  --check
	engage_trigger3 = "이깐놈들이나 상대해야 하다니..",  --check
	engage_trigger4 = "꺼져! 안그러면 죽는다!",

	vanish = "소멸",
	vanish_desc = "소멸에 대한 예측 타이머입니다.",
	vanish_message = "베라스: 소멸! 약 30초 이내 출현",
	vanish_warning = "소멸 종료 - %s 출현!",
	vanish_bar = "베라스 은신",

	immune = "면역 경고",
	immune_desc = "말란데가 주문 혹은 근접 공격에 면역 시 알립니다.",
	immune_message = "말란데: 15초간 %s 면역!",
	immune_bar = "%s 면역!",

	spell = "주문",
	melee = "근접",

	shield = "반사의 보호막",
	shield_desc = "말란데가 반사의 보호막을 얻었을 때 알립니다.",
	shield_message = "말란데에 반사의 보호막!",

	poison = "맹독",
	poison_desc = "맹독에 걸린 플레이어를 알립니다.",
	poison_other = "%s에 맹독!",
	poison_you = "당신에 맹독!",

	icon = "전술 표시",
	icon_desc = "맹독에 걸린 플레이어에 전술 표시를 지정합니다 (승급자 이상 권한 필요).",

	circle = "치유의 마법진",
	circle_desc = "말란데가 치유의 마법진 시전 시 알립니다.",
	circle_trigger = "여군주 말란데|1이;가; 치유의 마법진 시전을 시작합니다.",
	circle_message = "치유의 마법진 시전!",
	circle_heal_message = "치유됨! - 다음은 약 20초 이내",
	circle_fail_message = "%s 차단함! - 다음은 약 12초 이내",
	circle_bar = "~치유의 마법진 대기 시간",

	res = "저항의 오라",
	res_desc = "파괴자 가디오스의 오색 저항의 오라를 얻었을 때 알립니다.",
	res_message = "가디오스: 30초간 저항!",
	res_bar = "저항의 오라",

	blizzard = "당신에 눈보라",
	blizzard_desc = "당신이 눈보라에 걸렸을 때 알립니다.",
	blizzard_message = "당신에 눈보라!",
} end )

L:RegisterTranslations("zhCN", function() return {
	engage_trigger1 = "你们要考验我吗？",
	engage_trigger2 = "通用语……多么粗俗的语言。Bandal！",
	engage_trigger3 = "我还有更重要的事情要做……",
	engage_trigger4 = "不逃走就受死吧！",

	vanish = "消失",
	vanish_desc = "消失记时条。",
	vanish_message = "维尔莱斯 - 消失！30秒后重新出现。",
	vanish_warning = "消失结束 - %s出现！",
	vanish_bar = "<消失>",

	immune = "免疫警报",
	immune_desc = "当玛兰德免疫法术或近战攻击时发出警报。",
	immune_message = "女公爵玛兰德 - %s免疫！15秒。",
	immune_bar = "<%s免疫>",

	spell = "法术",
	melee = "近战",

	shield = "反射之盾",
	shield_desc = "当玛兰德获得反射之盾时发出警报。",
	shield_message = "反射之盾！注意！",

	poison = "致命药膏",
	poison_desc = "当玩家受到致命药膏时发出警报。",
	poison_other = "致命药膏：>%s<！",
	poison_you = ">你< 致命药膏！",

	icon = "团队标记",
	icon_desc = "为中致命药膏的玩家打上团队标记。（需要权限）",

	circle = "治疗之环",
	circle_desc = "当玛兰德开始施放治疗之环时发出警报。",
	circle_trigger = "女公爵玛兰德开始施放治疗之环。$",
	circle_message = "正在施放 治疗之环！",
	circle_heal_message = "治疗成功！约20秒后，再次发动。",
	circle_fail_message = "%s 打断！约12秒后，再次发动治疗之环。",
	circle_bar = "<治疗之环 冷却>",

	res = "多彩抗性光环",
	res_desc = "当击碎者加西奥斯获得多彩抗性光环时发出警报。",
	res_message = "击碎者加西奥斯 - 多彩抗性光环，30秒！",
	res_bar = "<多彩抗性光环>",

	blizzard = "暴风雪",
	blizzard_desc = "当你中了暴风雪发出警报。",
	blizzard_message = "暴风雪：>你<！",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger1 = "你們要考驗我嗎?",
	engage_trigger2 = "通用語...多麼粗俗的語言。",
	engage_trigger3 = "我還有更重要的事情要做……",
	engage_trigger4 = "Flee, or die!",

	vanish = "消失",
	vanish_desc = "消失計時條.",
	vanish_message = "維拉斯: 消失! ~30秒回來",
	vanish_warning = "消失結束 - %s 回來了!",
	vanish_bar = "維拉斯潛行",

	immune = "免疫警告",
	immune_desc = "當瑪蘭黛女士免疫法術或近戰時警告",
	immune_message = "瑪蘭黛: %s 15秒免疫!",
	immune_bar = "%s 免疫!",

	spell = "法術",
	melee = "近戰",

	shield = "反射護盾",
	shield_desc = "當瑪蘭黛女士獲得了反射護盾時警告",
	shield_message = "反射護盾在瑪蘭黛女士身上!",

	poison = "致命毒藥",
	poison_desc = "當玩家受到致命毒藥時警告",
	poison_other = "致命毒藥：[%s]",
	poison_you = "致命毒藥在你身上!",

	icon = "團隊標記",
	icon_desc = "為中了致命毒藥的隊員打上團隊標記.",

	circle = "治療之環",
	circle_desc = "當瑪蘭黛女士開始施放治療之環時警告",
	circle_trigger = "瑪蘭黛女士開始施放治療之環。",
	circle_message = "正在施放治療之環!",
	circle_heal_message = "被治療了! - 下一次 ~20秒",
	circle_fail_message = "%s 中斷了! - 下一次 ~12秒",
	circle_bar = "~治療之環冷卻",

	res = "多重抗性光環",
	res_desc = "警告當粉碎者高希歐獲得了多重抗性光環的效果。",
	res_message = "粉碎者高希歐: 多重抗性光環 30 秒!",
	res_bar = "多重抗性光環",

	--blizzard = "Blizzard on You",
	--blizzard_desc = "Warn when you are in a Blizzard.",
	--blizzard_message = "Blizzard on YOU!",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger1 = "Wollt Ihr mich auf die Probe stellen?",
	engage_trigger2 = "Gemeinsprache... welch barbarische Zunge. Bandal!",
	engage_trigger3 = "Ich habe besseres zu tun..",
	engage_trigger4 = "Flieht, oder sterbt!",

	vanish = "Verschwinden",
	vanish_desc = "Geschäzte Timer für das Verschwinden von Veras Schwarzschatten.",
	vanish_message = "Veras: Verschwunden! Zurrück in ~30sek",
	vanish_warning = "Verschwinden vorbei - %s zurrück!",
	vanish_bar = "Veras getarnt",

	immune = "Immunitäts Warnung",
	immune_desc = "Warnen wenn Malande immun gegen Zauber oder Nahkampfangriffe wird.",
	immune_message = "Malande: %s Immun für 15sec!",
	immune_bar = "%s Immun!",

	spell = "Zauber",
	melee = "Nahkampf",

	shield = "Reflektierender Schild",
	shield_desc = "Warnt wenn Malande Reflektierender Schild bekommt.",
	shield_message = "Reflektierender Schild auf Malande!",

	poison = "Tödliches Gift",
	poison_desc = "Warnt wenn Tödliches Gift auf Spielern ist .",
	poison_other = "%s hat Tödliches Gift!",
	poison_you = "Tödliches Gift on DIR!",

	icon = "Schlachtzug Symbol",
	icon_desc = "Plaziert ein Schlachtgruppen Symbol auf Spielern mit Tödliches Gift (benötigt Assistent oder höher).",

	circle = "Kreis der Heilung",
	circle_desc = "Warnt wenn Malande anfängt Kreis der Heilung zu zaubern.",
	circle_trigger = "Lady Malande beginnt Kreis der Heilung zu wirken.",
	circle_message = "Zaubert Kreis der Heilung!",
	circle_heal_message = "Geheilt! - Nächster in ~20sek",
	circle_fail_message = "%s Unterbrochen! - Nächster in ~12sek",
	circle_bar = "~Kreis der Heilung Cooldown",

	res = "Resistenz Aura",
	res_desc = "Warnt wenn Gathios der Zerschmetterer die Aura des chromatischen Widerstands bekommt.",
	res_message = "Gathios: Resistenz für 30 sek!",
	res_bar = "Resistenz Aura",

	--blizzard = "Blizzard on You",
	--blizzard_desc = "Warn when you are in a Blizzard.",
	--blizzard_message = "Blizzard on YOU!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Black Temple"]
mod.enabletrigger = {malande, gathios, zerevor, veras}
mod.toggleoptions = {"immune", "res", "shield", -1, "vanish", "circle", -1, "poison", "icon", -1, "blizzard", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Vanish", 41476)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Shield", 41475)
	self:AddCombatListener("SPELL_AURA_APPLIED", "ResAura", 41453)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Poison", 41485)

	self:AddCombatListener("SPELL_AURA_APPLIED", "SpellWarding", 41451)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Protection", 41450)
	self:AddCombatListener("SPELL_CAST_START", "HealingStart", 41455)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Healed", 41455)
	self:AddCombatListener("SPELL_INTERRUPT", "HealingFailed")
	self:AddCombatListener("SPELL_AURA_APPLIED", "Blizzard", 41482)
	self:AddCombatListener("UNIT_DIED", "Deaths")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Vanish(_, spellID)
	if db.vanish then
		self:IfMessage(L["vanish_message"], "Urgent", spellID, "Alert")
		self:Bar(L["vanish_bar"], 30, spellID)
		self:DelayedMessage(30, fmt(L["vanish_warning"], veras), "Attention")
	end
end

function mod:Shield(_, spellID)
	if db.shield then
		self:IfMessage(L["shield_message"], "Important", spellID, "Long")
		self:Bar(L["shield_message"], 20, spellID)
	end
end

function mod:ResAura(_, spellID)
	if db.res then
		self:IfMessage(L["res_message"], "Positive", spellID)
		self:Bar(L["res_bar"], 30, spellID)
	end
end

function mod:Poison(player, spellID)
	if db.poison then
		local other = fmt(L["poison_other"], player)
		if player == pName then
			self:LocalMessage(L["poison_you"], "Important", spellID, "Long")
			self:WideMessage(other)
		else
			self:IfMessage(other, "Attention", spellID)
		end
		self:Icon(player, "icon")
	end
end

function mod:Deaths(unit)
	if unit == malande then
		self:GenericBossDeath(boss)
	end
end

function mod:SpellWarding(unit, spellID)
	if unit == malande and db.immune then
		self:IfMessage(fmt(L["immune_message"], L["spell"]), "Positive", spellID)
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["immune_message"], L["melee"]))
		self:Bar(fmt(L["immune_bar"], L["spell"]), 15, spellID)
	end
end

function mod:Protection(unit, spellID)
	if unit == malande and db.immune then
		self:IfMessage(fmt(L["immune_message"], L["melee"]), "Positive", spellID)
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["immune_message"], L["spell"]))
		self:Bar(fmt(L["immune_bar"], L["melee"]), 15, spellID)
	end
end

function mod:HealingStart(_, spellID, source)
	if source == malande and db.circle then
		self:IfMessage(L["circle_message"], "Attention", spellID, "Info")
		self:Bar(L["circle"], 2.5, spellID)
	end
end

function mod:Healed(_, spellID, source)
	if source == malande  and db.circle then
		self:IfMessage(L["circle_heal_message"], "Urgent", spellID)
		self:Bar(L["circle_bar"], 20, spellID)
	end
end

function mod:HealingFailed(_, _, source, spellID)
	if spellID == 41455 and db.circle then
		self:Message(fmt(L["circle_fail_message"], source), "Urgent")
		self:Bar(L["circle_bar"], 12, spellID)
	end
end

function mod:Blizzard(player)
	if player == pName and db.blizzard then
		self:LocalMessage(L["blizzard_message"], "Personal", 41482, "Alarm")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if db.enrage and (
		msg:find(L["engage_trigger1"]) or
		msg:find(L["engage_trigger2"]) or
		msg:find(L["engage_trigger3"]) or
		msg:find(L["engage_trigger4"])) then
		self:Enrage(900)
	end
end

