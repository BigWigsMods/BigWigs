local L = BigWigs:NewBossLocale("MOTHER", "ruRU")
if not L then return end
if L then
	L.sideLaser = "(Сбоку) Лучи" -- short for: (location) Uldir Defensive Beam
	L.upLaser = "(Сверху) Лучи"
	L.mythic_beams = "Лучи"
end

L = BigWigs:NewBossLocale("Zek'voz, Herald of N'zoth", "ruRU")
if L then
	L.surging_darkness_eruption = "Извержение (%d)"
	L.mythic_adds = "Эпохальные Адды"
	L.mythic_adds_desc = "Отображать таймеры появления аддов в Эпохальной сложности (Силитиды-воины и Нерубские заклинатели Бездны появляются одновременно)."
end

L = BigWigs:NewBossLocale("Zul", "ruRU")
if L then
	L.crawg_msg = "Крог" -- Short for 'Bloodthirsty Crawg'
	L.crawg_desc = "Предупреждения и таймеры появления Кровожадного Крога."

	L.bloodhexer_msg = "Проклинательница" -- Short for 'Nazmani Bloodhexer'
	L.bloodhexer_desc = "Предупреждения и таймеры появления Назманийской проклинательницы крови."

	L.crusher_msg = "Крушительница" -- Short for 'Nazmani Crusher'
	L.crusher_desc = "Предупреждения и таймеры появления  Назманийской крушительницы."

	L.custom_off_decaying_flesh_marker = "Метки Разлагающейся плоти"
	L.custom_off_decaying_flesh_marker_desc = "Отмечает противников под воздействием Разлагающейся плоти {rt8}, требуется быть лидером или помощником."
end

L = BigWigs:NewBossLocale("Mythrax the Unraveler", "ruRU")
if L then
	L.destroyer_cast = "%s (Н'ракский разрушитель)" -- npc id: 139381
	L.xalzaix_returned = "Залзеикс вернулся!" -- npc id: 138324
	L.add_blast = "Адд Взрыв"
	L.boss_blast = "Босс Взрыв"
end

L = BigWigs:NewBossLocale("G'huun", "ruRU")
if L then
	L.orbs_deposited = "Сферы вставлены (%d/3) - %.1f сек"
	L.orb_spawning = "Появление сфер"
	L.orb_spawning_side = "Появление сфер (%s)"
	L.left = "Слева"
	L.right = "Справа"

	L.custom_on_fixate_plates = "Иконка Преследования на Полосах Здоровья противников"
	L.custom_on_fixate_plates_desc = "Отображать иконку Преследования на Полосе Здоровья противника, что преследует Вас.\nПолосы здоровья должны быть включены. Данная опция поддерживает только KuiNameplates."
end

L = BigWigs:NewBossLocale("Uldir Trash", "ruRU")
if L then
	L.watcher = "Пораженный порчей страж"
	L.ascendant = "Назманийская перерожденная"
	L.dominator = "Назманийская доминаторша"
end
