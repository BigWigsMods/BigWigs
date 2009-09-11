local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "esES")

if not L then return end

-- Bars2.lua

L["%s: Timer [%s] finished."] = "%s: Temporizador [%s] finalizado"
L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Tiempo inv\195\161lido (|cffff0000%q|r) o texto de barra ausente en una barra personal iniciada por |cffd9d919%s|r. <tiempo> puede ser un n\195\186mero en segundos, una pareja M:S, o Mm. Por ejemplo 5, 1:20 or 2m."


-- Colors.lua
L["Colors"] = "Colores"

L["Messages"] = "Mensajes"
L["Bars"] = "Barras"
L["Short"] = "Cortas"
L["Long"] = "Largas"
L["Short bars"] = "Barras cortas"
L["Long bars"] = "Barras largas"
L["Color "] = "Color"
L["Number of colors"] = "Número de colores"
L["Background"] = "Fondo"
L["Text"] = "Texto"
L["Reset"] = "Reiniciar"

L["Bar"] = "Barra"
L["Change the normal bar color."] = "Cambia el color de la barra normal"
L["Emphasized bar"] = "Barra enfatizada"
L["Change the emphasized bar color."] = "Cambia el color de la barra enfatizada"

L["Colors of messages and bars."] = "Color de los mensajes y barras"
L["Change the color for %q messages."] = "Cambia el color para %q mensajes"
L["Change the %s color."] = "Cambia el %s color"
L["Change the bar background color."] = "Cambia el color de fondo de la barra"
L["Change the bar text color."] = "Cambia el color del texto de la barra"
L["Resets all colors to defaults."] = "Reinicia todos los colores a los valores por defecto"

L["Important"] = "Importante"
L["Personal"] = "Personal"
L["Urgent"] = "Urgente"
L["Attention"] = "Atención"
L["Positive"] = "Positivo"
L["Bosskill"] = "Muerte de Jefe"
L["Core"] = "Núcleo"
	
-- Messages.lua
L["Messages"] = "Mensajes"
L["Options for message display."] = "Opciones para mostrar mensajes."

L["BigWigs Anchor"] = "Ancla de BigWigs"
L["Output Settings"] = "Parámetros de salida"

L["Show anchor"] = "Mostrar ancla"
L["Show the message anchor frame.\n\nNote that the anchor is only usable if you select 'BigWigs' as Output."] = "Mostrar la ventana del ancla de los mensajes.\n\nLa ventana de ancla es utilizable solo si seleccionas BigWigs como salida."

L["Use colors"] = "Usar colores"
L["Toggles white only messages ignoring coloring."] = "Mostrar solo mensajes en blanco, ignorando colores."

L["Scale"] = "Escala"
L["Set the message frame scale."] = "Establece la escala del mensaje."

L["Use icons"] = "Usar iconos"
L["Show icons next to messages, only works for Raid Warning."] = "mostrar iconos al lado de los mensajes. Solo funciona para avisos de banda."

L["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = "|cffff0000Co|cffff00fflo|cff00ff00r|r"
L["White"] = "Blanco"

L["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "Envía también a la ventana de chat por defecto todos los mensaje de BigWigs."

L["Chat frame"] = "Ventana de chat"

L["Test"] = "Probar"
L["Close"] = "Cerrar"

L["Reset position"] = "Reiniciar posición"
L["Reset the anchor position, moving it to the center of your screen."] = "Reinicia la posición del ancla, moviéndola al centro de la pantalla."


-- RaidIcon.lua
L["Raid Icons"] = "Iconos de banda"
L["Configure which icon Big Wigs should use when placing raid target icons on players for important 'bomb'-type boss abilities."] = "Configura qué iconos colocará BigWigs sobre jugadores afectados por habilidades de Jefe tipo 'Bomba' u otras."

L["RaidIcon"] = "Icono de banda"

L["Place"] = "Colocar"
L["Place Raid Icons"] = "Activar iconos en jugadores"
L["Toggle placing of Raid Icons on players."] = "Activa la colocación de iconos de banda sobre jugadores."

L["Icon"] = "Icono"
L["Set Icon"] = "Establecer icono"
L["Set which icon to place on players."] = "Establece qué icono se colocará sobre los jugadores."

L["Use the %q icon when automatically placing raid icons for boss abilities."] = "Usar el icono %q al colocar automáticamente iconos de banda para habilidades de Jefes."

L["Star"] = "Estrella"
L["Circle"] = "Círculo"
L["Diamond"] = "Diamante"
L["Triangle"] = "Triángulo"
L["Moon"] = "Luna"
L["Square"] = "Cuadrado"
L["Cross"] = "Cruz"
L["Skull"] = "Calavera"

-- RaidWarn.lua
L["RaidWarning"] = "Aviso de banda"

L["Whisper"] = "Susurrar"
L["Toggle whispering warnings to players."] = "Activa el susurro de avisos a los jugadores."

L["raidwarning_desc"] = "Te permite configurar dónde enviará BigWigs los mensajes de jefes además de en local."

-- Sound.lua
L["Sounds"] = "Sonidos"
L["Options for sounds."] = "Opciones de los sonidos"

L["Alarm"] = "Alarma"
L["Info"] = "Información"
L["Alert"] = "Alerta"
L["Long"] = "Largo"
L["Victory"] = "Victoria"

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "Establece el sonido a usar para %q (Ctrl-Click en un sonido para escucharlo)."
L["Toggle all sounds on or off."] = "Activa o desactiva todos los sonidos."
L["Default only"] = "Solo por defecto"
L["Use only the default sound."] = "Usar solo el sonido por defecto"
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

L.proximityfont = "Fonts\\FRIZQT__.TTF"