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
	L.engage_yell = "Offrez vos âmes, mortels ! Vous êtes dans le séjour des morts !"

	L.phase_lightning_trigger = "Ô grand esprit ! Accorde-moi le pouvoir de la terre !"
	L.phase_flame_trigger = "Ô être exalté ! Grâce à moi vous ferez fondre la chair et les os !"
	L.phase_arcane_trigger = "Ô sagesse ancestrale ! Distille en moi ta sagesse arcanique !"
	L.phase_shadow_trigger = "Grandes âmes des champions du passé ! Confiez-moi votre bouclier !" -- à vérifier

	L.phase_lightning = "Phase de Foudre !"
	L.phase_flame = "Phase des Flammes !"
	L.phase_arcane = "Phase des Arcanes !"
	L.phase_shadow = "Phase d'Ombre (héroïque) !"

	L.phase_message = "Nouvelle phase imminente !"
	L.shroud_message = "Voile"
	L.shroud_can_interrupt = "%s peut interrompre %s !"
	L.barrier_message = "Barrière EN PLACE !"
	L.barrier_cooldown = "Recharge Barrière"

	-- Tanks
	L.tank = "Alertes tank"
	L.tank_desc = "Compte les cumuls de Fouet foudroyant, Lance enflammée, Horion des Arcanes & Brûlure de l'ombre (héroïque)."
	L.lash_message = "Fouet"
	L.spear_message = "Lance"
	L.shock_message = "Horion"
	L.burn_message = "Brûlure"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "frFR")
if L then
	L.engage_yell = "L'heure de mourir elle est arrivée maintenant !" -- à vérifier

	L.totem_message = "Totem (%d)"
	L.shadowy_message = "Attaque (%d)"
	L.banish_message = "Tank banni"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "frFR")
if L then
	L.bosses = "Boss"
	L.bosses_desc = "Prévient quand un boss devient actif."

	L.shield_removed = "Bouclier enlevé ! (%s)"
	L.casting_shields = "Incantations de boucliers"
	L.casting_shields_desc = "Prévient quand des boucliers sont incantés pour tous les boss."
end

L = BigWigs:NewBossLocale("Elegon", "frFR")
if L then
	L.engage_yell = "Passage en mode défensif. Désactivation des sécurités intégrées." -- à vérifier

	L.last_phase = "Dernière phase"
	L.overcharged_total_annihilation = "Surcharge %d ! Un peu trop ?"

	L.floor = "Disparition du sol"
	L.floor_desc = "Prévient quand le sol est sur le point de s'effondrer."
	L.floor_message = "Le sol est en train de s'effondrer !"

	L.adds = "Protecteurs célestes"
	L.adds_desc = "Prévient quand un Protecteur céleste est sur le point d'apparaître."
end

L = BigWigs:NewBossLocale("Will of the Emperor", "frFR")
if L then
	L.enable_zone = "Forge des Éternels"

	L.heroic_start_trigger = "La destruction des tuyaux"
	L.normal_start_trigger = "La machine s’anime en bourdonnant"

	L.rage_trigger = "La rage de l'empereur se répercute dans les collines."
	L.strength_trigger = "La Force de l'empereur apparaît dans les alcôves !"
	L.courage_trigger = "Le Courage de l'empereur apparaît dans les alcôves !"
	L.bosses_trigger = "Deux assemblages titanesques apparaissent dans les grandes alcôves !"
	L.gas_trigger = "La machine mogu antique s’effondre !"
	L.gas_overdrive_trigger = "La machine mogu antique s’emballe !" -- à vérifier

	L.target_only = "|cFFFF0000Cette alerte ne s'affichera que pour le boss que vous ciblez.|r "
	L.combo_message = "%s : combo imminent !"
end

