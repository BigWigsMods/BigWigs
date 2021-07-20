local L = BigWigs:NewBossLocale("The Tarragrue", "ruRU")
if not L then return end
if L then
	L.chains = "Цепи" -- Chains of Eternity (Chains)
	L.remnants = "Фрагменты" -- Remnant of Forgotten Torments (Remnants)

	L.physical_remnant = "Физический фрагмент"
	L.magic_remnant = "Магический фрагмент"
	L.fire_remnant = "Огненный фрагмент"
	L.fire = "Огонь"
	L.magic = "Магия"
	L.physical = "Физика"
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
	L.run_away = "Убегай" -- Wings of Rage
	L.song = "Песня" -- Short for Song of Dissolution
	L.go_in = "Забегай" -- Reverberating Refrain
	L.valkyr = "Зов" -- Short for Call of the Val'kyr - Used 'Зов' since it's a more common shorthand for the spell
	L.blades = "Клинки" -- Agatha's Eternal Blade
	L.big_bombs = "Большие бомбы" -- Daschla's Mighty Impact
	L.big_bomb = "Большая бамба" -- Attached to the countdown
	L.shield = "Эгида" -- Annhylde's Bright Aegis
	L.soaks = "Засокать" -- Aradne's Falling Strike - Using imperative, since "Соки" has another meaning, but can be used if need be
	L.small_bombs = "Маленькие бомбы" -- Brynja's Mournful Dirge
	L.recall = "Повторение" -- Short for Word of Recall - Using word that means "repeat" since ru translation uses "return". Can use "Возвращение", but i'd advise against it.

	--L.blades_yell = "Fall before my blade!"
	--L.soaks_yell = "You are all outmatched!"
	--L.shield_yell = "My shield never falters!"

	L.berserk_stage1 = "Берсерк: Фаза 1"
	L.berserk_stage2 = "Берсерк: Фаза 2"

	L.image_special = "%s [Скайя]" -- Stage 2 boss name
end

L = BigWigs:NewBossLocale("Remnant of Ner'zhul", "ruRU")
if L then
	 L.cones = "Конусы" -- Grasp of Malice
	 L.orbs = "Орбы" -- Orb of Torment
	 L.orb = "Орб" -- Orb of Torment
end

L = BigWigs:NewBossLocale("Soulrender Dormazain", "ruRU")
if L then
	 L.custom_off_nameplate_defiance = "Непокорность: неймплейт иконка"
	 L.custom_off_nameplate_defiance_desc = "Показывает иконку на неймплейте Верных утробе под эффектом Непокорности.\n\nТребует использование вражеских полос неймплейтов и поддерживаемый аддон (KuiNameplates, Plater)."

	 L.custom_off_nameplate_tormented = "Мучение: неймплейт иконка"
	 L.custom_off_nameplate_tormented_desc = "Показывает иконку на неймплейте Верных утробе под эффектом Мучения.\n\nТребует использование вражеских полос неймплейтов и поддерживаемый аддон (KuiNameplates, Plater)."

	 L.cones = "Конусы" -- Torment
	 L.dance = "Танец" -- Encore of Torment
	 L.brands = "Brands" -- Brand of Torment
	 L.brand = "Клеймо" -- Single Brand of Torment
	 L.spike = "Кольцо" -- Short for Agonizing Spike -- Spell renamed to Agonizing Nova btw
	 L.chains = "Цепи" -- Hellscream
	 L.chain = "Цепь" -- Soul Manacles
	 L.souls = "Души" -- Rendered Soul

	 L.chains_remaining = "Осталось цепей: %d"
	 L.all_broken = "Все цепи сломаны"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "ruRU")
if L then
	 L.hammer = "Молот" -- Short for Rippling Hammer
	 L.axe = "Топор" -- Short for Cruciform Axe
	 L.scythe = "Коса" -- Short for Dualblade Scythe
	 L.trap = "Ловушка" -- Short for Flameclasp Trap
	 L.chains = "Цепи" -- Short for Shadowsteel Chains
	 L.embers = "Угли" -- Short for Shadowsteel Embers
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "ruRU")
if L then
	L.custom_on_stop_timers = "Всегда показывать полосы заклинаний"
	L.custom_on_stop_timers_desc = "Стражница может иметь задержку при касте способностей. Если включить, то полосы для этих способностей будут оставаться на Вашем экране."
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "ruRU")
if L then
	 L.rings = "Кольца"
	 L.rings_active = "Кольца активны" -- for when they activate/are movable
	 L.runes = "Руны"

	 L.grimportent_countdown = "Отсчёт"
	 L.grimportent_countdown_desc = "Отсчёт для игроков под эффектом Дурного Предзнаменования"
	 L.grimportent_countdown_bartext = "Беги к руне!"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "ruRU")
if L then
	 L.spikes = "Шипы" -- Short for Glacial Spikes
	 L.spike = "Шип"
	 L.miasma = "Миазмы" -- Short for Sinister Miasma

	 L.custom_on_nameplate_fixate = "Преследование: неймплейт иконка"
	 L.custom_on_nameplate_fixate_desc = "Показывать иконку на неймплейте Прислужников, которые преследуют Вас.\n\nТребует использование вражеских полос неймплейтов и поддерживаемый аддон (KuiNameplates, Plater)."
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "ruRU")
if L then
	 L.chains_active = "Цепи активны"
	 L.chains_active_desc = "Показывать полосу, когда активны Цепи Господства"

	 L.custom_on_nameplate_fixate = "Преследование: неймплейт иконка"
	 L.custom_on_nameplate_fixate_desc = "Показывать иконку на неймплейте Часовых, которые преследуют Вас.\n\nТребует использование вражеских полос неймплейтов и поддерживаемый аддон (KuiNameplates, Plater)."

	 L.chains = "Цепи" -- Short for Domination Chains
	 L.chain = "Цепь" -- Single Domination Chain
	 L.darkness = "Завеса" -- Short for Veil of Darkness -- Using "veil" instead of "darkness" because of spell name in russian
	 L.arrow = "Стрела" -- Short for Wailing Arrow
	 L.wave = "Волна" -- Short for Haunting Wave
	 L.dread = "Ужас" -- Short for Crushing Dread
	 L.orbs = "Орбы" -- Dark Communion
	 L.curse = "Проклятие" -- Short for Curse of Lethargy
	 L.pools = "Лужи" -- Banshee's Bane
	 L.scream = "Крик" -- Banshee Scream

	 L.knife_fling = "Ножи вылетают!" -- "Death-touched blades fling out"
end

