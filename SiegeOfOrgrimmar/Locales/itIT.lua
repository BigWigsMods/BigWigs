local L = BigWigs:NewBossLocale("The Fallen Protectors", "itIT")
if not L then return end
if L then
--@localization(locale="itIT", namespace="SiegeOfOrgrimmar/TheFallenProtectors", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_bane_marks = "Parola d'Ombra: Flagello"
	L.custom_off_bane_marks_desc = "Per aiutare a dissipare, evidenzia chi ha Parola d'Ombra: Flagello su di loro con {rt1}{rt2}{rt3}{rt4}{rt5} (in questo ordine, possono non essere usati tutti i simboli), richiede capo incursione o assistente."
end

L = BigWigs:NewBossLocale("Norushen", "itIT")
if L then
--@localization(locale="itIT", namespace="SiegeOfOrgrimmar/Norushen", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("Sha of Pride", "itIT")
if L then
--@localization(locale="itIT", namespace="SiegeOfOrgrimmar/ShaOfPride", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_titan_mark = "Marcatore Potenza dei Titani"
	L.custom_off_titan_mark_desc = "Evidenzia i giocatori con Dono dei Titani con {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}, richiede capoincursione o assistente.\n|cFFFF0000Soltanto 1 dei giocatori nell'incursione dovrebbe tenere abilitata questa opzione per evitare conflitti di marcamento.|r"

	L.custom_off_fragment_mark = "Corrupted Fragment marker"
	L.custom_off_fragment_mark_desc = "Mark the Corrupted Fragments with {rt8}{rt7}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
end

L = BigWigs:NewBossLocale("Galakras", "itIT")
if L then
--@localization(locale="itIT", namespace="SiegeOfOrgrimmar/Galakras", format="lua_additive_table", handle-unlocalized="ignore")@

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
--@localization(locale="itIT", namespace="SiegeOfOrgrimmar/KorkronDarkShaman", format="lua_additive_table", handle-unlocalized="ignore")@

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
	L.final_wave = "Ultima Ondata"
	L.add_wave = "%s (%s): %s"

	L.chain_heal_message = "Il tuo focus sta lanciando Catena di Guarigione Potenziata!"

	L.arcane_shock_message = "Il tuo focus sta lanciando Folgore Arcana!"
end

L = BigWigs:NewBossLocale("Malkorok", "itIT")
if L then
	L.custom_off_energy_marks = "Marcatore Energia Dispersa"
	L.custom_off_energy_marks_desc = "Per aiutare l'assegnazione dei dissolvimenti, evidenzia i giocatori che hanno Energia Diffusa su di loro con {rt1}{rt2}{rt3}{rt4}, richiede capoincursione o assistente.\n|cFFFF0000Solo 1 persona nell'incursione dovrebbe attivare questa opzione per evitare conflitti con le assegnazioni.|r"
end

L = BigWigs:NewBossLocale("Spoils of Pandaria", "itIT")
if L then
--@localization(locale="itIT", namespace="SiegeOfOrgrimmar/SpoilsOfPandaria", format="lua_additive_table", handle-unlocalized="ignore")@

	L.crates = "Casse"
	L.crates_desc = "Messaggio per quanta Potenza è ancora richiesta e quante casse grandi*medie/piccole servono."
	L.full_power = "Piena Potenza!"
	L.power_left = "%d rimanenti! (%d/%d/%d)"
end

L = BigWigs:NewBossLocale("Thok the Bloodthirsty", "itIT")
if L then
--@localization(locale="itIT", namespace="SiegeOfOrgrimmar/ThokTheBloodthirsty", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("Siegecrafter Blackfuse", "itIT")
if L then
--@localization(locale="itIT", namespace="SiegeOfOrgrimmar/SiegecrafterBlackfuse", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_mine_marker = "Marcatore delle Mine"
	L.custom_off_mine_marker_desc = "Evidenzia le mine per l'assegnazione specifica degli incapacitamenti (Vengono utilizzati tutti i simboli)"
end

L = BigWigs:NewBossLocale("Paragons of the Klaxxi", "itIT")
if L then
	L.catalyst_match = "Catalizzatore: |c%sHA SCELTO TE|r" -- might not be best for colorblind?
	L.you_ate = "Hai mangiato un parassita (%d rimasti)"
	L.other_ate = "%s ha mangiato un %sparassita (%d rimasti)"
	L.parasites_up = "%d |4Parassita:Parassiti; attivi"
	L.dance = "%s, Danza"
	L.prey_message = "Usa Preda sul Parassita"
	L.injection_over_soon = "Fine di Iniezione tra poco (%s)!"

	L.one = "Iyyokuk seleziona: Uno!"
	L.two = "Iyyokuk seleziona: Due!"
	L.three = "Iyyokuk seleziona: Tre!"
	L.four = "Iyyokuk seleziona: Quattro!"
	L.five = "Iyyokuk seleziona: Cinque!"

	L.custom_off_edge_marks = "Marcatori dei Limiti"
	L.custom_off_edge_marks_desc = "Evidenzia i giocatori che saranno i limiti in base ai calcoli {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8}, richiede capoincursione o assistente.\n|cFFFF0000Solo 1 persona nell'incursione dovrebbe attivare questa opzione per evitare conflitti con le assegnazioni.|r"
	L.edge_message = "Sei uno dei limiti"

	L.custom_off_parasite_marks = "Marcatore Parassita"
	L.custom_off_parasite_marks_desc = "Evidenzia i parassiti da controllare e le assegnazioni di Preda con {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}, richiede capoincursione o assistente.\n|cFFFF0000Solo 1 persona nell'incursione dovrebbe attivare questa opzione per evitare conflitti con le assegnazioni.|r"
end

L = BigWigs:NewBossLocale("Garrosh Hellscream", "itIT")
if L then
--@localization(locale="itIT", namespace="SiegeOfOrgrimmar/GarroshHellscream", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_shaman_marker = "Marcatore Chiaroveggenti"
	L.custom_off_shaman_marker_desc = "Per aiutare l'assegnazione delle interruzioni, evidenzia i Cavalcalupi Chiaroveggenti con {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7} (in questo ordine, non tutti i simboli possono essere usati), richiede capo incursione o assistente."

	L.custom_off_minion_marker = "Marcatore servitori"
	L.custom_off_minion_marker_desc = "Per aiutare a separare i servitori, evidenziali con {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8}, richiede capoincursione o assistente."
end

