local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "esES") or BigWigsAPI:NewLocale("BigWigs: Plugins", "esMX")
if not L then return end

L.comma = ", "
L.width = "Ancho"
L.height = "Alto"
L.sizeDesc = "Normalmente ajusta el tamaño deslizando por la barra. Si necesitas un tamaño exacto puedes usar este deslizador o teclea el valor dentro de la caja, no tiene máximo."

L.abilityName = "Nombre de habilidad"
L.abilityNameDesc = "Muestra/oculta el nombre de la habilidad encima de la ventana"
L.Alarm = "Alarma"
L.Alert = "Alerta"
L.align = "Alineación"
L.alignText = "Alinear texto"
L.alignTime = "Alinear tiempo"
L.altPowerTitle = "PoderAlternativo"
L.background = "Fondo"
L.backgroundDesc = "Muestra/oculta el fondo"
L.bars = "Barras"
L.bestTimeBar = "Mejor tiempo"
L.bigWigsBarStyleName_Default = "Por defecto"
L.blockEmotes = "Bloquear emotes del centro de la pantalla"
L.blockEmotesDesc = [=[Algunos jefes muestran emotes para ciertas habilidades, estos mensajes son demasiado largos y descriptivos. Intentamos acortarlos, y ajustarlos para que no interfieran con el juego, y que no te digan específicamente que tienes que hacer.

Ten en cuenta: Los emotes de Jefe seguirán siendo visibles en el chat si deseas leerlos.]=]
L.blockGuildChallenge = "Bloquear ventanas emergentes de hermandad"
L.blockGuildChallengeDesc = [=[Los logros de hermandad muestran ventanas emergentes, principalmente cuando un grupo de tu hermandad completa una mazmorra heroica o un desafío.

Estas ventanas pueden cubrir partes críticas de tu interfaz durante un encuentro, así que recomendamos bloquearlas.]=]
L.blockMovies = "Bloquear vídeos repetidos"
L.blockMoviesDesc = "Los vídeos de un encuentro solo se visionarán una vez (los verás todos una vez) y luego serán bloqueados."
L.blockSpellErrors = "Bloquear mensajes de hechizos fallidos"
L.blockSpellErrorsDesc = "Mensajes como \"Ese hechizo no está listo todavía\" que normalmente se muestran arriba de la pantalla serán bloqueados."
L.bossBlock = "Bloque de Jefe"
L.bossBlockDesc = "Configura varias cosas que puedes bloquear durante un encuentro."
L.bossDefeatDurationPrint = "Derrotado '%s' después de %s."
L.bossStatistics = "Estadísticas de Jefe"
L.bossStatsDescription = "Registro de estadísticas de Jefes, como el número de veces que ha sido derrotado, cantidad de wipes, tiempo total que duró el combate, o la muerte más rápida. Estas estadísticas se pueden ver en la ventana de configuración de cada jefe, pero permanecerán ocultas en los jefes que no tengan todavía registro de estadísticas."
L.bossWipeDurationPrint = "Wipe en '%s' después de %s."
L.breakBar = "Tiempo de descanso"
L.breakFinished = "El descanso ha terminado!"
L.breakMinutes = "El descanso acaba en %d |4minuto:minutos;!"
L.breakSeconds = "El descanso acaba en %d |4segundo:segundos;!"
L.breakStarted = "Tiempo de descanso iniciado por %s (%s)."
L.breakStopped = "Descanso cancelado por %s."
L.bwEmphasized = "BigWigs enfatizado"
L.center = "Centro"
L.chatMessages = "Mensajes de chat"
L.classColors = "Colores de clase"
L.classColorsDesc = "Colorea el nombre de los jugadores según su clase"
L.clickableBars = "Barras clicables"
L.clickableBarsDesc = [=[Las barras de BigWigs bars son clicables por defecto. De esta forma puedes targetear objetos o lanzar hechizos AoE detrás de ellos, cambia el ángulo de la cámara, y así sucesivamente, mientras tu cursos está encima de las barras. |cffff4411Si habilitas las barras clicables, esto dejará de funcionar.|r Las barras interceptarán cualquier clic de ratón que hagas en ellas.
]=]
L.close = "Cerrar"
L.closeButton = "Boton cerrar"
L.closeButtonDesc = "Muestra/oculta el botón de cerrar"
L.closeProximityDesc = [=[Cierra la ventana de proximidad.

Para desactivarla completamente para un encuentro, tienes que ir a las opciones para ese encuentro y desactivar la opción de 'Proximidad'.]=]
L.colors = "Colores"
L.combatLog = "Combatlog automático"
L.combatLogDesc = "Empieza a guardar automáticamente el Combatlog cuando se lanza un pull y termina cuando acaba el combate."
L.countDefeats = "Contar Muertes"
L.countdownAt = "Cuenta atrás en... (segundos)"
L.countdownColor = "Color de cuenta atrás"
L.countdownTest = "Probar cuenta atrás"
L.countdownType = "Tipo de cuenta atrás"
L.countdownVoice = "Voz de cuenta atrás"
L.countWipes = "Contar Wipes"
L.createTimeBar = "Mostrar barra de 'Mejor tiempo' "
L.customBarStarted = "Barra personal '%s' lanzada por el jugador %s %s."
L.customRange = "Indicador de rango personalizado"
L.customSoundDesc = "Reproduce el sonido seleccionado en lugar de uno suministrado por el módulo"
L.defeated = "%s ha sido derrotado"
L.disable = "Desactivar"
L.disabled = "Desactivado"
L.disabledDisplayDesc = "Desactivar la ventana de proximidad para todos los módulos que la utilizan."
L.disableDesc = "Desactiva permanentemente la habilidad del encuentro para que no de opción a que reaparezca esta barra"
L.displayTime = "Muestra la hora"
L.displayTimeDesc = "Cuanto tiempo mostrará un mensaje, en segundos"
L.emphasize = "Enfatizar"
L.emphasizeAt = "Enfatizar en... (segundos)"
L.emphasized = "Enfatizado"
L.emphasizedBars = "Barras enfatizadas"
L.emphasizedCountdownSinkDescription = "Redirecciona la salida de este addon al sistema de cuenta atrás enfatizada de BigWigs. Este método de visualización soporta texto y colores, y puede mostrar solo un mensaje cada vez."
L.emphasizedMessages = "Mensajes enfatizados"
L.emphasizedSinkDescription = "Guía fuera de este addon siguiendo los mensajes enfatizados mostrados de BigWigs. Estos soportan texto y colores, y solo pueden mostrarse uno a la vez."
L.enable = "Permitir"
L.enableStats = "Activar estadísticas"
L.encounterRestricted = "Esta función no se puede usar durante un encuentro."
L.fadeTime = "Tiempo de desaparición"
L.fadeTimeDesc = "Cuando tiempo tardará en desaparecer un mensaje, en segundos"
L.fill = "Llenar"
L.fillDesc = "Llena las barras o las drena."
L.flash = "Flash"
L.font = "Fuente"
L.fontColor = "Color de la fuente"
L.fontSize = "Tamaño de la fuente"
L.general = "General"
L.growingUpwards = "Crecer ascendente"
L.growingUpwardsDesc = "Alterna el crecimiento hacia arriba o abajo desde el punto de anclaje."
L.icon = "Icono"
L.iconDesc = "Muestra u oculta los iconos de las barras."
L.icons = "Iconos"
L.Info = "Info"
L.interceptMouseDesc = "Activa las barras para permitir clics de ratón"
L.left = "Izquierda"
L.localTimer = "Local"
L.lock = "Bloquear"
L.lockDesc = "Bloquea la ventana en el lugar, previniendo que se mueva y redimensione"
L.Long = "Largo"
L.messages = "Mensajes"
L.modifier = "Modificador"
L.modifierDesc = "Presiona la tecla de modificador elegido para activar acciones de clics en los tiempos de las barras."
L.modifierKey = "Solo con una tecla de modificador"
L.modifierKeyDesc = "Permite a las barras que sean clicables en el caso de que esté presionada la tecla modificadora, en este punto las acciones de ratón describirán justo debajo si estarán disponibles."
L.monochrome = "Monocromo"
L.monochromeDesc = "Cambia a monocromo el indicador, quitando cualquier suavizado de fuente."
L.move = "Mover"
L.moveDesc = "Mueve las barras enfatizadas al anclaje de Enfatizar. Si esta opción está desactivada, las barras enfatizadas simplemente cambiarán el tamaño y el color."
L.movieBlocked = "Ya has visto esta cinemática antes, omitiéndola."
L.newBestTime = "¡Nueva muerte más rápida!"
L.none = "Ninguno"
L.normal = "Normal"
L.normalMessages = "Mensajes normales"
L.outline = "Contorno"
L.output = "Salida"
L.positionDesc = "Introduce o mueve el deslizador si necesitas posicionar de manera precisa desde el anclaje."
L.positionExact = "Posicionamiento preciso"
L.positionX = "Posición X"
L.positionY = "Posición Y"
L.primary = "Primario"
L.primaryDesc = "El primer objetivo de la raid el cual deberia usar este icono"
L.printBestTimeOption = "Notificar muerte más rápida"
L.printDefeatOption = "Tiempo de la Muerte"
L.printWipeOption = "Tiempo del Wipe"
L.proximity = "Visualizar proximidad"
L.proximity_desc = "Muestra la ventana de proximidad cuando sea apropidada para este encuentro, lista los jugadores que están demasiado cerca tuya."
L.proximity_name = "Proximidad"
L.proximityTitle = "%d m / %d |4jugador:jugadores;"
L.pull = "Pull"
L.pullIn = "Pull en %d seg"
L.engageSoundTitle = "Reproduce un sonido cuando un encuentro ha comenzado"
L.pullStartedSoundTitle = "Reproduce un sonido cuando el contador de pull ha empezado"
L.pullFinishedSoundTitle = "Reproduce un sonido cuando el contador de pull ha finalizado"
L.pullStarted = "Cuenta atrás para el Pull lanzada por el jugador %s %s."
L.pullStopped = "Pull cancelado por %s."
L.pullStoppedCombat = "Contador de Pull cancelado porque has entrado en combate."
L.raidIconsDesc = [=[Algunos encuentros usan los iconos de raid para marcar jugadores de interés especial para tu grupo. Por ejemplo los efectos tipo 'bomba' y control mental. Si la cambias a desactivado, no marcarás a nadie.

|cffff4411¡Solo aplica las marcas si eres ayudante o lider!|r]=]
L.raidIconsDescription = [=[Elementos de tipo 'bomba' y simirales en un jugador pueden ser de interes especial. Aqui puedes configurar como se debería marar con iconos algunos pjs.

Si solo se usa un icono para un encuentro se usará el primario, nunca se usará el mismo icono para 2 habilidades distintas, para eso esta el icono secundario.

|cffff4411Nota: Si un jugador ha sido marcado manualmente BigWigs nunca cambiará su icono.|r]=]
L.recordBestTime = "Recordar muertes más rápidas"
L.regularBars = "Barras regulares"
L.remove = "Quitar"
L.removeDesc = "Temporalmente quita la barra y los mensajes asociados"
L.removeOther = "Quitar otro"
L.removeOtherDesc = "Temporalmente quita todas las barras (excepto esta) y los mensajes asociados."
L.report = "Reportar"
L.reportDesc = "Reporta el estado actual de las barras al grupo activo de chat; ya sea en el chat de estancia, raid, grupo o decir, según corresponda."
L.requiresLeadOrAssist = "Esta función requiere ser el líder de banda o ayudante"
L.reset = "Reiniciar"
L.resetAll = "Resetear todo"
L.resetAllCustomSound = "Si tienes sonidos personalizados para algun ajuste en algún encuentro, este botón los reiniciará a TODOS y así los sonidos definidos aquí serán usados en su lugar."
L.resetAllDesc = "Si has personallizado los colores y los ajustes de algun encuentro, este botón reiniciará TODO y se usarán los colores por defecto."
L.resetDesc = "Reinicia los colores por defecto"
L.respawn = "Reaparece"
L.restart = "Reiniciar"
L.restartDesc = "Reinicia las barras enfatizadas para que empiecen desde el principio y el recuento desde 10."
L.right = "Derecha"
L.secondary = "Secundario"
L.secondaryDesc = "El secundario objetivo de la raid el cual debería usar este icono"
L.sendBreak = "Enviando un descanso a los jugadores con BigWigs y DBM."
L.sendCustomBar = "Enviando barra personalizada '%s' a usuarios de BigWigs y DBM."
L.sendPull = "Enviando una cuenta para el Pull a usuarios de BigWigs y DBM."
L.showHide = "Mostrar/ocultar"
L.showRespawnBar = "Muestra la barra de reaparecer"
L.showRespawnBarDesc = "Muestra una barra después de morir en un jefe que indica el tiempo que queda hasta que el jefe reaparezca."
L.sinkDescription = "Guía fuera de este addon siguiendo los mensajes mostrados de BigWigs. Estos soportan iconos, colores y pueden mostrarse hasta 4 mensajes en la pantalla a la vez. Recién insertados los mensajes crecerán en tamaño y encogerán de nuevo rápidamente para notificar al usuario."
L.sound = "Sonido"
L.soundButton = "Botón de sonido"
L.soundButtonDesc = "Muestra/oculta el botón de sonido"
L.soundDelay = "Retardo de sonido"
L.soundDelayDesc = "Especifica el tiempo que BigWigs debería esperar entre cada repetición de sonido cuando alguien está demasiado cerca de ti."
L.soundDesc = "Los mensajes podrían llegar con un sonido. A algunas personas les resulta más fácil escucahr. Cuando aprenden que 'tal' sonido va con 'cual' mensaje, en vez de leer dicho mensaje."
L.Sounds = "Sonidos"
L.style = "Estilo"
L.superEmphasize = "Super Enfatizar"
L.superEmphasizeDesc = [=[Da un aviso mucho más detectable a los mensajes o barras relacionados con una habilidad de un encuentro.

Aquí configuras exactamente que debería ocurrir cuando cambias a activado en la opción de Super Enfatizar en la sección avanzada para una habilidad de un encuentro de un jefe.

|cffff4411Nota: Super Enfatizar está apagado por defecto para todas las habilidades.|r
]=]
L.superEmphasizeDisableDesc = "Desactivar Súper Enfatizar para todos los módulos que lo utilicen."
L.tempEmphasize = "Temporalmente Super Enfatiza la barra y los mensajes asociados para la duración."
L.text = "Texto"
L.textCountdown = "Texto de cuenta atrás"
L.textCountdownDesc = "Muestra un contador visual durante una cuenta atrás"
L.textShadow = "Sombra de texto"
L.texture = "Textura"
L.thick = "Grueso"
L.thin = "Fino"
L.time = "Tiempo"
L.timeDesc = "Oculta o muestra el tiempo restante en las barras."
L.timerFinished = "%s: Contador [%s] terminado."
L.title = "Título"
L.titleDesc = "Muestra/oculta el título"
L.toggleDisplayPrint = "La ventana de proximidad se mostrará la próxima vez. Para ocultarla siempre para este encuentro, es necesario desactivarla en las opciones del encuentro."
L.toggleSound = "Cambiar sonido"
L.toggleSoundDesc = "Activada o no la ventana de proximidad debería emitir un beep si estás cerca de otro jugador."
L.tooltip = "Tooltip"
L.tooltipDesc = "Muestra/oculta la descripción del hechizo si la ventana de proximidad esta ligada a una habilidad del jefe."
L.uppercase = "MAYUSCULAS"
L.uppercaseDesc = "Mayúsculas en todos los mensajes relacionados con una opción super enfatizada."
L.useColors = "Usar colores"
L.useColorsDesc = "Mensajes de color blanco ignorando los colores."
L.useIcons = "Usar iconos"
L.useIconsDesc = "Mostrar iconos al lado de mensajes"
L.Victory = "Victoria"
L.victoryHeader = "Configura las acciones que se deberían realizar después de derrotar un jefe."
L.victoryMessageBigWigs = "Muestra el mensaje de BigWigs"
L.victoryMessageBigWigsDesc = "El mensaje de BigWigs es un simple mensaje \"jefe ha sido derrotado\" ."
L.victoryMessageBlizzard = "Muestra el mensaje de Blizzard"
L.victoryMessageBlizzardDesc = "El mensaje de Blizzard es una animación de gran tamaño en el medio de la pantalla \"jefe ha sido derrotado\"."
L.victoryMessages = "Mostrar mensajes de jefe derrotado"
L.victorySound = "Reproduce un sonido de victoria"
L.Warning = "Advertencia"
L.wipe = "Wipe"
L.wipeSoundTitle = "Reproduce un sonido cuando hay wipe"
L.wrongBreakFormat = "Debe ser entre 1 y 60 minutos. Por ejemplo: /break 5"
L.wrongCustomBarFormat = "Formato incorrecto. Un ejemplo seria: /raidbar 20 text"
L.wrongPullFormat = "Debe ser entre 1 y 60. Un ejemplo sería: /pull 5"
L.wrongTime = "Tiempo especificado inválido. <time> puede ser bien un número en segundos, un par M:S, o Min. Por ejemplo 5, 1:20 o 2m."

-----------------------------------------------------------------------
-- AutoReply.lua
--

L.autoReply = "Auto Respuesta"
L.autoReplyDesc = "Automáticamente responde a los que te susurran cuando estás ocupado durante un encuentro."
L.responseType = "Tipo de respuesta"
L.autoReplyFinalReply = "También susurra cuando acabas el combate"
L.guildAndFriends = "Hermandad y Amimgos"
L.everyoneElse = "Todos los demás"

L.autoReplyBasic = "Estoy ocupado combatiendo contra un jefe."
L.autoReplyNormal = "Estoy ocupado luchando contra '%s'."
L.autoReplyAdvanced = "Estoy ocupado luchando contra '%s' (%s) y %d/%d personas están vivas."
L.autoReplyExtreme = "Estoy ocupado luchando contra '%s' (%s) y %d/%d personas están vivas: %s"

L.autoReplyLeftCombatBasic = "Ya no estoy en combate con ningún jefe."
L.autoReplyLeftCombatNormalWin = "Gané contra '%s'."
L.autoReplyLeftCombatNormalWipe = "Perdí contra '%s'."
L.autoReplyLeftCombatAdvancedWin = "Gané contra '%s' con %d/%d personas vivas."
L.autoReplyLeftCombatAdvancedWipe = "Perdí contra '%s' en: %s"

-----------------------------------------------------------------------
-- Bars.lua
--

L.spacing = "Espaciado"
L.spacingDesc = "Cambia el espacio entre cada barra."
L.emphasizeMultiplier = "Multiplicador de tamaño"
L.emphasizeMultiplierDesc = "Si desactivas las barras moviéndose al anclaje enfatizado, esta opción decidirá que tamaño tendrán las barras enfatizadas multiplicando el tamaño de las barras normales."
L.iconPosition = "Posición del icono"
L.iconPositionDesc = "Elige dónde en la barra se posicionará el icono."
L.visibleBarLimit = "Límite de barras visibles"
L.visibleBarLimitDesc = "Ajusta la máxima cantidad de barras que serán visibles al mismo tiempo."
L.textDesc = "Ya sea para mostrar u ocultar el texto que se muestra en las barras."

-----------------------------------------------------------------------
-- BossBlock.lua
--

L.disableSfx = "Deshabilitar efectos de sonido"
L.disableSfxDesc = "La opción de 'Efectos de Sonido' en las opciones de sonido de WoW se desactivará, luego se vovlerá a activar cuando el encuentro con el jefe finalice. Esto puede ayudarte a concentrarte en los sonidos de avisos de BigWigs."
--L.blockTooltipQuests = "Block tooltip quest objectives"
--L.blockTooltipQuestsDesc = "When you need to kill a boss for a quest, it will usually show as '0/1 complete' in the tooltip when you place your mouse over the boss. This will be hidden whilst in combat with that boss to prevent the tooltip growing very large."
--L.blockFollowerMission = "Bloquear ventanas emergentes de ciudadela" -- Rename to follower mission
--L.blockFollowerMissionDesc = "Las ventanas emergentes de ciudadela muestran varias cosas, pero principalmente cuando un seguidor a completado una misión.\n\nEstas ventanas pueden cubrir partes críticas de tu interfaz durante un encuentro, así que recomendamos bloquearlas."

L.subzone_grand_bazaar = "Gran Bazar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "Puerto de Zandalar" -- Battle of Dazar'alor raid (Battle for Azeroth)
--L.subzone_eastern_transept = "Eastern Transept" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

L.red = "Rojo"
L.redDesc = "Avisos Generales para encuentros."
L.blue = "Azul"
L.blueDesc = "Avisos para cosas que te afecta a ti directamente como un debuff siendo aplicado a ti."
L.orange = "Naranja"
L.yellow = "Amarillo"
L.green = "Verde"
L.greenDesc = "Avisos para cosas buenas que ocurren, como un debuff siendo eliminado de ti."
L.cyan = "Cian"
L.cyanDesc = "Avisos para cambios de estados durante un encuentro como el avance a la siguiente fase."
L.purple = "Púrpura"
L.purpleDesc = "Avisos para habilidades específicas para tanques como acumulaciones de un debuff en un tanque."

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infoBox = "InfoBox"

-----------------------------------------------------------------------
-- Statistics.lua
--

L.printHealthOption = "Salud del jefe"
L.healthPrint = "Salud: %s."
L.healthFormat = "%s (%.1f%%)"
