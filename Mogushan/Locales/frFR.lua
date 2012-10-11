local L = BigWigs:NewBossLocale("The Stone Guard", "frFR")
if not L then return end
if L then
	L.petrifications = "Pétrification"
	L.petrifications_desc = "Prévient quand un des boss commencent une pétrification."

	L.overload = "Surcharge"
	L.overload_desc = "Prévient de l'arrivée de chaque type de surcharge."
end

L = BigWigs:NewBossLocale("Feng the Accursed", "frFR")
if L then
	L.phases = "Phases"
	L.phases_desc = "Prévient quand la rencontre entre dans une nouvelle phase."

	L.phase_lightning_trigger = "Ô grand esprit ! Accorde-moi le pouvoir de la terre !" -- à vérifier
	L.phase_flame_trigger = "Ô être exalté ! Grâce à moi vous ferez fondre la chair et les os !" -- à vérifier
	L.phase_arcane_trigger =  "Ô sagesse ancestrale ! Distille en moi ta sagesse arcanique !" -- à vérifier
	L.phase_shadow_trigger = "Great soul of champions past! Bear to me your shield!" -- à traduire

	L.phase_lightning = "Phase de Foudre !"
	L.phase_flame = "Phase des Flammes !"
	L.phase_arcane = "Phase des Arcanes !"
	L.phase_shadow = "Phase d'Ombre !"

	L.shroud_message = "%2$s cast Shroud on %1$s"
	L.barrier_message = "Barrier UP!"

	-- Tanks
	L.tank = "Alertes tank"
	L.tank_desc = "Alertes pour tank uniquement. Compte les cumuls de Fouet foudroyant, Lance enflammée, Horion des Arcanes & Brûlure de l'ombre (héroïque)."
	L.lash_message = "%2$dx Fouet(s) sur %1$s"
	L.spear_message = "%2$dx Lance(s) sur %1$s"
	L.shock_message = "%2$dx Horion(s) sur %1$s"
	L.burn_message = "%2$dx Brûlure(s) sur %1$s"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "frFR")
if L then
	L.frenzy = "Frénésie imminente !"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "frFR")
if L then
	L.shield_removed = "Bouclier enlevé !"
end

L = BigWigs:NewBossLocale("Elegon", "frFR")
if L then
	L.last_phase = "Dernière phase"
	L.floor_despawn = "Disparition du sol"
	L.overcharged_total_annihilation = "Vous avez (%d) %s, réinitialisez votre affaiblissement !"
end

L = BigWigs:NewBossLocale("Will of the Emperor", "frFR")
if L then
	L.rage_trigger = "La rage de l'empereur se répercute dans les collines." -- à vérifier
	L.strength_trigger = "La Force de l'empereur apparaît dans les alcôves !" -- à vérifier
	L.courage_trigger = "Le Courage de l'empereur apparaît dans les alcôves !" -- à vérifier
	L.bosses_trigger = "Deux assemblages titanesques apparaissent dans les grandes alcôves !" -- à vérifier

	L.arc_desc = "|cFFFF0000Cette alerte ne s'affichera que pour le boss que vous ciblez.|r " .. (select(2, EJ_GetSectionInfo(5673)))
end

