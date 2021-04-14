local L = BigWigs:NewBossLocale("Void Reaver", "frFR")
if not L then return end
if L then
	L.engage_trigger = "Alerte ! Vous êtes désigné pour extermination."
end

L = BigWigs:NewBossLocale("High Astromancer Solarian", "frFR")
if L then
	L.engage_trigger = "Tal anu'men no sin'dorei!"

	L.phase = "Phases"
	L.phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase."
	L.phase1_message = "Phase 1 - Rupture dans ~50 sec."
	L.phase2_warning = "Phase 2 imminente !"
	L.phase2_trigger = "^Je ne fais plus"
	L.phase2_message = "20% - Phase 2"

	L.wrath_other = "Courroux"

	L.split = "Rupture"
	L.split_desc = "Prévient de l'arrivée des ruptures & des apparitions des adds."
	L.split_trigger1 = "Je vais balayer vos illusions de grandeur !"
	L.split_trigger2 = "Vous êtes désespérément surclassés !"
	L.split_bar = "~Prochaine Rupture"
	L.split_warning = "Rupture dans ~7 sec."

	L.agent_warning = "Rupture ! - Agents dans 6 sec."
	L.agent_bar = "Agents"
	L.priest_warning = "Prêtres/Solarian dans 3 sec."
	L.priest_bar = "Prêtres/Solarian"
end

L = BigWigs:NewBossLocale("Kael'thas Sunstrider", "frFR")
if L then
	L.engage_trigger = "^L'énergie. La puissance."
	L.engage_message = "Phase 1"

	L.gaze = "Focalisation"
	L.gaze_desc = "Prévient quand Thaladred se focalise sur un joueur."
	L.gaze_trigger = "pose ses yeux"

	L.fear_soon_message = "Rugissement imminent !"
	L.fear_message = "Rugissement !"
	L.fear_bar = "Recharge Rugissement"

	L.rebirth = "Renaissance du phénix"
	L.rebirth_desc = "Prévient quand le phénix est suceptible de renaitre."
	L.rebirth_warning = "Renaissance probable dans 5 sec. !"
	L.rebirth_bar = "~Renaissance probable"

	L.pyro = "Explosion pyrotechnique"
	L.pyro_desc = "Affiche un compte à rebours de 60 secondes pour l'Explosion pyrotechnique."
	L.pyro_trigger = "%s commence à lancer une explosion pyrotechnique !"
	L.pyro_warning = "Explosion pyrotechnique dans 5 sec. !"
	L.pyro_message = "Explosion pyrotechnique en incantation !"

	L.phase = "Phases"
	L.phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase."
	L.thaladred_inc_trigger = "Impressionnant. Voyons comment tiendront vos nerfs face à l'Assombrisseur, Thaladred !"
	L.sanguinar_inc_trigger = "Vous avez tenu tête à certains de mes plus talentueux conseillers… Mais personne ne peut résister à la puissance du Marteau de sang. Je vous présente le seigneur Sanguinar !"
	L.capernian_inc_trigger = "Capernian fera en sorte que votre séjour ici ne se prolonge pas."
	L.telonicus_inc_trigger = "Bien, vous êtes dignes de mesurer votre talent à celui de mon maître ingénieur, Telonicus."
	L.weapons_inc_trigger = "Comme vous le voyez, j'ai plus d'une corde à mon arc…"
	L.phase3_trigger = "Peut-être vous ai-je sous-estimés. Il ne serait pas très loyal de vous faire combattre mes quatre conseillers en même temps, mais… mon peuple n'a jamais été traité avec loyauté. Je ne fais que rendre la politesse."
	L.phase4_trigger = "Il est hélas parfois nécessaire de prendre les choses en main soi-même. Balamore shanal !"

	L.flying_trigger = "Je ne suis pas arrivé si loin pour échouer maintenant ! Je ne laisserai pas l'avenir que je prépare être remis en cause ! Vous allez goûter à ma vraie puissance !"
	L.flying_message = "Phase 5 - Rupture de gravité dans 1 min."

	L.weapons_inc_message = "Phase 2 - Arrivée des armes !"
	L.phase3_message = "Phase 3 - Conseillers et armes !"
	L.phase4_message = "Phase 4 - Arrivée de Kael'thas !"
	L.phase4_bar = "Arrivée de Kael'thas"

	L.mc = "Contrôle mental"
	L.mc_desc = "Prévient quand des joueurs subissent les effets du Contrôle mental."

	L.revive_bar = "Retour des conseillers"
	L.revive_warning = "Retour des conseillers dans 5 sec. !"

	L.dead_message = "%s meurt"

	L.capernian = "Grande astromancienne Capernian"
	L.sanguinar = "Seigneur Sanguinar"
	L.telonicus = "Maître ingénieur Telonicus"
	L.thaladred = "Thaladred l'Assombrisseur"
end

