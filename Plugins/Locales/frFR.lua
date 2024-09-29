local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "frFR")
if not L then return end

L.general = "Général"
L.advanced = "Avancé"
L.comma = ", "

L.positionX = "Position X"
L.positionY = "Position Y"
L.positionExact = "Positionnement exact"
L.positionDesc = "Tapez dans la saisie ou déplacez le curseur si vous avez besoin d'un positionnement exact par rapport à l'ancre."
L.width = "Largeur"
L.height = "Hauteur"
L.sizeDesc = "Normalement, la taille peut être définie en tirant sur l'ancre. Si vous avez besoin d'une taille bien précise, vous pouvez utiliser ce slider ou taper la valeur dans la boîte de saisie."
L.fontSizeDesc = "Ajustez la taille de la police à l'aide de ce curseur, ou tapez la valeur dans la saisie ce qui permet d'aller jusqu'à 200."
L.disabled = "Désactivé"
L.disableDesc = "Vous allez désactiver la fonctionnalité '%s', ce qui n'est |cffff4411pas recommandé|r.\n\nÊtes-vous sûr de vouloir faire cela ?"

-- Anchor Points
--L.UP = "Up"
--L.DOWN = "Down"
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
L.autoScale = "Mise à l'échelle automatique"
L.autoScaleDesc = "Change automatiquement l'échelle par rapport à celle de la barre d'infos."
L.glowAt = "Commencer la surbrillance (secondes)"
L.glowAt_desc = "Choisissez combien il doit rester de secondes sur le temps de recharge afin d'activer la surbrillance."

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

L.sound = "Son"

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
L.bossVictoryPrint = "Vous êtes victorieux contre '%s' après %s." -- You were victorious against 'BOSS_NAME' after COMBAT_DURATION.
L.bossDefeatPrint = "Vous êtes battus par '%s' après %s." -- You were defeated by 'BOSS_NAME' after COMBAT_DURATION.
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
