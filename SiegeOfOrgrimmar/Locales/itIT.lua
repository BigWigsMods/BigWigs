local L = BigWigs:NewBossLocale("Immerseus", "itIT")
if not L then return end
if L then
	L.win_yell = "Ah, you have done it!"
end

L = BigWigs:NewBossLocale("The Fallen Protectors", "itIT")
if L then
	L.defile = "Lancio Suolo Profanato"

	L.custom_off_bane_marks = "Parola d'Ombra: Flagello"
	L.custom_off_bane_marks_desc = "Per aiutare a dissipare, evidenzia chi ha Parola d'Ombra: Flagello su di loro con %s%s%s%s%s%s%s (in questo ordine)(possono non essere usati tutti i simboli), richiede capo incursione o assistente."

	L.no_meditative_field = "NESSUN Campo di Meditazione!"

	L.intermission = "Misure Disperate"
	L.intermission_desc = "Avvisa quando ti stai avvicinando ad un boss che sta lanciando Misure Disperate"

	L.inferno_self = "Assalto dell'Inferno su di te"
	L.inferno_self_desc = "Countdown Speciale quando Assalto dell'nferno è su di te."
	L.inferno_self_bar = "Stai Esplodendo!"
end

L = BigWigs:NewBossLocale("Norushen", "itIT")
if L then
	L.pre_pull = "Pre-ingaggio"
	L.pre_pull_desc = "Barra per la scenetta prima dell'ingaggio del boss"
	L.pre_pull_trigger = "Molto bene, creerò un campo di contenimento per la corruzione che vi affligge."

	L.big_adds = "Add Maggiori"
	L.big_adds_desc = "Avvisa quando uccidi gli Add Maggiori dentro/fuori"
	L.big_add = "Add Maggiore (%d)"
	L.big_add_killed = "Add Maggiore ucciso! (%d)"
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
	L.south_tower_trigger = "The door barring the South Tower has been breached!" --need check/translation
	L.south_tower = "Torre sud"
	L.north_tower_trigger = "The door barring the North Tower has been breached!" --need check/translation
	L.north_tower = "Torre nord"
	L.tower_defender = "DIfensore Torre"

	L.custom_off_shaman_marker = "Marcatore Sciamano"
	L.custom_off_shaman_marker_desc = "Per aiutare l'assegnazione delle interruzioni, evidenzia lo Sciamano delle Maree delle Fauci di Drago con %s%s%s%s%s%s%s (in questo ordine)(non tutti i simboli possono essere usati), richiede capo incursione o assistente."
end

L = BigWigs:NewBossLocale("Iron Juggernaut", "itIT")
if L then
	L.custom_off_mine_marks = "Marcatore delle Mine"
	L.custom_off_mine_marks_desc = "Per aiutare l'assegnazione degli assorbimenti, cerca di evidenziare le Mine Striscianti con %s%s%s%s%s (in questo ordine)(non tutti i simboli possono essere usati), richiede capo incursione o assistente."
end

L = BigWigs:NewBossLocale("Kor'kron Dark Shaman", "itIT")
if L then
	L.blobs = "Melme"

	L.custom_off_mist_marks = "Infestazione"
	L.custom_off_mist_marks_desc = "Per aiutare l'assegnazione delle cure, evidenzia i giocatori che hanno Infestazione su di loro con %s%s%s%s%s%s%s (in questo ordine)(possono non essere usati tutti i simboli), richiede capo incursione o assistente."
end

L = BigWigs:NewBossLocale("General Nazgrim", "itIT")
if L then
	L.custom_off_bonecracker_marks = "Colpo Incrinante"
	L.custom_off_bonecracker_marks_desc = "Per aiutare l'assegnazione delle cure, evidenzia i giocatori che hanno Colpo Incrinante su di loro con %s%s%s%s%s%s%s (in questo ordine)(possono non essere usati tutti i simboli), richiede capo incursione o assistente."

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
	L.custom_off_energy_marks_desc = "To help dispelling assignments, mark the people who have Displaced Energy on them with {rt1}{rt2}{rt3}{rt4}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
end

L = BigWigs:NewBossLocale("Spoils of Pandaria", "itIT")
if L then
	L.win_trigger = "System resetting. Don't turn the power off, or the whole thing will probably explode."

	L.matter_scramble_explosion = "Esplosione Scambio di Materia" -- shorten maybe?

	L.custom_off_mark_brewmaster = "Marcatore Mastro Birraio"
	L.custom_off_mark_brewmaster_desc = "Evidenzia il Mastro Birraio Antico con %s"
end

L = BigWigs:NewBossLocale("Thok the Bloodthirsty", "itIT")
if L then
	L.tank_debuffs = "Malefici Difensori"
	L.tank_debuffs_desc = "Avvisi per i vari tipi di malefici sui Difensori associati a Ruggito Temibile"

	L.cage_opened = "Gabbia Aperta"
end

L = BigWigs:NewBossLocale("Siegecrafter Blackfuse", "itIT")
if L then
	L.shredder_engage_trigger = "Un Segatronchi Automatizzato si avvicina!" -- needs verify
	L.laser_on_you = "Laser su di te PEW PEW!"
	L.laser_say = "Laser PEW PEW!"

	L.assembly_line_trigger = "Unfinished weapons begin to roll out on the assembly line."--need check/translation
	L.assembly_line_message = "Armi non finite (%d)"

	L.shockwave_missile_trigger = "Vi presento... la nuova, magnifica torretta lanciamissili a onda d'urto ST-03!" --need check
end

L = BigWigs:NewBossLocale("Paragons of the Klaxxi", "itIT")
if L then
	-- for getting all those calculate emotes:
	-- cat Transcriptor.lua | sed "s/\t//g" | grep -E "(CHAT_MSG_RAID_BOSS_EMOTE].*Iyyokuk)" | sed "s/.*EMOTE//" | sed "s/#/\"/" | sed "s/#.*/\"/" | sort | uniq
	L.one = "Iyyokuk selects: One!"
	L.two = "Iyyokuk selects: Two!"
	L.three = "Iyyokuk selects: Three!"
	L.four = "Iyyokuk selects: Four!"
	L.five = "Iyyokuk selects: Five!"
	-------------------------------------
	L.edge_message = "Sei uno dei limiti"
	L.custom_off_edge_marks = "Marcatori dei Limiti"
	L.custom_off_edge_marks_desc = "Evidenzia i giocatori che, dopo i calcoli, saranno i limiti di Confine Ardente con %s%s%s%s%s%s%s (in questo ordine)(possono non essere usati tutti i simboli), richiede capo incursione o assistente."
	L.injection_over_soon = "Fine di Iniezione tra poco (%s)!"
	L.custom_off_mutate_marks = "Mutazione: Marcatore Scorpione Mantid"
	L.custom_off_mutate_marks_desc = "Evidenzia il giocatore con Mutazione Scoprione Mantid con %s%s%s per aiutare l'assegnazione delle cure, richiede capo incursione o assistente."
end

L = BigWigs:NewBossLocale("Garrosh Hellscream", "itIT")
if L then
	L.intermission = "Intermezzo"
	L.mind_control = "Controllo della Mente"

	L.chain_heal_desc = "Cura un bersaglio amico per il 40% della sua vita massima, e a catena anche i bersagli amici vicini."
	L.chain_heal_message = "Il tuo focus sta lanciando Catena di Guarigione!"
	L.chain_heal_bar = "Focus: Catena di Guarigione"

	L.farseer_trigger = "Chiaroveggenti, guarite le nostre ferite!"
	L.custom_off_shaman_marker = "Marcatore Chiaroveggenti"
	L.custom_off_shaman_marker_desc = "Per aiutare l'assegnazione delle interruzioni, evidenzia i Cavalcalupi Chiaroveggenti con {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7} (in questo ordine, non tutti i simboli possono essere usati), richiede capo incursione o assistente."

	L.focus_only = "|cffff0000Avvisi solo dei bersagli focus.|r "
end

L = BigWigs:NewBossLocale("Siege of Orgrimmar Trash", "itIT")
if L then

end

