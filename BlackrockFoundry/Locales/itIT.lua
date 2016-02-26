local L = BigWigs:NewBossLocale("Gruul", "itIT")
if not L then return end
if L then
L.first_ability = "Schianto o Contusione"

end

L = BigWigs:NewBossLocale("Oregorger", "itIT")
if L then
-- L.roll_message = "Roll %d - %d ore to go!"

end

L = BigWigs:NewBossLocale("The Blast Furnace", "itIT")
if L then
L.bombs_dropped = "Bombe sganciate! (%d)"
L.bombs_dropped_p2 = "Ingegnere ucciso, bombe rilasciate!"
L.custom_off_firecaller_marker = "Marcatore Invocatore del Fuoco"
L.custom_off_firecaller_marker_desc = [=[Evidenzia gli Invocatori del Fuoco con {rt7}{rt6}, richiede assistente o capo-incursione.
|cFFFF0000Solo 1 persona nell'incursione dovrebbe attivare questa opzione per evitare conflitti con l'evidenziazione.|r
|cFFADFF2FSUGGERIMENTO: Se l'incursione ha scelto te per questo ruolo, spostare velocemente il mouse sopra i mob è la soluzione più rapida per marcarli.|r]=]
L.custom_on_shieldsdown_marker = "Marcatore Scudo Protettivo Disattivasto "
L.custom_on_shieldsdown_marker_desc = "Evidenzia un'Elementalistta Primordiale vulnerabile con {rt8}, richiede capoincursione o assistente."
L.engineer = "Apparizione Ingengeri della Fornace"
L.engineer_desc = "Durante la Fase 1, appariranno continuamente 2 Ingegneri della Fornace, uno per ogni lato della stanza."
L.firecaller = "Apparizione Invocatori del Fuoco"
L.firecaller_desc = "Durante la Fase 2, appariranno continuamente 2 Invocatori del Fuoco, uno per ogni lato della stanza."
L.guard = "Apparizione Guardia di Sicurezza"
L.guard_desc = "Durante la Fase 1, appariranno continuamente 2 Guardia di Sicurezza, una per ogni lato della stanza. Durante la Fase 2, 1 Guardia di Sicurezza apparirà continuamente all'ingresso della stanza."
L.heat_increased_message = "Calore aumentato! Ondata ogni %ss"
L.operator = "Marcatore Addetto ai Mantici"
L.operator_desc = "Durante la Fase 1, appariranno continuamente 2 Addetti ai Mantici, uno per ogni lato della stanza."

end

L = BigWigs:NewBossLocale("Flamebender Ka'graz", "itIT")
if L then
L.custom_off_wolves_marker = "Marcatore Lupo delle Braci"
L.custom_off_wolves_marker_desc = "Evidenzia i Lupi delle Braci {rt3}{rt4}{rt5}{rt6}, richiede capoincursione o assistente."
L.molten_torrent_self = "Taglio di Lava su di te"
L.molten_torrent_self_bar = "Stai per esplodere!"
L.molten_torrent_self_desc = "Tempo di Recupero aggiuntivo quando Taglio di Lava è su di te."

end

L = BigWigs:NewBossLocale("Kromog", "itIT")
if L then
L.custom_off_hands_marker = "Marcatore Difensore Terra Ghermitrice"
L.custom_off_hands_marker_desc = "Evidenzia le Terre Ghermitrici che avvolgono i difensori con {rt7}{rt8}, richiede Capo Incursione o Assistente Incursione."
-- L.destroy_pillars = "Destroy Pillars"
-- L.prox = "Tank Proximity"
-- L.prox_desc = "Open a 15 yard proximity showing the other tanks to help you deal with the Fists of Stone ability."

end

L = BigWigs:NewBossLocale("Beastlord Darmac", "itIT")
if L then
L.custom_off_conflag_marker = "Marcatore Pirocombusione"
L.custom_off_conflag_marker_desc = [=[Evidenzia i bersagli di Pirocombustione con {rt1}{rt2}{rt3}, richiede capoincursione o assistente.
|cFFFF0000Solo 1 persona nell'incursione dovrebbe attivare questa opzione per evitare conflitti con l'evidenziazione.|r]=]
L.custom_off_pinned_marker = "Marcatore Blocco sul Posto"
L.custom_off_pinned_marker_desc = [=[Evidenzia le Lancie Bloccanti con {rt8}{rt7}{rt6}{rt5}{rt4}, richiede assistente o capo-incursione.
|cFFFF0000Solo 1 persona nell'incursione dovrebbe attivare questa opzione per evitare conflitti con l'evidenziazione.|r
|cFFADFF2FSUGGERIMENTO: Se l'incursione ha scelto te per questo ruolo, spostare velocemente il mouse sopra i mob è la soluzione più rapida per marcarli.|r]=]
L.next_mount = "In sella tra poco!"

end

L = BigWigs:NewBossLocale("Operator Thogar", "itIT")
if L then
L.adds_train = "Servitori Treno"
L.big_add_train = "Servitore Maggiore del Treno"
L.cannon_train = "Cannone del Treno"
L.custom_on_firemender_marker = "Marcatore Curatore del Fuoco Grom'kar"
L.custom_on_firemender_marker_desc = "Evidenzia i Curatori del Fuoco Grom'kar con {rt7}, richiede capoincursione o assistente."
L.custom_on_manatarms_marker = "Marcatore Fante Corazzato Grom'kar"
L.custom_on_manatarms_marker_desc = "Evidenzia i Fanti Corazzati Grom'kar con {rt8}, richiede capoincursione o assistente."
L.deforester = "Disboscatore"
L.lane = "Binario %s: %s"
L.random = "Treni casuali"
L.train = "Treno"
L.trains = "Avvisi del Treno"
L.trains_desc = "Mostra timer e messaggi per ogni binario per quando arriva ogni treno. I binari sono numerati dal Boss fino all'entrata. Per esempio, Boss 1 2 3 4 Entrata"
-- L.train_you = "Train on your lane! (%d)"

end

L = BigWigs:NewBossLocale("The Iron Maidens", "itIT")
if L then
L.custom_off_heartseeker_marker = "Marcatore Centracuori Inzuppato di Sangue"
L.custom_off_heartseeker_marker_desc = "Evidenzia i bersagli della Centracuori con {rt1}{rt2}{rt3}, richiede capoincursione o assistente."
L.power_message = "%d Furia di Ferro!"
L.ship = "Salta sulla Corazzata"
L.ship_trigger = "si prepara a usare il Cannone Principale della Corazzata!"

end

L = BigWigs:NewBossLocale("Blackhand", "itIT")
if L then
L.custom_off_markedfordeath_marker = "Marcatore Marchio della Morte"
L.custom_off_markedfordeath_marker_desc = "Evidenzia i bersagli di Marchio della Morte con {rt1}{rt2}{rt3}, richiede capoincursione o assistente."
L.custom_off_massivesmash_marker = "Marcatore Frantumazione Devastante Massiccia"
L.custom_off_massivesmash_marker_desc = "Evidenzia il difensore coolpito da Frantumazione Devastante Massiccia con {rt6}, richiede capoincursione o assistente."

end

L = BigWigs:NewBossLocale("Blackrock Foundry Trash", "itIT")
if L then
L.beasttender = "Curatore delle Bestie Spaccatuono"
L.brute = "Bruto dell'Officina delle Scorie"
L.earthbinder = "Plasmaterra di Ferro"
L.enforcer = "Scagnozzo Roccianera"
L.furnace = "Scarico dell'Altoforno"
-- L.furnace_msg1 = "Hmm, kinda toasty isn't it?"
-- L.furnace_msg2 = "It's marshmallow time!"
-- L.furnace_msg3 = "This can't be good..."
L.gnasher = "Masticatore Scheggianera"
L.gronnling = "Protogronn Lavoratore"
L.guardian = "Guardiano dell'Officina"
L.hauler = "Ogron Trasportatore"
L.mistress = "Signora della Forgia Manfiammante"
L.taskmaster = "Coordinatore di Ferro"

end

