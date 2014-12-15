local L = BigWigs:NewBossLocale("Kargath Bladefist", "frFR")
if not L then return end
if L then
	L.blade_dance_bar = "Danse"

	L.arena_sweeper_desc = "Délai avant d'être expulsé des gradins après Projection de chaîne."
end

L = BigWigs:NewBossLocale("The Butcher", "frFR")
if L then
	L.adds_multiple = "Adds x%d"
end

L = BigWigs:NewBossLocale("Tectus", "frFR")
if L then
	L.earthwarper_trigger1 = "Yjj'rmr" -- Yjj'rmr... Xzzolos... -- à vérifier
	L.earthwarper_trigger2 = "Oui, Tectus" -- Yes, Tectus. Bend to... our master's... will.... -- à vérifier
	L.earthwarper_trigger3 = "Vous ne comprenez pas !" -- You do not understand! This one must not.... -- à vérifier
	L.berserker_trigger1 = "MAÎTRE !" -- MASTER! I COME FOR YOU! -- à vérifier
	L.berserker_trigger2 = "Kral'ach" --Kral'ach.... The darkness speaks.... A VOICE! -- à vérifier
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
	--L.mythic_ability = "Special Ability"
	--L.mythic_ability_desc = "Show a timer bar for the next Call of the Tides or Exploding Fungus arriving."

	L.creeping_moss_boss_heal = "Mousse sous le BOSS (soigne)"
	L.creeping_moss_add_heal = "Mousse sous le MANGE-CHAIR (soigne)"
end

L = BigWigs:NewBossLocale("Twin Ogron", "frFR")
if L then
	--L.volatility_self_desc = "Options for when the Arcane Volatility debuff is on you."

	L.custom_off_volatility_marker = "Marquage Volatilité arcanique"
	L.custom_off_volatility_marker_desc = "Marque les cibles de Volatilité arcanique avec {rt1}{rt2}{rt3}{rt4}. Nécessite d'être assistant ou chef de raid."
end

L = BigWigs:NewBossLocale("Ko'ragh", "frFR")
if L then
	L.fire_bar = "Tout le monde explose !"
	--L.overwhelming_energy_bar = "Balls hit (%d)"

	L.custom_off_fel_marker = "Marquage Projection de magie : Gangrène"
	L.custom_off_fel_marker_desc = "Marque les cibles de Projection de magie : Gangrène avec {rt1}{rt2}{rt3}. Nécessite d'être assistant ou chef de raid.\n|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r"
end

L = BigWigs:NewBossLocale("Imperator Mar'gok", "frFR")
if L then
	L.branded_say = "%s (%d) %dm"

	L.custom_off_fixate_marker = "Marquage Fixer"
	L.custom_off_fixate_marker_desc = "Marque les cibles de Fixer du Mage de guerre gorien avec {rt1}{rt2}. Nécessite d'être assistant ou chef de raid.\n|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r"

	L.custom_off_branded_marker = "Marquage Marqué"
	L.custom_off_branded_marker_desc = "Marque les cibles de Marqué avec {rt3}{rt4}. Nécessite d'être assistant ou chef de raid.\n|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r"
end

