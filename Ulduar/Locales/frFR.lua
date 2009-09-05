if true then return end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Algalon", "enUS", true)
L:RegisterTranslations("frFR", function() return {
	phase = "Phases",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",
	engage_warning = "Phase 1",
	phase2_warning = "Arrivée de la phase 2",
	phase_bar = "Phase %d",
	engage_trigger = "Vos actions sont illogiques. Tous les résultats possibles de cette rencontre ont été calculés. Le panthéon recevra le message de l'Observateur quelque soit l'issue.", -- à vérifier

	punch_message = "%2$dx Coups de poing phasiques sur %1$s",
	smash_message = "Arrivée d'un Choc cosmique !",
	blackhole_message = "Trou noir %dx apparu",
	bigbang_soon = "Big Bang imminent !",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Auriaya", "enUS", true)
L:RegisterTranslations("frFR", function() return {
	fear_warning = "Hurlement terrifiant imminent !",
	fear_message = "Hurlement terrifiant en incantation !",
	fear_bar = "~H. terrifiant",

	swarm_message = "Swarm",
	swarm_bar = "~Essaim",

	defender = "Défenseur farouche",
	defender_desc = "Prévient quand le Défenseur farouche apparaît et quand il perd une vie.",
	defender_message = "Défenseur actif %d/9 !",

	sonic_bar = "~H. sonore",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Freya", "enUS", true)
L:RegisterTranslations("frFR", function() return {
	engage_trigger1 = "Le jardin doit être protégé !",
	engage_trigger2 = "Anciens, donnez-moi votre force !",

	phase = "Phases",
	phase_desc = "Prévient quand la recontre entre dans une nouvelle phase.",
	phase2_message = "Phase 2 !",

	wave = "Vagues",
	wave_desc = "Prévient de l'arrivée des vagues.",
	wave_bar = "Prochaine vague",
	conservator_trigger = "Eonar, ta servante a besoin d'aide !",
	detonate_trigger = "La nuée des éléments va vous submerger !",
	elementals_trigger = "Mes enfants, venez m'aider !",
	tree_trigger = "Un |cFF00FFFFdon de la Lieuse-de-vie|r commence à pousser !",
	conservator_message = "Ancien conservateur !",
	detonate_message = "Flagellants explosifs !",
	elementals_message = "Élémentaires !",
	tree_message = "Un arbre pousse !",

	fury_message = "Fury",
	fury_other = "Fureur : %s",

	tremor_warning = "Tremblement de terre imminent !",
	tremor_bar = "~Prochain Tremblement",
	energy_message = "Energie instable sur VOUS !",
	sunbeam_message = "Rayons de soleil actif !",
	sunbeam_bar = "~Prochains Rayons de soleil",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par un Rayon de soleil (nécessite d'être assistant ou mieux).",

	end_trigger = "Son emprise sur moi se dissipe. J'y vois à nouveau clair. Merci, héros.",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Hodir", "enUS", true)
L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Vous allez souffrir pour cette intrusion !",

	cold = "Ça caille ici",
	cold_desc = "Prévient quand Froid mordant s'est empilé 2 fois sur votre personnage.",
	cold_message = "Froid mordant x%d !",

	flash_warning = "Gel instantané en incantation !",
	flash_soon = "Gel instantané dans 5 sec. !",

	hardmode = "Délai du mode difficile",
	hardmode_desc = "Affiche une barre de 3 min pour le mode difficile (délai avant qu'Hodir ne détruise sa cache rare).",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par un Nuage d'orage (nécessite d'être assistant ou mieux).",

	end_trigger = "Je suis... libéré de son emprise... enfin.",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Ignis", "enUS", true)
L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Chiots insolents ! Les lames qui serviront à reconquérir ce monde seront trempées dans votre sang !",

	construct_message = "Assemblage activé !",
	construct_bar = "Prochain Assemblage",
	brittle_message = "Un Assemblage est devenu Fragile !",
	flame_bar = "~Recharge Flots",
	scorch_message = "Brûlure sur VOUS !",
	scorch_soon = "Brûlure dans ~5 sec. !",
	scorch_bar = "Prochaine Brûlure",
	slagpot_message = "Marmite : %s",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Iron Council", "enUS", true)
L:RegisterTranslations("frFR", function() return {
	engage_trigger1 = "Vous ne vaincrez pas si facilement l'assemblée du Fer, envahisseurs !",
	engage_trigger2 = "Seule votre extermination complète me conviendra.",
	engage_trigger3 = "Que vous soyez les plus grandes punaises ou les plus grands héros de ce monde, vous n'êtes jamais que des mortels.",

	overload_message = "Surcharge dans 6 sec. !",
	death_message = "Rune de mort sur VOUS !",
	summoning_message = "Arrivée des élémentaires !",

	chased_other = "%s est poursuivi(e) !",
	chased_you = "VOUS êtes poursuivi(e) !",

	overwhelm_other = "P. accablante : %s",

	shield_message = "Bouclier des runes !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par une Puissance accablante ou ciblé par un Eclair tourbillonnant (nécessite d'être assistant ou mieux).",

	council_dies = "%s éliminé",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Kologarn", "enUS", true)
L:RegisterTranslations("frFR", function() return {
	arm = "Destruction des bras",
	arm_desc = "Prévient quand le bras gauche et/ou droit est détruit.",
	left_dies = "Bras gauche détruit",
	right_dies = "Bras droit détruit",
	left_wipe_bar = "Repousse bras gauche",
	right_wipe_bar = "Repousse bras droit",

	shockwave = "Onde de choc",
	shockwave_desc = "Prévient quand la prochaine Onde de choc arrive.",
	shockwave_trigger = "OUBLI !",

	eyebeam = "Rayon de l'oeil",
	eyebeam_desc = "Prévient quand un Rayon de l'oeil focalisé est incanté.",
	eyebeam_trigger = "%s concentre son regard sur vous !",
	eyebeam_message = "Rayon : %s",
	eyebeam_bar = "~Rayon de l'oeil",
	eyebeam_you = "Rayon de l'oeil sur VOUS !",
	eyebeam_say = "Rayon de l'oeil sur moi !",

	eyebeamsay = "Rayon de l'oeil - Dire",
	eyebeamsay_desc = "Fait dire à votre personnage qu'il est ciblé par le Rayon de l'oeil quand c'est le cas.",

	armor_message = "%2$dx broyages d'armure sur %1$s",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Flame Leviathan", "enUS", true)
L:RegisterTranslations("frFR", function() return {
	engage_trigger = "^Entités hostiles détectées.",
	engage_message = "%s engagé !",

	pursue = "Poursuite",
	pursue_desc = "Prévient quand le Léviathan des flammes poursuit un joueur.",
	pursue_trigger = "^%%s poursuit",
	pursue_other = "Poursuivi(e) : %s",

	shutdown_message = "Extinction des systèmes !",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Mimiron", "enUS", true)
L:RegisterTranslations("frFR", function() return {
	phase = "Phases",
	phase_desc = "Prévient quand la recontre entre dans une nouvelle phase.",
	engage_warning = "Phase 1",
	engage_trigger = "^Nous n'avons pas beaucoup de temps, les amis !",
	phase2_warning = "Arrivée de la phase 2",
	phase2_trigger = "^MERVEILLEUX ! Résultats parfaitement formidables !",
	phase3_warning = "Arrivée de la phase 3",
	phase3_trigger = "^Merci, les amis !",
	phase4_warning = "Arrivée de la phase 4",
	phase4_trigger = "^Fin de la phase d'essais préliminaires",
	phase_bar = "Phase %d",

	hardmode = "Autodestruction",
	hardmode_desc = "Affiche une barre de 10 minutes pour le mode difficile (mécanisme d'autodestruction activé).",
	hardmode_trigger = "^Mais, pourquoi",
	hardmode_message = "Autodestruction activée !",
	hardmode_warning = "Autodestruction !",

	plasma_warning = "Plasma en incantation !",
	plasma_soon = "Explosion de plasma imminente !",
	plasma_bar = "Plasma",

	shock_next = "Prochain Horion",

	laser_soon = "Accélération !",
	laser_bar = "Barrage",

	magnetic_message = "UCA au sol !",

	suppressant_warning = "Arrivée d'un Coupe-flamme !",

	fbomb_soon = "Bombe de givre imminente !",
	fbomb_bar = "Prochaine Bombe de givre",

	bomb_message = "Robo-bombe apparu !",

	end_trigger = "^Il semblerait que j'aie pu faire une minime erreur de calcul.",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Razorscale", "enUS", true)
L:RegisterTranslations("frFR", function() return {
	["Razorscale Controller"] = "Contrôleur de Tranchécaille",

	phase = "Phases",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",
	ground_trigger = "Faites vite ! Elle va pas rester au sol très longtemps !",
	ground_message = "Tranchécaille enchaînée !",
	air_trigger = "Laissez un instant pour préparer la construction des tourelles.",
	air_trigger2 = "Incendie éteint ! Reconstruisons les tourelles !",
	air_message = "Décollage !",
	phase2_trigger = "Tranchécaille bloquée au sol !",
	phase2_message = "Phases 2 !",
	phase2_warning = "Phase 2 imminente !",
	stun_bar = "Étourdie",

	breath_trigger = "%s inspire profondément…",
	breath_message = "Souffle de flammes !",
	breath_bar = "~Recharge Souffle",

	flame_message = "Flamme dévorante sur VOUS !",

	harpoon = "Tourelle à harpon",
	harpoon_desc = "Prévient quand une tourelle à harpon est prête.",
	harpoon_message = "Tourelle à harpon %d prête !",
	harpoon_trigger = "Tourelle à harpon prête à l'action !",
	harpoon_nextbar = "Tourelle %d",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Thorim", "enUS", true)
L:RegisterTranslations("frFR", function() return {
	["Runic Colossus"] = "Colosse runique", -- For the runic barrier emote.

	phase = "Phases",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",
	phase1_message = "Phase 1",
	phase2_trigger = "Des intrus ! Mortels, vous qui osez me déranger en plein divertissement allez pay -  Attendez, vous -",
	phase2_message = "Phase 2 - Berserk dans 6 min. 15 sec. !",
	phase3_trigger = "Avortons impertinents, vous osez me défier sur mon piédestal ? Je vais vous écraser moi-même !",
	phase3_message = "Phase 3 - %s engagé !",

	hardmode = "Délai du mode difficile",
	hardmode_desc = "Affiche une barre de 3 minutes pour le mode difficile (délai avant que Sif ne disparaisse).",
	hardmode_warning = "Délai du mode difficile dépassé",

	shock_message = "Horion de foudre sur VOUS !",
	barrier_message = "Barrière runique actif !",

	detonation_say = "Détonation runique sur moi !",

	charge_message = "Charge de foudre x%d !",
	charge_bar = "Charge %d",

	strike_bar = "Recharge Frappe",

	end_trigger = "Retenez vos coups ! Je me rends !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par une Détonation runique (nécessite d'être assistant ou mieux).",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: General Vezax", "enUS", true)
L:RegisterTranslations("frFR", function() return {
	engage_trigger = "^Votre destruction annoncera un nouvel âge de souffrance !",

	surge_message = "Vague de ténèbres %d !",
	surge_cast = "Vague %d en incantation !",
	surge_bar = "Vague %d",

	animus = "Animus de saronite",
	animus_desc = "Prévient quand l'Animus de saronite apparaît.",
	animus_trigger = "Les vapeurs saronitiques s'amassent et tourbillonnent violemment pour former un amas monstrueux !",
	animus_message = "Animus apparu !",

	vapor = "Vapeurs de saronite",
	vapor_desc = "Prévient quand des Vapeurs de saronite apparaissent.",
	vapor_message = "Vapeurs de saronite %d !",
	vapor_bar = "Vapeurs %d/6",
	vapor_trigger = "Un nuage de vapeurs saronitiques se forme non loin !",

	vaporstack = "Cumul des Vapeurs",
	vaporstack_desc = "Prévient quand vous avez 5 cumuls ou plus de Vapeurs de saronite.",
	vaporstack_message = "Vapeurs de saronite x%d !",

	crash_say = "Déferlante d'ombre sur moi !",

	crashsay = "Déferlante - Dire",
	crashsay_desc = "Fait dire à votre personnage qu'il est ciblé par une Déferlante d'ombre quand c'est le cas.",
	crashicon = "Déferlante - Icône",
	crashicon_desc = "Place une icône de raid secondaire sur le dernier joueur ciblé par une Déferlante d'ombre (nécessite d'être assistant ou mieux).",

	mark_message = "Marque",
	mark_message_other = "Marque : %s",

	icon = "Marque - Icône",
	icon_desc = "Place une icône de raid primaire sur le dernier joueur affecté par une Marque du Sans-visage (nécessite d'être assistant ou mieux).",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: XT-002", "enUS", true)
L:RegisterTranslations("frFR", function() return {
	exposed_warning = "Cœur exposé imminent",
	exposed_message = "Cœur exposé !",

	gravitybomb_other = "Gravité : %s",

	gravitybombicon = "Bombe à gravité - Icône",
	gravitybombicon_desc = "Place une icône de raid bleue sur le dernier joueur affecté par une Bombe à gravité (nécessite d'être assistant ou mieux).",

	lightbomb_other = "Lumière : %s",

	tantrum_bar = "~Recharge Colère",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Yogg-Saron", "enUS", true)
L:RegisterTranslations("frFR", function() return {
	["Crusher Tentacle"] = "Tentacule écraseur",
	["The Observation Ring"] = "le cercle d'observation",

	phase = "Phase",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",
	engage_warning = "Phase 1",
	engage_trigger = "^Il sera bientôt temps de",
	phase2_warning = "Phase 2",
	phase2_trigger = "^Je suis le rêve éveillé",
	phase3_warning = "Phase 3",
	phase3_trigger = "^Contemplez le vrai visage de la mort",

	portal = "Portail",
	portal_desc = "Prévient de l'arrivée des portails.",
	portal_trigger = "Des portails s'ouvrent sur l'esprit |2 %s !",
	portal_message = "Portails ouverts !",
	portal_bar = "Prochains portails",

	sanity_message = "Vous allez devenir fou !",

	weakened = "Étourdi",
	weakened_desc = "Prévient quand Yogg-Saron est étourdi.",
	weakened_message = "%s est étourdi !",
	weakened_trigger = "L'illusion se brise et un chemin s'ouvre vers la salle centrale !",

	madness_warning = "Susciter la folie dans 5 sec. !",
	malady_message = "Mal : %s",

	tentacle = "Tentacule écraseur",
	tentacle_desc = "Prévient quand un Tentacule écraseur apparaît.",
	tentacle_message = "Écraseur %d !",

	link_warning = "Votre cerveau est lié !",

	gaze_bar = "~Recharge Regard",
	empower_bar = "~Recharge Renforcement",

	guardian_message = "Gardien %d !",

	empowericon = "Renforcement - Icône",
	empowericon_desc = "Place un crâne sur le Gardien immortel ayant Renforcement des ombres.",
	empowericon_message = "Renforcement terminé !",

	roar_warning = "Rugissement dans 5 sec. !",
	roar_bar = "Prochain Rugissement",
} end )
