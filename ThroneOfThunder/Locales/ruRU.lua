local L = BigWigs:NewBossLocale("Jin'rokh the Breaker", "ruRU")
if not L then return end
if L then
	L.storm_duration = "Длительность Грозы"
	L.storm_duration_desc = "Отдельная полоса предупреждения для длительности чтения Грозы."
	L.storm_short = "Гроза"

	L.in_water = "Вы в воде!"
end

L = BigWigs:NewBossLocale("Horridon", "ruRU")
if L then
	L.charge_trigger = "останавливает свой взгляд"
	L.door_trigger = "прибывают"
	L.orb_trigger = "направляет"

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
	L.priestess_adds_desc = "Предупреждать о всех типах помощников Верховной жрицы Мар'ли."
	L.priestess_adds_message = "Помощник Жрицы"

	L.custom_on_markpossessed = "Помечать одержимого босса"
	L.custom_on_markpossessed_desc = "На одержимого босса ставится череп, требуется быть помощником или лидером."

	L.priestess_heal = "%s мсцелён!"
	L.assault_stun = "Танк оглушен!"
	L.assault_message = "Натиск"
	L.full_power = "Полная энергия"
	L.hp_to_go_power = "%d%% HP осталось! (Энергия: %d)"
	L.hp_to_go_fullpower = "%d%% HP осталось! (Полная энергия)"
end

L = BigWigs:NewBossLocale("Tortos", "ruRU")
if L then
	L.bats_desc = "Много летучих мышей. Справляйтесь."

	L.kick = "Пинок"
	L.kick_desc = "Отслеживает, сколько черепах можно пнуть."
	L.kick_message = "Можно пнуть черепах: %d"
	L.kicked_message = "%s пнул! (%d осталось)"

	L.custom_off_turtlemarker = "Маркировка черепах"
	L.custom_off_turtlemarker_desc = "Помечать рейдовыми метками черепах, требуется быть помощником или лидером.\n|cFFFF0000Только 1 человек в рейде должен включить эту опцию, чтобы предотвратить конфликты.|r\n|cFFADFF2FСОВЕТ: Если вы выбраны для этой задачи, быстро проведите указателем мыши по черепахам, метки сразу же поставятся.|r"

	L.no_crystal_shell = "НЕТ Защитного панциря"
end

L = BigWigs:NewBossLocale("Megaera", "ruRU")
if L then
	L.breaths = "Дыхания"
	L.breaths_desc = "Предупреждения, связанные со всеми типами дыхания."

	L.arcane_adds = "Тайные помощники"
end

L = BigWigs:NewBossLocale("Ji-Kun", "ruRU")
if L then
	L.first_lower_hatch_trigger = "Яйца в одном из нижних гнезд начинают проклевываться!"
	L.lower_hatch_trigger = "Яйца в одном из нижних гнезд начинают проклевываться!"
	L.upper_hatch_trigger = "Яйца в одном из верхних гнезд начинают проклевываться!"

	L.nest = "Гнезда"
	L.nest_desc = "Предупреждения, связанные с гнездами.\n|cFFADFF2FСОВЕТ: Снимите галочку, чтобы отключить предупреждения, если вы не назначены на гнезда.|r"

	L.flight_over = "Полет закончится через %d сек!"
	L.upper_nest = "|cff008000Верхние|r гнезда"
	L.lower_nest = "|cffff0000Нижние|r гнезда"
	L.up = "|cff008000ВВЕРХ|r"
	L.down = "|cffff0000ВНИЗ|r"
	L.add = "Помощник"
	L.big_add_message = "Большой помощник: %s"
end

L = BigWigs:NewBossLocale("Durumu the Forgotten", "ruRU")
if L then
	L.red_spawn_trigger = "багровый туман"
	L.blue_spawn_trigger = "лазурный туман"
	L.yellow_spawn_trigger = "янтарный туман"

	L.adds = "Найденные помощники"
	L.adds_desc = "Предупреждать, когда вы находите Багровый, Янтарный или Лазурный туманы, и сколько туманов ещё осталось."

	L.custom_off_ray_controllers = "Операторы луча"
	L.custom_off_ray_controllers_desc = "Использовать {rt1}{rt7}{rt6} метки для обозначения людей, контролирующих лучи, требуется быть помощником или лидером."

	L.custom_off_parasite_marks = "Маркировка Темного паразита"
	L.custom_off_parasite_marks_desc = "Чтобы помочь лекарям, на людей с темным паразитом, будут поставлены метки {rt3}{rt4}{rt5}, требуется быть помощником или лидером."

	L.initial_life_drain = "Начало чтения Похищения жизни"
	L.initial_life_drain_desc = "Сообщать о начале чтения похищения жизни, чтобы помочь с распределением дебаффа."

	L.life_drain_say = "%dx Похищение"

	L.rays_spawn = "Появляются лучи"
	L.red_add = "|cffff0000Красный|r помощник"
	L.blue_add = "|cff0000ffСиний|r помощник"
	L.yellow_add = "|cffffff00Желтый|r помощник"
	L.death_beam = "Смертельный луч"
	L.red_beam = "|cffff0000Красный|r луч"
	L.blue_beam = "|cff0000ffСиний|r луч"
	L.yellow_beam = "|cffffff00Желтый|r луч"
end

L = BigWigs:NewBossLocale("Primordius", "ruRU")
if L then
	L.mutations = "Мутации |cff008000(%d)|r |cffff0000(%d)|r"
end

L = BigWigs:NewBossLocale("Dark Animus", "ruRU")
if L then
	L.engage_trigger = "Сфера взрывается!"

	L.matterswap_desc = "Игрок, на которого наложен эффект \"Обмен материей\", находится слишком далеко от вас. При рассеивании эффекта этот игрок поменяется с вами местами."
	L.matterswap_message = "Вы дальше всех для Обмена материей!"

	L.siphon_power = "Поглощение анимы (%d%%)"
	L.siphon_power_soon = "Поглощение анимы (%d%%) %s скоро!"
	L.slam_message = "Удар"
end

L = BigWigs:NewBossLocale("Iron Qon", "ruRU")
if L then
	L.molten_energy = "Сила огня"

	L.arcing_lightning_cleared = "Рейд свободен от Дуговой молнии"
end

L = BigWigs:NewBossLocale("Twin Consorts", "ruRU")
if L then
	L.last_phase_yell_trigger = "Только в этот раз..."

	L.barrage_fired = "Обстрел закончен!"
end

L = BigWigs:NewBossLocale("Lei Shen", "ruRU")
if L then
	L.custom_off_diffused_marker = "Маркировка Рассеянных молний"
	L.custom_off_diffused_marker_desc = "Помечать рейдовыми метками Рассеянные молнии, требуется быть помощником или лидером.\n|cFFFF0000Только 1 человек в рейде должен включить эту опцию, чтобы предотвратить конфликты.|r\n|cFFADFF2FСОВЕТ: Если вы выбраны для этой задачи, быстро проведите указателем мыши по молниям, метки сразу же поставятся.|r"

	L.stuns = "Оглушения"
	L.stuns_desc = "Показывать полосы длительности оглушений для Шаровых молний."

	L.aoe_grip = "AoE хватка"
	L.aoe_grip_desc = "Предупреждать, когда рыцарь смерти использует Хватку Кровожада для Шаровых молний."

	L.shock_self = "Статический шок на ТЕБЕ"
	L.shock_self_desc = "Показывать полосу с длительностью эффекта Статического шока на тебе."

	L.overcharged_self = "Перегрузка на ТЕБЕ"
	L.overcharged_self_desc = "Показывать полосу с длительностью эффекта Перегрузки на тебе."

	L.last_inermission_ability = "Последний перерыв!"
	L.safe_from_stun = "Возможно, вы защищены от оглушения Перегрузкой"
	L.diffusion_add = "Рассеянная молния"
	L.shock = "Электрошок"
	L.static_shock_bar = "<Статический шок>"
	L.overcharge_bar = "<Выброс Перегрузки>"
end

L = BigWigs:NewBossLocale("Ra-den", "ruRU")
if L then
	L.vita_abilities = "Способности Жизни"
	L.anima_abilities = "Способности Анимы"
	L.worm = "Червь"
	L.worm_desc = "Призыв червя"
	L.balls = "Сферы"
	L.balls_desc = "Сферы Анимы (красные) и Жизни (синие), которые определяют, какие способности получит Ра-ден"
	L.corruptedballs = "Оскверненные сферы"
	L.corruptedballs_desc = "Оскверненные сферы Жизни и Анимы, которые увеличивают урон (Жизнь) или здоровье (Анима)."
	L.unstablevitajumptarget = "Смена цели Нестабильной жизни"
	L.unstablevitajumptarget_desc = "Предупреждает, если вы дальше всех от игрока с Нестабильной жизнью. Если включено увеличение, запустится обратный отсчет, когда Нестабильная жизнь собирается перепрыгнуть с вас."
	L.unstablevitajumptarget_message = "Вы дальше всех от Нестабильной жизни"
	L.sensitivityfurthestbad = "Восприимчивость к жизни + далеко = |cffff0000ПЛОХО|r!"
	L.kill_trigger = "Остановитесь!"

	L.assistPrint = "Плагин 'BigWigs_Ra-denAssist' уже выпущен для помощи во время схватки с Ра-Деном. Возможно, ваша гильдия захочет его попробовать."
end

L = BigWigs:NewBossLocale("Throne of Thunder Trash", "ruRU")
if L then
	L.stormcaller = "Зандаларский призыватель бурь"
	L.stormbringer = "Вестник шторма Драз'кил"
	L.monara = "Монара"
	L.rockyhorror = "Скальный ужас"
	L.thunderlord_guardian = "Повелитель грозы / Страж молний"
end
