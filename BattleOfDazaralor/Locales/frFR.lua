local L = BigWigs:NewBossLocale("Battle of Dazar'alor Trash", "frFR")
if not L then return end
if L then
	L.flamespeaker = "Parleflamme rastari"
	L.enforcer = "Massacreur éternel"
	L.punisher = "Punisseur rastari"
	L.vessel = "Engeance de Bwonsamdi"

	L.victim = "%s VOUS a poignardé avec %s!"
	L.witness = "%s a poignardé %s avec %s!"
end

L = BigWigs:NewBossLocale("Champion of the Light Horde", "frFR")
if L then
	L.disorient_desc = "Barre d'incantation de |cff71d5ff[Foi aveuglante]|r.\nProbablement la barre dont vous voulez avoir le décompte." -- Blinding Faith = 283650
end

L = BigWigs:NewBossLocale("Champion of the Light Alliance", "frFR")
if L then
	L.disorient_desc = "Barre d'incantation de |cff71d5ff[Foi aveuglante]|r.\nProbablement la barre dont vous voulez avoir le décompte." -- Blinding Faith = 283650
end

L = BigWigs:NewBossLocale("Jadefire Masters Horde", "frFR")
if L then
	L.custom_on_fixate_plates = "Icône de poursuite sur la barre de vie de l'ennemi"
	L.custom_on_fixate_plates_desc = "Fait apparaître une icône sur la barre de vie de la cible qui vous poursuit.\nNécessite l'affichage des barres de vie des ennemis. Actuellement, cette fonctionnalité est prise en charge uniquement par KuiNameplates."

	L.absorb = "Absorption"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "Incantation"
	L.cast_text = "%.1fs (|cff%s%.0f%%|r)"

	L.interrupted_after = "%s interrompu par %s (%.1f secondes restantes)"
end

L = BigWigs:NewBossLocale("Jadefire Masters Alliance", "frFR")
if L then
	L.custom_on_fixate_plates = "Icône de poursuite sur la barre de vie de l'ennemi"
	L.custom_on_fixate_plates_desc = "Fait apparaître une icône sur la barre de vie de la cible qui vous poursuit.\nNécessite l'affichage des barres de vie des ennemis. Actuellement, cette fonctionnalité est prise en charge uniquement par KuiNameplates."

	L.absorb = "Absorption"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "Incantation"
	L.cast_text = "%.1fs (|cff%s%.0f%%|r)"

	L.interrupted_after = "%s interrompu par %s (%.1f secondes restantes)"
end

L = BigWigs:NewBossLocale("Opulence", "frFR")
if L then
	L.room = "Salle (%d/8)"
	L.no_jewel = "Pas de Joyau :"

	L.custom_on_fade_out_bars = "Estomper les barres de la phase 1"
	L.custom_on_fade_out_bars_desc = "Estompe les barres concernant la construction qui n'est pas de votre côté pendant la phase 1."

	L.custom_on_hand_timers = "La Main d'In'zashi"
	L.custom_on_hand_timers_desc = "Affiche des alertes et des barres concernant les compétences de la Main d'In'zashi."
	L.hand_cast = "Main : %s"

	L.custom_on_bulwark_timers = "Rempart de Yalat"
	L.custom_on_bulwark_timers_desc = "Affiche des alertes et des barres concernant les compétences du Rempart de Yalat."
	L.bulwark_cast = "Rempart : %s"
end

L = BigWigs:NewBossLocale("Conclave of the Chosen", "frFR")
if L then
	L.killed = "%s tué !"
	L.count_of = "%s (%d/%d)"
end

L = BigWigs:NewBossLocale("High Tinker Mekkatorque", "frFR")
if L then
	L.gigavolt_alt_text = "Bombe"

	L.custom_off_sparkbot_marker = "Marqueur de robot étourdisseur"
	L.custom_off_sparkbot_marker_desc = "Marquer les robots étourdisseurs avec {rt4}{rt5}{rt6}{rt7}{rt8}."

	L.custom_off_repeating_shrunk_say = "Répéter Rétrécissement - Dire" -- Shrunk = 284168
	L.custom_off_repeating_shrunk_say_desc = "Spamme Rétrécissement tant que vous êtes la cible de |cff71d5ff[Rétrécissement]|r. Peut-être qu'ils arrêteront de vous marcher dessus."

	L.custom_off_repeating_tampering_say = "Répéter Piratage - Dire" -- Tampering = 286105
	L.custom_off_repeating_tampering_say_desc = "Spamme votre nom pendant que vous contrôlez un robot."
end

L = BigWigs:NewBossLocale("Stormwall Blockade", "frFR")
if L then
	L.killed = "%s tué !"

	L.custom_on_fade_out_bars = "Estomper les barres de la phase 1"
	L.custom_on_fade_out_bars_desc = "Estompe les barres concernant le boss qui n'est pas actif de votre côté du bateau pendant la phase 1."
end

L = BigWigs:NewBossLocale("Lady Jaina Proudmoore", "frFR")
if L then
	L.starbord_ship_emote = "Un bateau de Kul Tiras se rapproche à tribord !"
	L.port_side_ship_emote = "Un bateau de Kul Tiras se rapproche à bâbord !"

	L.starbord_txt = "Bateau de tribord (droite)" -- starboard
	L.port_side_txt = "Bateau de bâbord (gauche)" -- port

	L.custom_on_stop_timers = "Toujours afficher les barres de compétence"
	L.custom_on_stop_timers_desc = "La prochaine compétence hors du temps de recharge lancée par Jaine est aléatoire. Lorsque cette option est activée, les barres de ces compétences resteront affichées à l'écran."

	L.frozenblood_player = "%s (%d joueurs)"

	L.intermission_stage2 = "Phase 2 - %.1f sec"
end
