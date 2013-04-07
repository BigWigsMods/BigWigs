local L = BigWigs:NewBossLocale("Jin'rokh the Breaker", "itIT")
if not L then return end
if L then
	L.storm_duration = "Durata Tempesta di Fulmini"
	L.storm_duration_desc = "Una barra di avviso separata per la durata del lancio di Tempesta di Fulmini"
	L.storm_short = "Tempesta"

	L.in_water = "Sei nell'acqua!"
end

L = BigWigs:NewBossLocale("Horridon", "itIT")
if L then
	L.charge_trigger = "posa il suo sguardo" -- Horridon sets his eyes on PLAYERNAME and stamps his tail! Horridon posa il suo sguardo su PLAYER e sbatte la coda!
	L.door_trigger = "irrompono" -- "<160.1 21:33:04> CHAT_MSG_RAID_BOSS_EMOTE#Farraki forces pour from the Farraki Tribal Door!#War-God Jalak#####0#0##0#1107#nil#0#false#false", -- [1]

	L.chain_lightning_message = "Il tuo focus sta lanciando Catena di Fulmini!"
	L.chain_lightning_bar = "Focus: Catena di Fulmini"

	L.fireball_message = "Il tuo focus sta lanciando Palla di Fuoco!"
	L.fireball_bar = "Focus: Palla di Fuoco"

	L.venom_bolt_volley_message = "Il tuo Focus sta lanciando Raffica Venefica!"
	L.venom_bolt_volley_bar = "Focus: Raffica Venefica"

	L.adds = "Adds in arrivo"
	L.adds_desc = "Avvisa quando sono in arrivo i vari add dei Farraki, dei Gurubashi, dei Drakkari, degli Amani, e il Dio della Guerra Jalak."

	L.door_opened = "Porta Aperta!"
	L.door_bar = "Prossima porta (%d)"
	L.balcony_adds = "Add dal Balcone"
	L.orb_message = "Globo del Controllo a Terra!"

	--L.puncture_message = "Perforazione Tripla" Commented out since there isnt anymore into Locals, Keep it for lazyness.
 	L.focus_only = "|cffff0000Avviso solo per il bersaglio Focus.|r "

end

L = BigWigs:NewBossLocale("Council of Elders", "itIT")
if L then
	L.priestess_adds = "Add Sacerdotessa"
	L.priestess_adds_desc = "Avviso per tutti i tipi di add della Gran Sacerdotessa Mar'li"
	L.priestess_adds_message = "Add Sacerdotessa"

	L.assault_stun = "Difensore Stordito!"
	L.full_power = "Pieno Potere"
	L.assault_message = "Assalto"
	L.hp_to_go_power = "Punti Vita alla Fine %d%%! (Potenza: %d)"
	L.hp_to_go_fullpower = "Punti Vita alla Fine %d%%! (Piena Potenza)"

	L.custom_on_markpossessed = "Evidenzia Boss Posseduto"
	L.custom_on_markpossessed_desc = "Evidenzia il Boss posseduto con un teschio."
end

L = BigWigs:NewBossLocale("Tortos", "itIT")
if L then
	L.bats_desc = "Tanti pipistrelli. Dai una mano."

	L.kick = "Calcio"
	L.kick_desc = "Tieni il conto di quante tartarughe possono essere prese a calci"
	L.kick_message = "Tartarughe Calciabili: %d"

	L.custom_off_turtlemarker = "Selezionatore Tartarughe"
	L.custom_off_turtlemarker_desc = "Evidenzia le tartarughe usando tutti i simboli dell'incursione.\n|cFFFF0000Solo una persona dovrebbe abilitare questa opzione per evitare conflitti nella marcatura.|r\n|cFFADFF2FSUGGERIMENTO: Se l'Incursione ha scelto te per abilitare questa opzione, muovere velocemente il mouse sopra le tartarughe è il modo più rapido per marcarle.|r"
	L.no_crystal_shell = "NESSUNO Scudo di Cristallo"
end

L = BigWigs:NewBossLocale("Megaera", "itIT")
if L then
	L.breaths = "Soffi"
	L.breaths_desc = "Avvisi relativi ad ogni tipo di soffio possibile."
	L.arcane_adds = "Teste Arcane"
end

L = BigWigs:NewBossLocale("Ji-Kun", "itIT")
if L then
	L.lower_hatch_trigger = "Le uova in uno dei nidi inferiori iniziano a schiudersi!" 
	L.upper_hatch_trigger = "Le uova in uno dei nidi superiori iniziano a schiudersi!" 

	L.nest = "Nidi"
	L.nest_desc = "Avvisi relativi ai nidi. |cffff0000Deselezionalo per spengere gli avvisi, se non sei designato a gestire i nidi!|r"

	L.flight_over = "Termine del Volo per %d sec!"
	L.upper_nest = "Nido |cff008000Superiore|r"
	L.lower_nest = "Nido |cffff0000Inferiore|r"
	L.up = "SOPRA"
	L.down = "SOTTO"
	L.add = "Add"
	L.big_add_message = "Add Grande su %s"
end

L = BigWigs:NewBossLocale("Durumu the Forgotten", "itIT")
if L then
	L.red_spawn_trigger = "Nebbia Cremisi" -- "The Infrared Light reveals a Crimson Fog!"
	L.blue_spawn_trigger = "Nebbia Azzurra" -- "The Blue Rays reveal an Azure Fog!"
	L.yellow_spawn_trigger = "Nebbia d'Ambra" -- "The Bright Light reveals an Amber Fog!"

	L.adds = "Rivela Adds"
	L.adds_desc = "Avvisa quando rivela una Nebbia Cremisi, d'ambra o Azzurra e quante Nebbie d'Ambra rimangono."

	L.custom_off_ray_controllers = "Controllori dei Raggi"
	L.custom_off_ray_controllers_desc = "Usa le icone di incursione %s%s%s per evidenziare i giocatori che controllano le posizioni dei raggi e il loro movimento.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"

	L.custom_off_parasite_marks = "Marcatore Parassita Oscuro"
	L.custom_off_parasite_marks_desc = "Per aiutare l'assegnazione dei Guaritori, evidenzia i giocatori che hanno il Parassita Oscuro con %s%s%s.\n|cFFFF0000Solo 1 giocatore dell'incursione dovrebbe aver abilitato questa opzione per evitare conflitti sui marcamenti.|r"

	L.initial_life_drain = "Lancio iniziale Risucchio di Vita"
	L.initial_life_drain_desc = "Messaggio per il primo lancio di Risucchio di Vita per aiutare le cure su colui che ha il maleficio sulle cure ricevute."

	L.life_drain_say = "%dx Risucchiato"

	L.rays_spawn = "Apparizione raggi"
	L.red_add = "Add |cffff0000Rosso|r"
	L.blue_add = "Add |cff0000ffBlu|r"
	L.yellow_add = "Add |cffffff00Giallo|r"
	L.death_beam = "Raggio Disintegratore"
	L.red_beam = "Raggio |cffff0000Rosso|r"
	L.blue_beam = "Raggio |cff0000ffBlu|r"
	L.yellow_beam = "Raggio |cffffff00Giallo|r"
end

L = BigWigs:NewBossLocale("Primordius", "itIT")
if L then
	L.mutations = "Mutazioni |cff008000(%d)|r |cffff0000(%d)|r"
	L.acidic_spines = "Spine Acide (Danno ad Area)"	
end

L = BigWigs:NewBossLocale("Dark Animus", "itIT")
if L then
	L.engage_trigger = "Il globo esplode!"

	L.siphon_power = "Aspirazione dell'Anima (%d%%)"
	L.siphon_power_soon = "Aspirazione dell'Anima (%d%%) %s tra poco!"
	L.font_empower = "Fonte dell'Anima + Golem Potenziato"
	L.slam_message = "Urto Esplosivo"
end

L = BigWigs:NewBossLocale("Iron Qon", "itIT")
if L then
	L.molten_energy = "Energia Fusa"

	L.overload_casting = "Lancio Sovraccarico Fuso"
	L.overload_casting_desc = "Avvisa quando viene lanciato Sovraccarico Fuso"

	L.arcing_lightning_cleared = "Fulmine Arcuato non più presente sull'Incursione"

	L.custom_off_spear_target = "Bersaglio Tiro Lancia"
	L.custom_off_spear_target_desc = "Cerca di avvisare il bersaglio di Tiro Lancia. Questo metodo è molto esigente in quanto all'uso di CPU e a volte mostra il bersaglio errato quindi è disabilitato per default.\n|cFFADFF2FTIP: Impostare il ruolo di DIFENSORE dovrebbe aiutare l'accuratezza dell'avviso.|r"
	L.possible_spear_target = "Possibile Lancia"
end

L = BigWigs:NewBossLocale("Twin Consorts", "itIT")
if L then
	L.barrage_fired = "Raffica Lanciata!"
	L.last_phase_yell_trigger = "Just this once..." -- "<490.4 01:24:30> CHAT_MSG_MONSTER_YELL#Just this once...#Lu'lin###Suen##0#0##0#3273#nil#0#false#false", -- [6]
end

L = BigWigs:NewBossLocale("Lei Shen", "itIT")
if L then
	L.custom_off_diffused_marker = "Marcatore Fulmine Diffuso Marker"
	L.custom_off_diffused_marker_desc = "Marca gli add Fulmine Diffuso usando tutte le icone dell'incursione, richiede capogruppo o assistente.\n|cFFFF0000Solo 1 persona nell'incursione dovrebbe attivare questa opzione per evitare conflitti di marcamento.|r\n|cFFADFF2FTIP: Se l'incursione ha scelto te attivalo, e muovi velocemente il mouse sopra OGNI add per marcarli più velocemente possibile.|r"

	L.stuns = "Disorientamenti"
	L.stuns_desc = "Mostra delle barre per la durata dei disorientamenti, da usare per la gestione dei Fulmini Globulari."

	L.aoe_grip = "Attrazione ad Area"
	L.aoe_grip_desc = "Avvisa quando un cavaliere della Morte usa Presa di Malacarne, da usare per la gestione dei Fulmini Globulari."

	L.last_inermission_ability = "Ultima abilità intermezzo usata!"
	L.safe_from_stun = "Sei probabilmente al sicuro dai disorientamenti di Sovraccarico"
	L.intermission = "Intermezzo"
	L.diffusion_add = "Add di Diffusione"
	L.shock = "Folgore"
end

L = BigWigs:NewBossLocale("Ra-den", "itIT")
if L then

end

L = BigWigs:NewBossLocale("Trash", "itIT")
if L then
	L.stormcaller = "Invocatore delle Tempeste Zandalari"
	L.stormbringer = "Araldo della Tempesta Draz'kil"
	L.monara = "Monara"
end

