local L = BigWigs:NewBossLocale("Argus the Unmaker", "ruRU")
if not L then return end
if L then
	L.combinedBurstAndBomb = "Одновременные Бомба души и Взрывная душа"
	L.combinedBurstAndBomb_desc = "|cff71d5ffБомбы души|r всегда накладываются одновременно с |cff71d5ffВзрывными душами|r. Включите эту опцию, чтобы объединить два сообщения в одно."

	L.custom_off_always_show_combined = "Всегда отображать объединенное сообщение о Взрывной душе и Бомбе души"
	L.custom_off_always_show_combined_desc = "Объединенное сообщение не будет отображено, если на Вас накладывается |cff71d5ffБомба души|r or the |cff71d5ffВзрывная душа|r. Включите данную опцию, если вы хотите всегда видеть объединённое сообщение. |cff33ff99Полезно для лидера рейда.|r"

	L.fear_help = "Страх перед Саргерасом Комбинация"
	L.fear_help_desc = "Сказать специальное сообщение, если на вас |cff71d5ffСтрах перед Саргерасом|r и |cff71d5ffИзнуряющая чума|r/|cff71d5ffВзрывная душа|r/|cff71d5ffБомба души|r/|cff71d5ffПриговор Саргераса|r."

	L[257931] = "Страх" -- short for Sargeras' Fear
	L[248396] = "Чума" -- short for Soulblight
	L[251570] = "Бомба" -- short for Soulbomb
	L[250669] = "Взрыв" -- short for Soulburst
	L[257966] = "Приговор" -- short for Sentence of Sargeras

	L.stage2_early = "Ярость морей смоет эту скверну!"  -- Aman'thul's accurate quote
	L.stage3_early = "Надежды нет. Есть только боль!" -- Argus' accurate quote 

	L.gifts = "ДарыGifts: %s (Небо), %s (Море)"
	L.burst = "|T1778229:15:15:0:0:64:64:4:60:4:60|tВзрыв:%s" -- short for Soulburst
	L.bomb = "|T1778228:15:15:0:0:64:64:4:60:4:60|tБомба (%d):|T137002:0|t%s - " -- short for Soulbomb

	L.sky_say = "{rt5} Крит/Маст" -- short for Critical Strike/Mastery (stats)
	L.sea_say = "{rt6} Хаст/Верса" -- short for Haste/Versatility (stats)

	L.bomb_explosions = "Взрывы бомб"
	L.bomb_explosions_desc = "Отобразить таймер взрыва Взрывной души и Бомбы души."
end

L = BigWigs:NewBossLocale("Aggramar", "ruRU")
if L then
	L.wave_cleared = "Волна %d Зачищена!" -- Wave 1 Cleared!

	L.track_ember = "Трекер Угольков Тайшалака"
	L.track_ember_desc = "Отображать сообщения о смерти каждого Уголька Тайшалака."

	L.custom_off_ember_marker_desc = "Отмечать Уголек Тайшалака метками {rt1}{rt2}{rt3}{rt4}{rt5}, требуется помощник рейда или лидер.\n|cff33ff99Эпохальный: Отмечает только аддов текущей волны и выше 45 энергии.|r"
end

L = BigWigs:NewBossLocale("The Coven of Shivarra", "ruRU")
if L then
	L.torment_of_the_titans_desc = "Шиварра заставляет души титанов использовать их способности против игроков."

	L.timeLeft = "%.1fс" -- s = seconds
	L.torment = "Мучение: %s"
	L.nextTorment = "Следуещее Мучение: |cffffffff%s|r"
	L.tormentHeal = "Хил/Дот" -- something like Heal/DoT (max 10 characters)
	L.tormentLightning = "Молнии" -- short for "Chain Lightning" (or similar, max 10 characters)
	L.tormentArmy = "Армия" -- short for "Spectral Army of Norgannon" (or similar, max 10 characters)
	L.tormentFlames = "Огонь" -- short for "Flames of Khaz'goroth" (or similar, max 10 characters)
end

L = BigWigs:NewBossLocale("Eonar the Life-Binder", "ruRU")
if L then
	L.warp_in_desc = "Отображает таймеры и сообщения для каждой волны, вместе с каждым специальным аддом в волне."

	L.top_lane = "Верх"
	L.mid_lane = "Центр"
	L.bot_lane = "Низ"

	L.purifier = "Очиститель" -- Fel-Powered Purifier
	L.destructor = "Разрушитель" -- Fel-Infused Destructor
	L.obfuscator = "Маскировщик" -- Fel-Charged Obfuscator
	L.bats = "Сквернотопыри"
end

L = BigWigs:NewBossLocale("Portal Keeper Hasabel", "ruRU")
if L then
	L.custom_on_stop_timers = "Всегда отображать таймеры способностей"
	L.custom_on_stop_timers_desc = "Азабель использует случайную восстановившуюся способность. Когда данная опция включена, полосы возможных способностей будут оставаться на экране."
	L.custom_on_filter_platforms = "Фильтр сообщений и полос боковых платформ"
	L.custom_on_filter_platforms_desc = "Убирает лишние сообщения и полосы, если Вы не на боковой платформе. Но всегда будет отображать сообщения и полосы основной Платформы: Нексус."
	L.worldExplosion_desc = "Отображать таймер до взрыва Гибнущего мира."
	L.platform_active = "%s Активна!" -- Platform: Xoroth Active!
	L.add_killed = "%s убит!"
	L.achiev = "Дебаффы для достижения 'Война порталов'" -- Achievement 11928
end

L = BigWigs:NewBossLocale("Kin'garoth", "ruRU")
if L then
	--L.empowered = "(E) %s" -- (E) Ruiner
	--L.gains = "Kin'garoth gains %s" -- Kin'garoth gains Empowered Ruiner
end

L = BigWigs:NewBossLocale("Antoran High Command", "ruRU")
if L then
	L.felshieldActivated = "%s активировал Щит Скверны"
	L.felshieldUp = "Щит Скверны доступен"
end

L = BigWigs:NewBossLocale("Gorothi Worldbreaker", "ruRU")
if L then
	--L.cannon_ability_desc = "Display Messages and Bars related to the 2 cannons on the Gorothi Worldbreaker's back."

	L.missileImpact = "Аннигиляция Столкновение"
	L.missileImpact_desc = "Отобразить таймер до приземления снарядов Аннигиляции."

	L.decimationImpact = "Децимация Столкновение"
	L.decimationImpact_desc = "Отобразить таймер до приземления старядом Децимации."
end

L = BigWigs:NewBossLocale("Antorus Trash", "ruRU")
if L then
	-- [[ Before Garothi Worldbreaker ]] --
	L.felguard = "Страж Скверны из Анторуса"

	-- [[ After Garothi Worldbreaker ]] --
	L.flameweaver = "Заклинатель пламени"

	-- [[ Before Antoran High Command ]] --
	L.ravager = "Присягнувший клинку опустошитель"
	L.deconix = "Император Деконикс"
	L.clobex = "Клобекc"

	-- [[ Before Portal Keeper Hasabel ]] --
	L.stalker = "Изголодавшийся ловец"

	-- [[ Before Varimathras / Coven of Shivarra ]] --
	L.tarneth = "Тарнет"
	L.priestess = "Жрица делирия"

	-- [[ Before Aggramar ]] --
	L.aedis = "Темный хранитель Эйдис"
end
