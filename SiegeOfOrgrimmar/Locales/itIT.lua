local L = BigWigs:NewBossLocale("Immerseus", "itIT")
if not L then return end
if L then
--@localization(locale="itIT", namespace="SiegeOfOrgrimmar/Immerseus", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("The Fallen Protectors", "itIT")
if L then
	L.defile = "Lancio Suolo Profanato"

	L.custom_off_bane_marks = "Parola d'Ombra: Flagello"
	L.custom_off_bane_marks_desc = "Per aiutare a dissipare, evidenzia chi ha Parola d'Ombra: Flagello su di loro con {rt1}{rt2}{rt3}{rt4}{rt5} (in questo ordine, possono non essere usati tutti i simboli), richiede capo incursione o assistente."

	L.no_meditative_field = "NESSUN Campo di Meditazione!"

	L.intermission = "Misure Disperate"
	L.intermission_desc = "Avvisa quando ti stai avvicinando ad un boss che sta lanciando Misure Disperate"

	L.inferno_self = "Assalto dell'Inferno su di te"
	L.inferno_self_desc = "Countdown Speciale quando Assalto dell'nferno è su di te."
	L.inferno_self_bar = "Stai Esplodendo!"
end

L = BigWigs:NewBossLocale("Norushen", "itIT")
if L then
--@localization(locale="itIT", namespace="SiegeOfOrgrimmar/Norushen", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("Sha of Pride", "itIT")
if L then
	L.custom_off_titan_mark = "Marcatore Potenza dei Titani"
	L.custom_off_titan_mark_desc = "Evidenzia i giocatori con Dono dei Titani con {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8}, richiede capoincursione o assistente.\n|cFFFF0000Soltanto 1 dei giocatori nell'incursione dovrebbe tenere abilitata questa opzione per evitare conflitti di marcamento.|r"

	L.projection_message = "Vai verso la freccia |cFF00FF00VERDE|r!"
	L.projection_explosion = "Proiezione esplosione"

	L.big_add_bar = "Add Maggiore"
	L.big_add_spawning = "Add Maggiore in arrivo!"
	L.small_adds = "Add Minori"

	L.titan_pride = "Titano+Orgoglio: %s"
end

L = BigWigs:NewBossLocale("Galakras", "itIT")
if L then
	L.demolisher = "Demolitori"
	L.demolisher_desc = "Timer per l'arrivo in combattimento dei Demolitori Kor'kron"

	L.towers = "Torri"
	L.towers_desc = "Avvisa quando le torri vengono distrutte"
	L.south_tower_trigger = "La porta a protezione della torre a sud è stata sfondata!" --checked
	L.south_tower = "Torre sud"
	L.north_tower_trigger = "La porta a protezione della torre a nord è stata sfondata!" --checked
	L.north_tower = "Torre nord"
	L.tower_defender = "DIfensore Torre"

	--L.adds_desc = "Timers for when a new set of adds enter the fight."
	--L.adds_trigger1 = "Bring her down quick so I can wrap my fingers around her neck." -- Lady Sylvanas Windrunner
	--L.adds_trigger2 = "Here they come!" -- Lady Jaina Proudmoore
	--L.adds_trigger3 = "Dragonmaw, advance!"
	--L.adds_trigger4 = "For Hellscream!"
	--L.adds_trigger5 = "Next squad, push forward!"

	L.custom_off_shaman_marker = "Marcatore Sciamano"
	L.custom_off_shaman_marker_desc = "Per aiutare l'assegnazione delle interruzzioni, evidenzia gli Sciamani delle Maree delle Fauci di Drago con {rt1}{rt2}{rt3}{rt4}{rt5}, richiede capo incursione o assistente.\n|cFFFF0000Solo 1 persona nell'incursione dovrebbe attivare questa opzione per evitare conflitti con le assegnazioni.|r\n|cFFADFF2FSUGGERIMENTO: Se l'Incursione ha scelto te per abilitare questa opzione, muovere velocemente il mouse sopra gli sciamani è il modo più rapido per evidenziarli.|r"
end

L = BigWigs:NewBossLocale("Iron Juggernaut", "itIT")
if L then
	L.custom_off_mine_marks = "Marcatore delle Mine"
	L.custom_off_mine_marks_desc = "Per aiutare l'assegnazione degli assorbimenti, evidenzia le Mine Striscianti con {rt1}{rt2}{rt3}, richiede capo incursione o assistente.\n|cFFFF0000Solo 1 persona nell'incursione dovrebbe attivare questa opzione per evitare conflitti con le assegnazioni.|r\n|cFFADFF2FSUGGERIMENTO: Se l'Incursione ha scelto te per abilitare questa opzione, muovere velocemente il mouse sopra tutte le mine è il modo più rapido per evidenziarle.|r"
end

L = BigWigs:NewBossLocale("Kor'kron Dark Shaman", "itIT")
if L then
	L.blobs = "Melme"

	L.custom_off_mist_marks = "Marcatore Nebbia Tossica"
	L.custom_off_mist_marks_desc = "Per aiutare l'assegnazione delle cure, evidenzia i giocatori che hanno Nebbia Tossica con {rt1}{rt2}{rt3}{rt4}{rt5}, richiede capo incursione o assistente.\n|cFFFF0000Solo 1 persona nell'incursione dovrebbe attivare questa opzione per evitare conflitti con le assegnazioni.|r"
end

L = BigWigs:NewBossLocale("General Nazgrim", "itIT")
if L then
	L.custom_off_bonecracker_marks = "Marcatore Colpo Incrinante"
	L.custom_off_bonecracker_marks_desc = "Per aiutare l'assegnazione delle cure, evidenzia i giocatori che hanno Colpo Incrinante su di loro con {rt1}{rt2}{rt3}{rt4}{rt5}, richiede capo incursione o assistente.\n|cFFFF0000Solo 1 persona nell'incursione dovrebbe attivare questa opzione per evitare conflitti con le assegnazioni.|r"

	L.stance_bar = "%s (ADESSO: %s)"
	L.battle = "Battaglia"
	L.berserker = "Berserker"
	L.defensive = "Difesa"

	L.adds_trigger1 = "Difendete il cancello!" --all triggers verified
	L.adds_trigger2 = "Radunate le forze!"
	L.adds_trigger3 = "Prossima squadra, al fronte!"
	L.adds_trigger4 = "Guerrieri, in marcia!"
	L.adds_trigger5 = "Kor'kron, con me!"
	L.adds_trigger_extra_wave = "Tutti i Kor'kron... al mio comando... uccideteli... ORA"
	L.extra_adds = "Armate Aggiuntive"

	L.chain_heal_message = "Il tuo focus sta lanciando Catena di Guarigione Potenziata!"

	L.arcane_shock_message = "Il tuo focus sta lanciando Folgore Arcana!"

	L.focus_only = "|cffff0000Avvisi solo dei bersagli focus.|r "
end

L = BigWigs:NewBossLocale("Malkorok", "itIT")
if L then
	L.custom_off_energy_marks = "Marcatore Energia Dispersa"
	L.custom_off_energy_marks_desc = "Per aiutare l'assegnazione dei dissolvimenti, evidenzia i giocatori che hanno Energia Diffusa su di loro con {rt1}{rt2}{rt3}{rt4}, richiede capoincursione o assistente.\n|cFFFF0000Solo 1 persona nell'incursione dovrebbe attivare questa opzione per evitare conflitti con le assegnazioni.|r"
end

L = BigWigs:NewBossLocale("Spoils of Pandaria", "itIT")
if L then
	L.win_trigger = "Riavvio del sistema. Non staccare la corrente o potrebbe saltare tutto in aria."

	L.enable_zone = "Immagazzinamento Artefatti"
	L.matter_scramble_explosion = "Esplosione Scambio di Materia" -- shorten maybe?
end

L = BigWigs:NewBossLocale("Thok the Bloodthirsty", "itIT")
if L then
--@localization(locale="itIT", namespace="SiegeOfOrgrimmar/ThokTheBloodthirsty", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("Siegecrafter Blackfuse", "itIT")
if L then
	L.overcharged_crawler_mine = "Mina Strisciante Sovraccaricata" -- sadly this is needed since they have same mobId
	L.custom_off_mine_marker = "Marcatore delle Mine"
	L.custom_off_mine_marker_desc = "Evidenzia le mine per l'assegnazione specifica degli incapacitamenti (Vengono utilizzati tutti i simboli)"

	L.saw_blade_near_you = "Lama Rotante vicino a te (non su di te)"
	L.saw_blade_near_you_desc = "Potresti disabilitare questa opzione ed evitare spam inutile di messaggi se la vostra incursione preferisce usare una tattica in cui state molto ammassati."

	L.disabled = "Disabilitato"

	L.shredder_engage_trigger = "Un Segatronchi Automatizzato si avvicina!" -- verified
	L.laser_on_you = "Laser su di te PEW PEW!"
	L.laser_say = "Laser PEW PEW"

	L.assembly_line_trigger = "Armi incomplete iniziano a uscire dalla catena di montaggio." --verified
	L.assembly_line_message = "Armi non finite (%d)"
	L.assembly_line_items = "Oggetti (%d): %s"
	L.item_missile = "Missile"
	L.item_mines = "Mines"
	L.item_laser = "Laser"
	L.item_magnet = "Magnete"

	L.shockwave_missile_trigger = "Vi presento... la nuova, magnifica torretta lanciamissili a onda d'urto ST-03!" --verified
end

L = BigWigs:NewBossLocale("Paragons of the Klaxxi", "itIT")
if L then
	L.catalyst_match = "Catalizzatore: |c%sHA SCELTO TE|r" -- might not be best for colorblind?
	L.you_ate = "Hai mangiato un parassita (%d rimasti)"
	L.other_ate = "%s ha mangiato un %sparassita (%d rimasti)"
	L.parasites_up = "%d |4Parassita:Parassiti; attivi"
	L.dance = "Danza"
	L.prey_message = "Usa Preda sul Parassita"
	L.one = "Iyyokuk seleziona: Uno!"
	L.two = "Iyyokuk seleziona: Due!"
	L.three = "Iyyokuk seleziona: Tre!"
	L.four = "Iyyokuk seleziona: Quattro!"
	L.five = "Iyyokuk seleziona: Cinque!"
	L.edge_message = "Sei uno dei limiti"
	L.custom_off_edge_marks = "Marcatori dei Limiti"
	L.custom_off_edge_marks_desc = "Evidenzia i giocatori che saranno i limiti in base ai calcoli {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8}, richiede capoincursione o assistente.\n|cFFFF0000Solo 1 persona nell'incursione dovrebbe attivare questa opzione per evitare conflitti con le assegnazioni.|r"
	L.injection_over_soon = "Fine di Iniezione tra poco (%s)!"
	L.custom_off_parasite_marks = "Marcatore Parassita"
	L.custom_off_parasite_marks_desc = "Evidenzia i parassiti da controllare e le assegnazioni di Preda con {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}, richiede capoincursione o assistente.\n|cFFFF0000Solo 1 persona nell'incursione dovrebbe attivare questa opzione per evitare conflitti con le assegnazioni.|r"
end

L = BigWigs:NewBossLocale("Garrosh Hellscream", "itIT")
if L then
	L.manifest_rage = "Manifestazione della Rabbia"
	L.manifest_rage_desc = "Quando Garrosh raggiungwe 100 inizierà a prelanciare Manifestazione della Rabbia per 2 secondi, e poi la canalizzerà. Mentre canalizza, evoca degli add grandi. Porta la Pirostella su Garrosh per incapacitarlo ed interrompere il suo lancio."

	L.phase_3_end_trigger = "Pensate di aver VINTO? Siete CIECHI. VI COSTRINGERÒ AD APRIRE GLI OCCHI."

	L.clump_check = "Controllo ammucchiamento"
	L.clump_check_desc = "Controlla ogni 3 secondi durante il Bombardamento i giocatori ammucchiati, se viene rilevato un gruppo, verrà creata una Pirostella Kor'kron."
	L.clump_check_warning = "Rilevato ammucchiamento, Pirostella in arrivo"

	L.bombardment = "Bombardmento"
	L.bombardment_desc = "Bombardamendo di Roccavento che lascia dei fuochi sul terreno. Le Pirostelle Kor'kron possono apparire soltanto durante il bombardmento."

	L.intermission = "Intermezzo"
	L.mind_control = "Controllo della Mente"
	L.empowered_message = "%s adesso è potenziato!"

	L.ironstar_impact_desc = "Una barra a tempo per quando la Pirostella si schianterà contro l'altra parte della stanza."
	L.ironstar_rolling = "Pirostella in movimento!"

	L.chain_heal_desc = "Cura un bersaglio amico per il 40% della sua vita massima, e a catena anche i bersagli amici vicini."
	L.chain_heal_message = "Il tuo focus sta lanciando Catena di Guarigione!"
	L.chain_heal_bar = "Focus: Catena di Guarigione"

	L.farseer_trigger = "Chiaroveggenti, guarite le nostre ferite!"
	L.custom_off_shaman_marker = "Marcatore Chiaroveggenti"
	L.custom_off_shaman_marker_desc = "Per aiutare l'assegnazione delle interruzioni, evidenzia i Cavalcalupi Chiaroveggenti con {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7} (in questo ordine, non tutti i simboli possono essere usati), richiede capo incursione o assistente."

	L.custom_off_minion_marker = "Marcatore servitori"
	L.custom_off_minion_marker_desc = "Per aiutare a separare i servitori, evidenziali con {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8}, richiede capoincursione o assistente."

	L.focus_only = "|cffff0000Avvisi solo dei bersagli focus.|r "
end

