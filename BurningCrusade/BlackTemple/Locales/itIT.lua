local L = BigWigs:NewBossLocale("High Warlord Naj'entus", "itIT")
if not L then return end
if L then
	--L.start_trigger = "You will die in the name of Lady Vashj!"
end

L = BigWigs:NewBossLocale("Supremus", "itIT")
if L then
	--L.normal_phase_trigger = "Supremus punches the ground in anger!"
	--L.kite_phase_trigger = "The ground begins to crack open!"
	--L.normal_phase = "Normal Phase"
	--L.kite_phase = "Kite Phase"
	--L.next_phase = "Next Phase"
end

L = BigWigs:NewBossLocale("Shade of Akama", "itIT")
if L then
	--L.wipe_trigger = "No! Not yet!"
	--L.defender = "Defender" -- Ashtongue Defender
	--L.sorcerer = "Sorcerer" -- Ashtongue Sorcerer
	--L.adds_right = "Adds (Right)"
	--L.adds_left = "Adds (Left)"

	--L.engaged = "Shade of Akama Engaged"
end

L = BigWigs:NewBossLocale("Reliquary of Souls", "itIT")
if L then
	--L.zero_mana = "Zero Mana"
	--L.zero_mana_desc = "Show the time it will take until the Essence of Desire has reduced everyones maximum mana to 0."
	--L.desire_start = "Essence of Desire - Zero Mana in 160 sec"

	L[-15665] = "Fase 1: Essenza della Sofferenza"
	L[-15673] = "Fase 2: Essenza del Desiderio"
	L[-15681] = "Fase 3: Essenza della Rabbia"
end

L = BigWigs:NewBossLocale("The Illidari Council", "itIT")
if L then
	L.veras = "Veras: %s"
	L.malande = "Malande: %s"
	L.gathios = "Gathios: %s"
	L.zerevor = "Zerevor: %s"

	--L.circle_heal_message = "Healed! - Next in ~20sec"
	--L.circle_fail_message = "%s Interrupted! - Next in ~12sec"

	--L.magical_immunity = "Immune to magical!"
	--L.physical_immunity = "Immune to physical!"

	L[-15704] = "Gathios lo Sbriciolatore"
	L[-15716] = "Veras Ombrascura"
	L[-15726] = "Dama Malande"
	L[-15720] = "Gran Fatuomante Zerevor"
end

L = BigWigs:NewBossLocale("Illidan Stormrage", "itIT")
if L then
	--L.barrage_bar = "Barrage"
	--L.warmup_trigger = "Akama. Your duplicity is hardly surprising. I should have slaughtered you and your malformed brethren long ago."

	L[-15735] = "Fase 1: Voi non siete pronti!"
	L[-15740] = "Fase 2: Fiamme di Azzinoth"
	L[-15751] = "Fase 3: Il demone interiore"
	L[-15757] = "Fase 4: La lunga caccia"
end
