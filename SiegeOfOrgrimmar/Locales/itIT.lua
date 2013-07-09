local L = BigWigs:NewBossLocale("Immerseus", "itIT")
if not L then return end
if L then

end

L = BigWigs:NewBossLocale("The Fallen Protectors", "itIT")
if L then
	L.defile = "Lancio Suolo Profanato"

	L.custom_off_bane_marks = "Parola d'Ombra: Flagello"
	L.custom_off_bane_marks_desc = "Per aiutare a dissipare, evidenzia chi ha Parola d'Ombra: Flagello su di loro con mark the people who have Shadow Word: Bane on them with %s%s%s%s%s%s%s (in questo ordine)(possono non essere usati tutti i simboli), richiede capo incursione o assistente."

	L.no_meditative_field = "NIENTE Campo di Meditazione!"

	L.intermission = "Misure Disperate"
	L.intermission_desc = "Avvisa quando ti stai avvicinando ad un boss che sta lanciando Misure Disperate"
end

L = BigWigs:NewBossLocale("Norushen", "itIT")
if L then

end

L = BigWigs:NewBossLocale("Sha of Pride", "itIT")
if L then

end

L = BigWigs:NewBossLocale("Galakras", "itIT")
if L then

end

L = BigWigs:NewBossLocale("Iron Juggernaut", "itIT")
if L then

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

	L.adds_trigger1 = "Defend the gate!"
	L.adds_trigger2 = "Rally the forces!"
	L.adds_trigger3 = "Next squad, to the front!"
	L.adds_trigger4 = "Warriors, on the double!"
	L.adds_trigger5 = "Kor'kron, at my side!"

	L.chain_heal, L.chain_heal_desc = EJ_GetSectionInfo(7935)
	L.chain_heal_icon = 1064
	L.chain_heal_message = "Il tuo focus sta lanciando Catena di Guarigione Potenziata!"

	L.arcane_shock, L.arcane_shock_desc = EJ_GetSectionInfo(7928)
	L.arcane_shock_icon = 114003
	L.arcane_shock_message = "Il tuo focus sta lanciando Folgore Arcana!"

	L.focus_only = "|cffff0000Avvisi solo dei bersagli focus.|r "
end

L = BigWigs:NewBossLocale("Malkorok", "itIT")
if L then
	L.custom_off_energy_marks = "Marcatore Energia Dispersa"
	L.custom_off_energy_marks_desc = "Per aiutare l'assegnazione delle cure, evidenzia i giocatori che hanno Energia Dispersa su di loro con %s%s%s%s%s%s%s (in questo ordine)(possono non essere usati tutti i simboli), richiede capo incursione o assistente."

end

L = BigWigs:NewBossLocale("Spoils of Pandaria", "itIT")
if L then

end

L = BigWigs:NewBossLocale("Thok the Bloodthirsty", "itIT")
if L then

end

L = BigWigs:NewBossLocale("Siegecrafter Blackfuse", "itIT")
if L then
	L.shredder_engage_trigger = "Un Segatronchi Automatizzato si avvicina!" -- needs verify
	L.laser_on_you = "Laser su di te PEW PEW!"
	L.laser_say = "Laser PEW PEW!"

	L.assembly_line_trigger = "Unfinished weapons begin to roll out on the assembly line."
	L.assembly_line_message = "Armi non finite (%d)"
end

L = BigWigs:NewBossLocale("Paragons of the Klaxxi", "itIT")
if L then
	-- for getting all those calculate emotes:
	-- cat Transcriptor.lua | sed "s/\t//g" | grep -E "(CHAT_MSG_RAID_BOSS_EMOTE].*Iyyokuk)" | sed "s/.*EMOTE//" | sed "s/Iyyo.*//" | sed "s/#/\"/g" | sort | uniq
	-- XXX incomplete this should be 15 strings
	L.bomb = "Detonate every Bomb!"
	L.sword = "Slice the Swords!"
	L.drums = "Sound the Drums!"
	L.mantid = "PH"
	L.staff = "PH"

	L.yellow = "Chase Down Every Yellow Coward!"
	L.red = "Drain all the Red Blood!"
	L.blue = "Make Every Blue Cry!"
	L.purple = "PH"
	L.green = "PH"

	L.one = "Every Solitary One!"
	L.two = "Split Every Pair!"
	L.three = "Target Every Three!"
	L.four = "PH"
	L.five = "PH"
	--------------------------------
	L.edge_message = "Sei uno dei limiti"
	L.custom_off_edge_marks = "Marcatori dei Limiti"
	L.custom_off_edge_marks_desc = "PEvidenzia i giocatori che, dopo i calcoli, saranno i limiti di Confine Ardente con %s%s%s%s%s%s%s (in questo ordine)(possono non essere usati tutti i simboli), richiede capo incursione o assistenteho will be edges based on the calculations %s%s%s%s%s%s, requires promoted or leader."
	L.injection_over_soon = "Fine di Iniezione tra poco (%s)!"
end

L = BigWigs:NewBossLocale("Garrosh Hellscream", "itIT")
if L then

end

L = BigWigs:NewBossLocale("Siege of Orgrimmar Trash", "itIT")
if L then

end

