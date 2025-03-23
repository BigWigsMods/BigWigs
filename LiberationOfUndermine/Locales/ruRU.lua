local L = BigWigs:NewBossLocale("Cauldron of Carnage", "ruRU")
if not L then return end
if L then
	L.custom_on_fade_out_bars = "Скрывать полосы"
	L.custom_on_fade_out_bars_desc = "Скрывать полосы боссов вне ренджа."

	L.bomb_explosion = "Взрыв Бомбы"
	L.bomb_explosion_desc = "Показывать таймер взрыва бомбы."

	--L.eruption_stomp = "Stomp" -- Short for Eruption Stomp
	--L.thunderdrum_salvo = "Salvo" -- Short for Thunderdrum Salvo
end

L = BigWigs:NewBossLocale("Rik Reverb", "ruRU")
if L then
	L.amplification = "Усилители"
	L.echoing_chant = "Эхо"
	L.faulty_zap = "Разряды"
	L.sparkblast_ignition = "Бомбочки"
end

L = BigWigs:NewBossLocale("Stix Bunkjunker", "ruRU")
if L then
	L.ball_size_medium = "Средний Шар!"
	L.ball_size_large = "Большой Шапр!"
	L.rolled_on_you = "%s прокатился по ТЕБЕ" -- PlayerX rolled over you
	L.rolled_from_you = "Прокатился по %s" -- (you) Rolled over PlayerX
	L.garbage_dump_message = "ТЫ ударил босса на %s"

	L.electromagnetic_sorting = "Сортировка" -- Short for Electromagnetic Sorting
	L.muffled_doomsplosion = "Бомба поглощена"
	--L.short_fuse = "Bombshell Explosion"
	L.incinerator = "Огонь войды"
	L.landing = "Приземление" -- Landing down from the sky
end

L = BigWigs:NewBossLocale("Sprocketmonger Lockenstock", "ruRU")
if L then
	L.foot_blasters = "Мины"
	--L.unstable_shrapnel = "Mine Soaked"
	L.screw_up = "Буры"
	--L.screw_up_single = "Drill" -- Singular of Drills
	L.sonic_ba_boom = "Рейд урон"
	--L.polarization_generator = "Colors"

	--L.polarization_soon = "Color Soon: %s"
	--L.polarization_soon_change = "Color SWITCH Soon: %s"

	L.activate_inventions = "Активированы: %s"
	L.blazing_beam = "Лучи"
	L.rocket_barrage = "Ракеты"
	L.mega_magnetize = "Магниты"
	L.jumbo_void_beam = "Большие лучи"
	L.void_barrage = "Шарики"
	--L.everything = "Everything"

	--L.under_you_comment = "Under You" -- Implies this setting is for the damage from the ground effect under you
end

L = BigWigs:NewBossLocale("The One-Armed Bandit", "ruRU")
if L then
	L.rewards = "Призы" -- Fabulous Prizes
	L.rewards_desc = "После сдачи 2 токенов, \"Потрясающие Призы\" активируется.\nСообщения скажут, что было выдано.\nИнфобокс покажет, какие награды всё ещё доступны."
	L.deposit_time = "Время для сдачи" -- Timer that indicates how long you have left to deposit the tokens.

	L.pay_line = "Монетки"
	L.shock = "Шок"
	L.flame = "Огонь"
	L.coin = "Монета"

	--L.withering_flames = "Flames" -- Short for Withering Flames

	--L.cheat = "Activate: %s" -- Cheat: Coils, Cheat: Debuffs, Cheat: Raid Damage, Cheat: Final Cast
	--L.linked_machines = "Coils"
	--L.linked_machine = "Coil" -- Singular of Coils
	--L.hot_hot_heat = "Hot Debuffs"
	--L.explosive_jackpot = "Final Cast"
end

L = BigWigs:NewBossLocale("Mug'Zee, Heads of Security", "ruRU")
if L then
	L.earthshaker_gaol = "Темницы"
	L.frostshatter_boots = "Сапоги льда" -- Short for Frostshatter Boots
	L.frostshatter_spear = "Ледяные копья" -- Short for Frostshatter Spears
	L.stormfury_finger_gun = "Палец-пушка" -- Short for Stormfury Finger Gun
	L.molten_gold_knuckles = "Танк фронтал"
	L.unstable_crawler_mines = "Мины"
	L.goblin_guided_rocket = "Ракета"
	L.double_whammy_shot = "Танк Соак"
	--L.electro_shocker = "Shocker"
end

L = BigWigs:NewBossLocale("Chrome King Gallywix", "ruRU")
if L then
	--L.story_phase_trigger = "What, you think you won?" -- What, you think you won? Nah, I got somethin' else for ya.

	L.scatterblast_canisters = "Конус делёжка"
	L.fused_canisters = "Групповая делёжка"
	L.tick_tock_canisters = "Делёжка"
	--L.total_destruction = "DESTRUCTION!"

	L.duds = "Ждуны" -- Short for 1500-Pound "Dud"
	L.all_duds_detontated = "Все Ждуны Детонированы!"
	L.duds_remaining = "%d |4Ждун осталось:Ждуны осталось;" -- 1 Dud Remains | 2 Duds Remaining
	L.duds_soak = "Сокай Ждунов (%d осталось)"
end
