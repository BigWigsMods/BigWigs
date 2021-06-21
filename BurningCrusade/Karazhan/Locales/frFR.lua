local L = BigWigs:NewBossLocale("Attumen the Huntsman Raid", "frFR")
if not L then return end
if L then
	L.phase = "Phase"
	L.phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase."
	L.phase2_trigger = "%s appelle son maître !"
	L.phase2_message = "Phase 2 - %s & Attumen"
	L.phase3_trigger = "Viens, Minuit, allons disperser cette insignifiante racaille !"
	L.phase3_message = "Phase 3"
end

L = BigWigs:NewBossLocale("The Curator Raid", "frFR")
if L then
	L.engage_trigger = "L'accès à la Ménagerie est réservé aux invités."

	L.weaken_message = "Evocation - Affaibli pendant 20 sec. !"
	L.weaken_fade_message = "Evocation terminée - Fin de l'Affaiblissement !"
	L.weaken_fade_warning = "Evocation terminée dans 5 sec. !"
end

L = BigWigs:NewBossLocale("Maiden of Virtue Raid", "frFR")
if L then
	L.engage_trigger = "Votre comportement est inacceptable."
	L.engage_message = "Damoiselle engagée ! Repentir dans ~33 sec."

	L.repentance_message = "Repentir ! Prochain pas avant ~33 sec."
	L.repentance_warning = "Fin du temps de recharge de Repentir - Imminent !"
end

L = BigWigs:NewBossLocale("Prince Malchezaar", "frFR")
if L then
	L.wipe_bar = "Réapparition"

	L.phase = "Engagement"
	L.phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase."
	L.phase1_trigger = "La folie vous a fait venir ici, devant moi. Et je serai votre perte !"
	L.phase2_trigger = "Imbéciles heureux ! Le temps est le brasier dans lequel vous brûlerez !"
	L.phase3_trigger = "Comment pouvez-vous espérer résister devant un tel pouvoir ?"
	L.phase1_message = "Phase 1 - Infernal dans ~40 sec. !"
	L.phase2_message = "60% - Phase 2"
	L.phase3_message = "30% - Phase 3 "

	L.infernal = "Infernaux"
	L.infernal_desc = "Affiche le temps de recharge des invocations d'infernaux."
	L.infernal_bar = "Arrivée d'un infernal"
	L.infernal_warning = "Arrivée d'un infernal dans 20 sec. !"
	L.infernal_message = "Infernal ! Flammes infernales dans 5 sec. !"
	L.infernal_trigger1 = "Vous n'affrontez pas seulement"
	L.infernal_trigger2 = "toutes les dimensions me sont"
end

L = BigWigs:NewBossLocale("Moroes Raid", "frFR")
if L then
	L.engage_trigger = "Hum. Des visiteurs imprévus. Il va falloir se préparer."
	L.engage_message = "Moroes engagé - Disparition dans ~35 sec. !"
end

L = BigWigs:NewBossLocale("Netherspite", "frFR")
if L then
	L.phase = "Phases"
	L.phase_desc = "Prévient quand Dédain-du-Néant passe d'une phase à l'autre."
	L.phase1_message = "Retrait - Fin des Souffles du Néant"
	L.phase1_bar = "~Retrait probable"
	L.phase1_trigger = "%s se retire avec un cri en ouvrant un portail vers le Néant."
	L.phase2_message = "Rage - Souffles de Néant imminent !"
	L.phase2_bar = "~Rage probable"
	L.phase2_trigger = "%s entre dans une rage nourrie par le Néant !"

	L.voidzone_warn = "Zone du vide (%d) !"
end

L = BigWigs:NewBossLocale("Nightbane Raid", "frFR")
if L then
	L.name = "Plaie-de-nuit"

	L.phase = "Phases"
	L.phase_desc = "Prévient quand Plaie-de-nuit passe d'une phase à l'autre."
	L.airphase_trigger = "Misérable vermine. Je vais vous exterminer des airs !"
	L.landphase_trigger1 = "Assez ! Je vais atterrir et vous écraser moi-même !"
	L.landphase_trigger2 = "Insectes ! Je vais vous montrer de quel bois je me chauffe !"
	L.airphase_message = "Décollage !"
	L.landphase_message = "Atterrissage !"
	L.summon_trigger = "Dans le lointain, un être ancien s'éveille…"

	L.engage_trigger = "Fous ! Je vais mettre un terme rapide à vos souffrances !"
end

L = BigWigs:NewBossLocale("Romulo & Julianne", "frFR")
if L then
	L.name = "Romulo & Julianne"

	L.phase = "Phases"
	L.phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase."
	L.phase1_trigger = "Quel démon es-tu pour me tourmenter ainsi ?"
 	L.phase1_message = "Acte I - Julianne"
	L.phase2_trigger = "Tu veux donc me provoquer ? Eh bien, à toi, enfant."
 	L.phase2_message = "Acte II - Romulo"
	L.phase3_trigger = "Viens, gentille nuit ; rends-moi mon Romulo !"
	L.phase3_message = "Acte III - Les deux"

	L.poison = "Poison"
	L.poison_desc = "Prévient quand un joueur est empoisonné."
	L.poison_message = "Empoisonné"

	L.heal = "Soin"
	L.heal_desc = "Prévient quand Julianne lance Amour éternel."
	L.heal_message = "Julianne incante un soin !"

	L.buff = "Buff"
	L.buff_desc = "Prévient quand Romulo et Julianne gagnent leurs buffs."
	L.buff1_message = "Romulo gagne Hardiesse !"
	L.buff2_message = "Julianne gagne Dévotion !"
end

L = BigWigs:NewBossLocale("Shade of Aran", "frFR")
if L then
	L.adds = "Elémentaires"
	L.adds_desc = "Prévient quand les élémentaires d'eau apparaissent."
	L.adds_message = "Arrivée des élémentaires !"
	L.adds_warning = "Elémentaires imminent"
	L.adds_bar = "Fin des élémentaires"

	L.drink = "Boisson"
	L.drink_desc = "Prévient quand l'Ombre d'Aran commence à boire."
	L.drink_warning = "Mana faible - Boisson imminente !"
	L.drink_message = "Boisson - Polymorphisme de zone !"
	L.drink_bar = "Super Explosion pyro."

	L.blizzard = "Blizzard"
	L.blizzard_desc = "Prévient quand Blizzard est incanté."
	L.blizzard_message = "Blizzard !"

	L.pull = "Attraction/Sort de zone"
	L.pull_desc = "Prévient de l'attraction magnétique et de l'explosion des arcanes."
	L.pull_message = "Explosion des arcanes !"
	L.pull_bar = "Explosion des arcanes"
end

L = BigWigs:NewBossLocale("Terestian Illhoof", "frFR")
if L then
	L.engage_trigger = "^Ah, vous arrivez juste à temps."

	L.weak = "Affaibli"
	L.weak_desc = "Prévient quand Terestian est affaibli."
	L.weak_message = "Affaibli pendant ~45 sec. !"
	L.weak_warning1 = "Fin de l'Affaiblissement dans ~5 sec. !"
	L.weak_warning2 = "Affaiblissement terminé !"
	L.weak_bar = "~Fin Affaiblissement"
end

L = BigWigs:NewBossLocale("The Big Bad Wolf", "frFR")
if L then
	L.name = "Le Grand Méchant Loup"

	L.riding_bar = "Chaperon : %s"
end

L = BigWigs:NewBossLocale("The Crone", "frFR")
if L then
	L.name = "La Mégère"

	L.engage_trigger = "^Oh, Tito, nous devons trouver le moyen de rentrer à la maison !"

	L.spawns = "Délais d'activité"
	L.spawns_desc = "Affiche plusieurs barres indiquant quand les différents personnages passent à l'action."
	L.spawns_warning = "%s dans 5 sec."

	L.roar = "Graou"
	L.tinhead = "Tête de fer-blanc"
	L.strawman = "Homme de paille"
	L.tito = "Tito"
end

