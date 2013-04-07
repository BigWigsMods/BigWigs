local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "frFR")
if not L then return end
-----------------------------------------------------------------------
-- Bars.lua
--

L["Style"] = "Style"
L.bigWigsBarStyleName_Default = "Défaut"

L["Clickable Bars"] = "Barres cliquables"
L.clickableBarsDesc = "Par défaut, les barres de Big Wigs ignorent la souris. Vous pouvez ainsi cibler ou lancer des sorts de zone derrière elles, changer l'angle de la caméra, ... tandis que votre curseur survole les barres. |cffff4411Si vous activez ceci, tout cela ne sera plus d'application.|r Les barres intercepteront tout clic que vous effectuez sur elles.\n"
L["Enables bars to receive mouse clicks."] = "Permet aux barres de recevoir les clics de la souris."
L["Modifier"] = "Modificateur"
L["Hold down the selected modifier key to enable click actions on the timer bars."] = "Maintenez enfoncée la touche modificatrice sélectionnée pour activer les actions des clics sur les barres."
L["Only with modifier key"] = "Seul. avec touche mod."
L["Allows bars to be click-through unless the specified modifier key is held down, at which point the mouse actions described below will be available."] = "Permet aux barres de ne pas réagir aux clics de la souris à moins que la touche modificatrice sélectionnée ne soit maintenue enfoncée, cas dans lequel les actions de la souris décrites ci-dessous seront disponibles."

L["Temporarily Super Emphasizes the bar and any messages associated with it for the duration."] = "Met temporairement en super mise en évidence la barre et ses messages associés pendant sa durée."
L["Report"] = "Rapport"
L["Reports the current bars status to the active group chat; either instance chat, raid, party or say, as appropriate."] = "Rapporte le statut des barres actuelles dans la discussion de groupe active : la discussion d'instance, de raid, de groupe ou juste le dire, selon ce qui est le plus approprié."
L["Remove"] = "Enlever"
L["Temporarily removes the bar and all associated messages."] = "Enlève temporairement la barre et les messages qui y sont associés."
L["Remove other"] = "Enlever les autres"
L["Temporarily removes all other bars (except this one) and associated messages."] = "Enlève temporairement toutes les autres barres et leurs messages associés."
L["Disable"] = "Désactiver"
L["Permanently disables the boss encounter ability option that spawned this bar."] = "Désactive l'option de la rencontre de boss qui a fait apparaître cette barre."

L["Emphasize at... (seconds)"] = "Mettre en évidence à... (secondes)"
L["Scale"] = "Échelle"
L["Grow upwards"] = "Ajouter vers le haut"
L["Toggle bars grow upwards/downwards from anchor."] = "Ajoute les nouvelles barres soit en haut de l'ancre, soit en bas de l'ancre."
L["Texture"] = "Texture"
L["Emphasize"] = "Mise en évidence"
L["Enable"] = "Activer"
L["Move"] = "Déplacer"
L.moveDesc = "Déplace les barres mises en évidence vers l'ancre de mise en évidence. Si cette option est désactivée, les barres mises en évidence changeront simplement d'échelle et de couleur."
L["Regular bars"] = "Barres normales"
L["Emphasized bars"] = "Barres en évidence"
L["Align"] = "Alignement"
L["Left"] = "Gauche"
L["Center"] = "Centre"
L["Right"] = "Droite"
L["Time"] = "Temps"
L["Whether to show or hide the time left on the bars."] = "Affiche ou non le temps restant sur les barres."
L["Icon"] = "Icône"
L["Shows or hides the bar icons."] = "Affiche ou non les icônes des barres."
L["Font"] = "Police d'écriture"
L["Restart"] = "Relancer"
L["Restarts emphasized bars so they start from the beginning and count from 10."] = "Relance les barres mises en évidence afin qu'elles commencent du début."
L["Fill"] = "Remplir"
L["Fills the bars up instead of draining them."] = "Remplit les barres au lieu de les vider."

L["Local"] = "Local"
L["%s: Timer [%s] finished."] = "%s : Minuteur [%s] terminé."
L["Custom bar '%s' started by %s user '%s'."] = "Barre perso '%s' lancée par l'utilisateur de %s '%s'."

L["Pull"] = "Pull"
L["Pulling!"] = "Pull !"
L["Pull timer started by %s user '%s'."] = "Délai de pull lancé par l'utilisateur de %s '%s'."
L["Pull in %d sec"] = "Pull dans %d sec."
L["Sending a pull timer to Big Wigs and DBM users."] = "Envoi d'un délai de pull aux utilisateurs de Big Wigs et DBM."
L["Sending custom bar '%s' to Big Wigs and DBM users."] = "Envoi d'une barre perso '%s' aux utilisateurs de Big Wigs et DBM."
L["This function requires raid leader or raid assist."] = "Cette fonction nécessite d'être le chef du raid ou un de ses assistants."
L["Must be between 1 and 60. A correct example is: /pull 5"] = "Doit être compris entre 1 et 60. Un exemple correct est le suivant : /pull 5"
L["Incorrect format. A correct example is: /raidbar 20 text"] = "Format incorrect. Un exemple correct est le suivant : /raidbar 20 texte"
L["Invalid time specified. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Durée spécifiée incorrecte. <durée> peut être exprimée soit avec un nombre en secondes, avec une paire M:S ou avec Mm. Par exemple 5, 1:20 ou 2m."
L["This function can't be used during an encounter."] = "Cette fonction ne peut pas être utilisée pendant une rencontre."

L.customBarSlashPrint = "This functionality has been renamed. Use /raidbar to send a custom bar to your raid or /localbar for a bar only you can see."

-----------------------------------------------------------------------
-- Colors.lua
--

L.Colors = "Couleurs"

L.Messages = "Messages"
L.Bars = "Barres"
L.Background = "Fond"
L.Text = "Texte"
--L.TextShadow = "Text Shadow"
L.Flash = "Flash"
L.Normal = "Normal"
L.Emphasized = "En évidence"

L.Reset = "Réinit."
L["Resets the above colors to their defaults."] = "Réinitialise les couleurs ci-dessus à leurs valeurs par défaut."
L["Reset all"] = "Tt réinit."
L["If you've customized colors for any boss encounter settings, this button will reset ALL of them so the colors defined here will be used instead."] = "Si vous avez des couleurs personnalisées dans les paramètres des rencontres de boss, ce bouton les réinitialisera TOUTES et les couleurs définies ici seront utilisées à la place."

L.Important = "Important"
L.Personal = "Personnel"
L.Urgent = "Urgent"
L.Attention = "Attention"
L.Positive = "Positif"
L.Neutral = "Neutre"

-----------------------------------------------------------------------
-- Emphasize.lua
--

L["Super Emphasize"] = "Super mise en évidence"
L.superEmphasizeDesc = "Ce module met fortement en évidence les barres ou messages relatifs à une technique de rencontre de boss.\n\nVous pouvez définir ici exactement ce qui doit arriver quand vous cochez une option de super mise en évidence dans la section avancée d'une technique de rencontre de boss.\n\n|cffff4411Notez que la super mise en évidence est désactivée par défaut pour toutes les techniques.|r\n"
L["UPPERCASE"] = "MAJUSCULE"
L["Uppercases all messages related to a super emphasized option."] = "Met entièrement en majuscules tous les messages relatifs à une option à mettre fortement en évidence."
L["Double size"] = "Taille double"
L["Doubles the size of super emphasized bars and messages."] = "Double la taille des barres et messages relatifs à une option à mettre fortement en évidence."
L["Countdown"] = "Compte à rebours"
L["If a related timer is longer than 5 seconds, a vocal and visual countdown will be added for the last 5 seconds. Imagine someone counting down \"5... 4... 3... 2... 1... COUNTDOWN!\" and big numbers in the middle of your screen."] = "Si un minuteur relatif à une option à mettre fortement en évidence est plus long que 5 secondes, un compte à rebours visuel et vocal sera ajouté pour les 5 dernières secondes. Imaginez quelqu'un décompter \"5... 4... 3... 2... 1... COUNTDOWN!\" et de gros chiffres au milieu de votre écran."

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Transmet la sortie de cet addon via l'affichage des messages de Big Wigs. Cet affichage supporte les icônes, les couleurs et peut afficher jusqu'à 4 messages à l'écran en même temps. Les messages récemment insérés grandiront et reviendront rapidement à leur taille initiale afin de bien capter l'attention du joueur."
L.emphasizedSinkDescription = "Transmet la sortie de cet addon via l'affichage des messages mis en évidence de Big Wigs. Cet affichage supporte le texte et les couleurs, et ne peut afficher qu'un message à la fois."
L.emphasizedCountdownSinkDescription = "Route output from this addon through the Big Wigs Emphasized Countdown message display. This display supports text and colors, and can only show one message at a time."

L["Big Wigs Emphasized"] = "Big Wigs en évidence"
L["Messages"] = "Messages"
L["Normal messages"] = "Messages normaux"
L["Emphasized messages"] = "Messages en évidence"
L["Output"] = "Sortie"
L["Emphasized countdown"] = "Compte à rebours en évidence"

L["Use colors"] = "Utiliser des couleurs"
L["Toggles white only messages ignoring coloring."] = "Utilise ou non des couleurs dans les messages à la place du blanc unique."

L["Use icons"] = "Utiliser les icônes"
L["Show icons next to messages, only works for Raid Warning."] = "Affiche les icônes à côté des messages. Ne fonctionne que sur l'Avertissement raid."

L["Class colors"] = "Couleurs de classe"
L["Colors player names in messages by their class."] = "Colore le nom des joueurs dans les messages selon leur classe."

L["Font size"] = "Taille de la police"
L["None"] = "Aucun"
L["Thin"] = "Épais"
L["Thick"] = "Mince"
L["Outline"] = "Contour"
L["Monochrome"] = "Monochrome"
L["Toggles the monochrome flag on all messages, removing any smoothing of the font edges."] = "Active ou non le marqueur monochrome sur tous les messages, enlevant tout lissage des bords de la police d'écriture."

L["Display time"] = "Durée d'affichage"
L["How long to display a message, in seconds"] = "Définit pendant combien de temps un message doit rester affiché (en secondes)."
L["Fade time"] = "Durée d'estompe"
L["How long to fade out a message, in seconds"] = "Définit pendant combien de temps un message doit s'estomper (en secondes)."
L["Font color"] = "Couleur de police"

-----------------------------------------------------------------------
-- Proximity.lua
--

L["Custom range indicator"] = "Indicateur perso. de portée"
L.proximityTitle = "%d m / %d |4joueur:joueurs;"
L["Proximity"] = "Proximité"
L["Sound"] = "Son"
L["Disabled"] = "Désactivé"
L["Disable the proximity display for all modules that use it."] = "Désactive l'affichage de proximité pour tous les modules l'utilisant."
L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = "L'affichage de proximité sera affiché la prochaine fois. Pour le désactiver complètement, rendez-vous dans les options du boss et décochez \"Proximité\"."
L["Sound delay"] = "Délai du son"
L["Specify how long Big Wigs should wait between repeating the specified sound when someone is too close to you."] = "Spécifie combien de temps Big Wigs doit attendre entre chaque répétition du son indiquant qu'au moins une personne est trop proche de vous."

L.proximity = "Affichage de proximité"
L.proximity_desc = "Affiche la fenêtre de proximité quand cela est approprié pour cette rencontre, indiquant la liste des joueurs qui se trouvent trop près de vous."

L["Close"] = "Fermer"
L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = "Ferme l'affichage de proximité.\nPour le désactiver complètement, rendez-vous dans les options du boss et décochez \"Proximité\"."
L["Lock"] = "Verrouiller"
L["Locks the display in place, preventing moving and resizing."] = "Verrouille l'affichage à sa place actuelle, empêchant tout déplacement ou redimensionnement."
L["Title"] = "Titre"
L["Shows or hides the title."] = "Affiche ou non le titre."
L["Background"] = "Arrière-plan"
L["Shows or hides the background."] = "Affiche ou non l'arrière-plan."
L["Toggle sound"] = "Son"
L["Toggle whether or not the proximity window should beep when you're too close to another player."] = "Fait ou non bipper la fenêtre de proximité quand vous êtes trop près d'un autre joueur."
L["Sound button"] = "Bouton du son"
L["Shows or hides the sound button."] = "Affiche ou non le bouton du son."
L["Close button"] = "Bouton de fermeture"
L["Shows or hides the close button."] = "Affiche ou non le bouton de fermeture."
L["Show/hide"] = "Afficher/cacher"
L["Ability name"] = "Nom de la technique"
L["Shows or hides the ability name above the window."] = "Affiche ou non le nom de la technique au dessus de la fenêtre."
L["Tooltip"] = "Bulle d'aide"
L["Shows or hides a spell tooltip if the Proximity display is currently tied directly to a boss encounter ability."] = "Affiche ou non la bulle d'aide du sort si l'affichage de proximité est actuellement directement lié avec une technique de rencontre de boss."

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L["Icons"] = "Icônes"

L.raidIconDescription = "Certaines rencontres peuvent comporter des éléments tels que les techniques de type 'bombe' qui affectent un joueur spécifique, un joueur poursuivi ou bien encore un joueur spécifique important pour d'autres raisons. Vous pouvez personnaliser ici les icônes de raid qui seront utilisées pour marquer ces joueurs.\n\nSi une rencontre ne comporte qu'une technique qui requiert de marquer quelqu'un, seule l'icône primaire sera utilisée. Une icône ne sera jamais utilisée pour deux techniques différentes de la même rencontre, et chaque technique utilisera toujours la même icône la prochaine fois qu'elle se produira.\n\n|cffff4411Notez que si un joueur a déjà été marqué manuellement, Big Wigs ne changera jamais son icône.|r"
L["Primary"] = "Primaire"
L["The first raid target icon that a encounter script should use."] = "La première icône de cible de raid qu'un script de rencontre doit utiliser."
L["Secondary"] = "Secondaire"
L["The second raid target icon that a encounter script should use."] = "La seconde icône de cible de raid qu'un script de rencontre doit utiliser."

L["Star"] = "Étoile"
L["Circle"] = "Cercle"
L["Diamond"] = "Diamant"
L["Triangle"] = "Triangle"
L["Moon"] = "Lune"
L["Square"] = "Carré"
L["Cross"] = "Croix"
L["Skull"] = "Crâne"
L["|cffff0000Disable|r"] = "|cffff0000Désactiver|r"

-----------------------------------------------------------------------
-- Sound.lua
--

L.soundDefaultDescription = "Si ceci est coché, Big Wigs utilisera uniquement le son de l'Avertissement raid de Blizzard pour les messages accompagnés d'un son. Notez que seuls certains messages des scripts de rencontre déclencheront une alerte sonore."

L.Sounds = "Sons"

L.Alarm = "Alarme"
L.Info = "Info"
L.Alert = "Alerte"
L.Long = "Long"
L.Warning = "Avertissement"
L.Victory = "Victoire"

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "Détermine le son à utiliser pour %q (Ctrl-clic sur un son pour avoir un aperçu)."
L["Default only"] = "Son par défaut uniquement"

L.customSoundDesc = "Joue le son personnalisé sélectionné au lieu de celui fourni par le module"
L.resetAllCustomSound = "Si vous avez des sons personnalisés pour certains paramètres des rencontres de boss, ce bouton les réinitialisera TOUS afin que les sons par défaut soient utilisés à la place."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossKillDurationPrint = "Défaite de '%s' au bout de %s."
L.bossWipeDurationPrint = "Wipe sur '%s' au bout de %s."
L.newBestKill = "Nouveau record !"
L.bossStatistics = "Statistiques des boss"
L.bossStatsDescription = "Enregistrement de diverses statitistiques relatives aux boss telles que le nombre de fois qu'un boss a été vaincu, le nombre de wipes, la durée totale du combat ou la victoire la plus rapide. Ces statistiques peuvent être visionnées sur l'écran de configuration de chaque boss, mais seront cachées pour les boss qui n'ont pas encore de statistiques enregistrées."
L.enableStats = "Activer les statistiques"
L.chatMessages = "Messages de la fenêtre de discussion"
L.printBestKillOption = "Notif. de nv record"
L.printKillOption = "Durée (victoire)"
L.printWipeOption = "Durée (échec)"
L.countKills = "Compter les victoires"
L.countWipes = "Compter les échecs"
L.recordBestKills = "Se souvenir des meilleurs temps"

