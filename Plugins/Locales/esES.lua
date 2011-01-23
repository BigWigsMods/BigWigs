local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "esES")
if not L then return end
-----------------------------------------------------------------------
-- Bars.lua
--

L["Clickable Bars"] = "Barras clicables"
L.clickableBarsDesc = "Big Wigs bars are click-through by default. This way you can target objects or launch targetted AoE spells behind them, change the camera angle, and so on, while your cursor is over the bars. |cffff4411If you enable clickable bars, this will no longer work.|r The bars will intercept any mouse clicks you perform on them.\n"
L["Enables bars to receive mouse clicks."] = "Activa las barras para recivir clics de rat\195\179n"
L["Modifier"] = "Modificador"
L["Hold down the selected modifier key to enable click actions on the timer bars."] = "Presiona la tecla de modificador elegido para activar acciones de clics en los tiempos de las barras."
L["Only with modifier key"] = "Solo con una tecla de modificador"
L["Allows bars to be click-through unless the specified modifier key is held down, at which point the mouse actions described below will be available."] = true

L["Temporarily Super Emphasizes the bar and any messages associated with it for the duration."] = "Temporalmente Super Enfatiza la barra y los mensajes asociados para la duraci\195\179n."
L["Report"] = "Reportar"
L["Reports the current bars status to the active group chat; either battleground, raid, party or guild, as appropriate."] = "Reporta el estado de las barras actuales al chat del grupo activo; bg, raid, grupo o hermandad, el m\195\161s apropiado."
L["Remove"] = "Quitar"
L["Temporarily removes the bar and all associated messages."] = "Temporalmente quita la barra y los mensajes asociados"
L["Remove other"] = "Quitar otro"
L["Temporarily removes all other bars (except this one) and associated messages."] = "Temporalmente quita todas las barras (excepto esta) y los mensajes asociados."
L["Disable"] = "Desactivar"
L["Permanently disables the boss encounter ability option that spawned this bar."] = true

L["Scale"] = "Escala"
L["Grow upwards"] = "Crecer ascendente"
L["Toggle bars grow upwards/downwards from anchor."] = "Alterna entre crecer las barras ascendente/descendente desde el anclaje."
L["Texture"] = "Textura"
L["Emphasize"] = "Enfatizar"
L["Enable"] = "Permitir"
L["Move"] = "Mover"
L["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."] = true
L["Flash"] = "Flash"
L["Flashes the background of emphasized bars, which could make it easier for you to spot them."] = "Flashea el fondo de la barra enfatizada, haciendola m\195\161s facil de ver"
L["Regular bars"] = "Barras regulares"
L["Emphasized bars"] = "Barras emfatizadas"
L["Align"] = "Alineaci\195\179n"
L["Left"] = "Izquierda"
L["Center"] = "Centro"
L["Right"] = "Derecha"
L["Time"] = "Tiempo"
L["Whether to show or hide the time left on the bars."] = "Oculta o muestra el tiempo restante en las barras."
L["Icon"] = "Icono"
L["Shows or hides the bar icons."] = "Muestra u oculta los iconos de las barras."
L["Font"] = "Fuente"
L["Restart"] = "Reiniciar"
L["Restarts emphasized bars so they start from the beginning and count from 10."] = "Reinicia las barras enfatizadas para que empiecen desde el principio y el recuento desde 10."
L["Fill"] = "Llenar"
L["Fills the bars up instead of draining them."] = "Llena las barras o las drena."

L["Local"] = "Local"
L["%s: Timer [%s] finished."] = "%s: Contador [%s] terminado."
L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = true

-----------------------------------------------------------------------
-- Colors.lua
--

L["Colors"] = "Colores"

L["Messages"] = "Mensajes"
L["Bars"] = "Barras"
L["Background"] = "Fondo"
L["Text"] = "Texto"
L["Flash and shake"] = "Flash y temblar"
L["Normal"] = "Normal"
L["Emphasized"] = "Enfatizado"

L["Reset"] = "Reiniciar"
L["Resets the above colors to their defaults."] = "Reinicia los colores por defecto"
L["Reset all"] = "Resetear todo"
L["If you've customized colors for any boss encounter settings, this button will reset ALL of them so the colors defined here will be used instead."] = "Si has personallizado los colores y los ajustes de algun encuentro de jefe, este bot\195\179n seiniciar\195\161 TODO y se usar\195\161n los colores por defecto."

L["Important"] = "Importante"
L["Personal"] = "Personal"
L["Urgent"] = "Urgente"
L["Attention"] = "Atenci\195\179n"
L["Positive"] = "Positivo"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Route output from this addon through the Big Wigs message display. This display supports icons, colors and can show up to 4 messages on the screen at a time. Newly inserted messages will grow in size and shrink again quickly to notify the user."
L.emphasizedSinkDescription = "Route output from this addon through the Big Wigs Emphasized message display. This display supports text and colors, and can only show one message at a time."

L["Messages"] = "Mensajes"
L["Normal messages"] = "Mensajes normales"
L["Emphasized messages"] = "Mensajes enfatizados"
L["Output"] = "Salida"

L["Use colors"] = "Usar colores"
L["Toggles white only messages ignoring coloring."] = "Mensajes de color blanco ignorando los colores."

L["Use icons"] = "Usar iconos"
L["Show icons next to messages, only works for Raid Warning."] = "Muestra los siguientes iconos para mensajes, solo funciona para alertas de raid."

L["Class colors"] = "Colores de clase"
L["Colors player names in messages by their class."] = "Colores el nombre del jugador en los mensajes con el color de su clase"

L["Chat frame"] = "Ventana de chat"
L["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "Todos los mensajes de salida de Big Wigs a la ventana de chat por defecto en adici\195\179n a los ajustes mostrados"

L["Font size"] = "Tama\195\177o de fuente"
L["None"] = "Ninguno"
L["Thin"] = "Fino"
L["Thick"] = "Grueso"
L["Outline"] = "Contorno"
L["Monochrome"] = "Monocromo"
L["Toggles the monochrome flag on all messages, removing any smoothing of the font edges."] = "Cambia a monocromo el indicador en todos los mensajes, quitando cualquier suavizado de fuente."

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L["Icons"] = "Iconos"

L.raidIconDescription = "Elementos de tipo 'bomba' y simirales en un jugador pueden ser de interes especial. Aqui puedes configurar como se deber\195\173a marar con iconos algunos pjs.\n\nSi solo se usa un icono para un encuentro se usar\195\161 el primario, nunca se usar\195\161 el mismo icono para 2 habilidades distintas, para eso esta el icono secundario.\n\n|cffff4411Nota si un jugador ha sido marcado manualmente Big Wigs nunca cambiar\195\161 su icono.|r"
L["Primary"] = "Primario"
L["The first raid target icon that a encounter script should use."] = "El primer objetivo de la raid el cual deberia usar este icono"
L["Secondary"] = "Secundario"
L["The second raid target icon that a encounter script should use."] = "El secundario objetivo de la raid el cual deber\195\173a usar este icono"

L["Star"] = "Estrella"
L["Circle"] = "C\195\173rculo"
L["Diamond"] = "Diamante"
L["Triangle"] = "TRi\195\161ngulo"
L["Moon"] = "Luna"
L["Square"] = "Cuadrado"
L["Cross"] = "Cruz"
L["Skull"] = "Calavera"
L["|cffff0000Disable|r"] = "|cffff0000Desactivar|r"

-----------------------------------------------------------------------
-- Sound.lua
--

L.soundDefaultDescription = "Con esa opci\195\179n puesta, Big Wigs solo usar\195\161 el sonido por defecto de Blizzard para las alertas de raid y para mensajes que llegan con una alerta de sonido. Nota que solo algunos mensajes de los scripts de encuentros usar\195\161n un gatillo como alerta de sonido."

L["Sounds"] = "Sonidos"

L["Alarm"] = "Alarma"
L["Info"] = "Info"
L["Alert"] = "Alerta"
L["Long"] = "Largo"
L["Victory"] = "Victoria"

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "Ajusta el sonido a usar para %q.\n\nCtrl-Clic un sonido a vista previa."
L["Default only"] = "Solo por defecto"

-----------------------------------------------------------------------
-- Proximity.lua
--

L["|T%s:20:20:-5|tAbility name"] = "|T%s:20:20:-5|tNombre de la habilidad"
L["Custom range indicator"] = "Indicador de rango personalizado"
L["%d yards"] = "%d yrd/mtr"
L["Proximity"] = "Proximidad"
L["Sound"] = "Sonido"
L["Disabled"] = "Desactivado"
L["Disable the proximity display for all modules that use it."] = "Desactiva la ventana de proximidad pra todos los m\195\179dulos que la usen."
L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = "La ventana de proximidad se mostrar\195\161 la pr\195\179xima vez. Para desativarla completamente de este encuentro, necesitas apagarla de las opciones de encuentros."

L.proximity = "Visualizar proximidad"
L.proximity_desc = "Muestra la ventana de proximidad cuando sea apropidada para este encuentro, lista los jugadores que están demasiado cerca tuya."

L["Close"] = "Cerrar"
L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = true
L["Lock"] = "Bloquear"
L["Locks the display in place, preventing moving and resizing."] = "Bloquea la ventana en el lugar, previniendo que se mueva y redimensione"
L["Title"] = "T\195\173tulo"
L["Shows or hides the title."] = "Muestra/oculta el t\195\173tulo"
L["Background"] = "Fondo"
L["Shows or hides the background."] = "Muestra/oculta el fondo"
L["Toggle sound"] = "Cambiar sonido"
L["Toggle whether or not the proximity window should beep when you're too close to another player."] = "Activada o no la ventana de proximidad deber\195\173a emitir un beep si est\195\161s cerca de otro jugador."
L["Sound button"] = "Bot\195\179n de sonido"
L["Shows or hides the sound button."] = "Muestra/oculta el bot\195\179n de sonido"
L["Close button"] = "Boton cerrar"
L["Shows or hides the close button."] = "Muestra/oculta el bot\195\179n de cerrar"
L["Show/hide"] = "Mostrar/ocultar"
L["Ability name"] = "Nombre de habilidad"
L["Shows or hides the ability name above the window."] = "Muestra/oculta el nombre de la habilidad encima de la ventana"
L["Tooltip"] = "Tooltip"
L["Shows or hides a spell tooltip if the Proximity display is currently tied directly to a boss encounter ability."] = "Muestra/oculta el tooltip del hechizo si la ventana de proximidad esta empatada con una habilidad del boss."

-----------------------------------------------------------------------
-- Tips.lua
--

L["|cff%s%s|r says:"] = "|cff%s%s|r dice:"
L["Cool!"] = "¡Guay1"
L["Tips"] = "Tips"
L["Tip of the Raid"] = true
L["Tip of the raid will show by default when you zone in to a raid instance, you are not in combat, and your raid group has more than 9 players in it. Only one tip will be shown per session, typically.\n\nHere you can tweak how to display that tip, either using the pimped out window (default), or outputting it to chat. If you play with officers who overuse the |cffff4411/sendtip command|r, you might want to show them in chat frame instead!"] = true
L["If you don't want to see any tips, ever, you can toggle them off here. Tips sent by your raid officers will also be blocked by this, so be careful."] = true
L["Automatic tips"] = true
L["If you don't want to see the awesome tips we have, contributed by some of the best PvE players in the world, pop up when you zone in to a raid instance, you can disable this option."] = true
L["Manual tips"] = true
L["Raid officers have the ability to show manual tips with the /sendtip command. If you have an officer who spams these things, or for some other reason you just don't want to see them, you can disable it with this option."] = true
L["Output to chat frame"] = true
L["By default the tips will be shown in their own, awesome window in the middle of your screen. If you toggle this, however, the tips will ONLY be shown in your chat frame as pure text, and the window will never bother you again."] = true
L["Usage: /sendtip <index|\"Custom tip\">"] = true
L["You must be an officer in the raid to broadcast a tip."] = true
L["Tip index out of bounds, accepted indexes range from 1 to %d."] = true

-----------------------------------------------------------------------
-- Emphasize.lua
--

L["Super Emphasize"] = "Super Enfatizar"
L.superEmphasizeDesc = "Da a los mensajes o barras relacionados con una habilidad de un encuentro.\n\nAqu\195\173 configuras exactamente que deber\195\173a ocurrir cuando cambias a activado en la opci\195\179n de Super Enfatizar en la secci\195\179n avanzada para una habilidad de un encuentro de un jefe.\n\n|cffff4411Nota que Super Enfatizar est\195\161 apagado por defecto para todas las habilidades.|r\n"
L["UPPERCASE"] = "MAYUSCULAS"
L["Uppercases all messages related to a super emphasized option."] = "May\195\186sculas en todos los mensajes relacionados con una opci\195\179n super enfatizada."
L["Double size"] = "Tama\195\177o doble"
L["Doubles the size of super emphasized bars and messages."] = "Dobla el tama\195\177o de las barras super enfatizadas y los mensajes"
L["Countdown"] = "Cuenta atr\195\161s"
L["If a related timer is longer than 5 seconds, a vocal and visual countdown will be added for the last 5 seconds. Imagine someone counting down \"5... 4... 3... 2... 1... COUNTDOWN!\" and big numbers in the middle of your screen."] = true
L["Flash"] = "Flash"
L["Flashes the screen red during the last 3 seconds of any related timer."] = "Flashea la pantalla en rojo durante los 3 \195\186ltimos segundos o de algun contador relacionado."

