local L = BigWigs:NewBossLocale("High Warlord Naj'entus", "frFR")
if not L then return end
if L then
	L.start_trigger = "Vous allez mourir, au nom de dame Vashj !"
end

L = BigWigs:NewBossLocale("Supremus", "frFR")
if L then
	L.normal_phase_trigger = "De rage, Supremus frappe le sol !"
	L.kite_phase_trigger = "Le sol commence à se fissurer !"
	--L.normal_phase = "Normal Phase"
	--L.kite_phase = "Kite Phase"
	--L.next_phase = "Next Phase"
end

L = BigWigs:NewBossLocale("Shade of Akama", "frFR")
if L then
	--L.wipe_trigger = "No! Not yet!"
	--L.defender = "Defender" -- Ashtongue Defender
	--L.sorcerer = "Sorcerer" -- Ashtongue Sorcerer
	--L.adds_right = "Adds (Right)"
	--L.adds_left = "Adds (Left)"

	--L.engaged = "Shade of Akama Engaged"
end

L = BigWigs:NewBossLocale("Reliquary of Souls", "frFR")
if L then
	L.zero_mana = "Zéro Mana"
	--L.zero_mana_desc = "Show the time it will take until the Essence of Desire has reduced everyones maximum mana to 0."
	L.desire_start = "Essence du désir - Zéro Mana dans 160 sec"
end

L = BigWigs:NewBossLocale("The Illidari Council", "frFR")
if L then
	L.veras = "Veras: %s"
	L.malande = "Malande: %s"
	L.gathios = "Gathios: %s"
	L.zerevor = "Zerevor: %s"

	L.circle_heal_message = "Soigné ! - Prochain dans ~20 sec"
	L.circle_fail_message = "Interrompu par %s ! - Prochain dans ~12 sec"

	--L.magical_immunity = "Immune to magical!"
	--L.physical_immunity = "Immune to physical!"
end

L = BigWigs:NewBossLocale("Illidan Stormrage", "frFR")
if L then
	L.barrage_bar = "Barrage"
	L.warmup_trigger = "Akama. Ta duplicité n'est pas très étonnante. J'aurais dû vous massacrer depuis longtemps, toi et ton frère déformé."
end
