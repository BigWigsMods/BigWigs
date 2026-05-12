local L = BigWigs:NewBossLocale("Vorasius", "ruRU")
if not L then return end
if L then
	L.shadowclaw_slam = "Удары"
end

L = BigWigs:NewBossLocale("Fallen-King Salhadaar", "ruRU")
if L then
	L.fractured_projection = "Прерывания"
end

L = BigWigs:NewBossLocale("Vaelgor & Ezzorak", "ruRU")
if L then
	L.grappling_maw = "Захват танка"
end

L = BigWigs:NewBossLocale("Lightblinded Vanguard", "ruRU")
if L then
	L.aura_of_wrath = "Гнев" -- Short for Aura of Wrath
	L.execution_sentence = "Приговоры" -- Short for Execution Sentence
	L.executes_mythic = "Приговоры + уклонение"
	L.judgement_red = "Правосудие [К]" -- R for the Red icon.
	L.aura_of_devotion = "Благочестие" -- Short for Aura of Devotion
	L.judgement_blue = "Правосудие [С]" -- B for the Blue icon.
	L.aura_of_peace = "Мир" -- Short for Aura of Peace
	L.tyrs_wrath_mythic = "Поглощения + приговоры"
	L.divine_toll_mythic = "Уклонение + поглощения"
	L.zealous_spirit = "Дух" -- Short for Zealous Spirit

	L.empowered_searing_radiance = "Усиленное обжигающее сияние"
	L.empowered_searing_radiance_desc = "Показывать таймер усиленного обжигающего сияния"

	L.empowered_avengers_shield = "Усиленный щит мстителя"
	L.empowered_avengers_shield_desc = "Показывать таймер усиленного щита мстителя"

	L.empowered_divine_storm = "Усиленная божественная буря"
	L.empowered_divine_storm_desc = "Показывать таймер усиленной божественной бури"
	L.tornadoes = "Шторм" -- The renamed empowered Divine Storm

	L.empowered = "[У] %s" -- Empowered version of an ability, [E] Avengers Shield
end

L = BigWigs:NewBossLocale("Crown of the Cosmos", "ruRU")
if L then
	L.silverstrike_arrow = "Стрелы"
	L.grasp_of_emptiness = "Обелиски"
	L.interrupting_tremor = "Прерывание"
	L.ravenous_abyss = "Выбежать"
	L.silverstrike_barrage = "Линии"
	L.cosmic_barrier = "Барьер"
	L.rangers_captains_mark = "Стрелы"
	L.voidstalker_sting = "Жала"
	L.aspect_of_the_end = "Связи"
	L.devouring_cosmos = "След. платформа"
end
