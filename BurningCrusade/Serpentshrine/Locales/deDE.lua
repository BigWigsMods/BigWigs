local L = BigWigs:NewBossLocale("Hydross the Unstable", "deDE")
if not L then return end
if L then
	L.start_trigger = "Ich kann nicht zulassen, dass Ihr Euch einmischt!"

	L.mark = "Mal"
	L.mark_desc = "Zeigt Warnungen und Anzahl des Mals."

	L.stance = "Phasenwechsel"
	L.stance_desc = "Warnt wenn Hydross der Unstete seine Phase wechselt."
	L.poison_stance = "Hydross ist nun vergiftet!"
	L.water_stance = "Hydross ist wieder gereinigt!"

	L.debuff_warn = "Mal bei %s%%!"
end

L = BigWigs:NewBossLocale("Fathom-Lord Karathress", "deDE")
if L then
	L.enrage_trigger = "Achtung, Wachen! Wir haben Besuch..."

	L.totem = "Feuerspuckendes Totem"
	L.totem_desc = "Warnt vor dem Feuerspuckenden Totem und wer es aufstellt."
	L.totem_message1 = "Flutvess: Feuerspuckendes Totem"
	L.totem_message2 = "Karathress: Feuerspuckendes Totem"
	L.heal_message = "Caribdis heilt!"

	L.priest = "Tiefenw\195\164chter Caribdis"
end

L = BigWigs:NewBossLocale("Leotheras the Blind", "deDE")
if L then
	L.enrage_trigger = "Endlich hat meine Verbannung ein Ende!"

	L.phase = "D\195\164monenphase"
	L.phase_desc = "Gesch\195\164tzte Timer f\195\188r die D\195\164monenphase."
	L.phase_trigger = "Hinfort, unbedeutender Elf. Ich habe jetzt die Kontrolle!"
	L.phase_demon = "D\195\164monenphase f\195\188r 60sec!"
	L.phase_demonsoon = "D\195\164monenphase in 5sec!"
	L.phase_normalsoon = "Normale Phase in 5sec"
	L.phase_normal = "Normale Phase!"
	L.demon_bar = "D\195\164monenphase"
	L.demon_nextbar = "N\195\164chste D\195\164monenphase"

	L.mindcontrol = "Gedankenkontrolle"
	L.mindcontrol_desc = "Warnt vor \195\188bernommenen Spielern."
	L.mindcontrol_warning = "Gedankenkontrolle"

	L.image = "Schatten von Leotheras"
	L.image_desc = "Meldet die 15% Schatten Abspaltung."
	L.image_trigger = "Ich bin der Meister! H\195\182rt Ihr?"
	L.image_message = "15% - Schatten von Leotheras!"
	L.image_warning = "Schatten von Leotheras bald!"

	L.whisper = "Heimt\195\188ckisches Gefl\195\188ster"
	L.whisper_desc = "Zeigt an, welche Spieler von Heimt\195\188ckisches Gefl\195\188ster betroffen sind."
	L.whisper_message = "D\195\164mon"
	L.whisper_bar = "D\195\164monen verschwinden"
	L.whisper_soon = "~D\195\164monen"
end

L = BigWigs:NewBossLocale("The Lurker Below", "deDE")
if L then
	L.engage_warning = "%s Engaged - M\195\182gliches Abtauchen in 90sek"

	L.dive = "Abtauchen"
	L.dive_desc = "Zeitanzeige wann Das Grauen aus der Tiefe taucht."
	L.dive_warning = "M\195\182gliches Abtauchen in %dsek!"
	L.dive_bar = "~Abtauchen"
	L.dive_message = "Abgetaucht - Zur\195\188ck in 60sek"

	L.spout = "Schwall"
	L.spout_desc = "Gesch\195\164tzte Zeitanzeige f\195\188r Schwall."
	L.spout_message = "Wirkt Schwall!"
	L.spout_warning = "M\195\182glicher Schwall in ~3sek!"
	L.spout_bar = "M\195\182glicher Schwall"

	L.emerge_warning = "Zur\195\188ck in %dsek"
	L.emerge_message = "Aufgetaucht - M\195\182gliches Abtauchen in 90sek"
	L.emerge_bar = "Auftauchen"
end

L = BigWigs:NewBossLocale("Morogrim Tidewalker", "deDE")
if L then
	L.grave_bar = "<Nasses Grab>"
	L.grave_nextbar = "n\195\164chstes Nasses Grab"

	L.murloc = "Murlocs"
	L.murloc_desc = "Warnt vor ankommenden Murlocs."
	L.murloc_bar = "n\195\164chste Murlocs"
	L.murloc_message = "Murlocs kommen!"
	L.murloc_soon_message = "Murlocs bald!"
	L.murloc_engaged = "%s angegriffen, Murlocs in ~40sec"

	L.globules = "Wasserkugeln"
	L.globules_desc = "Warnt vor Wasserkugeln."
	L.globules_trigger1 = "Bald ist es vor\195\188ber!"
	L.globules_trigger2 = "Es gibt kein Entkommen!"
	L.globules_message = "Wasserkugeln kommen!"
	L.globules_warning = "Wasserkugeln bald!"
	L.globules_bar = "Wasserkugeln Despawn"
end

L = BigWigs:NewBossLocale("Lady Vashj", "deDE")
if L then
	L.engage_trigger1 = "Normalerweise würde ich mich nicht herablassen, Euresgleichen persönlich gegenüberzutreten, aber ihr lasst mir keine Wahl..."
	L.engage_trigger2 = "Ich spucke auf Euch, Oberweltler!" -- up to date as of 2.3.3
	L.engage_trigger3 = "Sieg für Fürst Illidan!" -- up to date as of 2.3.3
	L.engage_trigger4 = "Ich werde Euch der Länge nach spalten!" -- to be checked
	L.engage_trigger5 = "Tod den Eindringlingen!"
	L.engage_message = "Phase 1"

	L.phase = "Phasenwarnung"
	L.phase_desc = "Warnt, wenn Vashj ihre Phase wechselt."
	L.phase2_trigger = "Die Zeit ist gekommen! Lasst keinen am Leben!"
	L.phase2_soon_message = "Phase 2 bald!"
	L.phase2_message = "Phase 2, Adds kommen!"
	L.phase3_trigger = "Geht besser in Deckung!"
	L.phase3_message = "Phase 3 - Wutanfall in 4min!"

	L.elemental = "Besudelter Elementar Spawn"
	L.elemental_desc = "Warnt, wenn ein Besudelter Elementar während Phase 2 spawnt."
	L.elemental_bar = "Besudelter Elementar kommt"
	L.elemental_soon_message = "Besudelter Elementar bald!"

	L.strider = "Schreiter des Echsenkessels Spawn"
	L.strider_desc = "Warnt, wenn ein Schreiter des Echsenkessels während Phase 2 spawnt."
	L.strider_bar = "Schreiter kommt"
	L.strider_soon_message = "Schreiter bald!"

	L.naga = "Naga Elite spawn"
	L.naga_desc = "Warnt, wenn ein Naga Elite während Phase 2 spawnt."
	L.naga_bar = "Naga Elite kommt"
	L.naga_soon_message = "Naga Elite bald!"

	L.barrier_desc = "Alarmiert, wenn die Barrieren in Phase 2 zerstört werden."
	L.barrier_down_message = "Barriere %d/4 zerstört!"
end

