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
	L.phase_arcane_trigger =  "Ô sagesse ancestrale ! Distille en moi ta sagesse arcanique !"
	L.phase_shadow_trigger = "Grandes âmes des champions du passé ! Confiez-moi votre bouclier !" -- à vérifier

	L.phase_lightning = "Phase de Foudre !"
	L.phase_flame = "Phase des Flammes !"
	L.phase_arcane = "Phase des Arcanes !"
	L.phase_shadow = "Phase d'Ombre (héroïque) !"

	L.shroud_message = "%2$s incante Voile sur %1$s"
	L.barrier_message = "Barrière EN PLACE !"

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
	L.engage_yell = "L'heure de mourir elle est arrivée maintenant !" -- à vérifier

	L.totem = "Totem %d"
	L.shadowy_message = "Attaque %d"
	L.banish_message = "Tank banni"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "frFR")
if L then
	L.shield_removed = "Bouclier enlevé ! (%s)"
	L.casting_shields = "Incantations de boucliers"
	L.casting_shields_desc = "Prévient quand des boucliers sont incantés pour tous les boss."
end

L = BigWigs:NewBossLocale("Elegon", "frFR")
if L then
	L.last_phase = "Dernière phase"
	L.overcharged_total_annihilation = "Vous avez (%d) %s, réinitialisez votre affaiblissement !"

	L.floor = "Disparition du sol"
	L.floor_desc = "Prévient quand le sol est sur le point de s'effondrer."
	L.floor_message = "Le sol est en train de s'effondrer !"
end

L = BigWigs:NewBossLocale("Will of the Emperor", "frFR")
if L then
	L.enable_zone = "Forge des Éternels"

	L.energizing = "%s s'énergise !"
	L.combo = "%s : combo en cours"

	L.heroic_start_trigger = "Destroying the pipes" -- Destroying the pipes leaks |cFFFF0000|Hspell:116779|h[Titan Gas]|h|r into the room!
	L.normal_start_trigger = "La machine s'anime" -- The machine hums to life!  Get to the lower level!

	L.rage_trigger = "La rage de l'empereur se répercute dans les collines." -- à vérifier
	L.strength_trigger = "La Force de l'empereur apparaît dans les alcôves !" -- à vérifier
	L.courage_trigger = "Le Courage de l'empereur apparaît dans les alcôves !" -- à vérifier
	L.bosses_trigger = "Deux assemblages titanesques apparaissent dans les grandes alcôves !" -- à vérifier
	L.gas_trigger = "The Ancient Mogu Machine breaks down!" -- à traduire
	L.gas_overdrive_trigger = "The Ancient Mogu Machine goes into overdrive!" -- à traduire

	L.arc_desc = "|cFFFF0000Cette alerte ne s'affichera que pour le boss que vous ciblez.|r " .. (select(2, EJ_GetSectionInfo(5673)))
end

