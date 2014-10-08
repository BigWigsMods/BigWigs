
local L = BigWigs:NewBossLocale("Protectors of the Endless", "frFR")
if not L then return end
if L then
	L.under = "%s en dessous de %s !"
	L.heal = "Soin |2 %s"
end

L = BigWigs:NewBossLocale("Tsulong", "frFR")
if L then
	L.engage_yell = "Vous n'avez pas votre place ici ! Les eaux doivent être protégées... je vais vous renvoyer, ou vous tuer !" -- à vérifier
	L.kill_yell = "Je vous remercie, étrangers. J'ai été libéré." -- à vérifier

	L.phases = "Phases"
	L.phases_desc = "Prévient quand la rencontre entre dans une nouvelle phase."

	L.sunbeam_spawn = "Nouveau Rayon de soleil !"
end

L = BigWigs:NewBossLocale("Lei Shi", "frFR")
if L then
	L.hp_to_go = "%d%% à faire"

	L.special = "Prochaine technique spéciale"
	L.special_desc = "Prévient de l'arrivée de la prochaine technique spéciale."

	L.custom_off_addmarker = "Marquage des protecteurs"
	L.custom_off_addmarker_desc = "Marque les Protecteurs animés lors des Protections de Lei Shi. Nécessite d'être assistant ou chef de raid.\n|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r\n|cFFADFF2FASTUCE : si le raid a décidé que c'est vous qui devez l'activer, survoler rapidement toutes les protecteurs est le moyen le plus rapide de les marquer.|r"
end

L = BigWigs:NewBossLocale("Sha of Fear", "frFR")
if L then
	L.fading_soon = "%s se dissipe bientôt"

	L.swing = "Frappe"
	L.swing_desc = "Compte le nombre de Frappes avant Rosser."

	L.throw = "Lancer !"
	L.ball_dropped = "Boule à terre !"
	L.ball_you = "Vous avez la boule !"
	L.ball = "Boule"

	L.cooldown_reset = "Vos temps de recharge sont réinitialisés !"

	L.ability_cd = "Recharge des techniques"
	L.ability_cd_desc = "Tente de deviner dans quel ordre les techniques seront utilisées après un Emerger."

	L.strike_or_spout = "Frappe ou Geysérit"
	L.huddle_or_spout_or_strike = "Recroq. ou Geysérit ou Frappe"

	L.custom_off_huddle = "Marquage Recroquevillement"
	L.custom_off_huddle_desc = "Afin d'aider à l'attribution des soins, marque les joueurs affectés par Recroquevillement de terreur avec {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}. Nécessite d'être assistant ou chef de raid."
end

