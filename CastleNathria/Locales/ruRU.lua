local L = BigWigs:NewBossLocale("Shriekwing", "ruRU")
if not L then return end
if L then
	L.pickup_lantern = "%s поднял фонарь!"
	L.dropped_lantern = "Фонарь брошен: %s!"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "ruRU")
if L then
	L.killed = "%s убит"
end

L = BigWigs:NewBossLocale("Hungering Destroyer", "ruRU")
if L then
	L.miasma = "Миазмы" -- Short for Gluttonous Miasma
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "ruRU")
if L then
	L.stage2_yell = "Что же делает эта штука? Любопытно до смерти. Правда, умрете, скорее всего, вы." -- "The anticipation to use this relic is killing me! Though, it will more likely kill you."
	L.stage3_yell = "Надеюсь, эта вещица не только выглядит опасной!" -- "I hope this wondrous item is as lethal as it looks!"
	L.tear = "Разрыв" -- Short for Dimensional Tear
	L.spirits = "Духи" -- Short for Fleeting Spirits
	L.seeds = "Семена" -- Short for Seeds of Extinction
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "ruRU")
if L then
	-- L.times = "%dx %s"

	L.level = "%s (Уровень |cffffff00%d|r)"
	L.full = "%s (|cffff0000ПОЛНЫЙ|r)"

	L.anima_adds = "Адды Концентрированной Анимы"
	L.anima_adds_desc = "Показ таймера появления аддов от дебафа Концентрированной Анимы."

	L.custom_off_experimental = "Включение экспериментальных функций"
	L.custom_off_experimental_desc = "Эти функции |cffff0000не были протестированы|r и могут создать |cffff0000спам|r."

	L.anima_tracking = "Отслеживание анимы |cffff0000(Экспериментально)|r"
	L.anima_tracking_desc = "Сообщения и полосы для слежения за уровнями анимы в контейнерах.|n|cffaaff00Подсказка: Вы, возможно, захотите отключить информацию в инфобоксах или полосах, в зависимости от ваших предпочтений."

	L.custom_on_stop_timers = "Всегда показывать полосы способностей"
	L.custom_on_stop_timers_desc = "Пока доступно только для тестирования"

	L.desires = "Желания"
	L.bottles = "Колбы"
	L.sins = "Грехи"
end

L = BigWigs:NewBossLocale("The Council of Blood", "ruRU")
if L then
	L.macabre_start_emote = "Занимайте свои места и приготовьтесь к пляске смерти!" -- [RAID_BOSS_EMOTE] Take your places for the Danse Macabre!#Dance Controller#4#false"
	L.custom_on_repeating_dark_recital = "Повторение Тёмного бала"
	L.custom_on_repeating_dark_recital_desc = "Спам сообщений в /сказать с метками {rt1}, {rt2} чтобы найти своего партнёра для танца во время Тёмного бала."

	L.custom_off_select_boss_order = "Маркировка порядка убийства боссов"
	L.custom_off_select_boss_order_desc = "Устанавливать метку крест {rt7} в соответствии с порядком убийства боссов. Требуется быть помощником или лидером рейда."
	L.custom_off_select_boss_order_value1 = "Никлаус -> Фрида -> Ставрос"
	L.custom_off_select_boss_order_value2 = "Фрида -> Никлаус -> Ставрос"
	L.custom_off_select_boss_order_value3 = "Ставрос -> Никлаус -> Фрида"
	L.custom_off_select_boss_order_value4 = "Никлаус -> Ставрос -> Фрида"
	L.custom_off_select_boss_order_value5 = "Фрида -> Ставрос -> Никлаус"
	L.custom_off_select_boss_order_value6 = "Ставрос -> Фрида -> Никлаус"

	L.dance_assist = "Помощник танцев"
	L.dance_assist_desc = "Показ предупреждений о направлении во время фазы танцев."
	L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t Двигайся вперед |T450907:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t Двигайся направо |T450908:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t Двигайся вниз |T450905:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t Двигайся влево |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "вперед" -- "Жете вперед!" -- Prance Forward!
	L.dance_yell_right = "вправо" -- "Па вправо!" -- Shimmy right!
	L.dance_yell_down = "назад" -- "Бризе назад!" -- Boogie down!
	L.dance_yell_left = "влево" -- "Шажок влево!" -- Sashay left!
end

L = BigWigs:NewBossLocale("Sludgefist", "ruRU")
if L then
	L.stomp_shift = "Топот + Сдвиг" -- Destructive Stomp + Seismic Shift

	L.fun_info = "Информация об уроне"
	L.fun_info_desc = "Показ сообщения о том сколько босс потерял здоровья за фазу Разрушительного удара."

	L.health_lost = "Грязешмяк потерял %.1f%% здоровья!"
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "ruRU")
if L then
	L.first_blade = "Первое лезвие"
	L.second_blade = "Второе лезвие"

	L.skirmishers = "Войска" -- Short for Stone Legion Skirmishers

	L.custom_on_stop_timers = "Всегда показывать полосы способностей"
	L.custom_on_stop_timers_desc = "Пока доступно только для тестирования"
end

L = BigWigs:NewBossLocale("Sire Denathrius", "ruRU")
if L then
	--L.add_spawn = "Crimson Cabalists answer the call of Denathrius." -- [RAID_BOSS_EMOTE] Crimson Cabalists answer the call of Denathrius.#Sire Denathrius#4#true"

	L.infobox_stacks = "%d |4Стак:Стака:Стаков;: %d |4игрок:игрока:игроков;" -- 4 Stacks: 5 players // 1 Stack: 1 player

	L.custom_on_repeating_nighthunter = "Повторение крика о Ночном охотнике"
	L.custom_on_repeating_nighthunter_desc = "Спам крика о способности Ночной охотник иконками {rt1}, {rt2} или {rt3} для облегчения поиска линии, которую вы должны перекрывать."

	L.custom_on_repeating_impale = "Повторение чата о Пригвождении"
	L.custom_on_repeating_impale_desc = "Спам сообщений '1', '22', '333' или '4444' в /сказать о способности Пригвождение чтобы показать порядок, в котором игроки получат урон."

	L.hymn_stacks = "Гимн Нафрии"
	L.hymn_stacks_desc = "Оповещать о количестве стаков гимна Нафрии на вас."

	-- L.ravage_target = "Reflection: Ravage Target Cast Bar"
	-- L.ravage_target_desc = "Cast bar showing the time until the reflection targets a location for Ravage."
	-- L.ravage_targeted = "Ravage Targeted" -- Text on the bar for when Ravage picks its location to target in stage 3

	L.no_mirror = "Без зеркала: %d" -- Player amount that does not have the Through the Mirror
	L.mirror = "С зеркалом: %d" -- Player amount that does have the Through the Mirror
end
