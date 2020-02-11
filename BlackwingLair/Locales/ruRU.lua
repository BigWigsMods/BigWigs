local L = BigWigs:NewBossLocale("Razorgore the Untamed", "ruRU")
if not L then return end
if L then
	L.start_trigger = "Злоумышленники проломились"
	L.start_message = "Бритвосмерт в бещенстве! Помощники появятся через 45 секунд!"
	L.start_soon = "Помощники через 5 секунд!"
	L.start_mob = "Появляются помощники!"

	L.eggs = "Считать яйца"
	L.eggs_desc = "Пересчитывать уничтоженные яйца."
	L.eggs_message = "%d/30 яиц уничтожено!"

	L.phase2_message = "Все яйца уничтоже, Бритвосметр повержен!"
end

L = BigWigs:NewBossLocale("Chromaggus", "ruRU")
if L then
	L.breath = "Дыхание"
	L.breath_desc = "Сообщать о дыхании."

	--L.debuffs_message = "3/5 debuffs, carefull!"
	--L.debuffs_warning = "4/5 debuffs, %s on 5th!"
end

L = BigWigs:NewBossLocale("Nefarian ", "ruRU")
if L then
	L.landing_soon_trigger = "Отличная работа мои миньёны!"
	L.landing_trigger = "СЖЕЧЬ! Вы обречены!"
	L.zerg_trigger = "Невозможно!"

	L.triggershamans = "Шаманы! Покажитесь мне!"
	L.triggerwarlock = "Варлоки, вы должны играть!"
	L.triggerhunter = "Охотники и ваше раздражение"
	L.triggermage = "Маги так же%?"
	L.triggerdeathknight = "Рыцари смерти! Сюда!"
	--L.triggermonk = "Monks"

	L.landing_soon_warning = "Нефариан приземлится через 10 секунд!"
	L.landing_warning = "Нефариан ПРИЗЕМЛЯЕТСЯ!"
	L.zerg_warning = "НАЧИНАЕТСЯ ЗЕРГ!"
	L.classcall_warning = "Начинается классовый вызов!"

	L.warnshaman = "Шаманы - ставьте тотемы!"
	L.warndruid = "Друиды - пробудите в себе зверя!"
	L.warnwarlock = "Чернокнижники - вызывайте инферналов!"
	L.warnpriest = "Жрецы - исцеляйте повреждения!"
	L.warnhunter = "Охотники - доставайте свои луки!"
	L.warnwarrior = "Войны - становитесь в атакующие стойки!"
	L.warnrogue = "Разбойники - точите свои клинки!"
	L.warnpaladin = "Паладины - улучшайте защиту!"
	L.warnmage = "Маги - используйте превращение!"
	--L.warnmonk = "Monks - Stuck Rolling"
	--L.warndemonhunter = "Demon Hunters - Blinded"

	L.classcall_bar = "Классовый вызов"

	L.classcall = "Классовый вызов"
	L.classcall_desc = "Предупреждать о классовом вызове."

	L.otherwarn = "Приземление и зерг"
	L.otherwarn_desc = "Предупреждать об опасности приземления и зерга."
end

