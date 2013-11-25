local L = BigWigs:NewBossLocale("Immerseus", "deDE")
if not L then return end
if L then
--@localization(locale="deDE", namespace="SiegeOfOrgrimmar/Immerseus", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("The Fallen Protectors", "deDE")
if L then
--@localization(locale="deDE", namespace="SiegeOfOrgrimmar/TheFallenProtectors", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_bane_marks = "Schattenwort: Unheil markieren"
	L.custom_off_bane_marks_desc = "Um bei der Einteilung zum Bannen zu helfen, werden die anfangs von Schattenwort: Unheil betroffenen Spieler mit {rt1}{rt2}{rt3}{rt4}{rt5} markiert (in dieser Reihenfolge, vielleicht werden nicht alle Symbole genutzt), benötigt Leiter oder Assistent."
end

L = BigWigs:NewBossLocale("Norushen", "deDE")
if L then
--@localization(locale="deDE", namespace="SiegeOfOrgrimmar/Norushen", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("Sha of Pride", "deDE")
if L then
--@localization(locale="deDE", namespace="SiegeOfOrgrimmar/ShaOfPride", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_titan_mark = "Gabe der Titanen markieren"
	L.custom_off_titan_mark_desc = "Markiert Spieler, die von Gabe der Titanen betroffen sind, mit {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8}, benötigt Leiter oder Assistent.\n|cFFFF0000Um Konflikte beim Markieren zu vermeiden, sollte lediglich 1 Person im Raid diese Option aktivieren.|r"
end

L = BigWigs:NewBossLocale("Galakras", "deDE")
if L then
--@localization(locale="deDE", namespace="SiegeOfOrgrimmar/Galakras", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_shaman_marker = "Schamanen markieren"
	L.custom_off_shaman_marker_desc = "Um bei der Einteilung zum Unterbrechen zu helfen, werden die Gezeitenschamanen des Drachenmals mit {rt1}{rt2}{rt3}{rt4}{rt5} markiert, benötigt Leiter oder Assistent.\n|cFFFF0000Um Konflikte beim Markieren zu vermeiden, sollte lediglich 1 Person im Raid diese Option aktivieren.|r\n|cFFADFF2FTIPP: Wenn Du diese Option aktivierst, ist die schnellste Methode zum Markieren das zügige Bewegen des Mauszeigers über die Schamanen.|r"

	L.custom_off_fragment_mark = "Corrupted Fragment marker"
	L.custom_off_fragment_mark_desc = "Mark the Corrupted Fragments with {rt8}{rt7}{rt6}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.\nIn 25 player mode, this will conflict with the Gift of the Titans marker.|r"
end

L = BigWigs:NewBossLocale("Iron Juggernaut", "deDE")
if L then
	L.custom_off_mine_marks = "Minen markieren"
	L.custom_off_mine_marks_desc = "Um bei der Einteilung zum Einstampfen zu helfen, werden die Kriecherminen mit {rt1}{rt2}{rt3} markiert, benötigt Leiter oder Assistent.\n|cFFFF0000Um Konflikte beim Markieren zu vermeiden, sollte lediglich 1 Person im Raid diese Option aktivieren.|r\n|cFFADFF2FTIPP: Wenn Du diese Option aktivierst, ist die schnellste Methode zum Markieren das zügige Bewegen des Mauszeigers über die Minen.|r"
end

L = BigWigs:NewBossLocale("Kor'kron Dark Shaman", "deDE")
if L then
	L.blobs = "Schleim"

	L.custom_off_mist_marks = "Toxischer Nebel markieren"
	L.custom_off_mist_marks_desc = "Um bei der Einteilung zum Heilen zu helfen, werden Spieler mit Toxischem Nebel mit {rt1}{rt2}{rt3}{rt4}{rt5} markiert, benötigt Leiter oder Assistent.\n|cFFFF0000Um Konflikte beim Markieren zu vermeiden, sollte lediglich 1 Person im Raid diese Option aktivieren.|r"
end

L = BigWigs:NewBossLocale("General Nazgrim", "deDE")
if L then
	L.custom_off_bonecracker_marks = "Knochenknacker markieren"
	L.custom_off_bonecracker_marks_desc = "Um bei der Einteilung zum Heilen zu helfen, werden die von Knochenknacker betroffenen Spieler mit {rt1}{rt2}{rt3}{rt4}{rt5} markiert, benötigt Leiter oder Assistent.\n|cFFFF0000Um Konflikte beim Markieren zu vermeiden, sollte lediglich 1 Person im Raid diese Option aktivieren.|r"

	L.stance_bar = "%s(JETZT:%s)"
	L.battle = "Kampf"
	L.berserker = "Berserker"
	L.defensive = "Verteidigung"

	L.adds_trigger1 = "Verteidigt das Tor!"
	L.adds_trigger2 = "Truppen, sammelt euch!"
	L.adds_trigger3 = "Nächste Staffel, nach vorn!"
	L.adds_trigger4 = "Krieger, im Laufschritt!"
	L.adds_trigger5 = "Kor'kron, zu mir!"
	L.adds_trigger_extra_wave = "Alle Kor'kron unter meinem Befehl, tötet sie! Jetzt!"
	L.extra_adds = "Zusätzliche Adds"
	L.final_wave = "Letzte Welle"

	L.chain_heal_message = "Dein Fokusziel wirkt Kettenheilung!"

	L.arcane_shock_message = "Dein Fokusziel wirkt Arkaner Schock!"

	L.focus_only = "|cffff0000Nur Meldungen für Fokusziele.|r "
end

L = BigWigs:NewBossLocale("Malkorok", "deDE")
if L then
	L.custom_off_energy_marks = "Verdrängte Energie markieren"
	L.custom_off_energy_marks_desc = "Um bei der Einteilung zum Bannen zu helfen, werden Spieler mit Verdrängter Energie mit {rt1}{rt2}{rt3}{rt4} markiert, benötigt Leiter oder Assistent.\n|cFFFF0000Um Konflikte beim Markieren zu vermeiden, sollte lediglich 1 Person im Raid diese Option aktivieren.|r"
end

L = BigWigs:NewBossLocale("Spoils of Pandaria", "deDE")
if L then
	L.start_trigger = "Hallo? Mikrofontest"
	L.win_trigger = "System wird neu gestartet. Die Energieversorgung muss stabil bleiben, sonst fliegt die ganze Chose in die Luft."

	L.enable_zone = "Artefaktlagerraum"
	L.matter_scramble_explosion = "Materiewirbel Explosion"
end

L = BigWigs:NewBossLocale("Thok the Bloodthirsty", "deDE")
if L then
--@localization(locale="deDE", namespace="SiegeOfOrgrimmar/ThokTheBloodthirsty", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("Siegecrafter Blackfuse", "deDE")
if L then
	L.overcharged_crawler_mine = "Überladene Kriechermine"
	L.custom_off_mine_marker = "Minen markieren"
	L.custom_off_mine_marker_desc = "Markiert die Minen zum Einteilen der Betäubungen. (Alle Zeichen werden genutzt)"

	L.saw_blade_near_you = "Sägeblatt in der Nähe (nicht auf Dir)"
	L.saw_blade_near_you_desc = "Du kannst diese Option deaktivieren um Spam und Verwirrung zu vermeiden."

	L.disabled = "Deaktiviert"

	L.shredder_engage_trigger = "Ein automatisierter Schredder nähert sich!"
	L.laser_on_you = "Laser auf Dir PEW PEW!"
	L.laser_say = "Laser PEW PEW"

	L.assembly_line_trigger = "Unfertige Waffen werden auf das Fabrikationsband befördert."
	L.assembly_line_message = "Unfertige Waffen (%d)"
	L.assembly_line_items = "Waffen (%d): %s"
	L.item_missile = "Rakete"
	L.item_mines = "Minen"
	L.item_laser = "Laser"
	L.item_magnet = "Magnet"
	L.item_deathdealer = "Todesboten"

	L.shockwave_missile_trigger = "Ich präsentiere... den wunderschönen Erschütterungsraketenturm ST-03!"
end

L = BigWigs:NewBossLocale("Paragons of the Klaxxi", "deDE")
if L then
	L.catalyst_match = "Katalysator: |c%sSTIMMT MIT DIR ÜBEREIN|r"
	L.you_ate = "Du hast einen Parasiten gegessen (noch %d)"
	L.other_ate = "%s hat einen %sParasiten gegessen (noch %d)"
	L.parasites_up = "%d |4Parasit:Parasiten; vorhanden"
	L.dance = "Tanzen"
	L.prey_message = "Wirke Beute auf Parasiten"
	L.injection_over_soon = "Injektion bald vorbei (%s)!"

	L.one = "Iyyokuk wählt aus: Eins!"
	L.two = "Iyyokuk wählt aus: Zwei!"
	L.three = "Iyyokuk wählt aus: Drei!"
	L.four = "Iyyokuk wählt aus: Vier!"
	L.five = "Iyyokuk wählt aus: Fünf!"

	L.custom_off_edge_marks = "Brennendes Band markieren"
	L.custom_off_edge_marks_desc = "Markiert die Spieler mit Brennendem Band, basierend auf den Kalkulationen, mit {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8}, benötigt Leiter oder Assistent.\n|cFFFF0000Um Konflikte beim Markieren zu vermeiden, sollte lediglich 1 Person im Raid diese Option aktivieren.|r"
	L.edge_message = "Brennendes Band auf Dir"

	L.custom_off_parasite_marks = "Parasiten markieren"
	L.custom_off_parasite_marks_desc = "Markiert die Parasiten für Gruppenkontroll- und Beute-Einteilungen mit {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}, benötigt Leiter oder Assistent.\n|cFFFF0000Um Konflikte beim Markieren zu vermeiden, sollte lediglich 1 Person im Raid diese Option aktivieren.|r"

	L.injection_tank = "<Wirkt Injektion>"
	L.injection_tank_desc = "Timer für die Wirkzeit von Injektion auf den aktuellen Tank."
end

L = BigWigs:NewBossLocale("Garrosh Hellscream", "deDE")
if L then
	L.manifest_rage = "Wut manifestieren"
	L.manifest_rage_desc = "Wenn Garrosh 100 Energie erreicht, wirkt er zwei Sekunden lang Wut manifestieren und kanalisiert diesen Zauber dann. Während des Kanalisierens entstehen große Adds. Zieht den Eisernen Stern in Garrosh, um ihn zu betäuben und den Zauber zu unterbrechen."

	L.phase_3_end_trigger = "Ihr glaubt GEWONNEN zu haben? BLIND seid ihr. ICH WERDE EUCH DIE AUGEN ÖFFNEN."

	L.clump_check_desc = "Prüft alle 3 Sekunden während des Bombardements, ob Spieler eng zusammenstehen, da hierdurch Eiserne Sterne der Kor'kron entstehen."
	L.clump_check_warning = "Gruppierung gefunden, Stern kommt"

	L.bombardment = "Bombardement"
	L.bombardment_desc = "Bombardiert Sturmwind und hinterlässt Feuer auf dem Boden. Eiserne Sterne der Kor'kron können nur während des Bombardements entstehen."

	L.intermission = "Unterbrechung"
	L.mind_control = "Gedankenkontrolle"
	L.empowered_message = "%s ist jetzt mächtig!"

	L.ironstar_impact_desc = "Zeigt einen Timer für die Explosion der Eisernen Sterne an der jeweils gegenüberliegenden Wand."
	L.ironstar_rolling = "Eiserner Stern rollt!"

	L.chain_heal_desc = "Heilt ein verbündetes Ziel um 40% ihrer maximalen Gesundheit. Springt auf nahe verbündete Ziele über."
	L.chain_heal_message = "Dein Fokusziel wirkt Kettenheilung!"
	L.chain_heal_bar = "Fokusziel: Kettenheilung"

	L.farseer_trigger = "Scharfseher, heilt unsere Wunden!"
	L.custom_off_shaman_marker = "Scharfseher markieren"
	L.custom_off_shaman_marker_desc = "Um bei der Einteilung zum Unterbrechen zu helfen, werden die Scharfseherwolfsreiter mit {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7} markiert, benötigt Leiter oder Assistent.\n|cFFFF0000Um Konflikte beim Markieren zu vermeiden, sollte lediglich 1 Person im Raid diese Option aktivieren.|r\n|cFFADFF2FTIPP: Wenn Du diese Option aktivierst, ist die schnellste Methode zum Markieren das zügige Bewegen des Mauszeigers über die Scharfseher.|r"

	L.custom_off_minion_marker = "Diener markerieren"
	L.custom_off_minion_marker_desc = "Um bei der Unterscheidung der Diener zu helfen, werden diese mit {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8} markiert, benötigt Leiter oder Assistent."

	L.focus_only = "|cffff0000Nur Meldungen für Fokusziele.|r "
end

