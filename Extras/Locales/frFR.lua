local L = LibStub("AceLocale-3.0"):NewLocale("BigWigs:Extras", "frFR")

if not L then return end


-- Custombars.lua

L["Local"] = "Local"
L["%s: Timer [%s] finished."] = "%s : Délai [%s] terminé."
L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Durée invalide (|cffff0000%q|r) ou texte de barre manquant dans une barre personnalisée lancée par |cffd9d919%s|r. <durée> peut être soit un nombre en secondes, soit au format M:S, ou encore au format Mm. Par exemple : 5, 1:20 ou 2m."

-- Version.lua

L["should_upgrade"] = "Il semblerait que vous utilisez une ancienne version de Big Wigs. Il est recommandé de vous mettre à jour avant d'engager un boss."
L["out_of_date"] = "Les joueurs suivants semblent utiliser une ancienne version : %s."
L["not_using"] = "Membres n'utilisant pas Big Wigs : %s."

-- Proximity.lua

L["Proximity"] = "Proximité"
L["Close Players"] = "Joueurs proches"
L["Options for the Proximity Display."] = "Options concernant l'affichage de proximité."
L["|cff777777Nobody|r"] = "|cff777777Personne|r"
L["Sound"] = "Son"
L["Play sound on proximity."] = "Joue un son quand un autre joueur est trop proche de vous."
L["Disabled"] = "Désactivé"
L["Disable the proximity display for all modules that use it."] = "Désactive l'affichage de proximité pour tous les modules l'utilisant."
L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = "L'affichage de proximité sera affiché la prochaine fois. Pour le désactiver complètement, rendez-vous dans les options du boss et décochez \"Proximité\"."
L["The proximity display has been locked, you need to right click the Big Wigs icon, go to Extras -> Proximity -> Display and toggle the Lock option if you want to move it or access the other options."] = "L'affichage de proximité a été verrouillé. Vous devez faire un clic droit sur l'icône de BigWigs, puis allez dans Extras -> Proximité -> Affichage et décocher l'option Verrouiller si vous voulez le déplacer ou accédez aux autres options."

L.proximity = "Proximité"
L.proximity_desc = "Affiche la fenêtre de proximité quand approprié pour cette rencontre, indiquant la liste des joueurs qui se trouvent trop près de vous."

L.font = "Fonts\\FRIZQT__.TTF"

L["Close"] = "Fermer"
L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = "Ferme l'affichage de proximité.\nPour le désactiver complètement, rendez-vous dans les options du boss et décochez \"Proximité\"."
L["Test"] = "Test"
L["Perform a Proximity test."] = "Effectue un test de proximité."
L["Display"] = "Affichage"
L["Options for the Proximity display window."] = "Options concernant la fenêtre d'affichage de proximité."
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
