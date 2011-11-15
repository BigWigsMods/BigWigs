
local L = BigWigs:NewBossLocale("Cho'gall", "ruRU")
if not L then return end
if L then
	--heroic
	L.orders = "Смена приказа"
	L.orders_desc = "Сообщать когда Чо'Галл сменяет приказы огня/тьмы"

	L.worship_cooldown = "~Поклонение"

	L.adherent_bar = "Помощник #%d"
	L.adherent_message = "Надвигается помощник %d!"
	L.ooze_bar = "Слизнюки %d"
	L.ooze_message = "Надвигаются Слизнюки %d!"

	L.tentacles_bar = "Смутные творения"
	L.tentacles_message = "Смутные творения!"

	L.sickness_message = "Вы больны, и вас сейчас стошнит!"
	L.blaze_message = "На вас - Пламень!"
	L.crash_say = "На мне - Оскверняющее сокрушение!"

	L.fury_message = "Неистовство!"
	L.first_fury_soon = "Скоро Неистовство!"
	L.first_fury_message = "85% - Неистовство Чо'Галла!"

	L.unleashed_shadows = "Освобожденные тени"

	L.phase2_message = "2-ая фаза!"
	L.phase2_soon = "Скоро 2-ая фаза!"
end

L = BigWigs:NewBossLocale("Valiona and Theralion", "ruRU")
if L then
	L.phase_switch = "Смена фаз"
	L.phase_switch_desc = "Сообщать о смене фаз"

	L.phase_bar = "%s приземление"
	L.breath_message = "Надвигается Глубокий вдох!"
	L.dazzling_message = "Надвигается Шокирующее разрушение!"

	L.blast_message = "Сумеречный взрыв" --Sounds better and makes more sense than Twilight Blast (the user instantly knows something is coming from the sky at them)
	L.engulfingmagic_say = "Избыточная магия на МНЕ!"

	L.valiona_trigger = "Тералион, я подожгу коридор. Не дай им уйти!"
	L.win_trigger = "Одно утешает... Тералион погиб вместе со мной..."

	L.twilight_shift = "%2$dx Сумеречный сдвиг на |3-3(%1$s)"
end

L = BigWigs:NewBossLocale("Halfus Wyrmbreaker", "ruRU")
if L then
	L.strikes_message = "%2$dx удар(а) на |3-3(%1$s)"

	L.breath_message = "Обжигающее дыхание!"
	L.breath_bar = "~Дыхание"

	L.engage_yell = "Cho'gall will have your heads"
end

L = BigWigs:NewBossLocale("Ascendant Council", "ruRU")
if L then
	L.static_overload_say = "На МНЕ - Статическая перегрузка!"
	L.gravity_core_say = "На МНЕ - Гравитационное ядро!"
	L.health_report = "%s имеет %d%% здоровья, скоро смена!"
	L.switch = "Смена"
	L.switch_desc = "Сообщать о смене боссов"

	L.shield_up_message = "ЩИТ!"
	L.shield_down_message = "Щит СПАЛ!"
	L.shield_bar = "щит"

	L.switch_trigger = "Мы займемся ими!"

	L.thundershock_quake_soon = "%s через 10сек!"

	L.quake_trigger = "Земля уходит у вас из-под ног..."
	L.thundershock_trigger = "Воздух потрескивает от скопившейся энергии..."

	L.thundershock_quake_spam = "%s in %d"

	L.last_phase_trigger = "Ваше упорство..."
end

L = BigWigs:NewBossLocale("Sinestra", "ruRU")
if L then
	L.whelps = "Дракончики"
	L.whelps_desc = "Сообщать о волнах дракончиков"

	L.slicer_message = "Возможные цели луча"

	L.egg_vulnerable = "Время омлета!"

	L.whelps_trigger = "Ешьте, дети мои! Пусть их мясо насытит вас!"
	L.omelet_trigger = "Ты так в этом уверен? Глупец!"

	L.phase13 = "Фаза 1 и 3"
	L.phase = "Фаза"
	L.phase_desc = "Сообщать о смене фаз"
end

