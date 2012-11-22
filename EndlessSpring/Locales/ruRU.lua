
local L = BigWigs:NewBossLocale("Protector of the Endless", "ruRU")
if not L then return end
if L then

end

L = BigWigs:NewBossLocale("Tsulong", "ruRU")
if L then
	L.win_trigger = "Спасибо вам, незнакомцы. Я свободен."

	L.phases = "Фазы"
	L.phases_desc = "Предупреждать о смене фаз."
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

	L.damage = "Урон"
	L.miss = "Промах"
end

