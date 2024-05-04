local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "esES")
if not L then return end

L.general = "General"
L.comma = ", "

L.positionX = "Posición X"
L.positionY = "Posición Y"
L.positionExact = "Posicionamiento preciso"
L.positionDesc = "Introduce o mueve el deslizador si necesitas posicionar de manera precisa desde el anclaje."
L.width = "Ancho"
L.height = "Alto"
L.sizeDesc = "Normalmente ajusta el tamaño deslizando por la barra. Si necesitas un tamaño exacto puedes usar este deslizador o teclea el valor dentro de la caja, no tiene máximo."
L.fontSizeDesc = "Ajusta el tamaño de la letra con el control deslizante o escribe el valor en la casilla cuyo máximo es 200."
L.disableDesc = "Estás a punto de desactivar la función '%s', aunque |cffff4411no se recomienda|r.\n\n¿Estás seguro de que quieres hacerlo?"
L.transparency = "Transparencia"

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "Poder alternativo"
L.altPowerDesc = "El marco de poder alternativo solo aparecerá en los jefes que utilicen el poder alternativo con los jugadores, lo cual es muy poco frecuente. El marco mide la cantidad de 'Poder alternativo' que tienes tú y tu grupo, mostrándolo en una lista. Para mover el marco, utiliza el botón de prueba de abajo."
L.toggleDisplayPrint = "El marco se mostrará la próxima vez. Para desactivarlo completamente para este encuentro, tienes que desactivarlo en las opciones del encuentro."
L.disabled = "Desactivado"
L.disabledDisplayDesc = "Desactiva el marco para todos los módulos que lo utilicen."
L.resetAltPowerDesc = "Restablece todas las opciones relacionadas con Poder alternativo, incluida la posición del ancla del marco."
L.test = "Prueba"
L.altPowerTestDesc = "Muestra el marco de 'Poder alternativo', permitiéndote moverlo y simulando los cambios de poder que verías en un encuentro con un jefe."
L.yourPowerBar = "Tu barra de energía"
L.barColor = "Color de la barra"
L.barTextColor = "Color del texto de la barra"
L.additionalWidth = "Anchura adicional"
L.additionalHeight = "Altura adicional"
L.additionalSizeDesc = "Aumenta el tamaño del marco estándar ajustando este deslizador, o escribe el valor en la casilla cuyo máximo es 100."
L.yourPowerTest = "Tu energía: %d" -- Your Power: 42
L.yourAltPower = "Tu %s: %d" -- e.g. Your Corruption: 42
L.player = "Jugador %d" -- Player 7
L.disableAltPowerDesc = "Desactiva globalmente el marco de Poder alternativo, nunca se mostrará en ningún encuentro con jefes."

-----------------------------------------------------------------------
-- AutoReply.lua
--

L.autoReply = "Respuesta automática"
L.autoReplyDesc = "Responde automáticamente a los susurros cuando participes en un encuentro con un jefe."
L.responseType = "Tipo de respuesta"
L.autoReplyFinalReply = "También susurra cuando acabas el combate"
L.guildAndFriends = "Hermandad y amigos"
L.everyoneElse = "Todos los demás"

L.autoReplyBasic = "Estoy ocupado luchando contra un jefe."
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
L.resetBarsDesc = "Restablece todas las opciones relacionadas con las barras, incluida la posición de los anclajes."

L.nameplateBars = "Barras en placas de nombre"
L.nameplateAutoWidth = "Igualar anchura de la placa de nombre"
L.nameplateAutoWidthDesc = "Ajusta la anchura de las barras de la placa a la de su placa padre."
L.nameplateOffsetY = "Desplazamiento Y"
L.nameplateOffsetYDesc = "Desplazamiento desde la parte superior de la placa para barras ascendentes y desde la parte inferior para barras descendentes."
L.nameplateAlphaDesc = "Controla el nivel de transparencia de las barras de la placa."

L.clickableBars = "Barras clicables"
L.clickableBarsDesc = "Las barras de BigWigs son clicables por defecto. De este modo, puedes seleccionar objetos o lanzar hechizos AoE detrás de ellas, cambiar el ángulo de la cámara, etc., mientras el cursor está sobre las barras. |cffff4411Si activas las barras clicables, esto dejará de funcionar.|r Las barras interceptarán cualquier clic del ratón que hagas sobre ellas.\n"
L.interceptMouseDesc = "Permite que las barras reciban clics del ratón."
L.modifier = "Modificador"
L.modifierDesc = "Mantén pulsada la tecla modificadora seleccionada para activar las acciones de clic en las barras del temporizador."
L.modifierKey = "Solo con la tecla modificadora"
L.modifierKeyDesc = "Permite hacer clic en las barras a menos que se mantenga pulsada la tecla modificadora especificada, en cuyo caso estarán disponibles las acciones del ratón que se describen a continuación."

L.temporaryCountdownDesc = "Activa temporalmente la cuenta atrás en la habilidad asociada a esta barra."
L.report = "Informar"
L.reportDesc = "Informa del estado actual de las barras al chat de grupo activo; ya sea chat de instancia, banda, grupo o decir, según corresponda."
L.remove = "Eliminar"
L.removeBarDesc = "Elimina temporalmente esta barra."
L.removeOther = "Eliminar las otras"
L.removeOtherBarDesc = "Elimina temporalmente todas las demás barras (excepto esta)."

L.emphasizeAt = "Enfatizar en... (segundos)"
L.growingUpwards = "Crecer ascendente"
L.growingUpwardsDesc = "Cambia el crecimiento hacia arriba o hacia abajo desde el punto de anclaje."
L.texture = "Textura"
L.emphasize = "Enfatizar"
L.emphasizeMultiplier = "Multiplicador de tamaño"
L.emphasizeMultiplierDesc = "Si desactivas que las barras se muevan al ancla de Enfatizar, esta opción decidirá qué tamaño tendrán las barras enfatizadas multiplicando el tamaño de las barras normales."

L.enable = "Activar"
L.move = "Mover"
L.moveDesc = "Mueve las barras enfatizadas al ancla de Enfatizar. Si esta opción está desactivada, las barras enfatizadas simplemente cambiarán de tamaño y color."
L.emphasizedBars = "Barras enfatizadas"
L.align = "Alineación"
L.alignText = "Alinear texto"
L.alignTime = "Alinear tiempo"
L.left = "Izquierda"
L.center = "Centro"
L.right = "Derecha"
L.time = "Tiempo"
L.timeDesc = "Mostrar u ocultar el tiempo restante en las barras."
L.textDesc = "Mostrar u ocultar el texto que aparece en las barras."
L.icon = "Icono"
L.iconDesc = "Muestra u oculta los iconos de las barras."
L.iconPosition = "Posición del icono"
L.iconPositionDesc = "Elige en qué parte de la barra debe colocarse el icono."
L.font = "Fuente"
L.restart = "Reiniciar"
L.restartDesc = "Reinicia las barras enfatizadas para que empiecen desde el principio y cuenten desde 10."
L.fill = "Llenar"
L.fillDesc = "Llena las barras en lugar de vaciarlas."
L.spacing = "Espaciado"
L.spacingDesc = "Cambia el espacio entre cada barra."
L.visibleBarLimit = "Límite de barras visibles"
L.visibleBarLimitDesc = "Establece la cantidad máxima de barras visibles al mismo tiempo."

L.localTimer = "Local"
L.timerFinished = "%s: Contador [%s] terminado."
L.customBarStarted = "Barra personalizada '%s' iniciada por el jugador %s %s."
L.sendCustomBar = "Enviando barra personalizada '%s' a usuarios de BigWigs y DBM."

L.requiresLeadOrAssist = "Esta función requiere ser líder de banda o asistente de banda."
L.encounterRestricted = "Esta función no se puede usar durante un encuentro."
L.wrongCustomBarFormat = "Formato incorrecto. Un ejemplo sería: /raidbar 20 texto"
L.wrongTime = "Tiempo especificado no válido. <time> puede ser un número en segundos, una combinación M:S o Mm. Por ejemplo 5, 1:20 o 2m."

L.wrongBreakFormat = "Debe estar entre 1 y 60 minutos. Un ejemplo correcto es: /break 5"
L.sendBreak = "Enviando un temporizador de descanso a los usuarios de BigWigs y DBM."
L.breakStarted = "Tiempo de descanso iniciado por %s (%s)."
L.breakStopped = "Descanso cancelado por %s."
L.breakBar = "Tiempo de descanso"
L.breakMinutes = "¡El descanso termina en %d |4minuto:minutos;!"
L.breakSeconds = "¡El descanso termina en %d |4segundo:segundos;!"
L.breakFinished = "¡El descanso ha terminado!"

-----------------------------------------------------------------------
-- BossBlock.lua
--

L.bossBlock = "Bloque de jefe"
L.bossBlockDesc = "Configura varias cosas que puedes bloquear durante un encuentro.\n\n"
L.bossBlockAudioDesc = "Configura qué audio silenciar durante un encuentro con un jefe.\n\nCualquier opción que esté |cff808080griseada|r ha sido desactivada en las opciones de sonido de WoW.\n\n"
L.movieBlocked = "Ya has visto esta cinemática antes, omitiéndola."
L.blockEmotes = "Bloquear emociones del centro de la pantalla"
L.blockEmotesDesc = "Algunos jefes muestran emotes para ciertas habilidades, estos mensajes son demasiado largos y descriptivos. Intentamos acortarlos, y ajustarlos para que no interfieran con el juego, y que no te digan específicamente qué tienes que hacer.\n\nTen en cuenta: los emotes de Jefe seguirán siendo visibles en el chat si deseas leerlos."
L.blockMovies = "Bloquear vídeos repetidos"
L.blockMoviesDesc = "Las cinemáticas de encuentros con jefes solo se reproducirán una vez (para que puedas ver cada una de ellas) y luego se bloquearán."
L.blockFollowerMission = "Bloquear las ventanas emergentes de las misiones de los seguidores"
L.blockFollowerMissionDesc = "Las ventanas emergentes de las misiones de los seguidores se muestran para algunas cosas, pero principalmente cuando se completa una misión de los seguidores.\n\nEstas ventanas emergentes pueden tapar partes críticas de la interfaz durante un combate contra un jefe, así que recomendamos bloquearlas."
L.blockGuildChallenge = "Bloquear ventanas emergentes de hermandad"
L.blockGuildChallengeDesc = "Los logros de hermandad muestran ventanas emergentes, principalmente cuando un grupo de tu hermandad completa una mazmorra heroica o un desafío.\n\nEstas ventanas pueden cubrir partes críticas de tu interfaz durante un encuentro, así que recomendamos bloquearlas."
L.blockSpellErrors = "Bloquear mensajes de hechizos fallidos"
L.blockSpellErrorsDesc = "Mensajes como \"Ese hechizo no está listo todavía\" que normalmente se muestran arriba de la pantalla serán bloqueados."
L.blockZoneChanges = "Bloquear mensajes de cambio de zona"
L.blockZoneChangesDesc = "Los mensajes que se muestran en la parte del medio superior de la pantalla cuando cambias de zona como '|cFF33FF99Ventormenta|r' u '|cFF33FF99Orgrimmar|r' serán bloqueados."
L.audio = "Audio"
L.music = "Música"
L.ambience = "Sonido ambiental"
L.sfx = "Efectos de sonido"
L.errorSpeech = "Sonidos de error"
L.disableMusic = "Silenciar música (recomendado)"
L.disableAmbience = "Silenciar sonidos ambientales (recomendado)"
L.disableSfx = "Silenciar efectos de sonido (no recomendado)"
L.disableErrorSpeech = "Silenciar la voz de error (recomendado)"
L.disableAudioDesc = "La opción de '%s' en las opciones de sonido de WoW se desactivará, luego se vovlerá a activar cuando el encuentro con el jefe finalice. Esto puede ayudarte a concentrarte en los sonidos de avisos de BigWigs."
L.blockTooltipQuests = "Bloquear los objetivos de misión del tooltip"
L.blockTooltipQuestsDesc = "Cuando necesites matar a un jefe para una misión, normalmente se mostrará como '0/1 completado' en la descripción emergente cuando sitúes el ratón sobre el jefe. Esto se ocultará durante el combate con el jefe para evitar que haya demasiada información en el tooltip."
L.blockObjectiveTracker = "Ocultar seguimiento de misión"
L.blockObjectiveTrackerDesc = "El seguimiento de misiones se ocultará durante el encuentro con un jefe para no ocupar espacio en la pantalla.\n\nEsto NO ocurrirá si estás en un mítica+ o si estás siguiendo un logro."

L.blockTalkingHead = "Ocultar la ventana de diálogo de 'cabeza parlante' del PNJ"
L.blockTalkingHeadDesc = "La 'cabeza parlante' es un cuadro de diálogo emergente que tiene una cabeza de PNJ y un texto de chat de PNJ en la parte inferior central de la pantalla que |cffff4411a veces|r se muestra cuando un PNJ está hablando.\n\nPuedes elegir los diferentes tipos de instancias en las que se debe bloquear su visualización.\n\n|cFF33FF99Ten en cuenta:|r\n 1) Esta función permitirá que la voz del PNJ continúe reproduciéndose para que puedas seguir escuchándola.\n 2) Por seguridad, solo se bloquearán las cabezas parlantes especificadas. Cualquier cosa especial o única, como una misión única, no se bloqueará."
L.blockTalkingHeadDungeons = "Mazmorras normales y heroicas"
L.blockTalkingHeadMythics = "Mazmorras míticas y míticas+."
L.blockTalkingHeadRaids = "Bandas"
L.blockTalkingHeadTimewalking = "Paseo en el tiempo (mazmorras y bandas)"
L.blockTalkingHeadScenarios = "Escenarios"

L.redirectPopups = "Redirigir los carteles emergentes a mensajes de BigWigs"
L.redirectPopupsDesc = "Los carteles emergentes que aparecen el medio de tu pantalla como '|cFF33FF99recompensa de la gran cámara desbloqueada|r' o el cartel que ves al entrar en una mazmorra mítica+ serán bloqueados y en su lugar se mostrarán como mensajes de BigWigs. Estos carteles pueden ser bastante grandes, durar mucho tiempo y bloquear tu capacidad de hacer clic a través de ellos."
L.redirectPopupsColor = "Color del mensaje redirigido"
L.blockDungeonPopups = "Bloquear los carteles emergentes de mazmorras"
L.blockDungeonPopupsDesc = "Los carteles emergentes que aparecen cuando entras a una mazmorras pueden contener texto que es muy largo. Activar esta opcion los bloqueara directamente en vez de ser redigidos a un mensaje de BigWigs."
L.itemLevel = "Nivel de objeto %d"

L.userNotifySfx = "Los efectos de sonido fueron desactivados por el Bloque de jefe, forzándolos a volver a activarse."
L.userNotifyMusic = "La música fue desactivada por el Bloque de jefe, forzándola a volver a activarse."
L.userNotifyAmbience = "Los efectos de ambiente fueron desactivados por el Bloque de jefe, forzándolos a volver a activarse."
L.userNotifyErrorSpeech = "La voz de error fue desactivada por el Bloque de jefe, forzándola a volver a activarse."

L.subzone_grand_bazaar = "Gran Bazar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "Puerto de Zandalar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_eastern_transept = "Transepto oriental" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

L.colors = "Colores"

L.text = "Texto"
L.textShadow = "Sombra de texto"
L.normal = "Normal"
L.emphasized = "Enfatizado"

L.reset = "Reiniciar"
L.resetDesc = "Reinicia los colores por defecto"
L.resetAll = "Resetear todo"
L.resetAllDesc = "Si has personalizado los colores de cualquier encuentro, este botón los reiniciará TODOS para que se utilicen los colores definidos aquí."

L.red = "Rojo"
L.redDesc = "Avisos generales para encuentros."
L.blue = "Azul"
L.blueDesc = "Avisos para cosas que te afectan directamente, como un debuff que se te aplica."
L.orange = "Naranja"
L.yellow = "Amarillo"
L.green = "Verde"
L.greenDesc = "Avisos para cosas buenas que ocurren, como que se te quite un debuff."
L.cyan = "Cian"
L.cyanDesc = "Avisos de cambios de estado de los encuentros, como avanzar a la siguiente fase."
L.purple = "Morado"
L.purpleDesc = "Avisos para habilidades específicas de los tanques, como acumulaciones de un debuff en un tanque."

-----------------------------------------------------------------------
-- Countdown.lua
--

L.textCountdown = "Texto de cuenta atrás"
L.textCountdownDesc = "Muestra un contador visual durante una cuenta atrás"
L.countdownColor = "Color de cuenta atrás"
L.countdownVoice = "Voz de cuenta atrás"
L.countdownTest = "Probar cuenta atrás"
L.countdownAt = "Cuenta atrás en... (segundos)"
L.countdownAt_desc = "Elige cuánto tiempo debe quedar para que empiece la cuenta atrás de una habilidad de jefe (en segundos)."
L.countdown = "Cuenta atrás"
L.countdownDesc = "La función de cuenta atrás incluye una cuenta atrás sonora hablada y una cuenta atrás de texto visual. Rara vez está activada por defecto, pero puedes activarla para cualquier habilidad de jefe en la configuración específica del encuentro con el jefe."
L.countdownAudioHeader = "Cuenta atrás de audio hablada"
L.countdownTextHeader = "Cuenta atrás visual de texto"
L.resetCountdownDesc = "Restablece todos los ajustes de cuenta atrás anteriores a sus valores predeterminados."
L.resetAllCountdownDesc = "Si has seleccionado voces de cuenta atrás personalizadas para cualquier configuración de encuentro con jefe, este botón las restablecerá TODAS, así como restablecerá todas las configuraciones de cuenta atrás anteriores a sus valores predeterminados."

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infoBox = "Mensajes"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Envía la salida de este addon a través de la pantalla de mensajes de BigWigs. Esta pantalla soporta iconos, colores y puede mostrar hasta 4 mensajes en la pantalla a la vez. Los mensajes recién insertados crecerán en tamaño y se reducirán de nuevo rápidamente para notificar al usuario."
L.emphasizedSinkDescription = "Envía la salida de este addon a través de la pantalla de mensajes enfatizados de BigWigs. Esta pantalla admite texto y colores, y solo puede mostrar un mensaje a la vez."
L.resetMessagesDesc = "Restablece todas las opciones relacionadas con los mensajes, incluida la posición de los anclajes de los mensajes."

L.bwEmphasized = "BigWigs enfatizado"
L.messages = "Mensajes"
L.emphasizedMessages = "Mensajes enfatizados"
L.emphasizedDesc = "El objetivo de un mensaje enfatizado es llamar tu atención por ser un mensaje grande en medio de la pantalla. Rara vez está activado por defecto, pero puedes activarlo para cualquier habilidad de jefe cuando revises los ajustes específicos del encuentro con un jefe."
L.uppercase = "MAYÚSCULAS"
L.uppercaseDesc = "Todos los mensajes enfatizados se convertirán a MAYÚSCULAS."

L.useIcons = "Usar iconos"
L.useIconsDesc = "Mostrar iconos junto a los mensajes."
L.classColors = "Colores de clase"
L.classColorsDesc = "Los mensajes a veces contienen nombres de jugadores. Si activas esta opción, esos nombres se colorearán con los colores de la clase."
L.chatFrameMessages = "Mensajes al chat"
L.chatFrameMessagesDesc = "Envía todos los mensajes de BigWigs al cuadro de chat predeterminado, además de a la pantalla configurada."

L.fontSize = "Tamaño de la fuente"
L.none = "Ninguno"
L.thin = "Fino"
L.thick = "Grueso"
L.outline = "Contorno"
L.monochrome = "Monocromo"
L.monochromeDesc = "Activa la opción monocromo, eliminando el suavizado de los bordes de la fuente."
L.fontColor = "Color de la fuente"

L.displayTime = "Muestra la hora"
L.displayTimeDesc = "Cuánto tiempo mostrar un mensaje, en segundos"
L.fadeTime = "Tiempo de desaparición"
L.fadeTimeDesc = "Cuánto tiempo tardará en desaparecer un mensaje, en segundos"

-----------------------------------------------------------------------
-- Proximity.lua
--

L.customRange = "Indicador de rango personalizado"
L.proximityTitle = "%d m / %d |4jugador:jugadores;" -- yd = yards (short)
L.proximity_name = "Proximidad"
L.soundDelay = "Retardo de sonido"
L.soundDelayDesc = "Especifica el tiempo que BigWigs debería esperar entre cada repetición de sonido cuando alguien está demasiado cerca de ti."

L.resetProximityDesc = "Restablece todas las opciones relacionadas con la proximidad, incluida la posición del ancla de proximidad."

L.close = "Cerrar"
L.closeProximityDesc = "Cierra la ventana de proximidad.\n\nPara desactivarla completamente para un encuentro, tienes que ir a las opciones para ese encuentro y desactivar la opción de 'Proximidad'."
L.lock = "Bloquear"
L.lockDesc = "Bloquea la ventana en el lugar, previniendo que se mueva y redimensione"
L.title = "Título"
L.titleDesc = "Muestra/oculta el título"
L.background = "Fondo"
L.backgroundDesc = "Muestra/oculta el fondo"
L.toggleSound = "Cambiar sonido"
L.toggleSoundDesc = "Activada o no la ventana de proximidad debería emitir un beep si estás cerca de otro jugador."
L.soundButton = "Botón de sonido"
L.soundButtonDesc = "Muestra/oculta el botón de sonido"
L.closeButton = "Boton cerrar"
L.closeButtonDesc = "Muestra/oculta el botón de cerrar"
L.showHide = "Mostrar/ocultar"
L.abilityName = "Nombre de habilidad"
L.abilityNameDesc = "Muestra/oculta el nombre de la habilidad encima de la ventana"
L.tooltip = "Tooltip"
L.tooltipDesc = "Muestra/oculta la descripción del hechizo si la ventana de proximidad esta ligada a una habilidad del jefe."

-----------------------------------------------------------------------
-- Pull.lua
--

L.countdownType = "Tipo de cuenta atrás"
L.combatLog = "Registro automático de combates"
L.combatLogDesc = "Iniciar automáticamente el registro del combate cuando se inicia un temporizador de pull y finalizarlo cuando termina el encuentro."

L.pull = "Pull"
L.engageSoundTitle = "Reproduce un sonido cuando comienza un encuentro"
L.pullStartedSoundTitle = "Reproduce un sonido cuando se inicia el temporizador de pull"
L.pullFinishedSoundTitle = "Reproduce un sonido cuando finalice el temporizador de pull"
L.pullStarted = "Cuenta atrás para el pull iniciada por el jugador %s %s."
--L.pullStartedBy = "Pull timer started by %s."
L.pullStopped = "Pull cancelado por %s."
L.pullStoppedCombat = "Temporizador de pull cancelado porque entraste en combate."
L.pullIn = "Pull en %d seg"
L.sendPull = "Enviando temporizador de pull a usuarios de BigWigs y DBM."
L.wrongPullFormat = "Debe estar entre 1 y 60 segundos. Por ejemplo: /pull 5"
L.countdownBegins = "Comienzo de la cuenta atrás"
L.countdownBegins_desc = "Elige cuánto tiempo debe quedar en el temporizador de pull (en segundos) para que comience la cuenta atrás."

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L.icons = "Iconos"
L.raidIconsDescription = "Algunos encuentros pueden incluir elementos como habilidades de tipo bomba dirigidas a un jugador específico, un jugador perseguido, o un jugador específico puede ser de interés de otras maneras. Aquí puedes personalizar qué iconos de banda deben usarse para marcar a estos jugadores.\n\nSi un encuentro solo tiene una habilidad que merece la pena marcar, solo se utilizará el primer icono. Nunca se usará un icono para dos habilidades diferentes en el mismo encuentro, y cualquier habilidad dada siempre usará el mismo icono la próxima vez.\n\n|cffff4411Ten en cuenta que si un jugador ha sido marcado manualmente, BigWigs nunca cambiará su icono.|r"
L.primary = "Principal"
L.primaryDesc = "El primer icono de objetivo de banda que se debe utilizar en un encuentro."
L.secondary = "Secundario"
L.secondaryDesc = "El segundo icono de objetivo de banda que se debe utilizar en un encuentro."

-----------------------------------------------------------------------
-- Sound.lua
--

L.Sounds = "Sonidos"
L.soundsDesc = "BigWigs utiliza el canal de sonido 'General' para reproducir todos sus sonidos. Si consideras que los sonidos son demasiado silenciosos o demasiado altos, abre la configuración de sonido de WoW y ajusta el deslizador de 'Volumen general' a un nivel que te guste.\n\nAbajo puedes configurar globalmente los diferentes sonidos que se reproducen para acciones específicas, o ponerlos en 'None' para desactivarlos. Si solo quieres cambiar un sonido para una habilidad específica de un jefe, puedes hacerlo en los ajustes del encuentro con el jefe.\n\n"
L.oldSounds = "Sonidos antiguos"

L.Alarm = "Alarma"
L.Info = "Informativo"
L.Alert = "Alerta"
L.Long = "Largo"
L.Warning = "Advertencia"
L.onyou = "Un hechizo, beneficio o perjuicio te afecta"
L.underyou = "Necesitas salir de un hechizo que hay debajo de ti"

L.sound = "Sonido"

L.customSoundDesc = "Reproduce el sonido personalizado seleccionado en lugar del proporcionado por el módulo."
L.resetSoundDesc = "Restablece los sonidos anteriores a sus valores predeterminados."
L.resetAllCustomSound = "Si has personalizado sonidos para algún encuentro con jefes, este botón los reiniciará TODOS para que se utilicen los sonidos definidos aquí."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossDefeatDurationPrint = "Derrotado '%s' después de %s."
L.bossWipeDurationPrint = "Wipe en '%s' después de %s."
L.newBestTime = "¡Nueva muerte más rápida!"
L.bossStatistics = "Estadísticas de jefe"
L.bossStatsDescription = "Registro de estadísticas de jefes, como el número de veces que ha sido derrotado, cantidad de wipes, tiempo total que duró el combate, o la muerte más rápida. Estas estadísticas se pueden ver en la ventana de configuración de cada jefe, pero permanecerán ocultas en los jefes que no tengan todavía registro de estadísticas."
L.enableStats = "Activar estadísticas"
L.chatMessages = "Mensajes de chat"
L.printBestTimeOption = "Notificar muerte más rápida"
L.printDefeatOption = "Tiempo de la muerte"
L.printWipeOption = "Tiempo del wipe"
L.countDefeats = "Contar muertes"
L.countWipes = "Contar wipes"
L.recordBestTime = "Recordar muertes más rápidas"
L.createTimeBar = "Mostrar barra de 'Mejor tiempo'"
L.bestTimeBar = "Mejor tiempo"
L.printHealthOption = "Salud del jefe"
L.healthPrint = "Salud: %s."
L.healthFormat = "%s (%.1f%%)"

-----------------------------------------------------------------------
-- Victory.lua
--

L.Victory = "Victoria"
L.victoryHeader = "Configura las acciones que se deberían realizar después de derrotar un jefe."
L.victorySound = "Reproduce un sonido de victoria"
L.victoryMessages = "Mostrar mensajes de jefe derrotado"
L.victoryMessageBigWigs = "Muestra el mensaje de BigWigs"
L.victoryMessageBigWigsDesc = "El mensaje de BigWigs es un simple mensaje de \"el jefe ha sido derrotado\"."
L.victoryMessageBlizzard = "Muestra el mensaje de Blizzard"
L.victoryMessageBlizzardDesc = "El mensaje de Blizzard es una animación muy grande de \"el jefe ha sido derrotado\" en medio de la pantalla."
L.defeated = "%s ha sido derrotado"

-----------------------------------------------------------------------
-- Wipe.lua
--

L.wipe = "Derrota"
L.wipeSoundTitle = "Reproduce un sonido cuando tú mueres por un jefe"
L.respawn = "Reaparición"
L.showRespawnBar = "Muestra la barra de reaparición"
L.showRespawnBarDesc = "Muestra una barra después de que mueres por un jefe mostrando el tiempo hasta que el jefe reaparezca."
