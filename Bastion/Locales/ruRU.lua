local L = BigWigs:NewBossLocale("Cho'gall", "ruRU")
if L then
	--heroic
	L.orders = "Приказы огня/Тьмы"
	L.orders_desc = "Сообщать о Приказах огня/Тьмы"

	--normal
	L.worship_cooldown = "~Поклонение"
end

L = BigWigs:NewBossLocale("Valiona and Theralion", "ruRU")
if L then
	L.phase_switch = "Смена фаз"
	L.phase_switch_desc = "Сообщать о смене фаз"

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

end

L = BigWigs:NewBossLocale("Ascendant Council", "ruRU")
if L then
	L.static_overload_say = "На МНЕ - Статическая перегрузка!"
	L.gravity_core_say = "На МНЕ - Гравитационное ядро!"
	L.health_report = "%s имеет %d%% здоровья, скоро смена!"
	L.switch = "Смена"
	L.switch_desc = "Сообщать о смене боссов"

	L.lightning_rod_say = "На МНЕ - Громоотвод!"

	L.switch_trigger = "Мы займемся ими!"

	L.quake_trigger = "Земля уходит у вас из-под ног..."
	L.thundershock_trigger = "Воздух потрескивает от скопившейся энергии..."

	L.searing_winds_message = "Кружащиеся ветра!"
	L.grounded_message = "Заземление!"

	L.last_phase_trigger = "ВОТ ВАША СМЕРТЬ!"
end
