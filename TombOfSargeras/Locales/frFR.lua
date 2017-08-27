local L = BigWigs:NewBossLocale("Harjatan the Bludger", "frFR")
if not L then return end
if L then
	L.custom_on_fixate_plates = "Icône Fixer sur les barres d'info des ennemis"
	L.custom_on_fixate_plates_desc = "Affiche une icône sur la barre d'info de la cible qui est fixée sur vous.\nNécessite l'utlisation des barres d'info des ennemis. Cette fonctionnalité est actuellement uniquement supportée par KuiNameplates."
end

L = BigWigs:NewBossLocale("Demonic Inquisition", "frFR")
if L then
	L.custom_on_fixate_plates = "Icône Fixer sur les barres d'info des ennemis"
	L.custom_on_fixate_plates_desc = "Affiche une icône sur la barre d'info de la cible qui est fixée sur vous.\nNécessite l'utlisation des barres d'info des ennemis. Cette fonctionnalité est actuellement uniquement supportée par KuiNameplates."

	L.infobox_title_prisoners = "%d |4prisonnier:prisonniers;"

	L.custom_on_stop_timers = "Toujours afficher les barres de capacité"
	L.custom_on_stop_timers_desc = "L'Inquisition démoniaque a certains sorts qui sont retardés par les interruptions/les autres incantations. Quand cette option est activée, les barres de ces capacités resteront à l'écran."
end

L = BigWigs:NewBossLocale("Mistress Sassz'ine", "frFR")
if L then
	L.inks_fed_count = "Encre (%d/%d)"
	L.inks_fed = "Encres inhalées : %s" -- %s = List of players
end

L = BigWigs:NewBossLocale("The Desolate Host", "frFR")
if L then
	L.infobox_players = "Joueurs"
	L.armor_remaining = "%s restant (%d)" -- Bonecage Armor Remaining (#)
	L.custom_on_mythic_armor = "Ignorer Armure thoracique sur les Templiers réanimés en Mythique"
	L.custom_on_mythic_armor_desc = "Laissez cette option activée si vous off-tankez les Templiers réanimés afin d'ignorer les alertes et le comptage des Armures thoraciques sur les Templiers réanimés."
	L.custom_on_armor_plates = "Icône Armure thoracique sur les barres d'info des ennemis"
	L.custom_on_armor_plates_desc = "Affiche une icône sur la barre d'info des Templiers réanimés sous Armure thoracique.\nNécessite l'utlisation des barres d'info des ennemis. Cette fonctionnalité est actuellement uniquement supportée par KuiNameplates."
	L.tormentingCriesSay = "Cris" -- Tormenting Cries (short say)
end

L = BigWigs:NewBossLocale("Maiden of Vigilance", "frFR")
if L then
	L.infusionChanged = "Nouvelle Infusion : %s"
	L.sameInfusion = "Même Infusion : %s"
	L.fel = "Gangrené"
	L.light = "Lumière"
	L.felHammer = "Marteau gangrené" -- Better name for "Hammer of Obliteration"
	L.lightHammer = "Marteau de Lumière" -- Better name for "Hammer of Creation"
	L.absorb = "Absorb."
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "Incant."
	L.cast_text = "%.1fs (|cff%s%.0f%%|r)" -- s = seconds
	L.stacks = "Cumuls"
end

L = BigWigs:NewBossLocale("Fallen Avatar", "frFR")
if L then
	L.touch_impact = "Impact du Toucher" -- Touch of Sargeras Impact (short)

	L.custom_on_stop_timers = "Toujours afficher les barres de capacité"
	L.custom_on_stop_timers_desc = "L'Avatar déchu décide aléatoirement quel capacité hors cooldown il utilise ensuite. Quand cette option est activée, les barres de ces capacités resteront à l'écran."

	L.energy_leak = "Fuite d'énergie"
	L.energy_leak_desc = "Affiche une alerte quand de l'énergie a fuité vers le boss en phase 1."
	L.energy_leak_msg = "Fuite d'énergie ! (%d)"

	L.warmup_trigger = "L'enveloppe devant vous" -- L'enveloppe devant vous a servi de réceptacle à la puissance de Sargeras. Mais ce temple est notre véritable récompense. Le moyen par lequel nous allons réduire votre monde en cendres !

	L.absorb = "Absorb."
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "Incant."
	L.cast_text = "%.1fs (|cff%s%.0f%%|r)" -- s = seconds
end

L = BigWigs:NewBossLocale("Kil'jaeden", "frFR")
if L then
	L.singularityImpact = "Impact Singularité"
	L.obeliskExplosion = "Explosion Obélisque"
	L.obeliskExplosion_desc = "Affiche un délai pour l'Explosion Obélisque"

	L.darkness = "Ténèbres" -- Shorter name for Darkness of a Thousand Souls (238999)
	L.reflectionErupting = "Reflet : éruptif" -- Shorter name for Shadow Reflection: Erupting (236710)
	L.reflectionWailing = "Reflet : gémissant" -- Shorter name for Shadow Reflection: Wailing (236378)
	L.reflectionHopeless = "Reflet : désespéré" -- Shorter name for Shadow Reflection: Hopeless (237590)

	L.rupturingKnock = "Knockback de Singularité de rupture"
	L.rupturingKnock_desc = "Affiche un délai pour le knockback"

	L.meteorImpact_desc = "Affiche un délai pour l'impact des météores"

	L.shadowsoul = "Suivi des vies des Ames d'ombre"
	L.shadowsoul_desc = "Affiche la boîte d'info avec la vie actuelle des 5 Ames d'ombre."

	L.custom_on_track_illidan = "Pistage automatique des humanoïdes"
	L.custom_on_track_illidan_desc = "Si vous êtes un chasseur ou un druide farouche, cette option activera automatiquement le pistage des humanoïdes afin que vous puissiez traquer Illidan."

	L.custom_on_zoom_in = "Zoom automatique de la minicarte"
	L.custom_on_zoom_in_desc = "Cette option mettra le zoom de la minicarte au niveau 4 pour rendre plus facile la traque d'Illidan, et la remettra ensuite à son niveau précédent une fois la phase terminée."
end

L = BigWigs:NewBossLocale("Tomb of Sargeras Trash", "frFR")
if L then
	L.rune = "Rune orque"
	L.chaosbringer = "Infernal porte-chaos"
	L.rez = "Rez le Garde-Tombe"
	L.erduval = "Erdu'val"
	L.varah = "Dame des hippogriffes Varah"
	L.seacaller = "Mande-mers marécaille"
	L.custodian = "Gardien des fonds marins"
	L.dresanoth = "Dresanoth"
	L.stalker = "Le Traqueur de l'effroi"
	L.darjah = "Seigneur de guerre Darjah"
	L.sentry = "Factionnaire gardien"
	L.acolyte = "Acolyte fantomatique"
	L.ryul = "Ryul le Déclinant"
	L.countermeasure = "Contre-mesure défensive"
end
