local L = BigWigs:NewBossLocale("The Tarragrue", "ruRU")
if not L then return end
if L then
	L.chains = "Цепи" -- Chains of Eternity (Chains)
	L.remnants = "Фрагменты" -- Remnant of Forgotten Torments (Remnants)

	L.physical_remnant = "Физический фрагмент"
	L.magic_remnant = "Магический фрагмент"
	L.fire_remnant = "Огненный фрагмент"
	L.fire = "Огонь"
	L.magic = "Магический"
	L.physical = "Физический"
end

L = BigWigs:NewBossLocale("The Eye of the Jailer", "ruRU")
if L then
	L.chains = "Цепи" -- Short for Dragging Chains
	L.pool = "Лужа" -- Spreading Misery
	L.pools = "Лужи" -- Spreading Misery (multiple)
	L.death_gaze = "Взгляд смерти" -- Short for Titanic Death Gaze
end

L = BigWigs:NewBossLocale("The Nine", "ruRU")
if L then
	L.fragments = "Фрагменты" -- Short for Fragments of Destiny
	L.fragment = "Фрагмент" -- Singular Fragment of Destiny
	L.run_away = "Отбежать" -- Wings of Rage
	L.song = "Песня" -- Short for Song of Dissolution
	L.go_in = "Подбежать" -- Reverberating Refrain
	L.valkyr = "Зов валь'киры" -- Short for Call of the Val'kyr
	L.blades = "Клинки" -- Agatha's Eternal Blade
	L.big_bombs = "Большие бомбы" -- Daschla's Mighty Impact
	L.big_bomb = "Большая бомба" -- Attached to the countdown
	L.shield = "Щит" -- Annhylde's Bright Aegis
	L.soaks = "Перекрывания" -- Aradne's Falling Strike
	L.small_bombs = "Маленькие бомбы" -- Brynja's Mournful Dirge
	L.recall = "Повтор команд" -- Short for Word of Recall

	L.blades_yell = "Примите смерть от моего клинка!"
	L.soaks_yell = "Вам со мной не справиться!"
	L.shield_yell = "Мой щит не сломить!"

	L.berserk_stage1 = "Берсерк фазы 1"
	L.berserk_stage2 = "Берсерк фазы 2"

	L.image_special = "%s [Скайя]" -- Stage 2 boss name
end

L = BigWigs:NewBossLocale("Remnant of Ner'zhul", "ruRU")
if L then
	L.cones = "Конусы" -- Grasp of Malice
	L.orbs = "Сферы" -- Orb of Torment
	L.orb = "Сфера" -- Orb of Torment
end

L = BigWigs:NewBossLocale("Soulrender Dormazain", "ruRU")
if L then
	L.custom_off_nameplate_defiance = "Метки на Верных Утробе с Неповиновением"
	L.custom_off_nameplate_defiance_desc = "Ставит метку на Верного Утробе, имеющего бафф Неповиновения.\n\nТребует включённых индикаторов здоровья врагов и соответствующего аддона (KuiNameplates, Plater)."

	L.custom_off_nameplate_tormented = "Метки на Верных Утробе с Мучением"
	L.custom_off_nameplate_tormented_desc = "Ставит метку на Верного Утробе, имеющего дебафф Мучения.\n\nТребует включённых индикаторов здоровья врагов и соответствующего аддона (KuiNameplates, Plater)."

	L.cones = "Мучение" -- Torment
	L.dance = "Танцы" -- Encore of Torment
	L.brands = "Клеймо мучения" -- Brand of Torment
	L.brand = "Клеймо" -- Single Brand of Torment
	L.spike = "Кольцо агонии" -- Short for Agonizing Spike
	L.chains = "Цепи" -- Hellscream
	L.chain = "Цепь" -- Soul Manacles
	L.souls = "Души" -- Rendered Soul

	L.chains_remaining = "Цепей осталось: %d"
	L.all_broken = "Все цепи порваны"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "ruRU")
if L then
	L.hammer = "Молот" -- Short for Rippling Hammer
	L.axe = "Топор" -- Short for Cruciform Axe
	L.scythe = "Коса" -- Short for Dualblade Scythe
	L.trap = "Капкан" -- Short for Flameclasp Trap
	L.chains = "Цепи" -- Short for Shadowsteel Chains
	L.embers = "Угли" -- Short for Shadowsteel Embers
	L.adds_embers = "Угли (%d) - скоро адды!"
	L.adds_killed = "Адды убиты за %.2f с."
	L.spikes = "Смерть от шипов" -- Soft enrage spikes
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "ruRU")
if L then
	L.custom_on_stop_timers = "Всегда показывать полосы заклинаний"
	L.custom_on_stop_timers_desc = "Стражница может откладывать свои способности. Когда эта опция включена, полосы этих способностей будут оставаться на экране."

	L.bomb_missed = "%dx бомб мимо"
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "ruRU")
if L then
	L.rings = "Кольца"
	L.rings_active = "Колец активно" -- for when they activate/are movable
	L.runes = "Руны"

	L.grimportent_countdown = "Отсчёт до конца Дурного предзнаменования"
	L.grimportent_countdown_desc = "Показывать отсчёт для игроков с дебаффом Дурного предзнаменования"
	L.grimportent_countdown_bartext = "Иди к руне!"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "ruRU")
if L then
	L.spikes = "Шипы" -- Short for Glacial Spikes
	L.spike = "Шип"
	L.miasma = "Миазмы" -- Short for Sinister Miasma

	L.custom_on_nameplate_fixate = "Метка для преследующего прислужника"
	L.custom_on_nameplate_fixate_desc = "Показывать метку на прислужнике, который преследует вас.\n\nТребует включённых индикаторов здоровья врагов и соответствующего аддона (KuiNameplates, Plater)."
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "ruRU")
if L then
	L.chains_active = "Активация цепепй"
	L.chains_active_desc = "Показывать полосу для активации Цепей Господства"

	L.custom_on_nameplate_fixate = "Метка для преследующего часового"
	L.custom_on_nameplate_fixate_desc = "Показывать метку на Темном часовом, который преследует вас.\n\nТребует включённых индикаторов здоровья врагов и соответствующего аддона (KuiNameplates, Plater)."

	L.chains = "Цепи" -- Short for Domination Chains
	L.chain = "Цепь" -- Single Domination Chain
	L.darkness = "Завеса тьмы" -- Short for Veil of Darkness
	L.arrow = "Стрела" -- Short for Wailing Arrow
	L.wave = "Волна" -- Short for Haunting Wave
	L.dread = "Ужас" -- Short for Crushing Dread
	L.orbs = "Сферы" -- Dark Communion
	L.curse = "Проклятие летаргии" -- Short for Curse of Lethargy
	L.pools = "Лужи" -- Banshee's Bane
	L.scream = "Вой банши" -- Banshee Scream

	L.knife_fling = "Ножи смерти" -- "Death-touched blades fling out"
end

