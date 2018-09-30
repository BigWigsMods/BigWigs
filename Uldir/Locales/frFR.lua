local L = BigWigs:NewBossLocale("MOTHER", "frFR")
if not L then return end
if L then
	L.sideLaser = "Rayons (côté)" -- short for: (location) Uldir Defensive Beam
	L.upLaser = "Rayons (plafond)"
	L.mythic_beams = "Rayons"
end

L = BigWigs:NewBossLocale("Zek'voz, Herald of N'zoth", "frFR")
if L then
	L.surging_darkness_eruption = "Eruption (%d)"
	L.mythic_adds = "Adds en Mythique"
	L.mythic_adds_desc = "Affiche les délais indiquant l'apparition des adds en Mythique (les Guerriers silithides et les Tisse-Vides nérubiens apparaissent en même temps)."
end

L = BigWigs:NewBossLocale("Zul", "frFR")
if L then
	L.crawg_msg = "Crogg" -- Short for 'Bloodthirsty Crawg'
	L.crawg_desc = "Alertes et délais concernant l'apparition des Croggs assoiffés de sang."

	L.bloodhexer_msg = "Maléficieuse" -- Short for 'Nazmani Bloodhexer'
	L.bloodhexer_desc = "Alertes et délais concernant l'apparition des Maléficieuses de sang nazmani."

	L.crusher_msg = "Broyeuse" -- Short for 'Nazmani Crusher'
	L.crusher_desc = "Alertes et délais concernant l'apparition des Broyeuses nazmani."

	L.custom_off_decaying_flesh_marker = "Marquage Chair en putréfaction"
	L.custom_off_decaying_flesh_marker_desc = "Marque les forces ennemies affectées par Chair en putréfaction avec {rt8}. Nécessite d'être assistant ou chef de raid."
end

L = BigWigs:NewBossLocale("Mythrax the Unraveler", "frFR")
if L then
	L.destroyer_cast = "%s (Destructeur n'raqi)" -- npc id: 139381
	L.xalzaix_returned = "Xalzaix de retour !" -- npc id: 138324
	L.add_blast = "Choc Add"
	L.boss_blast = "Choc Boss"
end

L = BigWigs:NewBossLocale("G'huun", "frFR")
if L then
	L.orbs_deposited = "Orbes déposés (%d/3) - %.1f sec"
	L.orb_spawning = "Orbe apparu"
	L.orb_spawning_side = "Orbe apparu (%s)"
	L.left = "Gauche"
	L.right = "Droite"

	L.custom_on_fixate_plates = "Icône de prise pour cible sur la barre d'info ennemie"
	L.custom_on_fixate_plates_desc = "Affiche une icône sur la barre d'info de l'unité ennemie qui vous prend pour cible.\nNécessite l'utilisation des barres d'infos ennemies. Cette fonctionnalité est actuellement uniquement supportée par KuiNameplates."
end
