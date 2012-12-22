
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
	L.end_hide = "Прятки закончились"

	L.special = "Cпец. способность"
	L.special_desc = "Предупредать о следующей особой способности."
end

L = BigWigs:NewBossLocale("Sha of Fear", "ruRU")
if L then
	L.fading_soon = "%s скоро спадет"

	L.swing = "Замах"
	L.swing_desc = "Считает количество замахов перед Взбучкой."

	L.throw = "Throw!"
	L.ball_dropped = "Ball dropped!"
	L.ball_you = "You have the ball!"
	L.ball = "Ball"

	L.cooldown_reset = "Ваши перезарядки сброшены!"

	L.ability_cd = "Перезарядка способности"
	L.ability_cd_desc = "Попытка угадать, в каком порядке способности будут использоваться после Появления."

	L.huddle_or_spout = "Оцепенение или Изводень"
	L.huddle_or_strike = "Оцепенение или Удар"
	L.strike_or_spout = "Удар или Изводень"
	L.huddle_or_spout_or_strike =  "Оцепенение или Изводень или Удар"
end

