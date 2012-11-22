
local L = BigWigs:NewBossLocale("Protector of the Endless", "frFR")
if not L then return end
if L then

end

L = BigWigs:NewBossLocale("Tsulong", "frFR")
if L then
	L.win_trigger = "I thank you, strangers. I have been freed."

	L.phases = "Phases"
	L.phases_desc = "Prévient quand la rencontre entre dans une nouvelle phase."
end

L = BigWigs:NewBossLocale("Lei Shi", "frFR")
if L then
	L.engage_trigger = "Qu... Qu'est-ce que vous faites là ?! Partez !" -- à vérifier
	L.win_trigger = "I...ah...oh! Did I...? Was I...? It was so cloudy."

	L.hp_to_go = "%d%% à faire"
	L.end_hide = "Se cacher a pris fin"

	L.special = "Prochaine technique spéciale"
	L.special_desc = "Prévient de l'arrivée de la prochaine technique spéciale."
end

L = BigWigs:NewBossLocale("Sha of Fear", "frFR")
if L then
	L.fading_soon = "%s se dissipe bientôt"

	L.swing = "Frappe"
	L.swing_desc = "Compte le nombre de Frappes avant Rosser."

	L.damage = "Dégâts"
	L.miss = "Raté"
end

