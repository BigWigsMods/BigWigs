if not GetNumGroupMembers then return end
local L = BigWigs:NewBossLocale("Protector of the Endless", "ruRU")
if not L then return end
if L then

end

L = BigWigs:NewBossLocale("Tsulong", "ruRU")
if L then
	L.phases = "Фазы"
	L.phases_desc = "Предупреждать о смене фаз."
end

L = BigWigs:NewBossLocale("Lei Shi", "ruRU")
if L then
	L.engage_trigger = "Wh-what are you doing here?! G-go away!"	-- Needs review
	L.hp_to_go = "%d%% to go"	-- Needs review
	L.end_hide = "Спрятаться"

	L.special = "След. спец. способность"
	L.special_desc = "Предупредать о следующей особой способности"
end

L = BigWigs:NewBossLocale("Sha of Fear", "ruRU")
if L then
	L.fading_soon = "%s fading soon"	-- Needs review

	L.swing = "Замах"
	L.swing_desc = "Считает количество замахов перед Взбучкой."
end