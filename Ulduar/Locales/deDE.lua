local L = BigWigs:NewBossLocale("Algalon the Observer", "deDE")
if L then
	L.phase = "Phasen"
	L.phase_desc = "Warnt vor Phasenwechsel."
	L.engage_warning = "Phase 1"
	L.phase2_warning = "Phase 2 bald!"
	L.phase_bar = "Phase %d"
	L.engage_trigger = "Euer Handeln ist unlogisch. Alle Möglichkeiten dieser Begegnung wurden berechnet. Das Pantheon wird die Nachricht des Beobachters erhalten, ungeachtet des Ausgangs."

	L.punch_message = "%2$dx Phasenschlag: %1$s!"
	L.smash_message = "Kosmischer Schlag kommt!"
	L.blackhole_message = "Schwarzes Loch %dx!"
	L.bigbang_bar = "Nächster Großer Knall"
	L.bigbang_soon = "Großer Knall bald!"

	L.end_trigger = "Ich sah Welten umhüllt von den Flammen der Schöpfer"
end

L = BigWigs:NewBossLocale("Auriaya", "deDE")
if L then
	L.engage_trigger = "In manche Dinge mischt man sich besser nicht ein!"

	L.fear_warning = "Furcht bald!"
	L.fear_message = "Furcht!"
	L.fear_bar = "~Furcht"

	L.swarm_message = "Wächterschwarm"
	L.swarm_bar = "~Wächterschwarm"

	L.defender = "Wilder Verteidiger"
	L.defender_desc = "Warnt, wieviele Leben der Wilder Verteidiger noch hat."
	L.defender_message = "Verteidiger da %d/9!"

	L.sonic_bar = "~Überschallkreischen"
end

L = BigWigs:NewBossLocale("Freya", "deDE")
if L then
	L.engage_trigger1 = "Das Konservatorium muss verteidigt werden!"
	L.engage_trigger2 = "Ihr Ältesten, gewährt mir Eure Macht!"

	L.phase = "Phasen"
	L.phase_desc = "Warnt bei Phasenwechsel."
	L.phase2_message = "Phase 2"

	L.wave = "Wellen"
	L.wave_desc = "Warnt vor den Wellen."
	L.wave_bar = "Nächste Welle"
	L.conservator_trigger = "Eonar, Eure Dienerin braucht Hilfe!"
	L.detonate_trigger = "Der Schwarm der Elemente soll über Euch kommen!"
	L.elementals_trigger = "Helft mir, Kinder!"
	L.tree_trigger = "Ein |cFF00FFFFGeschenk der Lebensbinderin|r fängt an zu wachsen!"
	L.conservator_message = "Konservator!"
	L.detonate_message = "Explosionspeitscher!"
	L.elementals_message = "Elementare!"

	L.tree = "Eonars Geschenk"
	L.tree_desc = "Warnt, wenn Eonars Geschenk auftaucht."
	L.tree_message = "Eonars Geschenk!"

	L.fury_message = "Furor"
	L.fury_other = "Furor: %s"

	L.tremor_warning = "Bebende Erde bald!"
	L.tremor_bar = "~Bebende Erde"
	L.energy_message = "Instabile Energie auf DIR!"
	L.sunbeam_message = "Sonnenstrahl!"
	L.sunbeam_bar = "~Sonnenstrahl"

	L.end_trigger = "Seine Macht über mich beginnt zu schwinden. Endlich kann ich wieder klar sehen. Ich danke Euch, Helden."
end

L = BigWigs:NewBossLocale("Hodir", "deDE")
if L then
	L.engage_trigger = "Für Euer Eindringen werdet Ihr bezahlen!"

	L.cold = "Beißende Kälte"
	L.cold_desc = "Warnt, wenn du zwei Stapel von Beißende Kälte hast."
	L.cold_message = "Beißende Kälte x%d!"

	L.flash_warning = "Blitzeis!"
	L.flash_soon = "Blitzeis in 5 sek!"

	L.hardmode = "Hard Mode"
	L.hardmode_desc = "Timer für den Hard Mode."

	L.end_trigger = "Ich... bin von ihm befreit... endlich."
end

L = BigWigs:NewBossLocale("Ignis the Furnace Master", "deDE")
if L then
	L.engage_trigger = "Ihr anmaßenden Wichte! Euer Blut wird die Waffen härten, mit denen diese Welt erobert wird!"

	L.construct_message = "Konstrukt aktiviert!"
	L.construct_bar = "Nächstes Konstrukt"
	L.brittle_message = "Konstrukt ist spröde!"
	L.flame_bar = "~Flammenstrahlen"
	L.scorch_message = "Versengen auf DIR!"
	L.scorch_soon = "Versengen in ~5 sek!"
	L.scorch_bar = "Nächstes Versengen"
	L.slagpot_message = "Schlackentopf: %s"
end

L = BigWigs:NewBossLocale("The Iron Council", "deDE")
if L then
	L.engage_trigger1 = "So leicht werdet Ihr die Versammlung des Eisens nicht bezwingen, Eindringlinge!"
	L.engage_trigger2 = "Nur vollständige Dezimierung wird mich zufriedenstellen."
	L.engage_trigger3 = "Selbst wenn Ihr die größten Helden der Welt seid, so seid Ihr doch nichts weiter als Sterbliche."

	L.overload_message = "Überladen in 6 sek!"
	L.death_message = "Todesrune auf DIR!"
	L.summoning_message = "Elementare!"

	L.chased_other = "%s wird verfolgt!"
	L.chased_you = "DU wirst verfolgt!"

	L.overwhelm_other = "Überwältigende Kraft: %s"

	L.shield_message = "Runenschild!"

	L.council_dies = "%s getötet!"
end

L = BigWigs:NewBossLocale("Kologarn", "deDE")
if L then
	L.arm = "Arm stirbt"
	L.arm_desc = "Warnung und Timer für das Sterben des linken & rechten Arms."
	L.left_dies = "Linker Arm stirbt!"
	L.right_dies = "Rechter Arm stirbt!"
	L.left_wipe_bar = "Neuer linker Arm"
	L.right_wipe_bar = "Neuer rechter Arm"

	L.shockwave = "Schockwelle"
	L.shockwave_desc = "Timer für die Schockwelle."
	L.shockwave_trigger = "AUSLÖSCHUNG!"

	L.eyebeam = "Fokussierter Augenstrahl"
	L.eyebeam_desc = "Warnt, wenn du von Fokussierter Augenstrahl betroffen bist."
	L.eyebeam_trigger = "seinen Blick auf Euch!"
	L.eyebeam_message = "Augenstrahl: %s"
	L.eyebeam_bar = "~Augenstrahl"
	L.eyebeam_you = "Augenstrahl auf DIR!"
	L.eyebeam_say = "Augenstrahl auf MIR!"

	L.eyebeamsay = "Augenstrahl /sagen"
	L.eyebeamsay_desc = "Verkündet, wenn du das Ziel des Augenstrahls bist."

	L.armor_message = "%2$dx Rüstung zermalmen: %1$s!"
end

L = BigWigs:NewBossLocale("Flame Leviathan", "deDE")
if L then
	L.engage = "Angegriffen"
	L.engage_desc = "Warnt, wenn der Flammenleviathan angegriffen wurde."
	L.engage_trigger = "^Feindeinheiten erkannt"
	L.engage_message = "%s angegriffen!"

	L.pursue = "Verfolgen"
	L.pursue_desc = "Warnt, wenn der Flammenleviathan einen Spieler verfolgt."
	L.pursue_trigger = "^%%s verfolgt"
	L.pursue_other = "Verfolgen: %s"

	L.shutdown_message = "Systemabschaltung!"
end

L = BigWigs:NewBossLocale("Mimiron", "deDE")
if L then
	L.phase = "Phasen"
	L.phase_desc = "Warnt bei Phasenwechsel."
	L.engage_warning = "Phase 1"
	L.engage_trigger = "^Wir haben nicht viel Zeit, Freunde!"
	L.phase2_warning = "Phase 2"
	L.phase2_trigger = "WUNDERBAR! Das sind Ergebnisse nach meinem Geschmack! Integrität der Hülle bei 98,9 Prozent! So gut wie keine Dellen! Und weiter geht's."
	L.phase3_warning = "Phase 3"
	L.phase3_trigger = "^Danke Euch, Freunde! Eure Anstrengungen haben fantastische Daten geliefert!"
	L.phase4_warning = "Phase 4"
	L.phase4_trigger = "Vorversuchsphase abgeschlossen. Jetzt kommt der eigentliche Test!"
	L.phase_bar = "Phase %d"

	L.hardmode = "Hard Mode"
	L.hardmode_desc = "Timer für den Hard Mode."
	L.hardmode_trigger = "^Warum habt Ihr das denn jetzt gemacht?"
	L.hardmode_message = "Hard Mode aktiviert!"
	L.hardmode_warning = "BOOM!"

	L.plasma_warning = "Wirkt Plasmaeruption!"
	L.plasma_soon = "Plasmaeruption bald!"
	L.plasma_bar = "Plasmaeruption"

	L.shock_next = "~Schockschlag"

	L.laser_soon = "Lasersalve!"
	L.laser_bar = "Lasersalve"

	L.magnetic_message = "Einheit am Boden!"

	L.suppressant_warning = "Löschschaum kommt!"

	L.fbomb_soon = "Frostbombe bald!"
	L.fbomb_bar = "~Frostbombe"

	L.bomb_message = "Bombenbot!"

	L.end_trigger = "^Es scheint, als wäre mir"
end

L = BigWigs:NewBossLocale("Razorscale", "deDE")
if L then
	L["Razorscale Controller"] = "Klingenschuppe Controller"

	L.phase = "Phasen"
	L.phase_desc = "Warnt bei Phasenwechsel."
	L.ground_trigger = "Beeilt Euch! Sie wird nicht lange am Boden bleiben!"
	L.ground_message = "Angekettet!"
	L.air_trigger = "Gebt uns einen Moment, damit wir uns auf den Bau der Geschütze vorbereiten können."
	L.air_trigger2 = "Feuer einstellen! Lasst uns diese Geschütze reparieren!"
	L.air_message = "Hebt ab!"
	L.phase2_trigger = "%s dauerhaft an den Boden gebunden!"
	L.phase2_message = "Phase 2"
	L.phase2_warning = "Phase 2 bald!"
	L.stun_bar = "Betäubt"

	L.breath_trigger = "%s holt tief Luft..."
	L.breath_message = "Flammenatem!"
	L.breath_bar = "~Flammenatem"

	L.flame_message = "Verschlingende Flamme auf DIR!"

	L.harpoon = "Harpunengeschütze"
	L.harpoon_desc = "Warnungen und Timer für die Harpunengeschütze."
	L.harpoon_message = "Harpunengeschütz %d bereit!"
	L.harpoon_trigger = "Harpunengeschütz ist einsatzbereit!"
	L.harpoon_nextbar = "Geschütz %d"
end

L = BigWigs:NewBossLocale("Thorim", "deDE")
if L then
	L.phase = "Phasen"
	L.phase_desc = "Warnt bei Phasenwechsel."
	L.phase1_message = "Phase 1"
	L.phase2_trigger = " Eindringlinge! Ihr Sterblichen, die Ihr es wagt, Euch in mein Vergnügen einzumischen, werdet... Wartet... Ihr..." -- space in the beginning!
	L.phase2_message = "Phase 2 - Berserker in 6:15 min!"
	L.phase3_trigger = "Ihr unverschämtes Geschmeiß! Ihr wagt es, mich in meinem Refugium herauszufordern? Ich werde Euch eigenhändig zerschmettern!"
	L.phase3_message = "Phase 3 - Thorim angegriffen!"

	L.hardmode = "Hard Mode"
	L.hardmode_desc = "Timer für den Hard Mode."
	L.hardmode_warning = "Hard Mode beendet!"

	L.shock_message = "DU wirst geschockt!"
	L.barrier_message = "Runenbarriere oben!"

	L.detonation_say = "Ich bin die Bombe!"

	L.charge_message = "Blitzladung x%d!"
	L.charge_bar = "Blitzladung %d"

	L.strike_bar = "~Schlag"

	L.end_trigger = "Senkt Eure Waffen! Ich ergebe mich!"
end

L = BigWigs:NewBossLocale("General Vezax", "deDE")
if L then
	L.engage_trigger = "Eure Vernichtung wird ein neues Zeitalter des Leids einläuten!"

	L.surge_message = "Sog %d!"
	L.surge_cast = "Wirkt Sog %d"
	L.surge_bar = "Sog %d"

	L.animus = "Saronitanimus"
	L.animus_desc = "Warnt, wenn ein Saronitanimus auftaucht."
	L.animus_trigger = "Die Saronitdämpfe sammeln sich, wirbeln heftig herum und verschmelzen zu einer monströsen Form!"
	L.animus_message = "Saronitanimus kommt!"

	L.vapor = "Saronitdämpfe"
	L.vapor_desc = "Warnung und Timer für das Auftauchen von Saronitdämpfen."
	L.vapor_message = "Saronitdämpfe %d!"
	L.vapor_bar = "Saronitdämpfe %d/6"
	L.vapor_trigger = "Eine Wolke Saronitdämpfe bildet sich in der Nähe!"

	L.vaporstack = "Saronitdämpfe Stapel"
	L.vaporstack_desc = "Warnt, wenn du 5 oder mehr Stapel der Saronitdämpfe hast."
	L.vaporstack_message = "Saronitdämpfe x%d!"

	L.crash_say = "Schattengeschoss auf MIR!"

	L.mark_message = "Mal"
	L.mark_message_other = "Mal: %s"
end

L = BigWigs:NewBossLocale("XT-002 Deconstructor", "deDE")
if L then
	L.exposed_warning = "Freigelegtes Herz bald!"
	L.exposed_message = "Herz freigelegt!"

	L.gravitybomb_other = "Gravitationsbombe: %s"

	L.lightbomb_other = "Lichtbombe: %s"

	L.tantrum_bar = "~Betäubender Koller"
end

L = BigWigs:NewBossLocale("Yogg-Saron", "deDE")
if L then
	L["Crusher Tentacle"] = "Schmettertentakel"
	L["The Observation Ring"] = "Der Beobachtungsring"

	L.phase = "Phasen"
	L.phase_desc = "Warnt bei Phasenwechsel."
	L.engage_warning = "Phase 1"
	L.engage_trigger = "^Bald ist die Zeit"
	L.phase2_warning = "Phase 2"
	L.phase2_trigger = "^Ich bin der strahlende Traum"
	L.phase3_warning = "Phase 3"
	L.phase3_trigger = "^Erblickt das wahre Antlitz des Todes"

	L.portal = "Portale"
	L.portal_desc = "Warnt, wenn Portale erscheinen."
	L.portal_trigger = "Portale öffnen sich im Geist von %s!"
	L.portal_message = "Portale offen!"
	L.portal_bar = "Nächsten Portale"

	L.fervor_cast_message = "Wirkt Eifer auf %s!"
	L.fervor_message = "Eifer auf %s!"

	L.sanity_message = "DU wirst verrückt!"

	L.weakened = "Geschwächt"
	L.weakened_desc = "Warnt, wenn Yogg-Saron geschwächt ist."
	L.weakened_message = "%s ist geschwächt!"
	L.weakened_trigger = "Die Illusion fällt in sich zusammen und der Weg in den zentralen Raum wird frei!"

	L.madness_warning = "Wahnsinn in 5 sek!"
	L.malady_message = "Geisteskrank: %s!"

	L.tentacle = "Schmettertentakel"
	L.tentacle_desc = "Warnung und Timer für das Auftauchen der Schmettertentakel."
	L.tentacle_message = "Schmettertentakel %d!"

	L.link_warning = "DU bist verbunden!"

	L.gaze_bar = "~Blick"
	L.empower_bar = "~Machtvolle Schatten"

	L.guardian_message = "Wächter %d!"

	L.empowericon_message = "Schatten verblasst!"

	L.roar_warning = "Gebrüll in 5 sek!"
	L.roar_bar = "Nächstes Gebrüll"
end
