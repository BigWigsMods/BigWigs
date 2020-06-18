local L = BigWigs:NewBossLocale("Razorgore the Untamed", "frFR")
if not L then return end
if L then
	L.bossName = "Tranchetripe l'Indompté"
	L.start_trigger = "Sonnez l'alarme"
	L.start_message = "Tranchetripe engagé ! Gardes dans 45 sec. !"
	L.start_soon = "Arrivée des gardes dans 5 sec. !"
	L.start_mob = "Arrivée des gardes"

	L.eggs = "Comptage des œufs"
	L.eggs_desc = "Compte le nombre d'œufs détruits."
	L.eggs_message = "%d/30 œuf(s) détruit(s) !"

	L.phase2_message = "Tous les œufs ont été détruits !"
end

L = BigWigs:NewBossLocale("Vaelastrasz the Corrupt", "frFR")
if L then
	L.bossName = "Vaelastrasz le Corrompu"
end

L = BigWigs:NewBossLocale("Broodlord Lashlayer", "frFR")
if L then
	L.bossName = "Seigneur des couvées Lashlayer"
end

L = BigWigs:NewBossLocale("Firemaw", "frFR")
if L then
	L.bossName = "Gueule-de-feu"
end

L = BigWigs:NewBossLocale("Ebonroc", "frFR")
if L then
	L.bossName = "Rochébène"
end

L = BigWigs:NewBossLocale("Flamegor", "frFR")
if L then
	L.bossName = "Flamegor"
end

L = BigWigs:NewBossLocale("Chromaggus", "frFR")
if L then
	--L.bossName = "Chromaggus"
	L.breath = "Souffles"
	L.breath_desc = "Préviens de l'arrivée des souffles."

	--L.debuffs_message = "3/5 debuffs, carefull!"
	--L.debuffs_warning = "4/5 debuffs, %s on 5th!"
end

L = BigWigs:NewBossLocale("NefarianBWL", "frFR")
if L then
	--L.bossName = "Nefarian"
	L.landing_soon_trigger = "Beau travail"
	L.landing_trigger = "BRÛLEZ, misérables"
	L.zerg_trigger = "C'est impossible ! Relevez%-vous, serviteurs !"

	L.triggershamans = "Chamans, montrez moi"
	L.triggerwarlock = "Démonistes, vous ne devriez pas jouer"
	L.triggerhunter = "Ah, les chasseurs et les stupides"
	L.triggermage = "Les mages aussi"

	L.landing_soon_warning = "Nefarian atterit dans 10 sec. !"
	L.landing_warning = "Nefarian atterit !"
	L.zerg_warning = "Zerg imminent !"
	L.classcall_warning = "Arrivée de l'appel des classes !"

	L.warnshaman = "Chamans - Totems posés !"
	L.warndruid = "Druides - Coincés en forme de félin !"
	L.warnwarlock = "Démonistes - Arrivée d'infernaux !"
	L.warnpriest = "Prêtre - Soins blessants !"
	L.warnhunter = "Chasseurs - Arcs/Fusils cassés !"
	L.warnwarrior = "Guerriers - Coincés en posture berseker !"
	L.warnrogue = "Voleurs - Téléportés et immobilisés !"
	L.warnpaladin = "Paladins - Bénédiction de protection !"
	L.warnmage = "Mages - Arrivée des métamorphoses !"

	L.classcall_bar = "Appel des classes"

	L.classcall = "Appel de classe"
	L.classcall_desc = "Préviens de l'arrivée des appels de classe."

	L.otherwarn = "Atterissage et zerg"
	L.otherwarn_desc = "Préviens quand les Zergs arrivent et quand Nefarian atterit."

	-- L.add = "Drakonid deaths"
	-- L.add_desc = "Announce the number of adds killed in Phase 1 before Nefarian lands."
end

