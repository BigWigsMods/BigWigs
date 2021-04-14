local L = BigWigs:NewBossLocale("High Warlord Naj'entus", "deDE")
if not L then return end
if L then
	L.start_trigger = "Im Namen Lady Vashjs werdet Ihr sterben!"
end

L = BigWigs:NewBossLocale("Supremus", "deDE")
if L then
	L.normal_phase_trigger = "Supremus schlägt wütend auf den Boden!"
	L.kite_phase_trigger = "Der Boden beginnt aufzubrechen!"
	--L.normal_phase = "Normal Phase"
	--L.kite_phase = "Kite Phase"
	--L.next_phase = "Next Phase"
end

L = BigWigs:NewBossLocale("Shade of Akama", "deDE")
if L then
	--L.wipe_trigger = "No! Not yet!"
	--L.defender = "Defender" -- Ashtongue Defender
	--L.sorcerer = "Sorcerer" -- Ashtongue Sorcerer
	--L.adds_right = "Adds (Right)"
	--L.adds_left = "Adds (Left)"

	--L.engaged = "Shade of Akama Engaged"
end

L = BigWigs:NewBossLocale("Reliquary of Souls", "deDE")
if L then
	L.zero_mana = "Kein Mana"
	--L.zero_mana_desc = "Show the time it will take until the Essence of Desire has reduced everyones maximum mana to 0."
	L.desire_start = "Essenz der Begierde - Kein Mana in 160sec"

	L[-15665] = "Phase 1: Essenz des Leidens"
	L[-15673] = "Phase 2: Essenz der Begierde"
	L[-15681] = "Phase 3: Essenz des Zorns"
end

L = BigWigs:NewBossLocale("The Illidari Council", "deDE")
if L then
	L.veras = "Veras: %s"
	L.malande = "Malande: %s"
	L.gathios = "Gathios: %s"
	L.zerevor = "Zerevor: %s"

	L.circle_heal_message = "Geheilt! - Nächster in ~20sek"
	L.circle_fail_message = "%s unterbrochen! - Nächster in ~12sek"

	--L.magical_immunity = "Immune to magical!"
	--L.physical_immunity = "Immune to physical!"

	L[-15704] = "Gathios der Zerschmetterer"
	L[-15716] = "Veras Schwarzschatten"
	L[-15726] = "Lady Malande"
	L[-15720] = "Hochnethermant Zerevor"
end

L = BigWigs:NewBossLocale("Illidan Stormrage", "deDE")
if L then
	L.barrage_bar = "Sperrfeuer"
	L.warmup_trigger = "Akama. Euer falsches Spiel überrascht mich nicht. Ich hätte Euch und Eure missgestalteten Brüder schon vor langer Zeit abschlachten sollen."

	L[-15735] = "Phase 1: Ihr wisst nicht, was Euch erwartet"
	L[-15740] = "Phase 2: Flammen von Azzinoth"
	L[-15751] = "Phase 3: Der innere Dämon"
	L[-15757] = "Phase 4: Die lange Jagd"
end
