local L = BigWigs:NewBossLocale("Shriekwing", "itIT")
if not L then return end
if L then
	L.pickup_lantern = "%s ha raccolto la lanterna!"
	L.dropped_lantern = "Lantern lasciata da %s!"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "itIT")
if L then
	L.killed = "%s Ucciso"
end

L = BigWigs:NewBossLocale("Sun King's Salvation", "itIT")
if L then
	L.shield_removed = "%s rimosso dopo %.1fs" -- "Shield removed after 1.1s" s = seconds
	L.shield_remaining = "%s rimanente: %s (%.1f%%)" -- "Shield remaining: 2.1K (5.3%)"
end

L = BigWigs:NewBossLocale("Hungering Destroyer", "itIT")
if L then
	L.miasma = "Miasma" -- Short for Gluttonous Miasma

	L.custom_on_repeating_yell_miasma = "Urlo ripetitivo della vita per Miasma"
	L.custom_on_repeating_yell_miasma_desc = "Urla messaggi ripetitivi con Miasma Insaziabile per segnalare agli altri quando sei sotto il 75% di vita."

	L.custom_on_repeating_say_laser = "Messaggio Espulsione Instabile"
	L.custom_on_repeating_say_laser_desc = "Ripeti messaggi per Espulsione Instabile per aiutare a muovere i giocatori che non hanno visto il primo messaggio."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "itIT")
if L then
	L.tear = "Squarcio" -- Short for Dimensional Tear
	L.spirits = "Spiriti" -- Short for Fleeting Spirits
	L.seeds = "Semi" -- Short for Seeds of Extinction
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "itIT")
if L then
	L.times = "%dx %s"

	L.level = "%s (Livello |cffffff00%d|r)"
	L.full = "%s (|cffff0000PIENO|r)"

	L.anima_adds = "Adds Animum Concentrato"
	L.anima_adds_desc = "Mostra un timer per la comparsa degli Adds di Animum Concentrato."

	L.custom_off_experimental = "Abilita funzioni sperimentali"
	L.custom_off_experimental_desc = "Queste funzioni |cffff0000non sono state testate|r e potrebbero creare |cffff0000spam|r."

	L.anima_tracking = "Tracciamento Animum |cffff0000(Experimental)|r"
	L.anima_tracking_desc = "Barre e messaggi per i tracciamento dei livelli di animum nei contenitori.|n|cffaaff00Suggerimento: Potresti preferire tenere disabilitati le barre e il box informazioni, dipende dalle tue preferenze personali."

	L.custom_on_stop_timers = "Mostra sempre le barre abilità"
	L.custom_on_stop_timers_desc = "Solo per il test di adesso"

	L.desires = "Desideri"
	L.bottles = "Bottiglie"
	L.sins = "Peccati"
end

L = BigWigs:NewBossLocale("The Council of Blood", "itIT")
if L then
	L.custom_on_repeating_dark_recital = "Ripetizione per Esibizione Oscura"
	L.custom_on_repeating_dark_recital_desc = "Messaggi ripetuti per Esibizione Oscura con icone {rt1}, {rt2} per trovare il tuo compagno di ballo."

	L.custom_off_select_boss_order = "Icone ordine di uccisione Boss"
	L.custom_off_select_boss_order_desc = "Segna l'ordine di uccisione dei boss con croce {rt7}. Richiede capo incursione o assistente per marchiare."
	L.custom_off_select_boss_order_value1 = "Niklaus -> Frieda -> Stavros"
	L.custom_off_select_boss_order_value2 = "Frieda -> Niklaus -> Stavros"
	L.custom_off_select_boss_order_value3 = "Stavros -> Niklaus -> Frieda"
	L.custom_off_select_boss_order_value4 = "Niklaus -> Stavros -> Frieda"
	L.custom_off_select_boss_order_value5 = "Frieda -> Stavros -> Niklaus"
	L.custom_off_select_boss_order_value6 = "Stavros -> Frieda -> Niklaus"

	L.dance_assist = "Assistente Danza"
	L.dance_assist_desc = "Mostra avvisi direzionali per la fase della danza."
	L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t Danza in Avanti |T450907:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t Danza a Destra |T450908:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t Danza Indietro |T450905:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t Danza a Sinistra |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "Saltelli in avanti" -- Prance Forward!
	L.dance_yell_right = "Spallucce a destra" -- Shimmy right!
	L.dance_yell_down = "Via alle danze" -- Boogie down!
	L.dance_yell_left = "Volteggio a sinistra" -- Sashay left!
end

L = BigWigs:NewBossLocale("Sludgefist", "itIT")
if L then
	L.stomp_shift = "Carica & Spostamento" -- Destructive Stomp + Seismic Shift

	L.fun_info = "Info sui danni"
	L.fun_info_desc = "Mostra un messaggio che indica la salute persa dal boss durante Urto Distruttivo."

	L.health_lost = "Picchiapoltiglia è sceso del %.1f%%!"
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "itIT")
if L then
	L.first_blade = "Prima Lama"
	L.second_blade = "Seconda Lama"

	L.skirmishers = "Schermagliatrici" -- Short for Stone Legion Skirmishers
	L.eruption = "Eruzione" -- Short for Reverberating Eruption

	L.custom_on_stop_timers = "Mostra sempre le barre abilità"
	L.custom_on_stop_timers_desc = "Solo per il test di adesso"

	L.goliath_short = "Mastodonte"
	L.goliath_desc = "Mostra avvisi e timer per la comparsa del Mastodonte della Legione di Pietra."

	L.commando_short = "Commando"
	L.commando_desc = "Mostra avvisi quando viene ucciso un Commando della Legione di Pietra."
end

L = BigWigs:NewBossLocale("Sire Denathrius", "itIT")
if L then
	L.infobox_stacks = "%d |4Accumulo:Accumuli;: %d |4giocatore:giocatori;" -- 4 Stacks: 5 players // 1 Stack: 1 player

	L.custom_on_repeating_nighthunter = "Ripetizione Urlo Predatore della Notte"
	L.custom_on_repeating_nighthunter_desc = "Ripete messaggi di urlo per l'abilità Predatore della Notte usando le icone {rt1} o {rt2} o {rt3} per trovare la tuna linea più facilmente se devi assorbire."

	L.custom_on_repeating_impale = "Ripetizione Avviso Impalamento"
	L.custom_on_repeating_impale_desc = "Ripete i messaggi di chat per l'abilità Impalamento usando '1' o '22' o '333' o '4444' per avvisare l'ordine con cui colpirà."

	L.hymn_stacks = "Inno di Nathria"
	L.hymn_stacks_desc = "Avviso per gli accumuli di Inno di Nathria presenti su di te."

	L.ravage_target = "Riflesso: Devastazione Barra di Cast del Target"
	L.ravage_target_desc = "Barra di cast che mostra il tempo mancante prima che Riflesso colpisca con Devastazione."
	L.ravage_targeted = "Devastazione a Terra" -- Testo sulla barra per quando devastazione raggiunge il suo punto d'impatto in fase 3

	L.no_mirror = "No Specchio: %d" -- Numero di giocatori che non hanno Attraverso lo Specchio
	L.mirror = "Specchio: %d" -- Numero di giocatori che hanno Attraverso lo Specchio
end

L = BigWigs:NewBossLocale("Castle Nathria Trash", "itIT")
if L then
	--[[ Pre Shriekwing ]]--
	L.moldovaak = "Moldovaak"
	L.caramain = "Caramain"
	L.sindrel = "Sindrel"
	L.hargitas = "Hargitas"

	--[[ Shriekwing -> Huntsman Altimor ]]--
	L.gargon = "Gargon Gigantesco"
	L.hawkeye = "Occhiolungo di Nathria"
	L.overseer = "Sovrintendente dei Serragli"

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	L.feaster = "Divoratore di Terrore"
	L.rat = "Ratto di Dimensioni Anormali"
	L.miasma = "Miasma" -- Short for Gluttonous Miasma

	--[[ Hungering Destroyer -> Lady Inerva Darkvein ]]--
	L.deplina = "Deplina"
	L.dragost = "Dragost"
	L.kullan = "Kullan"

	--[[ Shriekwing -> Xy'mox ]]--
	L.antiquarian = "Antiquaria Sinistra"
	L.conservator = "Conservatore di Nathria"
	L.archivist = "Archivista di Nathria"
	L.hierarch = "Gerarca di Corte"

	--[[ Sludgefist -> Stone Legion Generals ]]--
	L.goliath = "Mastodonte della Legione di Pietra"
end
