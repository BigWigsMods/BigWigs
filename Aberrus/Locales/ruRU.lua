local L = BigWigs:NewBossLocale("The Amalgamation Chamber", "ruRU")
if not L then return end
if L then
	L.custom_on_fade_out_bars = "Скрыть панели второго босса"
	L.custom_on_fade_out_bars_desc = "Скрывает панели способностей босса, который вне радиуса на 1 фазе."

	L.coalescing_void = "Отбежка"

	L.shadow_and_flame = "Мифик дебафф"
end

L = BigWigs:NewBossLocale("The Forgotten Experiments", "ruRU")
if L then
	L.rending_charge_single = "Цель первого рывка"
	L.unstable_essence_new = "Бомба каст"
	L.custom_on_unstable_essence_high = "Сообщения в чат о высоких стаках Нестабильной Сущности"
	L.custom_on_unstable_essence_high_desc = "Сообщать в чат о высоких стаках Нестабильной Сущности"
	L.volatile_spew = "Войдзоны"
	L.volatile_eruption = "Извержение"
	L.temporal_anomaly_knocked = "Шарик откинут"
end

L = BigWigs:NewBossLocale("Assault of the Zaqali", "ruRU")
if L then
	-- These are in-game emotes and need to match the text shown in-game
	-- You should also replace the comment (--) with the full emote as it shows in-game
	L.zaqali_aide_north_emote_trigger = "северное укрепление" -- Помощники вождя поднимаются на северное укрепление!
	L.zaqali_aide_south_emote_trigger = "южное укрепление" -- Помощники вождя поднимаются на южное укрепление!

	L.both = "Обе"
	L.zaqali_aide_message = "%s лезут:  %s" -- Big Adds Climbing North
	L.add_bartext = "%s: %s (%d)"
	L.boss_returns = "Босс: Север"

	L.molten_barrier = "Преграда"
	L.catastrophic_slam = "Делёжка"
end

L = BigWigs:NewBossLocale("Rashok, the Elder", "ruRU")
if L then
	L.doom_flames = "Малые соки"
	L.charged_smash = "Делёжка"
	L.energy_gained = "Получено энергии: %d"
end

L = BigWigs:NewBossLocale("The Vigilant Steward, Zskarn", "ruRU")
if L then
	L.tactical_destruction = "Задувка"
	L.bombs_soaked = "Бомб активировано" -- Bombs Soaked (2/4)
	L.unstable_embers = "Угли"
	L.unstable_ember = "Уголь"
end

L = BigWigs:NewBossLocale("Magmorax", "ruRU")
if L then
	L.energy_gained = "Энергия получена (-17с)" -- When you fail, you lose 17 seconds, the boss reaches full energy faster

	-- Mythic
	L.explosive_magma = "Соки"
end

L = BigWigs:NewBossLocale("Echo of Neltharion", "ruRU")
if L then
	L.twisted_earth = "Стены"
	L.echoing_fissure = "Разлом"
	L.rushing_darkness = "Линии отталкивания"

	L.umbral_annihilation = "Уничтожение"
	L.ebon_destruction = "Большой взрыв"

	L.wall_breaker = "Ломатель стенки (Мифик)"
	L.wall_breaker_desc = "Игрок, являющийся целью Стремительной тьмы будет выбран в качестве ломателя стенки. Они будут отмечены ({rt6}) и отправят сообщение в чат. Работает только в мифической сложности на 1й фазе."
	L.wall_breaker_message = "Ломатель стенки"
end

L = BigWigs:NewBossLocale("Scalecommander Sarkareth", "ruRU")
if L then
	L.claws = "Танк дебафф" -- (Stage 1) Burning Claws / (Stage 2) Void Claws / (Stage 3) Void Slash
	L.claws_debuff = "Танк взрывается"
	L.emptiness_between_stars = "Забвение"
	L.void_slash = "Фронтал"

	L.ebon_might = "Ады иммун кик"
end

L = BigWigs:NewBossLocale("Aberrus, the Shadowed Crucible Trash", "ruRU")
if L then
	L.edgelord = "Владыка клинка из Пламени" -- NPC 198873
	L.naturalist = "Натуралист из Пламени" -- NPC 201746
	L.siegemaster = "Осадный мастер из Пламени" -- NPC 198874
	L.banner = "Знамя" -- Short for "Sundered Flame Banner" NPC 205638
	L.arcanist = "Чародей из Пламени" -- NPC 201736
	L.chemist = "Химик из Расколотого Пламени" -- NPC 205656
	L.fluid = "Живая жидкость" -- NPC 203939
	L.slime = "Булькающая жижа" -- NPC 205651
	L.goo = "Ползучая жижа" -- NPC 205820
	L.whisper = "Шепот во тьме" -- NPC 203806
end
