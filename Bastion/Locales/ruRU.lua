
local L = BigWigs:NewBossLocale("Cho'gall", "ruRU")
if not L then return end
if L then
	--heroic
	L.orders = "Смена приказа"
	L.orders_desc = "Сообщать когда Чо'Галл сменяет приказы огня/тьмы"

	--normal
	L.worship_cooldown = "~Поклонение"
	L.adherent_bar = "След. адепт-искуситель"
	L.adherent_message = "Адепт-искуситель!"
	L.ooze_bar = "Слизнюки"
	L.ooze_message = "Надвигаются Слизнюки!"
	L.tentacles_bar = "Смутные творения"
	L.tentacles_message = "Смутные творения!"
	L.sickness_message = "Вы больны, и вас сейчас стошнит!"
	L.fury_bar = "След. Неистовство"
	L.fury_message = "Неистовство!"

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

	L.engulfingmagic_say = "Избыточная магия на МНЕ!"
	L.engulfingmagic_cooldown = "~Избыточная магия"

	L.devouringflames_cooldown = "~Всепоглощающее пламя"

	L.valiona_trigger = "Тералион, я подожгу коридор. Не дай им уйти!"

	L.twilight_shift = "%2$dx Сумеречный сдвиг на |3-3(%1$s)"
end

L = BigWigs:NewBossLocale("Halfus Wyrmbreaker", "ruRU")
if L then

end

L = BigWigs:NewBossLocale("Sinestra", "ruRU")
if L then
	L.egg_vulnerable = "Omlet time!"

	L.omelet_trigger = "You mistake this for weakness?  Fool!"

	L.phase13 = "Фаза 1 и 3"
	L.phase = "Фаза"
	L.phase_desc = "Сообщать о смене фаз"
end

L = BigWigs:NewBossLocale("Ascendant Council", "ruRU")
if L then
	L.static_overload_say = "На МНЕ - Статическая перегрузка!"
	L.gravity_core_say = "На МНЕ - Гравитационное ядро!"
	L.health_report = "%s имеет %d%% здоровья, скоро смена!"
	L.switch = "Смена"
	L.switch_desc = "Сообщать о смене боссов"

	L.shield_up_message = "ЩИТ!"
	L.shield_bar = "След. щит"

	L.lightning_rod_say = "На МНЕ - Громоотвод!"

	L.switch_trigger = "Мы займемся ими!"

	L.thundershock_quake_soon = "%s через 10сек!"

	L.quake_trigger = "Земля уходит у вас из-под ног..."
	L.thundershock_trigger = "Воздух потрескивает от скопившейся энергии..."

	L.searing_winds_message = "Кружащиеся ветра!"
	L.grounded_message = "Заземление!"

	L.last_phase_trigger = "ВОТ ВАША СМЕРТЬ!"
end

