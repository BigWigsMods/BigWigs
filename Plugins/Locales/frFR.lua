local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "frFR")
if not L then return end
-----------------------------------------------------------------------
-- Bars.lua
--

L["Clickable Bars"] = "Barres cliquables"
L.clickableBarsDesc = "Par défaut, les barres de Big Wigs ignorent la souris. Vous pouvez ainsi cibler ou lancer des sorts de zone derrière elles, changer l'angle de la caméra, etc. tandis que votre curseur survole les barres. |cffff4411Si vous activez ceci, tout cela ne fonctionnera plus.|r Les barres intercepteront tout clic que vous effectuez sur elles.\n"
L["Enables bars to receive mouse clicks."] = "Permet aux barres de recevoir les clics de la souris."

L["Temporarily Super Emphasizes the bar and any messages associated with it for the duration."] = "Met temporairement en super mise en évidence la barre et ses messages associés pendant sa durée."
L["Report"] = "Rapport"
L["Reports the current bars status to the active group chat; either battleground, raid, party or guild, as appropriate."] = "Rapporte le statut actuel des barres dans le canal de discussion de groupe actif."
L["Remove"] = "Enlever"
L["Temporarily removes the bar and all associated messages."] = "Enlève temporairement la barre et les messages qui y sont associés."
L["Remove other"] = "Enlever les autres"
L["Temporarily removes all other bars (except this one) and associated messages."] = "Enlève temporairement toutes les autres barres et leurs messages associés."
L["Disable"] = "Désactiver"
L["Permanently disables the boss encounter ability option that spawned this bar."] = "Désactive l'option de la rencontre de boss qui a fait apparaître cette barre."

L["Scale"] = "Échelle"
L["Grow upwards"] = "Ajouter vers le haut"
L["Toggle bars grow upwards/downwards from anchor."] = "Ajoute les nouvelles barres soit en haut de l'ancre, soit en bas de l'ancre."
L["Texture"] = "Texture"
L["Emphasize"] = "Mise en évidence"
L["Enable"] = "Activer"
L["Move"] = "Déplacer"
L["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."] = "Déplace les barres mises en évidence vers une ancre dédiée. Si cette option est désactivée, les barres mises en évidence vont simplement changer d'échelle et de couleur, et peut-être commencer à clignoter."
L["Flash"] = "Clignoter"
L["Flashes the background of emphasized bars, which could make it easier for you to spot them."] = "Fait clignoter l'arrière-plan des barres en évidence afin que vous puissiez mieux les voir."
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

L["Local"] = "Local"
L["%s: Timer [%s] finished."] = "%s : Minuteur [%s] terminé."
L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Durée invalide (|cffff0000%q|r) ou texte de barre manquant dans une barre personnalisée lancée par |cffd9d919%s|r. <durée> peut être soit un nombre en secondes, soit au format M:S, ou encore au format Mm. Par exemple : 5, 1:20 ou 2m."

-----------------------------------------------------------------------
-- Colors.lua
--

L["Colors"] = "Couleurs"

L["Messages"] = "Messages"
L["Bars"] = "Barres"
L["Background"] = "Fond"
L["Text"] = "Texte"
L["Flash and shake"] = "Flash et secousse"
L["Normal"] = "Normal"
L["Emphasized"] = "En évidence"

L["Reset"] = "Réinit."
L["Resets the above colors to their defaults."] = "Réinitialise les couleurs ci-dessus à leurs valeurs par défaut."
L["Reset all"] = "Tt réinit."
L["If you've customized colors for any boss encounter settings, this button will reset ALL of them so the colors defined here will be used instead."] = "Si vous avez des couleurs personnalisées dans les paramètres des rencontres de boss, ce bouton les réinitialisera TOUTES et les couleurs définies ici seront utilisées à la place."

L["Important"] = "Important"
L["Personal"] = "Personnel"
L["Urgent"] = "Urgent"
L["Attention"] = "Attention"
L["Positive"] = "Positif"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Transmet la sortie de cet addon via l'affichage des messages de Big Wigs. Cet affichage supporte les icônes, les couleurs et peut afficher jusqu'à 4 messages à l'écran en même temps. Les messages récemment insérés grandiront et reviendront rapidement à leur taille initiale afin de bien capter l'attention du joueur."
L.emphasizedSinkDescription = "Transmet la sortie de cet addon via l'affichage des messages mis en évidence de Big Wigs. Cet affichage supporte le texte et les couleurs, et ne peut afficher qu'un message à la fois."

L["Messages"] = "Messages"
L["Normal messages"] = "Messages normaux"
L["Emphasized messages"] = "Messages en évidence"
L["Output"] = "Sortie"

L["Use colors"] = "Utiliser des couleurs"
L["Toggles white only messages ignoring coloring."] = "Utilise ou non des couleurs dans les messages à la place du blanc unique."

L["Use icons"] = "Utiliser les icônes"
L["Show icons next to messages, only works for Raid Warning."] = "Affiche les icônes à côté des messages. Ne fonctionne que sur l'Avertissement raid."

L["Class colors"] = "Couleurs de classe"
L["Colors player names in messages by their class."] = "Colore le nom des joueurs dans les messages selon leur classe."

L["Chat frame"] = "Fenêtre de discussion"
L["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "Affiche tous les messages de BigWigs dans la fenêtre de discussion par défaut, en plus de son affichage normal."

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

L["Sounds"] = "Sons"

L["Alarm"] = "Alarme"
L["Info"] = "Info"
L["Alert"] = "Alerte"
L["Long"] = "Long"
L["Victory"] = "Victoire"

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "Détermine le son à utiliser pour %q (Ctrl-clic sur un son pour avoir un aperçu)."
L["Default only"] = "Son par défaut uniquement"

-----------------------------------------------------------------------
-- Proximity.lua
--

L["%d yards"] = "%d mètres"
L["Proximity"] = "Proximité"
L["Sound"] = "Son"
L["Disabled"] = "Désactivé"
L["Disable the proximity display for all modules that use it."] = "Désactive l'affichage de proximité pour tous les modules l'utilisant."
L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = "L'affichage de proximité sera affiché la prochaine fois. Pour le désactiver complètement, rendez-vous dans les options du boss et décochez \"Proximité\"."

L.proximity = "Affichage de proximité"
L.proximity_desc = "Affiche la fenêtre de proximité quand cela est approprié pour cette rencontre, indiquant la liste des joueurs qui se trouvent trop près de vous."
L.proximityfont = "Fonts\\FRIZQT__.TTF"

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

-----------------------------------------------------------------------
-- Tips.lua
--

L["|cff%s%s|r says:"] = "|cff%s%s|r dit :"
L["Cool!"] = "Cool !"
L["Tips"] = "Astuces"
L["Tip of the Raid"] = "Astuce de raid"
L["Tip of the raid will show by default when you zone in to a raid instance, you are not in combat, and your raid group has more than 9 players in it. Only one tip will be shown per session, typically.\n\nHere you can tweak how to display that tip, either using the pimped out window (default), or outputting it to chat. If you play with officers who overuse the |cffff4411/sendtip command|r, you might want to show them in chat frame instead!"] = "Une astuce de raid sera affichée par défaut quand vous entrez dans une instance de raid, si vous n'êtes pas en combat et si votre groupe de raid comporte plus de 9 joueurs. Une seule astuce sera affichée par session.\n\nVous pouvez ici modifier la façon dont cette astuce est affichée (soit via sa fenêtre (par défaut), soit via la fenêtre de discussion). Si vous jouez avec des officiers de raid qui abusent de la |cffff4411commande /sendtip|r, vous préférerez sans doute la fenêtre de discussion !"
L["If you don't want to see any tips, ever, you can toggle them off here. Tips sent by your raid officers will also be blocked by this, so be careful."] = "Si vous ne souhaitez voir aucune astuce, même celles de vos assistants de raid, décochez ceci."
L["Automatic tips"] = "Astuces automatiques"
L["If you don't want to see the awesome tips we have, contributed by some of the best PvE players in the world, pop up when you zone in to a raid instance, you can disable this option."] = "Si vous ne souhaitez pas voir les supers astuces que nous avons (données par certains des meilleurs joueurs JcE du monde) apparaître quand vous entrez dans une instance de raid, vous pouvez désactiver cette option."
L["Manual tips"] = "Astuces manuels"
L["Raid officers have the ability to show manual tips with the /sendtip command. If you have an officer who spams these things, or for some other reason you just don't want to see them, you can disable it with this option."] = "Les officiers de raid ont la possiblité d'afficher aux joueurs du raid une astuce manuellement à l'aide de la commande /sendtip. Si vous avez un officier qui abuse de cette fonction, ou si tout simplement vous ne souhaitez pas voir ces astuces, vous pouvez désactiver la fonction avec cette option."
L["Output to chat frame"] = "Sortie vers la fenêtre de discussion"
L["By default the tips will be shown in their own, awesome window in the middle of your screen. If you toggle this, however, the tips will ONLY be shown in your chat frame as pure text, and the window will never bother you again."] = "Par défaut, les astuces sont affichées dans une fenêtre au milieu de l'écran. Si vous cochez ceci, elles seront UNIQUEMENT affichées dans votre fenêtre de discussion."
L["Usage: /sendtip <index|\"Custom tip\">"] = "Utilisation : /sendtip <index|\"Astuce perso.\">"
L["You must be an officer to broadcast a tip."] = "Vous devez être au moins officier de raid pour diffuser une astuce."
L["Tip index out of bounds, accepted indexes range from 1 to %d."] = "Index des astuces hors limite. Les index acceptés vont de 1 à %d."

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
L["Flash"] = "Flash"
L["Flashes the screen red during the last 3 seconds of any related timer."] = "Fait flasher l'écran en rouge pendant les 3 dernières secondes de tout minuteur relatif à une option à mettre fortement en évidence."
