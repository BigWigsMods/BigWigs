local L = LibStub("AceLocale-3.0"):NewLocale("BigWigs:Extras", "esES")

if not L then return end


-- Custombars.lua

L["%s: Timer [%s] finished."] = "%s: Temporizador [%s] finalizado"
L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Tiempo inv\195\161lido (|cffff0000%q|r) o texto de barra ausente en una barra personal iniciada por |cffd9d919%s|r. <tiempo> puede ser un n\195\186mero en segundos, una pareja M:S, o Mm. Por ejemplo 5, 1:20 or 2m."

-- Version.lua

-- no esES yet

-- Proximity.lua

L["Proximity"] = "Proximidad"

L["Options for the Proximity Display."] = "Opciones para la ventana de proximidad"
L["|cff777777Nobody|r"] = "|cff777777Nadie|r"
L["Sound"] = "Sonido"
L["Play sound on proximity."] = "Tocar sonido cuando est\195\169 en proximidad"
L["Disabled"] = "Desactivado"
L["Disable the proximity display for all modules that use it."] = "Desactivar la ventana de proximidad para todos los m\195\179dulos que lo usen"

L.proximity = "Ventana de proximidad"
L.proximity_desc = "Muestra la ventana de proximidad cuando sea apropiado para este encuentro, listando los jugadores que est\195\161n demasiado cerca de t\195\173."

L.font = "Fonts\\FRIZQT__.TTF"