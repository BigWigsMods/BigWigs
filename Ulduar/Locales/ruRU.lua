
local L = BigWigs:NewBossLocale("Algalon the Observer", "ruRU")
if L then
	L.phase = "Фазы"
	L.phase_desc = "Сообщать о смене фаз."
	L.engage_warning = "1-ая фаза"
	L.phase2_warning = "Наступление 2-ой фазы"
	L.phase_bar = "%d-ая фаза"
	L.engage_trigger = "Ваши действия нелогичны. Все возможные исходы этой схватки просчитаны. Пантеон получит сообщение от Наблюдателя в любом случае."

	L.punch_message = "%2$dx фазовых удара на |3-5(%1$s)"
	L.smash_message = "Наступление Кары небесной!"
	L.blackhole_message = "Появление черной дыры %d"
	L.bigbang_bar = "~Суровый удар"
	L.bigbang_soon = "Скоро Суровый удар!"
end

L = BigWigs:NewBossLocale("Auriaya", "ruRU")
if L then
	L.engage_trigger = "Some things are better left alone!"

	L.fear_warning = "Скоро Ужасающий вопль!"
	L.fear_message = "Применение страха!"
	L.fear_bar = "~Страх"

	L.swarm_message = "Cтража"
	L.swarm_bar = "~Стража"

	L.defender = "Дикий защитник"
	L.defender_desc = "Сообщать о жизни Дикого защитника."
	L.defender_message = "Защитник (%d/9)!"

	L.sonic_bar = "~Визг"
end

L = LibStub("AceLocale-3.0"):NewLocale("Freya", "ruRU")
if L then
	L.engage_trigger1 = "Нужно защитить Оранжерею!"
	L.engage_trigger2 = "Древни, дайте мне силы!"

	L.phase = "Фазы"
	L.phase_desc = "Сообщать о смене фаз."
	L.phase2_message = "2ая фаза!"

	L.wave = "Волны"
	L.wave_desc = "Сообщать о волнах."
	L.wave_bar = "Следующая волна"
	L.conservator_trigger = "Эонар, твоей прислужнице нужна помощь!"
	L.detonate_trigger = "Вас захлестнет сила стихий!"
	L.elementals_trigger = "Помогите мне, дети мои!"
	L.tree_trigger = "|cFF00FFFFДар Хранительницы жизни|r начинает расти!"
	L.conservator_message = "Древний опекун!"
	L.detonate_message = "Взрывные плеточники!"
	L.elementals_message = "Элементали!"

	L.tree = "Дар Эонара"
	L.tree_desc = "Сообщать когда Фрейа призывает Дар Эонара."
	L.tree_message = "Появление Дара Эонара!"

	L.fury_message = "Гнев"
	L.fury_other = "Гнев на: |3-5(%s)"

	L.tremor_warning = "Скоро Дрожание земли!"
	L.tremor_bar = "~Дрожание земли"
	L.energy_message = "Нестабильная энергия на ВАС!"
	L.sunbeam_message = "Луч солнца!"
	L.sunbeam_bar = "~следующий Луч солнца"

	L.end_trigger = "Он больше не властен надо мной. Мой взор снова ясен. Благодарю вас, герои."
end

L = LibStub("AceLocale-3.0"):NewLocale("Hodir", "ruRU")
if L then
	L.engage_trigger = "Вы будете наказаны за это вторжение!"

	L.cold = "Трескучий мороз"
	L.cold_desc = "Сообщать когда на вас наложено 2 эффекта Трескучего мороза"
	L.cold_message = "Трескучий мороз x%d!"

	L.flash_warning = "Применение мгновенной заморозки!"
	L.flash_soon = "Заморозка через 5сек!"

	L.hardmode = "Сложный режим"
	L.hardmode_desc = "Отображать таймер сложного режима."

	L.end_trigger = "Наконец-то я... свободен от его оков…"
end

L = LibStub("AceLocale-3.0"):NewLocale("Ignis the Furnace Master", "ruRU")
if L then
	L.engage_trigger = "Дерзкие глупцы! Ваша кровь закалит оружие, которым был завоеван этот мир!"

	L.construct_message = "Задействовать создание!"
	L.construct_bar = "Следующее создание"
	L.brittle_message = "Создание подверглось Ломкости!"
	L.flame_bar = "~перезарядка струи"
	L.scorch_message = "Ожог на ВАС!"
	L.scorch_soon = "Ожог через ~5сек!"
	L.scorch_bar = "Следующий Ожог"
	L.slagpot_message = "Захвачен в ковш: %s"
end

L = LibStub("AceLocale-3.0"):NewLocale("The Iron Council", "ruRU")
if L then
	L.engage_trigger1 = "Чужаки! Вам не одолеть Железное Собрание!"
	L.engage_trigger2 = "Я буду спокоен, лишь когда окончательно истреблю вас."
	L.engage_trigger3 = "Кто бы вы ни были - жалкие бродяги или великие герои... Вы всего лишь смертные!"

	L.overload_message = "Взрыв через 6сек!"
	L.death_message = "На ВАС Руна СМЕРТИ!"
	L.summoning_message = "Руна призыва - приход Элементалей!"

	L.chased_other = "Преследует |3-3(%s)!"
	L.chased_you = "ВАС преследуют!"

	L.overwhelm_other = "Переполняющая энергия на |3-5(%s)"

	L.shield_message = "Применён Рунический щит!"

	L.council_dies = "%s умер"
end

L = LibStub("AceLocale-3.0"):NewLocale("Kologarn", "ruRU")
if L then
	L.arm = "Уничтожение рук"
	L.arm_desc = "Сообщать о смерти левой и правой руки."
	L.left_dies = "Левая рука уничтожена"
	L.right_dies = "Правая рука уничтожена"
	L.left_wipe_bar = "Восcтaновление левой руки"
	L.right_wipe_bar = "Восcтaновление правой руки"

	L.shockwave = "Ударная волна"
	L.shockwave_desc = "Сообщает о грядущей Ударной волне."
	L.shockwave_trigger = "ЗАБВЕНИЕ!"

	L.eyebeam = "Сосредоточенный взгляд"
	L.eyebeam_desc = "Сообщать кто попал под воздействие Сосредоточенный взгляд."
	L.eyebeam_trigger = "Кологарн устремляет на вас свой взгляд!"
	L.eyebeam_message = "Взгляд: %s"
	L.eyebeam_bar = "~Взгляд"
	L.eyebeam_you = "Взгляд на ВАС!"
	L.eyebeam_say = "Взгяд на МНЕ!"

	L.eyebeamsay = "Сказать о взгяде"
	L.eyebeamsay_desc = "Сказать когда вы цель взгляда."

	L.armor_message = "%2$dx Хруста на |3-5(%1$s)"
end

L = LibStub("AceLocale-3.0"):NewLocale("Flame Leviathan", "ruRU")
if L then
	L.engage = "Сообщать о начале боя"
	L.engage_desc = "Сообщать о начале боя с Огненным Левиафаном."
	L.engage_trigger = "^Обнаружены противники."
	L.engage_message = "%s вступает в бой!"

	L.pursue = "Погоня"
	L.pursue_desc = "Сообщать когда Огненный Левиафан преследует игрока."
	L.pursue_trigger = "^%%s наводится на"
	L.pursue_other = "Левиафан преследует |3-3(%s)!"

	L.shutdown_message = "Отключение системы!"
end

L = LibStub("AceLocale-3.0"):NewLocale("Mimiron", "ruRU")
if L then
	L.phase = "Фазы"
	L.phase_desc = "Сообщать о смене фаз."
	L.engage_warning = "1ая фаза"
	L.engage_trigger = "^У нас мало времени, друзья!"
	L.phase2_warning = "Наступает 2-ая фаза"
	L.phase2_trigger = "^ПРЕВОСХОДНО! Просто восхитительный результат!"
	L.phase3_warning = "Наступает 3-ая фаза"
	L.phase3_trigger = "^Спасибо, друзья!"
	L.phase4_warning = "Наступает 4-ая фаза"
	L.phase4_trigger = "^Фаза предварительной проверки завершена."
	L.phase_bar = "%d фаза"

	L.hardmode_trigger = "^Так, зачем вы это сделали?"

	L.plasma_warning = "Применяется Взрыв плазмы!"
	L.plasma_soon = "Скоро Взрыв плазмы!"
	L.plasma_bar = "Взрыв плазмы"

	L.shock_next = "Следующий Шоковый удар!"

	L.laser_soon = "Вращение!"
	L.laser_bar = "Обстрел"

	L.magnetic_message = "Магнитное ядро! БОМБИТЕ!"

	L.suppressant_warning = "Подавитель пламени!"

	L.fbomb_soon = "Скоро Ледяная бомба!"
	L.fbomb_bar = "~Ледяная бомба"

	L.bomb_message = "Появился Бомбот!"

	L.end_trigger = "^Очевидно, я совершил небольшую ошибку в расчетах."
end

L = LibStub("AceLocale-3.0"):NewLocale("Razorscale", "ruRU")
if L then
	L.phase = "Фазы"
	L.phase_desc = "Сообщать когда Острокрылая меняет фазы."
	L.ground_trigger = "Быстрее! Сейчас она снова взлетит!"
	L.ground_message = "Острокрылая на привязи!"
	L.air_trigger = "Дайте время подготовить пушки."
	L.air_trigger2 = "Огонь прекратился! Надо починить пушки!"
	L.air_message = "Взлет!"
	L.phase2_trigger = "%s обессилела и больше не может летать!"
	L.phase2_message = "Вторая фаза!"
	L.phase2_warning = "Скоро вторая фаза!"
	L.stun_bar = "Оглушение"

	L.breath_trigger = "%s делает глубокий вдох…"
	L.breath_message = "Огненное дыхание!"
	L.breath_bar = "~перезарядка дыхания"

	L.flame_message = "ВЫ в Лавовой БОМБЕ!"

	L.harpoon = "Гарпунная Пушка"
	L.harpoon_desc = "Объявлять Гарпунные Пушки."
	L.harpoon_message = "Пушка (%d) готова!"
	L.harpoon_trigger = "Гарпунная пушка готова!"
	L.harpoon_nextbar = "Гарпун (%d)"
end

L = LibStub("AceLocale-3.0"):NewLocale("Thorim", "ruRU")
if L then
	L["Runic Colossus"] = "Рунический колосс" -- For the runic barrier emote.

	L.phase = "Фазы"
	L.phase_desc = "Сообщать о смене фаз."
	L.phase1_message = "Начало 1-ой фазы"
	L.phase2_trigger = "Незваные гости! Вы заплатите за то, что посмели вмешаться... Погодите, вы..."
	L.phase2_message = "2ая фаза - Исступление через 6мин 15сек!"
	L.phase3_trigger = "Бесстыжие выскочки, вы решили бросить вызов мне лично? Я сокрушу вас всех!"
	L.phase3_message = "3-я фаза - Торим вступает в бой!"

	L.hardmode = "Таймеры сложного режима"
	L.hardmode_desc = "Отображения таймера для сложного режима."
	L.hardmode_warning = "Завершение сложного режима"

	L.shock_message = "На вас Поражение громом! Шевелитесь!"
	L.barrier_message = "Колосс под Рунической преградой!"

	L.detonation_say = "Я БОМБА!"

	L.charge_message = "Разряд: x%d"
	L.charge_bar = "Разряд %d"

	L.strike_bar = "~Дисбалансирующий удар"

	L.end_trigger = "Придержите мечи! Я сдаюсь."
end

L = LibStub("AceLocale-3.0"):NewLocale("General Vezax", "ruRU")
if L then
	L.engage_trigger = "Ваша смерть возвестит новую эру страданий!"

	L.surge_message = "Наплыв %d!"
	L.surge_cast = "Применяется наплыв %d!"
	L.surge_bar = "Наплыв %d"

	L.animus = "Саронитовый враг"
	L.animus_desc = "Сообщать о появлении саронитового врага."
	L.animus_trigger = "Саронитовые испарения яростно клубятся и струятся, принимая пугающую форму!"
	L.animus_message = "Появился саронитовый враг!"

	L.vapor = "Саронитовые пары"
	L.vapor_desc = "Сообщать о появлении саронитовых паров."
	L.vapor_message = "Саронитовые пары (%d)!"
	L.vapor_bar = "Пары %d/6"
	L.vapor_trigger = "Поблизости начинают возникать саронитовые испарения!"

	L.vaporstack = "Стаки испарения"
	L.vaporstack_desc = "Сообщать, когда у вас уже 5 стаков саронитового испарения."
	L.vaporstack_message = "Испарения x%d!"

	L.crash_say = "Сокрушение на мне!"

	L.mark_message = "Метка"
	L.mark_message_other = "Метка на: |3-5(%s)!"
end

L = LibStub("AceLocale-3.0"):NewLocale("XT-002 Deconstructor", "ruRU")
if L then
	L.exposed_warning = "Скоро сердце станет уязвимо!"
	L.exposed_message = "Сердце уязвимо!"

	L.gravitybomb_other = "Бомба на |3-5(%s)!"

	L.lightbomb_other = "Взрыв на |3-5(%s)!"

	L.tantrum_bar = "~Раскаты ярости"
end

L = LibStub("AceLocale-3.0"):NewLocale("Yogg-Saron", "ruRU")
if L then
	L["Crusher Tentacle"] = "Тяжелое щупальце"
	L["The Observation Ring"] = "Круг Наблюдения"

	L.phase = "Фазы"
	L.phase_desc = "Сообщать о смене фаз."
	L.engage_warning = "1-ая фаза"
	L.engage_trigger = "^Скоро мы сразимся с главарем этих извергов!"
	L.phase2_warning = "2-ая фаза"
	L.phase2_trigger = "^Я – это сон наяву"
	L.phase3_warning = "3-ая фаза"
	L.phase3_trigger = "^Взгляните в истинное лицо"

	L.portal = "Портал"
	L.portal_desc = "Сообщать о портале."
	L.portal_trigger = "В сознание |3-1(%s) открываются порталы!"
	L.portal_message = "Порталы открыты!"
	L.portal_bar = "Следующий портал"

	L.fervor_cast_message = "Применяется Рвение на |3-5(%s)!"
	L.fervor_message = "Рвение на |3-5(%s)!"

	L.sanity_message = "Вы теряете рассудок!"

	L.weakened = "Оглушение"
	L.weakened_desc = "Сообщать, когда Йогг-Сарон производит оглушение."
	L.weakened_message = "%s оглушен!"
	L.weakened_trigger = "Иллюзия разрушена и путь в центральную комнату открыт!"

	L.madness_warning = "Помешательство через 5сек!"
	L.malady_message = "Болезнь у: |3-1(%s)"

	L.tentacle = "Тяжелое щупальце"
	L.tentacle_desc = "Сообщать о появлении тяжелого щупальца."
	L.tentacle_message = "Щупальце %d!"

	L.link_warning = "У вас схожее мышление!"

	L.gaze_bar = "~Взгляд безумца"
	L.empower_bar = "~Сгущение тьмы"

	L.guardian_message = "Страж %d!"

	L.empowericon_message = "Сгущение тьмы закончилось!"

	L.roar_warning = "Крик через 5 сек!"
	L.roar_bar = "Следущий крик"
end
