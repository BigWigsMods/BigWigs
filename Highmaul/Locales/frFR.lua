local L = BigWigs:NewBossLocale("Kargath Bladefist", "frFR")
if not L then return end
if L then
	--L.blade_dance_bar = "Dancing"
end

L = BigWigs:NewBossLocale("The Butcher", "frFR")
if L then
	--L.adds_multiple = "Adds x%d"
end

L = BigWigs:NewBossLocale("Tectus", "frFR")
if L then
	--L.earthwarper_trigger1 = "Yjj'rmr" -- Yjj'rmr... Xzzolos...
	--L.earthwarper_trigger2 = "Yes, Tectus" -- Yes, Tectus. Bend to... our master's... will....
	--L.earthwarper_trigger3 = "You do not understand!" -- You do not understand! This one must not....
	--L.berserker_trigger1 = "MASTER!" -- MASTER! I COME FOR YOU!
	--L.berserker_trigger2 = "Kral'ach" --Kral'ach.... The darkness speaks.... A VOICE!
	--L.berserker_trigger3 = "Graaagh!" --Graaagh! KAHL...  AHK... RAAHHHH!

	L.tectus = "Tectus"
	L.shard = "Eclat"
	L.motes = "Granules"

	L.custom_off_barrage_marker = "Marquage Barrage cristallin"
	L.custom_off_barrage_marker_desc = "Marque les cibles de Barrage cristallin avec {rt1}{rt2}{rt3}{rt4}{rt5}. Nécessite d'être assistant ou chef de raid."

	L.adds_desc = "Délais indiquant quand de nouveaux renforts se joignent au combat."
end

L = BigWigs:NewBossLocale("Brackenspore", "frFR")
if L then
	L.creeping_moss_heal = "Mousse rampante sous le BOSS (soigne)"
end

L = BigWigs:NewBossLocale("Twin Ogron", "frFR")
if L then
	L.custom_off_volatility_marker = "Marquage Volatilité arcanique"
	L.custom_off_volatility_marker_desc = "Marque les cibles de Volatilité arcanique avec {rt1}{rt2}{rt3}{rt4}. Nécessite d'être assistant ou chef de raid."
end

L = BigWigs:NewBossLocale("Ko'ragh", "frFR")
if L then
	--L.suppression_field_trigger1 = "Quiet!"
	--L.suppression_field_trigger2 = "I will tear you in half!"
	--L.suppression_field_trigger3 = "I will crush you!"
	--L.suppression_field_trigger4 = "Silence!"

	L.fire_bar = "Tout le monde explose !"
end

L = BigWigs:NewBossLocale("Imperator Mar'gok", "frFR")
if L then
	L.custom_off_fixate_marker = "Marquage Fixer"
	L.custom_off_fixate_marker_desc = "Marque les cibles de Fixer du Mage de guerre gorien avec {rt1}{rt2}. Nécessite d'être assistant ou chef de raid.\n|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r"
end

