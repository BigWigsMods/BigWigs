
local L = BigWigs:NewBossLocale("Algalon the Observer", "frFR")
if L then
	L.phase = "Phases"
	L.phase_desc = "Prévient quand la rencontre change de phase."
	L.engage_warning = "Phase 1"
	L.phase2_warning = "Arrivée de la phase 2"
	L.phase_bar = "Phase %d"
	L.engage_trigger = "Vos actions sont illogiques. Tous les résultats possibles de cette rencontre ont été calculés. Le Panthéon recevra le message de l'Observateur quelle que soit l'issue."

	L.punch_message = "%2$dx Coups de poing phasiques sur %1$s"
	L.smash_message = "Arrivée d'un Choc cosmique !"
	L.blackhole_message = "Trou noir %d !"
	L.bigbang_soon = "Big Bang imminent !"

	L.end_trigger = "J'ai vu des mondes baigner dans les flammes" -- à vérifier
end

L = BigWigs:NewBossLocale("Auriaya", "frFR")
if L then
	L.engage_trigger = "Certaines choses ne doivent pas être dérangées !"

	L.fear_warning = "Hurlement terrifiant imminent !"
	L.fear_message = "Hurlement terrifiant en incantation !"
	L.fear_bar = "~H. terrifiant"

	L.swarm_message = "Essaim gardien"
	L.swarm_bar = "~Essaim"

	L.defender = "Défenseur farouche"
	L.defender_desc = "Prévient quand le Défenseur farouche apparaît et quand il perd une vie."
	L.defender_message = "Défenseur actif %d/9 !"

	L.sonic_bar = "~H. sonore"
end

L = BigWigs:NewBossLocale("Freya", "frFR")
if L then
	L.engage_trigger1 = "Le jardin doit être protégé !"
	L.engage_trigger2 = "Anciens, donnez-moi votre force !"

	L.phase = "Phases"
	L.phase_desc = "Prévient quand la rencontre change de phase."
	L.phase2_message = "Phase 2 !"

	L.wave = "Vagues"
	L.wave_desc = "Prévient de l'arrivée des vagues."
	L.wave_bar = "Prochaine vague"
	L.conservator_trigger = "Eonar, ta servante a besoin d'aide !"
	L.detonate_trigger = "La nuée des éléments va vous submerger !"
	L.elementals_trigger = "Mes enfants, venez m'aider !"
	L.tree_trigger = "Un |cFF00FFFFdon de la Lieuse-de-vie|r commence à pousser !"
	L.conservator_message = "Ancien conservateur !"
	L.detonate_message = "Flagellants explosifs !"
	L.elementals_message = "Élémentaires !"

	L.tree = "Cadeau d'Eonar"
	L.tree_desc = "Prévient quand Freya fait apparaître un Cadeau d'Eonar."
	L.tree_message = "Un arbre pousse !"

	L.fury_message = "Fureur de la nature"
	L.fury_other = "Fureur : %s"

	L.tremor_warning = "Tremblement de terre imminent !"
	L.tremor_bar = "~Prochain Tremblement"
	L.energy_message = "Energie instable sur VOUS !"
	L.sunbeam_message = "Rayons de soleil actif !"
	L.sunbeam_bar = "~Prochains Rayons de soleil"

	L.end_trigger = "Son emprise sur moi se dissipe. J'y vois à nouveau clair. Merci, héros."
end

L = BigWigs:NewBossLocale("Hodir", "frFR")
if L then
	L.engage_trigger = "Vous allez souffrir pour cette intrusion !"

	L.cold = "Ça caille ici"
	L.cold_desc = "Prévient quand Froid mordant s'est empilé 2 fois sur votre personnage."
	L.cold_message = "Froid mordant x%d !"

	L.flash_warning = "Gel instantané en incantation !"
	L.flash_soon = "Gel instantané dans 5 sec. !"

	L.hardmode = "Jouons à casse-cache"
	L.hardmode_desc = "Affiche le délai avant qu'Hodir ne détruise sa cache rare."

	L.end_trigger = "Je suis... libéré de son emprise... enfin."
end

L = BigWigs:NewBossLocale("Ignis the Furnace Master", "frFR")
if L then
	L.engage_trigger = "Chiots insolents ! Les lames qui serviront à reconquérir ce monde seront trempées dans votre sang !"

	L.construct_message = "Assemblage activé !"
	L.construct_bar = "Prochain Assemblage"
	L.brittle_message = "Un Assemblage est devenu Fragile !"
	L.flame_bar = "~Recharge Flots"
	L.scorch_message = "Brûlure sur VOUS !"
	L.scorch_soon = "Brûlure dans ~5 sec. !"
	L.scorch_bar = "Prochaine Brûlure"
	L.slagpot_message = "Marmite : %s"
end

L = BigWigs:NewBossLocale("The Iron Council", "frFR")
if L then
	L.engage_trigger1 = "Vous ne vaincrez pas si facilement l'assemblée du Fer, envahisseurs !"
	L.engage_trigger2 = "Seule votre extermination complète me conviendra."
	L.engage_trigger3 = "Que vous soyez les plus grandes punaises ou les plus grands héros de ce monde, vous n'êtes jamais que des mortels."

	L.overload_message = "Surcharge dans 6 sec. !"
	L.death_message = "Rune de mort sur VOUS !"
	L.summoning_message = "Arrivée des élémentaires !"

	L.chased_other = "%s est poursuivi(e) !"
	L.chased_you = "VOUS êtes poursuivi(e) !"

	L.overwhelm_other = "P. accablante : %s"

	L.shield_message = "Bouclier des runes !"

	L.council_dies = "%s éliminé"
end

L = BigWigs:NewBossLocale("Kologarn", "frFR")
if L then
	L.arm = "Destruction des bras"
	L.arm_desc = "Prévient quand le bras gauche et/ou droit est détruit."
	L.left_dies = "Bras gauche détruit"
	L.right_dies = "Bras droit détruit"
	L.left_wipe_bar = "Repousse bras gauche"
	L.right_wipe_bar = "Repousse bras droit"

	L.shockwave = "Onde de choc"
	L.shockwave_desc = "Prévient quand la prochaine Onde de choc arrive."
	L.shockwave_trigger = "OUBLI !"

	L.eyebeam = "Rayon de l'oeil"
	L.eyebeam_desc = "Prévient quand un Rayon de l'oeil focalisé est incanté."
	L.eyebeam_trigger = "%s concentre son regard sur vous !"
	L.eyebeam_message = "Rayon : %s"
	L.eyebeam_bar = "~Rayon de l'oeil"
	L.eyebeam_you = "Rayon de l'oeil sur VOUS !"
	L.eyebeam_say = "Rayon de l'oeil sur moi !"

	L.armor_message = "%2$dx broyages d'armure sur %1$s"
end

L = BigWigs:NewBossLocale("Flame Leviathan", "frFR")
if L then
	L.engage = "Engagement"
	L.engage_desc = "Prévient quand le Léviathan des flammes est engagé."
	L.engage_trigger = "^Entités hostiles détectées."
	L.engage_message = "%s engagé !"

	L.pursue = "Poursuite"
	L.pursue_desc = "Prévient quand le Léviathan des flammes poursuit un joueur."
	L.pursue_trigger = "^%%s poursuit"
	L.pursue_other = "Poursuivi(e) : %s"

	L.shutdown_message = "Extinction des systèmes !"
end

L = BigWigs:NewBossLocale("Mimiron", "frFR")
if L then
	L.phase = "Phases"
	L.phase_desc = "Prévient quand la rencontre change de phase."
	L.engage_warning = "Phase 1"
	L.engage_trigger = "^Nous n'avons pas beaucoup de temps, les amis !"
	L.phase2_warning = "Arrivée de la phase 2"
	L.phase2_trigger = "^MERVEILLEUX ! Résultats parfaitement formidables !"
	L.phase3_warning = "Arrivée de la phase 3"
	L.phase3_trigger = "^Merci, les amis !"
	L.phase4_warning = "Arrivée de la phase 4"
	L.phase4_trigger = "^Fin de la phase d'essais préliminaires"
	L.phase_bar = "Phase %d"

	L.hardmode_trigger = "^Mais, pourquoi"

	L.plasma_warning = "Plasma en incantation !"
	L.plasma_soon = "Explosion de plasma imminente !"
	L.plasma_bar = "Plasma"

	L.shock_next = "Prochain Horion"

	L.laser_soon = "Accélération !"
	L.laser_bar = "Barrage"

	L.magnetic_message = "UCA au sol !"

	L.suppressant_warning = "Arrivée d'un Coupe-flamme !"

	L.fbomb_soon = "Bombe de givre imminente !"
	L.fbomb_bar = "Prochaine Bombe de givre"

	L.bomb_message = "Robo-bombe apparu !"

	L.end_trigger = "^Il semblerait que j'aie pu faire une minime erreur de calcul."
end

L = BigWigs:NewBossLocale("Razorscale", "frFR")
if L then
	L.phase = "Phases"
	L.phase_desc = "Prévient quand la rencontre change de phase."
	L.ground_trigger = "Faites vite ! Elle va pas rester au sol très longtemps !"
	L.ground_message = "Tranchécaille enchaînée !"
	L.air_trigger = "Laissez un instant pour préparer la construction des tourelles."
	L.air_trigger2 = "Incendie éteint ! Reconstruisons les tourelles !"
	L.air_message = "Décollage !"
	L.phase2_trigger = "Tranchécaille bloquée au sol !"
	L.phase2_message = "Phases 2 !"
	L.phase2_warning = "Phase 2 imminente !"
	L.stun_bar = "Étourdie"

	L.breath_trigger = "%s inspire profondément…"
	L.breath_message = "Souffle de flammes !"
	L.breath_bar = "~Recharge Souffle"

	L.flame_message = "Flamme dévorante sur VOUS !"

	L.harpoon = "Tourelle à harpon"
	L.harpoon_desc = "Prévient quand une tourelle à harpon est prête."
	L.harpoon_message = "Tourelle à harpon %d prête !"
	L.harpoon_trigger = "Tourelle à harpon prête à l'action !"
	L.harpoon_nextbar = "Tourelle %d"
end

L = BigWigs:NewBossLocale("Thorim", "frFR")
if L then
	L["Runic Colossus"] = "Colosse runique" -- For the runic barrier emote.

	L.phase = "Phases"
	L.phase_desc = "Prévient quand la rencontre change de phase."
	L.phase1_message = "Phase 1"
	L.phase2_trigger = "Des intrus ! Mortels, vous qui osez me déranger en plein divertissement allez pay - Attendez, vous -"
	L.phase2_message = "Phase 2 - Berserk dans 6 min. 15 sec. !"
	L.phase3_trigger = "Avortons impertinents, vous osez me défier sur mon piédestal ? Je vais vous écraser moi-même !"
	L.phase3_message = "Phase 3 - Thorim engagé !"

	L.hardmode = "Sifonné"
	L.hardmode_desc = "Affiche le délai avant que Sif ne disparaisse."
	L.hardmode_warning = "Sif a disparue"

	L.shock_message = "Horion de foudre sur VOUS !"
	L.barrier_message = "Barrière runique actif !"

	L.detonation_say = "Détonation runique sur moi !"

	L.charge_message = "Charge de foudre x%d !"
	L.charge_bar = "Charge %d"

	L.strike_bar = "Recharge Frappe"

	L.end_trigger = "Retenez vos coups ! Je me rends !"
end

L = BigWigs:NewBossLocale("General Vezax", "frFR")
if L then
	L.engage_trigger = "^Votre destruction annoncera un nouvel âge de souffrance !"

	L.surge_message = "Vague de ténèbres %d !"
	L.surge_cast = "Vague %d en incantation !"
	L.surge_bar = "Vague %d"

	L.animus = "Animus de saronite"
	L.animus_desc = "Prévient quand l'Animus de saronite apparaît."
	L.animus_trigger = "Les vapeurs saronitiques s'amassent et tourbillonnent violemment pour former un amas monstrueux !"
	L.animus_message = "Animus apparu !"

	L.vapor = "Vapeurs de saronite"
	L.vapor_desc = "Prévient quand des Vapeurs de saronite apparaissent."
	L.vapor_message = "Vapeurs de saronite %d !"
	L.vapor_bar = "Vapeurs %d/6"
	L.vapor_trigger = "Un nuage de vapeurs saronitiques se forme non loin !"

	L.vaporstack = "Cumul des Vapeurs"
	L.vaporstack_desc = "Prévient quand vous avez 5 cumuls ou plus de Vapeurs de saronite."
	L.vaporstack_message = "Vapeurs de saronite x%d !"

	L.crash_say = "Déferlante d'ombre sur moi !"

	L.mark_message = "Marque"
	L.mark_message_other = "Marque : %s"
end

L = BigWigs:NewBossLocale("XT-002 Deconstructor", "frFR")
if L then
	L.exposed_warning = "Cœur exposé imminent"
	L.exposed_message = "Cœur exposé !"

	L.gravitybomb_other = "Gravité : %s"

	L.lightbomb_other = "Lumière : %s"

	L.tantrum_bar = "~Recharge Colère"
end

L = BigWigs:NewBossLocale("Yogg-Saron", "frFR")
if L then
	L["Crusher Tentacle"] = "Tentacule écraseur"
	L["The Observation Ring"] = "le cercle d'observation"

	L.phase = "Phase"
	L.phase_desc = "Prévient quand la rencontre change de phase."
	L.engage_warning = "Phase 1"
	L.engage_trigger = "^Il sera bientôt temps de"
	L.phase2_warning = "Phase 2"
	L.phase2_trigger = "^Je suis le rêve éveillé"
	L.phase3_warning = "Phase 3"
	L.phase3_trigger = "^Contemplez le vrai visage de la mort"

	L.portal = "Portail"
	L.portal_desc = "Prévient de l'arrivée des portails."
	L.portal_trigger = "Des portails s'ouvrent sur l'esprit |2 %s !"
	L.portal_message = "Portails ouverts !"
	L.portal_bar = "Prochains portails"

	L.fervor_cast_message = "Ferveur en incantation sur %s !"
	L.fervor_message = "Ferveur sur %s !"

	L.sanity_message = "Vous allez devenir fou !"

	L.weakened = "Étourdi"
	L.weakened_desc = "Prévient quand Yogg-Saron est étourdi."
	L.weakened_message = "%s est étourdi !"
	L.weakened_trigger = "L'illusion se brise et un chemin s'ouvre vers la salle centrale !"

	L.madness_warning = "Susciter la folie dans 5 sec. !"
	L.malady_message = "Mal : %s"

	L.tentacle = "Tentacule écraseur"
	L.tentacle_desc = "Prévient quand un Tentacule écraseur apparaît."
	L.tentacle_message = "Écraseur %d !"

	L.link_warning = "Votre cerveau est lié !"

	L.gaze_bar = "~Recharge Regard"
	L.empower_bar = "~Recharge Renforcement"

	L.guardian_message = "Gardien %d !"

	L.empowericon_message = "Renforcement terminé !"

	L.roar_warning = "Rugissement dans 5 sec. !"
	L.roar_bar = "Prochain Rugissement"
end
