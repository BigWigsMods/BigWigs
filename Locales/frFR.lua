local _, addonTbl = ...
local L = addonTbl.API:NewLocale("BigWigs", "frFR")
if not L then return end

-- API.lua
L.showAddonBar = "L'addon '%s' a créé la barre '%s'."

-- Core.lua
L.berserk = "Berserk"
L.berserk_desc = "Prévient quand le boss devient fou furieux."
L.altpower = "Affichage de la ressource alternative"
L.altpower_desc = "Affiche la fenêtre de ressource alternative, qui montre la quantité de ressource alternative des membres de votre groupe."
L.infobox = "Boîte d'information"
L.infobox_desc = "Affiche une boîte d'information concernant la rencontre."
L.stages = "Phases"
L.stages_desc = "Active les fonctions relatives aux différentes phases lors d'un combat de boss tels quel les avertissements de changement de phase, les bars de durée de phase, etc."
L.warmup = "Préparation"
L.warmup_desc = "Temps avant que le combat face au boss ne commence."
L.proximity = "Affichage de proximité"
L.proximity_desc = "Affiche la fenêtre de proximité quand cela est approprié pour cette rencontre, indiquant la liste des joueurs qui se trouvent trop près de vous."
L.adds = "Adds"
L.adds_desc = "Active les fonctions relatives aux adds qui apparaissent durant le combat de boss."
L.health = "Vie"
L.health_desc = "Active les fonctions afin d'afficher diverses informations sur la vie durant le combat de boss."
L.energy = "Énergie"
L.energy_desc = "Active les fonctions d'information d'affichage par rapport aux différents niveaux d'énergie durant les rencontres."

L.already_registered = "|cffff0000ATTENTION :|r |cff00ff00%s|r (|cffffff00%s|r) existe déjà en tant que module dans BigWigs, mais quelque chose essaye de l'enregistrer à nouveau. Cela signifie souvent que vous avez deux copies de ce module dans votre répertoire AddOns suite à une mauvaise mise à jour d'un gestionnaire d'addons. Il est recommandé de supprimer tous les répertoires de BigWigs et de le réinstaller complètement."

-- Loader / Options.lua
L.okay = "OK"
L.officialRelease = "Vous utilisez une version FINALISÉE de BigWigs %s (%s)."
L.alphaRelease = "Vous utilisez une version ALPHA de BigWigs %s (%s)."
L.sourceCheckout = "Vous utilisez une version du dépôt de BigWigs %s."
L.littlewigsOfficialRelease = "Vous utilisez une version FINALISÉE de LittleWigs (%s)."
L.littlewigsAlphaRelease = "Vous utilisez une version ALPHA de LittleWigs (%s)."
L.littlewigsSourceCheckout = "Vous utilisez une version du dépôt de LittleWigs."
L.guildRelease = "Vous utilisez la version %d de BigWigs spécialement conçue pour votre guilde, basée sur la version %d de l'addon officiel."
L.getNewRelease = "Votre BigWigs est ancien (/bwv), mais vous pouvez facilement le mettre à jour en utilisant le client CurseForge. Vous pouvez également le mettre à jour à partir de curseforge.com ou addons.wago.io."
L.warnTwoReleases = "Votre BigWigs est obsolète de 2 versions ! Votre version risque de contenir des bugs, des fonctionnalités manquantes, voire même des délais totalement incorrects. Il est recommandé de faire la mise à jour."
L.warnSeveralReleases = "|cffff0000Votre BigWigs est %d versions derrière la plus récente !! Il est VIVEMENT recommandé d'effectuer la mise à jour afin d'éviter tout problème de synchronisation avec les autres joueurs !|r"
L.warnOldBase = "Vous utilisez une version guilde de BigWigs (%d), mais votre version de base (%d) est %d releases en retard. Cela peut poser problèmes."

L.tooltipHint = "|cffeda55fClic droit|r pour accéder aux options."
L.activeBossModules = "Modules de boss actifs :"

L.oldVersionsInGroup = "Certains joueurs de votre groupe ont |cffff0000d'anciennes versions|r de BigWigs. Tapez /bwv pour plus de détails."
L.upToDate = "À jour :"
L.outOfDate = "Périmé :"
L.dbmUsers = "Utilisateurs de DBM :"
L.noBossMod = "Pas de boss mod :"
L.offline = "Hors ligne"

L.missingAddOnPopup = "L'addon |cFF436EEE%s|r est manquant !"
L.missingAddOnRaidWarning = "L'addon |cFF436EEE%s|r est manquant ! Aucun timers ne sera affiché dans cette zone !"
L.outOfDateAddOnPopup = "L'addon |cFF436EEE%s|r n'est pas à jour !"
L.outOfDateAddOnRaidWarning = "L'addon |cFF436EEE%s|r n'est pas à jour ! Vous avez la v%d.%d.%d mais la dernière est v%d.%d.%d !"
L.disabledAddOn = "L'addon |cFF436EEE%s|r est désactivé, les délais ne seront pas affichés."
L.removeAddOn = "Veuillez enlever '|cFF436EEE%s|r' étant donné qu'il a été remplacé par '|cFF436EEE%s|r'."
L.alternativeName = "%s (|cFF436EEE%s|r)"
L.outOfDateContentPopup = "ATTENTION !\nVous avez mis à jour |cFF436EEE%s|r mais vous avez également besoin de mettre à jour l'addon principal |cFF436EEEBigWigs|r.\nIgnorer cela empêchera le fonctionnement de certaines fonctionnalités."
L.outOfDateContentRaidWarning = "|cFF436EEE%s|r a besoin de la version %d de l'addon principal |cFF436EEEBigWigs|r afin de fonctionner correctement, mais vous êtes en version %d."
L.addOnLoadFailedWithReason = "BigWigs a échoué à charger l'addon |cFF436EEE%s|r avec comme raison %q. Avertissez les développeurs de BigWigs !"
L.addOnLoadFailedUnknownError = "BigWigs a rencontré une erreur lors du chargement de l'addon |cFF436EEE%s|r. Avertissez les développeurs de BigWigs !"

L.expansionNames = {
	"Classic", -- Classic
	"The Burning Crusade", -- The Burning Crusade
	"Wrath of the Lich King", -- Wrath of the Lich King
	"Cataclysm", -- Cataclysm
	"Mists of Pandaria", -- Mists of Pandaria
	"Warlords of Draenor", -- Warlords of Draenor
	"Legion", -- Legion
	"Battle for Azeroth", -- Battle for Azeroth
	"Shadowlands", -- Shadowlands
	"Dragonflight", -- Dragonflight
	"The War Within", -- The War Within
}
L.littleWigsExtras = {
	["LittleWigs_Delves"] = "Gouffres",
	["LittleWigs_CurrentSeason"] = "Saison actuelle",
}

-- Media.lua (These are the names of the sounds in the dropdown list in the "sounds" section)
L.Beware = "Attention (Algalon)"
L.FlagTaken = "Drapeau pris (JcJ)"
L.Destruction = "Destruction (Kil'jaeden)"
L.RunAway = "Cours petite fille, cours (Le Grand Méchant Loup)"
L.spell_on_you = "BigWigs : sort sur vous"
L.spell_under_you = "BigWigs : sort en dessous de vous"
L.simple_no_voice = "Simple (Pas de voix)"

-- Options.lua
L.options = "Options"
L.optionsKey = "ID : %s" -- The ID that messages/bars/options use
L.raidBosses = "Boss de raid"
L.dungeonBosses = "Boss de donjon"
L.introduction = "Bienvenue sur BigWigs, votre compagnon des rencontres de boss. Attachez votre ceinture, gavez-vous de cacahouètes et profitez du voyage. Il ne fera pas de mal à vos enfants, mais vous aidera à préparer cette nouvelle rencontre de boss pour votre groupe de raid."
L.sound = "Son"
L.minimapIcon = "Icône de la minicarte"
L.minimapToggle = "Affiche ou non l'icône de la minicarte."
L.compartmentMenu = "Aucun icône de compartiment"
L.compartmentMenu_desc = "Désactiver cette option rendra Bigwigs visible dans le menu compartiment addon. Nous recommendons de laisser cette option activée."
L.configure = "Configuration"
L.resetPositions = "Réinitialiser les positions"
L.selectEncounter = "Sélectionnez une rencontre"
L.privateAuraSounds = "Sons privés d'aura"
L.privateAuraSounds_desc = "Les auras privées ne peuvent être trackées normalement, mais vous pouvez enregistrer un son qui sera joué lorsque vous serez ciblé par la compétence."
L.listAbilities = "Lister les techniques dans la discussion de groupe"

L.dbmFaker = "Prétendre d'utiliser DBM"
L.dbmFakerDesc = "Si un utilisateur de DBM effectue une vérification des versions pour voir qui utilise DBM, il vous verra sur la liste. Utile pour les guildes qui forcent l'utilisation de DBM."
L.zoneMessages = "Afficher les messages de zone"
L.zoneMessagesDesc = "La désactivation de ceci enlevera les messages qui s'affichent quand vous entrez dans une zone pour laquelle BigWigs a un module de délais que vous n'avez pas installé. Nous vous recommendons de laisser ceci activé, étant donné qu'il s'agit de la seule notification que vous recevrez si nous ajoutons un module que vous n'avez pas pour une nouvelle zone qui vous intéresse."
L.englishSayMessages = "Messages dans le chat en anglais"
L.englishSayMessagesDesc = "Tous les messages envoyés durant les combats de boss dans les discussions 'dire' et 'crier' seront toujours en anglais. Cette option peut être utile lorsque votre groupe est multilingue."

L.slashDescTitle = "|cFFFED000Commandes :|r"
L.slashDescPull = "|cFFFED000/pull :|r envoie un compte à rebours de pull à votre raid."
L.slashDescBreak = "|cFFFED000/break :|r envoie un temps de pause à votre raid."
L.slashDescRaidBar = "|cFFFED000/raidbar :|r envoie une barre personnalisée à votre raid."
L.slashDescLocalBar = "|cFFFED000/localbar :|r créée une barre personnalisée que seul vous pouvez voir."
L.slashDescRange = "|cFFFED000/range :|r ouvre l'indicateur de portée."
L.slashDescVersion = "|cFFFED000/bwv :|r effectue une vérification des versions de BigWigs."
L.slashDescConfig = "|cFFFED000/bw :|r ouvre la fenêtre de configuration de BigWigs."

L.gitHubDesc = "|cFF33FF99BigWigs est un logiciel open source hébergé sur GitHub. Nous sommes toujours à la recherche de nouvelles personnes pour nous aider et tout le monde est le bienvenu pour inspecter notre code, effectuer des contributions et soumettre des rapports de bogues. BigWigs existe en grande partie grâce à l'aide précieuse de la communauté de WoW.|r"

L.BAR = "Barres"
L.MESSAGE = "Messages"
L.ICON = "Icône"
L.SAY = "Dire"
L.FLASH = "Flash"
L.EMPHASIZE = "Mise en évidence"
L.ME_ONLY = "Si cela m'affecte"
L.ME_ONLY_desc = "Quand vous activez cette option, les messages de cette technique ne seront affichés que si cette dernière vous affecte directement. Par exemple, 'Bombe : Joueur' ne sera affiché que si la bombe est sur vous."
L.PULSE = "Pulse"
L.PULSE_desc = "En plus de faire clignoter l'écran, vous pouvez également avoir une icône relative à cette technique qui s'affiche momentanément au milieu de votre écran pour attirer votre attention."
L.MESSAGE_desc = "La plupart des techniques des rencontres comportent un ou plusieurs messages que BigWigs affichera sur votre écran. Si vous désactivez cette option, aucun des messages attachés à cette option ne sera affiché."
L.BAR_desc = "Des barres sont affichées pour certaines techniques des rencontres quand cela est approprié. Si cette technique est accompagnée par une barre que vous souhaitez cacher, désactivez cette option."
L.FLASH_desc = "Certaines techniques sont plus importantes que d'autres. Si vous souhaitez que votre écran clignote quand cette technique est imminente ou utilisée, cochez cette option."
L.ICON_desc = "BigWigs peut marquer les joueurs affectés par des techniques avec une icône. Cela les rend plus faciles à repérer."
L.SAY_desc = "Les bulles de dialogue sont faciles à repérer. BigWigs fera dire un message à votre personnage pour avertir les joueurs proches qu'un effet vous affecte."
L.EMPHASIZE_desc = "L'activation de cette option mettra en évidence tous les messages associés à cette technique, les rendant plus grands et plus lisibles. Vous pouvez définir la taille et la police des messages mis en évidence dans les options principales sous la catégorie \"Messages\"."
L.PROXIMITY = "Affichage de proximité"
L.PROXIMITY_desc = "Certaines techniques nécessitent que vous vous espaciez. L'affichage de proximité sera paramétré spécifiquement pour cette technique afin que vous puissiez voir d'un coup d'oeil si vous êtes en sécurité."
L.ALTPOWER = "Affichage de la ressource alternative"
L.ALTPOWER_desc = "Certaines rencontres utilisent le mécanisme de ressource alternative sur les joueurs de votre groupe. L'affichage de la ressource alternative fournit un aperçu rapide de qui a le plus/le moins de ressource alternative, ce qui peut être utile pour des stratégies ou des attributions spécifiques."
L.TANK = "Tank uniquement"
L.TANK_desc = "Certaines techniques sont importantes uniquement pour les tanks. Si vous souhaitez voir des alertes pour cette technique quelque soit votre rôle, désactivez cette option"
L.HEALER = "Soigneur uniquement"
L.HEALER_desc = "Certaines techniques sont importantes uniquement pour les soigneurs. Si vous souhaitez voir des alertes pour cette technique quelque soit votre rôle, désactivez cette option"
L.TANK_HEALER = "Tank & soigneur uniquement"
L.TANK_HEALER_desc = "Certaines techniques sont importantes uniquement pour les tanks et les soigneurs. Si vous souhaitez voir des alertes pour cette technique quelque soit votre rôle, désactivez cette option."
L.DISPEL = "Dispeller uniquement"
L.DISPEL_desc = "Certaines techniques sont importantes uniquement pour les dispeller. Si vous souhaitez voir des alertes pour cette technique quelque soit votre rôle, désactivez cette option."
L.VOICE = "Voix"
L.VOICE_desc = "Si vous avez un plugin vocal installé, cette option l'activera afin qu'il puisse jouer un fichier son qui dira cette alerte à voix haute pour vous."
L.COUNTDOWN = "Compte à rebours"
L.COUNTDOWN_desc = "Si activé, un compte à rebours vocal et visuel sera ajouté lors des 5 dernières secondes. Imaginez quelqu'un faisant le décompte \"5... 4... 3... 2... 1...\" en plus d'un gros chiffre au milieu de votre écran."
L.CASTBAR_COUNTDOWN = "Compte à rebours (uniquement pour les barres d'incantation)"
L.CASTBAR_COUNTDOWN_desc = "Si activé, un compte à rebours vocal et visuel sera ajouté lors des 5 dernières secondes de la barre d'incantation."
L.INFOBOX = L.infobox
L.INFOBOX_desc = L.infobox_desc
L.SOUND = L.sound
L.SOUND_desc = "Les techniques des boss sont habituellement accompagnées de sons afin de vous aider à les repérer. Si vous désactivez cette option, aucun des sons qui l'accompagnent ne seront joués."
L.CASTBAR = "Barres d'incantation"
L.CASTBAR_desc = "Les barres d'incantation sont parfois affichées sur certains boss, habituellement pour attirer l'attention sur une technique critique imminente. Si cette technique est accompagnée d'une barre d'incantation que vous souhaitez cacher, désactivez cette option."
L.SAY_COUNTDOWN = "Dire le compte à rebours"
L.SAY_COUNTDOWN_desc = "Les bulles de discussion sont faciles à repérer. BigWigs utilisera plusieurs messages en compte à rebours pour avertir les personnes proches qu'une technique vous affectant est sur le point de disparaitre."
L.ME_ONLY_EMPHASIZE = "Mise en évidence (sur moi)"
L.ME_ONLY_EMPHASIZE_desc = "L'activation de cette option mettra en évidence tous les messages associés à cette technique UNIQUEMENT si vous en êtes la cible, les rendant plus grands et plus visibles."
L.NAMEPLATE = "Barres d'infos"
L.NAMEPLATE_desc = "Si activé, les fonctionnalités telles que les icônes et le text relatif à cette technique spéciale s'affichera sur vos barres de noms. Cela permet de voir plus facilement quel PNJ est en train de lancer une capacité lorsqu'il y a plusieurs PNJs qui la lancent."
L.PRIVATE = "Aura personnelle"
L.PRIVATE_desc = "Les auras personnelles ne peuvent pas être suivies, cependant le son \"sur vous\" (Avertissement) peut être activé dans l'onglet Son."

L.advanced_options = "Options avancées"
L.back = "<< Retour"

L.tank = "|cFFFF0000Alertes pour tank uniquement.|r "
L.healer = "|cFFFF0000Alertes pour soigneur uniquement.|r "
L.tankhealer = "|cFFFF0000Alertes pour tank & soigneur uniquement.|r "
L.dispeller = "|cFFFF0000Alertes pour dispeller uniquement.|r "

-- Sharing.lua
L.import = "Importer"
L.import_info = "Après avoir entré une chaîne, vous pouvez sélectionner quels paramètres vous souhaitez importer.\nSi les paramètres ne sont pas disponibles dans la chaîne d'import, ils ne seront pas sélectionnables.\n\n|cffff4411Cet import n'affectera que les paramètres généraux et non les paramètres spécifiques à chaque boss.|r"
L.import_info_active = "Choisissez quelles parties vous souhaitez importer, puis cliquez sur le bouton Importer."
L.import_info_none = "|cFFFF0000La chaîne d'import est incompatible ou périmée.|r"
L.export = "Exporter"
L.export_info = "Sélectionnez quels paramètres vous souhaitez exporter et partager avec les autres.\n\n|cffff4411Vous ne pouvez partager que les paramètres généraux et ces derniers n'ont aucun effet sur les paramètres spécifiques de boss.|r"
L.export_string = "Chaîne d'export"
L.export_string_desc = "Copiez cette chaîne de caractères BigWigs si vous voulez partager vos paramètres."
L.import_string = "Chaîne d'import"
L.import_string_desc = "Collez la chaîne de caractères BigWigs que vous souhaitez importer ici."
L.position = "Position"
L.settings = "Paramètres"
L.other_settings = "Autres paramètres"
L.nameplate_settings_import_desc = "Importer tous les paramètres des barres d'infos."
L.nameplate_settings_export_desc = "Exporter tous les paramètres des barres d'infos."
L.position_import_bars_desc = "Importer la position (ancres) des barres."
L.position_import_messages_desc = "Importer la position (ancres) des messages."
L.position_import_countdown_desc = "mporter la position (ancres) du compte à rebours."
L.position_export_bars_desc = "Exporter la position (ancres) des barres."
L.position_export_messages_desc = "Exporter la position (ancres) des messages."
L.position_export_countdown_desc = "Exporter la position (ancres) du compte à rebours."
L.settings_import_bars_desc = "Importez les paramètres généraux des barres, tels que la taille, la police, etc."
L.settings_import_messages_desc = "Importez les paramètres généraux des messages, tels que la taille, la police, etc."
L.settings_import_countdown_desc = "Importez les paramètres généraux du compte à rebours, tels que la voix, la taille, la police, etc."
L.settings_export_bars_desc = "Exportez les paramètres généraux des barres, tels que la taille, la police, etc."
L.settings_export_messages_desc = "Exportez les paramètres généraux des messages, tels que la taille, la police, etc."
L.settings_export_countdown_desc = "Exportez les paramètres généraux du compte à rebours, tels que la voix, la taille, la police, etc."
L.colors_import_bars_desc = "Importez la couleur des barres."
L.colors_import_messages_desc = "Importez la couleur des messages."
L.color_import_countdown_desc = "Importez la couleur du compte à rebours."
L.colors_export_bars_desc = "Exportez la couleur des barres."
L.colors_export_messages_desc = "Exportez la couleur des messages."
L.color_export_countdown_desc = "Exportez la couleur du compte à rebours."
L.confirm_import = "Les paramètres sélectionnés que vous êtes sur le point d'importer écraseront les paramètres du profil sélectionné actuellement :\n\n|cFF33FF99\"%s\"|r\n\nÊtes-vous sûr de vouloir continuer ?"
L.confirm_import_addon = "L'addon |cFF436EEE\"%s\"|r souhaite importer automatiquement de nouveaux paramètres BigWigs, qui écraserons les paramètres dans votre profil actuel :\n\n|cFF33FF99\"%s\"|r\n\nÊtes-vous sûr de vouloir continuer ?"
L.confirm_import_addon_new_profile = "L'addon |cFF436EEE\"%s\"|r souhaite créer automatiquement un nouveau profil BigWigs appelé :\n\n|cFF33FF99\"%s\"|r\n\nAccepter ce nouveau profil vous feras basculer sur ce dernier."
L.confirm_import_addon_edit_profile = "L'addon |cFF436EEE\"%s\"|r souhaite automatiquement éditer un de vos profils BigWigs appelé :\n\n|cFF33FF99\"%s\"|r\n\n Accepter ces changements vous fera basculter sur ce dernier."
L.no_string_available = "Aucune chaîne stockée à importer. D'abord, importez une chaîne."
L.no_import_message = "Aucun paramètre n'a été importé."
L.import_success = "Importé : %s" -- Imported: Bar Anchors, Message Colors
L.imported_bar_positions = "Position de la barre"
L.imported_bar_settings = "Paramètres de la barre"
L.imported_bar_colors = "Couleurs de la barre"
L.imported_message_positions = "Positions des messages"
L.imported_message_settings = "Paramètres des messages"
L.imported_message_colors = "Couleurs des messages"
L.imported_countdown_position = "Position du compte à rebours"
L.imported_countdown_settings = "Paramètres du compte à rebours"
L.imported_countdown_color = "Couleur du compte à rebours"
L.imported_nameplate_settings = "Paramètres de barres d'infos"

-- Statistics
L.statistics = "Statistiques"
L.defeat = "Défaite"
L.defeat_desc = "Le nombre total de fois où vous avez été vaincu par le boss."
L.victory = "Victoire"
L.victory_desc = "Le nombre total de fois où vous avez été victorieux face au boss."
L.fastest = "Le plus rapide"
L.fastest_desc = "La victoire la plus rapide, et la date à laquelle cela est arrivé (Année/Mois/Jour)"
L.first = "Première victoire"
L.first_desc = "La première fois où vous avez été victorieux contre ce boss, formaté comme ceci :\n[Nombre de défaites avant la première victoire] - [Durée du combat] - [Année/Mois/Jour de la victoire]"

-- Difficulty levels for statistics display on bosses
L.unknown = "Inconnu"
L.LFR = "RdR"
L.normal = "Normal"
L.heroic = "Héroïque"
L.mythic = "Mythique"
L.timewalk = "Marcheur du temps"
L.solotier8 = "Solo Tier 8"
L.solotier11 = "Solo Tier 11"
L.story = "Histoire"
L.mplus = "Mythique+ %d"
L.SOD = "Saison de la Découverte"
L.hardcore = "Hardcore"
L.level1 = "Niveau 1"
L.level2 = "Niveau 2"
L.level3 = "Niveau 3"
L.N10 = "10 joueurs"
L.N25 = "25 joueurs"
L.H10 = "Héroïque 10"
L.H25 = "Héroïque 25"

-----------------------------------------------------------------------
-- TOOLS
-----------------------------------------------------------------------

L.tools = "Outils"
L.toolsDesc = "BigWigs propose divers outils ou des fonctionnalités \"qualité de vie\" afin d'accélérer et simplifier les combats de boss. Depliez le menu en cliquant sur |cFF33FF99+|r l'icône afin de tous les voir."

-----------------------------------------------------------------------
-- AutoRole.lua
--

L.autoRoleTitle = "Rôle automatique"
L.autoRoleExplainer = "Lorsque vous rejoignez un groupe, ou que vous changez de spécialisation alors que vous êtes en groupe, BigWigs mettra à jour automatiquement votre rôle de groupe (Tank, Soigneur, Dégâts) en conséquence.\n\n"

-----------------------------------------------------------------------
-- Keystones.lua
--

L.keystoneTitle = "BigWigs clefs mythique +"
L.keystoneHeaderParty = "Groupe"
L.keystoneRefreshParty = "MàJ Groupe"
L.keystoneHeaderGuild = "Guilde"
L.keystoneRefreshGuild = "MàJ Guilde"
L.keystoneLevelTooltip = "Niveau de clef : |cFFFFFFFF%s|r"
L.keystoneMapTooltip = "Donjon : |cFFFFFFFF%s|r"
L.keystoneRatingTooltip = "Côte mythique + : |cFFFFFFFF%d|r"
L.keystoneHiddenTooltip = "Le joueur a choisi de cacher cette information."
L.keystoneTabOnline = "En ligne"
L.keystoneTabAlts = "Rerolls"
L.keystoneTabTeleports = "Téléportations"
L.keystoneHeaderMyCharacters = "Mes personnages"
L.keystoneTeleportNotLearned = "Le sort de téléportation '|cFFFFFFFF%s|r' n'est |cFFFF4411pas appris|r pour le moment."
L.keystoneTeleportOnCooldown = "Le sort de téléportation '|cFFFFFFFF%s|r' est actuellement |cFFFF4411en recharge|r pour %d |4heure:heures; et %d |4minute:minutes;."
L.keystoneTeleportReady = "Le sort de téléportation '|cFFFFFFFF%s|r' est |cFF33FF99prêt|r, cliquez pour le lancer."
L.keystoneTeleportInCombat = "Vous ne pouvez pas vous téléportez là lors d'un combat."
L.keystoneTabHistory = "Historique"
L.keystoneHeaderThisWeek = "Cette semaine"
L.keystoneHeaderOlder = "Plus ancien"
L.keystoneScoreTooltip = "Score du donjon : |cFFFFFFFF%d|r"
L.keystoneScoreGainedTooltip = "Score gagné : |cFFFFFFFF+%d|r"
L.keystoneCompletedTooltip = "Réussite dans les temps"
L.keystoneFailedTooltip = "Échec à terminer dans les temps"
L.keystoneExplainer = "Une collection de divers outils pour améliorer l'expérience mythique +."
L.keystoneAutoSlot = "Clef dans le socle automatique"
L.keystoneAutoSlotDesc = "Place automatiquement votre clef dans le socle lorsque vous ouvrez la fontaine de puissance."
L.keystoneAutoSlotMessage = "Placement automatique de %s dans l'emplacement de la fontaine."
L.keystoneModuleName = "Mythique +"
L.keystoneStartBar = "%s +%d" -- Format is SHORT_DUNGEON_NAME +KEYSTONE_LEVEL e.g. "ROOK +12"
L.keystoneStartMessage = "%s +%d commence maintenant !" -- Format is LONG_DUNGEON_NAME +KEYSTONE_LEVEL e.g. "The Rookery +12 begins now!"
L.keystoneCountdownExplainer = "Lorsque vous commencez un donjon mythique +, un compte à rebours se lancera. Choisissez quelle voix vous souhaitez entendre et quand le compte à rebours commencera.\n\n"
L.keystoneCountdownBeginsDesc = "Choisissez combien de temps il doit rester au compte à rebours de départ avant de l'entendre."
L.keystoneCountdownBeginsSound = "Joue un son lorsque le compte à rebours de mythique + commence"
L.keystoneCountdownEndsSound = "Joue un son lorsque le compte à rebours de mythique + se termine"
L.keystoneViewerTitle = "Vue des clefs"
L.keystoneHideGuildTitle = "Cache ma clef des autres membres de la guilde"
L.keystoneHideGuildDesc = "|cffff4411Non recommandé.|r Cette fonctionnalité empêche vos membres de guilde de voire votre clef. N'importe qui dans votre groupe pourra la voire."
L.keystoneHideGuildWarning = "Désactiver la possibilité pour vos membres de guilde de voir votre clef est |cffff4411non recommandé|r.\n\nÊtes-vous sûr(e) de vouloir faire cela ?"
L.keystoneAutoShowEndOfRun = "Affiche lorsque le mythique + est terminé"
L.keystoneAutoShowEndOfRunDesc = "Montre automatiquement la vue des clefs lorsque le donjon mythique + est terminé.\n\n|cFF33FF99Cela peut vous aider à voir les nouvelles clefs que votre groupe a obtenu.|r"
L.keystoneViewerExplainer = "Vous pouvez ouvrir la vue des clefs en utilisant la commande |cFF33FF99/key|r ou en cliquant sur le bouton ci-dessous.\n\n"
L.keystoneViewerOpen = "Ouvre l'affichage des clefs"
L.keystoneClickToWhisper = "Cliquez pour ouvrir une fenêtre de dialogue"
L.keystoneClickToTeleportNow = "\nCliquez pour vous téléporter ici"
L.keystoneClickToTeleportCooldown = "\nTéléportation impossible, sort en cours de recharge"
L.keystoneClickToTeleportNotLearned = "\nTéléportation impossible, sort non appris"
L.keystoneHistoryRuns = "Total : %d"
L.keystoneHistoryRunsThisWeekTooltip = "Montant total de donjons effectués cette semaine : |cFFFFFFFF%d|r"
L.keystoneHistoryRunsOlderTooltip = "Montant total de donjons effectués avant cette semaine : |cFFFFFFFF%d|r"
L.keystoneHistoryScore = "Score : +%d"
L.keystoneHistoryScoreThisWeekTooltip = "Score total gagné cette semaine : |cFFFFFFFF+%d|r"
L.keystoneHistoryScoreOlderTooltip = "Score total gagné avant cette semaine : |cFFFFFFFF+%d|r"

-- It doesn't really matter what you call it as long as it's recognizable and limited to ~6 characters
L.keystoneShortName_TheRookery = "COLONIE"
L.keystoneShortName_DarkflameCleft = "FAILLE"
L.keystoneShortName_PrioryOfTheSacredFlame = "PRIEURÉ"
L.keystoneShortName_CinderbrewMeadery = "HYDROM"
L.keystoneShortName_OperationFloodgate = "VANNES"
L.keystoneShortName_TheaterOfPain = "THÉÂTRE"
L.keystoneShortName_TheMotherlode = "FILON"
L.keystoneShortName_OperationMechagonWorkshop = "ATELIER"
L.keystoneShortName_EcoDomeAldani = "ALDANI"
L.keystoneShortName_HallsOfAtonement = "EXPIA"
L.keystoneShortName_AraKaraCityOfEchoes = "ARAK"
L.keystoneShortName_TazaveshSoleahsGambit = "SOLEAH"
L.keystoneShortName_TazaveshStreetsOfWonder = "RUES"
L.keystoneShortName_TheDawnbreaker = "BRISE"

-- These short names are for the bar that shows during the Mythic+ countdown
-- Use the real dungeon names but make them shorter to fit on the bar better
L.keystoneShortName_TheRookery_Bar = "Colonie"
L.keystoneShortName_DarkflameCleft_Bar = "Flamme-Noire"
L.keystoneShortName_PrioryOfTheSacredFlame_Bar = "Prieuré"
L.keystoneShortName_CinderbrewMeadery_Bar = "Brassecendre"
L.keystoneShortName_OperationFloodgate_Bar = "Vannes Ouvertes"
L.keystoneShortName_TheaterOfPain_Bar = "Théâtre"
L.keystoneShortName_TheMotherlode_Bar = "Filon"
L.keystoneShortName_OperationMechagonWorkshop_Bar = "Atelier"
L.keystoneShortName_EcoDomeAldani_Bar = "Al'dani"
L.keystoneShortName_HallsOfAtonement_Bar = "Expiation"
L.keystoneShortName_AraKaraCityOfEchoes_Bar = "Ara-Kara"
L.keystoneShortName_TazaveshSoleahsGambit_Bar = "Stratagème"
L.keystoneShortName_TazaveshStreetsOfWonder_Bar = "Rues"
L.keystoneShortName_TheDawnbreaker_Bar = "Brise-Aube"

-- Instance Keys "Who has a key?"
--L.instanceKeysTitle = "Who has a key?"
--L.instanceKeysDesc = "When you enter a Mythic dungeon, the players that have a keystone for that dungeon will be displayed as a list.\n\n"
--L.instanceKeysTest8 = "Dungeon +8 - |cFF00FF98Monk|r"
--L.instanceKeysTest10 = "Dungeon +10 - |cFFFF7C0ADruid|r"
--L.instanceKeysDisplay = "%s +%d - |c%s%s|r" -- "DUNGEON_NAME +DUNGEON_LEVEL - PLAYER_NAME"

-----------------------------------------------------------------------
-- LFGTimer.lua
--

L.lfgTimerTitle = "LFG Timer"
L.lfgTimerExplainer = "Whenever the LFG queue popup appears, BigWigs will create a timer bar telling you how long you have to accept the queue.\n\n"
L.lfgUseMaster = "Play LFG ready sound on 'Master' audio channel"
L.lfgUseMasterDesc = "When this option is enabled the LFG ready sound will play over the 'Master' audio channel. If you disable this option it will play over the '%s' audio channel instead."

-----------------------------------------------------------------------
-- PLUGINS
-----------------------------------------------------------------------

L.general = "Général"
L.advanced = "Avancé"
L.comma = ", "
L.reset = "Réinitialiser"
--L.resetDesc = "Reset the above settings to their default values."
L.resetAll = "Tout réinitialiser"

L.positionX = "Position X"
L.positionY = "Position Y"
L.positionExact = "Positionnement exact"
L.positionDesc = "Tapez dans la saisie ou déplacez le curseur si vous avez besoin d'un positionnement exact par rapport à l'ancre."
L.width = "Largeur"
L.height = "Hauteur"
L.size = "Taille"
L.sizeDesc = "Normalement, la taille peut être définie en tirant sur l'ancre. Si vous avez besoin d'une taille bien précise, vous pouvez utiliser ce slider ou taper la valeur dans la boîte de saisie."
L.fontSizeDesc = "Ajustez la taille de la police à l'aide de ce curseur, ou tapez la valeur dans la saisie ce qui permet d'aller jusqu'à 200."
L.disabled = "Désactivé"
L.disableDesc = "Vous allez désactiver la fonctionnalité '%s', ce qui n'est |cffff4411pas recommandé|r.\n\nÊtes-vous sûr de vouloir faire cela ?"
L.keybinding = "Raccourci clavier"
L.dragToResize = "Tirer pour redimensionner"

-- Anchor Points
L.UP = "Au-dessus"
L.DOWN = "En-dessous"
L.TOP = "En haut"
L.RIGHT = "Droite"
L.BOTTOM = "En bas"
L.LEFT = "Gauche"
L.TOPRIGHT = "En haut à droite"
L.TOPLEFT = "En haut à gauche"
L.BOTTOMRIGHT = "En bas à droite"
L.BOTTOMLEFT = "En bas à gauche"
L.CENTER = "Centre"
L.customAnchorPoint = "Avancé : point d'ancrage personnalisé"
L.sourcePoint = "Point source"
L.destinationPoint = "Point destination"

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "Ressource alternative"
L.altPowerDesc = "L'affichage de la Ressource alternative ne s'effectuera que sur les boss qui ajoutent une ressource alternative aux joueurs, ce qui est très rare. L'affichage indique la quantité de 'Ressource alternative' que vous et votre groupe possédez, sous forme de liste. Pour déplacer l'affichage, veuillez utiliser le bouton de test ci-dessous."
L.toggleDisplayPrint = "L'affichage sera présent la prochaine fois. Pour le désactiver complètement pour cette rencontre, vous devez le décocher dans les options de la rencontre."
L.disabledDisplayDesc = "Désactive l'affichage pour tous les modules qui l'utilisent."
L.resetAltPowerDesc = "Réinitialise toutes les options relatives à la ressource alternative, y compris la position de l'ancre."
L.test = "Test"
L.altPowerTestDesc = "Affiche la fenêtre de 'Ressource alternative', vous permettant de la déplacer, et de simuler les changements de ressource que vous verrez dans une rencontre de boss."
L.yourPowerBar = "Votre barre de puissance"
L.barColor = "Couleur de la barre"
L.barTextColor = "Couleur du texte de la barre"
L.additionalWidth = "Longeur additionnelle"
L.additionalHeight = "Hauteur additionnelle"
L.additionalSizeDesc = "Ajoutez de la taille à l'affichage standard à l'aide de ce curseur, ou tapez la valeur dans la saisie ce qui permet d'aller jusqu'à 100."
L.yourPowerTest = "Votre ressource : %d" -- Your Power: 42
L.yourAltPower = "Votre %s : %d" -- e.g. Your Corruption: 42
L.player = "Joueur %d" -- Player 7
L.disableAltPowerDesc = "Désactive l'affichage de la ressource alternative de manière globale ; elle ne sera jamais affichée sur les rencontres de boss."

-----------------------------------------------------------------------
-- AutoReply.lua
--

L.autoReply = "Répondeur auto."
L.autoReplyDesc = "Répond automatiquement aux chuchotements quand vous êtes dans une rencontre de boss."
L.responseType = "Type de réponse"
L.autoReplyFinalReply = "Chuchoter également à la fin du combat"
L.guildAndFriends = "Guilde & Amis"
L.everyoneElse = "Tout le reste"

L.autoReplyBasic = "Je suis occupé à combattre un boss."
L.autoReplyNormal = "Je suis occupé à combattre '%s'."
L.autoReplyAdvanced = "Je suis occupé à combattre '%s' (%s). %d/%d joueurs en vie."
L.autoReplyExtreme = "Je suis occupé à combattre '%s' (%s). %d/%d joueurs en vie : %s"

L.autoReplyLeftCombatBasic = "Je ne suis plus en combat avec un boss."
L.autoReplyLeftCombatNormalWin = "J'ai terrassé '%s'."
L.autoReplyLeftCombatNormalWipe = "J'ai perdu face à '%s'."
L.autoReplyLeftCombatAdvancedWin = "J'ai terrassé '%s' avec %d/%d joueurs en vie."
L.autoReplyLeftCombatAdvancedWipe = "J'ai perdu face à '%s' : %s"

-----------------------------------------------------------------------
-- Bars.lua
--

L.bars = "Barres"
L.style = "Style"
L.bigWigsBarStyleName_Default = "Défaut"
L.resetBarsDesc = "Réinitialise toutes les options relatives aux barres, y compris la position des ancres des barres."
L.testBarsBtn = "Créer une barre de test"
L.testBarsBtn_desc = "Créée une barre pour que vous puissiez tester vos paramètres d'affichage actuels."

L.toggleAnchorsBtnShow = "Afficher les ancres"
L.toggleAnchorsBtnHide = "Cacher les ancres"
L.toggleAnchorsBtnHide_desc = "Cacher les ancres pour verrouiller les positions."
L.toggleBarsAnchorsBtnShow_desc = "Afficher les ancres pour permettre de déplacer les barres."

L.emphasizeAt = "Mettre en évidence à... (secondes)"
L.growingUpwards = "Ajouter vers le haut"
L.growingUpwardsDesc = "Permute le sens d'ajout des éléments par rapport à l'ancre entre vers le haut et vers le bas."
L.texture = "Texture"
L.emphasize = L.EMPHASIZE
L.emphasizeMultiplier = "Multiplicateur de taille"
L.emphasizeMultiplierDesc = "Si vous désactivez le déplacement des barres vers l'ancre de mise en évidence, cette option décidera la taille des barres mises en évidence en multipliant la taille des barres normales."

L.enable = "Activer"
L.move = "Déplacer"
L.moveDesc = "Déplace les barres mises en évidence vers l'ancre de mise en évidence. Si cette option est désactivée, les barres mises en évidence changeront simplement d'échelle et de couleur."
L.emphasizedBars = "Barres en évidence"
L.align = "Alignement"
L.alignText = "Alignement du texte"
L.alignTime = "Alignement du temps"
L.time = "Temps"
L.timeDesc = "Affiche ou non le temps restant sur les barres."
L.textDesc = "Affiche ou non le texte des barres."
L.icon = "Icône"
L.iconDesc = "Affiche ou non les icônes des barres."
L.iconPosition = "Position de l'icône"
L.iconPositionDesc = "Définit où l'icône est positionnée sur la barre."
L.font = "Police d'écriture"
L.restart = "Relancer"
L.restartDesc = "Relance les barres mises en évidence afin qu'elles commencent du début."
L.fill = "Remplir"
L.fillDesc = "Remplit les barres au lieu de les vider."
L.spacing = "Espacement"
L.spacingDesc = "Modifie l'espacement entre chaque barre."
L.visibleBarLimit = "Limite de barres visibles"
L.visibleBarLimitDesc = "Définit le nombre limite de barres qui sont visibles au même moment."

L.localTimer = "Local"
L.timerFinished = "%s : Minuteur [%s] terminé."
L.customBarStarted = "Barre perso '%s' lancée par l'utilisateur de %s %s."
L.sendCustomBar = "Envoi d'une barre perso '%s' aux utilisateurs de BigWigs et DBM."

L.requiresLeadOrAssist = "Cette fonction nécessite d'être le chef du raid ou un de ses assistants."
L.encounterRestricted = "Cette fonction ne peut pas être utilisée pendant une rencontre."
L.wrongCustomBarFormat = "Format incorrect. Un exemple correct est le suivant : /raidbar 20 texte"
L.wrongTime = "Durée spécifiée incorrecte. <durée> peut être exprimée soit avec un nombre en secondes, avec une paire M:S ou avec Mm. Par exemple 5, 1:20 ou 2m."

L.wrongBreakFormat = "Doit être compris entre 1 et 60 minutes. Un exemple correct est le suivant : /break 5"
L.sendBreak = "Envoi d'un temps de pause aux utilisateurs de BigWigs et DBM."
L.breakStarted = "Temps de pause lancé par %2$s (%1$s)."
L.breakStopped = "Temps de pause annulé par %s."
L.breakBar = "Temps de pause"
L.breakMinutes = "Fin de la pause dans %d |4minute:minutes; !"
L.breakSeconds = "Fin de la pause dans %d |4seconde:secondes; !"
L.breakFinished = "Le temps de pause est terminé !"

-----------------------------------------------------------------------
-- BossBlock.lua
--

L.bossBlock = "Bloquages"
L.bossBlockDesc = "Configure les divers éléments que vous pouvez bloquer durant une rencontre de boss.\n\n"
L.bossBlockAudioDesc = "Configure l'audio à couper lors d'une rencontre de boss.\n\nAny option here that is |cff808080greyed out|r has been disabled in WoW's sound options.\n\n"
L.movieBlocked = "Vous avez déjà vu cette cinématique, elle ne sera pas affichée."
L.blockEmotes = "Bloquer les émotes du centre de l'écran"
L.blockEmotesDesc = "Certains boss affichent des émotes pour certaines techniques, des messages qui sont bien trop longs et descriptifs. Nous essayons de produire des messages plus courts et appropriés qui n'interfèrent pas avec votre expérience de jeu et qui ne vous disent pas spécifiquement ce qu'il faut faire.\n\nVeuillez noter que les émotes des boss seront toujours visibles dans la fenêtre de discussion au cas où vous désireriez les lire."
L.blockMovies = "Bloquer les cinématiques déjà vues"
L.blockMoviesDesc = "Les cinématiques des rencontres de boss ne seront autorisées à être jouées qu'une seule fois (afin que vous puissiez les voir toutes au moins une fois) et seront ensuite bloquées."
L.blockFollowerMission = "Bloquer les popups des sujets"
L.blockFollowerMissionDesc = "Les popups des sujets s'affichent de temps en temps, principalement quand un sujet a terminé une mission.\n\nCes popups pouvant cacher des éléments critiques de votre interface pendant les rencontres de boss, nous vous recommandons de les bloquer."
L.blockGuildChallenge = "Bloquer les popups de défi de guilde"
L.blockGuildChallengeDesc = "Les popups de défi de guilde s'affichent de temps en temps, principalement quand un groupe de votre guilde termine un donjon héroïque ou un donjon en mode défi.\n\nCes popups pouvant cacher des éléments critiques de votre interface pendant les rencontres de boss, nous vous recommandons de les bloquer."
L.blockSpellErrors = "Bloquer les messages de sorts échoués"
L.blockSpellErrorsDesc = "Les messages tels que \"Le sort n'est pas encore utilisable\" qui s'affichent en haut de l'écran seront bloqués."
L.blockZoneChanges = "Bloquer les messages de changement de zone"
L.blockZoneChangesDesc = "Les messages qui s'affichent au milieu-centre de votre écran quand vous changez de zone tels que '|cFF33FF99Stormwind|r' ou '|cFF33FF99Orgrimmar|r' seront bloqués."
L.audio = "Audio"
L.music = "Musique"
L.ambience = "Ambiance"
L.sfx = "Effets sonores"
L.errorSpeech = "Mess. vocaux d'erreur"
L.disableMusic = "Couper la musique (recommandé)"
L.disableAmbience = "Couper les sons ambiants (recommandé)"
L.disableSfx = "Couper les effets sonores (non recommandé)"
L.disableErrorSpeech = "Couper les messages vocaux d'erreur (recommandé)"
L.disableAudioDesc = "L'option '%s' des options de Son de WoW sera désactivé, et ensuite réactivé une fois que la rencontre de boss est terminée. Cela peut vous aider à vous concentrer sur les sons d'alerte de BigWigs."
L.blockTooltipQuests = "Bloquer les objectifs de quête dans la bulle d'aide"
L.blockTooltipQuestsDesc = "Quand vous devez tuer un boss pour une quête, cela sera affiché sous la forme '0/1 terminé' dans la bulle d'aide quand vous survolez le boss avec votre souris. Cela sera caché lors du combat face à ce boss pour éviter que sa bulle d'aide ne devienne trop grande."
L.blockObjectiveTracker = "Cacher le suivi des quêtes"
L.blockObjectiveTrackerDesc = "Le suivi des objectifs de quêtes sera caché durant les rencontres de boss pour libérer de la place sur l'écran.\n\nCela ne sera PAS le cas dans les donjons Mythique+ ou si vous suivez un haut fait."

L.blockTalkingHead = "Cacher la boîte de dialogue PNJ 'Talking Head'"
L.blockTalkingHeadDesc = "Le 'Talking Head' est une boîte de dialogue contenant une tête de PNJ et du dialogue au milieu-bas de votre écran qui |cffff4411parfois|r s'affiche quand un PNJ parle.\n\nVous pouvez choisir dans quels types d'instances cette boîte ne sera pas affichée.\n\n|cFF33FF99Attention :|r\n 1) Cette fonctionnalité permet toujours à la voix du PNJ d'être jouée afin que vous puissiez l'entendre.\n 2) Par sécurité, seules certaines boîtes de dialogue seront bloquées. Les boîtes de dialogue spéciales ou uniques, comme celles des quêtes non répétables, ne seront pas bloquées."
L.blockTalkingHeadDungeons = "Donjons normaux & héroïques"
L.blockTalkingHeadMythics = "Donjons mythiques & mythiques+"
L.blockTalkingHeadRaids = "Raids"
L.blockTalkingHeadTimewalking = "Marcheurs du temps (donjons & raids)"
L.blockTalkingHeadScenarios = "Scénarios"

L.redirectPopups = "Redirige les popups vers les messages BigWigs"
L.redirectPopupsDesc = "Les bannières popup au centre de votre écran, telles que la bannière '|cFF33FF99Emplacement de chambre forte débloqué|r' sera plutôt affichée en tant que message BigWigs. Ces popups sont parfois larges, restent affichées longtemps et vous empêchent de cliquer à travers."
L.redirectPopupsColor = "Couleur du message redirigé"
L.blockDungeonPopups = "Bloque les popups de donjons"
L.blockDungeonPopupsDesc = "Les popups qui s'affichent lorsque vous entrez dans un donjon contiennent parfois beaucoup de texte. Activer cette option désactivera complètement ces messages."
L.itemLevel = "Niveau d'objet %d"
L.newRespawnPoint = "Nouveau point de réapparition"

L.userNotifySfx = "Les effets sonores étaient désactivés par BossBlock, la réactivation a été forcée."
L.userNotifyMusic = "La musique était désactivée par BossBlock, la réactivation a été forcée."
L.userNotifyAmbience = "Les sons d'ambiance étaient désactivés par BossBlock, la réactivation a été forcée."
L.userNotifyErrorSpeech = "Les messsages d'erreur vocaux étaient désactivés par BossBlock, la réactivation a été forcée."

L.subzone_grand_bazaar = "Le Grand bazar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "Port de Zandalar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_eastern_transept = "Transept est" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

L.colors = "Couleurs"

L.text = "Texte"
L.textShadow = "Ombre du texte"
L.expiring_normal = "Normal"
L.emphasized = "En évidence"

L.resetColorsDesc = "Réinitialise les couleurs ci-dessus à leurs valeurs par défaut."
L.resetAllColorsDesc = "Si vous avez des couleurs personnalisées dans les paramètres des rencontres de boss, ce bouton les réinitialisera TOUTES et les couleurs définies ici seront utilisées à la place."

L.red = "Rouge"
L.redDesc = "Alertes générales des rencontres."
L.blue = "Bleu"
L.blueDesc = "Alertes concernant ce qui vous affecte directement et négativement, comme des affaiblissements sur vous."
L.orange = "Orange"
L.yellow = "Jaune"
L.green = "Vert"
L.greenDesc = "Alertes concernant ce qui vous affecte directement et positivement, comme le retrait d'un affaiblissement qui vous affecte."
L.cyan = "Cyan"
L.cyanDesc = "Alertes indiquant le changement de statut d'une rencontre, comme le passage à une nouvelle phase."
L.purple = "Violet"
L.purpleDesc = "Alertes des techniques spécifiques aux tanks, comme le cumul d'un affaiblissement tank."

-----------------------------------------------------------------------
-- Countdown.lua
--

L.textCountdown = "Texte compte à rebours"
L.textCountdownDesc = "Affiche un compteur visuel lors des comptes à rebours."
L.countdownColor = "Couleur compte à rebours"
L.countdownVoice = "Voix du compte à rebours"
L.countdownTest = "Test compte à rebours"
L.countdownAt = "Compte à rebours à... (secondes)"
L.countdownAt_desc = "Choisissez combien de temps il doit rester sur une technique de boss (en secondes) quand le compte à rebours commence."
L.countdown = "Compte à rebours"
L.countdownDesc = "La fonctionnalité de compte à rebours consiste en un compte à rebours audio parlé et un compte à rebours texte visuel. Elle est rarement activée par défaut, mais vous pouvez l'activer pour n'importe quelle technique de boss en vous rendant dans les paramètres spécifiques de la rencontre de boss."
L.countdownAudioHeader = "Compte à rebours audio parlé"
L.countdownTextHeader = "Compte à rebours texte visuel"
L.resetCountdownDesc = "Réinitialise tous les paramètres des comptes à rebours ci-dessus à leurs valeurs par défaut."
L.resetAllCountdownDesc = "Si vous avez sélectionné des voix de compte à rebours personnalisés dans les paramètres de n'importe quel rencontre de boss, ce bouton va TOUS les réinitialiser et réinitialiser tous les paramètres ci-dessus à leurs valeurs par défaut."

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infobox_short = "Boîte d'infos"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Transmet la sortie de cet addon via l'affichage des messages de BigWigs. Cet affichage supporte les icônes, les couleurs et peut afficher jusqu'à 4 messages à l'écran en même temps. Les messages récemment insérés grandiront et reviendront rapidement à leur taille initiale afin de bien capter l'attention du joueur."
L.emphasizedSinkDescription = "Transmet la sortie de cet addon via l'affichage des messages mis en évidence de BigWigs. Cet affichage supporte le texte et les couleurs, et ne peut afficher qu'un message à la fois."
L.resetMessagesDesc = "Réinitialise toutes les options relatives aux messages, y compris la position des ancres des messages."
L.toggleMessagesAnchorsBtnShow_desc = "Afficher les ancres pour permettre de déplacer les messages."

L.testMessagesBtn = "Créer un message test"
L.testMessagesBtn_desc = "Créer un message pour vous, afin de tester les paramètres d'affichage actuels."

L.bwEmphasized = "BigWigs en évidence"
L.messages = "Messages"
L.emphasizedMessages = "Messages en évidence"
L.emphasizedDesc = "Le principe d'un message en évidence est d'attirer votre attention en affichant un large message au milieu de votre écran. Il est rarement activé par défaut, mais vous pouvez l'activer pour n'importe quelle technique de boss en vous rendant dans les paramètres spécifiques de la rencontre de boss."
L.uppercase = "MAJUSCULE"
L.uppercaseDesc = "Tous les messages mis en évidence seront convertis en MAJUSCULES."

L.useIcons = "Utiliser les icônes"
L.useIconsDesc = "Affiche les icônes à côté des messages."
L.classColors = "Couleurs de classe"
L.classColorsDesc = "Les messages comportent parfois des noms de joueurs. L'activation de cette option colorera ces noms selon la classe."
L.chatFrameMessages = "Messages de la fenêtre de discussion"
L.chatFrameMessagesDesc = "Affiche tous les messages de BigWigs dans la fenêtre de discussion par défaut, en plus de son affichage normal."

L.fontSize = "Taille de la police"
L.none = "Aucun"
L.thin = "Épais"
L.thick = "Mince"
L.outline = "Contour"
L.monochrome = "Monochrome"
L.monochromeDesc = "Active ou non le marqueur monochrome, enlevant tout lissage des bords de la police d'écriture."
L.fontColor = "Couleur de police"

L.displayTime = "Durée d'affichage"
L.displayTimeDesc = "Définit pendant combien de temps un message doit rester affiché (en secondes)."
L.fadeTime = "Durée d'estompe"
L.fadeTimeDesc = "Définit pendant combien de temps un message doit s'estomper (en secondes)."

-----------------------------------------------------------------------
-- Nameplates.lua
--

L.nameplates = "Barres d'infos"
L.testNameplateIconBtn = "Affiche l'icône de test"
L.testNameplateIconBtn_desc = "Créé une icône afin de pouvoir tester vos paramètres d'affichage actuels avec la barre d'infos de votre cible."
L.testNameplateTextBtn = "Affiche le texte de test"
L.testNameplateTextBtn_desc = "Créé un texte afin de pouvoir tester vos paramètres de texte actuels avec la barre d'infos de votre cible."
L.stopTestNameplateBtn = "Arrêter les tests"
L.stopTestNameplateBtn_desc = "Arrête les tests d'icône et de texte sur vos barres d'infos."
L.noNameplateTestTarget = "Vous devez avoir une cible hostile sélectionnée qui est attaquable afin de tester la fonctionnalité de barre d'infos."
L.anchoring = "Ancrage"
L.growStartPosition = "Position de départ"
L.growStartPositionDesc = "La position de départ pour la première icône."
L.growDirection = "Direction"
L.growDirectionDesc = "La direction dans laquelle les icônes se développeront depuis la position de départ."
L.iconSpacingDesc = "Change l'espacement entre chaque icône."
L.nameplateIconSettings = "Paramètrage des icônes"
L.keepAspectRatio = "Conserver les proportions"
L.keepAspectRatioDesc = "Conserve les proportions des icônes 1:1 au lieu de l'étirer afin de convenir à la taille du cadre."
L.iconColor = "Couleur de l'icône"
L.iconColorDesc = "Change la couleur de la texture de l'icône."
L.desaturate = "Désaturer"
L.desaturateDesc = "Désature la texture de l'icône."
L.zoom = "Zoom"
L.zoomDesc = "Zoom sur la texture de l'icône."
L.showBorder = "Affiche la bordure"
L.showBorderDesc = "Affiche une bordure autour de l'icône."
L.borderColor = "Couleur de la bordure"
L.borderSize = "Taille de la bordure"
L.showNumbers = "Affiche les nombres"
L.showNumbersDesc = "Affiche les nombres dans l'icône."
L.cooldown = "Temps de recharge"
L.showCooldownSwipe = "Affiche le balayage"
L.showCooldownSwipeDesc = "Affiche le balayage sur l'icône lorsque le temps de recharge est actif."
L.showCooldownEdge = "Affiche le bord du balayage"
L.showCooldownEdgeDesc = "Affiche une barre sur le bord du balayage lorsque le temps de recharge est actif."
L.inverse = "Inverser"
L.inverseSwipeDesc = "Inverse les animations du temps de recharge."
L.glow = "Surbrillance"
L.enableExpireGlow = "Active la surbrillance d'expiration"
L.enableExpireGlowDesc = "Affiche la surbrillance autour de l'icône lorsque le temps de recharge a expiré."
L.glowColor = "Couleur de la surbrillance"
L.glowType = "Type de surbrillance"
L.glowTypeDesc = "Change le type de surbrillance qui est montré autour de l'icône."
L.resetNameplateIconsDesc = "Réinitialise toutes les options liées aux icônes des barres d'infos."
L.nameplateTextSettings = "Paramètres de texte"
L.fixate_test = "Fixe Test" -- Text that displays to test on the frame
L.resetNameplateTextDesc = "Réinitialise toutes les options liées au texte des barres d'infos."
L.glowAt = "Commencer la surbrillance (secondes)"
L.glowAt_desc = "Choisissez combien il doit rester de secondes sur le temps de recharge afin d'activer la surbrillance."
L.headerIconSizeTarget = "Taille d'icône de votre cible actuelle"
L.headerIconSizeOthers = "Taille d'icône de toutes les autres cibles"
L.headerIconPositionTarget = "Position de l'icône de votre cible actuelle"
L.headerIconPositionOthers = "Position de l'icône de toutes les autres cibles"

-- Glow types as part of LibCustomGlow
L.pixelGlow = "Surbrillance discontinue"
L.autocastGlow = "Surbrillance de points"
L.buttonGlow = "Surbrillance du bouton"
L.procGlow = "Surbrillance de proc"
L.speed = "Vitesse"
L.animation_speed_desc = "La vitesse à laquelle l'animation de surbrillance joue."
L.lines = "Lignes"
L.lines_glow_desc = "Le nombre de lignes dans l'animation de surbrillance."
L.intensity = "Intensité"
L.intensity_glow_desc = "L'intensité de l'effet de surbrillance, une valeur plus élevée donne plus d'étincelles."
L.length = "Longueur"
L.length_glow_desc = "La longueur des lignes de l'animation de surbrillance."
L.thickness = "Épaisseur"
L.thickness_glow_desc = "L'épaisseur des lignes de l'animation de surbrillance."
L.scale = "Échelle"
L.scale_glow_desc = "L'échelle des étincelles de l'animation."
L.startAnimation = "Start Animation"
L.startAnimation_glow_desc = "Cette surbrillance a une animation de départ, cela activera / désactivera cette animation."

-----------------------------------------------------------------------
-- Proximity.lua
--

L.customRange = "Indicateur perso. de portée"
L.proximityTitle = "%d m / %d |4joueur:joueurs;"
L.proximity_name = "Proximité"
L.soundDelay = "Délai du son"
L.soundDelayDesc = "Spécifie combien de temps BigWigs doit attendre entre chaque répétition du son indiquant qu'au moins une personne est trop proche de vous."

L.resetProximityDesc = "Réinitialise toutes les options relatives à la portée, y compris la position de l'ancre."

L.close = "Fermer"
L.closeProximityDesc = "Ferme l'affichage de proximité.\n\nPour le désactiver complètement, rendez-vous dans les options du boss et décochez 'Proximité'."
L.lock = "Verrouiller"
L.lockDesc = "Verrouille l'affichage à sa place actuelle, empêchant tout déplacement ou redimensionnement."
L.title = "Titre"
L.titleDesc = "Affiche ou non le titre."
L.background = "Arrière-plan"
L.backgroundDesc = "Affiche ou non l'arrière-plan."
L.toggleSound = "Son"
L.toggleSoundDesc = "Fait ou non bipper la fenêtre de proximité quand vous êtes trop près d'un autre joueur."
L.soundButton = "Bouton du son"
L.soundButtonDesc = "Affiche ou non le bouton du son."
L.closeButton = "Bouton de fermeture"
L.closeButtonDesc = "Affiche ou non le bouton de fermeture."
L.showHide = "Afficher/cacher"
L.abilityName = "Nom de la technique"
L.abilityNameDesc = "Affiche ou non le nom de la technique au dessus de la fenêtre."
L.tooltip = "Bulle d'aide"
L.tooltipDesc = "Affiche ou non la bulle d'aide du sort si l'affichage de proximité est actuellement directement lié avec une technique de rencontre de boss."

-----------------------------------------------------------------------
-- Pull.lua
--

L.countdownType = "Type de compte à rebours"
L.combatLog = "Enregistrement auto. des combats"
L.combatLogDesc = "Lance automatiquement l'enregistrement du combat quand un délai de pull est lancé et l'arrête quand la rencontre prend fin."

L.pull = "Pull"
L.engageSoundTitle = "Jouer un son quand une rencontre de boss débute"
L.pullStartedSoundTitle = "Jouer un son quand le délai de pull est lancé"
L.pullFinishedSoundTitle = "Jouer un son quand le délai de pull est terminé"
L.pullStartedBy = "Délai de pull commencé par %s."
L.pullStopped = "Délai de pull annulé par %s."
L.pullStoppedCombat = "Délai de pull annulé car vous êtes entré en combat."
L.pullIn = "Pull dans %d sec."
L.sendPull = "Envoi d'un signal de pull à votre groupe."
L.wrongPullFormat = "Durée de pull invalide. Un exemple corret est : /pull 5"
L.countdownBegins = "Début du compte à rebours"
L.countdownBegins_desc = "Choisissez combien de temps il doit rester sur le délai de pull (en secondes) pour que le compte à rebours commence."
L.pullExplainer = "\n|cFF33FF99/pull|r démarrera un timer de pull normal.\n|cFF33FF99/pull 7|r démarrera un timer de pull de 7 secondes, vous pouvez utiliser n'importe quel nombre.\nAutrement, vous pouvez aussi attribuer un raccourci clavier ci-dessous.\n\n"
L.pullKeybindingDesc = "Choisissez un raccourci clavier afinde lancer un pull."

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L.icons = "Icônes"
L.raidIconsDescription = "Certaines rencontres peuvent comporter des éléments tels que les techniques de type 'bombe' qui affectent un joueur spécifique, un joueur poursuivi ou bien encore un joueur spécifique important pour d'autres raisons. Vous pouvez personnaliser ici les icônes de raid qui seront utilisées pour marquer ces joueurs.\n\nSi une rencontre ne comporte qu'une technique qui requiert de marquer quelqu'un, seule l'icône primaire sera utilisée. Une icône ne sera jamais utilisée pour deux techniques différentes de la même rencontre, et chaque technique utilisera toujours la même icône la prochaine fois qu'elle se produira.\n\n|cffff4411Notez que si un joueur a déjà été marqué manuellement, BigWigs ne changera jamais son icône.|r"
L.primary = "Primaire"
L.primaryDesc = "La première icône de cible de raid qu'un script de rencontre doit utiliser."
L.secondary = "Secondaire"
L.secondaryDesc = "La seconde icône de cible de raid qu'un script de rencontre doit utiliser."

-----------------------------------------------------------------------
-- Sound.lua
--

L.Sounds = "Sons"
L.soundsDesc = "BigWigs utilise le canal son 'Principal' pour jouer ses sons. Si vous trouvez que ces sons sont trop discrets ou trop bruyants, ouvrez les paramètres de son de WoW et ajustez le curseur 'Principal' selon vos préférences.\n\nCi-dessous, vous pouvez configurer globalement les différents sons joués lors d'actions spécifiques, ou les mettre à 'Aucun' pour les désactiver. Si vous souhaitez changer uniquement le son d'une technique de boss spécifique, rendez-vous dans les paramètres de cette rencontre de boss.\n\n"
L.oldSounds = "Anciens sons"

L.Alarm = "Alarme"
L.Info = "Info"
L.Alert = "Alerte"
L.Long = "Long"
L.Warning = "Avertissement"
L.onyou = "Un sort, amélioration ou affaiblissement est sur vous"
L.underyou = "Vous devez bouger hors d'un sort qui se trouve en dessous de vous"
L.privateaura = "Lorsqu'une 'aura privée' est sur vous"

L.customSoundDesc = "Joue le son personnalisé sélectionné au lieu de celui fourni par le module."
L.resetSoundDesc = "Réinitialise les sons ci-dessous à leurs valeurs par défaut."
L.resetAllCustomSound = "Si vous avez des sons personnalisés pour certains paramètres des rencontres de boss, ce bouton les réinitialisera TOUS afin que les sons par défaut soient utilisés à la place."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossStatistics = "Statistiques des boss"
L.bossStatsDescription = "L'enregistrement des diverses statistiques concernant les boss, comme le nombre de fois que vous les avez vaincu, le nombre de fois qu'ils vous ont vaincu, la date de première victoire, ainsi que la victoire la plus rapide. Ces statistiques peuvent être visionnées sur l'écran de configuration de chaque boss, mais seront cachées pour les boss qui n'ont pas encore de statistiques enregistrées."
L.createTimeBar = "Afficher la barre 'Meilleur temps'"
L.bestTimeBar = "Meilleur temps"
L.healthPrint = "Vie : %s."
L.healthFormat = "%s (%.1f%%)"
L.chatMessages = "Messages de la fenêtre de discussion"
L.newFastestVictoryOption = "Victoire la plus rapide"
L.victoryOption = "Vous êtes victorieux"
L.defeatOption = "Vous êtes vaincus"
L.bossHealthOption = "Vie du boss"
L.bossVictoryPrint = "Vous avez vaincu '%s' après %s." -- You were victorious against 'BOSS_NAME' after COMBAT_DURATION.
L.bossDefeatPrint = "Vous avez été vaincu par '%s' après %s." -- You were defeated by 'BOSS_NAME' after COMBAT_DURATION.
L.newFastestVictoryPrint = "Nouvelle victoire la plus rapide : (-%s)" -- New fastest victory: (-COMBAT_DURATION)

-----------------------------------------------------------------------
-- Victory.lua
--

L.Victory = "Victoire"
L.victoryHeader = "Configure les actions qui doivent être effectuées quand vous remportez une rencontre de boss."
L.victorySound = "Jouer un son de victoire"
L.victoryMessages = "Affichage des messages de défaite des boss"
L.victoryMessageBigWigs = "Afficher le message BigWigs"
L.victoryMessageBigWigsDesc = "Le message BigWigs est un simple message \"le boss a été vaincu\"."
L.victoryMessageBlizzard = "Afficher le message Blizzard"
L.victoryMessageBlizzardDesc = "Le message Blizzard est une imposante animation \"le boss s'est fait terrasser\" au milieu de votre écran."
L.defeated = "%s a été vaincu(e)"

-----------------------------------------------------------------------
-- Wipe.lua
--

L.wipe = "Wipe"
L.wipeSoundTitle = "Joue un son quand vous wipez"
L.respawn = "Réapparition"
L.showRespawnBar = "Affiche la barre de réapparition"
L.showRespawnBarDesc = "Affiche une barre après une défaite affichant le temps restant avant que le boss ne réapparaisse."
