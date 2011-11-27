local L = BigWigs:NewBossLocale("Beth'tilac", "frFR")
if not L then return end
if L then
	L.flare = GetSpellInfo(100936)
	L.flare_desc = "Affiche une barre de délai pour les Braises incandescentes à effet de zone."

	L.devastate_message = "Dévastation #%d"
	L.drone_bar = "Ouvrière"
	L.drone_message = "Arrivée d'une ouvrière !"
	L.kiss_message = "Baiser"
	L.spinner_warn = "Tisseuses #%d"
end

L = BigWigs:NewBossLocale("Lord Rhyolith", "frFR")
if L then
	L.armor = "Armure en obsidienne"
	L.armor_desc = "Prévient quand des cumuls d'armure sont enlevés de Rhyolith."
	L.armor_message = "Il reste %d%% d'armure"
	L.armor_gone_message = "Armure détruite !"

	L.adds_header = "Étincelles/Fragments"
	L.big_add_message = "Étincelle de Rhyolith apparue !"
	L.small_adds_message = "Arrivée de fragments de Rhyolith !"

	L.phase2_warning = "Phase 2 imminente !"

	L.molten_message = "%d cumuls de fournaise sur le boss !"

	L.stomp_message = "Piétinement !"
	L.stomp = "Piétinement"
end

L = BigWigs:NewBossLocale("Alysrazor", "frFR")
if L then
	L.claw_message = "%2$dx Griffes sur %1$s"
	L.fullpower_soon_message = "Pleine puissance imminente !"
	L.halfpower_soon_message = "Phase 4 imminente !"
	L.encounter_restart = "Et c'est reparti..."
	L.no_stacks_message = "Juste au cas où : vous n'avez pas de plumes."
	L.moonkin_message = "Arrêtez de faire genre et récupérez de vraies plumes."
	L.molt_bar = "Mue"

	L.meteor = "Météore"
	L.meteor_desc = "Prévient quand un météore en fusion est invoqué."
	L.meteor_message = "Météore !"

	L.stage_message = "Phase %d "
	L.kill_message = "C'est maintenant ou jamais - tuez-la !"
	L.engage_message = "Alysrazor engagée - Phase 2 dans ~%d min."

	L.worm_emote = "Des vers de lave embrasés surgissent du sol !"
	L.phase2_soon_emote = "Alysrazor commence à voler en cercles rapides !"

	L.flight = "Assistance en vol"
	L.flight_desc = "Affiche une barre indiquant la durée de vos Ailes de flamme. Idéal si utilisé avec la fonctionnalité de super mise en évidence."

	L.initiate = "Apparitions des initiés"
	L.initiate_desc = "Affiche des barres de délai concernant les apparitions des initiés."
	L.initiate_both = "Les deux initiés"
	L.initiate_west = "Initié de l'ouest"
	L.initiate_east = "Initié de l'est"
end

L = BigWigs:NewBossLocale("Shannox", "frFR")
if L then
	L.safe = "%s sauvé"
	L.wary_dog = "%s est prudent !"
	L.crystal_trap = "Prison de cristal"

	L.traps_header = "Pièges"
	L.immolation = "Piège d'immolation sur les chiens"
	L.immolation_desc = "Prévient quand Croquepatte ou Ragegueule marche sur un piège d'immolation, gagnant de ce fait l'amélioration 'Prudence'."
	L.immolationyou = "Piège d'immolation en dessous de vous"
	L.immolationyou_desc = "Prévient quand un piège d'immolation est invoqué en dessous de vous."
	L.immolationyou_message = "Piège d'immolation"
	L.crystal = "Piège de cristal"
	L.crystal_desc = "Prévient en dessous de qui Shannox incante un piège de cristal."
end

L = BigWigs:NewBossLocale("Baleroc", "frFR")
if L then
	L.torment = "Cumuls de Torment sur la focalisation"
	L.torment_desc = "Prévient quand votre /focus gagne un autre cumul de tourment."

	L.blade_bar = "~Prochaine Lame"
	L.shard_message = "Éclats de tourment (%d) !"
	L.focus_message = "Votre focalisation a %d cumuls !"
	L.link_message = "Liés"
end

L = BigWigs:NewBossLocale("Majordomo Staghelm", "frFR")
if L then
	L.seed_explosion = "Vous explosez bientôt !"
	L.seed_bar = "Vous explosez !"
	L.adrenaline_message = "Adrenaline x%d !"
	L.leap_say = "Bond sur MOI !"
end

L = BigWigs:NewBossLocale("Ragnaros", "frFR")
if L then
	L.intermission_end_trigger1 = "Sulfuras sera votre fin"
	L.intermission_end_trigger2 = "À genoux, mortels"
	L.intermission_end_trigger3 = "Je vais en finir"
	L.phase4_trigger = "Trop tôt..." -- à vérifier
	L.seed_explosion = "Explosion des graînes !"
	L.intermission_bar = "Intervalle"
	L.intermission_message = "Intervalle !"
	L.sons_left = "%d |4fils restant:fils restants;"
	L.engulfing_close = "Section proche engloutie !"
	L.engulfing_middle = "Section centrale engloutie !"
	L.engulfing_far = "Section éloignée engloutie !"
	L.hand_bar = "\"Knockback\""
	L.ragnaros_back_message = "Ragnaros est de retour !"

	L.wound = "Blessure brûlante"
	L.wound_desc = "Alerte pour tanks uniquement. Compte les cumuls de blessure brûlante et affiche une barre de durée."
	L.wound_message = "%2$dx Blessure sur %1$s"
end
