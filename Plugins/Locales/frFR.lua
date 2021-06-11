local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "frFR")
if not L then return end

L.general = "Général"
L.comma = ", "

L.positionX = "Position X"
L.positionY = "Position Y"
L.positionExact = "Positionnement exact"
L.positionDesc = "Tapez dans la saisie ou déplacez le curseur si vous avez besoin d'un positionnement exact par rapport à l'ancre."
L.width = "Largeur"
L.height = "Hauteur"
L.sizeDesc = "Normalement, la taille peut être définie en tirant sur l'ancre. Si vous avez besoin d'une taille bien précise, vous pouvez utiliser ce slider ou taper la valeur dans la boîte de saisie, qui n'a pas de limite."
L.fontSizeDesc = "Ajustez la taille de la police à l'aide de ce curseur, ou tapez la valeur dans la saisie ce qui permet d'aller jusqu'à 200."
L.disableDesc = "Vous allez désactiver la fonctionnalité '%s', ce qui n'est |cffff4411pas recommandé|r.\n\nÊtes-vous sûr de vouloir faire cela ?"
L.transparency = "Transparence"

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "Ressource alternative"
L.altPowerDesc = "L'affichage de la Ressource alternative ne s'effectuera que sur les boss qui ajoutent une ressource alternative aux joueurs, ce qui est très rare. L'affichage indique la quantité de 'Ressource alternative' que vous et votre groupe possédez, sous forme de liste. Pour déplacer l'affichage, veuillez utiliser le bouton de test ci-dessous."
L.toggleDisplayPrint = "L'affichage sera présent la prochaine fois. Pour le désactiver complètement pour cette rencontre, vous devez le décocher dans les options de la rencontre."
L.disabled = "Désactivé"
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

L.nameplateBars = "Barres d'info des unités"
L.nameplateAutoWidth = "Même largeur que la barre d'info"
L.nameplateAutoWidthDesc = "Force la largeur des barres d'info à être de la même largeur que la barre parente."
L.nameplateOffsetY = "Décalage Y"
L.nameplateOffsetYDesc = "Décalage à partir du haut de la barre d'info pour les barres allant vers le haut, à partir du bas de la barre d'info pour les barres allant vers le bas."
L.nameplateAlphaDesc = "Contrôle à quel point les barres d'info des unités sont transparentes."

L.clickableBars = "Barres cliquables"
L.clickableBarsDesc = "Par défaut, les barres de BigWigs ignorent la souris. Vous pouvez ainsi cibler ou lancer des sorts de zone derrière elles, changer l'angle de la caméra, ... tandis que votre curseur survole les barres. |cffff4411Si vous activez ceci, tout cela ne sera plus d'application.|r Les barres intercepteront tout clic que vous effectuez sur elles.\n"
L.interceptMouseDesc = "Permet aux barres de recevoir les clics de la souris."
L.modifier = "Modificateur"
L.modifierDesc = "Maintenez enfoncée la touche modificatrice sélectionnée pour activer les actions des clics sur les barres."
L.modifierKey = "Seul. avec touche mod."
L.modifierKeyDesc = "Permet aux barres de ne pas réagir aux clics de la souris à moins que la touche modificatrice sélectionnée ne soit maintenue enfoncée, cas dans lequel les actions de la souris décrites ci-dessous seront disponibles."

L.temporaryCountdownDesc = "Active temporairement le compte à rebours sur la technique associée à cette barre."
L.report = "Rapport"
L.reportDesc = "Rapporte le statut des barres actuelles dans la discussion de groupe active : la discussion d'instance, de raid, de groupe ou juste le dire, selon ce qui est le plus approprié."
L.remove = "Enlever"
L.removeBarDesc = "Enlève temporairement cette barre."
L.removeOther = "Enlever les autres"
L.removeOtherBarDesc = "Enlève temporairement toutes les autres barres (mis à part celle-ci)."

L.emphasizeAt = "Mettre en évidence à... (secondes)"
L.growingUpwards = "Ajouter vers le haut"
L.growingUpwardsDesc = "Permute le sens d'ajout des éléments par rapport à l'ancre entre vers le haut et vers le bas."
L.texture = "Texture"
L.emphasize = "Mise en évidence"
L.emphasizeMultiplier = "Multiplicateur de taille"
L.emphasizeMultiplierDesc = "Si vous désactivez le déplacement des barres vers l'ancre de mise en évidence, cette option décidera la taille des barres mises en évidence en multipliant la taille des barres normales."

L.enable = "Activer"
L.move = "Déplacer"
L.moveDesc = "Déplace les barres mises en évidence vers l'ancre de mise en évidence. Si cette option est désactivée, les barres mises en évidence changeront simplement d'échelle et de couleur."
L.emphasizedBars = "Barres en évidence"
L.align = "Alignement"
L.alignText = "Alignement du texte"
L.alignTime = "Alignement du temps"
L.left = "Gauche"
L.center = "Centre"
L.right = "Droite"
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
L.breakMinutes = "Fin de la pause dans %d |4minute:minutes; !"
L.breakSeconds = "Fin de la pause dans %d |4seconde:secondes; !"
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

L.subzone_grand_bazaar = "Le Grand bazar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "Port de Zandalar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_eastern_transept = "Transept est" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

L.colors = "Couleurs"

L.text = "Texte"
L.textShadow = "Ombre du texte"
L.flash = "Flash"
L.normal = "Normal"
L.emphasized = "En évidence"

L.reset = "Réinitialiser"
L.resetDesc = "Réinitialise les couleurs ci-dessus à leurs valeurs par défaut."
L.resetAll = "Tout réinitialiser"
L.resetAllDesc = "Si vous avez des couleurs personnalisées dans les paramètres des rencontres de boss, ce bouton les réinitialisera TOUTES et les couleurs définies ici seront utilisées à la place."

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

L.infoBox = "Boîte d'infos"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Transmet la sortie de cet addon via l'affichage des messages de BigWigs. Cet affichage supporte les icônes, les couleurs et peut afficher jusqu'à 4 messages à l'écran en même temps. Les messages récemment insérés grandiront et reviendront rapidement à leur taille initiale afin de bien capter l'attention du joueur."
L.emphasizedSinkDescription = "Transmet la sortie de cet addon via l'affichage des messages mis en évidence de BigWigs. Cet affichage supporte le texte et les couleurs, et ne peut afficher qu'un message à la fois."
L.resetMessagesDesc = "Réinitialise toutes les options relatives aux messages, y compris la position des ancres des messages."

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
L.pullStarted = "Délai de pull lancé par l'utilisateur de %s %s."
L.pullStopped = "Délai de pull annulé par %s."
L.pullStoppedCombat = "Délai de pull annulé car vous êtes entré en combat."
L.pullIn = "Pull dans %d sec."
L.sendPull = "Envoi d'un délai de pull aux utilisateurs de BigWigs et DBM."
L.wrongPullFormat = "Doit être compris entre 1 et 60 secondes. Un exemple correct est le suivant : /pull 5"
L.countdownBegins = "Début du compte à rebours"
L.countdownBegins_desc = "Choisissez combien de temps il doit rester sur le délai de pull (en secondes) pour que le compte à rebours commence."

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

L.sound = "Son"

L.customSoundDesc = "Joue le son personnalisé sélectionné au lieu de celui fourni par le module."
L.resetSoundDesc = "Réinitialise les sons ci-dessous à leurs valeurs par défaut."
L.resetAllCustomSound = "Si vous avez des sons personnalisés pour certains paramètres des rencontres de boss, ce bouton les réinitialisera TOUS afin que les sons par défaut soient utilisés à la place."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossDefeatDurationPrint = "Défaite de '%s' au bout de %s."
L.bossWipeDurationPrint = "Wipe sur '%s' au bout de %s."
L.newBestTime = "Nouveau record !"
L.bossStatistics = "Statistiques des boss"
L.bossStatsDescription = "Enregistrement de diverses statitistiques relatives aux boss telles que le nombre de fois qu'un boss a été vaincu, le nombre de wipes, la durée totale du combat ou la victoire la plus rapide. Ces statistiques peuvent être visionnées sur l'écran de configuration de chaque boss, mais seront cachées pour les boss qui n'ont pas encore de statistiques enregistrées."
L.enableStats = "Activer les statistiques"
L.chatMessages = "Messages de la fenêtre de discussion"
L.printBestTimeOption = "Notif. de nv record"
L.printDefeatOption = "Durée (victoire)"
L.printWipeOption = "Durée (échec)"
L.countDefeats = "Compter les victoires"
L.countWipes = "Compter les échecs"
L.recordBestTime = "Se souvenir des meilleurs temps"
L.createTimeBar = "Afficher la barre 'Meilleur temps'"
L.bestTimeBar = "Meilleur temps"
L.printHealthOption = "Vie du boss"
L.healthPrint = "Vie : %s."
L.healthFormat = "%s (%.1f%%)"

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
