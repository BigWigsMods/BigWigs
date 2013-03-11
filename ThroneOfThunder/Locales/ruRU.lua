local L = BigWigs:NewBossLocale("Jin'rokh the Breaker", "ruRU")
if not L then return end
if L then
	L.storm_duration = "Длительность Грозы"
	L.storm_duration_desc = "Отдельная полоса предупреждения для длительности чтения Грозы."

	L.in_water = "Вы в воде!"
end

L = BigWigs:NewBossLocale("Horridon", "ruRU")
if L then
	L.charge_trigger = "останавливает свой взгляд"
	L.door_trigger = "прибывают"

	L.chain_lightning_message = "Ваш фокус читает Цепную молнию!"
	L.chain_lightning_bar = "Фокус: Цепная молния"

	L.fireball_message = "Ваш фокус читает Огненный шар!"
	L.fireball_bar = "Фокус: Огненный шар"

	L.venom_bolt_volley_message = "Ваш фокус читает Залп!"
	L.venom_bolt_volley_bar = "Фокус: Залп"

	L.adds = "Появление помощников"
	L.adds_desc = "Предупреждать о появлении Фарраки, Гурубаши, Драккари, Амани и Бога Войны Джалака."

	L.door_opened = "Ворота открыты!"
	L.door_bar = "След. ворота (%d)"
	L.balcony_adds = "Подкрепление с балкона"
	L.orb_message = "Сфера контроля упала!"

	L.focus_only = "|cffff0000Оповещения только для фокуса.|r "
end

L = BigWigs:NewBossLocale("Council of Elders", "ruRU")
if L then
	L.priestess_adds = "Помощники Жрицы"
	L.priestess_adds_desc = "Предупреждать о всех типах помощников верховной жрицы Мар'ли."
	L.priestess_adds_message = "Помощник Жрицы"

	L.assault_stun = "Tank Stunned!"
	L.full_power = "Полная энергия"
	L.assault_message = "Выпад"
	L.hp_to_go_power = "HP осталось: %d%% - Энергия: %d"

	L.custom_on_markpossessed = "Помечать одержимого босса"
	L.custom_on_markpossessed_desc = "На одержимого босса ставится череп."
end

L = BigWigs:NewBossLocale("Tortos", "ruRU")
if L then
	L.kick = "Пинок"
	L.kick_desc = "Отслеживает, сколько черепах можно пнуть."
	L.kick_message = "Можно пнуть черепах: %d"

	L.crystal_shell_removed = "Защитный панцирь снят!"
	L.no_crystal_shell = "НЕТ Защитного панциря"
end

L = BigWigs:NewBossLocale("Megaera", "ruRU")
if L then
	L.breaths = "Дыхание"
	L.breaths_desc = "Предупреждения, связанные со всеми типами дыхания."

	L.arcane_adds = "Тайные помощники"
end

L = BigWigs:NewBossLocale("Ji-Kun", "ruRU")
if L then
	L.lower_hatch_trigger = "Яйца в одном из нижних гнезд начинают проклевываться!"
	L.upper_hatch_trigger = "Яйца в одном из верхних гнезд начинают проклевываться!"

	L.nest = "Гнезда"
	L.nest_desc = "Предупреждения, связанные с гнездами. |cffff0000Снимите галочку, чтобы отключить предупреждения, если вы не назначены на гнезда!|r"

	L.flight_over = "Облет для %d сек!"
	L.upper_nest = "|cff008000Верхние|r гнезда"
	L.lower_nest = "|cffff0000Нижние|r гнезда"
	L.upper = "|cff008000Верхние|r"
	L.lower = "|cffff0000Нижние|r"
	L.add = "Помощник"
	L.big_add_message = "Большой помощник: %s"
end

L = BigWigs:NewBossLocale("Durumu the Forgotten", "ruRU")
if L then
	L.red_spawn_trigger = "Инфракрасный свет высвечивает багровый туман!"
	L.blue_spawn_trigger = "The Blue Rays reveal an Azure Eye!"

	L.custom_off_ray_controllers = "Операторы луча"
	L.custom_off_ray_controllers_desc = "Использовать %s, %s, %s метки для обозначения людей, контроллирующих лучи."

	L.rays_spawn = "Появляются лучи"
	L.red_add = "|cffff0000Красный|r помощник"
	L.blue_add = "|cff0000ffСиний|r помощник"
	L.death_beam = "Смертельный луч"
	L.red_beam = "|cffff0000Red|r beam"
	L.blue_beam = "|cff0000ffBlue|r beam"
	L.yellow_beam = "|cffffff00Yellow|r beam"
end

L = BigWigs:NewBossLocale("Primordius", "ruRU")
if L then
	L.mutations = "Мутации |cff008000(%d)|r |cffff0000(%d)|r"
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

	-- L.arcing_lightning_cleared = "Raid is clear of Arcing Lightning"
end
L = BigWigs:NewBossLocale("Twin Consorts", "ruRU")
if L then
	-- L.barrage_fired = "Barrage fired!"
	-- L.last_phase_yell_trigger = "Just this once..."
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

