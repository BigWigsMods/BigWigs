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
	L.big_adds = "Add Maggiori"
	L.big_adds_desc = "Avvisa quando uccidi gli Add Maggiori dentro/fuori"
	L.big_add = "Add Maggiore! (%d)"
	L.big_add_killed = "Add Maggiore ucciso! (%d)"
end

L = BigWigs:NewBossLocale("Sha of Pride", "itIT")
if L then
	L.custom_off_titan_mark = "Marcatore Potenza dei Titani"
	L.custom_off_titan_mark_desc = "Per aiutare a trovare gli altri con Potenza dei Titani, evidenzia i giocatori che hanno Potenza dei Titani su di lorocon %s%s%s%s%s%s%s%s (i giocatori con Aura d'Orgoglio non sono evidenziati), richiede capo-incursione o assistente."

	L.projection_message = "Vai verso la freccia |cFF00FF00VERDE|r!"
	L.projection_explosion = "Proiezione esplosione"

	L.big_add_bar = "Add Maggiore"
	L.big_add_spawning = "Add Maggiore in arrivo!"
	L.small_adds = "Add Minori"
end

L = BigWigs:NewBossLocale("Galakras", "itIT")
if L then
	L.demolisher = "Demolitori"
	L.demolisher_desc = "Timer per l'arrivo in combattimento dei Demolitoris Kor'kron"
	L.towers = "Torri"
	L.towers_desc = "Avvisa quando le torri vengono distrutte"
	L.south_tower_trigger = "The door barring the South Tower has been breached!" --need check/translation
	L.south_tower = "Torre sud"
	L.north_tower_trigger = "The door barring the North Tower has been breached!" --need check/translation
	L.north_tower = "Torre nord"

	L.custom_off_shaman_marker = "Marcatore Sciamano"
	L.custom_off_shaman_marker_desc = "To help interrupt assignments, mark the Dragonmaw Tidal Shamans with %s%s%s%s%s%s%s (in that order)(not all marks may be used), requires promoted or leader." --need check/translation
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
	L.battle = "Battle"
	L.berserker = "Berserker"
	L.defensive = "Defensive"

	L.adds_trigger1 = "Difendete il cancello!" --all triggers need verify
	L.adds_trigger2 = "Radunate le forze!"
	L.adds_trigger3 = "Prossima squadra, al fronte!"
	L.adds_trigger4 = "Guerrieri, in marcia!"
	L.adds_trigger5 = "Kor'kron, con me!"
	L.adds_trigger_extra_wave = "Tutti Kor'kron... al mio comando... uccideteli... ORA"
	L.extra_adds = "Extra adds"

	L.chain_heal_message = "Il tuo focus sta lanciando Catena di Guarigione Potenziata!"

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
	L.enable_zone = "Artifact Storage"
	L.matter_scramble_explosion = "Esplosione Scambio di Materia" -- shorten maybe?

	L.custom_off_mark_brewmaster = "Marcatore Mastro Birraio"
	L.custom_off_mark_brewmaster_desc = "Evidenzia il Mastro Birraio Antico con %s"
end

L = BigWigs:NewBossLocale("Thok the Bloodthirsty", "itIT")
if L then
	L.tank_debuffs = "Malefici Difensori"
	L.tank_debuffs_desc = "Avvisi per i vari tipi di malefici sui Difensori associati a Ruggito Temibile"
end

L = BigWigs:NewBossLocale("Siegecrafter Blackfuse", "itIT")
if L then
	L.shredder_engage_trigger = "Un Segatronchi Automatizzato si avvicina!" -- needs verify
	L.laser_on_you = "Laser su di te PEW PEW!"
	L.laser_say = "Laser PEW PEW!"

	L.assembly_line_trigger = "Unfinished weapons begin to roll out on the assembly line."--need check/translation
	L.assembly_line_message = "Armi non finite (%d)"

	L.shockwave_missile_trigger = "Presenting... the beautiful new ST-03 Shockwave missile turret!" --need check/translation
end

L = BigWigs:NewBossLocale("Paragons of the Klaxxi", "itIT")
if L then
	-- for getting all those calculate emotes:
	-- cat Transcriptor.lua | sed "s/\t//g" | grep -E "(CHAT_MSG_RAID_BOSS_EMOTE].*Iyyokuk)" | sed "s/.*EMOTE//" | sed "s/Iyyo.*//" | sed "s/#/\"/g" | sort | uniq
	-- XXX incomplete this should be 15 strings
	L.bomb = "Detonate every Bomb!" -- all those triggers need checking and translation
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
	L.custom_off_edge_marks_desc = "Evidenzia i giocatori che, dopo i calcoli, saranno i limiti di Confine Ardente con %s%s%s%s%s%s%s (in questo ordine)(possono non essere usati tutti i simboli), richiede capo incursione o assistenteho will be edges based on the calculations %s%s%s%s%s%s, requires promoted or leader."
	L.injection_over_soon = "Fine di Iniezione tra poco (%s)!"
end

L = BigWigs:NewBossLocale("Garrosh Hellscream", "itIT")
if L then
	L.mind_control = "Controllo della Mente"

	L.chain_heal = mod:SpellName(144583)
	L.chain_heal_desc = "Heals a friendly target for 40% of their max health, chaining to nearby friendly targets."
	L.chain_heal_message = "Your focus is casting Chain Heal!"
	L.chain_heal_bar = "Focus: Chain Heal"

	L.farseer_trigger = "Chiaroveggenti, guarite le nostre ferite!"
	L.custom_off_shaman_marker = "Farseer marker"
	L.custom_off_shaman_marker_desc = "To help interrupt assignments, mark the Farseer Wolf Rider with %s%s%s%s%s%s%s (in that order)(not all marks may be used), requires promoted or leader."

	L.focus_only = "|cffff0000Focus target alerts only.|r "
end

L = BigWigs:NewBossLocale("Siege of Orgrimmar Trash", "itIT")
if L then

end

