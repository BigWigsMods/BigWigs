
local L = BigWigs:NewBossLocale("Protector of the Endless", "ruRU")
if not L then return end
if L then
	L.on = "%s на %s!"
	L.under = "%s под %s!"
	L.heal = "%s heal"
end

L = BigWigs:NewBossLocale("Tsulong", "ruRU")
if L then
	L.engage_yell = "Здесь вам не место! Нужно защитить священные воды... Я прогоню вас или убью вас!"

	L.phases = "Фазы"
	L.phases_desc = "Предупреждать о смене фаз."

	L.sunbeam_spawn = "New Sunbeam!"
end

L = BigWigs:NewBossLocale("Lei Shi", "ruRU")
if L then
	L.hp_to_go = "%d%% to go" -- Needs review
	L.end_hide = "Прятки закончились"

	L.special = "След. спец. способность"
	L.special_desc = "Предупредать о следующей особой способности"
end

L = BigWigs:NewBossLocale("Sha of Fear", "ruRU")
if L then
	L.fading_soon = "%s скоро спадет"

	L.swing = "Замах"
	L.swing_desc = "Считает количество замахов перед Взбучкой."
end

