local L = BigWigs:NewBossLocale("Jin'rokh the Breaker", "itIT")
if not L then return end
if L then
	L.storm_duration = "Durata Tempesta di Fulmini"
	L.storm_duration_desc = "Una barra di avviso separata per la durata del lancio di Tempesta di Fulmini"

	L.in_water = "Sei nell'acqua!"
end

L = BigWigs:NewBossLocale("Horridon", "itIT")
if L then
	L.charge_trigger = "sets his eyes" -- Horridon sets his eyes on PLAYERNAME and stamps his tail!

	L.chain_lightning_message = "Il tuo focus sta lanciando Catena di Fulmini!"
	L.chain_lightning_bar = "Focus: Catena di Fulmini"

	L.fireball_message = "Il tuo focus sta lanciando Palla di Fuoco!"
	L.fireball_bar = "Focus: Palla di Fuoco"

	L.venom_bolt_volley_message = "Il tuo Focus sta lanciando Raffica Venefica!"
	L.venom_bolt_volley_bar = "Focus: Raffica Venefica"

	L.adds = "Adds in arrivo"
	L.adds_desc = "Avvisa quando sono in arrivo i vari add dei Farraki, dei Gurubashi, dei Drakkari, degli Amani, e il Dio della Guerra Jalak."

	L.orb_message = "Globo del Controllo a Terra!"

	--L.puncture_message = "Perforazione Tripla" Commented out since there isnt anymore into Locals, Keep it for lazyness.
 	L.focus_only = "|cffff0000Avviso solo per il bersaglio Focus.|r "

	L.door_opened = "Porta Aperta!"
	L.door_bar = "Prossima porta (%d)"
	L.balcony_adds = "Add dal Balcone"
	L.door_trigger = "pour" -- "<160.1 21:33:04> CHAT_MSG_RAID_BOSS_EMOTE#Farraki forces pour from the Farraki Tribal Door!#War-God Jalak#####0#0##0#1107#nil#0#false#false", -- [1]
end

L = BigWigs:NewBossLocale("Council of Elders", "itIT")
if L then
	L.priestess_adds = "Add Sacerdotessa"
	L.priestess_adds_desc = "Avviso per tutti i tipi di add della Gran Sacerdotessa Mar'li"
	L.priestess_adds_message = "Add Sacerdotessa"

	L.assault_stun = "Tank Stunned!"
	L.full_power = "Pieno Potere"
	L.assault_message = "Assalto"
	L.hp_to_go_power = "Punti Vita alla Fine: %d%% - Potere: %d"

	L.custom_on_markpossessed = "Evidenzia Boss Posseduto"
	L.custom_on_markpossessed_desc = "Evidenzia il Boss posseduto con un teschio."
end

L = BigWigs:NewBossLocale("Tortos", "itIT")
if L then
	L.kick = "Calcio"
	L.kick_desc = "Tieni il conto di quante tartarughe possono essere prese a calci"
	L.kick_message = "Tartarughe Calciabili: %d"

	L.crystal_shell_removed = "Scudo di Cristallo RIMOSSO!"
	L.no_crystal_shell = "NESSUNO Scudo di Cristallo"
end

L = BigWigs:NewBossLocale("Megaera", "itIT")
if L then
	L.breaths = "Soffi"
	L.breaths_desc = "Avvisi relativi ad ogni tipo di soffio possibile."
	--L.rampage_over = "Furia Terminata!" Commented out since there isnt anymore into Locals, Keep it for lazyness.
	L.arcane_adds = "Teste Arcane"
end

L = BigWigs:NewBossLocale("Ji-Kun", "itIT")
if L then
	L.flight_over = "Termine del Volo"
	L.young_egg_hatching = "Schiusura Uova Giovani"
	L.lower_hatch_trigger = "Le uova in uno dei nidi più bassi iniziano a schiudersi!" --da controllare
	L.upper_hatch_trigger = "Le uova in uno dei nidi più alti iniziano a schiudersi!" -- da controllare
	L.upper_nest = "Nido |c00008000Superiore|r"
	L.lower_nest = "Nido |c00FF0000Inferiore|r"
	L.lower_upper_nest = "Nido |c00FF0000Inferiore|r + |c00008000Superiore|r"
	--L.food_call_trigger = "Hatchling calls for food!" --da tradurre / Commented out since there isnt anymore into Locals, Keep it for lazyness.
	L.nest = "Nidi"
	L.nest_desc = "Avvisi relativi ai nidi. |c00FF0000Deselezionalo per spengere gli avvisi, se non sei designato a gestire i nidi!|r"
	L.big_add_message = "Add Grande su %s"
end

L = BigWigs:NewBossLocale("Durumu the Forgotten", "itIT")
if L then
	L.rays_spawn = "Apparizione raggi"
	--L.ray_controller = "Controllore del Raggio" Commented out since there isnt anymore into Locals, Keep it for lazyness.
	--L.ray_controller_desc = "Annuncia la direzione del raggio del controllore per il raggio blu e rosso." Commented out since there isnt anymore into Locals, Keep it for lazyness.

	--L.red_ray_controller = "Sei il controllore del raggio |c000000FFBlu|r" Commented out since there isnt anymore into Locals, Keep it for lazyness.
	--L.blue_ray_controller = "Sei il controllore del raggio |c00FF0000Rosso|r" Commented out since there isnt anymore into Locals, Keep it for lazyness.
	L.red_spawn_trigger = "The Infrared Light reveals a Crimson Fog!"
	L.blue_spawn_trigger = "The Blue Rays reveal an Azure Eye!"
	L.red_add = "Add |c00FF0000Rosso|r"
	L.blue_add = "Add |c000000FFBlu|r"
	L.clockwise = "Senso Orario"
	L.counter_clockwise = "Senso Antiorario"
	L.death_beam = "Raggio Disintegratore"

	L.custom_off_ray_controllers = "Controllori dei Raggi"
	L.custom_off_ray_controllers_desc = "Usa le icone di incursione %s, %s, %s per evidenziare i giocatori che controllano le posizioni dei raggi e il loro movimento."
end

L = BigWigs:NewBossLocale("Primordius", "itIT")
if L then
	L.stream_of_blobs = "Ondata di Fluidi"
	L.mutations = "Mutazioni"
end

L = BigWigs:NewBossLocale("Dark Animus", "itIT")
if L then
	L.engage_trigger = "Il globo esplode!"
	L.slam_message = "Colpo"
end

L = BigWigs:NewBossLocale("Iron Qon", "itIT")
if L then
	L.molten_energy = "Energia Fusa"

	L.overload_casting = "Lancio Sovraccarico Fuso"
	L.overload_casting_desc = "Avvisa quando viene lanciato Sovraccarico Fuso"

	L.arcing_lightning_cleared = "Fulmine Arcuato non più presente sull'Incursione"
end

L = BigWigs:NewBossLocale("Twin Consorts", "itIT")
if L then
	L.barrage_fired = "Raffica Lanciata!"
	L.last_phase_yell_trigger = "Just this once..." -- "<490.4 01:24:30> CHAT_MSG_MONSTER_YELL#Just this once...#Lu'lin###Suen##0#0##0#3273#nil#0#false#false", -- [6]
end

L = BigWigs:NewBossLocale("Lei Shen", "itIT")
if L then
	L.conduit_abilities = "Abilità dei Condotti"
	L.conduit_abilities_desc = "Barre di recupero approssimative per le abilità specifiche dei condotti"
	L.conduit_ability_meassage = "Abilità successiva del condotto"

	L.intermission = "Intermezzo"
	L.overchargerd_message = "Pulsazione ad Effetto Stordente"
	L.static_shock_message = "Danno ad Effetto da Suddividere"
	L.diffusion_add_message = "Add di Diffusione"
	L.diffusion_chain_message = "Add di Diffusione tra poco - ALLARGARSI!!!"
end

L = BigWigs:NewBossLocale("Ra-den", "itIT")
if L then

end
