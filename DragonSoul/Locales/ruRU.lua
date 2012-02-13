local L = BigWigs:NewBossLocale("Morchok", "ruRU")
if not L then return end
if L then
	L.engage_trigger = "Попробуйте остановить лавину и умрете."

	L.crush = "Сокрушение доспеха"
	L.crush_desc = "Только для танков. Считает стаки сокрушения доспеха и показывает таймер."
	L.crush_message = "%2$dx Сокрушение на |3-5(%1$s)"

	L.blood = "Черная кровь"

	L.explosion = "Взрыв"
	L.crystal = "Кристалл"
end

L = BigWigs:NewBossLocale("Warlord Zon'ozz", "ruRU")
if L then
	L.engage_trigger = "Ззоф Шуул'уах. Ток фшш Н'Зот!"

	L.ball = "Сфера"
	L.ball_desc = "Сфера, которая отскакивает от игроков и босса."

	L.bounce = "Отскок Сферы"
	L.bounce_desc = "Счетчик для отскакиваний сферы."

	L.darkness = "Дискотека Щупалец!"
	L.darkness_desc = "Эта фаза начинается, когда сфера попадает в босса."

	L.shadows = "Тени"
end

L = BigWigs:NewBossLocale("Yor'sahj the Unsleeping", "ruRU")
if L then
	L.engage_trigger = "Иилт ки'уотк шн'ма йе'глу Шат'Яр! Х'ИУН ИИЛТ!"

	L.bolt_desc = "Только для танков. Считает стаки стрел тьмы и показывает таймер."
	L.bolt_message = "%2$dx Стрела на |3-5(%1$s)"

	L.blue = "|cFF0080FFСиняя|r"
	L.green = "|cFF088A08Зеленая|r"
	L.purple = "|cFF9932CDФиолетовая|r"
	L.yellow = "|cFFFFA901Желтая|r"
	L.black = "|cFF424242Черная|r"
	L.red = "|cFFFF0404Красная|r"

	L.blobs = "Капли"
	L.blobs_bar = "Новые капли"
	L.blobs_desc = "Капли крови двигаются к боссу"
end

L = BigWigs:NewBossLocale("Hagara the Stormbinder", "ruRU")
if L then
	L.engage_trigger = "Вы осмелились бросить вызов владычице штормов?!"

	L.lightning_or_frost = "Грозовая или Ледяная"
	L.ice_next = "Ледяная фаза"
	L.lightning_next = "Грозовая фаза"

	L.assault_desc = "Только для танков/лекарей. "..select(2, EJ_GetSectionInfo(4159))

	L.nextphase = "Следующая Фаза"
	L.nextphase_desc = "Предупреждать о следующей фазе"
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
	L.crystal_green = "Зеленый Кристалл"
	L.crystal_blue = "Синий Кристалл"

	L.twilight = "Сумерки"
	L.cast = "Полоса каста Сумерек"
	L.cast_desc = "Показывает 5-ти (Нормал) или 3-х (Героик) секундную полосу каста Сумерек."

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
    L.warmup = "Начало боя"
	L.warmup_desc = "Время до начала боя."

	L.sunder = "Раскол брони"
	L.sunder_desc = "Только для танков. Считает стаки раскола брони и показывает таймер."
	L.sunder_message = "%2$dx Раскол на |3-5(%1$s)"

	L.sapper_trigger = "Дракон пикирует на палубу, чтобы сбросить на нее сумеречного сапера!"
	L.sapper = "Сапер"
	L.sapper_desc = "Сапер наносит повреждения кораблю, если достигнет каюты"

	L.stage2_trigger = "Похоже, мне придется заняться этим самому. Чудесно!"
end

L = BigWigs:NewBossLocale("Spine of Deathwing", "ruRU")
if L then
	L.engage_trigger = "Смотрите, он разваливается! Оторвите пластины, и у нас появится шанс сбить его!"

	L.left_start = "собирается накрениться влево"
	L.right_start = "собирается накрениться вправо"
	L.left = "наклоняется влево"
	L.right = "наклоняется вправо"
	L.not_hooked = "ТЫ >НЕ< зацеплен!"
	L.roll_message = "Он вращается, вращается, вращается!"
	L.level_trigger = "выравнивается"
	L.level_message = "Неважно, он выравнивается!"

	L.exposed = "Броня Вскрыта"

	L.residue = "Непоглощенный Осадок"
	L.residue_desc = "Сообщения, информирующие вас о том, сколько ещё осадков крови осталось на полу."
	L.residue_message = "Осадков: %d"
end

L = BigWigs:NewBossLocale("Madness of Deathwing", "ruRU")
if L then
	L.engage_trigger = "У вас НИЧЕГО не вышло. Я РАЗОРВУ ваш мир на куски."

	L.impale_desc = "Только для танков/лекарей. "..select(2,EJ_GetSectionInfo(4114))

	-- Copy & Paste from Encounter Journal with correct health percentages (type '/dump EJ_GetSectionInfo(4103)' in the game)
	L.smalltentacles_desc = "At 70% and 40% remaining health the Limb Tentacle sprouts several Blistering Tentacles that are immune to Area of Effect abilities."

	L.bolt_explode = "<Взрыв Стрелы>"
	L.parasite = "Паразит"
	L.blobs_soon = "%d%% - Свертывающаяся кровь скоро!"
end

