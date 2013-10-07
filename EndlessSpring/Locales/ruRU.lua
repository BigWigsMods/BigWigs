
local L = BigWigs:NewBossLocale("Protectors of the Endless", "ruRU")
if not L then return end
if L then
	L.under = "%s под %s!"
	L.heal = "%s исцеление"
end

L = BigWigs:NewBossLocale("Tsulong", "ruRU")
if L then
	L.engage_yell = "Здесь вам не место! Нужно защитить священные воды... Я прогоню вас или убью вас!"
	L.kill_yell = "Спасибо вам, незнакомцы. Я свободен."

	L.phases = "Фазы"
	L.phases_desc = "Предупреждать о смене фаз."

	L.sunbeam_spawn = "Новый луч солнца!"
end

L = BigWigs:NewBossLocale("Lei Shi", "ruRU")
if L then
	L.hp_to_go = "%d%% осталось"

	L.special = "Cпец. способность"
	L.special_desc = "Предупреждать о следующей особой способности."

	L.custom_off_addmarker = "Маркировка Защитников"
	L.custom_off_addmarker_desc = "Помечать рейдовыми метками защитников, пока Лей Ши защищена, требуется быть помощником или лидером.\n|cFFFF0000Только 1 человек в рейде должен включить эту опцию, чтобы предотвратить конфликты.|r\n|cFFADFF2FСОВЕТ: Если вы выбраны для этой задачи, быстро проведите указателем мыши по защитникам, метки сразу же поставятся.|r"
end

L = BigWigs:NewBossLocale("Sha of Fear", "ruRU")
if L then
	L.fading_soon = "%s скоро спадет"

	L.swing = "Замах"
	L.swing_desc = "Считает количество замахов перед Взбучкой."

	L.throw = "Бросок!"
	L.ball_dropped = "Мяч упал!"
	L.ball_you = "У вас мяч!"
	L.ball = "Мяч"

	L.cooldown_reset = "Ваши перезарядки сброшены!"

	L.ability_cd = "Перезарядка способности"
	L.ability_cd_desc = "Попытка угадать, в каком порядке способности будут использоваться после Появления."

	L.strike_or_spout = "Удар или Изводень"
	L.huddle_or_spout_or_strike = "Оцепенение или Изводень или Удар"

	L.custom_off_huddle = "Маркировка Оцепенения"
	L.custom_off_huddle_desc = "Чтобы помочь лекарям, на людей с Оцепенением будут поставлены метки {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}, требуется быть помощником или лидером."
end

