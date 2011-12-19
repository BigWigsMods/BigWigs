local L = BigWigs:NewBossLocale("Morchok", "ruRU")
if not L then return end
if L then
	L.engage_trigger = "Попробуйте остановить лавину и умрете."

	L.crush = "Сокрушение доспеха"
	L.crush_desc = "Только для танков. Считает стаки сокрушения доспеха и показывает их таймер."
	L.crush_message = "%2$dx Сокрушение на %1$s"

	L.blood = "Кровь"

	L.explosion = "Взрыв"
end

L = BigWigs:NewBossLocale("Warlord Zon'ozz", "ruRU")
if L then
	L.engage_trigger = "Ззоф Шуул'уах. Ток фшш Н'Зот!"

	L.ball = "Сфера"
	L.ball_desc = "Сфера, которая отскакивает от игроков и босса."

	L.bounce = "Отскок Сферы"
	L.bounce_desc = "Счетчик для отскакиваний сферы."

	L.darkness = "Диско пати Щупалец!"
	L.darkness_desc = "Эта фаза начинается, когда сфера попадает в босса."

	L.shadows = "Тени"
end

L = BigWigs:NewBossLocale("Yor'sahj the Unsleeping", "ruRU")
if L then
	L.engage_trigger = "Иилт ки'уотк шн'ма йе'глу Шат'Яр! Х'ИУН ИИЛТ!"

	L.bolt_desc = "Только для танков. Считает стаки стрел тьмы и показывает их таймер."
	L.bolt_message = "%2$dx Стрел на %1$s"

	L.blue = "|cFF0080FFСиняя|r"
	L.green = "|cFF088A08Зеленая|r"
	L.purple = "|cFF9932CDФиолетовая|r"
	L.yellow = "|cFFFFA901Желтая|r"
	L.black = "|cFF424242Черная|r"
	L.red = "|cFFFF0404Красная|r"

	L.blobs = "Капли"
	L.blobs_bar = "Новые капли"
	L.blobs_desc = "Йор'садж Неспящий обращается к мощи Шу'мы и призывает разноцветные капли его крови. Эти капли медленно движутся к Йор'саджу. Если капля достигает его, она дарует ему заключенную в ней мощь."
end

L = BigWigs:NewBossLocale("Hagara the Stormbinder", "ruRU")
if L then
	L.engage_trigger = "Вы осмелились бросить вызов владычице штормов?!"

	L.lightning_or_frost = "Грозовая или Ледяная"
	L.ice_next = "Ледяная фаза"
	L.lightning_next = "Грозовая фаза"

	L.assault_desc = "Только для танков. "..select(2, EJ_GetSectionInfo(4159))

	L.nextphase = "След. Фаза"
	L.nextphase_desc = "Предупреждения для следующей фазы"
end

L = BigWigs:NewBossLocale("Ultraxion", "ruRU")
if L then
	L.engage_trigger = "Настало Время Сумерек!"

	L.warmup = "Начало боя"
	L.warmup_desc = "Время до начала боя с боссом."
	L.warmup_trigger = "Я - начало конца... Тень, что заслоняет солнце... Звонящий по вам колокол…"

	L.crystal = "Мощь Кристаллов"
	L.crystal_desc = "Таймеры для различных кристаллов, даруемых Аспектами."
	L.crystal_red = "Красный Кристалл"
	L.crystal_green = "Зелёный Кристалл"
	L.crystal_blue = "Синий Кристалл"

	L.twilight = "Сумерки"
	L.cast = "Полоса каста Сумерек"
	L.cast_desc = "Показывает 5-ти (Нормал) или 3-х (Героик) секундную полосу начала каста Сумерек."

	L.lightself = "Гаснущий свет на Тебе"
	L.lightself_desc = "Показывает полосу с таймером взрыва Гаснущего света на тебе."
	L.lightself_bar = "<Ты Взорвешься>"

	L.lighttank = "Гаснущий свет на Танках"
	L.lighttank_desc = "Только для танков. Если Гаснущий свет на танке, показывет полосу взрыва и Мигание/Тряску."
	L.lighttank_bar = "<%s Взорвется>"
	L.lighttank_message = "Взрыв Танка"
end

L = BigWigs:NewBossLocale("Warmaster Blackhorn", "ruRU")
if L then
	L.harpooning = "Гарпун"

	L.rush = "Натиск Клинка"

	L.sunder = "Раскол брони"
	L.sunder_desc = "Только для танков. Считает стаки раскола брони и показывает их таймер."
	L.sunder_message = "%2$dx Раскол на %1$s"

	L.sapper_trigger = "Дракон пикирует на палубу, чтобы сбросить на нее сумеречного сапера!"
	L.sapper = "Сапер"
	L.sapper_desc = "Сапер наносит повреждения кораблю"

	L.stage2_trigger = "Похоже, мне придется заняться этим самому. Чудесно!"
end

L = BigWigs:NewBossLocale("Spine of Deathwing", "ruRU")
if L then
	L.left_start = "собирается накрениться влево"
	L.right_start = "собирается накрениться вправо"
	L.left = "наклоняется влево"
	L.right = "наклоняется вправо"
	L.not_hooked = "ТЫ >НЕ< зацеплен!"
	L.roll_message = "Он вращается, вращается, вращается!"
	L.level_trigger = "выравнивается"
	L.level_message = "Неважно, он выравнивается!"

	L.exposed = "Броня Вскрыта"
end

L = BigWigs:NewBossLocale("Madness of Deathwing", "ruRU")
if L then

	L.impale_desc = "Только для танков. "..select(2,EJ_GetSectionInfo(4114))

end

