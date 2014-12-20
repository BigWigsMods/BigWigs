local L = BigWigs:NewBossLocale("Kargath Bladefist", "deDE")
if not L then return end
if L then
	L.blade_dance_bar = "Tanzen"

	L.arena_sweeper_desc = "Timer für das Schleudern von der Tribüne nachdem Ihr durch Kettenschleudern hinaufgeworfen wurdet."
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

	L.adds_desc = "Timer für das Erscheinen von Adds."

	L.custom_off_barrage_marker = "Kristallbeschuss markieren"
	L.custom_off_barrage_marker_desc = "Markiert die Ziele von Kristallbeschuss mit {rt1}{rt2}{rt3}{rt4}{rt5}, benötigt Leiter oder Assistent."

	--L.tectus = "Tectus"
	L.shard = "Splitter"
	L.motes = "Partikel"
end

L = BigWigs:NewBossLocale("Brackenspore", "deDE")
if L then
	L.mythic_ability = "Spezialfähigkeit"
	L.mythic_ability_desc = "Zeigt Timer für den nächsten Rufs der Gezeiten oder Explodierenden Pilz an."

	L.creeping_moss_boss_heal = "Moos unter dem BOSS (Heilung)"
	L.creeping_moss_add_heal = "Moos unter GROSSEM ADD (Heilung)"
end

L = BigWigs:NewBossLocale("Twin Ogron", "deDE")
if L then
	L.volatility_self_desc = "Optionen für den Schwächungszauber Arkane Flüchtigkeit auf Dir."

	L.custom_off_volatility_marker = "Arkane Flüchtigkeit markieren"
	L.custom_off_volatility_marker_desc = "Markiert die Ziele von Arkane Flüchtigkeit mit {rt1}{rt2}{rt3}{rt4}, benötigt Leiter oder Assistent."
end

L = BigWigs:NewBossLocale("Ko'ragh", "deDE")
if L then
	L.fire_bar = "Alle explodieren!"
	L.overwhelming_energy_bar = "Kugeln treffen auf (%d)"
	L.overwhelming_energy_mc_bar = "MC Kugeln treffen auf (%d)"

	L.custom_off_fel_marker = "Magie ausstoßen: Teufelsenergie markieren"
	L.custom_off_fel_marker_desc = "Markiert die Ziele von Magie ausstoßen: Teufelsenergie mit {rt1}{rt2}{rt3}, benötigt Leiter oder Assistent.\n|cFFFF0000Um Konflikte beim Markieren zu vermeiden, sollte lediglich 1 Person im Raid diese Option aktivieren.|r"
end

L = BigWigs:NewBossLocale("Imperator Mar'gok", "deDE")
if L then
	--L.phase4_trigger = "You know nothing of the power you meddle with"

	L.branded_say = "%s (%d) %dm"
	L.add_death_soon = "Add stirbt bald!"
	L.slow_fixate = "Verlangsamen + Fixieren"

	L.custom_off_fixate_marker = "Fixieren markieren"
	L.custom_off_fixate_marker_desc = "Markiert die Ziele von Fixieren mit {rt1}{rt2}, benötigt Leiter oder Assistent.\n|cFFFF0000Um Konflikte beim Markieren zu vermeiden, sollte lediglich 1 Person im Raid diese Option aktivieren.|r"

	L.custom_off_branded_marker = "Gebrandmarkt markieren"
	L.custom_off_branded_marker_desc = "Markiert die Ziele von Gebrandmarkt mit {rt3}{rt4}, benötigt Leiter oder Assistent.\n|cFFFF0000Um Konflikte beim Markieren zu vermeiden, sollte lediglich 1 Person im Raid diese Option aktivieren.|r"
end

