local L = BigWigs:NewBossLocale("High Warlord Naj'entus", "ptBR")
if not L then return end
if L then
	--L.start_trigger = "You will die in the name of Lady Vashj!"
end

L = BigWigs:NewBossLocale("Supremus", "ptBR")
if L then
	--L.normal_phase_trigger = "Supremus punches the ground in anger!"
	--L.kite_phase_trigger = "The ground begins to crack open!"
	--L.normal_phase = "Normal Phase"
	--L.kite_phase = "Kite Phase"
	--L.next_phase = "Next Phase"
end

L = BigWigs:NewBossLocale("Shade of Akama", "ptBR")
if L then
	--L.wipe_trigger = "No! Not yet!"
	--L.defender = "Defender" -- Ashtongue Defender
	--L.sorcerer = "Sorcerer" -- Ashtongue Sorcerer
	--L.adds_right = "Adds (Right)"
	--L.adds_left = "Adds (Left)"

	--L.engaged = "Shade of Akama Engaged"
end

L = BigWigs:NewBossLocale("Reliquary of Souls", "ptBR")
if L then
	--L.zero_mana = "Zero Mana"
	--L.zero_mana_desc = "Show the time it will take until the Essence of Desire has reduced everyones maximum mana to 0."
	--L.desire_start = "Essence of Desire - Zero Mana in 160 sec"

	L[-15665] = "Estágio Um: Essência do Sofrimento"
	L[-15673] = "Estágio Dois: Essência do Desejo"
	L[-15681] = "Estágio Três: Essência da Ira"
end

L = BigWigs:NewBossLocale("The Illidari Council", "ptBR")
if L then
	L.veras = "Veras: %s"
	L.malande = "Malande: %s"
	L.gathios = "Gathios: %s"
	L.zerevor = "Zerevor: %s"

	--L.circle_heal_message = "Healed! - Next in ~20sec"
	--L.circle_fail_message = "%s Interrupted! - Next in ~12sec"

	--L.magical_immunity = "Immune to magical!"
	--L.physical_immunity = "Immune to physical!"

	L[-15704] = "Gathios, o Despedaçador"
	L[-15716] = "Veras Sombranera"
	L[-15726] = "Lady Malande"
	L[-15720] = "Sumo Etereomante Zerevor"
end

L = BigWigs:NewBossLocale("Illidan Stormrage", "ptBR")
if L then
	--L.barrage_bar = "Barrage"
	--L.warmup_trigger = "Akama. Your duplicity is hardly surprising. I should have slaughtered you and your malformed brethren long ago."

	L[-15735] = "Estágio Um: Você não está preparado"
	L[-15740] = "Estágio Dois: Chamas de Azzinoth"
	L[-15751] = "Estágio Três: O Demônio Interior"
	L[-15757] = "Estágio Quatro: A Longa Caçada"
end
