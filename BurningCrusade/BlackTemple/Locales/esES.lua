local L = BigWigs:NewBossLocale("High Warlord Naj'entus", "esES") or BigWigs:NewBossLocale("High Warlord Naj'entus", "esMX")
if not L then return end
if L then
	L.start_trigger = "¡Moriréis en el nombre de Lady Vashj!"
end

L = BigWigs:NewBossLocale("Supremus", "esES") or BigWigs:NewBossLocale("Supremus", "esMX")
if L then
	L.normal_phase_trigger = "¡Supremus golpea el suelo enfadado!"
	L.kite_phase_trigger = "El suelo comienza a abrirse."
	--L.normal_phase = "Normal Phase"
	--L.kite_phase = "Kite Phase"
	--L.next_phase = "Next Phase"
end

L = BigWigs:NewBossLocale("Shade of Akama", "esES") or BigWigs:NewBossLocale("Shade of Akama", "esMX")
if L then
	--L.wipe_trigger = "No! Not yet!"
	--L.defender = "Defender" -- Ashtongue Defender
	--L.sorcerer = "Sorcerer" -- Ashtongue Sorcerer
	--L.adds_right = "Adds (Right)"
	--L.adds_left = "Adds (Left)"

	--L.engaged = "Shade of Akama Engaged"
end

L = BigWigs:NewBossLocale("Reliquary of Souls", "esES") or BigWigs:NewBossLocale("Reliquary of Souls", "esMX")
if L then
	L.zero_mana = "Sin Maná"
	--L.zero_mana_desc = "Show the time it will take until the Essence of Desire has reduced everyones maximum mana to 0."
	L.desire_start = "Esencia de Deseo - Sin Maná en 160 seg"

	L[-15665] = "Fase 1: Esencia de Sufrimiento"
	L[-15673] = "Fase 2: Esencia de deseo"
	L[-15681] = "Fase 3: Esencia de inquina"
end

L = BigWigs:NewBossLocale("The Illidari Council", "esES") or BigWigs:NewBossLocale("The Illidari Council", "esMX")
if L then
	L.veras = "Veras: %s"
	L.malande = "Malande: %s"
	L.gathios = "Gathios: %s"
	L.zerevor = "Zerevor: %s"

	L.circle_heal_message = "¡Se ha curado! - Prox. en ~20seg"
	L.circle_fail_message = "¡%s Interrumpido! - Prox. en ~12seg"

	--L.magical_immunity = "Immune to magical!"
	--L.physical_immunity = "Immune to physical!"

	L[-15704] = "Gathios el Despedazador	"
	L[-15716] = "Veras Sombra Oscura"
	L[-15726] = "Lady Malande"
	L[-15720] = "Sumo abisálico Zerevor"
end

L = BigWigs:NewBossLocale("Illidan Stormrage", "esES") or BigWigs:NewBossLocale("Illidan Stormrage", "esMX")
if L then
	L.barrage_bar = "Tromba"
	L.warmup_trigger = "Akama. Tu hipocresía no me sorprende. Debí acabar contigo y con tus malogrados hermanos hace tiempo."

	L[-15735] = "Fase 1: No estáis preparados"
	L[-15740] = "Fase 2: Las llamas de Azzinoth"
	L[-15751] = "Fase 3: El demonio interior"
	L[-15757] = "Fase 4: La gran cacería"
end
