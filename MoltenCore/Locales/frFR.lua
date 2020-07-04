local L = BigWigs:NewBossLocale("Lucifron", "frFR")
if not L then return end
if L then
	L.bossName = "Lucifron"

	L.mc_bar = "CM : %s"
end

L = BigWigs:NewBossLocale("Magmadar", "frFR")
if L then
	L.bossName = "Magmadar"
end

L = BigWigs:NewBossLocale("Gehennas", "frFR")
if L then
	L.bossName = "Gehennas"
end

L = BigWigs:NewBossLocale("Garr", "frFR")
if L then
	L.bossName = "Garr"
end

L = BigWigs:NewBossLocale("Baron Geddon", "frFR")
if L then
	L.bossName = "Baron Geddon"
end

L = BigWigs:NewBossLocale("Shazzrah", "frFR")
if L then
	L.bossName = "Shazzrah"
end

L = BigWigs:NewBossLocale("Sulfuron Harbinger", "frFR")
if L then
	L.bossName = "Messager de Sulfuron"
end

L = BigWigs:NewBossLocale("Golemagg the Incinerator", "frFR")
if L then
	L.bossName = "Golemagg l’Incinérateur"
end

L = BigWigs:NewBossLocale("Majordomo Executus", "frFR")
if L then
	L.bossName = "Chambellan Executus"

	L.disabletrigger = "Impossible ! Arrêtez votre attaque, mortels... Je me rends ! Je me rends !"
	-- L.power_next = "Next Power"
end

L = BigWigs:NewBossLocale("Ragnaros", "frFR")
if L then
	L.bossName = "Ragnaros"

	-- L.warmup_message = "RP started, engaging in ~73s"

	L.engage_trigger = "ET MAINTENANT"
	L.submerge_trigger = "VENEZ, MES SERVITEURS"

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

