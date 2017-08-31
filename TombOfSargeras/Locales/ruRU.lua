local L = BigWigs:NewBossLocale("Harjatan the Bludger", "ruRU")
if not L then return end
if L then
	L.custom_on_fixate_plates = "Иконка фиксации на вражеских неймплейтах"
	L.custom_on_fixate_plates_desc = "Показывать иконку цели, которая на вас навелась.\nТребуется чтобы вражеские неймплейты были включены. Эта функция пока поддерживается только аддоном KuiNameplates."
end

L = BigWigs:NewBossLocale("Demonic Inquisition", "ruRU")
if L then
	L.custom_on_fixate_plates = "Иконка фиксации на вражеских неймплейтах"
	L.custom_on_fixate_plates_desc = "Показывать иконку цели, которая на вас навелась.\nТребуется чтобы вражеские неймплейты были включены. Эта функция пока поддерживается только аддоном KuiNameplates."

	L.infobox_title_prisoners = "%d |4Заключенный:Заключенные;"

	L.custom_on_stop_timers = "Всегда показывать полосы для способностей"
	L.custom_on_stop_timers_desc = "Демоническая инквизиция имеет некоторые способности, которые задерживаются прерываниями/другими заклинаниями. Когда эта опция включена, полосы для этих способностей останутся на вашем экране."
end

L = BigWigs:NewBossLocale("Mistress Sassz'ine", "ruRU")
if L then
	L.inks_fed_count = "Чернила (%d/%d)"
	L.inks_fed = "Чернил скормлено: %s" -- %s = List of players
end

L = BigWigs:NewBossLocale("The Desolate Host", "ruRU")
if L then
	L.infobox_players = "Игроки"
	L.armor_remaining = "%s осталось (%d)" -- Bonecage Armor Remaining (#)
	L.custom_on_mythic_armor = "Игнорировать Костяную Броню на Оживленных храмовниках на Эпохальной сложности"
	L.custom_on_mythic_armor_desc = "Оставьте эту опцию включенной, если вы оффтанчите Оживленных храмовников, чтобы игнорировать предупреждения о Костяной броне на Оживленных храмовниках"
	L.custom_on_armor_plates = "Иконка Костяной брони над индикатором здоровья"
	L.custom_on_armor_plates_desc = "Отобразить иконку над индикатором здоровья Оживленного храмовника с Костяной броней.\nТребуется использования Индикатора Здоровья. На данный момент поддерживается только аддоном KuiNameplates"
	L.tormentingCriesSay = "Стон" -- Tormenting Cries (short say)
end

L = BigWigs:NewBossLocale("Maiden of Vigilance", "ruRU")
if L then
	L.infusionChanged = "Насыщение ИЗМЕНИЛОСЬ: %s"
	L.sameInfusion = "Насыщение: %s"
	L.fel = "Скверна"
	L.light = "Свет"
	L.felHammer = "Молот Скверны" -- Better name for "Hammer of Obliteration"
	L.lightHammer = "Молот Света" -- Better name for "Hammer of Creation"
	L.absorb = "Поглощение"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "Заклинание"
	L.cast_text = "%.1fs (|cff%s%.0f%%|r)" -- s = seconds
	L.stacks = "Стаки"
end

L = BigWigs:NewBossLocale("Fallen Avatar", "ruRU")
if L then
	L.touch_impact = "Взрыв касания" -- Touch of Sargeras Impact (short)

	L.custom_on_stop_timers = "Всегда показывать полосы для способностей"
	L.custom_on_stop_timers_desc = "Аватара Падшего использует свои способности случайным образом. Когда эта опция включена, полосы для этих способностей останутся на вашем экране."

	L.energy_leak = "Утечка энергии"
	L.energy_leak_desc = "Отобразить предупреждение, когда энергия попала в босса на 1-й фазе"
	L.energy_leak_msg = "Утечка Энергии! (%d)"

	L.warmup_trigger = "Когда-то эта оболочка" -- Когда-то эта оболочка была наполнена мощью самого Саргераса. Но нашей главной целью всегда был храм – с его помощью мы испепелим ваш мир!

	L.absorb = "Поглощение"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "Заклинание"
	L.cast_text = "%.1fs (|cff%s%.0f%%|r)" -- s = seconds
end

L = BigWigs:NewBossLocale("Kil'jaeden", "ruRU")
if L then
	L.singularityImpact = "Взрыв сингулярности"
	L.obeliskExplosion = "Взрыв обелисков"
	L.obeliskExplosion_desc = "Таймер Взрыва Обелисков"

	L.darkness = "Тьма" -- Shorter name for Darkness of a Thousand Souls (238999)
	L.reflectionErupting = "Отражение: взрывное" -- Shorter name for Shadow Reflection: Erupting (236710)
	L.reflectionWailing = "Отражение: жалобное" -- Shorter name for Shadow Reflection: Wailing (236378)
	L.reflectionHopeless = "Отражение: обречённое" -- Shorter name for Shadow Reflection: Hopeless (237590)

	L.rupturingKnock = "Разрывающая Сингулярность Откидывание"
	L.rupturingKnock_desc = "Отображать таймер для откидывания"

	L.meteorImpact_desc = "Отображать таймер падения Метеора"

	L.shadowsoul = "Отслеживание здоровья Темных душ"
	L.shadowsoul_desc = "Отображать инфоблок с текущим здовьем пяти Темных душ."

	L.custom_on_track_illidan = "Автоматически отслеживать гуманоидов"
	L.custom_on_track_illidan_desc = "Если вы охотник или ферал други, эта опция автоматически включит отслеживание гуманоидов для поиска Иллидана."

	L.custom_on_zoom_in = "Автоматический масштаб миникарты"
	L.custom_on_zoom_in_desc = "Эта опция установит масштаб миникарты на уровень 4 для более простого отслеживания Иллидана и вернёт на прежнее значение после окончания фазы."
end

L = BigWigs:NewBossLocale("Tomb of Sargeras Trash", "ruRU")
if L then
	L.rune = "Орочья руна"
	L.chaosbringer = "Инфернал - вестник хаоса"
	L.rez = "Смотритель гробницы Рез"
	L.erduval = "Эрду'вал"
	L.varah = "Повелительница гиппогрифов Вара"
	L.seacaller = "Зовущая море из клана Волнистой Чешуи"
	L.custodian = "Подводный надзиратель"
	L.dresanoth = "Кресанот"
	L.stalker = "Жуткий Охотник"
	L.darjah = "Полководец Даржа"
	L.sentry = "Страж Хранительницы"
	L.acolyte = "Призрачная послушница"
	L.ryul = "Рюл Поблекший"
	L.countermeasure = "Защитные контрмеры"
end
