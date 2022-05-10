local L = BigWigs:NewBossLocale("Kil'jaeden", "frFR")
if not L then return end
if L then
	L.bomb_cast = "Ténèbres des mille âmes en incantation !"
	L.bomb_nextbar = "~Bombe probable"
	L.bomb_warning = "Bombe probable dans ~10 sec."

	L.orb = "Orbe du bouclier"
	L.orb_desc = "Prévient quand un Orbe du bouclier lance des Traits de l'ombre."
	L.orb_shooting = "Orbe en vie - Bombardement de traits !"

	L.shield_up = "Bouclier ACTIF !"
	L.deceiver_dies = "Main du Trompeur #%d tué"

	L.blueorb = "Orbe du Vol bleu"
	L.blueorb_desc = "Prévient quand un Orbe du Vol bleu est prêt."
	L.blueorb_message = "Orbe du Vol bleu prêt !"

	L.kalec_yell = "Je vais canaliser mon énergie vers les orbes ! Préparez-vous !"
	L.kalec_yell2 = "J'ai chargé un autre orbe ! Utilisez-le vite !"
	L.kalec_yell3 = "Un autre orbe est prêt ! Hâtez-vous !"
	L.kalec_yell4 = "J'ai envoyé tout ce que je pouvais ! La puissance est entre vos mains !"
	L.phase3_trigger = "Rien ne m'arrêtera ! Ce monde va tomber !"
	L.phase4_trigger = "Assez de faux espoirs ! Vous ne pouvez pas gagner !"
	L.phase5_trigger = "Arggghhh ! Les pouvoirs du Puits de soleil… se retournent... contre moi ! Qu'avez-vous fait ? Qu'avez-vous fait ??"
end

L = BigWigs:NewBossLocale("Felmyst", "frFR")
if L then
	L.phase = "Phases"
	L.phase_desc = "Prévient quand Gangrebrume décolle et atterit."
	L.airphase_trigger = "Je suis plus forte que jamais !"
	L.takeoff_bar = "Décollage"
	L.takeoff_message = "Décollage dans 5 sec. !"
	L.landing_bar = "Atterrissage"
	L.landing_message = "Atterrissage dans 10 sec. !"

	L.breath = "Grande inspiration"
	L.breath_desc = "Prévient quand Gangrebrume inspire profondément."
end

L = BigWigs:NewBossLocale("Brutallus", "frFR")
if L then
	L.engage_trigger = "Ah, encore des agneaux pour l'abattoir !"

	L.burnresist = "Résistances à Brûler"
	L.burnresist_desc = "Prévient quand un joueur a résisté à Brûler."
	L.burn_resist = "%s a résisté à Brûler"
end

L = BigWigs:NewBossLocale("M'uru", "frFR")
if L then
	L.sentinel = "Sentinelles du Vide"
	L.sentinel_desc = "Prévient quand les Sentinelles du Vide apparaissent."
	L.sentinel_next = "Sentinelle (%d)"

	L.humanoid = "Renforts humanoïdes"
	L.humanoid_desc = "Prévient quand les renforts humanoïdes apparaissent."
	L.humanoid_next = "Humanoïdes (%d)"
end

L = BigWigs:NewBossLocale("Kalecgos", "frFR")
if L then
	L.engage_trigger = "Aarghh !! Je ne serai plus jamais l'esclave de Malygos ! Osez me défier et vous serez détruits !"
	L.enrage_trigger = "Sathrovarr déchaîne la rage de Kalecgos !"

	L.sathrovarr = "Sathrovarr le Corrupteur"

	L.portal = "Portail"
	L.portal_message = "Portail probable dans 5 sec. !"

	L.realm_desc = "Prévient quand un joueur est dans le Royaume spectral."
	L.realm_message = "Royaume spectral : %s (Groupe %d)"
	L.nobody = "Nul"

	L.curse = "Malédiction"

	L.wild_magic_healing = "Magie sauvage (Soins prodigués augmentés)"
	L.wild_magic_healing_desc = "Prévient quand les effets de vos soins sont augmentés par la Magie sauvage."
	L.wild_magic_healing_you = "Magie sauvage - Effets des soins augmentés !"

	L.wild_magic_casting = "Magie sauvage (Temps d'incantation augmenté)"
	L.wild_magic_casting_desc = "Prévient quand un soigneur a son temps d'incantation augmenté par la Magie sauvage."
	L.wild_magic_casting_you = "Magie sauvage - Temps d'incantation augmenté pour VOUS !"
	L.wild_magic_casting_other = "Magie sauvage - Temps d'incantation augmenté pour %s !"

	L.wild_magic_hit = "Magie sauvage (Chances de toucher réduites)"
	L.wild_magic_hit_desc = "Prévient quand les chances de toucher d'un tank sont réduites par la Magie sauvage."
	L.wild_magic_hit_you = "Magie sauvage - Chances de toucher réduites pour VOUS !"
	L.wild_magic_hit_other = "Magie sauvage - Chances de toucher réduites pour %s !"

	L.wild_magic_threat = "Magie sauvage (Menace générée augmentée)"
	L.wild_magic_threat_desc = "Prévient quand la menace que vous générez est augmentée par la Magie sauvage."
	L.wild_magic_threat_you = "Magie sauvage - Menace générée augmentée !"
end

L = BigWigs:NewBossLocale("The Eredar Twins", "frFR")
if L then
	L.lady = "Sacrocingle #3:"
	L.lock = "Alythess #2:"

	L.threat = "Menace"

	-- L.custom_on_threat = "Threat InfoBox"
	-- L.custom_on_threat_desc = "Show second on threat for Grand Warlock Alythess and third on threat for Lady Sacrolash."
end

