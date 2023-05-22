local L = BigWigs:NewBossLocale("Kazzara, the Hellforged", "ruRU")
if not L then return end
if L then
	L.dread_rift = "Разлом" -- Singular Dread Rift
end

L = BigWigs:NewBossLocale("The Amalgamation Chamber", "ruRU")
if L then
	L.custom_on_fade_out_bars = "Скрыть панели второго босса"
	L.custom_on_fade_out_bars_desc = "Скрывает панели способностей босса, который вне радиуса на 1 фазе."

	L.coalescing_void = "Отбежка"
	L.shadow_convergence = "Орбы"
	L.molten_eruption = "Соки"
	L.swirling_flame = "Ветерки"
	L.gloom_conflagration = "Ветерки + Отбежка"
	L.blistering_twilight = "Бомбы + Ветерки"
	L.convergent_eruption = "Соки + Орбы"
	L.shadowflame_burst = "Фронтал"

	L.shadow_and_flame = "Мифик дебафф"
end

L = BigWigs:NewBossLocale("The Forgotten Experiments", "ruRU")
if L then
	--L.rending_charge_single = "First Charge"
	L.massive_slam = "Фронтал"
	L.unstable_essence_new = "Бомба каст"
	L.custom_on_unstable_essence_high = "Сообщения в чат о высоких стаках Нестабильной Сущности"
	L.custom_on_unstable_essence_high_desc = "Сообщать в чат о высоких стаках Нестабильной Сущности"
	L.volatile_spew = "Войдзоны"
	L.volatile_eruption = "Извержение"
	L.temporal_anomaly = "Шарик"
	L.temporal_anomaly_knocked = "Шарик откинут"
end

L = BigWigs:NewBossLocale("Assault of the Zaqali", "ruRU")
if L then
	-- These are in-game emotes and need to match the text shown in-game
	-- You should also replace the comment (--) with the full emote as it shows in-game
	L.zaqali_aide_north_emote_trigger = "северное укрепление" -- Помощники вождя поднимаются на северное укрепление!
	L.zaqali_aide_south_emote_trigger = "южное укрепление" -- Помощники вождя поднимаются на южное укрепление!

	L.north = "Север"
	L.south = "Юг"
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
	L.shadowlave_blast = "Фронтал"
	L.charged_smash = "Делёжка"
	L.energy_gained = "Получено энергии: %d"

	-- Mythic
	L.unleash_shadowflame = "Мифические орбы"
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
	L.custom_on_repeating_sunder_reality = "Повторяющиеся уведомления о Тёмном Уничтожении"
	L.custom_on_repeating_sunder_reality_desc = "Напоминать о касте Тёмного Уничтожения, пока вы не зайдёте в портал."

	L.twisted_earth = "Стены"
	L.echoing_fissure = "Разлом"
	L.rushing_darkness = "Линии отталкивания"

	L.umbral_annihilation = "Уничтожение"
	L.sunder_reality = "Порталы"
	L.ebon_destruction = "Большой взрыв"
end

L = BigWigs:NewBossLocale("Scalecommander Sarkareth", "ruRU")
if L then
	L.claws = "Танк дебафф" -- (Stage 1) Burning Claws / (Stage 2) Void Claws / (Stage 3) Void Slash
	L.claws_debuff = "Танк взрывается"
	L.emptiness_between_stars = "Забвение"
	L.void_slash = "Фронтал"

	--L.boss_immune = "Boss Immune"
	--L.ebon_might = "Adds Immune"
end
