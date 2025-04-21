local L = BigWigs:NewBossLocale("Cauldron of Carnage", "esMX")
if not L then return end
if L then
	L.custom_on_fade_out_bars = "Barras que desaparecen"
	L.custom_on_fade_out_bars_desc = "Barras que desaparecen del jefe que esta fuera de rango."

	L.bomb_explosion = "Explosión de la bomba"
	L.bomb_explosion_desc = "Muestra el tiempo de explosión de la bomba."

	L.eruption_stomp = "Pisotón" -- Short for Eruption Stomp
	L.thunderdrum_salvo = "Salva" -- Short for Thunderdrum Salvo

	L.static_charge_high = "%d - Te estás moviendo mucho"
end

L = BigWigs:NewBossLocale("Rik Reverb", "esMX")
if L then
	L.amplification = "Amplificadores"
	L.echoing_chant = "Ecos Resonantes"
	L.faulty_zap = "Voltajes Persistentes"
	L.sparkblast_ignition = "Barriles"
end

L = BigWigs:NewBossLocale("Stix Bunkjunker", "esMX")
if L then
	L.rolled_on_you = "%s Te atropello A TI" -- PlayerX rolled over you
	L.rolled_from_you = "Atropellaste a %s" -- (you) Rolled over PlayerX
	L.garbage_dump_message = "Le pegaste al jefe por %s"

	L.electromagnetic_sorting = "Clasificación" -- Short for Electromagnetic Sorting
	L.muffled_doomsplosion = "Bomba explotada"
	L.short_fuse = "Explosión de Caparabomba"
	L.incinerator = "Circulos de fuego"
end

L = BigWigs:NewBossLocale("Sprocketmonger Lockenstock", "esMX")
if L then
	L.foot_blasters = "Minas"
	L.unstable_shrapnel = "Mina Pisada"
	L.screw_up = "Taladros"
	L.screw_up_single = "Taladro" -- Singular of Drills
	L.sonic_ba_boom = "Daño de banda"
	L.polarization_generator = "Colors"

	L.polarization_soon = "Cambio de color: %s"
	L.polarization_soon_change = "Cambio de color PRONTO: %s"

	L.activate_inventions = "Activando: %s"
	L.blazing_beam = "Rayos"
	L.rocket_barrage = "Misiles"
	L.mega_magnetize = "Imanes"
	L.jumbo_void_beam = "Rayos GRANDES"
	L.void_barrage = "Pelotas"
	L.everything = "TODO"

	L.under_you_comment = "Bajo tuyo" -- Implies this setting is for the damage from the ground effect under you
end

L = BigWigs:NewBossLocale("The One-Armed Bandit", "esMX")
if L then
	L.rewards = "Premios" -- Fabulous Prizes
	L.rewards_desc = "Cuando dos fichas se entregan, el \"Premio Fabuloso\" es repartido.\nMensajes te harán saber que premio ha sido entregado.\nEl cuadro de información te mostrará que premios aún están disponibles."
	L.deposit_time = "Tiempo para depositar:" -- Timer that indicates how long you have left to deposit the tokens.

	L.pay_line = "Monedas"
	L.shock = "Rayo"
	L.flame = "Llama"
	L.coin = "Moneda"

	L.withering_flames = "Llamas" -- Short for Withering Flames

	L.cheat = "Activando: %s" -- Cheat: Coils, Cheat: Debuffs, Cheat: Raid Damage, Cheat: Final Cast
	L.linked_machines = "Bobinas"
	L.linked_machine = "Bobina" -- Singular of Coils
	L.hot_hot_heat = "Calor Hipercaliente"
	L.explosive_jackpot = "Gran explosión"
end

L = BigWigs:NewBossLocale("Mug'Zee, Heads of Security", "esMX")
if L then
	L.earthshaker_gaol = "Prisiones"
	L.frostshatter_boots = "Botas de hielo" -- Short for Frostshatter Boots
	L.frostshatter_spear = "Lanzas de hielo" -- Short for Frostshatter Spears
	L.stormfury_finger_gun = "Dedos de rayo" -- Short for Stormfury Finger Gun
	L.molten_gold_knuckles = "Frontal de tanque"
	L.unstable_crawler_mines = "Minas"
	L.goblin_guided_rocket = "Misil grande"
	L.double_whammy_shot = "Detrás del tanque"
	L.electro_shocker = "Electrificador"
end

L = BigWigs:NewBossLocale("Chrome King Gallywix", "esMX")
if L then
	--L.story_phase_trigger = "What, you think you won?" -- What, you think you won? Nah, I got somethin' else for ya.

	L.scatterblast_canisters = "Cono frontal"
	L.fused_canisters = "Soak de grupo"
	L.tick_tock_canisters = "Soaks"
	L.total_destruction = "DESTRUCCIÓN!"

	L.duds = "DÑD" -- Short for 1500-Pound "Dud"
	L.all_duds_detontated = "TODAS las DÑD han sido explotadas!"
	L.duds_remaining = "%d |4DÑD faltante:DÑD faltantes;" -- 1 Dud Remains | 2 Duds Remaining
	L.duds_soak = "Pisa DÑD (%d vivas aún)"
end
