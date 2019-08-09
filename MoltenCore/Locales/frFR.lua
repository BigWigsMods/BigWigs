local L = BigWigs:NewBossLocale("Lucifron", "frFR")
if not L then return end
if L then
	L.mc_bar = "CM : %s"
end

L = BigWigs:NewBossLocale("Majordomo Executus", "frFR")
if L then
	L.disabletrigger = "Impossible ! Arrêtez votre attaque, mortels... Je me rends ! Je me rends !"
	--L.power_next = "Next Power"
end

L = BigWigs:NewBossLocale("Ragnaros ", "frFR")
if L then
	L.submerge_trigger = "VENEZ, MES SERVITEURS"
	L.engage_trigger = "ET MAINTENANT"

	L.knockback_message = "Projection de zone !"
	L.knockback_bar = "Projection de zone"

	L.submerge = "Immersion"
	L.submerge_desc = "Préviens quand Ragnaros plonge et l'arrivée des Fils des flammes."
	L.submerge_message = "Ragnaros intouchable pendant 90 sec. Arrivée des Fils des flammes !"
	L.submerge_bar = "Départ de Ragnaros"

	L.emerge = "Émergence"
	L.emerge_desc = "Préviens quand Ragnaros émerge."
	L.emerge_message = "Ragnaros en surface, 3 min. avant immersion !"
	L.emerge_bar = "Retour de Ragnaros"
end

