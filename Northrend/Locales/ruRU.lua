local L = LibStub("AceLocale-3.0"):NewLocale("BigWigsArchavon the Stone Watcher", "ruRU")
if L then
	L.stomp_message = "Топот - близится Рывок!"
	L.stomp_warning = "Топот через ~5сек!"
	L.stomp_bar = "~Перезарядка топота"

	L.cloud_message = "ВЫ в Удушающем облаке!"

	L.charge = "Рывок"
	L.charge_desc = "Предупреждать о Рывках."

	L.icon = "Отмечать иконкой"
	L.icon_desc = "Отмечать рейдовой иконой игрока, на которого нацелены каменные осколки. (необходимо быть лидером группы или рейда)"
end


L = LibStub("AceLocale-3.0"):NewLocale("BigWigsEmalon the Storm Watcher", "ruRU")
if L then
	L.nova_next = "~Перезарядка Вспышки молнии"

	L.overcharge_message = "Служитель бури перегружен!"
	L.overcharge_bar = "Взрыв Служителя бури"
	L.overcharge_next = "~Следующая Перегрузка"

	L.icon = "Иконка Перегрузки"
	L.icon_desc = "Отмечать черепом Служителя бури с эффектом Перегрузки."
end


L = LibStub("AceLocale-3.0"):NewLocale("BigWigsMalygos", "ruRU")
if L then
	L.sparks = "Искра мощи"
	L.sparks_desc = "Предупреждать о появлениях Искры мощи."
	L.sparks_message = "Появилась Искра мощи!"
	L.sparks_warning = "Искра мощи через ~5сек!"

	L.sparkbuff_message = "Малигос получил Яркую искру!"

	L.vortex = "Воронка"
	L.vortex_desc = "Предупреждать о воронках и отображать полосу."
	L.vortex_message = "Воронка!"
	L.vortex_warning = "Воронка через ~5сек!"
	L.vortex_next = "Перезарядка воронки"

	L.breath = "Глубокое дыхание"
	L.breath_desc = "Оповещать кокда Малигос использует Deep Breath во 2ой фазе."
	L.breath_message = "Глубокое дыхание!"
	L.breath_warning = "Глубокое дыхание через ~5сек!"

	L.surge = "Прилив мощи"
	L.surge_desc = "Предупреждать кто получает Прилив мощи."
	L.surge_you = "На ВАС Прилив мощи!"
	L.surge_trigger = "%s уставился на вас!"

	L.phase = "Фазы"
	L.phase_desc = "Предупреждать о смене фаз."
	L.phase2_warning = "Скоро 2 фаза!"
	L.phase2_trigger = "Я рассчитывал быстро покончить с вами, однако вы оказались более… более стойкими, чем я рассчитывал"
	L.phase2_message = "2 Фаза - Повелители нексуса и Потомоки вечности!"
	L.phase2_end_trigger = "ХВАТИТ! Если ты намерен вернуть себе магию Азерота, ты ее получишь!"
	L.phase3_warning = "Скоро 3 фаза!"
	L.phase3_trigger = "А-а, вот и твои благодетели!"
	L.phase3_message = "3 Фаза!"
end

L = LibStub("AceLocale-3.0"):NewLocale("BigWigsSartharion", "ruRU")
if L then
	L.tsunami = "Огненное цунами"
	L.tsunami_desc = "Предупреждать о взбалтывании лавы и отображать полосу."
	L.tsunami_warning = "Огненное цунами через ~5сек!"
	L.tsunami_message = "Огненное цунами!"
	L.tsunami_cooldown = "Перезарядка цунами"
	L.tsunami_trigger = "Лава вокруг |3-1(%s) начинает бурлить!"

	L.breath_cooldown = "Перезарядка дыхания"

	L.drakes = "Драконы"
	L.drakes_desc = "Предупреждать когда драконы вступят в бой."
	L.drakes_incomingsoon = "%s прилетит через ~5сек!"

	L.twilight = "События в Зоне сумерек"
	L.twilight_desc = "Сообщать что происходит с Сумеречным порталом."
	L.twilight_trigger_tenebron = "Тенеброн начинает высиживать кладку в Зоне сумерек!"
	L.twilight_trigger_vesperon = "В Сумраке появляется ученик Весперона!"
	L.twilight_trigger_shadron = "Ученик Шадрона появляется в Зоне сумерек!"
	L.twilight_message_tenebron = "Вылупление яиц"
	L.twilight_message = "Появился Ученик |3-1(%s)!"
end
