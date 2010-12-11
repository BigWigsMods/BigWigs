local L = BigWigs:NewBossLocale("Cho'gall", "frFR")
if L then
	--heroic
	L.orders = "Ordres de l'ombre/de la flamme"
	L.orders_desc = "Affiche des alertes concernant les Ordres de l'ombre/de la flamme."

	--normal
	L.worship_cooldown = "~Vénération"
end

L = BigWigs:NewBossLocale("Valiona and Theralion", "frFR")
if L then
	L.phase_switch = "Changement de phase"
	L.phase_switch_desc = "Prévient quand la rencontre change de phase."

	L.engulfingmagic_say = "Magie enveloppante sur moi !"

	L.devouringflames_cooldown = "~Flammes dévorantes"

	L.valiona_trigger = "Theralion, je m'occupe du vestibule. Couvre leur fuite !" -- à vérifier

	L.twilight_shift = "%2$dx Transferts du Crépuscule sur %1$s"
end

L = BigWigs:NewBossLocale("Halfus Wyrmbreaker", "frFR")
if L then

end

L = BigWigs:NewBossLocale("Sinestra", "frFR")
if L then

end

L = BigWigs:NewBossLocale("Ascendant Council", "frFR")
if L then
	L.static_overload_say = "Surcharge statique sur moi !"
	L.gravity_core_say = "Noyau de gravité sur moi !"
	L.health_report = "%s est à %d%% de vie, changement imminent !"
	L.switch = "Changement"
	L.switch_desc = "Prévient quand les boss échangent leurs places."

	L.lightning_rod_say = "Bâtonnet d'éclair sur moi !"

	L.switch_trigger = "We will handle them!" -- récupérer transcription (alternative : "Que cessent ces stupidités !"

	L.quake_trigger = "The ground beneath you rumbles ominously...." -- récupérer transcription
	L.thudershock_trigger = "The surrounding air crackles with energy...." -- récupérer transcription

	L.searing_winds_message = "Obtenez des vents tournoyants !"
	L.grounded_message = "Liez-vous à la terre !"

	L.last_phase_trigger = "CONTEMPLEZ VOTRE DESTIN !" -- à vérifier
end