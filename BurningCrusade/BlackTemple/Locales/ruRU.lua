local L = BigWigs:NewBossLocale("High Warlord Naj'entus", "ruRU")
if not L then return end
if L then
	L.start_trigger = "Вы умрете во имя леди Вайш!"
end

L = BigWigs:NewBossLocale("Supremus", "ruRU")
if L then
	L.normal_phase_trigger = "Супремус в гневе ударяет по земле!"
	L.kite_phase_trigger = "Земля начинает раскалываться!"
	L.normal_phase = "Обычная фаза"
	L.kite_phase = "Кайт фаза"
	L.next_phase = "След. фаза"

	L.fixate = mod:SpellName(40607)
	L.fixate_icon = 40607
end

L = BigWigs:NewBossLocale("Shade of Akama", "ruRU")
if L then
	--L.wipe_trigger = "No! Not yet!"
	L.defender = "Защитник" -- Ashtongue Defender
	L.sorcerer = "Колдун" -- Ashtongue Sorcerer
	L.adds_right = "Адды (Справа)"
	L.adds_left = "Адды (Слева)"

	L.engaged = "Тень Акамы вступает в бой"
end

L = BigWigs:NewBossLocale("Reliquary of Souls", "ruRU")
if L then
	L.zero_mana = "Нет маны"
	L.zero_mana_desc = "Показывает время до момента когда кол-во маны уменьшится до нуля"
	L.zero_mana_icon = "spell_shadow_manaburn"
	L.desire_start = "Воплощение мечты - Кол-во маны уменьшится до нуля через 160 сек"

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

	L.magical_immunity = "Неуязвим к МАГ. эфф.!"
	L.physical_immunity = "Неуязвим к ФИЗ. эфф.!"

	L[-15704] = "Гатиос Изувер"
	L[-15716] = "Верас Глубокий Мрак"
	L[-15726] = "Леди Маланда"
	L[-15720] = "Верховный пустомант Зеревор"
end

L = BigWigs:NewBossLocale("Illidan Stormrage", "ruRU")
if L then
	L.barrage_bar = "Темный огонь"
	L.warmup_trigger = "Акама. Я не удивлен твоей двуличностью. Давно нужно было убить тебя и твоих мерзких прихвостней."

	L[-15735] = "Фаза первая: Вы не готовы!"
	L[-15740] = "Фаза вторая: Пламя Аззинота"
	L[-15751] = "Фаза третья: Демон внутри"
	L[-15757] = "Фаза четвертая: Длинная охота"
end
