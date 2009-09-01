local L = LibStub("AceLocale-3.0"):NewLocale("BigWigs:Plugins", "frFR")
if not L then return end
-- Bars2.lua

L["Bars"] = "Barres"
L["Normal Bars"] = "Barres normales"
L["Emphasized Bars"] = "Barres en évidence"
L["Options for the timer bars."] = "Options concernant les barres temporelles."
L["Toggle anchors"] = "Afficher/cacher ancres"
L["Show or hide the bar anchors for both normal and emphasized bars."] = "Affiche l'ancre pour les barres normales et les barres en évidence."
L["Scale"] = "Échelle"
L["Set the bar scale."] = "Définit l'échelle des barres."
L["Grow upwards"] = "Ajouter vers le haut"
L["Toggle bars grow upwards/downwards from anchor."] = "Ajoute les nouvelles barres soit en haut de l'ancre, soit en bas de l'ancre."
L["Texture"] = "Texture"
L["Set the texture for the timer bars."] = "Définit la texture des barres temporelles."
L["Test"] = "Test"
L["Close"] = "Fermer"
L["Emphasize"] = "Mise en évidence"
L["Emphasize bars that are close to completion (<10sec). Also note that bars started at less than 15 seconds initially will be emphasized right away."] = "Met en évidence les barres proches de la fin (< 10 sec.). Les barres d'une durée initiale de moins de 15 secondes seront directement mises en évidence."
L["Enable"] = "Activer"
L["Enables emphasizing bars."] = "Active la mise en évidence des barres."
L["Move"] = "Déplacer"
L["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."] = "Déplace les barres mises en évidence vers une ancre dédiée. Si cette option est désactivée, les barres mises en évidence vont simplement changer d'échelle et de couleur, et peut-être commencer à clignoter."
L["Set the scale for emphasized bars."] = "Détermine l'échelle des barres mises en évidence."
L["Reset position"] = "Réinit. la position"
L["Reset the anchor positions, moving them to their default positions."] = "Réinitialise la position des ancres, les déplaçant à leurs positions par défaut."
L["Test"] = "Test"
L["Creates a new test bar."] = "Créé une nouvelle barre de test."
L["Hide"] = "Cacher"
L["Hides the anchors."] = "Cache les ancres."
L["Flash"] = "Clignoter"
L["Flashes the background of emphasized bars, which could make it easier for you to spot them."] = "Fait clignoter l'arrière-plan des barres en évidence afin que vous puissiez mieux les voir."
L["Regular bars"] = "Barres normales"
L["Emphasized bars"] = "Barres en évidence"
L["Align"] = "Alignement"
L["How to align the bar labels."] = "Définit la façon d'aligner les libellés des barres."
L["Left"] = "Gauche"
L["Center"] = "Centre"
L["Right"] = "Droite"
L["Time"] = "Temps"
L["Whether to show or hide the time left on the bars."] = "Affiche ou non le temps restant sur les barres."
L["Icon"] = "Icône"
L["Shows or hides the bar icons."] = "Affiche ou non les icônes des barres."
L["Font"] = "Police d'écriture"
L["Set the font for the timer bars."] = "Définit la police d'écriture des barres temporelles."

-- Colors.lua

L["Colors"] = "Couleurs"

L["Messages"] = "Messages"
L["Bars"] = "Barres"
L["Short"] = "Court"
L["Long"] = "Long"
L["Short bars"] = "Barres courtes"
L["Long bars"] = "Barres longues"
L["Color "] = "Couleur "
L["Number of colors"] = "Nombre de couleurs"
L["Background"] = "Arrière-plan"
L["Text"] = "Texte"
L["Reset"] = "RÀZ"

L["Bar"] = "Barre"
L["Change the normal bar color."] = "Change la couleur des barres normales."
L["Emphasized bar"] = "Barre en évidence"
L["Change the emphasized bar color."] = "Change la couleur des barres mises en évidence."

L["Colors of messages and bars."] = "Couleurs des messages et des barres."
L["Change the color for %q messages."] = "Change la couleur des messages %q."
L["Change the %s color."] = "Change la couleur de %s."
L["Change the bar background color."] = "Change la couleur de l'arrière-plan."
L["Change the bar text color."] = "Change la couleur du texte des barres."
L["Resets all colors to defaults."] = "Réinitialise tous les paramètres à leurs valeurs par défaut."

L["Important"] = "Important"
L["Personal"] = "Personnel"
L["Urgent"] = "Urgent"
L["Attention"] = "Attention"
L["Positive"] = "Positif"
L["Bosskill"] = "Défaite"
L["Core"] = "Noyau"

L["color_upgrade"] = "Les valeurs de couleur pour vos messages & barres ont été réinitialisées afin de faciliter la mise à jour à partir de la dernière version. Si vous voulez les modifier à nouveau, faites un clic droit sur Big Wigs et allez dans Plugins -> Couleurs."

-- Messages.lua

L["Messages"] = "Messages"
L["Options for message display."] = "Options concernant l'affichage des messages."

L["BigWigs Anchor"] = "Ancre de BigWigs"
L["Output Settings"] = "Paramètres de sortie"

L["Show anchor"] = "Afficher l'ancre"
L["Show the message anchor frame.\n\nNote that the anchor is only usable if you select 'BigWigs' as Output."] = "Affiche l'ancre du cadre des messages.\n\nNotez que l'ancre est uniquement utilisable si vous avez choisi 'BigWigs' comme Sortie."

L["Use colors"] = "Utiliser des couleurs"
L["Toggles white only messages ignoring coloring."] = "Utilise ou non des couleurs dans les messages à la place du blanc unique."

L["Scale"] = "Échelle"
L["Set the message frame scale."] = "Détermine l'échelle du cadre des messages."

L["Use icons"] = "Utiliser les icônes"
L["Show icons next to messages, only works for Raid Warning."] = "Affiche les icônes à côté des messages. Ne fonctionne que sur l'Avertissement raid."

L["Class colors"] = "Couleurs de classe"
L["Colors player names in messages by their class."] = "Colore le nom des joueurs dans les messages selon leur classe."

L["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = "|cffff0000Co|cffff00ffule|cff00ff00ur|r"
L["White"] = "Blanc"

L["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "Affiche tous les messages de BigWigs dans la fenêtre de discussion par défaut, en plus de son affichage normal."

L["Chat frame"] = "Fenêtre de discussion"

L["Test"] = "Test"
L["Close"] = "Fermer"

L["Reset position"] = "RÀZ position"
L["Reset the anchor position, moving it to the center of your screen."] = "Réinitialise la position de l'ancre, la replaçant au centre de l'écran."

L["Spawns a new test warning."] = "Fait apparaître un nouvel avertissement de test."
L["Hide"] = "Cacher"
L["Hides the anchors."] = "Cache l'ancre."


-- RaidIcon.lua

L["Raid Icons"] = "Icônes de raid"
L["Configure which icon Big Wigs should use when placing raid target icons on players for important 'bomb'-type boss abilities."] = "Détermine l'icône que Big Wigs doit utiliser lors du placement des icônes de raid sur les joueurs affectés par les capacités des boss (ex. la bombe de Geddon)."

L["RaidIcon"] = "IcôneRaid"

L["Place"] = "Placement"
L["Place Raid Icons"] = "Placer les icônes de raid"
L["Toggle placing of Raid Icons on players."] = "Place ou non les icônes de raid sur les joueurs."

L["Icon"] = "Icône"
L["Set Icon"] = "Déterminer l'icône"
L["Set which icon to place on players."] = "Détermine quelle icône sera placée sur les joueurs."

L["Use the %q icon when automatically placing raid icons for boss abilities."] = "Utilise l'icône %q lors des placements automatiques des icônes de raid pour les capacités des boss."

L["Star"] = "Étoile"
L["Circle"] = "Cercle"
L["Diamond"] = "Diamant"
L["Triangle"] = "Triangle"
L["Moon"] = "Lune"
L["Square"] = "Carré"
L["Cross"] = "Croix"
L["Skull"] = "Crâne"

-- RaidWarn.lua
L["RaidWarning"] = "Avertissement du raid"

L["Whisper"] = "Chuchoter"
L["Toggle whispering warnings to players."] = "Chuchote ou non les avertissements aux joueurs."

L["raidwarning_desc"] = "Vous permet de déterminer où BigWigs doit envoyer ses messages en plus de ses messages locaux."

-- Sound.lua

L["Sounds"] = "Sons"
L["Options for sounds."] = "Options concernant les sons."

L["Alarm"] = "Alarme"
L["Info"] = "Info"
L["Alert"] = "Alerte"
L["Long"] = "Long"
L["Victory"] = "Victoire"

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "Détermine le son à utiliser pour %q (Ctrl-clic sur un son pour avoir un aperçu)."
L["Use sounds"] = "Utiliser les sons"
L["Toggle all sounds on or off."] = "Joue ou non les sons."
L["Default only"] = "Son par défaut uniquement"
L["Use only the default sound."] = "Utilise uniquement le son par défaut."
