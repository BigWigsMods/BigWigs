
local L = BigWigs:NewBossLocale("Protector of the Endless", "ruRU")
if not L then return end
if L then

end

L = BigWigs:NewBossLocale("Tsulong", "ruRU")
if L then
	L.phases = "Фазы"
	L.phases_desc = "Предупреждать о смене фаз."
	L.disable_trigger = "Спасибо вам, незнакомцы. Я свободен."
end

L = BigWigs:NewBossLocale("Lei Shi", "ruRU")
if L then
	L.engage_trigger = "Ч-что вы здесь делаете?! П-п-прочь!"
	L.win_trigger = "I...ah...oh! Did I...? Was I...? It was so cloudy."

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

