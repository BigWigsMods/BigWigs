local L = BigWigs:NewBossLocale("Blood Princes", "frFR")
if L then
	L.switch_message = "Changement de vulnérabilité"
end

L = BigWigs:NewBossLocale("Icecrown Gunship Battle", "frFR")
if L then
	L.adds = "Portails"
	L.adds_desc = "Prévient de l'arrivée des ennemis sur votre propre bateau."
	L.adds_trigger_alliance = "Saccageurs, sergents, à l'attaque !"
	L.adds_trigger_horde = "Soldats, sergents, à l'attaque !"
	L.adds_message = "Portails !"
	L.adds_bar = "Prochains portails"

	L.mage = "Mage"
	L.mage_desc = "Prévient quand un mage apparaît pour congeler vos canons."
	L.mage_message = "Mage apparu !"
	L.mage_bar = "Prochain mage"

	L.enable_trigger_alliance = "Faites chauffer les moteurs ! On a rencart avec le destin, les gars !"
	L.enable_trigger_horde = "Levez-vous, fils et filles de la Horde ! Aujourd’hui, nous affrontons le plus haï de nos ennemis ! LOK’TAR OGAR !"

	L.disable_trigger_alliance = "Vous direz pas que j'vous avais pas prévenus, canailles ! Mes frères et sœurs, en avant !"
	L.disable_trigger_horde = "L'Alliance baisse pavillon. Sus au roi-liche !"
end

L = BigWigs:NewBossLocale("Lady Deathwhisper", "frFR")
if L then
	L.engage_trigger = "Quelle est cette perturbation ?"
	L.phase2_message = "Barrière de mana dissipée - Phase 2 !"

	L.dnd_message = "Mort et décomposition sur VOUS !"

	L.adds = "Membres du culte"
	L.adds_desc = "Affiche des minuteurs concernant l'apparition des membres du culte."
	L.adds_bar = "Prochains membres du culte"
	L.adds_warning = "Prochains membres du culte dans 5 sec. !"

	L.touch_message = "%2$dx Toucher sur %1$s"
	L.touch_bar = "Prochain Toucher"
end

L = BigWigs:NewBossLocale("Festergut", "frFR")
if L then
	L.engage_trigger = "On joue ?"

	L.inhale_message = "Inhalation de chancre %d"
	L.inhale_bar = "~Prochaine Inhalation (%d)"

	L.blight_warning = "Chancre âcre dans ~5 sec. !"
	L.blight_bar = "~Prochain Chancre âcre"

	L.bloat_message = "%2$dx Ballonnement gastrique sur %1$s"
	L.bloat_bar = "~Prochain Ballonnement"

	L.spore_bar = "~Prochaines Spores gazeuses"
end

L = BigWigs:NewBossLocale("Blood-Queen Lana'thel", "frFR")
if L then

end

L = BigWigs:NewBossLocale("Lord Marrowgar", "frFR")
if L then
	L.engage_trigger = "Le Fléau va déferler sur ce monde dans un torrent de mort et de destruction !"

	L.impale_cd = "~Prochain Empaler"

	L.bonestorm_cd = "~Prochaine Tempête d'os"
	L.bonestorm_warning = "Tempête d'os dans 5 sec. !"

	L.coldflame_message = "Flamme froide sur VOUS !"
end

L = BigWigs:NewBossLocale("Putricide Dogs", "frFR")
if L then
	L.wound_message = "%2$dx Blessure mortelle sur %1$s"
end

L = BigWigs:NewBossLocale("Professor Putricide", "frFR")
if L then
	L.engage_trigger = "Grande nouvelle, mes amis !" -- à vérifier

	L.blight_message = "Ballonnement gazeux : %s"
	L.violation_message = "Adhésif de limon volatil : %s"
end

L = BigWigs:NewBossLocale("Rotface", "frFR")
if L then
	L.infection_bar = "Infection mutée : %s"

	L.flood_trigger1 = "Grande nouvelle, mes amis ! J'ai réparé le distributeur de poison !"
	L.flood_trigger2 = "Merveilleuse nouvelle, mes amis ! La gelée coule à flots !"
	L.flood_warning = "Prochaine inondation imminente !"
end

L = BigWigs:NewBossLocale("Deathbringer Saurfang", "frFR")
if L then
	L.adds = "Bêtes de sang"
	L.adds_desc = "Affiche un minuteur et des messages indiquant quand des Bêtes de sang apparaissent."
	L.adds_warning = "Bêtes de sang dans 5 sec. !"
	L.adds_message = "Bêtes de sang !"
	L.adds_bar = "Prochaines Bêtes de sang"

	L.rune_bar = "Prochaine Rune sanglante"

	L.mark = "Marque %d"

	L.engage_trigger = "PAR LA PUISSANCE DU ROI-LICHE !"
	L.warmup_alliance = "Bon allez, on se bouge ! En route -"
	L.warmup_horde = "Kor'krons, en route ! Champions, surveillez bien vos arrières. Le Fléau a été -"
end

L = BigWigs:NewBossLocale("Sindragosa", "frFR")
if L then
	L.airphase_trigger = "Votre incursion s'arrête ici" -- à vérifier
	L.airphase = "Phase aérienne"
	L.airphase_message = "Phase aérienne"
	L.airphase_desc = "Prévient quand Sindragosas décolle."
	L.boom = "Explosion !"
end

L = BigWigs:NewBossLocale("Valithria Dreamwalker", "frFR")
if L then
	L.manavoid_message = "Vide de mana sur VOUS !"
	L.portal = "Portail du Cauchemar"
	L.portal_desc = "Prévient quand Valithria ouvre un portail."
	L.portal_message = "Portail actif !"
	L.portal_trigger = "J'ai ouvert un portail vers le Rêve" -- à vérifier
end

