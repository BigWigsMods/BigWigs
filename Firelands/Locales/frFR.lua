local L = BigWigs:NewBossLocale("Beth'tilac", "frFR")
if not L then return end
if L then
	L.devastate_message = "Dévastation #%d !"
	L.devastate_bar = "~Prochaine dévastation"
	L.drone_bar = "Prochaine ouvrière"
	L.drone_message = "Arrivée d'une ouvrière !"
	L.kiss_message = "Baiser"
end

L = BigWigs:NewBossLocale("Lord Rhyolith", "frFR")
if L then
	L.armor = "Armure en obsidienne"
	L.armor_desc = "Prévient quand des cumuls d'armure sont enlevés de Rhyolith."
	L.armor_icon = 98632
	L.armor_message = "%d%% d'armure restantes"
	L.armor_gone_message = "Armure détruite !"

	L.adds_header = "Adds"
	L.big_add_message = "Étincelle de Rhyolith apparue !"
	L.small_adds_message = "Arrivée de fragments de Rhyolith !"

	L.phase2_warning = "Phase 2 imminente !"

	L.molten_message = "%dx cumuls sur le boss !"

	L.stomp_message = "Piétinement ! Piétinement ! Piétinement !"
	L.stomp_warning = "Prochain piétinement"
end

L = BigWigs:NewBossLocale("Alysrazor", "frFR")
if L then
	L.tornado_trigger = "Ce ciel est à MOI."
	L.claw_message = "%2$dx Griffes sur %1$s"
	L.fullpower_soon_message = "Pleine puissance imminente !"
	L.halfpower_soon_message = "Phase 4 imminente !"
	L.encounter_restart = "Et c'est reparti..."
	L.no_stacks_message = "Juste au cas où : vous n'avez pas de plumes."
	L.moonkin_message = "Arrêtez de faire genre et récupérez de vraies plumes."
	L.molt_bar = "Prochaine mue"

	L.stage_message = "Phase %d"

	L.worm_emote = "Des vers de lave embrasés surgissent du sol !"
	L.phase2_soon_emote = "Alysrazor commence à voler en cercles rapides !"
	L.phase2_emote = "99794" -- Fiery Vortex spell ID used in the emote
	L.phase3_emote = "99432" -- Burns Out spell ID used in the emote
	L.phase4_emote = "99922" -- Re-Ignites spell ID used in the emote
	L.restart_emote = "99925" -- Full Power spell ID used in the emote

	L.flight = "Assistance en vol"
	L.flight_desc = "Affiche une barre indiquant la durée de vos Ailes de flamme. Idéal si utilisé avec la fonctionnalité de super mise en évidence."
	L.flight_icon = 98619
end

L = BigWigs:NewBossLocale("Shannox", "frFR")
if L then
	L.safe = "%s sauvé"
	L.immolation_trap = "Immolation sur %s !"
	L.crystaltrap = "Prison de cristal"
end

L = BigWigs:NewBossLocale("Baleroc", "frFR")
if L then
	L.torment = "Cumuls de Torment sur la focalisation"
	L.torment_desc = "Prévient quand votre /focus gagne un autre cumul de tourment."
	L.torment_icon = 99256
	--L.torment_message = "%2$dx tourments sur %1$s"

	L.blade_bar = "~Prochaine Lame"
	L.shard_message = "Éclats de tourment (%d) !"
	L.focus_message = "Votre focalisation a %d cumuls !"
	L.countdown_bar = "Prochain lien"
	L.link_message = "Liés"
end

L = BigWigs:NewBossLocale("Majordomo Staghelm", "frFR")
if L then
	L.seed_explosion = "Vous explosez bientôt !"
	L.seed_bar = "Vous explosez !"
	L.adrenaline_message = "Adrenaline x%d !"
end

L = BigWigs:NewBossLocale("Ragnaros", "frFR")
if L then
	L.phase4_trigger = "Trop tôt..." -- à vérifier
	L.seed_explosion = "Explosion des graînes !"
	L.intermission_bar = "Intervalle"
	L.intermission_message = "Intervalle !"
	L.sons_left = "%d |4fils restants:fils restant;"
	L.engulfing_close = "Section proche engloutie !"
	L.engulfing_middle = "Section centrale engloutie !"
	L.engulfing_far = "Section éloignée engloutie !"
	L.hand_bar = "Prochain \"knockback\""
	L.wound_bar = "Blessure sur %s"
	L.ragnaros_back_message = "Ragnaros est de retour !"
end
