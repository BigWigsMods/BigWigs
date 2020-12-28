local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "esMX")
if not L then return end

L.general = "General"
L.comma = ", "

L.positionX = "Posición X"
L.positionY = "Posición Y"
L.positionExact = "Posicionamiento exacto"
L.positionDesc = "Escriba en el recuadro o mueva el deslizador si necesita un posicionamiento exacto desde el ancla."
L.width = "Ancho"
L.height = "Alto"
L.sizeDesc = "Normalmente se ajusta el tamaño arrastrando el ancla. Si necesitas un tamaño exacto puedes usar este deslizador o escribir el valor en el recuadro, que no tiene un máximo."

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "PoderAlternativo"
L.toggleDisplayPrint = "La pantalla mostrará la próxima vez. Para desactivarlo completamente para este encuentro, debes desactivarlo en las opciones del encuentro."
L.disabled = "Desactivado"
L.disabledDisplayDesc = "Desactiva la pantalla para todos los módulos que la utilicen."
--L.resetAltPowerDesc = "Reset all the options related to AltPower, including the position of the AltPower anchor."

-----------------------------------------------------------------------
-- AutoReply.lua
--

L.autoReply = "Respuesta automática"
L.autoReplyDesc = "Automáticamente responde a los que te susurran cuando estás ocupado durante un encuentro."
L.responseType = "Tipo de respuesta"
L.autoReplyFinalReply = "También susurra cuando acabas el combate"
L.guildAndFriends = "Hermandad y Amigos"
L.everyoneElse = "Todos los demás"

L.autoReplyBasic = "Estoy ocupado en un encuentro contra un jefe."
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

L.bars = "Barras"
L.style = "Estilo"
L.bigWigsBarStyleName_Default = "Por defecto"
--L.resetBarsDesc = "Reset all the options related to bars, including the position of the bar anchors."

L.nameplateBars = "Barras de nombres"
L.nameplateAutoWidth = "Igualar anchura de la placa de nombre"
L.nameplateAutoWidthDesc = "Establece el ancho de las barras de nombres con la anchura de la barra de nombre padre."
L.nameplateOffsetY = "Desplazamiento en Y"
L.nameplateOffsetYDesc = "Desplazamiento de la parte superior de la placa de nombre para las barras hacia arriba y la parte inferior de la placa de nombre para las barras hacia abajo."

L.clickableBars = "Barra cliqueable"
L.clickableBarsDesc = "Las barras de BigWigs se les puede hacer clic por defecto. De esta manera puedes seleccionar objetos, lanzar hechizos AoE, cambiar el ángulo de la cámara, etc., mientras tu cursor está encima de las mismas. |cffff4411Si activas esta opción ya no se comportarán de esta forma.|r Las barras interceptarán los clics que hagas en ellas.\n"
L.interceptMouseDesc = "Permite que las barras reciban clics del ratón."
L.modifier = "Modificador"
L.modifierDesc = "Presiona la tecla modificadora seleccionada para activar acciones de clic en barras de tiempo."
L.modifierKey = "Solo con una tecla modificadora"
L.modifierKeyDesc = "Permite hacer clic en las barras a menos que se mantenga pulsada la tecla modificadora especificada, en cuyo caso las acciones del ratón que se describen a continuación estarán disponibles."

L.tempEmphasize = "Temporalmente Super Enfatiza la barra y cualquier mensaje asociado a ella durante la duración."
L.report = "Reportar"
L.reportDesc = "Informa del estado actual de las barras al grupo de chat activo; ya sea en el chat de la estancia, en la banda, en el grupo o decir, según corresponda."
L.remove = "Quitar"
L.removeDesc = "Quita temporalmente la barra y todos los mensajes asociados."
L.removeOther = "Quitar otros"
L.removeOtherDesc = "Quita temporalmente todas las demás barras (excepto ésta) y los mensajes asociados."
L.disable = "Deshabilitar"
L.disableDesc = "Deshabilita permanentemente la opción de la habilidad de encuentro con el jefe que dio origen a esta barra."

L.emphasizeAt = "Enfatiza en... (segundos)"
L.growingUpwards = "Crece hacia arriba"
L.growingUpwardsDesc = "Alterna el crecimiento hacia arriba o abajo desde el punto de anclaje."
L.texture = "Textura"
L.emphasize = "Enfatizar"
L.emphasizeMultiplier = "Multiplicador de tamaño"
L.emphasizeMultiplierDesc = "Si desactiva las barras moviéndose el anclaje enfatizado, esta opción decidirá el tamaño de las barras enfatizadas multiplicando el tamaño de las barras normales."

L.enable = "Habilitar"
L.move = "Mover"
L.moveDesc = "Mueve las barras enfatizadas al anclaje de Enfatizar. Si esta opción está deshabilitada, las barras enfatizadas simplemente cambiarán de tamaño y color."
L.regularBars = "Barras regulares"
L.emphasizedBars = "Barras enfatizadas"
L.align = "Alinear"
L.alignText = "Alinear el texto"
L.alignTime = "Alinear el tiempo"
L.left = "Izquierda"
L.center = "Centro"
L.right = "Derecha"
L.time = "Tiempo"
L.timeDesc = "Muestra u oculta el tiempo que queda en las barras."
L.textDesc = "Muestra u oculta el texto que aparece en las barras."
L.icon = "Ícono"
L.iconDesc = "Muestra u oculta los íconos de la barra."
L.iconPosition = "Posición del ícono"
L.iconPositionDesc = "Elige en qué lugar de la barra debe posicionarse el ícono."
L.font = "Fuenta"
L.restart = "Reiniciar"
L.restartDesc = "Reinicia las barras enfatizadas para que empiecen desde el principio y cuenten desde 10."
L.fill = "Llenar"
L.fillDesc = "Llena las barras en lugar de vaciarlas."
L.spacing = "Espaciado"
L.spacingDesc = "Cambie el espacio entre cada barra."
L.visibleBarLimit = "Límite de barras visibles"
L.visibleBarLimitDesc = "Establece la cantidad máxima de barras que son visibles al mismo tiempo."

L.localTimer = "Local"
L.timerFinished = "%s: Temporizador [%s] finalizado."
L.customBarStarted = "Barra personalizada '%s' iniciada por %s el jugador %s."
L.sendCustomBar = "Enviando barra personalizada '%s' para los usuarios de BigWigs y DBM."

L.requiresLeadOrAssist = "Esta función requiere ser el líder de banda o ayudante"
L.encounterRestricted = "Esta función no puede ser usada durante un encuentro."
L.wrongCustomBarFormat = "Formato incorrecto.Un ejemplo correcto es: /raidbar 20 text"
L.wrongTime = "Tiempo especificado inválido. <time> puede ser un número en segundos, un par M:S , o Mm. Por ejemplo 5, 1:20 o 2m."

L.wrongBreakFormat = "Debe ser entre 1 y 60 minutos. Un ejemplo correcto es: /break 5"
L.sendBreak = "Enviando un temporizador de descanso a los usuarios de BigWigs y DBM."
L.breakStarted = "Temporizador de descanso iniciado por %s el usuario %s."
L.breakStopped = "Temporizador de descanso cancelado por %s."
L.breakBar = "Tiempo de descanso"
L.breakMinutes = "El descanso termina en %d |4minuto:minutos;!"
L.breakSeconds = "El descanso termina en %d |4segundo:segundos;!"
L.breakFinished = "El descanso ha terminado!"

-----------------------------------------------------------------------
-- BossBlock.lua
--

L.bossBlock = "Bloque de Jefe"
L.bossBlockDesc = "Configura las diferentes cosas que puedes bloquear durante un encuentro con el jefe."
L.movieBlocked = "Ya has visto esta cinemática antes, saltándola."
L.blockEmotes = "Bloquear los emotes de la pantalla central"
L.blockEmotesDesc = "Algunos jefes muestran emotes para ciertas habilidades, estos mensajes son demasiado largos y descriptivos. Intentamos acortarlos, y ajustarlos para que no interfieran con el juego, y que no te digan específicamente qué tienes que hacer.\n\nTen en cuenta: Los emotes de Jefe seguirán siendo visibles en el chat si deseas leerlos."
L.blockMovies = "Bloquear las cinemáticas repetidas"
L.blockMoviesDesc = "Las cinemáticas de encuentros con el jefe sólo se podrán ver una vez (para que puedas ver cada una) y luego serán bloqueadas."
L.blockFollowerMission = "Bloquea las ventanas emergentes de los seguidores"
L.blockFollowerMissionDesc = "Las ventanas emergentes de las misiones de seguidores muestran algunas cosas, principalmente cuando una misión es completada.\n\nEstas ventanas emergentes pueden cubrir partes críticas de tu UI durante un encuentro con un jefe, así que recomendamos bloquearlos."
L.blockGuildChallenge = "Bloquea las ventanas emergentes de logros de hermandad"
L.blockGuildChallengeDesc = "Las ventanas emergentes de logros de hermandad muestran algunas cosas, principalmente cuando un grupo en tu hermandad completa un calabozo heroico o un calabozo en modo desafío.\n\nEstas ventanas emergentes pueden cubrir partes críticas de tu UI durante un encuentro con un jefe, así que recomendamos bloquearlos."
L.blockSpellErrors = "Bloquear mensajes de hechizos fallidos"
L.blockSpellErrorsDesc = "Mensajes tales como \"El hechizo no está listo aún\" que usualmente es mostrado en la parte de arriba de la pantalla serán bloqueados."
L.audio = "Audio"
L.music = "Música"
L.ambience = "Sonido ambiental"
L.sfx = "Efectos de sonido"
--L.disableMusic = "Mute music (recommended)"
--L.disableAmbience = "Mute ambient sounds (recommended)"
--L.disableSfx = "Mute sound effects (not recommended)"
L.disableAudioDesc = "La opción '%s' en las opciones de sonido de WoW será deshabilitada, luego se volverá a habilidad cuando el encuentro con el jefe termina. Esto puede ayudarte a enfocarte en los sonidos de alerta de BigWigs."
L.blockTooltipQuests = "Bloquea la ventana de información de los objetivos de misiones"
L.blockTooltipQuestsDesc = "Cuando necesitas matar a un jefe para una misión, normalmente se mostrará como '0/1 completado' en la ventana de información cuando pasas tu mouse sobre el jefe. Esto se esconderá durante el combate con ese jefe para evitar que la ventana de información crezca mucho."
L.blockObjectiveTracker = "Ocultar el seguimiento de misión"
L.blockObjectiveTrackerDesc = "El seguimiento de misión se ocultará durante encuentros de jefes para limpiar el espacio en pantalla.\n\nEsto no sucederá si estás en una mítica + o estás haciendo seguimiento de un logro."

L.subzone_grand_bazaar = "Gran Bazar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "Puerto de Zandalar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_eastern_transept = "Transepto del Este" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

L.colors = "Colores"

L.text = "Texto"
L.textShadow = "Sombra de texto"
L.flash = "Destello"
L.normal = "Normal"
L.emphasized = "Enfatizado"

L.reset = "Reajusta"
L.resetDesc = "Reajusta los colores anteriores a sus valores por defecto."
L.resetAll = "Reajustar todo"
L.resetAllDesc = "Si has personalizado los colores de cualquier encuentro con el jefe, este botón los reajustará TODOS para que se usen los colores definidos aquí."

L.red = "Rojo"
L.redDesc = "Alertas generales del encuentro."
L.blue = "Azul"
L.blueDesc = "Alertas por cosas que te afectan directamente, como un efecto maléfico que se te aplica."
L.orange = "Naranja"
L.yellow = "Amarillo"
L.green = "Verde"
L.greenDesc = "Advertencias para las cosas buenas que pasan, como que te quiten un efecto maléfico."
L.cyan = "Cian"
L.cyanDesc = "Advertencias para cambios de estado del encuentro, como el avance a la siguiente fase."
L.purple = "Morado"
L.purpleDesc = "Advertencias sobre las habilidades específicas de los tanques, como las acumulaciones de efectos negativos en un tanque."

-----------------------------------------------------------------------
-- Countdown.lua
--

L.superEmphasize = "Súper Enfatizar"
L.superEmphasizeDesc = "Mejora los mensajes o barras relacionados con una habilidad de un encuentro con el jefe.\n\nAquí se configura exactamente lo que debe suceder cuando se activa la opción de súper enfatizar en la sección avanzada para una habilidad de encuentro con el jefe.\n\n|cffff4411Ten en cuenta que el súper enfatizar está deshabilitado por defecto para todas las habilidades.|r\n"
L.uppercase = "MAYÚSCULAS"
L.uppercaseDesc = "Pone en mayúsculas todos los mensajes relacionados con una opción súper enfatizada."
L.superEmphasizeDisableDesc = "Deshabilitar el súper enfatizar para todos los módulos que lo utilizan."
L.textCountdown = "Cuenta regresiva de texto"
L.textCountdownDesc = "Muestra un contador visual durante una cuenta regresiva."
L.countdownColor = "Color de la cuenta regresiva"
L.countdownVoice = "Voz de la cuenta regresiva"
L.countdownTest = "Probar una cuenta regresiva"
L.countdownAt = "Cuenta regresiva en... (segundos)"
--L.countdownAt_desc = "Choose how much time should be remaining on a boss ability (in seconds) when the countdown begins."
--L.countdown = "Countdown"
--L.countdownDesc = "The countdown feature involves a spoken audio countdown and a visual text countdown. It can be enabled for any boss ability (in the boss abilities section) if the ability is on a timer, but is rarely enabled by default."
--L.countdownAudioHeader = "Spoken Audio Countdown"
--L.countdownTextHeader = "Visual Text Countdown"
--L.resetCountdownDesc = "Resets all the above countdown settings to their defaults."
--L.resetAllCountdownDesc = "If you've selected custom countdown voices for any boss encounter settings, this button will reset ALL of them as well as resetting all the above countdown settings to their defaults."

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infoBox = "InfoBox"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Dirige la salida de este complemento a través de la pantalla de mensajes de BigWigs. Esta pantalla soporta iconos, colores y puede mostrar hasta 4 mensajes en la pantalla a la vez. Los mensajes recién insertados crecerán en tamaño y se reducirán de nuevo rápidamente para notificar al usuario."
L.emphasizedSinkDescription = "Dirige la salida de este complemento a través de la pantalla de mensajes de BigWigs enfatizada. Esta pantalla admite texto y colores, y sólo puede mostrar un mensaje a la vez."
L.emphasizedCountdownSinkDescription = "Dirige la salida de este complemento a través de la pantalla de mensajes de BigWigs enfatizada en la cuenta regresiva. Esta pantalla admite texto y colores, y sólo puede mostrar un mensaje a la vez."
--L.resetMessagesDesc = "Reset all the options related to messages, including the position of the message anchors."

L.bwEmphasized = "BigWigs enfatizado"
L.messages = "Menajes"
L.normalMessages = "Mensajes normales"
L.emphasizedMessages = "Mensajes enfatizados"
L.output = "Resultado"

L.useIcons = "Usar íconos"
L.useIconsDesc = "Mostrar íconos al lado de los mensajes."
L.classColors = "Colores de clase"
L.classColorsDesc = "Colorea los nombres de los jugadores de acuerdo con su clase."

L.fontSize = "Tamaño de la fuente"
L.none = "Ninguno"
L.thin = "Delgado"
L.thick = "Grueso"
L.outline = "Contorno"
L.monochrome = "Monocromo"
L.monochromeDesc = "Cambia a modo monocromático, eliminando cualquier suavizado de los bordes de la fuente."
L.fontColor = "Color de la fuente"

L.displayTime = "Tiempo de visualización"
L.displayTimeDesc = "Cuánto tiempo mostrará un mensaje, en segundos."
L.fadeTime = "Tiempo de desvanecimiento"
L.fadeTimeDesc = "Cuánto tiempo tardará en desaparecer un mensaje, en segundos."

-----------------------------------------------------------------------
-- Proximity.lua
--

L.customRange = "Indicador de rango personalizado"
L.proximityTitle = "%d yd / %d |4jugador:jugadores;" -- yd = yards (short)
L.proximity_name = "Proximidad"
L.soundDelay = "Retraso de sonido"
L.soundDelayDesc = "Especifica el tiempo que BigWigs debería esperar entre cada repetición de sonido cuando alguien está demasiado cerca de ti."

L.proximity = "Pantalla de proximidad"
L.proximity_desc = "Muestra la ventana de proximidad cuando sea apropiado para este encuentro, enumerando los jugadores que están demasiado cerca de ti."
--L.resetProximityDesc = "Reset all the options related to proximity, including the position of the proximity anchor."

L.close = "Cerrar"
L.closeProximityDesc = "Cierra la ventana de proximidad.\n\nPara deshabilitarla completamente para un encuentro, debes ir a las opciones para ese encuentro module y deshabilitar la opción de 'Proximidad'."
L.lock = "Bloquear"
L.lockDesc = "Bloquea la ventana en el lugar en el que está, previniendo que esta sea movida o redimensionada."
L.title = "Título"
L.titleDesc = "Muestra u oculta el título."
L.background = "Fondo"
L.backgroundDesc = "Muestra u oculta el fondo."
L.toggleSound = "Cambiar sonido"
L.toggleSoundDesc = "Cambia si la ventana de proximidad debe sonar o no cuando estás demasiado cerca de otro jugador."
L.soundButton = "Botón de sonido"
L.soundButtonDesc = "Muestra u oculta el botón de sonido."
L.closeButton = "Botón cerrar"
L.closeButtonDesc = "Muestra u oculta el botón cerrar."
L.showHide = "Muestra/Oculta"
L.abilityName = "Nombre de la habilidad"
L.abilityNameDesc = "Muestra u oculta el nombre de la habilidad sobre la ventana."
L.tooltip = "Tooltip"
L.tooltipDesc = "Muestra u oculta la descripción del hechizo si la ventana de proximidad está ligada a una habilidad del jefe."

-----------------------------------------------------------------------
-- Pull.lua
--

L.countdownType = "Tipo de cuenta regresiva"
L.combatLog = "Registro automático de combate"
L.combatLogDesc = "Automáticamente comienza a registrar el combate cuando se inicia el temporizador de llamado de jefe y lo termina cuando acaba el encuentro."

L.pull = "Llamado de jefe"
L.engageSoundTitle = "Toca un sonido cuando un encuentro con el jefe haya comenzado"
L.pullStartedSoundTitle = "Toca un sonido cuando el temporizador de llamado de jefe es comenzado"
L.pullFinishedSoundTitle = "Toca un sonido cuando el temporizador de llamado de jefe termina"
L.pullStarted = "Temporizador de llamado de jefe empezado por %s el jugador %s."
L.pullStopped = "Temporizador de llamado de jefe cancelado por %s."
L.pullStoppedCombat = "Temporizador de llamado de jefe cancelado porque tu entraste en combate"
L.pullIn = "Llamado de jefe en %d seg"
L.sendPull = "Enviando un temporizador de llamado de jefe para los usuarios de BigWigs y DBM."
L.wrongPullFormat = "Debe estar entre 1 y 60 segundos. Un ejemplo correcto es: /pull 5"

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L.icons = "Íconos"
L.raidIconsDesc = "Algunos encuentros usan los iconos de banda para marcar jugadores de interés especial para tu grupo. Por ejemplo, los efectos tipo 'bomba' y control mental. Si la deshabilitas, no marcarás a nadie.\n\n|cffff4411¡Sólo se aplica si eres el líder del grupo o si te tienes ayudante!|r"
L.raidIconsDescription = "Algunos encuentros pueden incluir elementos como habilidades de tipo bomba dirigidas a un jugador específico, un jugador perseguido, o un jugador específico puede ser de interés. Aquí puedes personalizar los íconos de banda que deben utilizarse para marcar a estos jugadores.\n\nSi un encuentro sólo tiene una habilidad por la que vale la pena marcar, sólo se utilizará el primer icono. Un icono nunca se usará para dos habilidades diferentes en el mismo encuentro, y cualquier habilidad dada siempre usará el mismo icono la próxima vez.\n\n|cffff4411Ten en cuenta que si un jugador ya ha sido marcado manualmente, BigWigs nunca cambiará su icono.|r"
L.primary = "Primario"
L.primaryDesc = "El primer ícono de banda que un encuentro debería usar. "
L.secondary = "Secundario"
L.secondaryDesc = "El segundo ícono de banda que un encuentro debería usar."

-----------------------------------------------------------------------
-- Sound.lua
--

L.Sounds = "Sonidos"
--L.oldSounds = "Old Sounds"

L.Alarm = "Alarma"
L.Info = "Información"
L.Alert = "Alerta"
L.Long = "Largo"
L.Warning = "Alerta"
--L.onyou = "A spell, buff, or debuff is on you"
--L.underyou = "You need to move out of a spell under you"

L.sound = "Sonido"
L.soundDesc = "Los mensajes pueden venir con un sonido. A algunas personas les resulta más fácil escucharlos una vez que han aprendido qué sonido va con cada mensaje, en lugar de leer los mensajes reales."

L.customSoundDesc = "Reproduce el sonido personalizado seleccionado en lugar del suministrado por el módulo."
--L.resetSoundDesc = "Resets the above sounds to their defaults."
L.resetAllCustomSound = "Si has personalizado los sonidos para cualquier encuentro con el jefe, este botón los reajustará TODOS para que se usen los sonidos definidos aquí."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossDefeatDurationPrint = "Derrotado '%s' después de %s."
L.bossWipeDurationPrint = "Wipe en '%s' después de %s."
L.newBestTime = "¡Nuevo mejor tiempo!"
L.bossStatistics = "Estadísticas del jefe"
L.bossStatsDescription = "Registro de varias estadísticas relacionadas con los jefes, como la cantidad de veces que un jefe ha sido asesinado, la cantidad de wipes, el tiempo total que duró el combate o la muerte más rápida del jefe. Estas estadísticas pueden verse en la pantalla de configuración de cada jefe, pero se ocultarán para los jefes que no tengan estadísticas registradas."
L.enableStats = "Habilitar las estadísticas"
L.chatMessages = "Mensajes de chat"
L.printBestTimeOption = "Notificación de mejor tiempo"
L.printDefeatOption = "Tiempo de derrota"
L.printWipeOption = "Tiempo de wipe"
L.countDefeats = "Recuento de derrotas"
L.countWipes = "Recuento de wipes"
L.recordBestTime = "Recordar mejor tiempo"
L.createTimeBar = "Mostrar la barra 'Mejor tiempo'"
L.bestTimeBar = "Mejor tiempo"
L.printHealthOption = "Vida del jefe"
L.healthPrint = "Vida: %s."
L.healthFormat = "%s (%.1f%%)"

-----------------------------------------------------------------------
-- Victory.lua
--

L.Victory = "Victoria"
L.victoryHeader = "Configura las acciones que deben tomarse después de derrotar un encuentro con el jefe."
L.victorySound = "Reproduce un sonido de victoria"
L.victoryMessages = "Muestra los mensajes de derrota del jefe"
L.victoryMessageBigWigs = "Muestra el mensaje de BigWigs"
L.victoryMessageBigWigsDesc = "El mensaje de BigWigs es un simple mensaje de \"el jefe ha sido derrotado\""
L.victoryMessageBlizzard = "Muestra el mensaje de Blizzard"
L.victoryMessageBlizzardDesc = "El mensaje de Blizzard es una gran animación de \"el jefe ha sido derrotado\" en el centro de tu pantalla."
L.defeated = "%s ha sido derrotado"

-----------------------------------------------------------------------
-- Wipe.lua
--

L.wipe = "Wipe"
L.wipeSoundTitle = "Reproduce un sonido cuando tu wipeas"
L.respawn = "Reaparición"
L.showRespawnBar = "Muestra la barra de reaparición"
L.showRespawnBarDesc = "Muestra una barra después de que wipeas en un jefe mostrando el tiempo hasta que el jefe reaparezca."
