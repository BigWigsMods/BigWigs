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

	--L.infobox_title_prisoners = "%d |4Prisoner:Prisoners;"

	L.custom_on_stop_timers = "Всегда показывать полосы для способностей"
	L.custom_on_stop_timers_desc = "Демоническая инквизиция имеет некоторые способности, которые задерживаются прерываниями/другими заклинаниями. Когда эта опция включена, полосы для этих способностей останутся на вашем экране."
end

L = BigWigs:NewBossLocale("Mistress Sassz'ine", "ruRU")
if L then
	--L.inks_fed_count = "Ink (%d/%d)"
	--L.inks_fed = "Inks fed: %s" -- %s = List of players
end

L = BigWigs:NewBossLocale("The Desolate Host", "ruRU")
if L then
	L.infobox_players = "Игроки"
	L.armor_remaining = "%s осталось (%d)" -- Bonecage Armor Remaining (#)
	--L.custom_on_mythic_armor = "Ignore Bonecage Armor on Reanimated Templars in Mythic Difficulty"
	--L.custom_on_mythic_armor_desc = "Leave this option enabled if you are offtanking Reanimated Templars to ignore warnings and counting the Bonecage Armor on the Ranimated Templars"
	--L.custom_on_armor_plates = "Bonecage Armor icon on Enemy Nameplate"
	--L.custom_on_armor_plates_desc = "Show an icon on the nameplate of Reanimated Templars who have Bonecage Armor.\nRequires the use of Enemy Nameplates. This feature is currently only supported by KuiNameplates."
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
	--L.absorb = "Absorb"
	--L.absorb_text = "%s (|cff%s%.0f%%|r)"
	--L.cast = "Cast"
	--L.cast_text = "%.1fs (|cff%s%.0f%%|r)" -- s = seconds
	--L.stacks = "Stacks"
end

L = BigWigs:NewBossLocale("Fallen Avatar", "ruRU")
if L then
	L.touch_impact = "Взрыв касания" -- Touch of Sargeras Impact (short)

	L.custom_on_stop_timers = "Всегда показывать полосы для способностей"
	L.custom_on_stop_timers_desc = "Аватара Падшего использует свои способности случайным образом. Когда эта опция включена, полосы для этих способностей останутся на вашем экране."

	--L.energy_leak = "Energy Leak"
	--L.energy_leak_desc = "Display a warning when energy has leaked onto the boss in stage 1."
	--L.energy_leak_msg = "Energy Leak! (%d)"

	--L.warmup_trigger = "The husk before you" -- The husk before you was once a vessel for the might of Sargeras. But this temple itself is our prize. The means by which we will reduce your world to cinders!

	--L.absorb = "Absorb"
	--L.absorb_text = "%s (|cff%s%.0f%%|r)"
	--L.cast = "Cast"
	--L.cast_text = "%.1fs (|cff%s%.0f%%|r)" -- s = seconds
end

L = BigWigs:NewBossLocale("Kil'jaeden", "ruRU")
if L then
	L.singularityImpact = "Взрыв сингулярности"
	L.obeliskExplosion = "Взрыв обелисков"
	--L.obeliskExplosion_desc = "Timer for the Obelisk Explosion"

	L.darkness = "Тьма" -- Shorter name for Darkness of a Thousand Souls (238999)
	L.reflectionErupting = "Отражение: взрывное" -- Shorter name for Shadow Reflection: Erupting (236710)
	L.reflectionWailing = "Отражение: жалобное" -- Shorter name for Shadow Reflection: Wailing (236378)
	L.reflectionHopeless = "Отражение: обречённое" -- Shorter name for Shadow Reflection: Hopeless (237590)

	--L.rupturingKnock = "Rupturing Singularity Knockback"
	--L.rupturingKnock_desc = "Show a timer for the knockback"

	--L.meteorImpact_desc = "Show a timer for the Meteors landing"

	--L.add = "Add %d"
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
	L.sentry = "Страж Хранительницы"
	L.acolyte = "Призрачная послушница"
	L.ryul = "Рюл Поблекший"
end
