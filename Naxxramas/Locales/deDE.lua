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

	L.decimate_bar = "Dezimieren"
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

	L.startwarn = "Die Vier Reiter angegriffen! Male in ~17 sek."
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "deDE")
if L then
	L.bossName = "Kel'Thuzad"
	L.KELTHUZADCHAMBERLOCALIZEDLOLHAX = "Kel'Thuzads Gemächer"

	L.start_trigger = "Lakaien, Diener, Soldaten der eisigen Finsternis! Folgt dem Ruf von Kel'Thuzad!"
	L.start_warning = "Kel'Thuzad gestartet! ~3:30 min, bis er aktiv wird!"

	L.phase2_trigger1 = "Betet um Gnade!"
	L.phase2_trigger2 = "Schreiend werdet ihr diese Welt verlassen!"
	L.phase2_trigger3 = "Euer Ende ist gekommen!"
	L.phase2_warning = "Phase 2, Kel'Thuzad kommt!"
	L.phase2_bar = "Kel'Thuzad aktiv"

	L.phase3_trigger = "Meister, ich benötige Beistand."
	L.phase3_soon_warning = "Phase 3 bald!"
	L.phase3_warning = "Phase 3, Wächter in ~15 sek!"

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

	L.doom_5sec_warn = "Unausweichliches Schicksal (%d) in 5 sek!"
	L.doomtime_bar = "Schicksal alle 15 sek"
	L.doomtime_warn = "Schicksal: Timer Wechsel in %s sek!"
	L.doomtime_now = "Unausweichliches Schicksal nun alle 15 sek!"

	L.remove_curse = "Flüche bei Loatheb aufgehoben"

	L.spore_warn = "Spore (%d)!"
end

L = BigWigs:NewBossLocale("Noth the Plaguebringer", "deDE")
if L then
	L.bossName = "Noth der Seuchenfürst"

	L.starttrigger1 = "Sterbt, Eindringling!"
	L.starttrigger2 = "Ehre unserem Meister!"
	L.starttrigger3 = "Euer Leben ist verwirkt!"
	L.startwarn = "Noth angegriffen! Teleport in 90 sek!"
	L.add_trigger = "Erhebt euch, Soldaten! Erhebt euch und kämpft erneut!"

	L.blink = "Blinzeln"
	L.blink_desc = "Warnungen und Timer für Blinzeln."
	L.blink_trigger = "%s blinzelt sich davon!"
	L.blink_bar = "Blinzeln"

	L.teleport = "Teleport"
	L.teleport_desc = "Warnungen und Timer für Teleport."
	L.teleport_bar = "Teleport"
	L.teleportwarn = "Teleport! Noth auf dem Balkon!"
	L.teleportwarn2 = "Teleport in 10 sek!"
	L.back_bar = "Rückteleport"
	L.back_warn = "Noth zurück im Raum für %d sek!"
	L.back_warn2 = "Rückteleport in 10 sek!"

	L.curse_explosion = "Fluch Explosion!"
	L.curse_warn = "Fluch! Nächster in ~55 sek."
	L.curse_10sec_warn = "Fluch in ~10 sek!"
	L.curse_bar = "Nächster Fluch"

	L.wave = "Wellen"
	L.wave_desc = "Warnungen und Timer für die Gegnerwellen."
	L.wave1_bar = "Welle 1"
	L.wave2_bar = "Welle 2"
	L.wave2_message = "Welle 2 in 10 sek!"
end

L = BigWigs:NewBossLocale("Patchwerk", "deDE")
if L then
	L.bossName = "Flickwerk"
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

	L.deepbreath_trigger = "%s atmet tief ein..."

	-- L.air_phase = "Air phase"
	-- L.ground_phase = "Ground phase"

	L.deepbreath = "Eisbombe"
	L.deepbreath_warning = "Eisbombe kommt!"
	L.deepbreath_bar = "Eisbombe landet!"

	L.icebolt_say = "Ich bin ein Eisblock!"
end

L = BigWigs:NewBossLocale("Instructor Razuvious", "deDE")
if L then
	L.bossName = "Instrukteur Razuvious"
	L.understudy = "Reservist der Todesritter"

	L.taunt_warning = "Spott bereit in 5 sek!"
	L.shieldwall_warning = "Knochenbarriere weg in 5 sek!"
end

L = BigWigs:NewBossLocale("Thaddius", "deDE")
if L then
	L.bossName = "Thaddius"

	L.trigger_phase1_1 = "Stalagg zerquetschen!"
	L.trigger_phase1_2 = "Verfüttere euch an Meister!"
	L.trigger_phase2_1 = "Eure... Knochen... zermalmen..."
	L.trigger_phase2_2 = "Euch... zerquetschen!"
	L.trigger_phase2_3 = "Töten..."

	L.polarity_trigger = "Jetzt spürt ihr den Schmerz..."

	L.polarity_warning = "Polaritätsveränderung in 3 sek!"
	L.polarity_changed = "Polarität geändert!"
	L.polarity_nochange = "Selbe Polarität!"
	L.polarity_first_positive = "Du bist POSITIV!"
	L.polarity_first_negative = "Du bist NEGATIV!"

	L.phase1_message = "Phase 1"
	L.phase2_message = "Thaddius Phase 2 - Berserker in 5 min"

	L.throw = "Magnetische Anziehung"
	L.throw_desc = "Warnt, wenn die Tanks die Plattform wechseln."
	L.throw_warning = "Magnetische Anziehung in ~5 sek!"

	-- L.polarity_extras = "Additional alerts for Polarity positioning. Make sure to only choose one strategy!"

	-- L.custom_off_charge_RL = "Strategy 1"
	-- L.custom_off_charge_RL_desc = "|cffff2020Negative (-)|r are LEFT, |cff20ff20Positive (+)|r are RIGHT. Start in front of the boss."
	-- L.custom_off_charge_LR = "Strategy 2"
	-- L.custom_off_charge_LR_desc = "|cff20ff20Positive (+)|r are LEFT, |cffff2020Negative (-)|r are RIGHT. Start in front of the boss."

	-- L.custom_off_charge_text = "Text arrows"
	-- L.custom_off_charge_text_desc = "Show a message with the direction to move when Polarity Shift happens."
	-- L.custom_off_charge_voice = "Voice alerts"
	-- L.custom_off_charge_voice_desc = "Play a voice alert when Polarity Shift happens."

	-- Translate these to get locale sound files!
	L.warn_left = "<--- Nach Links <--- Nach Links <---"
	L.warn_right = "---> Nach Rechts ---> Nach Rechts --->"
	L.warn_swap = "^^^^ Seitenwechseln ^^^^ Seitenwechseln ^^^^"
	L.warn_stay = "==== Nicht Bewegen ==== Nicht Bewegen ===="
end
