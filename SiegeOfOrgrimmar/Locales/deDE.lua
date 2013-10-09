local L = BigWigs:NewBossLocale("Immerseus", "deDE")
if not L then return end
if L then
	L.win_yell = "Ah, Ihr habt es geschafft!"
end

L = BigWigs:NewBossLocale("The Fallen Protectors", "deDE")
if L then
	L.defile = "Geschändeter Boden"

	L.custom_off_bane_marks = "Schattenwort: Unheil markieren"
	L.custom_off_bane_marks_desc = "Um bei der Einteilung zum Bannen zu helfen, werden die anfangs von Schattenwort: Unheil betroffenen Spieler mit {rt1}{rt2}{rt3}{rt4}{rt5} markiert (in dieser Reihenfolge, vielleicht werden nicht alle Symbole genutzt), benötigt Leiter oder Assistent."

	L.no_meditative_field = "KEIN Meditationsfeld!"

	L.intermission = "Verzweifelte Maßnahmen"
	L.intermission_desc = "Warnt, wenn Du Dich nahe bei einem Boss befindest, welcher Verzweifelte Maßnahmen benutzt"

	L.inferno_self = "Infernostoß auf Dir"
	L.inferno_self_desc = "Spezieller Timer wenn Du von Infernostoß betroffen bist."
	L.inferno_self_bar = "Du explodierst!"
end

L = BigWigs:NewBossLocale("Norushen", "deDE")
if L then
	L.pre_pull = "Boss aktiv"
	L.pre_pull_desc = "Leiste für das Event, bevor der Boss aktiv wird."
	L.pre_pull_trigger = "Nun gut, ich werde ein Feld erschaffen, das Eure Verderbnis eindämmt."

	L.big_adds = "Große Adds"
	L.big_adds_desc = "Warnungen für das Besiegen der großen Adds (Drinnen/Draußen)."
	L.big_add = "Großes Add (%d)"
	L.big_add_killed = "Großes Add getötet! (%d)"
end

L = BigWigs:NewBossLocale("Sha of Pride", "deDE")
if L then
	L.custom_off_titan_mark = "Gabe der Titanen markieren"
	L.custom_off_titan_mark_desc = "Markiert Spieler, die von Gabe der Titanen betroffen sind, mit {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8}, benötigt Leiter oder Assistent.\n|cFFFF0000Um Konflikte beim Markieren zu vermeiden, sollte lediglich 1 Person im Raid diese Option aktivieren.|r"

	L.projection_message = "Gehe zum |cFF00FF00GRÜNEN|r Pfeil!"
	L.projection_explosion = "Projektion Explosion"

	L.big_add_bar = "Großes Add"
	L.big_add_spawning = "Großes Add ercsheint!"
	L.small_adds = "Kleine Adds"

	L.titan_pride = "Titanen+Stolz: %s"
end

L = BigWigs:NewBossLocale("Galakras", "deDE")
if L then
	L.demolisher = "Verwüster"
	L.demolisher_desc = "Zeigt an, wann die Verwüster der Kor'kron in den Kampf eintreten."

	L.towers = "Türme"
	L.towers_desc = "Warnungen für das Durchbrechen der Tore zu den Türmen."
	L.south_tower_trigger = "Das Tor zum Südturm ist durchbrochen!"
	L.south_tower = "Südlicher Turm"
	L.north_tower_trigger = "Das Tor zum Nordturm ist durchbrochen!"
	L.north_tower = "Nördlicher Turm"
	L.tower_defender = "Turmverteidiger"

	L.custom_off_shaman_marker = "Schamanen markieren"
	L.custom_off_shaman_marker_desc = "Um bei der Einteilung zum Unterbrechen zu helfen, werden die Gezeitenschamanen des Drachenmals mit {rt1}{rt2}{rt3}{rt4}{rt5} markiert, benötigt Leiter oder Assistent.\n|cFFFF0000Um Konflikte beim Markieren zu vermeiden, sollte lediglich 1 Person im Raid diese Option aktivieren.|r\n|cFFADFF2FTIPP: Wenn Du diese Option aktivierst, ist die schnellste Methode zum Markieren das zügige Bewegen des Mauszeigers über die Schamanen.|r"
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
	L.win_trigger = "System wird neu gestartet. Die Energieversorgung muss stabil bleiben, sonst fliegt die ganze Chose in die Luft."

	L.enable_zone = "Artefaktlagerraum"
	L.matter_scramble_explosion = "Materiewirbel Explosion"
end

L = BigWigs:NewBossLocale("Thok the Bloodthirsty", "deDE")
if L then
	L.adds = "Heroische Adds"
	L.adds_desc = "Warnungen für den Kampfeintritt der heroischen Adds."

	L.tank_debuffs = "Tank Schwächungszauber"
	L.tank_debuffs_desc = "Warnungen für die verschiedenen Typen von Schwächungszaubern auf den Tanks in Verbindung mit Fürchterlichem Brüllen."

	L.cage_opened = "Käfig geöffnet"
end

L = BigWigs:NewBossLocale("Siegecrafter Blackfuse", "deDE")
if L then
	L.shredder_engage_trigger = "Ein automatisierter Schredder nähert sich!"
	L.laser_on_you = "Laser auf Dir PEW PEW!"
	L.laser_say = "Laser PEW PEW"

	L.assembly_line_trigger = "Unfertige Waffen werden auf das Fabrikationsband befördert."
	L.assembly_line_message = "Unfertige Waffen (%d)"

	L.shockwave_missile_trigger = "Ich präsentiere... den wunderschönen Erschütterungsraketenturm ST-03!"
end

L = BigWigs:NewBossLocale("Paragons of the Klaxxi", "deDE")
if L then
	L.one = "Iyyokuk wählt aus: Eins!"
	L.two = "Iyyokuk wählt aus: Zwei!"
	L.three = "Iyyokuk wählt aus: Drei!"
	L.four = "Iyyokuk wählt aus: Vier!"
	L.five = "Iyyokuk wählt aus: Fünf!"
	--------------------------------
	L.edge_message = "Brennendes Band auf Dir"
	L.custom_off_edge_marks = "Brennendes Band markieren"
	--L.custom_off_edge_marks_desc = "Mark the players who will be edges based on the calculations {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
	L.injection_over_soon = "Injektion bald vorbei (%s)!"
	--L.custom_off_parasite_marks = "Parasite marker"
	--L.custom_off_parasite_marks_desc = "Mark the parasites for crowd control and Prey assignments with {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
end

L = BigWigs:NewBossLocale("Garrosh Hellscream", "deDE")
if L then
	L.intermission = "Unterbrechung"
	L.mind_control = "Gedankenkontrolle"

	L.chain_heal_desc = "Heilt ein verbündetes Ziel um 40% ihrer maximalen Gesundheit. Springt auf nahe verbündete Ziele über."
	L.chain_heal_message = "Dein Fokusziel wirkt Kettenheilung!"
	L.chain_heal_bar = "Fokusziel: Kettenheilung"

	L.farseer_trigger = "Scharfseher, heilt unsere Wunden!"
	L.custom_off_shaman_marker = "Scharfseher markieren"
	L.custom_off_shaman_marker_desc = "Um bei der Einteilung zum Unterbrechen zu helfen, werden die Scharfseherwolfsreiter mit {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7} markiert (in dieser Reihenfolge)(vielleicht werden nicht alle Symbole genutzt), benötigt Leiter oder Assistent."

	L.focus_only = "|cffff0000Nur Meldungen für Fokusziele.|r "
end

L = BigWigs:NewBossLocale("Siege of Orgrimmar Trash", "deDE")
if L then

end

