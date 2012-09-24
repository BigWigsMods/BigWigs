
local L = BigWigs:NewBossLocale("Protector of the Endless", "frFR")
if not L then return end
if L then

end

L = BigWigs:NewBossLocale("Tsulong", "frFR")
if L then
	L.phases = "Phases"
	L.phases_desc = "Prévient quand la rencontre entre dans une nouvelle phase."
end

L = BigWigs:NewBossLocale("Lei Shi", "frFR")
if L then
	L.engage_trigger = "Qu... Qu'est-ce que vous faites là ?! Partez !" -- à vérifier
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
end

