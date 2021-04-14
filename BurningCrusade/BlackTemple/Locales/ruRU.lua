local L = BigWigs:NewBossLocale("High Warlord Naj'entus", "ruRU")
if not L then return end
if L then
	L.start_trigger = "Вы умрете во имя леди Вайш!"
end

L = BigWigs:NewBossLocale("Supremus", "ruRU")
if L then
	L.normal_phase_trigger = "Супремус в гневе ударяет по земле!"
	L.kite_phase_trigger = "Земля начинает раскалываться!"
	--L.normal_phase = "Normal Phase"
	--L.kite_phase = "Kite Phase"
	--L.next_phase = "Next Phase"
end

L = BigWigs:NewBossLocale("Shade of Akama", "ruRU")
if L then
	--L.wipe_trigger = "No! Not yet!"
	--L.defender = "Defender" -- Ashtongue Defender
	--L.sorcerer = "Sorcerer" -- Ashtongue Sorcerer
	--L.adds_right = "Adds (Right)"
	--L.adds_left = "Adds (Left)"

	--L.engaged = "Shade of Akama Engaged"
end

L = BigWigs:NewBossLocale("Reliquary of Souls", "ruRU")
if L then
	--L.zero_mana = "Zero Mana"
	--L.zero_mana_desc = "Show the time it will take until the Essence of Desire has reduced everyones maximum mana to 0."
	--L.desire_start = "Essence of Desire - Zero Mana in 160 sec"

	L[-15665] = "Фаза 1: Воплощение страдания"
	L[-15673] = "Фаза 2: Воплощение мечты"
	L[-15681] = "Фаза 3: Воплощение гнева"
end

L = BigWigs:NewBossLocale("The Illidari Council", "ruRU")
if L then
	L.veras = "Верас: %s"
	L.malande = "Маланда: %s"
	L.gathios = "Гатиос: %s"
	L.zerevor = "Зеревор: %s"

	L.circle_heal_message = "Исцелен! - Следующее через ~20сек"
	L.circle_fail_message = "Прервал %s! - Следующее через ~12sec"

	--L.magical_immunity = "Immune to magical!"
	--L.physical_immunity = "Immune to physical!"

	L[-15704] = "Гатиос Изувер"
	L[-15716] = "Верас Глубокий Мрак"
	L[-15726] = "Леди Маланда"
	L[-15720] = "Верховный пустомант Зеревор"
end

L = BigWigs:NewBossLocale("Illidan Stormrage", "ruRU")
if L then
	--L.barrage_bar = "Barrage"
	L.warmup_trigger = "Акама! Твое двуличие меня не удивляет. Мне давным-давно стоило уничтожить тебя и твоих уродливых собратьев."

		L[-15735] = "Stage One: You Are Not Prepared"
		L[-15740] = "Stage Two: Flames of Azzinoth"
		L[-15751] = "Stage Three: The Demon Within"
		L[-15757] = "Stage Four: The Long Hunt"
end
