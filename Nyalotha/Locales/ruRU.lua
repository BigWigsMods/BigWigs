local L = BigWigs:NewBossLocale("Maut", "ruRU")
if not L then return end
if L then
	L.stage2_over = "Фаза 2 закончена - %.1f сек"
end

L = BigWigs:NewBossLocale("Shad'har the Insatiable", "ruRU")
if L then
	L.custom_on_stop_timers = "Всегда показывать полосы способностей"
	L.custom_on_stop_timers_desc = "Шад'хар выбирает случайную откатившуюся способность и использует её следующей. Когда эта опция включена, полосы этих способностей будут оставаться на вашем экране."
end

L = BigWigs:NewBossLocale("Drest'agath", "ruRU")
if L then
	-L.adds_desc = "Предупреждения и сообщения для Ока, Щупальца и Пасти Дест'агат."
	-- L.adds_icon = "achievement_nzothraid_drestagath"

	L.eye_killed = "Око убито!"
	L.tentacle_killed = "Щупальце убито!"
	L.maw_killed = "Пасть убита!"
end

L = BigWigs:NewBossLocale("Il'gynoth, Corruption Reborn", "ruRU")
if L then
	L.custom_on_fixate_plates = "Иконка преследования вас на неймплейте врага"
	L.custom_on_fixate_plates_desc = "Показывает иконку на неймплейте цели, которая вас преследует.\nТребуется включить неймплейты врагов. Эта возможность пока поддерживается только аддоном KuiNameplates."
end

L = BigWigs:NewBossLocale("Vexiona", "ruRU")
if L then
	L.killed = "Убит: %s"
end

L = BigWigs:NewBossLocale("Ra-den the Despoiled", "ruRU")
if L then
	L.essences = "Сущности"
	L.essences_desc = "Ра-ден переодически призывает сущности из других реальностей. Сущности, которые достигают Ра-дена усиляют его энергией своего типа."
end

L = BigWigs:NewBossLocale("Carapace of N'Zoth", "ruRU")
if L then
	L.player_membrane = "Мембрана игрока" -- In stage 3
	L.boss_membrane = "Мембрана босса" -- In stage 3
end

L = BigWigs:NewBossLocale("N'Zoth, the Corruptor", "ruRU")
if L then
	L.realm_switch = "Реальность изменена" -- When you leave the Mind of N'zoth

	L.custom_on_repeating_paranoia_say = "Оповещение /сказать о паранойе"
	L.custom_on_repeating_paranoia_say_desc = "Спам сообщение в канал /сказать, чтобы другие игроки избегали вас во время паранойи на вас."
	-- L.custom_on_repeating_paranoia_say_icon = 315927

	L.gateway_yell = "Тревога: периметр нарушен. Зал Сердца атакован." -- Yelled by MOTHER to trigger mythic only stage
	L.gateway_open = "Врата открыты!"

	L.laser_left = "Лучи (Влево)"
	L.laser_right = "Лучи (Направо)"
end
