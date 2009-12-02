local L = BigWigs:NewBossLocale("Blood Princes", "frFR")
if L then
	L.switch_message = "Changement de vulnérabilité"
end

local L = BigWigs:NewBossLocale("Lady Deathwhisper", "frFR")
if L then
	L.dnd_message = "Mort et décomposition sur VOUS !"
	L.phase2_message = "Barrière de mana dissipée - Phase 2 !"
end

local L = BigWigs:NewBossLocale("Lady Deathwhisper's Trash", "frFR")
if L then
	L.reckoning = "Sombre rétribution"
end

local L = BigWigs:NewBossLocale("Festergut", "frFR")
if L then

end

local L = BigWigs:NewBossLocale("Blood-Queen Lana'thel", "frFR")
if L then

end

local L = BigWigs:NewBossLocale("Lord Marrowgar", "frFR")
if L then
	L.impale_cd = "~Prochain Empaler"
	L.whirlwind_cd = "~Prochain Tourbillon d'os"
	--L.ww_start = "Début du Tourbillon d'os"
	--L.ww_end = "Fin du Tourbillon d'os"

	L.coldflame_message = "Flamme froide sur VOUS !"
end

local L = BigWigs:NewBossLocale("Precious", "frFR")
if L then
	L.zombies = GetSpellInfo(71159)
	L.zombies_desc = "Invoque 11 zombies pestiférés pour aider le lanceur."
	L.zombies_message = "Zombies invoqués !"
	L.zombies_cd = "~Prochains zombies"

	L.wound_message = "%2$dx Blessure mortelle sur %1$s"

	L.decimate_cd = "~Prochain Décimer"
end

local L = BigWigs:NewBossLocale("Professor Putricide", "frFR")
if L then
	L.blight_message = "Ballonnement gazeux : %s"
	L.violation_message = "Adhésif de limon volatil : %s"
end

local L = BigWigs:NewBossLocale("Rotface", "frFR")
if L then
	L.infection_bar = "Infection mutée : %s"

	L.flood_trigger1 = "Grande nouvelle, mes amis ! J'ai réparé le distributeur de poison !" -- à vérifier
	L.flood_trigger2 = "Merveilleuse nouvelle, mes amis ! La gelée coule à flot !" -- à vérifier
	L.flood_warning = "Une nouvelle zone va bientôt être inondée !"
end

local L = BigWigs:NewBossLocale("Deathbringer Saurfang", "frFR")
if L then
	L.adds_message = "Bêtes de sang invoquées"
	L.adds = "Bêtes de sang"
	L.adds_desc = "Prévient quand des Bêtes de sang sont invoquées."
end

local L = BigWigs:NewBossLocale("Sindragosa", "frFR")
if L then
	L.airphase_trigger = "Votre incursion s'arrête ici" -- à vérifier
	L.airphase = "Phase aérienne"
	L.airphase_message = "Phase aérienne"
	L.airphase_desc = "Prévient quand Sindragosas décolle."
	L.boom = "Explosion !"
end

local L = BigWigs:NewBossLocale("Stinky", "frFR")
if L then
	L.wound_message = "%2$dx Blessure mortelle sur %1$s"
	L.decimate_cd = "~Prochain Décimer"
end

local L = BigWigs:NewBossLocale("Valithria Dreamwalker", "frFR")
if L then
	L.manavoid_message = "Vide de mana sur VOUS !"
	L.portal = "Portail du Cauchemar"
	L.portal_desc = "Prévient quand Valithria ouvre un portail."
	L.portal_message = "Portail actif !"
	L.portal_trigger = "J'ai ouvert un portail vers le Rêve" -- à vérifier
end
