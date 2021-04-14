local L = BigWigs:NewBossLocale("Void Reaver", "deDE")
if not L then return end
if L then
	L.engage_trigger = "Alarm! Eliminierung eingeleitet!"
end

L = BigWigs:NewBossLocale("High Astromancer Solarian", "deDE")
if L then
	L.engage_trigger = "Tal anu'men no sin'dorei!"

	L.phase = "Phasen"
	L.phase_desc = "Warnung bei Phasenwechsel."
	L.phase1_message = "Phase 1 - Spaltung in ~50sek"
	L.phase2_warning = "Phase 2 bald!"
	L.phase2_trigger = "^Ich werde"
	L.phase2_message = "20% - Phase 2"

	L.wrath_other = "Zorn"

	L.split = "Spaltung"
	L.split_desc = "Warnt vor Spaltung & Add Spawn."
	L.split_trigger1 = "Ich werde Euch Euren Hochmut austreiben!"
	L.split_trigger2 = "Ihr seid eindeutig in der Unterzahl!"
	L.split_bar = "~Nächste Spaltung"
	L.split_warning = "Spaltung in ~7sek"

	L.agent_warning = "Splittung! - Agenten in 6sek"
	L.agent_bar = "Agenten"
	L.priest_warning = "Priester/Solarian in 3sek"
	L.priest_bar = "Priester/Solarian"
end

L = BigWigs:NewBossLocale("Kael'thas Sunstrider", "deDE")
if L then
	L.engage_trigger = "^Energie. Kraft."
	L.engage_message = "Phase 1"

	L.gaze = "Blick"
	L.gaze_desc = "Warnt, wenn Thaladred einen Spieler fokussiert."
	L.gaze_trigger = "im Blickfeld"

	L.fear_soon_message = "Furcht bald!"
	L.fear_message = "Furcht!"
	L.fear_bar = "~Nächste Furcht"

	L.rebirth = "Phönix Wiedergeburt"
	L.rebirth_desc = "Warnt vor Wiedergeburt der Phönix Eier."
	L.rebirth_warning = "Phönix Wiedergeburt in 5sek!"
	L.rebirth_bar = "~Mögliche Wiedergeburt"

	L.pyro = "Pyroschlag"
	L.pyro_desc = "Zeigt einen 60 Sekunden Timer f\195\188r Pyroschlag."
	L.pyro_trigger = "%s beginnt, Pyroschlag zu wirken!"
	L.pyro_warning = "Pyroschlag in 5sek!"
	L.pyro_message = "Pyroschlag!"

	L.phase = "Phasen"
	L.phase_desc = "Warnt vor den verschiedenen Phasen."
	L.thaladred_inc_trigger = "Eindrucksvoll. Aber werdet Ihr auch mit Thaladred, dem Verfinsterer fertig?"
	L.sanguinar_inc_trigger = "Ihr habt gegen einige meiner besten Berater bestanden... aber niemand kommt gegen die Macht des Bluthammers an. Zittert vor Fürst Blutdurst!"
	L.capernian_inc_trigger = "Capernian wird dafür sorgen, dass Euer Aufenthalt hier nicht lange währt."
	L.telonicus_inc_trigger = "Gut gemacht. Ihr habt Euch würdig erwiesen, gegen meinen Meisteringenieur, Telonicus, anzutreten."
	L.weapons_inc_trigger = "Wie Ihr seht, habe ich viele Waffen in meinem Arsenal..."
	L.phase3_trigger = "Vielleicht habe ich Euch unterschätzt. Es wäre unfair, Euch gegen meine vier Berater gleichzeitig kämpfen zu lassen, aber... mein Volk wurde auch nie fair behandelt. Ich vergelte nur Gleiches mit Gleichem."
	L.phase4_trigger = "Ach, manchmal muss man die Sache selbst in die Hand nehmen. Balamore shanal!"

	L.flying_trigger = "Ich bin nicht so weit gekommen, um jetzt noch aufgehalten zu werden! Die Zukunft, die ich geplant habe, darf nicht gefährdet werden. Jetzt bekommt Ihr wahre Macht zu spüren!"
	L.flying_message = "Schweben! Gravitationsverlust in 1min"

	L.weapons_inc_message = "Waffen kommen!"
	L.phase3_message = "Phase 2 - Berater und Waffen!"
	L.phase4_message = "Phase 3 - Kael'thas aktiv!"
	L.phase4_bar = "Kael'thas aktiv"

	L.mc = "Gedankenkontrolle"
	L.mc_desc = "Warnt wer von Gedankenkontrolle betroffen ist."

	L.revive_bar = "Berater wiederbeleben"
	L.revive_warning = "Wiederbeleben der Berater in 5sek!"

	L.dead_message = "%s stirbt"

	L.capernian = "Großastromantin Capernian"
	L.sanguinar = "Fürst Blutdurst"
	L.telonicus = "Meisteringenieur Telonicus"
	L.thaladred = "Thaladred der Verfinsterer"
end

