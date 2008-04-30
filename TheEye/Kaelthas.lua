------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Kael'thas Sunstrider"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local capernian = BB["Grand Astromancer Capernian"]
local sanguinar = BB["Lord Sanguinar"]
local telonicus = BB["Master Engineer Telonicus"]
local thaladred = BB["Thaladred the Darkener"]

local axe = BB["Devastation"]
local mace = BB["Cosmic Infuser"]
local dagger = BB["Infinity Blades"]
local staff = BB["Staff of Disintegration"]
local sword = BB["Warp Slicer"]
local bow = BB["Netherstrand Longbow"]
local shield = BB["Phaseshift Bulwark"]

local MCd = {}
local fmt = string.format
local db = nil
local CheckInteractDistance = CheckInteractDistance
local pName = UnitName("player")
local phase = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Kael'thas",

	engage_trigger = "^Energy. Power.",
	engage_message = "Phase 1",

	conflag = "Conflagration",
	conflag_desc = "Warn about Conflagration on a player.",
	conflag_spell = "Conflagration",
	conflag_message = "Conflag on %s!",

	gaze = "Gaze",
	gaze_desc = "Warn when Thaladred focuses on a player.",
	gaze_trigger = "sets eyes on (%S+)!$",
	gaze_message = "Gaze on %s!",
	gaze_bar = "~Gaze cooldown",
	gaze_you = "Gaze on YOU!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon over the player that Thaladred sets eyes on.",

	fear = "Fear",
	fear_desc = "Warn when about Bellowing Roar.",
	fear_soon_message = "Fear soon!",
	fear_message = "Fear!",
	fear_bar = "~Fear Cooldown",
	fear_spell = "Bellowing Roar",

	rebirth = "Phoenix Rebirth",
	rebirth_desc = "Approximate Phoenix Rebirth timers.",
	rebirth_trigger1 = "Anar'anel belore!",
	rebirth_trigger2 = "By the power of the sun!",
	rebirth_warning = "Possible Rebirth in ~5sec!",
	rebirth_bar = "~Possible Rebirth",

	pyro = "Pyroblast",
	pyro_desc = "Show a 60 second timer for Pyroblast",
	pyro_trigger = "%s begins to cast Pyroblast!",
	pyro_warning = "Pyroblast in 5sec!",
	pyro_message = "Casting Pyroblast!",

	toyall = "Remote Toy",
	toyall_desc = "Warn when a player has Remote Toy. Only counts in Phase 2 to prevent spam.",
	toyall_message = "Toy: %s",

	phase = "Phase warnings",
	phase_desc = "Warn about the various phases of the encounter.",
	thaladred_inc_trigger = "Impressive. Let us see how your nerves hold up against the Darkener, Thaladred! ",
	sanguinar_inc_trigger = "You have persevered against some of my best advisors... but none can withstand the might of the Blood Hammer. Behold, Lord Sanguinar!",
	capernian_inc_trigger = "Capernian will see to it that your stay here is a short one.",
	telonicus_inc_trigger = "Well done, you have proven worthy to test your skills against my master engineer, Telonicus.",
	weapons_inc_trigger = "As you see, I have many weapons in my arsenal....",
	phase3_trigger = "Perhaps I underestimated you. It would be unfair to make you fight all four advisors at once, but... fair treatment was never shown to my people. I'm just returning the favor.",
	phase4_trigger = "Alas, sometimes one must take matters into one's own hands. Balamore shanal!",

	flying_trigger = "I have not come this far to be stopped! The future I have planned will not be jeopardized! Now you will taste true power!!",
	gravity_trigger1 = "Let us see how you fare when your world is turned upside down.",
	gravity_trigger2 = "Having trouble staying grounded?",
	gravity_bar = "Next Gravity Lapse",
	gravity_message = "Gravity Lapse!",
	flying_message = "Phase 5 - Gravity Lapse in 1min",

	weapons_inc_message = "Phase 2 - Weapons incoming!",
	phase3_message = "Phase 3 - Advisors and Weapons!",
	phase4_message = "Phase 4 - Kael'thas incoming!",
	phase4_bar = "Kael'thas incoming",

	mc = "Mind Control",
	mc_desc = "Warn who has Mind Control.",
	mc_message = "Mind Control: %s",

	revive_bar = "Adds Revived",
	revive_warning = "Adds Revived in 5sec!",

	dead_message = "%s dies",
} end )

L:RegisterTranslations("esES", function() return {
	engage_trigger = "^Energía. Poder.",
	engage_message = "Fase 1",

	conflag = "Conflagración (Conflagration)",
	conflag_desc = "Avisar quién tiene Conflagración.",
	conflag_spell = "Conflagración",
	conflag_message = "¡Conflagración en %s!",

	gaze = "Mirada (Gaze)",
	gaze_desc = "Avisar cuando Thaladred mira a un jugador.",
	gaze_trigger = "mira a (%S+)!$",
	gaze_message = "¡Mirada en %s!",
	gaze_bar = "~Mirada",
	gaze_you = "¡Mirada en TI!",

	icon = "Icono de banda",
	icon_desc = "Poner un icono de banda sobre jugadores que reciben la mirada de Thaladred.",

	fear = "Miedo (Fear)",
	fear_desc = "Avisar cuando se lanza Rugido bramante.",
	fear_soon_message = "¡Miedo en breve!",
	fear_message = "¡Miedo!",
	fear_bar = "~Miedo",
	fear_spell = "Rugido bramante",

	rebirth = "Renacer del Fénix",
	rebirth_desc = "Temporizadores aproximados para el Renacer del Fénix.",
	rebirth_trigger1 = "¡Anar'anel belore!",
	rebirth_trigger2 = "¡Por el poder del Sol!",
	rebirth_warning = "Posible Renacer en ~5seg",
	rebirth_bar = "~Posible Renacer",

	pyro = "Piroexplosión (Pyroblast)",
	pyro_desc = "Mostrar un temporizador de 60 seg. para Piroexplosión.",
	pyro_trigger = "%s lanza una piroexplosión",
	pyro_warning = "Piroexplosión en 5seg",
	pyro_message = "¡Lanzando Piroexplosión!",

	toyall = "Juguete remoto (Remote Toy)",
	toyall_desc = "Avisar cuando un jugador tiene Juguete remoto. Solo en Fase 2 para prevenir spam.",
	toyall_message = "Juguete: %s",

	phase = "Fases",
	phase_desc = "Avisar sobre las distintas fases del encuentro.",
	thaladred_inc_trigger = "¡Veamos cómo aguantan vuestros nervios contra el Ensombrecedor, Thaladred!",
	sanguinar_inc_trigger = "Habéis sobrevivido a algunos de mis mejores consejeros... pero nadie puede resistir el poder del Martillo de Sangre. ¡He aquí Lord Sanguinar!",
	capernian_inc_trigger = "Capernian se encargará de que vuestra visita sea breve.",
	telonicus_inc_trigger = "Bien hecho. Parecéis dignos de probar vuestras habilidades con mi maestro ingeniero Telonicus.",
	weapons_inc_trigger = "Como veis, dispongo de un amplio arsenal...",
	phase3_trigger = "Quizás os subestimé. Sería injusto que os enfrentarais a los cuatro consejeros al mismo tiempo, pero... nunca se le ha brindado un trato justo a mi gente. Así que os devuelvo el favor.",
	phase4_trigger = "Desafortunadamente hay veces en las que tienes que hacer las cosas con tus propias manos. ¡Balamore shanal!",

	flying_trigger = "¡No he llegado hasta aquí para que me detengáis! ¡El futuro que he planeado no se pondrá en peligro! ¡Vais a probar el verdadero poder!",
	gravity_trigger1 = "Veamos cómo os sienta tener el mundo al revés.",
	gravity_trigger2 = "Hay que andar con pies de plomo.",
	gravity_bar = "~Gravedad cero",
	gravity_message = "¡Gravedad cero!",
	flying_message = "Fase 5 - Gravedad cero en 1min",

	weapons_inc_message = "¡Fase 2 - Armas!",
	phase3_message = "¡Fase 3 - Consejeros y Armas!",
	phase4_message = "¡Fase 4 - Kael'thas!",
	phase4_bar = "Kael'thas entra",

	mc = "Control mental (Mind Control)",
	mc_desc = "Avisar quién tiene Control mental.",
	mc_message = "Control mental: %s",

	revive_bar = "Añadidos revividos",
	revive_warning = "¡Añadidos reviven en 5seg!",

	dead_message = "%s muere",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "^나의 백성은",
	engage_message = "1 단계",

	conflag = "거대한 불길",
	conflag_desc = "플레이어에게 거대한 불길을 경고합니다.",
	conflag_spell = "거대한 불길",
	conflag_message = "%s에게 거대한 불길!",

	gaze = "주시",
	gaze_desc = "플레이어에게 탈라드레드의 주시를 경고합니다.",
	gaze_trigger = "([^%s]+)|1을;를; 노려봅니다!$",
	gaze_message = "%s 주시!",
	gaze_bar = "~주시 대기 시간",
	gaze_you = "당신을 주시!",

	icon = "전술 표시",
	icon_desc = "탈라드레드의 주시 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	fear = "공포",
	fear_desc = "우레와 같은 울부짖음에 대한 경고입니다.",
	fear_soon_message = "잠시 후 공포!",
	fear_message = "공포!",
	fear_bar = "~공포 대기 시간",
	fear_spell = "우레와 같은 울부짖음",

	rebirth = "불사조 환생",
	rebirth_desc = "불사조 환생 접근 타이머입니다.",
	rebirth_trigger1 = "아나라넬 벨로레!",
	rebirth_trigger2 = "태양의 힘으로!",
	rebirth_warning = "5초 이내 불사조 환생!",
	rebirth_bar = "~환생 가능",

	pyro = "불덩이 작렬",
	pyro_desc = "불덩이 작렬에 대한 60초 타이머를 표시합니다.",
	pyro_trigger = "%s|1이;가; 불덩이 작렬을 시전합니다!$",
	pyro_warning = "약 5초 이내 불덩이 작렬!",
	pyro_message = "불덩이 작렬 시전!",

	toyall = "원격조종 장난감",
	toyall_desc = "원격조종 장난감에 걸릴 시 경고합니다. 많은 스팸으로 2단계만 제외하고 막습니다.",
	toyall_message = "장난감: %s",

	phase = "단계 경고",
	phase_desc = "단계 변경에 대해 알립니다.",
	thaladred_inc_trigger = "암흑의 인도자 탈라드레드를 상대로 얼마나 버틸지 볼까?",
	sanguinar_inc_trigger = "최고의 조언가를 상대로 잘도 버텨냈군. 허나 그 누구도 붉은 망치의 힘에는 대항할 수 없지. 보아라, 군주 생귀나르를!",
	capernian_inc_trigger = "카퍼니안, 놈들이 여기 온 것을 후회하게 해 줘라.",
	telonicus_inc_trigger = "좋아, 그 정도 실력이면 수석기술자 텔로니쿠스를 상대해 볼만하겠어.",
	weapons_inc_trigger = "보다시피 내 무기고에는 굉장한 무기가 아주 많지.",
	phase3_trigger = "네놈들을 과소평가했나 보군. 모두를 한꺼번에 상대하라는 건 불공평한 처사지만, 나의 백성도 공평한 대접을 받은 적 없기는 매한가지. 받은 대로 돌려주겠다.",
	phase4_trigger = "때론 직접 나서야 할 때도 있는 법이지. 발라모어 샤날!",

	flying_trigger = "이대로 물러날 내가 아니다! 반드시 내가 설계한 미래를 실현하리라! 이제 진정한 힘을 느껴 보아라!",
	gravity_trigger1 = "세상을 거꾸로 뒤집으면 어떻게 되는지 구경해 볼까..",
	gravity_trigger2 = "마냥 서 있기만 하려니 힘들지 않나?",
	gravity_bar = "다음 중력 붕괴",
	gravity_message = "중력 붕괴!",
	flying_message = "5 단계 - 1분후 중력 붕괴",

	weapons_inc_message = "2 단계 - 무기 임박!",
	phase3_message = "3 단계 - 조언가와 무기!",
	phase4_message = "4 단계 - 캘타스!",
	phase4_bar = "잠시 후 캘타스",

	mc = "정신 지배",
	mc_desc = "정신 지배에 걸린 플레이어를 알립니다.",
	mc_message = "정신 지배: %s",

	revive_bar = "조언가 부활",
	revive_warning = "5초 이내 조언가 부활!",

	dead_message = "%s 처치! 루팅하세요!",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "^L'énergie. La puissance.",
	engage_message = "Phase 1",

	conflag = "Déflagration",
	conflag_desc = "Prévient quand un joueur subit les effets de la Déflagration.",
	conflag_spell = "Déflagration",
	conflag_message = "Déflag. sur %s !",

	gaze = "Focalisation",
	gaze_desc = "Prévient quand Thaladred se focalise sur un joueur.",
	gaze_trigger = "pose ses yeux sur (%S+) !$",
	gaze_message = "Focalisation sur %s !",
	gaze_bar = "Recharge Focalisation",
	gaze_you = "Focalisation sur VOUS !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur la personne surveillée par Thaladred (nécessite d'être promu ou mieux).",

	fear = "Rugissement",
	fear_desc = "Prévient quand le Seigneur Sanguinar utilise son Rugissement puissant.",
	fear_soon_message = "Rugissement imminent !",
	fear_message = "Rugissement !",
	fear_bar = "Recharge Rugissement",
	fear_spell = "Rugissement puissant",

	rebirth = "Renaissance du phénix",
	rebirth_desc = "Prévient quand le phénix est suceptible de renaitre.",
	rebirth_trigger1 = "Anar'anel belore !",
	rebirth_trigger2 = "Par le pouvoir du soleil !",
	rebirth_warning = "Renaissance probable dans 5 sec. !",
	rebirth_bar = "~Renaissance probable",

	pyro = "Explosion pyrotechnique",
	pyro_desc = "Affiche un compte à rebours de 60 secondes pour l'Explosion pyrotechnique.",
	pyro_trigger = "%s commence à lancer une explosion pyrotechnique !",
	pyro_warning = "Explosion pyrotechnique dans 5 sec. !",
	pyro_message = "Explosion pyrotechnique en incantation !",

	toyall = "Jouet à distance",
	toyall_desc = "Prévient quand un joueur subit les effets du Jouet à distance. S'affiche uniquement en phase 2 pour éviter un spam excessif.",
	toyall_message = "Jouet : %s",

	phase = "Phases",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",
	thaladred_inc_trigger = "Impressionnant. Voyons comment tiendront vos nerfs face à l'Assombrisseur, Thaladred !",
	sanguinar_inc_trigger = "Vous avez tenu tête à certains de mes plus talentueux conseillers… Mais personne ne peut résister à la puissance du Marteau de sang. Je vous présente le seigneur Sanguinar !",
	capernian_inc_trigger = "Capernian fera en sorte que votre séjour ici ne se prolonge pas.",
	telonicus_inc_trigger = "Bien, vous êtes dignes de mesurer votre talent à celui de mon maître ingénieur, Telonicus.",
	weapons_inc_trigger = "Comme vous le voyez, j'ai plus d'une corde à mon arc…",
	phase3_trigger = "Peut-être vous ai-je sous-estimés. Il ne serait pas très loyal de vous faire combattre mes quatre conseillers en même temps, mais… mon peuple n'a jamais été traité avec loyauté. Je ne fais que rendre la politesse.",
	phase4_trigger = "Il est hélas parfois nécessaire de prendre les choses en main soi-même. Balamore shanal !",

	flying_trigger = "Je ne suis pas arrivé si loin pour échouer maintenant ! Je ne laisserai pas l'avenir que je prépare être remis en cause ! Vous allez goûter à ma vraie puissance !",
	gravity_trigger1 = "Voyons comment vous vous débrouillerez une fois la tête en bas.",
	gravity_trigger2 = "On a du mal à garder les pieds sur terre ?",
	gravity_bar = "Prochaine Rupture",
	gravity_message = "Rupture de gravité !",
	flying_message = "Phase 5 - Rupture de gravité dans 1 min.",

	weapons_inc_message = "Phase 2 - Arrivée des armes !",
	phase3_message = "Phase 3 - Conseillers et armes !",
	phase4_message = "Phase 4 - Arrivée de Kael'thas !",
	phase4_bar = "Arrivée de Kael'thas",

	mc = "Contrôle mental",
	mc_desc = "Prévient quand des joueurs subissent les effets du Contrôle mental.",
	mc_message = "Contrôle mental : %s",

	revive_bar = "Retour des conseillers",
	revive_warning = "Retour des conseillers dans 5 sec. !",

	dead_message = "%s meurt",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "^Energie. Kraft.",
	engage_message = "Phase 1",

	phase = "Phasen",
	phase_desc = "Warnt vor den verschiedenen Phasen des Encounters...",

	conflag = "Großbrand",
	conflag_desc = "Warnt vor Großbrand auf einem Spieler.",
	conflag_spell = "Großbrand",
	conflag_message = "Großbrand auf %s!",

	gaze = "Blick",
	gaze_desc = "Warnt, wenn Thaladred sich auf einen Spieler fokussiert.",
	gaze_trigger = "behält ([^%s]+) im Blickfeld!$",
	gaze_message = "Blick auf %s!",
	gaze_bar = "Blick Cooldown",
	gaze_you = "Blick auf DIR!",

	icon = "Schlachtzug Symbol",
	icon_desc = "Plaziert ein Schlachtzug Symbol auf dem Spieler, den Thaladred im Blick behält.",

	fear = "Furcht",
	fear_desc = "Warnt vor Dröhnendem Gebrüll.",
	fear_soon_message = "Furcht bald!",
	fear_message = "Furcht!",
	fear_bar = "Furcht Cooldown",
	fear_spell = "Dröhnendes Gebrüll",

	rebirth = "Phönix Wiedergeburt",
	rebirth_desc = "Warnt vor Wiedergeburt der Phönix Eier.",
	rebirth_trigger1 = "Anar'anel belore!",
	rebirth_trigger2 = "Bei der Macht der Sonne!",
	rebirth_warning = "Phönix Wiedergeburt in 5sec!",
	rebirth_bar = "~Mögliche Wiedergeburt",

	pyro = "Pyroschlag",
	pyro_desc = "Zeigt einen 60 Sekunden Timer f\195\188r Pyroschlag.",
	pyro_trigger = "%s beginnt, Pyroschlag zu wirken!",
	pyro_warning = "Pyroschlag in 5sec!",
	pyro_message = "Pyroschlag!",

	toyall = "Ferngesteuertes Spielzeug",
	toyall_desc = "Warnt,wenn ein Spieler ein Ferngesteuertes Spielzeug ist.",
	toyall_message = "Spielzeug: %s",

	phase = "Phasen Warnungen",
	phase_desc = "Warnt vor den verschiedenen Phasen des Encounters.",
	thaladred_inc_trigger = "Eindrucksvoll. Aber werdet Ihr auch mit Thaladred, dem Verfinsterer fertig?",
	sanguinar_inc_trigger = "Ihr habt gegen einige meiner besten Berater bestanden... aber niemand kommt gegen die Macht des Bluthammers an. Zittert vor Fürst Blutdurst!",
	capernian_inc_trigger = "Capernian wird dafür sorgen, dass Euer Aufenthalt hier nicht lange währt.",
	telonicus_inc_trigger = "Gut gemacht. Ihr habt Euch würdig erwiesen, gegen meinen Meisteringenieur, Telonicus, anzutreten.",
	weapons_inc_trigger = "Wie Ihr seht, habe ich viele Waffen in meinem Arsenal...",
	phase3_trigger = "Vielleicht habe ich Euch unterschätzt. Es wäre unfair, Euch gegen meine vier Berater gleichzeitig kämpfen zu lassen, aber... mein Volk wurde auch nie fair behandelt. Ich vergelte nur Gleiches mit Gleichem.",
	phase4_trigger = "Ach, manchmal muss man die Sache selbst in die Hand nehmen. Balamore shanal!",

	flying_trigger = "Ich bin nicht so weit gekommen, um jetzt noch aufgehalten zu werden! Die Zukunft, die ich geplant habe, darf nicht gefährdet werden. Jetzt bekommt Ihr wahre Macht zu spüren!",
	gravity_trigger1 = "Mal sehen, wie Ihr klarkommt, wenn Eure Welt auf den Kopf gestellt wird.",
	gravity_trigger2 = "Ihr verliert wohl den Boden unter den Füßen?",
	gravity_bar = "Nächster Gravitationsverlust",
	gravity_message = "Gravitationsverlust!",
	flying_message = "Schweben! Gravitationsverlust in 1min",

	weapons_inc_message = "Waffen kommen!",
	phase3_message = "Phase 2 - Berater und Waffen!",
	phase4_message = "Phase 3 - Kael'thas aktiv!",
	phase4_bar = "Kael'thas aktiv",

	mc = "Gedankenkontrolle",
	mc_desc = "Warnt wer von Gedankenkontrolle betroffen ist.",
	mc_message = "Gedankenkontrolle: %s",

	revive_bar = "Berater Wiederbelebung",
	revive_warning = "Berater wiederbelebt in 5sec!",
} end )

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "魔法，能量，我的人民陷入其中不能自拔……自从太阳之井被摧毁之后就是如此。欢迎来到未来。真遗憾，你们无法阻止什么。没有人可以阻止我了！Selama ashal’anore！",
	engage_message = "第一阶段 - 四顾问！",

	conflag = "燃烧",
	conflag_desc = "当玩家受到燃烧时发出警报。",
	conflag_spell = "燃烧",
	conflag_message = "燃烧：>%s <！",

	gaze = "凝视",
	gaze_desc = "当亵渎者萨拉德雷凝视玩家时发出警报。",
	gaze_trigger = "凝视着(.+)！$",
	gaze_message = "凝视：>%s<！",
	gaze_bar = "<凝视 冷却>",
	gaze_you = ">你< 凝视！",

	icon = "团队标记",
	icon_desc = "给受到凝视的队友打上团队标记。（需要权限）",

	fear = "恐惧",
	fear_desc = "当施放低沉咆哮时发出警报。",
	fear_soon_message = "即将 恐惧！",
	fear_message = "恐惧！",
	fear_bar = "<恐惧 冷却>",
	fear_spell = "低沉咆哮",

	rebirth = "凤凰复生",
	rebirth_desc = "凤凰复生计时条。",
	rebirth_trigger1 = "Anar'anel belore!",
	rebirth_trigger2 = "以太阳之名！",
	rebirth_warning = "约5秒后，凤凰复生！",
	rebirth_bar = "<凤凰重生>",

	pyro = "炎爆术",
	pyro_desc = "显示60秒的炎爆术记时条。",
	pyro_trigger = "%s开始施放炎爆术！",
	pyro_warning = "5秒后，炎爆术！",
	pyro_message = "正在施放 炎爆术！",

	toyall = "遥控玩具",
	toyall_desc = "当玩家遥控玩具时发出警报，只在第二阶段时有效以防止误报。",
	toyall_message = "遥控玩具：>%s<！",

	phase = "阶段警报",
	phase_desc = "每阶段首领来领发出警报。",
	thaladred_inc_trigger = "让我们来看看你们如何面对亵渎者萨拉德雷！ ",
	sanguinar_inc_trigger = "你们击败了我最强大的顾问……但是没有人能战胜鲜血之锤。出来吧，萨古纳尔男爵！",
	capernian_inc_trigger = "卡波妮娅会很快解决你们的。",
	telonicus_inc_trigger = "干得不错。看来你们有能力挑战我的首席技师，塔隆尼库斯。",
	weapons_inc_trigger = "你们看，我的个人收藏中有许多武器……",
	phase3_trigger = "也许我确实低估了你们。虽然让你们同时面对我的四位顾问显得有些不公平，但是我的人民从来都没有得到过公平的待遇。我只是在以牙还牙。",
	phase4_trigger = "唉，有些时候，有些事情，必须得亲自解决才行。Balamore shanal！",

	flying_trigger = "我的心血是不会被你们轻易浪费的！我精心谋划的未来是不会被你们轻易破坏的！感受我真正的力量吧！",
	gravity_trigger1 = "如果世界变得上下颠倒，你们会怎么办呢？",
	gravity_trigger2 = "站不住脚了吗？",
	gravity_bar = "<下一引力失效>",
	gravity_message = "引力失效！",
	flying_message = "第五阶段 - 1分钟后引力失效！",

	weapons_inc_message = "第二阶段 - 准备与神器作战！",
	phase3_message = "第三阶段 - 四顾问复生！",
	phase4_message = "第四阶段 - 凯尔萨斯！",
	phase4_bar = "<凯尔萨斯 来临>",

	mc = "精神控制",
	mc_desc = "当玩家受到精神控制时发出警报。",
	mc_message = "精神控制：>%s<！",

	revive_bar = "<凤凰复活>",
	revive_warning = "5秒后，凤凰复活！",

	dead_message = "%s死亡了。",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "能量。力量。我的人民陷入其中不能自拔……自從太陽之井被摧毀之後就顯得更加明顯。歡迎來到未來。真遺憾，你們無法阻止什麼。沒有人可以阻止我了﹗(薩拉斯語)為了人民的正義!",
	engage_message = "第一階段 - 四顧問!",

	conflag = "燃燒",
	conflag_desc = "當玩家受到燃燒時發出警告",
	conflag_spell = "燃燒",
	conflag_message = "燃燒: [%s]",

	gaze = "凝視",
	gaze_desc = "警報誰受到凝視",
	gaze_trigger = "凝視著([^%s]+)!$",
	gaze_message = "凝視: [%s] - 快跑!",
	gaze_bar = "<凝視冷卻>",
	gaze_you = "凝視著你!",

	icon = "團隊標記",
	icon_desc = "當目標受到凝視時設置骷髏標記 (需要權限)",

	fear = "恐懼",
	fear_desc = "低沉咆哮警示",
	fear_soon_message = "即將恐懼!",
	fear_message = "恐懼!",
	fear_bar = "<恐懼冷卻>",
	fear_spell = "低沉咆哮",

	rebirth = "鳳凰復生",
	rebirth_desc = "顯示鳳凰復生的計時",
	rebirth_trigger1 = "(薩拉斯語)以太陽之名!",
	rebirth_trigger2 = "(薩拉斯語)以太陽之名!",
	rebirth_warning = "約 5 秒內鳳凰可能復生!",
	rebirth_bar = "<估計復生時間>",

	pyro = "炎爆術",
	pyro_desc = "顯示一個 60 秒的炎爆術計時",
	pyro_trigger = "開始施放炎爆術",
	pyro_warning = "約 5 秒內施放炎爆術!",
	pyro_message = "炎爆術!",

	toyall = "遙控玩具",
	toyall_desc = "當玩家受到遙控玩具影響時警示，僅作用在第二階段，避免洗頻",
	toyall_message = "遙控玩具: [%s]",

	phase = "階段警示",
	phase_desc = "開啟各階段警示",
	thaladred_inc_trigger = "讓我們看看你們這些大膽的狂徒如何反抗晦暗者薩拉瑞德的力量!",
	sanguinar_inc_trigger = "你已經努力的打敗了我的幾位最忠誠的諫言者…但是沒有人可以抵抗血錘的力量。等著看桑古納爾的力量吧!",
	capernian_inc_trigger = "卡普尼恩將保證你們不會在這裡停留太久。",
	telonicus_inc_trigger = "做得好，你已經證明你的實力足以挑戰我的工程大師泰隆尼卡斯。",
	weapons_inc_trigger = "你們看，我的個人收藏中有許多武器……",
	phase3_trigger = "也許我低估了你。要你一次對付四位諫言者也許對你來說是不太公平，但是……我的人民從未得到公平的對待。我只是以牙還牙而已。",
	phase4_trigger = "唉，有些時候，有些事情，必須得親自解決才行。(薩拉斯語)受死吧!",

	flying_trigger = "我的心血是不會被你們輕易浪費的!我精心謀劃的未來是不會被你們輕易破壞的!感受我真正的力量吧!",
	gravity_trigger1 = "如果世界變的上下顛倒，你們會怎麼辦呢?",
	gravity_trigger2 = "站不住腳了嗎?",
	gravity_bar = "下一次重力流逝",
	gravity_message = "重力流逝！",
	flying_message = "第五階段 - 1 分鐘內重力流逝!",

	weapons_inc_message = "第二階段 - 武器即將出現!",
	phase3_message = "第三階段 - 顧問群重生!",
	phase4_message = "第四階段 - 王子來臨!",
	phase4_bar = "<凱爾薩斯來臨>",

	mc = "精神控制",
	mc_desc = "精神控制警報",
	mc_message = "精神控制: [%s]",

	revive_bar = "顧問重生",
	revive_warning = "顧問在 5 秒內活動! 坦克、治療準備就位!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Tempest Keep"]
mod.otherMenu = "The Eye"
mod.enabletrigger = { boss, capernian, sanguinar, telonicus, thaladred }
mod.wipemobs = { axe, mace, dagger, staff, sword, bow, shield }
mod.toggleoptions = { "phase", -1, "conflag", "mc", "toyall", "gaze", "icon", "fear", "pyro", "rebirth", "proximity", "bosskill" }
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Conflag", 37018)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Toy", 37027)
	self:AddCombatListener("SPELL_AURA_APPLIED", "MC", 36797)
	self:AddCombatListener("SPELL_CAST_START", "FearCast", 44863)
	self:AddCombatListener("SPELL_MISSED", "Fear", 44863)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Fear", 44863)
	self:AddCombatListener("UNIT_DIED", "Deaths")


	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	db = self.db.profile
	phase = 0
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Conflag(player, spellID)
	if db.conflag then
		local msg = fmt(L["conflag_message"], player)
		self:IfMessage(msg, "Attention", spellID)
		self:Bar(msg, 10, spellID)
	end
end

function mod:Toy(player, spellID)
	if db.toyall and phase < 3 then
		local msg = fmt(L["toyall_message"], player)
		self:IfMessage(msg, "Attention", spellID)
		self:Bar(msg, 60, spellID)
	end
end

function mod:MC(player)
	if db.conflag then
		MCd[player] = true
		self:ScheduleEvent("BWMCWarn", self.MCWarn, 0.3, self)
	end
end

function mod:FearCast()
	if db.fear then
		self:IfMessage(L["fear_soon_message"], "Urgent", 36922)
	end
end

function mod:Fear(_, spellID)
	if db.fear then
		self:IfMessage(L["fear_message"], "Attention", spellID)
		self:Bar(L["fear_bar"], 30, spellID)
	end
end

function mod:Deaths(unit)
	if unit == axe or unit == mace or unit == dagger or unit == staff or unit == sword or unit == bow or unit == shield then
		self:Message(fmt(L["dead_message"], unit), "Attention")
	elseif unit == boss then
		self:GenericBossDeath(unit)
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if not db.gaze then return end

	local player = select(3, msg:find(L["gaze_trigger"]))
	if player then
		self:Bar(L["gaze_bar"], 9, "Spell_Shadow_EvilEye")
		local other = fmt(L["gaze_message"], player)
		if player == pName then
			self:LocalMessage(L["gaze_you"], "Personal", nil, "Alarm")
			self:WideMessage(other)
		else
			self:Message(other, "Important")
		end
		self:Icon(player, "whisper")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) then
		self:Bar(thaladred, 32, "Spell_Shadow_Charm")
		self:Message(L["engage_message"], "Positive")
		for k in pairs(MCd) do MCd[k] = nil end
		phase = 1
	elseif msg == L["thaladred_inc_trigger"] then
		self:Message(thaladred, "Positive")
	elseif msg == L["sanguinar_inc_trigger"] then
		self:Message(sanguinar, "Positive")
		self:Bar(sanguinar, 13, "Spell_Shadow_Charm")
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
		self:TriggerEvent("BigWigs_StopBar", self, L["gaze_bar"])
	elseif msg == L["capernian_inc_trigger"] then
		self:Message(capernian, "Positive")
		self:Bar(capernian, 7, "Spell_Shadow_Charm")
		self:TriggerEvent("BigWigs_ShowProximity", self)
		self:TriggerEvent("BigWigs_StopBar", self, L["fear_bar"])
	elseif msg == L["telonicus_inc_trigger"] then
		self:Message(telonicus, "Positive")
		self:Bar(telonicus, 8, "Spell_Shadow_Charm")
		self:TriggerEvent("BigWigs_HideProximity", self)
	elseif msg == L["weapons_inc_trigger"] then
		phase = 2
		self:Message(L["weapons_inc_message"], "Positive")
		self:Bar(L["revive_bar"], 95, "Spell_Holy_ReviveChampion")
		self:DelayedMessage(90, L["revive_warning"], "Attention")
	elseif msg == L["phase3_trigger"] then
		phase = 3
		self:Message(L["phase3_message"], "Positive")
		self:Bar(L["phase4_bar"], 180, "Spell_ChargePositive")
	elseif msg == L["phase4_trigger"] then
		phase = 4
		self:Message(L["phase4_message"], "Positive")
		if db.pyro then
			self:Bar(L["pyro"], 60, "Spell_Fire_Fireball02")
			self:DelayedMessage(55, L["pyro_warning"], "Attention")
		end
		self:TriggerEvent("BigWigs_StopBar", self, L["phase4_bar"])
	elseif msg == L["flying_trigger"] then
		phase = 5
		self:Message(L["flying_message"], "Attention")
		self:Bar(L["gravity_bar"], 60, "Spell_Nature_UnrelentingStorm")
	elseif msg == L["gravity_trigger1"] or msg == L["gravity_trigger2"] then
		self:Message(L["gravity_message"], "Important")
		self:Bar(L["gravity_bar"], 90, "Spell_Nature_UnrelentingStorm")
	elseif db.rebirth and (msg == L["rebirth_trigger1"] or msg == L["rebirth_trigger2"]) then
		self:Message(L["rebirth"], "Urgent")
		self:Bar(L["rebirth_bar"], 45, "Spell_Fire_Burnout")
		self:DelayedMessage(40, L["rebirth_warning"], "Attention")
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if db.pyro and msg == L["pyro_trigger"] then
		self:Bar(L["pyro"], 60, "Spell_Fire_Fireball02")
		self:Message(L["pyro_message"], "Positive")
		self:DelayedMessage(55, L["pyro_warning"], "Attention")
	end
end

function mod:MCWarn()
	if db.mc then
		local msg = nil
		for k in pairs(MCd) do
			if not msg then
				msg = k
			else
				msg = msg .. ", " .. k
			end
		end
		self:IfMessage(fmt(L["mc_message"], msg), "Important", 36798, "Alert")
	end
	for k in pairs(MCd) do MCd[k] = nil end
end

