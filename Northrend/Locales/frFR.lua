
local L = BigWigs:NewBossLocale("Archavon the Stone Watcher", "frFR")
if L then
	L.stomp_message = "Piétinement - Empaler imminent !"
	L.stomp_warning = "Piétinement probable dans ~5 sec. !"
	L.stomp_bar = "~Recharge Piétinement"

	L.cloud_message = "Nuage asphyxiant sur VOUS !"

	L.charge = "Empaler"
	L.charge_desc = "Prévient quand un joueur subit les effets d'un Empaler."
end

L = BigWigs:NewBossLocale("Emalon the Storm Watcher", "frFR")
if L then
	L.nova_next = "~Recharge Nova"

	L.overcharge_message = "Un séide est surchargé !"
	L.overcharge_bar = "Explosion"
	L.overcharge_next = "~Prochaine Surcharge"
end

L = BigWigs:NewBossLocale("Halion", "frFR")
if L then
	L.engage_trigger = "Votre monde vacille au bord de l'élimination. Vous serez tous témoins de l'avènement d'une nouvelle ère de DESTRUCTION !"

	L.phase_two_trigger = "Vous ne trouverez que souffrance au royaume du crépuscule ! Entrez si vous l'osez !"

	L.twilight_cutter_trigger = "Les sphères volantes rayonnent d'énergie noire !"
	L.twilight_cutter_bar = "~Tranchant du crépuscule"
	L.twilight_cutter_warning = "Arrivée d'un Tranchant du crépuscule !"

	L.fire_damage_message = "Vos pieds brûlent !"
	L.fire_message = "Combustion ardente"
	L.fire_bar = "Prochaine Combustion ardente"
	L.fire_say = "Combustion ardente sur moi !"
	L.shadow_message = "Consomption d'âmes"
	L.shadow_bar = "Prochaine Consomption d'âmes"
	L.shadow_say = "Consomption d'âmes sur moi !"

	L.meteorstrike_yell = "Les cieux s'embrasent !"
	L.meteorstrike_bar = "Frappe météore"
	L.meteorstrike_warning = "Arrivée d'une Frappe météore !"

	L.breath_cooldown = "Prochain Souffle"
end

L = BigWigs:NewBossLocale("Koralon the Flame Watcher", "frFR")
if L then
	L.cinder_message = "Braise enflammée sur VOUS !"

	L.breath_bar = "Souffle %d"
	L.breath_message = "Souffle %d imminent !"
end

L = BigWigs:NewBossLocale("Malygos", "frFR")
if L then
	L.sparks = "Etincelle de puissance"
	L.sparks_desc = "Prévient quand une Etincelle de puissance apparait."
	L.sparks_message = "Etincelle de puissance apparue !"
	L.sparks_warning = "Etincelle de puissance dans ~5 sec. !"

	L.sparkbuff = "Etincelle de puissance sur Malygos"
	L.sparkbuff_desc = "Prévient quand Malygos récupère une Etincelle de puissance."
	L.sparkbuff_message = "Malygos gagne Etincelle de puissance !"

	L.vortex = "Vortex"
	L.vortex_desc = "Prévient de l'arrivée des Vortex."
	L.vortex_message = "Vortex !"
	L.vortex_warning = "Vortex probable dans ~5 sec. !"
	L.vortex_next = "Recharge Vortex"

	L.breath = "Inspiration profonde"
	L.breath_desc = "Prévient quand Malygos inspire profondément."
	L.breath_message = "Inspiration profonde !"
	L.breath_warning = "Inspiration profonde dans ~5 sec. !"

	L.surge = "Vague de puissance"
	L.surge_desc = "Prévient quand un joueur subit les effets de la Vague de puissance."
	L.surge_you = "Vague de puissance sur VOUS !"
	L.surge_trigger = "%s fixe le regard sur vous !"

	L.phase = "Phases"
	L.phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase."
	L.phase2_warning = "Phase 2 imminente !"
	L.phase2_trigger = "Je pensais mettre rapidement fin à vos existences"
	L.phase2_message = "Phase 2 - Seigneurs du Nexus & Scions de l'Éternité !"
	L.phase2_end_trigger = "ASSEZ ! Si c'est la magie d'Azeroth que vous voulez, alors vous l'aurez !"
	L.phase3_warning = "Phase 3 imminente !"
	L.phase3_trigger = "Vos bienfaiteurs font enfin leur entrée, mais ils arrivent trop tard !"
	L.phase3_message = "Phase 3 !"
end

L = BigWigs:NewBossLocale("Sartharion", "frFR")
if L then
	L.engage_trigger = "Ces oeufs sont sous ma responsabilité. Je vous ferai brûler avant de vous laisser y toucher !"

	L.tsunami = "Vague de flammes"
	L.tsunami_desc = "Prévient quand la lave bouillonne et affiche une barre."
	L.tsunami_warning = "Vague dans ~5 sec. !"
	L.tsunami_message = "Vague de flammes !"
	L.tsunami_cooldown = "Recharge Vague"
	L.tsunami_trigger = "La lave qui entoure %s bouillonne !"

	L.breath_cooldown = "Recharge Souffle"

	L.drakes = "Arrivée des drakes"
	L.drakes_desc = "Prévient quand chaque drake se joint au combat."
	L.drakes_incomingsoon = "%s atterrit dans ~5 sec. !"

	L.twilight = "Évènements du crépuscule"
	L.twilight_desc = "Prévient quand quelque chose se passe dans le crépuscule."
	L.twilight_trigger_tenebron = "Ténébron se met à poser des œufs dans le crépuscule !"
	L.twilight_trigger_vesperon = "Un disciple de Vespéron apparaît dans le crépuscule !"
	L.twilight_trigger_shadron = "Un disciple d'Obscuron apparaît dans le crépuscule !"
	L.twilight_message_tenebron = "Éclosion des œufs"
	L.twilight_message = "Disciple |2 %s actif !"
end

L = BigWigs:NewBossLocale("Toravon the Ice Watcher", "frFR")
if L then
	L.whiteout_bar = "Blanc aveuglant %d"
	L.whiteout_message = "Blanc aveuglant %d imminent !"

	L.frostbite_message = "%2$dx Morsure de givre sur %1$s"

	L.freeze_message = "Sol givrant"

	L.orb_bar = "Prochain Orbe"
end
