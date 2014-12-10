local L = BigWigs:NewBossLocale("Kargath Bladefist", "deDE")
if not L then return end
if L then
	L.blade_dance_bar = "Tanzen"
end

L = BigWigs:NewBossLocale("The Butcher", "deDE")
if L then
	--L.adds_multiple = "Adds x%d"
end

L = BigWigs:NewBossLocale("Tectus", "deDE")
if L then
	--L.earthwarper_trigger1 = "Yjj'rmr" -- Yjj'rmr... Xzzolos...
	L.earthwarper_trigger2 = "Ja, Tectus" -- Yes, Tectus. Bend to... our master's... will....
	L.earthwarper_trigger3 = "Ihr versteht nicht!" -- You do not understand! This one must not....
	L.berserker_trigger1 = "MEISTER!" -- MASTER! I COME FOR YOU!
	--L.berserker_trigger2 = "Kral'ach" --Kral'ach.... The darkness speaks.... A VOICE!
	--L.berserker_trigger3 = "Graaagh!" --Graaagh! KAHL...  AHK... RAAHHHH!

	--L.tectus = "Tectus"
	L.shard = "Splitter"
	L.motes = "Partikel"

	L.custom_off_barrage_marker = "Kristallbeschuss markieren"
	L.custom_off_barrage_marker_desc = "Markiert die Ziele von Kristallbeschuss mit {rt1}{rt2}{rt3}{rt4}{rt5}, benötigt Leiter oder Assistent."

	L.adds_desc = "Timer für das Erscheinen von Adds."
end

L = BigWigs:NewBossLocale("Brackenspore", "deDE")
if L then
	L.creeping_moss_boss_heal = "Moos unter dem BOSS (Heilung)"
	L.creeping_moss_add_heal = "Moos unter GROSSEM ADD (Heilung)"
end

L = BigWigs:NewBossLocale("Twin Ogron", "deDE")
if L then
	L.custom_off_volatility_marker = "Arkane Flüchtigkeit markieren"
	L.custom_off_volatility_marker_desc = "Markiert die Ziele von Arkane Flüchtigkeit mit {rt1}{rt2}{rt3}{rt4}, benötigt Leiter oder Assistent."
end

L = BigWigs:NewBossLocale("Ko'ragh", "deDE")
if L then
	L.suppression_field_trigger1 = "Ruhe!"
	L.suppression_field_trigger2 = "Ich reiße Euch in Stücke!"
	L.suppression_field_trigger3 = "Ich werde Euch zermalmen!"
	L.suppression_field_trigger4 = "Schweigt!"

	L.fire_bar = "Alle explodieren!"

	L.custom_off_fel_marker = "Magie ausstoßen: Teufelsenergie markieren"
	L.custom_off_fel_marker_desc = "Markiert die Ziele von Magie ausstoßen: Teufelsenergie mit {rt1}{rt2}{rt3}, benötigt Leiter oder Assistent.\n|cFFFF0000Um Konflikte beim Markieren zu vermeiden, sollte lediglich 1 Person im Raid diese Option aktivieren.|r"
end

L = BigWigs:NewBossLocale("Imperator Mar'gok", "deDE")
if L then
	--L.branded_say = "%s (%d) %dy"

	L.custom_off_fixate_marker = "Fixieren markieren"
	L.custom_off_fixate_marker_desc = "Markiert die Ziele von Fixieren mit {rt1}{rt2}, benötigt Leiter oder Assistent.\n|cFFFF0000Um Konflikte beim Markieren zu vermeiden, sollte lediglich 1 Person im Raid diese Option aktivieren.|r"

	--L.custom_off_branded_marker = "Branded Marker"
	--L.custom_off_branded_marker_desc = "Mark Branded targets with {rt3}{rt4}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"	
end

