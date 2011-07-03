local L = BigWigs:NewBossLocale("Beth'tilac", "frFR")
if not L then return end
if L then
	L.devastate_message = "Dévastation #%d !"
	L.devastate_bar = "~Prochaine dévastation"
	L.drone_bar = "Prochaine ouvrière braisetoile"
	L.drone_message = "Arrivée d'une ouvrière braisetoile !"
end

L = BigWigs:NewBossLocale("Lord Rhyolith", "frFR")
if L then
	L.molten_message = "%dx cumuls sur le boss !"
	L.armor_message = "%d%% d'armure restants"
	L.armor_gone_message = "Armure détruite !"
	L.phase2_soon_message = "Phase 2 imminente !"
	L.stomp_message = "Piétinement ! Piétinement ! Piétinement !"
	L.big_add_message = "Étincelle de Rhyolith apparue !"
	L.small_adds_message = "Arrivée de fragments de Rhyolith !"
end

L = BigWigs:NewBossLocale("Alysrazor", "frFR")
if L then
	L.tornado_trigger = "Ce ciel est à MOI !" -- à vérifier
	L.claw_message = "%2$dx Griffes sur %1$s"
	L.fullpower_soon_message = "Pleine puissance imminente !"
	L.halfpower_soon_message = "Phase 4 imminente !"
	L.encounter_restart = "Pleine puissance ! Et c'est reparti..."
	L.no_stacks_message = "Juste au cas où : vous n'avez pas de plumes."
	L.moonkin_message = "Arrêtez de faire genre et récupérez de vraies plumes."

	L.worm_emote = "Des vers de lave embrasés surgissent du sol !" -- à vérifier
	L.phase2_soon_emote = "Alysrazor begins to fly in a rapid circle!" -- à traduire
	L.phase2_emote = "99794" -- Fiery Vortex spell ID used in the emote
	L.phase3_emote = "99432" -- Burns Out spell ID used in the emote
	L.phase4_emote = "99922" -- Re-Ignites spell ID used in the emote
	L.restart_emote = "99925" -- Full Power spell ID used in the emote
end

L = BigWigs:NewBossLocale("Shannox", "frFR")
if L then
	L.safe = "%s sauvé"
	L.immolation_trap = "Immolation sur %s !"
	L.crystaltrap = "Prison de cristal"
end

L = BigWigs:NewBossLocale("Baleroc", "frFR")
if L then
	L.torment_message = "%2$dx Tourments sur %1$s"
	L.blade = "~Lame"
end

L = BigWigs:NewBossLocale("Majordomo Staghelm", "frFR")
if L then
	L.seed_explosion = "Explosion de la graîne imminente !"
end

L = BigWigs:NewBossLocale("Ragnaros", "frFR")
if L then
	L.intermission = "Intervalle"
	L.sons_left = "Il reste %d Fils"
	L.engulfing_close = "%s proches"
	L.engulfing_middle = "%s au milieu"
	L.engulfing_far = "%s éloignées"
end
