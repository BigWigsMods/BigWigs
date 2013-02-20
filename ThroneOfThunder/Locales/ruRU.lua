local L = BigWigs:NewBossLocale("Jin'rokh the Breaker", "ruRU")
if not L then return end
if L then
	L.storm_duration = "Длительность Грозы"
	L.storm_duration_desc = "Отдельная полоса предупреждения для длительности чтения Грозы."

	L.in_water = "Вы в воде!"
end

L = BigWigs:NewBossLocale("Horridon", "ruRU")
if L then
	L.orb_message = "Сфера контроля упала!"

	L.chain_lightning_warning = "Ваш фокус читает Цепную молнию!"
	L.chain_lightning_bar = "Фокус: Цепная молния"

	L.fireball_warning = "Ваш фокус читает Огненный шар!"
	L.fireball_bar = "Фокус: Огненный шар"

	L.venom_bolt_volley_desc = "|cFFFF0000WARNING: Таймер показывается только для вашего 'фокуса', так как заклинатели имеют разное время восстановление способностей.|r "..select(2, EJ_GetSectionInfo(7112))
	L.venom_bolt_volley_warning = "Ваш фокус читает Залп!"
	L.venom_bolt_volley_bar = "Фокус: Залп"

	L.puncture_message = "Прокол"
end

L = BigWigs:NewBossLocale("Council of Elders", "ruRU")
if L then
	L.full_power = "Полная энергия"

	L.assault_message = "Выпад"

	L.loa_kills = "Убито Лоа: %s"
	L.priestess_add = "Помощник Жрицы"
	L.priestess_adds = "Помощники Жрицы"
	L.priestess_adds_desc = "Предупреждать о всех типах помощников Мар'ли верховной жрице."
	L.hp_to_go_power = "HP осталось: %d%% - Энергия: %d"
end

L = BigWigs:NewBossLocale("Tortos", "ruRU")
if L then
	L.kick = "Пинок"
	L.kick_desc = "Отслеживает, сколько черепах можно пнуть."
	L.kickable_turtles = "Можно пнуть черепах: %d"
	-- L.crystal_shell_removed = "Crystal Shell removed!"
	-- L.no_crystal_shell = "NO Crystal Shell"
end

L = BigWigs:NewBossLocale("Megaera", "ruRU")
if L then
	L.breaths = "Дыхание"
	L.breaths_desc = "Предупреждения, связанные со всеми типами дыхания."
	L.rampage_over = "Неистовство окончено!"
	-- L.arcane_adds = "Arcane adds"
end

L = BigWigs:NewBossLocale("Ji-Kun", "ruRU")
if L then
	L.flight_over = "Облет"
	L.young_egg_hatching = "Молодое инкубационное яйцо"
	-- L.lower_hatch_trigger = "The eggs in one of the lower nests begin to hatch!"
	-- L.upper_hatch_trigger = "The eggs in one of the upper nests begin to hatch!"
	L.upper_nest = "|c00008000Верхние|r гнезда"
	L.lower_nest = "|c00FF0000Нижние|r гнезда"
	-- L.food_call_trigger = "Hatchling calls for food!"
	L.nest = "Гнезда"
	L.nest_desc = "Предупреждения, связанные с гнездами. |c00FF0000Снимите галочку, чтобы отключить предупреждения, если вы не назначены на гнезда!|r"
end

L = BigWigs:NewBossLocale("Durumu the Forgotten", "ruRU")
if L then
	L.rays_spawn = "Появляются лучи"
	L.ray_controller = "Оператор луча"
	L.ray_controller_desc = "Объявлять операторов направления красного и синего луча."
	L.red_ray_controller = "Вы оператор |c000000FFСинего|r луча"
	L.blue_ray_controller = "Вы оператор |c00FF0000Красного|r луча"
	-- L.red_spawn_trigger = "The Infrared Light reveals a Crimson Fog!"
	-- L.blue_spawn_trigger = "The Blue Rays reveal an Azure Eye!"
	L.red_add = "|c00FF0000Красный|r помощник"
	L.blue_add = "|c000000FFСиний|r помощник"
	L.clockwise = "По часовой стрелке"
	L.counter_clockwise = "Отсчет часовой стрелки"
	-- L.death_beam = "Death beam"
end

L = BigWigs:NewBossLocale("Primordius", "ruRU")
if L then
	L.stream_of_blobs = "Поток каплей"
	L.mutations = "Мутации"
end

L = BigWigs:NewBossLocale("Dark Animus", "ruRU")
if L then
	-- L.engage_trigger = "The orb explodes!"
	L.slam_message = "Удар"
end
L = BigWigs:NewBossLocale("Iron Qon", "ruRU")
if L then
	L.molten_energy = "Огненная энергия"

	L.overload_casting = "Чтение Огненной перегрузки"
	L.overload_casting_desc = "Предупреждение для чтения Огненной перегрузки"
end
L = BigWigs:NewBossLocale("Twin Consorts", "ruRU")
if L then
	-- L.barrage_fired = "Barrage fired!"
end
L = BigWigs:NewBossLocale("Lei Shen", "ruRU")
if L then
	L.conduit_abilities = "Способности проводника"
	L.conduit_abilities_desc = "Полосы приблизительного восстановления способностей проводника."
	L.conduit_ability_meassage = "След. способность проводника"
	L.intermission = "Перерыв"
	L.overchargerd_message = "Оглушающий AoE импульс"
	L.static_shock_message = "Делящийся AoE урон"
	L.diffusion_add_message = "Рассеивающие помощники"
	L.diffusion_chain_message = "Скоро рассеивающий помощник - Разбегитесь!"
end
L = BigWigs:NewBossLocale("Ra-den", "ruRU")
if L then

end

