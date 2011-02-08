local L = BigWigs:NewBossLocale("Al'Akir", "ruRU")
if not L then return end
if L then
	L.stormling = "Помощники"
	L.stormling_desc = "Призыв помощников."
	L.stormling_message = "Прибытие помощника!"
	L.stormling_bar = "След. помощники"
	L.stormling_yell = "Буря! Приди мне на помощь!"

	L.phase3_yell = "Довольно! Меня ничто не в силах сдерживать!"

	L.phase = "Смена фаз"
	L.phase_desc = "Сообщать о смене фаз."

	L.cloud_message = "Грозовые облака!"
	L.feedback_message = "%dx Ответная реакция"
end

L = BigWigs:NewBossLocale("Conclave of Wind", "ruRU")
if L then
	L.gather_strength = "%s близок к обритению обсолютной силы!"

	L.storm_shield = "Щит бури"
	L.storm_shield_desc = "Щит поглощения урона"

	L.full_power = "Полная сила"
	L.full_power_desc = "Сообщает когда босс достигает полной силы и начинает применять специальные способности."
	L.gather_strength_emote = "%s начинает вбирать силу оставшихся владык ветра!"

	L.wind_chill = "На ВАС %sx стаков Холодного ветра!"
end

