local L = BigWigs:NewBossLocale("Morchok", "itIT")
if not L then return end
if L then
	L.engage_trigger = "State cercando di fermare una valanga. Io vi seppelliro'."

	L.crush = "Spacca Armatura"
	L.crush_desc = "Avviso per i Difensori. Conta le stack di Spacca Armatura e mostra una barra di durata."
	L.crush_message = "%2$dx Spacca Armatura su %1$s"

	L.blood = "Sangue Nero della Terra"

	L.explosion = "Esplosione"
	L.crystal = "Cristallo Echeggiante"
end

L = BigWigs:NewBossLocale("Warlord Zon'ozz", "itIT")
if L then
	L.engage_trigger = "Zzof Shuul'wah. Thoq fssh N'Zoth!"

	L.ball = "Ombra della Decadenza"
	L.ball_desc = "Una sfera di energia che disperde la sua energia sui giocatori."
	L.ball_yell = "Gul'kafh an'qov N'Zoth."

	L.bounce = "Rimbalzo della Sfera d'Ombra"
	L.bounce_desc = "Contatore per i rimbalzi dell'Ombra della Decadenza."

	L.darkness = "Uccidere i Tentacoli!"
	L.darkness_desc = "Questa fase comincia quando la Sfera di Energia colpisce il Boss."

	L.shadows = "Ombre d'Interruzione"
end

L = BigWigs:NewBossLocale("Yor'sahj the Unsleeping", "itIT")
if L then
	L.engage_trigger = "Iilth qi'uothk shn'ma yeh'glu Shath'Yar! H'IWN IILTH!"

	L.bolt = GetSpellInfo(105416)
	L.bolt_desc = "Avviso per i Difensori. Conteggia le stack di Dardo del Vuoto e mostra un timer di durata."
	L.bolt_message = "%2$dx Dardo %1$s"

	L.blue = "|cFF0080FFBlu|r"
	L.green = "|cFF088A08Verde|r"
	L.purple = "|cFF9932CDViola|r"
	L.yellow = "|cFFFFA901Gialla|r"
	L.black = "|cFF424242Nera|r"
	L.red = "|cFFFF0404Rossa|r"

	L.blobs = "Globuli"
	L.blobs_bar = "Prossimi Globuli"
	L.blobs_desc = "I Globuli si muovono verso il Boss."
	
end

L = BigWigs:NewBossLocale("Hagara the Stormbinder", "itIT")
if L then
	L.engage_trigger = "State per incontrare la Tempestosa ! Vi massacrero' Tutti."

	L.lightning_or_frost = "Tempesta o Ghiaccio"
	L.ice_next = "Fase del Ghiaccio"
	L.lightning_next = "Fase dei Fulmini"

	L.assault_desc = "Avviso per i Difensori e i curatori. "..select(2, EJ_GetSectionInfo(4159))

	L.nextphase = "Prossima Fase"
	L.nextphase_desc = "Avviso per la prossima fase."
end

L = BigWigs:NewBossLocale("Ultraxion", "itIT")
if L then
	L.engage_trigger = "E' L'ora del Crepuscolo!"

	L.warmup = "Preaparazione"
	L.warmup_desc = "Timer per la partenza del Boss."
	L.warmup_trigger = "Sono l'inizio della fine, l'ombra che oscura il sole, la campana che rintocca la morte."

	L.crystal = "Cristalli di Meteora"
	L.crystal_desc = "Timer per i vari cristalli che vengono lanciati dagli NPC."
	L.crystal_red = "Cristallo ROSSO"
	L.crystal_green = "Cristallo VERDE"
	L.crystal_blue = "Cristallo BLU"

	L.twilight = "Crepuscolo"
	L.cast = "Barra del Crepuscolo"
	L.cast_desc = "Mostra una barra per l'Ora del Crepuscolo 5 (in Normale) o 3 (in Eroico) secondi prima dell'inizio del Cast."
	
	L.lightself = "Luce Calante su di TE"
	L.lightself_desc = "Mostra una barra che visualizza il tempo rimamente prima che Luce Calante esploda."
	L.lightself_bar = "<TU ESPLODI>"
	
	L.lighttank = "Luce Calante sui Difensori"
	L.lighttank_desc = "Avviso per i Difensori. Se un tank ha Luce Calante, visualizza una barra di esplosione che lampeggia e vibra."
	L.lighttank_bar = "<%s Esplode>"
	L.lighttank_message = "I Difensori ESPLODONO"
end

L = BigWigs:NewBossLocale("Warmaster Blackhorn", "itIT")
if L then
	L.warmup = "Preparazione"
	L.warmup_desc = "Tempo all'avvio del Combattimento."
	
	L.sunder = "Sfondamento"
	L.sunder_desc = "Avviso per i Difensori. Conteggia le stack di Sfondamento e visualizza una Timer di durata."
	L.sunder_message = "%2$dx Sfondamento su %1$s"

	L.sapper_trigger = "Un drago lascia cadere un GENIERE sulla Nave!"
	L.sapper = "Geniere"
	L.sapper_desc = "Il Geniere danneggia la nave"

	L.stage2_trigger = "Sembra che dovro' fare tutto da solo. Bene!"
end

L = BigWigs:NewBossLocale("Spine of Deathwing", "itIT")
if L then
	L.engage_trigger = "Le Piastre! Sta Arrivando! Distruggiamo le Piastre e avremo una possibilita' di Colpirlo!"
	
	L.about_to_roll = "Sta per Avvitarsi"
	L.rolling = "Avvitamento"
	L.not_hooked = "TU >NON< SEI armpionato!"
	L.roll_message = "Si sta Avvitando, Avvitamento! Avvitamento!"
	L.level_trigger = "Si Stabilizza"
	L.level_message = "Ottimo, si e' Stabilizzato!"

	L.exposed = "Armatura Esposta"

	L.residue = "Residui non assorbiti"
	L.residue_desc = "Messaggi che ti informano di quanti residui sono rimasti sulla schiena, che aspettano di essere assorbiti."
	L.residue_message = "Residui non Assorbiti: %d"
end

L = BigWigs:NewBossLocale("Madness of Deathwing", "itIT")
if L then
	L.engage_trigger = "Non potete far nulla. Distruggero' il vostro Mondo."
	L.smalltentacles_desc = "Al 70% e al 40% di vita il Tentacolo dell'Arto genera alcuni Tentacoli Brucianti che sono immuni alle Spell AOE."
	L.bolt_explode = "<Esplosione del Dardo>"
	L.parasite = "Parassita"
	L.blobs_soon = "%d%% - SANGUE COAGULANTE in ARRIVO!"
end

