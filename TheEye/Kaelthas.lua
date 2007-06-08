------------------------------
--      Are you local?      --
------------------------------

local BB = AceLibrary("Babble-Boss-2.2")

local boss = BB["Kael'thas Sunstrider"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local capernian = BB["Grand Astromancer Capernian"]
local sanguinar = BB["Lord Sanguinar"]
local telonicus = BB["Master Engineer Telonicus"]
local thaladred = BB["Thaladred the Darkener"]

BB = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Kael'thas",

	phase = "Phase warnings",
	phase_desc = "Warn about the various phases of the encounter.",

	conflag = "Conflagration",
	conflag_desc = "Warn about Conflagration on a player.",

	temperament = "Chaotic Temperament",
	temperament_desc = "Warn about Chaotic Temperament on a player.",

	gaze = "Gaze",
	gaze_desc = "Warn when Thaladred focuses on a player.",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon over the player that Thaladred sets eyes on.",

	fear = "Fear",
	fear_desc = "Warn when about Bellowing Roar.",

	rebirth = "Phoenix Rebirth",
	rebirth_desc = "Warn for Rebirth",
	rebirth_trigger = "Phoenix begins to cast Rebirth.",
	rebirth_warning = "Phoenix Rebirth in 5sec!",

	pyro = "Pyroblast",
	pyro_desc = "Show a 60 second timer for Pyroblast",
	pyro_trigger = "%s begins to cast Pyroblast!",
	pyro_warning = "Pyroblast in 5sec!",
	pyro_message = "Casting Pyroblast!",

	thaladred_inc_trigger = "Impressive. Let us see how your nerves hold up against the Darkener, Thaladred!",
	sanguinar_inc_trigger = "You have persevered against some of my best advisors... but none can withstand the might of the Blood Hammer. Behold, Lord Sanguinar!",
	capernian_inc_trigger = "Capernian will see to it that your stay here is a short one.",
	telonicus_inc_trigger = "Well done, you have proven worthy to test your skills against my master engineer, Telonicus.",
	weapons_inc_trigger = "As you see, I have many weapons in my arsenal....",
	phase2_trigger = "Perhaps I underestimated you. It would be unfair to make you fight all four advisors at once, but... fair treatment was never shown to my people. I'm just returning the favor.",
	phase3_trigger = "Alas, sometimes one must take matters into one's own hands. Balamore shanal!",

	flying_trigger = "I have not come this far to be stopped! The future I have planned will not be jeapordized! Now, you will taste true power!!",
	gravity_trigger1 = "Let us see how you fare when your world is turned upside down.",
	gravity_trigger2 = "Having trouble staying grounded?",

	gravity_bar = "Next Gravity Lapse",
	gravity_message = "Gravity Lapse!",
	flying_message = "Flying! Gravity Lapse in 1min",

	weapons_inc_message = "Weapons incoming!",
	phase2_message = "Phase 2 - Advisors and Weapons!",
	phase3_message = "Phase 3 - Kael inc!",
	phase3_bar = "Kael'thas incoming",

	mc_trigger1 = "Obey me.",
	mc_trigger2 = "Bow to my will.",
	mc_bar = "Mind Control Cooldown",
	mc_message = "Mind Control! Next in ~33+ sec.",

	afflicted_trigger = "^(%S+) (%S+) afflicted by (.*).$",

	temperament_spell = "Chaotic Temperament",
	temperament_message = "Temperament on %s!",

	conflag_spell = "Conflagration",
	conflag_message = "Conflag on %s!",

	gaze_trigger = "sets eyes on ([^%s]+)!$",
	gaze_message = "Gaze on %s!",
	gaze_bar = "Gaze cooldown",

	fear_soon_message = "Fear soon!",
	fear_message = "Fear!",
	fear_bar = "Fear Cooldown",

	fear_soon_trigger = "Lord Sanguinar begins to cast Bellowing Roar.",
	fear_trigger1 = "^Lord Sanguinar's Bellowing Roar was resisted by %S+.$",
	fear_trigger2 = "^Lord Sanguinar's Bellowing Roar fails. %S+ is immune.$",
	fear_spell = "Bellowing Roar",

	revive_bar = "Adds Revived",
	revive_warning = "Adds Revived in 5sec!",

	-- Weapons
	["Devastation"] = true, -- Axe
	["Cosmic Infuser"] = true, -- Staff
	["Infinity Blades"] = true, -- Dagger
	["Staff of Disintegration"] = true, -- Healer/druid staff
	["Warp Slicer"] = true, -- Sword
	["Netherstrand Longbow"] = true, -- Bow
	["Phaseshift Bulwark"] = true, -- Shield
} end )

L:RegisterTranslations("koKR", function() return {
	phase = "단계 경고",
	phase_desc = "단계 변경에 대한 알림.",

	conflag = "거대한 불길",
	conflag_desc = "플레이어에게 거대한 불길 경고.",

	temperament = "혼돈의 기질",
	temperament_desc = "플레이어에게 혼돈의 기질 경고.",

	gaze = "주시",
	gaze_desc = "플레이어에게 탈라드레드의 주시 경고.",

	icon = "공격대 아이콘",
	icon_desc = "탈라드레드의 주시 대상이된 플레이어에 공격대 아이콘 지정(승급자 이상 권한 필요).",

	fear = "공포",
	fear_desc = "우레와 같은 울부짖음 경고.",

	rebirth = "불사조 환생",
	rebirth_desc = "불사조 환생 경고",
	rebirth_trigger = "블사조|1이;가; 환생 시전을 시작합니다.",
	rebirth_warning = "약 5초 이내 불사조 환생!",

	pyro = "불덩이 작렬",
	pyro_desc = "불덩이 작렬에 대한 60초 타이머 표시.",
	pyro_trigger = "%s|1이;가; 불덩이 작렬 시전을 시작합니다.",
	pyro_warning = "약 5초 이내 불덩이 작렬!",
	pyro_message = "불덩이 작열 시전!",

	thaladred_inc_trigger = "암흑의 인도자 탈라드레드를 상대로 얼마나 버틸지 볼까?",
	sanguinar_inc_trigger = "최고의 조언가를 상대로 잘도 버텨냈군. 허나 그 누구도 붉은 망치의 힘에는 대항할 수 없지. 보아라, 군주 생귀나르를!",
	capernian_inc_trigger = "카퍼니안, 놈들이 여기 온 것을 후회하게 해 줘라.",
	telonicus_inc_trigger = "좋아, 그 정도 실력이면 수석기술자 텔로니쿠스를 상대해 볼만하겠어.",
	weapons_inc_trigger = "보다시피 내 무기고엔 굉장한 무기가 아주 많지.",
	phase2_trigger = "네놈들을 과소평가했나 보군. 모두를 한꺼번에 상대하라는 건 불공평한 처사지. 나의 백성도 공평한 대접을 받은 적 없기는 매한가지. 받은 대로 돌려주겠다.",
	phase3_trigger = "Alas, sometimes one must take matters into one's own hands. Balamore shanal!", -- check

	flying_trigger = "I have not come this far to be stopped! The future I have planned will not be jeapordized! Now, you will taste true power!!", -- check
	gravity_trigger1 = "Let us see how you fare when your world is turned upside down.", -- check
	gravity_trigger2 = "Having trouble staying grounded?", -- check

	gravity_bar = "다음 중력 붕괴",
	gravity_message = "중력 붕괴!",
	flying_message = "비행! 1분후 중력 붕괴",

	weapons_inc_message = "무기 임박!",
	phase2_message = "경고 2 - 조언가와 무기!",
	phase3_message = "경고 3 - 캘타스!",
	phase3_bar = "잠시후 캘타스",

	mc_trigger1 = "나를 따르라.", -- check
	mc_trigger2 = "Bow to my will.", -- check
	mc_bar = "정신 지배 대기시간",
	mc_message = "정신 지배! 다음은 약 33초 후!",

	afflicted_trigger = "^([^|;%s]*)(.*)(.+)에 걸렸습니다%.$", -- check

	temperament_spell = "혼돈의 기질",
	temperament_message = "%s에게 혼돈의 기질 - 치유 시전시 침묵!",

	conflag_spell = "거대한 불길",
	conflag_message = "%s에게 거대한 불길!",

	gaze_trigger = "암흑의 인도자 탈라드레드|1이;가; ([^%s]+)|1을;를; 노려봅니다!$",
	gaze_message = "%s 주시!",
	gaze_bar = "주시 대기 시간",

	fear_soon_message = "잠시 후 공포!",
	fear_message = "공포!",
	fear_bar = "공포 대기 시간",

	fear_soon_trigger = "군주 생귀나르|1이;가; 우레와 같은 울부짖음 시전을 시작합니다.",
	fear_trigger1 = "^군주 생귀나르|1이;가; 우레와 같은 울부짖음|1으로;로; %S|1을;를; 공격했지만 저항했습니다.$",
	fear_trigger2 = "^군주 생귀나르|1이;가; 우레와 같은 울부짖음 사용에 실패했습니다. %S|1은;는; 면역입니다.$",
	fear_spell = "우레와 같은 울부짖음",

	revive_bar = "조언가 부활",
	revive_warning = "5초후 조건가 부활!",

	-- Weapons
	["Devastation"] = "황폐의 도끼", -- Axe
	["Cosmic Infuser"] = "붕괴의 지팡이", -- Staff
	["Infinity Blades"] = "무한의 비수", -- Dagger
	["Staff of Disintegration"] = "우주 에너지 주입기", -- Healer/druid staff
	["Warp Slicer"] = "차원의 절단기", -- Sword
	["Netherstrand Longbow"] = "황천매듭 장궁", -- Bow
	["Phaseshift Bulwark"] = "위상 변화의 보루방패", -- Shield
} end )

L:RegisterTranslations("frFR", function() return {
	phase = "Phases",
	phase_desc = "Préviens quand la rencontre entre dans une nouvelle phase.",

	conflag = "Conflagration",
	conflag_desc = "Préviens quand un joueur est touché par la Conflagration.",

	temperament = "Tempérament chaotique",
	temperament_desc = "Préviens quand un joueur est touché par le Tempérament chaotique.",

	gaze = "Focalisation",
	gaze_desc = "Préviens quand Thaladred se focalise sur un joueur.",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur la personne surveillée par Thaladred (nécessite d'être promu ou mieux).",

	fear = "Rugissement",
	fear_desc = "Préviens quand le Seigneur Sanguinar utilise son Rugissement puissant.",

	rebirth = "Renaissance du phénix",
	rebirth_desc = "Préviens quand le phénix renaît.",
	rebirth_trigger = "Phénix commence à lancer Renaissance.", -- à vérifier
	rebirth_warning = "Renaissance du phénix dans 5 sec. !",

	pyro = "Explosion pyrotechnique",
	pyro_desc = "Affiche un compte à rebours de 60 secondes pour l'Explosion pyrotechnique.",
	pyro_trigger = "%s commence à lancer une Explosion pyrotechnique !", -- à vérifier
	pyro_warning = "Explosion pyrotechnique dans 5 sec. !",
	pyro_message = "Explosion pyrotechnique en incantation !",

	thaladred_inc_trigger = "Impressionnant. Voyons comment tiendront vos nerfs face à l'Assombrisseur, Thaladred !", -- à vérifier
	sanguinar_inc_trigger = "Vous avez tenu tête à certains de mes plus talentueux conseillers… mais personne ne peut résister à la puissance du Marteau de sang. Je vous présente, le seigneur Sanguinar !", -- à vérifier
	capernian_inc_trigger = "Capernian fera en sorte que votre séjour ici ne se prolonge pas.", -- à vérifier
	telonicus_inc_trigger = "Bien, vous êtes digne de mesurer votre talent à celui de mon maître ingénieur, Telonicus.", -- à vérifier
	weapons_inc_trigger = "Comme vous le voyez, j'ai plus d'une corde à mon arc…", -- à vérifier
	phase2_trigger = "Peut-être vous ai-je sous-estimés. Il ne serait pas très loyal de vous faire combattre mes quatres conseillers en même temps, mais… mon peuple n'a jamais été traîté avec loyauté. Je ne fais que rendre la politesse.", -- à vérifier
	phase3_trigger = "Il est hélas parfois nécessaire de prendre les choses en main soi-même. Balamore shanal !", -- à vérifier

	flying_trigger = "Je ne suis pas arrivé si loin pour échouer maintenant ! Je ne laisserai pas l'avenir que je prépare être remis en cause ! Vous allez goûter à ma vraie puissance !", -- à vérifier
	gravity_trigger1 = "Voyons comment vous vous débrouillerez une fois la tête en bas.", -- à vérifier
	gravity_trigger2 = "On a du mal à garder les pieds sur terre ?", -- à vérifier

	gravity_bar = "Prochaine Rupture de gravité",
	gravity_message = "Rupture de gravité !",
	flying_message = "En vol ! Rupture de gravité dans 1 min.",

	weapons_inc_message = "Arrivée des armes !",
	phase2_message = "Phase 2 - Conseillers et Armes !",
	phase3_message = "Phase 3 - Kael arrive !",
	phase3_bar = "Arrivée de Kael'thas",

	mc_trigger1 = "Obéis-moi.", -- à vérifier
	mc_trigger2 = "Soumets-toi à ma volonté.", -- à vérifier
	mc_bar = "Cooldown Contrôle mental",
	mc_message = "Contrôle mental ! Prochain dans ~33+ sec.",

	afflicted_trigger = "^(%S+) (%S+) les effets de (.*).$",

	temperament_spell = "Tempérament chaotique",
	temperament_message = "Tempérament sur %s !",

	conflag_spell = "Conflagration",
	conflag_message = "Conflagration sur %s !",

	gaze_trigger = "pose ses yeux sur (%S+) !$", -- à vérifier
	gaze_message = "Focalisation sur %s !",
	gaze_bar = "Cooldown Focalisation",

	fear_soon_message = "Rugissement imminent !",
	fear_message = "Rugissement !",
	fear_bar = "Cooldown Rugissement",

	fear_soon_trigger = "Seigneur Sanguinar commence à lancer Rugissement puissant.",
	fear_trigger1 = "^Seigneur Sanguinar utilise Rugissement puissant, mais %S+ résiste.$",
	fear_trigger2 = "^Seigneur Sanguinar utilise Rugissement puissant, mais %S+ est insensible.$",
	fear_spell = "Rugissement puissant",

	revive_bar = "Retour des conseillers",
	revive_warning = "Retour des conseillers dans 5 sec. !",

	-- Weapons
	["Devastation"] = "Dévastation", -- Axe
	["Cosmic Infuser"] = "Bâton d'infusion cosmique", -- Staff
	["Infinity Blades"] = "Lames d'infinité", -- Dagger
	["Staff of Disintegration"] = "Bâton de désintégration", -- Healer/druid staff
	["Warp Slicer"] = "Tranchoir dimensionnel", -- Sword
	["Netherstrand Longbow"] = "Arc long brins-de-Néant", -- Bow
	["Phaseshift Bulwark"] = "Rempart de déphasage", -- Shield
} end )

L:RegisterTranslations("deDE", function() return {
	phase = "Phasen",
	phase_desc = "Warnt vor den verschiedenen Phasen des Encounters...",

	conflag = "Gro\195\159brand",
	conflag_desc = "Warnt vor Gro\195\159brand auf einem Spieler.",

	temperament = "Chaotic Temperament", -- to translate
	temperament_desc = "Warn about Chaotic Temperament on a player.", -- to translate

	gaze = "Blick",
	gaze_desc = "Warnt, wenn Thaladred sich auf einen Spieler fokussiert.",

	icon = "Icon",
	icon_desc = "Plaziert ein Icon auf dem Spieler, den Thaladred im Blick beh\195\164lt.",

	fear = "Furcht",
	fear_desc = "Warnt vor Dr\195\182hnendem Gebr\195\188ll.",

	rebirth = "Ph\195\182nix Wiedergeburt",
	rebirth_desc = "Warnt vor Wiedergeburt der Ph\195\182nix Eier",
	rebirth_trigger = "Ph\195\182nix beginnt Wiedergeburt zu wirken.",
	rebirth_warning = "Ph\195\182nix Wiedergeburt in 5sec!",

	pyro = "Pyroschlag",
	pyro_desc = "Zeigt einen 60 Sekunden Timer f\195\188r Pyroschlag",
	pyro_trigger = "%s beginnt, Pyroschlag zu wirken!",
	pyro_warning = "Pyroschlag in 5sec!",
	pyro_message = "Pyroschlag!",

	thaladred_inc_trigger = "Eindrucksvoll. Aber werdet Ihr auch mit Thaladred, dem Verfinsterer fertig?",
	sanguinar_inc_trigger = "Ihr habt gegen einige meiner besten Berater bestanden... aber niemand kommt gegen die Macht des Bluthammers an. Zittert vor F\195\188rst Blutdurst!",
	capernian_inc_trigger = "Capernian wird daf\195\188r sorgen, dass Euer Aufenthalt hier nicht lange w\195\164hrt.",
	telonicus_inc_trigger = "Gut gemacht. Ihr habt Euch w\195\188rdig erwiesen, gegen meinen Meisteringenieur, Telonicus, anzutreten.",
	weapons_inc_trigger = "Wie Ihr seht, habe ich viele Waffen in meinem Arsenal...",
	phase2_trigger = "Vielleicht habe ich Euch untersch\195\164tzt. Es w\195\164re unfair, Euch gegen meine vier Berater gleichzeitig k\195\164mpfen zu lassen, aber... mein Volk wurde auch nie fair behandelt. Ich vergelte nur Gleiches mit Gleichem.",
	phase3_trigger = "Ach, manchmal muss man die Sache selbst in die Hand nehmen. Balamore shanal!",
	
	flying_trigger = "I have not come this far to be stopped! The future I have planned will not be jeapordized! Now, you will taste true power!!", -- to translate
	gravity_trigger1 = "Let us see how you fare when your world is turned upside down.", -- to translate
	gravity_trigger2 = "Having trouble staying grounded?", -- to translate

	gravity_bar = "Next Gravity Lapse", -- to translate
	gravity_message = "Gravity Lapse!", -- to translate
	flying_message = "Flying! Gravity Lapse in 1min", -- to translate

	weapons_inc_message = "Waffen kommen!",
	phase2_message = "Phase 2 - Berater und Waffen!",
	phase3_message = "Phase 3 - Kael'thas aktiv!",
	phase3_bar = "Kael'thas aktiv",

	mc_trigger1 = "Gehorcht mir!",
	mc_trigger2 = "Beugt Euch meinem Willen!",
	mc_bar = "Gedankenkontrolle Cooldown",
	mc_message = "Gedankenkontrolle! N\195\164chste in ~33+ sec.",

	afflicted_trigger = "^(%S+) (%S+) ist von (.*) betroffen.$",

	temperament_spell = "Chaotic Temperament", -- to translate
	temperament_message = "Temperament on %s!", -- to translate

	conflag_spell = "Gro\195\159brand",
	conflag_message = "Gro\195\159brand auf %s!",

	gaze_trigger = "beh\195\164lt ([^%s]+) im Blickfeld!$",
	gaze_message = "Blick auf %s!",
	gaze_bar = "Blick Cooldown",

	fear_soon_message = "Furcht bald!",
	fear_message = "Furcht!",
	fear_bar = "Furcht Cooldown",

	fear_soon_trigger = "F\195\188rst Blutdurst beginnt Dr\195\182hnendes Gebr\195\188ll zu wirken.",
	fear_trigger1 = "^F\195\188rst Blutdurst's Dr\195\182hnendes Gebr\195\188ll wurde von %S+ widerstanden.$",
	fear_trigger2 = "^F\195\188rst Blutdurst versucht es mit Dr\195\182hnendes Gebr\195\188ll. Ein Fehlschlag, denn %S+ ist immun.$",
	fear_spell = "Dr\195\182hnendes Gebr\195\188ll",

	revive_bar = "Berater Wiederbelebung",
	revive_warning = "Berater wiederbelebt in 5sec!",

	-- Weapons
	["Devastation"] = "Verw\195\188stung", -- Axe
	["Cosmic Infuser"] = "Kosmische Macht", -- Mace
	["Infinity Blades"] = "Klinge der Unendlichkeit", -- Dagger
	["Staff of Disintegration"] = "Stab der Aufl\195\182sung", -- Healer/druid staff
	["Warp Slicer"] = "Warpschnitter", -- Sword
	["Netherstrand Longbow"] = "Netherbespannter Langbogen", -- Bow
	["Phaseshift Bulwark"] = "Phasenverschobenes Bollwerk", -- Shield
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Tempest Keep"]
mod.otherMenu = "The Eye"
mod.enabletrigger = { boss, capernian, sanguinar, telonicus, thaladred }
mod.wipemobs = {
	L["Devastation"], L["Cosmic Infuser"], L["Infinity Blades"], L["Staff of Disintegration"],
	L["Warp Slicer"], L["Netherstrand Longbow"], L["Phaseshift Bulwark"] }
mod.toggleoptions = { "phase", -1, "temperament", "conflag", "gaze", "icon", "fear", "pyro", "rebirth", "proximity", "bosskill" }
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Afflicted")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Afflicted")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Afflicted")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")

	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "KaelTemper", 6)
	self:TriggerEvent("BigWigs_ThrottleSync", "KaelConflag", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "KaelFearSoon", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "KaelFear", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "PhoenixRebirth", 5)
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if type(self[sync]) == "function" then
		self[sync](self, rest, nick)
	end
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["fear_soon_trigger"] then
		self:Sync("KaelFearSoon")
	elseif msg:find(L["fear_trigger2"]) or msg:find(L["fear_trigger1"]) then
		self:Sync("KaelFear")
	elseif msg == L["rebirth_trigger"] then
		self:Sync("PhoenixRebirth")
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	local player = select(3, msg:find(L["gaze_trigger"]))
	if player then
		self:Bar(L["gaze_bar"], 9, "Spell_Shadow_EvilEye")
		if self.db.profile.gaze then
			self:Message(L["gaze_message"]:format(player), "Important")
		end
		if self.db.profile.icon then
			self:Icon(player)
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["thaladred_inc_trigger"] then
		self:Message(thaladred, "Positive")
	elseif msg == L["sanguinar_inc_trigger"] then
		self:Message(sanguinar, "Positive")
	elseif msg == L["capernian_inc_trigger"] then
		self:Message(capernian, "Positive")
		self:TriggerEvent("BigWigs_ShowProximity", self)
	elseif msg == L["telonicus_inc_trigger"] then
		self:Message(telonicus, "Positive")
		self:TriggerEvent("BigWigs_HideProximity", self)
	elseif msg == L["weapons_inc_trigger"] then
		self:Message(L["weapons_inc_message"], "Positive")
		self:Bar(L["revive_bar"], 95, "Spell_Holy_ReviveChampion")
		self:DelayedMessage(90, L["revive_warning"], "Attention")
	elseif msg == L["phase2_trigger"] then
		self:Message(L["phase2_message"], "Positive")
		self:Bar(L["phase3_bar"], 180, "Spell_ChargePositive")
	elseif msg == L["phase3_trigger"] then
		self:Message(L["phase3_message"], "Positive")
	elseif msg == L["flying_trigger"] then
		self:Message(L["flying_message"], "Attention")
		self:Bar(L["gravity_bar"], 60, "Spell_Nature_UnrelentingStorm")
	elseif msg == L["gravity_trigger1"] or msg == L["gravity_trigger2"] then
		self:Message(L["gravity_message"], "Important")
		self:Bar(L["gravity_bar"], 90, "Spell_Nature_UnrelentingStorm")
	elseif msg == L["mc_trigger1"] or msg == L["mc_trigger2"] then
		self:Message(L["mc_message"], "Urgent")
		self:Bar(L["mc_bar"], 33, "Spell_Shadow_ShadowWordDominate")
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if self.db.profile.pyro and msg == L["pyro_trigger"] then
		self:Bar(L["pyro"], 60, "Spell_Fire_Fireball02")
		self:Message(L["pyro_message"], "Positive")
		self:DelayedMessage(55, L["pyro_warning"], "Attention")
	end
end

function mod:Afflicted(msg)
	local tPlayer, tType, tSpell = select(3, msg:find(L["afflicted_trigger"]))
	if tPlayer and tType then
		if tPlayer == L2["you"] and tType == L2["are"] then
			tPlayer = UnitName("player")
		end
		if tSpell == L["conflag_spell"] then
			self:Sync("KaelConflag " .. tPlayer)
		elseif tSpell == L["temperament_spell"] then
			self:Sync("KaelTemper " .. tPlayer)
		elseif tSpell == L["fear_spell"] then
			self:Sync("KaelFear")
		end
	end
end

function mod:KaelTemper(rest, nick)
	if not rest or not self.db.profile.temperament then return end

	local msg = L["temperament_message"]:format(rest)
	self:Message(msg, "Attention")
	self:Bar(msg, 8, "Spell_Arcane_ArcanePotency")
end

function mod:KaelConflag(rest, nick)
	if not rest or not self.db.profile.conflag then return end

	local msg = L["conflag_message"]:format(rest)
	self:Message(msg, "Attention")
	self:Bar(msg, 10, "Spell_Fire_Incinerate")
end

function mod:KaelFearSoon(rest, nick)
	if not self.db.profile.fear then return end

	self:Message(L["fear_soon_message"], "Urgent")
end

function mod:PhoenixRebirth(rest, nick)
	if not self.db.profile.rebirth then return end

	self:Message(L["rebirth"], "Urgent")
	self:Bar(L["rebirth"], 45, "Spell_Fire_Burnout")
	self:DelayedMessage(40, L["rebirth_warning"], "Attention")
end

function mod:KaelFear(rest, nick)
	if not self.db.profile.fear then return end

	self:Message(L["fear_message"], "Attention")
	self:Bar(L["fear_bar"], 30, "Spell_Shadow_Charm")
end