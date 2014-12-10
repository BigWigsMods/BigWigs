local L = BigWigs:NewBossLocale("Kargath Bladefist", "ruRU")
if not L then return end
if L then
	L.blade_dance_bar = "Танцуем"
end

L = BigWigs:NewBossLocale("The Butcher", "ruRU")
if L then
	L.adds_multiple = "Помощники x%d"
end

L = BigWigs:NewBossLocale("Tectus", "ruRU")
if L then
	--L.earthwarper_trigger1 = "Yjj'rmr" -- Yjj'rmr... Xzzolos...
	--L.earthwarper_trigger2 = "Yes, Tectus" -- Yes, Tectus. Bend to... our master's... will....
	--L.earthwarper_trigger3 = "You do not understand!" -- You do not understand! This one must not....
	--L.berserker_trigger1 = "MASTER!" -- MASTER! I COME FOR YOU!
	--L.berserker_trigger2 = "Kral'ach" --Kral'ach.... The darkness speaks.... A VOICE!
	--L.berserker_trigger3 = "Graaagh!" --Graaagh! KAHL...  AHK... RAAHHHH!

	L.adds_desc = "Таймеры, когда новые помощники вступят в бой."

	L.custom_off_barrage_marker = "Маркировка Кристаллического залпа"
	L.custom_off_barrage_marker_desc = "Отмечать людей с Кристаллическим залпом {rt1}{rt2}{rt3}{rt4}{rt5}, требуется быть помощником или лидером."

	L.tectus = "Тектоник"
	L.shard = "Осколок"
	L.motes = "Частица"
end

L = BigWigs:NewBossLocale("Brackenspore", "ruRU")
if L then
	L.creeping_moss_boss_heal = "Мох под БОССОМ (исцеление)"
	--L.creeping_moss_add_heal = "Moss under BIG ADD (healing)"
end

L = BigWigs:NewBossLocale("Twin Ogron", "ruRU")
if L then
	L.custom_off_volatility_marker = "Маркировка Непостоянной тайной магии"
	L.custom_off_volatility_marker_desc = "Отмечать людей с Непостоянной тайной магии {rt1}{rt2}{rt3}{rt4}, требуется быть помощником или лидером."
end

L = BigWigs:NewBossLocale("Ko'ragh", "ruRU")
if L then
	--L.suppression_field_trigger1 = "Quiet!"
	--L.suppression_field_trigger2 = "I will tear you in half!"
	--L.suppression_field_trigger3 = "I will crush you!"
	--L.suppression_field_trigger4 = "Silence!"

	L.fire_bar = "Все взорвутся!"

	--L.custom_off_fel_marker = "Expel Magic: Fel Marker"
	--L.custom_off_fel_marker_desc = "Mark Expel Magic: Fel targets with {rt1}{rt2}{rt3}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
end

L = BigWigs:NewBossLocale("Imperator Mar'gok", "ruRU")
if L then
	--L.branded_say = "%s (%d) %dy"

	L.custom_off_fixate_marker = "Маркировка Сосредоточение внимания"
	L.custom_off_fixate_marker_desc = "Отмечать цели Горианских боевых магов метками {rt1}{rt2}, требуется быть помощником или лидером.\n|cFFFF0000Только 1 человек в рейде должен включить эту опцию, чтобы предотвратить конфликты.|r"

	--L.custom_off_branded_marker = "Branded Marker"
	--L.custom_off_branded_marker_desc = "Mark Branded targets with {rt3}{rt4}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"	
end

