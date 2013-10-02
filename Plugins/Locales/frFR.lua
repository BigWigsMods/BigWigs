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
L.disable = "Désactiver"
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
L.font = "Police d'écriture"
L["Restart"] = "Relancer"
L["Restarts emphasized bars so they start from the beginning and count from 10."] = "Relance les barres mises en évidence afin qu'elles commencent du début."
L["Fill"] = "Remplir"
L["Fills the bars up instead of draining them."] = "Remplit les barres au lieu de les vider."

L["Local"] = "Local"
L["%s: Timer [%s] finished."] = "%s : Minuteur [%s] terminé."
L["Custom bar '%s' started by %s user %s."] = "Barre perso '%s' lancée par l'utilisateur de %s %s."

L["Pull"] = "Pull"
L["Pulling!"] = "Pull !"
L["Pull timer started by %s user %s."] = "Délai de pull lancé par l'utilisateur de %s %s."
L["Pull in %d sec"] = "Pull dans %d sec."
L["Sending a pull timer to Big Wigs and DBM users."] = "Envoi d'un délai de pull aux utilisateurs de Big Wigs et DBM."
L["Sending custom bar '%s' to Big Wigs and DBM users."] = "Envoi d'une barre perso '%s' aux utilisateurs de Big Wigs et DBM."
L["This function requires raid leader or raid assist."] = "Cette fonction nécessite d'être le chef du raid ou un de ses assistants."
L["Must be between 1 and 60. A correct example is: /pull 5"] = "Doit être compris entre 1 et 60. Un exemple correct est le suivant : /pull 5"
L["Incorrect format. A correct example is: /raidbar 20 text"] = "Format incorrect. Un exemple correct est le suivant : /raidbar 20 texte"
L["Invalid time specified. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Durée spécifiée incorrecte. <durée> peut être exprimée soit avec un nombre en secondes, avec une paire M:S ou avec Mm. Par exemple 5, 1:20 ou 2m."
L["This function can't be used during an encounter."] = "Cette fonction ne peut pas être utilisée pendant une rencontre."
L["Pull timer cancelled by %s."] = "Délai de pull annulé par %s."



-- These localization strings are translated on WoWAce: http://www.wowace.com/addons/big-wigs/localization/
--@localization(locale="frFR", namespace="Plugins", format="lua_additive_table", handle-unlocalized="ignore")@

