local L = BigWigs:NewBossLocale("Al'Akir", "ruRU")
if L then
	L.windburst = (GetSpellInfo(87770))
	
	L.phase3_yell = "Довольно! Меня ничто не в силах сдерживать!"

	L.phase_change = "Смена фаз"
	L.phase_change_desc = "Сообщать о смене фаз."
	L.phase_message = "Фаза %d"

	L.feedback_message = "%dx Ответная реакция"

	L.you = "%s на ВАС!"
end

local L = BigWigs:NewBossLocale("Conclave of Wind", "ruRU")
if L then
	L.gather_strength = "%s близок к обритению обсолютной силы!"

	L.storm_shield = GetSpellInfo(95865)
	L.storm_shield_desc = "Щит поглощения урона"

	L.full_power = "Полная сила"
	L.full_power_desc = "Сообщает когда босс достигает полной силы и начинает применять специальные способности."
	L.gather_strength_emote = "%s начинает вбирать силу оставшихся владык ветра!"

	L.wind_chill = "На ВАС %s стаков Холодного ветра"
end
