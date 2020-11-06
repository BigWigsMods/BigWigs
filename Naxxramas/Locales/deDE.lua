local L = BigWigs:NewBossLocale("Anub'Rekhan", "deDE")
if not L then return end
if L then
	L.bossName = "Anub'Rekhan"

	L.gainwarn10sec = "Heuschreckenschwarm in ~10 sek!"
	L.gainincbar = "~Nächster Schwarm"
end

L = BigWigs:NewBossLocale("Grand Widow Faerlina", "deDE")
if L then
	L.bossName = "Großwitwe Faerlina"

	L.silencewarn = "Stille! Raserei verzögert!"
	L.silencewarn5sec = "Stille endet in 5 sek!"
end

L = BigWigs:NewBossLocale("Gluth", "deDE")
if L then
	L.bossName = "Gluth"

	L.startwarn = "Gluth angegriffen! ~105 sek bis Dezimieren!"

	L.decimatesoonwarn = "Dezimieren bald!"
	L.decimatebartext = "~Dezimieren"
end

L = BigWigs:NewBossLocale("Gothik the Harvester", "deDE")
if L then
	L.bossName = "Gothik der Ernter"

	L.room = "Ankunft"
	L.room_desc = "Warnungen und Timer für die Ankunft von Gothik im Raum."

	L.add = "Adds"
	L.add_desc = "Warnungen und Timer für die Adds."

	L.adddeath = "Tod eines Adds"
	L.adddeath_desc = "Warnt, wenn ein Add stirbt."

	L.starttrigger1 = "Ihr Narren habt euren eigenen Untergang heraufbeschworen."
	L.starttrigger2 = "Maz Azgala veni kamil toralar Naztheros zennshinagas."
	L.startwarn = "Gothik der Ernter angegriffen! Im Raum in 4:30 min!"

	L.rider = "Unerbittlicher Reiter"
	L.spectral_rider = "Spektraler Reiter"
	L.deathknight = "Unerbittlicher Todesritter"
	L.spectral_deathknight = "Spektraler Todesritter"
	L.trainee = "Unerbittlicher Lehrling"
	L.spectral_trainee = "Spektraler Lehrling"

	L.riderdiewarn = "Reiter tot!"
	L.dkdiewarn = "Todesritter tot!"

	L.warn1 = "Im Raum in 3 min"
	L.warn2 = "Im Raum in 90 sek"
	L.warn3 = "Im Raum in 60 sek"
	L.warn4 = "Im Raum in 30 sek!"
	L.warn5 = "Gothik im Raum in 10 sek!"

	L.wave = "%d/23: %s"

	L.trawarn = "Lehrlinge in 3 sek!"
	L.dkwarn = "Todesritter in 3 sek!"
	L.riderwarn = "Reiter in 3 sek!"

	L.trabar = "Lehrling (%d)"
	L.dkbar = "Todesritter (%d)"
	L.riderbar = "Reiter (%d)"

	L.inroomtrigger = "Ich habe lange genug gewartet. Stellt euch dem Seelenjäger."
	L.inroomwarn = "Gothik im Raum!"

	L.inroombartext = "Gothik im Raum"
end

L = BigWigs:NewBossLocale("Grobbulus", "deDE")
if L then
	L.bossName = "Grobbulus"

	L.bomb_message = "Injektion"
	L.bomb_message_other = "%s ist verseucht!"
end

L = BigWigs:NewBossLocale("Heigan the Unclean", "deDE")
if L then
	L.bossName = "Heigan der Unreine"

	L.starttrigger = "Ihr gehört mir..."
	L.starttrigger2 = "Ihr seid.... als nächstes dran."
	L.starttrigger3 = "Ihr entgeht mir nicht..."

	L.engage = "Angriff"
	L.engage_desc = "Warnt, wenn Heigan angegriffen wird."
	L.engage_message = "Heigan der Unreine angegriffen! Teleport in 90 sek!"

	L.teleport = "Teleport"
	L.teleport_desc = "Warnungen und Timer für Teleport."
	L.teleport_trigger = "Euer Ende naht."
	L.teleport_1min_message = "Teleport in 1 min"
	L.teleport_30sec_message = "Teleport in 30 sek"
	L.teleport_10sec_message = "Teleport in 10 sek!"
	L.on_platform_message = "Teleport! Auf Plattform für 45 sek!"

	L.to_floor_30sec_message = "Zurück in 30 sek"
	L.to_floor_10sec_message = "Zurück in 10 sek!"
	L.on_floor_message = "Zurück im Raum! Nächster Teleport in 90 sek!"

	L.teleport_bar = "Teleport"
	L.back_bar = "Zurück im Raum"
end

L = BigWigs:NewBossLocale("The Four Horsemen", "deDE")
if L then
	L.bossName = "Die Vier Reiter"

	L.mark = "Male"
	L.mark_desc = "Warnungen und Timer für die Male."
	L.markbar = "Mal (%d)"
	L.markwarn1 = "Mal (%d)!"
	L.markwarn2 = "Mal (%d) in 5 sek!"

	L.dies = "#%d getötet"

	L.startwarn = "Die Vier Reiter angegriffen! Male in ~17 sek."
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "deDE")
if L then
	L.bossName = "Kel'Thuzad"

	L.KELTHUZADCHAMBERLOCALIZEDLOLHAX = "Kel'Thuzads Gemach"

	L.start_trigger = "Lakaien, Diener, Soldaten der eisigen Finsternis! Folgt dem Ruf von Kel'Thuzad!"
	L.start_warning = "Kel'Thuzad gestartet! ~3:30 min, bis er aktiv wird!"
	L.start_bar = "Phase 2"

	L.phase = "Phasen"
	L.phase_desc = "Warnt bei Phasenwechsel."
	L.phase2_trigger1 = "Betet um Gnade!"
	L.phase2_trigger2 = "Schreiend werdet ihr diese Welt verlassen!"
	L.phase2_trigger3 = "Euer Ende ist gekommen!"
	L.phase2_warning = "Phase 2, Kel'Thuzad kommt!"
	L.phase2_bar = "Kel'Thuzad aktiv"
	L.phase3_soon_warning = "Phase 3 bald!"
	L.phase3_trigger = "Meister, ich benötige Beistand."
	L.phase3_warning = "Phase 3, Wächter in ~15 sek!"

	L.mc_message = "Gedankenkontrolle: %s"
	L.mc_warning = "Gedankenkontrolle bald!"
	L.mc_nextbar = "~Gedankenkontrolle"

	L.frostblast_bar = "~Frostschlag"
	L.frostblast_soon_message = "Frostschlag in ~5 sek!"

	L.detonate_other = "Detonierendes Mana: %s"
	L.detonate_possible_bar = "~Detonierendes Mana"
	L.detonate_warning = "Detonierendes Mana in 5 sek!"

	L.guardians = "Wächter"
	L.guardians_desc = "Warnt vor den Wächtern von Eiskrone in Phase 3."
	L.guardians_trigger = "Wohlan, Krieger der Eisigen Weiten, erhebt euch! Ich befehle euch für euren Meister zu kämpfen, zu töten und zu sterben! Keiner darf überleben!"
	L.guardians_warning = "Wächter in ~10 sek!"
	L.guardians_bar = "Wächter kommen"
end

L = BigWigs:NewBossLocale("Loatheb", "deDE")
if L then
	L.bossName = "Loatheb"

	L.startwarn = "Loatheb angegriffen! 2 min bis Unausweichliches Schicksal!"

	L.aura_message = "Nekrotische Aura - Dauer 17 sek!"
	L.aura_warning = "Nekrotische Aura schwindet in 3 sek!"

	L.deathbloom_warning = "Todesblüte in 5 sek!"

	L.doombar = "Unausweichliches Schicksal (%d)"
	L.doomwarn = "Unausweichliches Schicksal (%d)! %d sek bis zum nächsten."
	L.doomwarn5sec = "Unausweichliches Schicksal (%d) in 5 sek!"
	L.doomtimerbar = "Schicksal alle 15 sek"
	L.doomtimerwarn = "Schicksal: Timer Wechsel in %s sek!"
	L.doomtimerwarnnow = "Unausweichliches Schicksal nun alle 15 sek!"

	L.sporewarn = "Spore (%d)!"
	L.sporebar = "Spore (%d)"
end

L = BigWigs:NewBossLocale("Noth the Plaguebringer", "deDE")
if L then
	L.bossName = "Noth der Seuchenfürst"

	L.starttrigger1 = "Sterbt, Eindringling!"
	L.starttrigger2 = "Ehre unserem Meister!"
	L.starttrigger3 = "Euer Leben ist verwirkt!"
	L.startwarn = "Noth angegriffen! Teleport in 90 sek!"

	L.blink = "Blinzeln"
	L.blink_desc = "Warnungen und Timer für Blinzeln."
	L.blinktrigger = "%s blinzelt sich davon!"
	L.blinkwarn = "Blinzeln!"
	L.blinkwarn2 = "Blinzeln in ~5 sek!"
	L.blinkbar = "Blinzeln"

	L.teleport = "Teleport"
	L.teleport_desc = "Warnungen und Timer für Teleport."
	L.teleportbar = "Teleport"
	L.backbar = "Rückteleport"
	L.teleportwarn = "Teleport! Noth auf dem Balkon!"
	L.teleportwarn2 = "Teleport in 10 sek!"
	L.backwarn = "Noth zurück im Raum für %d sek!"
	L.backwarn2 = "Rückteleport in 10 sek!"

	L.curseexplosion = "Fluch Explosion!"
	L.cursewarn = "Fluch! Nächster in ~55 sek."
	L.curse10secwarn = "Fluch in ~10 sek!"
	L.cursebar = "Nächster Fluch"

	L.wave = "Wellen"
	L.wave_desc = "Warnungen und Timer für die Gegnerwellen."
	L.addtrigger = "Erhebt euch, Soldaten! Erhebt euch und kämpft erneut!"
	L.wave1bar = "Welle 1"
	L.wave2bar = "Welle 2"
	L.wave2_message = "Welle 2 in 10 sek!"
end

L = BigWigs:NewBossLocale("Patchwerk", "deDE")
if L then
	L.bossName = "Flickwerk"

	L.enragewarn = "5% - Raserei!"
	L.starttrigger1 = "Flickwerk spielen möchte!"
	L.starttrigger2 = "Kel’Thuzad macht Flickwerk zu seinem Abgesandten von Krieg!" -- Yes, that's really a ´ instead of a '
end

L = BigWigs:NewBossLocale("Maexxna", "deDE")
if L then
	L.bossName = "Maexxna"

	L.webspraywarn30sec = "Fangnetz in 10 sek!"
	L.webspraywarn20sec = "Fangnetz! Spinnen in 10 sek!"
	L.webspraywarn10sec = "Spinnen! Gespinstschauer in 10 sek!"
	L.webspraywarn5sec = "Gespinstschauer in 5 sek!"
	L.enragewarn = "Raserei!"
	L.enragesoonwarn = "Raserei bald!"

	L.cocoonbar = "Fangnetz"
	L.spiderbar = "Spinnen"
end

L = BigWigs:NewBossLocale("Sapphiron", "deDE")
if L then
	L.bossName = "Saphiron"

	L.airphase_trigger = "Saphiron erhebt sich in die Lüfte!" -- No %s in deDE, we need the translated name!
	L.deepbreath_incoming_message = "Frostatem in ~23 sek!"
	L.deepbreath_incoming_soon_message = "Frostatem in ~5 sek!"
	L.deepbreath_incoming_bar = "Wirkt Frostatem..."
	L.deepbreath_trigger = "%s holt tief Luft."
	L.deepbreath_warning = "Frostatem kommt!"
	L.deepbreath_bar = "Frostatem landet!"

	L.lifedrain_message = "Lebensentzug! Nächster in ~24 sek!"
	L.lifedrain_warn1 = "Lebensentzug in ~5 sek!"
	L.lifedrain_bar = "~Lebensentzug"

	L.icebolt_say = "Ich bin ein Eisblock!"

	L.ping_message = "Eisblock - Pinge deine Position!"
end

L = BigWigs:NewBossLocale("Instructor Razuvious", "deDE")
if L then
	L.bossName = "Instrukteur Razuvious"

	L.shout_warning = "Unterbrechender Schrei in 5 sek!"
	L.shout_next = "~Unterbrechender Schrei"

	L.taunt_warning = "Spott bereit in 5 sek!"
	L.shieldwall_warning = "Knochenbarriere weg in 5 sek!"
end

L = BigWigs:NewBossLocale("Thaddius", "deDE")
if L then
	L.bossName = "Thaddius"

	L.phase = "Phasen"
	L.phase_desc = "Warnt bei Phasenwechsel."

	L.throw = "Magnetische Anziehung"
	L.throw_desc = "Warnt, wenn die Tanks die Plattform wechseln."

	L.trigger_phase1_1 = "Stalagg zerquetschen!"
	L.trigger_phase1_2 = "Verfüttere euch an Meister!"
	L.trigger_phase2_1 = "Eure... Knochen... zermalmen..."
	L.trigger_phase2_2 = "Euch... zerquetschen!"
	L.trigger_phase2_3 = "Töten..."

	L.polarity_trigger = "Jetzt spürt ihr den Schmerz..."
	L.polarity_message = "Thaddius beginnt Polaritätsveränderung zu wirken!"
	L.polarity_warning = "Polaritätsveränderung in 3 sek!"
	L.polarity_bar = "Polaritätsveränderung"
	L.polarity_changed = "Polarität geändert!"
	L.polarity_nochange = "Selbe Polarität!"

	L.polarity_first_positive = "Du bist POSITIV!"
	L.polarity_first_negative = "Du bist NEGATIV!"

	L.phase1_message = "Phase 1"
	L.phase2_message = "Thaddius Phase 2, Berserker in 6 min"

	L.surge_message = "Kraftsog auf Stalagg!"

	L.throw_bar = "Magnetische Anziehung"
	L.throw_warning = "Magnetische Anziehung in ~5 sek!"
end
