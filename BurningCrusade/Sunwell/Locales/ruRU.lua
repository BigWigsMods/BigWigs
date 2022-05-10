local L = BigWigs:NewBossLocale("Kil'jaeden", "ruRU")
if not L then return end
if L then
	L.bomb_cast = "Скоро взрыв"
	L.bomb_nextbar = "~ Возможен взрыв"
	L.bomb_warning = "Возможен взрыв ~10 секунд"

	L.orb = "Щитовая сфера"
	L.orb_desc = "Предупреждение о залпе Стрел Тьмы из сферы"
	L.orb_shooting = "Начат обстрел сферой"

	L.shield_up = "Щит поднят!"
	L.deceiver_dies = "Рука Искусителя #%d убита"

	L.blueorb = "Сила Синих драконов"
	L.blueorb_desc = "Предупреждают о появлении Силы Синих Драконов"
	L.blueorb_message = "Сила Синих Драконов готова!"

	L.kalec_yell = "Я направлю силу в сферы! Приготовься!"
	L.kalec_yell2 = "Я наполнил силой еще одну сферу! Используй ее как можно скорее!"
	L.kalec_yell3 = "Еще одна сфера готова! Торопись!"
	L.kalec_yell4 = "Я отдал все, что мог! Энергия в твоих руках!"
	L.phase3_trigger = "Меня не остановить! Этот мир падет!"
	L.phase4_trigger = "Отбросьте напрасные надежды! Вам не победить!"
	L.phase5_trigger = "Аххх… Сила Солнечного Колодца… обращается… против меня! Что это? Что ты наделала?!"
end

L = BigWigs:NewBossLocale("Felmyst", "ruRU")
if L then
	L.phase = "Фазы"
	L.phase_desc = "Предупреждение о смене фаз"
	L.airphase_trigger = "Я сильнее, чем когда-либо прежде!"
	L.takeoff_bar = "Взлет"
	L.takeoff_message = "Взлет через 5 секунд!"
	L.landing_bar = "Посадка"
	L.landing_message = "Посадка через 10 секунд!"

	L.breath = "Дыхание"
	L.breath_desc = "Предупреждение о дыхании."
end

L = BigWigs:NewBossLocale("Brutallus", "ruRU")
if L then
	L.engage_trigger = "О, а вот и новые агнцы идут на заклание!"

	L.burnresist = "Сопротивление Палящему Пламени"
	L.burnresist_desc = "Предупреждать Вас о тех, кто сопротивлении Палящему Пламени."
	L.burn_resist = "%s сопротивляется Палящему Пламени"
end

L = BigWigs:NewBossLocale("M'uru", "ruRU")
if L then
	L.sentinel = "Часовой бездны"
	L.sentinel_desc = "Предупреждать о появлении Часового Бездны."
	L.sentinel_next = "%d-й Часовой Бездны"

	L.humanoid = "Воины клана Темного Меча"
	L.humanoid_desc = "Предупреждать о приходе воинов клана Темного Меча."
	L.humanoid_next = "Воины Темного Меча (%d)"
end

L = BigWigs:NewBossLocale("Kalecgos", "ruRU")
if L then
	L.engage_trigger = "Аххх! Я больше никогда не буду рабом Малигоса! Осмелься бросить мне вызов – и я уничтожу тебя!"
	L.enrage_trigger = "Сатроварр приводит Калесгоса в бешеную ярость!"

	L.sathrovarr = "Сатроварр Осквернитель"

	L.portal = "Портал"
	L.portal_message = "Через 5 секунд возможен Портал!"

	L.realm_desc = "Показывать Вам игроков, затянутых в Спектральную Реальность."
	L.realm_message = "Призрачный мир: %s (Групповой %d)"
	L.nobody = "Никто"

	L.curse = "Проклятье"

	L.wild_magic_healing = "Дикая Магия (Увеличение Исцеления)"
	L.wild_magic_healing_desc = "Предупреждать, когда Вы получите эффект Увеличения Исцеления от Дикой Магии."
	L.wild_magic_healing_you = "Дикая Магия - Эффекты лечения увеличены!"

	L.wild_magic_casting = "Дикая Магия (Замедление заклинаний)"
	L.wild_magic_casting_desc = "Предупреждать когда ваши целители получают Эффект Замедления от  Дикой Магии."
	L.wild_magic_casting_you = "Дикая Магия - Ваши заклинания замедленны!"
	L.wild_magic_casting_other = "Дикая Магия - %s замедляет чтение заклинаний!"

	L.wild_magic_hit = "Дикая Магия (Понижен шанс попадания)"
	L.wild_magic_hit_desc = "Предупреждать когда у танка снижается шанс попадания от Дикой Магии."
	L.wild_magic_hit_you = "Дикая Магия - Ваш шанс попадания понижен!"
	L.wild_magic_hit_other = "Дикая Магия - %s начинает промахиваться по цели!"

	L.wild_magic_threat = "Дикая Магия (Увеличенная угроза)"
	L.wild_magic_threat_desc = "Предупреждать когда Ваша угроза повышается от Дикой Магии."
	L.wild_magic_threat_you = "Дикая Магия - Вы создаете повышенную угрозу!"
end

L = BigWigs:NewBossLocale("The Eredar Twins", "ruRU")
if L then
	L.lady = "Сакролаш #3:"
	L.lock = "Алитесса #2:"

	L.threat = "Угроза"

	-- L.custom_on_threat = "Threat InfoBox"
	-- L.custom_on_threat_desc = "Show second on threat for Grand Warlock Alythess and third on threat for Lady Sacrolash."
end

