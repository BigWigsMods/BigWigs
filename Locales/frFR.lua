local L = BigWigsAPI:NewLocale("BigWigs", "frFR")
if not L then return end

L.getNewRelease = "Votre BigWigs est ancien (/bwv), mais vous pouvez facilement le mettre à jour en utilisant le client Curse. Vous pouvez également le mettre à jour à partir de curse.com ou wowinterface.com."
L.warnTwoReleases = "Votre BigWigs est obsolète de 2 versions ! Votre version risque de contenir des bugs, des fonctionnalités manquantes, voire même des délais totalement incorrects. Il est recommandé de faire la mise à jour."
L.warnSeveralReleases = "|cffff0000Votre BigWigs est plusieurs versions derrière la plus récente !! Il est VIVEMENT recommandé d'effectuer la mise à jour afin d'éviter tout problème de synchronisation avec les autres joueurs !|r"

L.gitHubTitle = "BigWigs est sur GitHub"
L.gitHubDesc = "BigWigs est un logiciel open source hébergé sur GitHub. Nous sommes toujours à la recherche de nouvelles personnes pour nous aider et tout le monde est le bienvenu pour inspecter notre code, effectuer des contributions et soumettre des rapports de bogues. BigWigs existe en grande partie grâce à l'aide précieuse de la communauté de WoW.\n\n|cFF33FF99Notre API est désormais documentée et librement consultable sur le wiki GitHub.|r"

L.options = "Options"
L.raidBosses = "Boss de raid"
L.dungeonBosses = "Boss de donjon"

L.infobox = "Boîte d'information"
L.infobox_desc = "Affiche une boîte d'information concernant la rencontre."
L.INFOBOX = L.infobox
L.INFOBOX_desc = L.infobox_desc

L.disabledAddOn = "L'addon |cFF436EEE%s|r est désactivé, les délais ne seront pas affichés."

L.activeBossModules = "Modules de boss actifs :"
L.advanced = "Options avancées"
L.alphaRelease = "Vous utilisez une version ALPHA de BigWigs %s (%s)."
L.already_registered = "|cffff0000ATTENTION :|r |cff00ff00%s|r (|cffffff00%s|r) existe déjà en tant que module dans BigWigs, mais quelque chose essaye de l'enregistrer à nouveau. Cela signifie souvent que vous avez deux copies de ce module dans votre répertoire AddOns suite à une mauvaise mise à jour d'un gestionnaire d'addons. Il est recommandé de supprimer tous les répertoires de BigWigs et de le réinstaller complètement."
L.altpower = "Affichage de la ressource alternative"
L.ALTPOWER = "Affichage de la ressource alternative"
L.altpower_desc = "Affiche la fenêtre de ressource alternative, qui montre la quantité de ressource alternative des membres de votre groupe."
L.ALTPOWER_desc = "Certaines rencontres utilisent le mécanisme de ressource alternative sur les joueurs de votre groupe. L'affichage de la ressource alternative fournit un aperçu rapide de qui a le plus/le moins de ressource alternative, ce qui peut être utile pour des stratégies ou des attributions spécifiques."
L.back = "<< Retour"
L.BAR = "Barres"
L.BAR_desc = "Des barres sont affichées pour certaines techniques des rencontres quand cela est approprié. Si cette technique est accompagnée par une barre que vous souhaitez cacher, désactivez cette option."
L.berserk = "Berserk"
L.berserk_desc = "Prévient quand le boss devient fou furieux."
L.best = "Meilleur :"
L.blizzRestrictionsConfig = "En raison de restrictions mises en place par Blizzard, la configuration doit être chargée une première fois hors combat avant de pouvoir être accessible en combat."
L.blizzRestrictionsZone = "En attente de la fin du combat afin de terminer le chargement en raison de restrictions mises en place par Blizzard."
L.chatMessages = "Messages de la fenêtre de discussion"
L.chatMessagesDesc = "Affiche tous les messages de BigWigs dans la fenêtre de discussion par défaut, en plus de son affichage normal."
L.colors = "Couleurs"
L.configure = "Configuration"
L.coreAddonDisabled = "BigWigs ne fonctionnera pas correctement car l'addon %s est désactivé. Vous pouvez l'activer via le panneau de contrôle des addons à l'écran de sélection du personnage."
L.COUNTDOWN = "Compte à rebours"
L.COUNTDOWN_desc = "Si activé, un compte à rebours vocal et visuel sera ajouté lors des 5 dernières secondes. Imaginez quelqu'un faisant le décompte \"5... 4... 3... 2... 1...\" en plus d'un gros chiffre au milieu de votre écran."
L.dbmFaker = "Prétendre d'utiliser DBM"
L.dbmFakerDesc = "Si un utilisateur de DBM effectue une vérification des versions pour voir qui utilise DBM, il vous verra sur la liste. Utile pour les guildes qui forcent l'utilisation de DBM."
L.dbmUsers = "Utilisateurs de DBM :"
L.DISPEL = "Dispeller uniquement"
L.DISPEL_desc = "Certaines techniques sont importantes uniquement pour les dispeller. Si vous souhaitez voir des alertes pour cette technique quelque soit votre rôle, désactivez cette option."
L.dispeller = "|cFFFF0000Alertes pour dispeller uniquement.|r "
L.EMPHASIZE = "Super mise en évidence"
L.EMPHASIZE_desc = "L'activation de cette option mettra en évidence tous les messages associés à cette technique, les rendant plus grands et plus lisibles. Vous pouvez définir la taille et la police des messages mis en évidence dans les options principales sous la catégorie \"Messages\"."
L.finishedLoading = "Le combat a pris fin, BigWigs a maintenant terminé de se charger."
L.FLASH = "Flash"
L.FLASH_desc = "Certaines techniques sont plus importantes que d'autres. Si vous souhaitez que votre écran clignote quand cette technique est imminente ou utilisée, cochez cette option."
L.flashScreen = "Faire clignoter l'écran"
L.flashScreenDesc = "Certaines techniques sont tellement importantes qu'elles nécessitent toute votre attention. Quand ces techniques vous affectent, BigWigs peut faire clignoter l'écran."
L.flex = "Dyna"
L.healer = "|cFFFF0000Alertes pour soigneur uniquement.|r "
L.HEALER = "Soigneur uniquement"
L.HEALER_desc = "Certaines techniques sont importantes uniquement pour les soigneurs. Si vous souhaitez voir des alertes pour cette technique quelque soit votre rôle, désactivez cette option"
L.heroic = "Héroïque"
L.heroic10 = "10h"
L.heroic25 = "25h"
L.ICON = "Icône"
L.ICON_desc = "BigWigs peut marquer les joueurs affectés par des techniques avec une icône. Cela les rend plus faciles à repérer."
L.introduction = "Bienvenue sur BigWigs, votre compagnon des rencontres de boss. Attachez votre ceinture, gavez-vous de cacahouètes et profitez du voyage. Il ne fera pas de mal à vos enfants, mais vous aidera à préparer cette nouvelle rencontre de boss pour votre groupe de raid."
L.kills = "Victoires :"
L.lfr = "RdR"
L.listAbilities = "Lister les techniques dans la discussion de groupe"
L.ME_ONLY = "Uniquement quand cela m'affecte"
L.ME_ONLY_desc = "Quand vous activez cette option, les messages de cette technique ne seront affichés que si cette dernière vous affecte directement. Par exemple, 'Bombe : Joueur' ne sera affiché que si la bombe est sur vous."
L.MESSAGE = "Messages"
L.MESSAGE_desc = "La plupart des techniques des rencontres comportent un ou plusieurs messages que BigWigs affichera sur votre écran. Si vous désactivez cette option, aucun des messages attachés à cette option ne sera affiché."
L.minimapIcon = "Icône de la minicarte"
L.minimapToggle = "Affiche ou non l'icône de la minicarte."
L.missingAddOn = "Notez que cette zone nécessite le plugin |cFF436EEE%s|r pour que les délais puissent s'afficher."
L.modulesDisabled = "Tous les modules actifs ont été désactivés."
L.modulesReset = "Tous les modules actifs ont été réinitialisés."
L.mythic = "Mythique"
L.noBossMod = "Pas de boss mod :"
L.norm10 = "10"
L.norm25 = "25"
L.normal = "Normal"
L.officialRelease = "Vous utilisez une version FINALISÉE de BigWigs %s (%s)."
L.offline = "Hors ligne"
L.oldVersionsInGroup = "Certains joueurs de votre groupe ont d'anciennes versions ou n'ont pas BigWigs. Tapez /bwv pour plus de détails."
L.outOfDate = "Périmé :"
L.PROXIMITY = "Affichage de proximité"
L.PROXIMITY_desc = "Certaines techniques nécessitent que vous vous espaciez. L'affichage de proximité sera paramétré spécifiquement pour cette technique afin que vous puissiez voir d'un coup d'oeil si vous êtes en sécurité."
L.PULSE = "Pulse"
L.PULSE_desc = "En plus de faire clignoter l'écran, vous pouvez également avoir une icône relative à cette technique qui s'affiche momentanément au milieu de votre écran pour attirer votre attention."
L.removeAddon = "Veuillez enlever '|cFF436EEE%s|r' étant donné qu'il a été remplacé par '|cFF436EEE%s|r'."
L.resetPositions = "Réinitialiser les positions"
L.SAY = "Dire"
L.SAY_desc = "Les bulles de dialogue sont faciles à repérer. BigWigs fera dire un message à votre personnage pour avertir les joueurs proches qu'un effet vous affecte."
L.selectEncounter = "Sélectionnez une rencontre"
L.slashDescBreak = "|cFFFED000/break :|r envoie un temps de pause à votre raid."
L.slashDescConfig = "|cFFFED000/bw :|r ouvre la fenêtre de configuration de BigWigs."
L.slashDescLocalBar = "|cFFFED000/localbar :|r créée une barre personnalisée que seul vous pouvez voir."
L.slashDescPull = "|cFFFED000/pull :|r envoie un compte à rebours de pull à votre raid."
L.slashDescRaidBar = "|cFFFED000/raidbar :|r envoie une barre personnalisée à votre raid."
L.slashDescRange = "|cFFFED000/range :|r ouvre l'indicateur de portée."
L.slashDescTitle = "|cFFFED000Commandes :|r"
L.slashDescVersion = "|cFFFED000/bwv :|r effectue une vérification des versions de BigWigs."
L.sound = "Son"
L.sourceCheckout = "Vous utilisez une version du dépôt de BigWigs %s."
L.stages = "Phases"
L.stages_desc = "Active les fonctions relatives aux différentes phases/étapes du boss telles que la proximité, les barres, etc."
L.statistics = "Statistiques"
L.tank = "|cFFFF0000Alertes pour tank uniquement.|r "
L.TANK = "Tank uniquement"
L.TANK_desc = "Certaines techniques sont importantes uniquement pour les tanks. Si vous souhaitez voir des alertes pour cette technique quelque soit votre rôle, désactivez cette option"
L.tankhealer = "|cFFFF0000Alertes pour tank & soigneur uniquement.|r "
L.TANK_HEALER = "Tank & soigneur uniquement"
L.TANK_HEALER_desc = "Certaines techniques sont importantes uniquement pour les tanks et les soigneurs. Si vous souhaitez voir des alertes pour cette technique quelque soit votre rôle, désactivez cette option."
L.test = "Test"
L.testBarsBtn = "Créer une barre de test"
L.testBarsBtn_desc = "Créée une barre pour que vous puissiez tester vos paramètres d'affichage actuels."
L.toggleAnchorsBtn = "Afficher/cacher ancres"
L.toggleAnchorsBtn_desc = "Affiche ou cache toutes les ancres."
L.tooltipHint = [=[|cffeda55fClic gauche|r pour redémarrer les modules actifs.
|cffeda55fAlt-Clic gauche|r pour les désactiver.
|cffeda55fClic droit|r pour accéder aux options.]=]
L.upToDate = "À jour :"
L.VOICE = "Voix"
L.VOICE_desc = "Si vous avez un plugin vocal installé, cette option l'activera afin qu'il puisse jouer un fichier son qui dira cette alerte à voix haute pour vous."
L.warmup = "Préparation"
L.warmup_desc = "Temps avant que le combat face au boss ne commence."
L.wipes = "Échecs :"
L.zoneMessages = "Afficher les messages de zone"
L.zoneMessagesDesc = "La désactivation de ceci enlevera les messages qui s'affichent quand vous entrez dans une zone pour laquelle BigWigs a un module de délais que vous n'avez pas installé. Nous vous recommendons de laisser ceci activé, étant donné qu'il s'agit de la seule notification que vous recevrez si nous ajoutons un module que vous n'avez pas pour une nouvelle zone qui vous intéresse."

