local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "esES") or LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "esMX")
if not L then return end

-----------------------------------------------------------------------
-- Bars.lua
--

L["Style"] = "Estilo"
L.bigWigsBarStyleName_Default = "Por defecto"

L["Clickable Bars"] = "Barras clicables"
L.clickableBarsDesc = "Las barras de Big Wigs bars son clicables por defecto. De esta forma puedes targetear objetos o lanzar hechizos AoE detrás de ellos, cambia el ángulo de la cámara, y así sucesivamente, mientras tu cursos está encima de las barras. |cffff4411Si habilitas las barras clicables, esto dejará de funcionar.|r Las barras interceptarán cualquier clic de ratón que hagas en ellas.\n"
L["Enables bars to receive mouse clicks."] = "Activa las barras para recivir clics de ratón"
L["Modifier"] = "Modificador"
L["Hold down the selected modifier key to enable click actions on the timer bars."] = "Presiona la tecla de modificador elegido para activar acciones de clics en los tiempos de las barras."
L["Only with modifier key"] = "Solo con una tecla de modificador"
L["Allows bars to be click-through unless the specified modifier key is held down, at which point the mouse actions described below will be available."] = "Permite a las barras que sean clicables en el caso de que esté presionada la tecla modificadora, en este punto las acciones de ratón describirán justo debajo si estarán disponibles."

L["Temporarily Super Emphasizes the bar and any messages associated with it for the duration."] = "Temporalmente Super Enfatiza la barra y los mensajes asociados para la duración."
L["Report"] = "Reportar"
L["Reports the current bars status to the active group chat; either instance chat, raid, party or say, as appropriate."] = "Reporta el estado actual de las barras al grupo activo de chat; ya sea en el chat de estancia, raid, grupo o decir, según corresponda."
L["Remove"] = "Quitar"
L["Temporarily removes the bar and all associated messages."] = "Temporalmente quita la barra y los mensajes asociados"
L["Remove other"] = "Quitar otro"
L["Temporarily removes all other bars (except this one) and associated messages."] = "Temporalmente quita todas las barras (excepto esta) y los mensajes asociados."
L.disable = "Desactivar"
L["Permanently disables the boss encounter ability option that spawned this bar."] = "Desactiva permanentemente la habilidad del encuentro para que no de opción a que reaparezca esta barra"

L["Emphasize at... (seconds)"] = "Enfatizar en... (segundos)"
L["Scale"] = "Escala"
L["Grow upwards"] = "Crecer ascendente"
L["Toggle bars grow upwards/downwards from anchor."] = "Alterna entre crecer las barras ascendente/descendente desde el anclaje."
L["Texture"] = "Textura"
L["Emphasize"] = "Enfatizar"
L["Enable"] = "Permitir"
L["Move"] = "Mover"
L.moveDesc = "Mueve las barras enfatizadas al anclaje de Enfatizar. Si esta opción está desactivada, las barras enfatizadas simplemente cambiarán el tamaño y el color."
L["Regular bars"] = "Barras regulares"
L["Emphasized bars"] = "Barras emfatizadas"
L["Align"] = "Alineación"
L["Left"] = "Izquierda"
L["Center"] = "Centro"
L["Right"] = "Derecha"
L["Time"] = "Tiempo"
L["Whether to show or hide the time left on the bars."] = "Oculta o muestra el tiempo restante en las barras."
L["Icon"] = "Icono"
L["Shows or hides the bar icons."] = "Muestra u oculta los iconos de las barras."
L.font = "Fuente"
L["Restart"] = "Reiniciar"
L["Restarts emphasized bars so they start from the beginning and count from 10."] = "Reinicia las barras enfatizadas para que empiecen desde el principio y el recuento desde 10."
L["Fill"] = "Llenar"
L["Fills the bars up instead of draining them."] = "Llena las barras o las drena."

L["Local"] = "Local"
L["%s: Timer [%s] finished."] = "%s: Contador [%s] terminado."
L["Custom bar '%s' started by %s user %s."] = "Barra personal '%s' lanzada por el jugador %s %s."

L["Pull"] = "Pull"
L["Pulling!"] = "¡Puleando!"
L["Pull timer started by %s user %s."] = "Cuenta atrás para el Pull lanzada por el jugador %s %s."
L["Pull in %d sec"] = "Pull en %d seg"
L["Sending a pull timer to Big Wigs and DBM users."] = "Enviando una cuenta para el Pull a usuarios de Big Wigs y DBM."
L["Sending custom bar '%s' to Big Wigs and DBM users."] = "Enviando barra personalizada '%s' a usuarios de Big Wigs y DBM."
L["This function requires raid leader or raid assist."] = "Esta función requiere raid leader o asistente."
L["Must be between 1 and 60. A correct example is: /pull 5"] = "Debe ser entre 1 y 60. Un ejemplo sería: /pull 5"
L["Incorrect format. A correct example is: /raidbar 20 text"] = "Formato incorrecto. Un ejemplo seria: /raidbar 20 text"
L["Invalid time specified. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Tiempo especificado inválido. <time> puede ser bien un número en segundos, un par M:S, o Min. Por ejemplo 5, 1:20 o 2m."
L["This function can't be used during an encounter."] = "Esta función no se puede usar durante un encuentro."
L["Pull timer cancelled by %s."] = "Pull cancelado por %s."



-- These localization strings are translated on WoWAce: http://www.wowace.com/addons/big-wigs/localization/
--@localization(locale="esES", namespace="Plugins", format="lua_additive_table", handle-unlocalized="ignore")@

