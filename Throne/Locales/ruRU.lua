local L = BigWigs:NewBossLocale("Al'Akir", "ruRU")
if not L then return end
if L then
	L.stormling = "Буревики"
	L.stormling_desc = "Призыв Буревиков."
	L.stormling_message = "Призыв Буревика!"
	L.stormling_bar = "Буревик"
	L.stormling_yell = "Буря! Приди мне на помощь!"

	L.acid_rain = "Кислотный дождь (%d)"

	L.phase3_yell = "Довольно! Меня ничто не в силах сдерживать!"

	L.phase = "Смена фаз"
	L.phase_desc = "Сообщать о смене фаз."

	L.cloud_message = "Грозовые облака!"
	L.feedback_message = "%dx Ответная реакция"
end

L = BigWigs:NewBossLocale("Conclave of Wind", "ruRU")
if L then
	L.gather_strength = "%s Набирает Силу!"

	L.storm_shield = "Щит бури"
	L.storm_shield_desc = "Щит поглощает урон"

	L.full_power = "Полная сила"
	L.full_power_desc = "Сообщает когда босс достигает полной силы и начинает применять специальные способности."
	L.gather_strength_emote = "%s начинает вбирать силу оставшихся владык ветра!"

	L.wind_chill = "%sx Холодный ветер на ВАС!"
end

