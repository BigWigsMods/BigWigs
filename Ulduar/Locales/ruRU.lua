if true then return end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Algalon", "enUS", true)
L:RegisterTranslations("ruRU", function() return {
	phase = "Фазы",
	phase_desc = "Сообщать о смене фаз.",
	engage_warning = "1-ая фаза",
	phase2_warning = "Наступление 2-ой фазы",
	phase_bar = "%d-ая фаза",
	engage_trigger = "Ваши действия нелогичны. Все возможные исходы этой схватки просчитаны. Пантеон получит сообщение от Наблюдателя в любом случае.",

	punch_message = "%dx фазовых удара на |3-5(%s)",
	smash_message = "Наступление Кары небесной!",
	blackhole_message = "Появление черной дыры %dx",
	bigbang_soon = "Скоро Суровый удар!",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Auriaya", "enUS", true)
L:RegisterTranslations("ruRU", function() return {
	fear_warning = "Скоро Ужасающий вопль!",
	fear_message = "Применение страха!",
	fear_bar = "~страх",

	swarm_message = "Swarm",
	swarm_bar = "~стража",

	defender = "Дикий защитник",
	defender_desc = "Сообщать о жизни Дикого защитника.",
	defender_message = "Защитник (%d/9)!",

	sonic_bar = "~перезарядка визга",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Freya", "enUS", true)
L:RegisterTranslations("ruRU", function() return {
	engage_trigger1 = "Нужно защитить Оранжерею!",
	engage_trigger2 = "Древни, дайте мне силы!",

	phase = "Фазы",
	phase_desc = "Предупреждать о смене фаз.",
	phase2_message = "2ая фаза!",

	wave = "Волны",
	
	wave_desc = "Предупреждать о волнах.",
	wave_bar = "Следующая волна",
	conservator_trigger = "Эонар, твоей прислужнице нужна помощь!",
	detonate_trigger = "Вас захлестнет сила стихий!",
	elementals_trigger = "Помогите мне, дети мои!",
	tree_trigger = "|cFF00FFFFДар Хранительницы жизни|r начинает расти!",
	conservator_message = "Древний опекун!",
	detonate_message = "Взрывные плеточники!",
	elementals_message = "Элементали!",
	tree_message = "Появление Дара Эонара!",

	fury_message = "Fury",
	fury_other = "Гнев на: |3-5(%s)",

	tremor_warning = "Скоро Дрожание земли!",
	tremor_bar = "~Дрожание земли",
	energy_message = "Нестабильная энергия на ВАС!",

	icon = "Помечать иконкой",
	icon_desc = "Помечать рейдовой иконкой игрока, на которого нацелен Луч солнца. (необходимо быть лидером группы или рейда)",

	end_trigger = "Он больше не властен надо мной. Мой взор снова ясен. Благодарю вас, герои.",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Hodir", "enUS", true)
L:RegisterTranslations("ruRU", function() return {
	engage_trigger = "Вы будете наказаны за это вторжение!",

	cold = "Трескучий мороз",
	cold_desc = "Сообщать когда на вас наложено 2 эффекта Трескучего мороза",
	cold_message = "Трескучий мороз x%d!",

	flash_warning = "Применение мгновенной заморозки!",
	flash_soon = "Заморозка через 5сек!",

	hardmode = "Сложный режим",
	hardmode_desc = "Отображать таймер сложного режима.",

	icon = "Помечать иконкой",
	icon_desc = "Помечать рейдовой иконкой игрока, на которого нацелена Грозовая туча.",

	end_trigger = "Наконец-то я... свободен от его оков…",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Ignis", "enUS", true)
L:RegisterTranslations("ruRU", function() return {
	engage_trigger = "Дерзкие глупцы! Ваша кровь закалит оружие, которым был завоеван этот мир!",

	construct_message = "Задействовать создание!",
	construct_bar = "Следующее создание",
	brittle_message = "Создание подверглось Ломкости!",
	flame_bar = "~перезарядка струи",
	scorch_message = "Ожог на ВАС!",
	scorch_soon = "Ожог через ~5сек!",
	scorch_bar = "Следующий Ожог",
	slagpot_message = "Захвачен в ковш: %s",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Iron Council", "enUS", true)
L:RegisterTranslations("ruRU", function() return {
	engage_trigger1 = "Чужаки! Вам не одолеть Железное Собрание!",
	engage_trigger2 = "Я буду спокоен, лишь когда окончательно истреблю вас.",
	engage_trigger3 = "Кто бы вы ни были - жалкие бродяги или великие герои... Вы всего лишь смертные!",

	overload_message = "Взрыв через 6сек!",
	death_message = "На ВАС Руна СМЕРТИ!",
	summoning_message = "Руна призыва - приход Элементалей!",

	chased_other = "Преследует |3-3(%s)!",
	chased_you = "ВАС преследуют!",

	overwhelm_other = "Переполняющая энергия на |3-5(%s)",

	shield_message = "Применён Рунический щит!",

	icon = "Помечать иконкой",
	icon_desc = "Помечать рейдовой иконкой игрока, которого преследует Светящиеся придатки или Переполняющая энергия (необходимо быть лидером группы или рейда).",

	council_dies = "%s умер",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Kologarn", "enUS", true)
L:RegisterTranslations("ruRU", function() return {
	arm = "Уничтожение рук",
	arm_desc = "Сообщать о смерти левой и правой руки.",
	left_dies = "Левая рука уничтожена",
	right_dies = "Правая рука уничтожена",
	left_wipe_bar = "Восcтaновление левой руки",
	right_wipe_bar = "Восcтaновление правой руки",

	shockwave = "Ударная волна",
	shockwave_desc = "Сообщает о грядущей Ударной волне.",
	shockwave_trigger = "ЗАБВЕНИЕ!",

	eyebeam = "Сосредоточенный взгляд",
	eyebeam_desc = "Сообщать кто попал под воздействие Сосредоточенный взгляд.",
	eyebeam_trigger = "Кологарн устремляет на вас свой взгляд!",
	eyebeam_message = "Взгляд: %s",
	eyebeam_bar = "~Взгляд",
	eyebeam_you = "Взгляд на ВАС!",
	eyebeam_say = "Взгяд на мне!",

	eyebeamsay = "Сказать о взгяде",
	eyebeamsay_desc = "Сказать когда вы цель взгляда.",

	armor_message = "%2$dx Хруста на |3-5(%1$s)",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Flame Leviathan", "enUS", true)
L:RegisterTranslations("ruRU", function() return {
	engage_trigger = "^Обнаружены противники.",
	engage_message = "%s вступает в бой!",

	pursue = "Погоня",
	pursue_desc = "Сообщать когда Огненный Левиафан преследует игрока.",
	pursue_trigger = "^%%s наводится на",
	pursue_other = "Левиафан преследует |3-3(%s)!",

	shutdown_message = "Отключение системы!",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Mimiron", "enUS", true)
L:RegisterTranslations("ruRU", function() return {
	phase = "Фазы",
	phase_desc = "Сообщать о смене фаз.",
	engage_warning = "1ая фаза",
	engage_trigger = "^У нас мало времени, друзья!",
	phase2_warning = "Наступает 2-ая фаза",
	phase2_trigger = "^ПРЕВОСХОДНО! Просто восхитительный результат!",
	phase3_warning = "Наступает 3-ая фаза",
	phase3_trigger = "^Спасибо, друзья!",
	phase4_warning = "Наступает 4-ая фаза",
	phase4_trigger = "^Фаза предварительной проверки завершена.",
	phase_bar = "%d фаза",

	hardmode = "Таймеры сложного режима",
	hardmode_desc = "Отображения таймера для сложного режима.",
	hardmode_trigger = "^Так, зачем вы это сделали?",
	hardmode_message = "Сложный режим активирован!",
	hardmode_warning = "Завершение сложного режима",

	plasma_warning = "Применяется Взрыв плазмы!",
	plasma_soon = "Скоро Взрыв плазмы!",
	plasma_bar = "Взрыв плазмы",

	shock_next = "Следующий Шоковый удар!",

	laser_soon = "Вращение!",
	laser_bar = "Обстрел",

	magnetic_message = "Магнитное ядро! БОМБИТЕ!",

	suppressant_warning = "Подавитель пламени!",

	fbomb_soon = "Скоро Ледяная бомба!",
	fbomb_bar = "Следущая Ледяная бомба",

	bomb_message = "Появился Бомбот!",

	end_trigger = "^Очевидно, я совершил небольшую ошибку в расчетах.",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Razorscale", "enUS", true)
L:RegisterTranslations("ruRU", function() return {
	phase = "Фазы",
	phase_desc = "Сообщать когда Острокрылая меняет фазы.",
	ground_trigger = "Быстрее! Сейчас она снова взлетит!",
	ground_message = "Острокрылая на привязи!",
	air_trigger = "Дайте время подготовить пушки.",
	air_trigger2 = "Огонь прекратился! Надо починить пушки!",
	air_message = "Взлет!",
	phase2_trigger = "%s обессилела и больше не может летать!",
	phase2_message = "Вторая фаза!",
	phase2_warning = "Скоро вторая фаза!",
	stun_bar = "Оглушение",

	breath_trigger = "%s делает глубокий вдох…",
	breath_message = "Огненное дыхание!",
	breath_bar = "~перезарядка дыхания",

	flame_message = "ВЫ в Лавовой БОМБЕ!",

	harpoon = "Гарпунная Пушка",
	harpoon_desc = "Объявлять Гарпунные Пушки.",
	harpoon_message = "Пушка (%d) готова!",
	harpoon_trigger = "Гарпунная пушка готова!",
	harpoon_nextbar = "Гарпун (%d)",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Thorim", "enUS", true)
L:RegisterTranslations("ruRU", function() return {
	phase = "Фазы",
	phase_desc = "Сообщать о смене фаз.",
	phase1_message = "Начало 1-ой фазы",
	phase2_trigger = "Незваные гости! Вы заплатите за то, что посмели вмешаться... Погодите, вы...",
	--phase2_message = "2ая фаза - Исступление через 6мин 15сек!",
	phase3_trigger = "Бесстыжие выскочки, вы решили бросить вызов мне лично? Я сокрушу вас всех!",
	phase3_message = "3-яя фаза - %s вступает в бой!",

	hardmode = "Таймеры сложного режима",
	hardmode_desc = "Отображения таймера для сложного режима.",
	hardmode_warning = "Завершение сложного режима",

	shock_message = "На вас Поражение громом! Шевелитесь!",
	barrier_message = "Колосс под Рунической преградой!",

	detonation_say = "Я БОМБА!",

	charge_message = "Разряд: x%d",
	charge_bar = "Разряд %d",

	end_trigger = "Придержите мечи! Я сдаюсь.",

	icon = "Помечать иконкой",
	icon_desc = "Помечать рейдовой иконкой игрока, который попал под воздействие Взрыва рун. (необходимо быть лидером группы или рейда)",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: General Vezax", "enUS", true)
L:RegisterTranslations("ruRU", function() return {
	engage_trigger = "Ваша смерть возвестит новую эру страданий!",

	surge_message = "Наплыв %d!",
	surge_cast = "Применяется наплыв %d!",
	surge_bar = "Наплыв %d",

	animus = "Саронитовый враг",
	animus_desc = "Сообщать о появлении саронитового врага.",
	animus_trigger = "Саронитовые испарения яростно клубятся и струятся, принимая пугающую форму!",
	animus_message = "Появился саронитовый враг!",

	vapor = "Саронитовые пары",
	vapor_desc = "Сообщать о появлении саронитовых паров.",
	vapor_message = "Саронитовые пары (%d)!",
	vapor_bar = "Пары %d/6",
	vapor_trigger = "Поблизости начинают возникать саронитовые испарения!",

	vaporstack = "Стаки испарения",
	vaporstack_desc = "Сообщать, когда у вас уже 5 стаков саронитового испарения.",
	vaporstack_message = "Испарения x%d!",

	crash_say = "Сокрушение на мне!",

	crashsay = "Сказать о оокрушении",
	crashsay_desc = "Сказать, когда вы являетесь целью Темного сокрушения.",

	crashicon = "Иконка сокрушения",
	crashicon_desc = "Помечать рейдовой иконкой (синим квадратом) игрока, на которого наложено темное сокрушение (необходимо обладать промоутом).",

	mark_message = "Метка",
	mark_message_other = "Метка на: |3-5(%s)!",

	icon = "Иконка метки",
	icon_desc = "Помечать рейдовой иконкой игрока, на который попал под воздействие метки безликого (необходимо обладать промоутом)",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: XT-002", "enUS", true)
L:RegisterTranslations("ruRU", function() return {
	exposed_warning = "Скоро сердце станет уязвимо!",
	exposed_message = "Сердце уязвимо!",

	gravitybomb_other = "Бомба на |3-5(%s)!",

	gravitybombicon = "Иконка гравитационной бомбы",
	gravitybombicon_desc = "Помечать рейдовой иконкой (синим квадратом) игрока с бомбой (необходимо обладать промоутом).",

	lightbomb_other = "Взрыв на |3-5(%s)!",

	tantrum_bar = "~Раскаты ярости",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Yogg-Saron", "enUS", true)
L:RegisterTranslations("ruRU", function() return {
	["Crusher Tentacle"] = "Тяжелое щупальце",
	["The Observation Ring"] = "Круг Наблюдения",

	phase = "Фазы",
	phase_desc = "Сообщать о смене фаз.",
	engage_warning = "1-ая фаза",
	engage_trigger = "^Скоро мы сразимся с главарем этих извергов!",
	phase2_warning = "2-ая фаза",
	phase2_trigger = "^Я – это сон наяву",
	phase3_warning = "3-ая фаза",
	phase3_trigger = "^ПАДИТЕ НИЦ ПЕРЕД БОГОМ СМЕРТИ!",

	portal = "Портал",
	portal_desc = "Сообщать о портале.",
	portal_trigger = "В сознание |3-1(%s) открываются порталы!",
	portal_message = "Порталы открыты!",
	portal_bar = "Следующий портал",

	sanity_message = "Вы теряете рассудок!",

	weakened = "Оглушение",
	weakened_desc = "Сообщать, когда Йогг-Сарон производит оглушение.",
	weakened_message = "%s оглушен!",
	weakened_trigger = "Иллюзия разрушена и путь в центральную комнату открыт!",

	madness_warning = "Помешательство через 5сек!",
	malady_message = "Болезнь у: |3-1(%s)",

	tentacle = "Тяжелое щупальце",
	tentacle_desc = "Сообщать о появлении тяжелого щупальца.",
	tentacle_message = "Щупальце %d!",

	link_warning = "У вас схожее мышление!",

	gaze_bar = "~Взгляд безумца",
	empower_bar = "~Сгущение тьмы",

	empowericon = "Иконка сгущения тьмы",
	empowericon_desc = "Помечать черепом Бессмертного стража со сгущением тьмы.",
	empowericon_message = "Сгущение тьмы закончилось!",

	roar_warning = "Крик через 5 сек!",
	roar_bar = "Следущий крик",
} end )
