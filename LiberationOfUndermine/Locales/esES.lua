local L = BigWigs:NewBossLocale("Cauldron of Carnage", "esES")
if not L then return end
if L then
	L.custom_on_fade_out_bars = "Desvanecer barras"
	L.custom_on_fade_out_bars_desc = "Desvanecer barras que pertenecen al jefe que esté fuera de rango"

	L.bomb_explosion = "Explosión de bomba"
	L.bomb_explosion_desc = "Muestra un temporizador para la explosión de las bombas"

	L.eruption_stomp = "Pisotón" -- Short for Eruption Stomp
	L.thunderdrum_salvo = "Rafaga" -- Short for Thunderdrum Salvo

	L.static_charge_high = "%d - Te estás moviendo demasiado"
end

L = BigWigs:NewBossLocale("Rik Reverb", "esES")
if L then
	L.amplification = "Amplificadores"
	L.echoing_chant = "Ecos"
	L.faulty_zap = "Descarga"
	L.sparkblast_ignition = "Barriles"
end

L = BigWigs:NewBossLocale("Stix Bunkjunker", "esES")
if L then
	L.rolled_on_you = "%s rodó sobre ti" -- PlayerX rolled over you
	L.rolled_from_you = "Rodaste sobre %s" -- (you) Rolled over PlayerX
	L.garbage_dump_message = "Golpeaste al jefe por %s daño"

	L.electromagnetic_sorting = "Clasificación" -- Short for Electromagnetic Sorting
	L.muffled_doomsplosion = "Explosión amortiguada"
	L.short_fuse = "Explosión de cangrejobús"
	L.incinerator = "Circulos de fuego"
end

L = BigWigs:NewBossLocale("Sprocketmonger Lockenstock", "esES")
if L then
	L.foot_blasters = "Minas"
	L.unstable_shrapnel = "Mine absorbida"
	L.screw_up = "Taladros"
	L.screw_up_single = "Taladro" -- Singular of Drills
	L.sonic_ba_boom = "Daño de raid"
	L.polarization_generator = "Colores"

	L.polarization_soon = "Color pronto: %s"
	L.polarization_soon_change = "CAMBIO de color pronto: %s"

	L.activate_inventions = "Activar: %s"
	L.blazing_beam = "Rayos"
	L.rocket_barrage = "Cohetes"
	L.mega_magnetize = "Imanes"
	L.jumbo_void_beam = "Rayos grandes"
	L.void_barrage = "Bolas"
	L.everything = "Todo"

	L.under_you_comment = "Debajo de ti" -- Implies this setting is for the damage from the ground effect under you
end

L = BigWigs:NewBossLocale("The One-Armed Bandit", "esES")
if L then
	L.rewards = "Premios" -- Fabulous Prizes
	L.rewards_desc = "Cuando dos fichas han sido elegidas, el \"Premio increíble\" se entrega.\nMensajes te dirán cual ha sido el premio.\nLa infobox te dira qué premios aún están disponibles"
	L.deposit_time = "Tiempo de depósito:" -- Timer that indicates how long you have left to deposit the tokens.

	L.pay_line = "Monedas"
	L.shock = "Descarga"
	L.flame = "Llama"
	L.coin = "Moneda"

	L.withering_flames = "Llamas" -- Short for Withering Flames

	L.cheat = "Activar: %s" -- Cheat: Coils, Cheat: Debuffs, Cheat: Raid Damage, Cheat: Final Cast
	L.linked_machines = "Bobinas"
	L.linked_machine = "Bobina" -- Singular of Coils
	L.hot_hot_heat = "Debuff calor"
	L.explosive_jackpot = "Casteo final"
end

L = BigWigs:NewBossLocale("Mug'Zee, Heads of Security", "esES")
if L then
	L.earthshaker_gaol = "Cárceles"
	L.frostshatter_boots = "Botas de escarcha" -- Short for Frostshatter Boots
	L.frostshatter_spear = "Lanza de escarcha" -- Short for Frostshatter Spears
	L.stormfury_finger_gun = "Pistola de dedo" -- Short for Stormfury Finger Gun
	L.molten_gold_knuckles = "Frontal de tanque"
	L.unstable_crawler_mines = "Minas"
	L.goblin_guided_rocket = "Cohete"
	L.double_whammy_shot = "Soak de tanque"
	L.electro_shocker = "Emisor de descargas"
end

L = BigWigs:NewBossLocale("Chrome King Gallywix", "esES")
if L then
	L.story_phase_trigger = "¿Creéis que habéis ganado?" -- What, you think you won? Nah, I got somethin' else for ya.

	L.scatterblast_canisters = "Soak de cono"
	L.fused_canisters = "Soaks de grupo"
	L.tick_tock_canisters = "Soaks"
	L.total_destruction = "DESTRUCCIÓN!"

	L.duds = "Torpedos" -- Short for 1500-Pound "Dud"
	L.all_duds_detontated = "Todos los torpedos detonados!"
	L.duds_remaining = "Quedan %d |4torpedo:torpedos;" -- 1 Dud Remains | 2 Duds Remaining
	L.duds_soak = "Soak torpedos (Quedan %d)"
end
