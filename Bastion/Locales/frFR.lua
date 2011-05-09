
local L = BigWigs:NewBossLocale("Cho'gall", "frFR")
if not L then return end
if L then
	L.orders = "Changements de posture"
	L.orders_desc = "Prévient quand Cho'gall passe en posture Ordres de l'ombre/de la flamme."

	L.worship_cooldown = "~Vénération"

	L.adherent_bar = "Adhérent #%d"
	L.adherent_message = "Arrivée d'un Adhérent (%d) !"
	L.ooze_bar = "Nuée de Sangs #%d"
	L.ooze_message = "Arrivée d'une nuée de Sangs (%d) !"

	L.tentacles_bar = "Apparition de Créations"
	L.tentacles_message = "Créations assombries !"

	L.sickness_message = "Vous ne vous sentez pas bien !"
	L.blaze_message = "Brasier sur vous !"
	L.crash_say = "Déferlante sur moi !"

	L.fury_bar = "Prochaine Fureur"
	L.fury_message = "Fureur !"
	L.first_fury_soon = "Fureur imminente !"
	L.first_fury_message = "85% - Fureur commence !"

	L.unleashed_shadows = "Ombre vibrante"

	L.phase2_message = "Phase 2 !"
	L.phase2_soon = "Phase 2 imminente !"
end

L = BigWigs:NewBossLocale("Valiona and Theralion", "frFR")
if L then
	L.phase_switch = "Changement de phase"
	L.phase_switch_desc = "Prévient quand la rencontre change de phase."

	L.phase_bar = "%s atterrit"
	L.breath_message = "Arrivée des Souffles profonds !"
	L.dazzling_message = "Arrivée des zones tourbillonnantes !"

	L.blast_message = "Déflagration"
	L.engulfingmagic_say = "Magie sur moi !"
	L.engulfingmagic_cooldown = "~Magie enveloppante"

	L.devouringflames_cooldown = "~Flammes dévorantes"

	L.valiona_trigger = "Theralion, je m'occupe du vestibule. Couvre leur fuite !" -- à vérifier
	L.win_trigger = "Au moins... Theralion meurt avec moi..." -- à vérifier

	L.twilight_shift = "%2$dx Transferts sur %1$s"
end

L = BigWigs:NewBossLocale("Halfus Wyrmbreaker", "frFR")
if L then
	L.paralysis_bar = "Prochaine paralysie"
	L.strikes_message = "%2$dx Frappes sur %1$s"

	L.breath_message = "Arrivée d'un Souffle !"
	L.breath_bar = "~Souffle"

	L.engage_yell = "Cho'gall aura bientôt vos têtes"
end

L = BigWigs:NewBossLocale("Sinestra", "frFR")
if L then
	L.whelps = "Dragonnets"
	L.whelps_desc = "Prévient de l'arrivée des vagues de dragonnets."

	L.slicer_message = "Cibles probables des orbes"

	L.egg_vulnerable = "C'est l'heure de l'omelette !"

	L.whelps_trigger = "Mangez, mes enfants !"
	L.omelet_trigger = "Vous avez cru à une marque de faiblesse ?"

	L.phase13 = "Phase 1 et 3"
	L.phase = "Phase"
	L.phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase."
end

L = BigWigs:NewBossLocale("Ascendant Council", "frFR")
if L then
	L.static_overload_say = "Surcharge sur moi !"
	L.gravity_core_say = "Gravité sur moi !"
	L.health_report = "%s est à %d%%, changement de phase imminent !"
	L.switch = "Changement"
	L.switch_desc = "Prévient quand les boss échangent leurs places."

	L.shield_up_message = "Bouclier en place !"
	L.shield_down_message = "Bouclier dissipé !"
	L.shield_bar = "Prochain Bouclier"

	L.switch_trigger = "Nous allons nous occuper d'eux !" -- à vérifier

	L.thundershock_quake_soon = "%s dans 10 sec. !"

	L.quake_trigger = "Le sol sous vos pieds gronde avec menace..." -- à vérifier
	L.thundershock_trigger = "L'air qui vous entoure crépite d'énergie..." -- à vérifier

	L.thundershock_quake_spam = "%s dans %d"

	L.last_phase_trigger = "Quelle démonstration impressionnante" -- "CONTEMPLEZ VOTRE DESTIN !" -- à vérifier
end

