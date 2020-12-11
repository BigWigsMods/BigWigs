local L = BigWigs:NewBossLocale("Shriekwing", "frFR")
if not L then return end
if L then
	L.pickup_lantern = "%s a ramassé la lanterne !"
	L.dropped_lantern = "Lanterne posée par %s !"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "frFR")
if L then
	L.killed = "%s Mort"
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "frFR")
if L then
	-- L.stage2_yell = "The anticipation to use this relic is killing me! Though, it will more likely kill you."
	-- L.stage3_yell = "I hope this wondrous item is as lethal as it looks!"
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "frFR")
if L then
	-- L.times = "%dx %s"

	-- L.level = "%s (Level |cffffff00%d|r)"
	-- L.full = "%s (|cffff0000FULL|r)"

	L.custom_off_experimental = "Activer les options expérimentales"
	L.custom_off_experimental_desc = "Ces options |cffff0000ne sont pas testées|r et pourraient |cffff0000spam|r."

	L.anima_tracking = "Suivi de l'anima |cffff0000(Experimental)|r"
	L.anima_tracking_desc = "Messages et Barres pour suivre le niveau d'anima dans les conteneurs.|n|cffaaff00Tip: Vous pouvez désactiver les barres et boites d'infos si besoin."

	L.custom_on_stop_timers = "Toujours montrer les barres de techniques"
	L.custom_on_stop_timers_desc = "En cours de test"

	L.bottles = "Bouteilles"
	L.sins = "Vices"
end

L = BigWigs:NewBossLocale("The Council of Blood", "frFR")
if L then
	L.macabre_start_emote = "Prenez place pour la Danse Macabre !" -- [RAID_BOSS_EMOTE] Take your places for the Danse Macabre!#Dance Controller#4#false"
	L.custom_on_repeating_dark_recital = "Répéter Sombre Recital"
	L.custom_on_repeating_dark_recital_desc = "Répéter Sombre Recital en /dire avec les icones {rt1}, {rt2} pendant la danse."
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "frFR")
if L then
	L.first_blade = "Premier rebond"
	L.second_blade = "Deuxième rebond"
end
