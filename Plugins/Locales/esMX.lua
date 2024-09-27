local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "esMX")
if not L then return end

L.general = "General"
--L.advanced = "Advanced"
L.comma = ", "

L.positionX = "Posición X"
L.positionY = "Posición Y"
L.positionExact = "Posicionamiento exacto"
L.positionDesc = "Escriba en el recuadro o mueva el deslizador si necesita un posicionamiento exacto desde el ancla."
L.width = "Anchura"
L.height = "Altura"
L.sizeDesc = "Normalmente se ajusta el tamaño arrastrando el ancla. Si necesitas un tamaño exacto puedes usar este deslizador o escribir el valor en el recuadro."
L.fontSizeDesc = "Ajuste el tamaño de la fuente utilizando el control deslizante o escriba el valor en la casilla que tiene un máximo de 200."
L.disabled = "Desactivado"
L.disableDesc = "Está a punto de desactivar la función '%s' que |cffff4411no se recomienda|r.\n\n¿Estás seguro de que quieres hacer esto?"

-- Anchor Points
--L.UP = "Up"
--L.DOWN = "Down"
--L.TOP = "Top"
--L.RIGHT = "Right"
--L.BOTTOM = "Bottom"
--L.LEFT = "Left"
--L.TOPRIGHT = "Top Right"
--L.TOPLEFT = "Top Left"
--L.BOTTOMRIGHT = "Bottom Right"
--L.BOTTOMLEFT = "Bottom Left"
--L.CENTER = "Center"
--L.customAnchorPoint = "Advanced: Custom anchor point"
--L.sourcePoint = "Source Point"
--L.destinationPoint = "Destination Point"

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "PoderAlternativo"
L.altPowerDesc = "La pantalla de Poder Alternativo sólo aparecerá para los jefes que apliquen Poder Alternativo a los jugadores, lo cual es extremadamente raro. La pantalla mide la cantidad de Poder Alternativo que tienes tú y tu grupo, mostrándolo en una lista. Para mover la pantalla, por favor usa el botón de prueba de abajo."
L.toggleDisplayPrint = "La pantalla mostrará la próxima vez. Para desactivarlo completamente para este encuentro, debes desactivarlo en las opciones del encuentro."
L.disabledDisplayDesc = "Desactiva la pantalla para todos los módulos que la utilicen."
L.resetAltPowerDesc = "Restablece todas las opciones relacionadas con el Poder Alterno, incluyendo la posición del ancla de este."
L.test = "Prueba"
L.altPowerTestDesc = "Muestra la pantalla de Poder Alternativo, permitiéndote moverlo, y simulando los cambios de poder que verías en un encuentro con un jefe."
L.yourPowerBar = "Tu barra de poder"
L.barColor = "Color de la barra"
L.barTextColor = "Color del texto de la barra"
L.additionalWidth = "Anchura adicional"
L.additionalHeight = "Altura adicional"
L.additionalSizeDesc = "Aumente el tamaño de la pantalla estándar ajustando este deslizador, o escriba el valor en la casilla que tiene un máximo de 100."
L.yourPowerTest = "Tu poder: %d" -- Your Power: 42
L.yourAltPower = "Tu %s: %d" -- e.g. Your Corruption: 42
L.player = "Jugador %d" -- Player 7
L.disableAltPowerDesc = "Desactiva la pantalla de Poder Alternativo, nunca se mostrará para ningún encuentro con el jefe."

-----------------------------------------------------------------------
-- AutoReply.lua
--

L.autoReply = "Respuesta automática"
L.autoReplyDesc = "Automáticamente responde a los que te susurran cuando estás ocupado durante un encuentro."
L.responseType = "Tipo de respuesta"
L.autoReplyFinalReply = "También susurra cuando acabas el combate"
L.guildAndFriends = "Hermandad y amigos"
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
L.bigWigsBarStyleName_Default = "Predeterminado"
L.resetBarsDesc = "Restablece todas las opciones relacionadas con las barras, incluyendo la posición de anclas de este."
L.testBarsBtn = "Crear barra de prueba"
L.testBarsBtn_desc = "Crea barras para que las pruebes con los ajustes actuales"

L.toggleAnchorsBtnShow = "Mostrar anclajes móviles"
L.toggleAnchorsBtnHide = "Ocultar anclajes móviles"
L.toggleAnchorsBtnHide_desc = "Oculta todos los anclajes móviles, bloqueanto todo en su lugar."
L.toggleBarsAnchorsBtnShow_desc = "Muestra todos los anclajes móviles, permitiendo mover las barras."

L.emphasizeAt = "Enfatiza en... (segundos)"
L.growingUpwards = "Crecer hacia arriba"
L.growingUpwardsDesc = "Alterna el crecimiento hacia arriba o abajo desde el punto de anclaje."
L.texture = "Textura"
L.emphasize = "Enfatizar"
L.emphasizeMultiplier = "Multiplicador de tamaño"
L.emphasizeMultiplierDesc = "Si desactiva las barras moviéndose el anclaje enfatizado, esta opción decidirá el tamaño de las barras enfatizadas multiplicando el tamaño de las barras normales."

L.enable = "Activar"
L.move = "Mover"
L.moveDesc = "Mueve las barras enfatizadas al anclaje de Enfatizar. Si esta opción está desactivada, las barras enfatizadas simplemente cambiarán de tamaño y color."
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
L.icon = "Icono"
L.iconDesc = "Muestra u oculta los iconos de la barra."
L.iconPosition = "Posición del icono"
L.iconPositionDesc = "Elige en qué lugar de la barra debe posicionarse el icono."
L.font = "Fuente"
L.restart = "Restablecer"
L.restartDesc = "Restablece las barras enfatizadas para que empiecen desde el principio y cuenten desde 10."
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
L.breakMinutes = "¡El descanso termina en %d |4minuto:minutos;!"
L.breakSeconds = "¡El descanso termina en %d |4segundo:segundos;!"
L.breakFinished = "¡El descanso ha terminado!"

-----------------------------------------------------------------------
-- BossBlock.lua
--

L.bossBlock = "Bloque de jefe"
L.bossBlockDesc = "Configura las diferentes cosas que puedes bloquear durante un encuentro con el jefe.\n\n"
L.bossBlockAudioDesc = "Configura qué sonido silenciar durante un encuentro con un jefe.\n\nCualquier opción aquí que está |cff808080grisada|r ha sido desactivada en las opciones de sonido de WoW.\n\n"
L.movieBlocked = "Ya has visto esta cinemática antes, saltándola."
L.blockEmotes = "Bloquear emociones de la pantalla central"
L.blockEmotesDesc = "Algunos jefes muestran emociones para ciertas habilidades, estos mensajes son demasiado largos y descriptivos. Intentamos acortarlos, y ajustarlos para que no interfieran con el juego, y que no te digan específicamente qué tienes que hacer.\n\nTen en cuenta: Las emociones de Jefe seguirán siendo visibles en el chat si deseas leerlos."
L.blockMovies = "Bloquear las cinemáticas repetidas"
L.blockMoviesDesc = "Las cinemáticas de encuentros con el jefe sólo se podrán ver una vez (para que puedas ver cada una) y luego serán bloqueadas."
L.blockFollowerMission = "Bloquea las ventanas emergentes de los seguidores"
L.blockFollowerMissionDesc = "Las ventanas emergentes de las misiones de seguidores muestran algunas cosas, principalmente cuando una misión es completada.\n\nEstas ventanas emergentes pueden cubrir partes críticas de tu UI durante un encuentro con un jefe, así que recomendamos bloquearlos."
L.blockGuildChallenge = "Bloquea las ventanas emergentes de logros de hermandad"
L.blockGuildChallengeDesc = "Las ventanas emergentes de logros de hermandad muestran algunas cosas, principalmente cuando un grupo en tu hermandad completa un calabozo heroico o un calabozo en modo desafío.\n\nEstas ventanas emergentes pueden cubrir partes críticas de tu UI durante un encuentro con un jefe, así que recomendamos bloquearlos."
L.blockSpellErrors = "Bloquear mensajes de hechizos fallidos"
L.blockSpellErrorsDesc = "Mensajes tales como \"El hechizo no está listo aún\" que usualmente es mostrado en la parte de arriba de la pantalla serán bloqueados."
L.blockZoneChanges = "Bloquear mensajes de cambio de zona"
L.blockZoneChangesDesc = "Los mensajes que se muestran en la parte del medio superior de la pantalla cuando cambias de zona, como '|cFF33FF99Ventormenta|r' u '|cFF33FF99Orgrimmar|r', se bloquearán."
L.audio = "Audio"
L.music = "Música"
L.ambience = "Sonido ambiental"
L.sfx = "Efectos de sonido"
L.errorSpeech = "Sonidos de error"
L.disableMusic = "Silenciar la música (recomendado)"
L.disableAmbience = "Silenciar sonidos ambientales (recomendado)"
L.disableSfx = "Silenciar efectos de sonido (no recomendado)"
L.disableErrorSpeech = "Silenciar sonidos de error (recomendado)"
L.disableAudioDesc = "La opción '%s' en las opciones de sonido de WoW será desactivada, luego se volverá a habilidad cuando el encuentro con el jefe termina. Esto puede ayudarte a enfocarte en los sonidos de alerta de BigWigs."
L.blockTooltipQuests = "Bloquea la ventana de información de los objetivos de misiones"
L.blockTooltipQuestsDesc = "Cuando necesitas matar a un jefe para una misión, normalmente se mostrará como '0/1 completado' en la ventana de información cuando pasas tu mouse sobre el jefe. Esto se esconderá durante el combate con ese jefe para evitar que la ventana de información crezca mucho."
L.blockObjectiveTracker = "Ocultar el seguimiento de misión"
L.blockObjectiveTrackerDesc = "El seguimiento de misión se ocultará durante encuentros de jefes para limpiar el espacio en pantalla.\n\nEsto no sucederá si estás en una mítica + o estás haciendo seguimiento de un logro."

L.blockTalkingHead = "Ocultar la ventana emergente de diálogo 'Cabeza Parlante' del PNJ"
L.blockTalkingHeadDesc = "La 'Cabeza Parlante' es un cuadro de diálogo emergente que tiene una cabeza de PNJ y un texto de chat de PNJ en la parte media-baja de tu pantalla que |cffff4411en ocasiones|r muestra cuando un PNJ está hablando.\n\nPuedes elegir los diferentes tipos de instancias en las que esto debe ser bloqueado para que no se muestre.\n\n|cFF33FF99Ten en cuenta:|r\n 1) Esta característica permitirá que la voz del PNJ se continúe reproduciéndo para que puedas seguir escuchándola.\n 2) Por seguridad, sólo se bloquearán cabezas parlantes específicas. Cualquier cosa especial o única, como una búsqueda única, no se bloqueará."
L.blockTalkingHeadDungeons = "Calabozos Normales & Heroicos"
L.blockTalkingHeadMythics = "Calabozos Míticos y Míticos+"
L.blockTalkingHeadRaids = "Bandas"
L.blockTalkingHeadTimewalking = "Cronoviaje (Calabozos & Bandas)"
L.blockTalkingHeadScenarios = "Escenarios"

L.redirectPopups = "Redirigir carteles emergentes a mensajes de BigWigs"
--L.redirectPopupsDesc = "Popup banners in the middle of your screen such as the '|cFF33FF99vault slot unlocked|r' banner will instead be displayed as BigWigs messages. Estos carteles pueden ser bastante grandes, durar mucho tiempo y bloquear la posibilidad de hacer clic en ellos."
L.redirectPopupsColor = "Color del mensaje redirigido"
L.blockDungeonPopups = "Bloquear carteles emergentes de calabozos"
L.blockDungeonPopupsDesc = "Los carteles emergentes que se muestran al entrar a un calabozo a veces pueden contener texto muy largo. Al activar esta función los bloqueará completamente."
L.itemLevel = "Nivel de objeto %d"

L.userNotifySfx = "BossBlock desactivó los efectos de sonido, lo que obligó a volver a activarlos."
L.userNotifyMusic = "BossBlock desactivó la música, lo que obligó a volver a activarla."
L.userNotifyAmbience = "BossBlock desactivó el ambiente, lo que obligó a volver a activarlo."
L.userNotifyErrorSpeech = "BossBlock desactivó el aviso de error, lo que obligó a volver a activarlo."

L.subzone_grand_bazaar = "Gran Bazar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "Puerto de Zandalar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_eastern_transept = "Transepto del Este" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

L.colors = "Colores"

L.text = "Texto"
L.textShadow = "Sombra de texto"
L.normal = "Normal"
L.emphasized = "Enfatizado"

L.reset = "Restablecer"
L.resetDesc = "Restablece los colores anteriores a sus valores predeterminados."
L.resetAll = "Restablecer todo"
L.resetAllDesc = "Si has personalizado los colores de cualquier encuentro con el jefe, este botón los restablecerá TODOS para que se usen los colores definidos aquí."

L.red = "Rojo"
L.redDesc = "Alertas generales del encuentro."
L.blue = "Azul"
L.blueDesc = "Alertas por cosas que te afectan directamente, como un efecto maléfico que se te aplica."
L.orange = "Naranja"
L.yellow = "Amarillo"
L.green = "Verde"
L.greenDesc = "Avisos para las cosas buenas que pasan, como que te quiten un efecto maléfico."
L.cyan = "Cian"
L.cyanDesc = "Avisos para cambios de estado del encuentro, como el avance a la siguiente fase."
L.purple = "Morado"
L.purpleDesc = "Avisos sobre las habilidades específicas de los tanques, como las acumulaciones de efectos negativos en un tanque."

-----------------------------------------------------------------------
-- Countdown.lua
--

L.textCountdown = "Cuenta regresiva de texto"
L.textCountdownDesc = "Muestra un contador visual durante una cuenta regresiva."
L.countdownColor = "Color de la cuenta regresiva"
L.countdownVoice = "Voz de la cuenta regresiva"
L.countdownTest = "Probar cuenta regresiva"
L.countdownAt = "Cuenta regresiva en... (segundos)"
L.countdownAt_desc = "Elige cuánto tiempo le queda a la habilidad del jefe (en segundos) cuando la cuenta regresiva comience."
L.countdown = "Cuenta regresiva"
L.countdownDesc = "La característica de la cuenta regresiva implica una cuenta regresiva de audio hablado y una cuenta regresiva de texto visual. Rara vez está activada de forma predeterminada, pero puedes activarla para cualquier habilidad del jefe al mirar la configuración específica del encuentro con el jefe."
L.countdownAudioHeader = "Cuenta regresiva de audio hablada"
L.countdownTextHeader = "Cuenta regresiva de texto"
L.resetCountdownDesc = "Restablece todos los ajustes anteriores de la cuenta regresiva a sus valores predeterminados."
L.resetAllCountdownDesc = "Si has seleccionado voces de cuenta regresiva personalizadas para cualquier configuración de encuentro con el jefe, este botón restablecerá TODAS ellas, así como todos los ajustes de cuenta regresiva anteriores a sus valores predeterminados."

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infoBox = "Caja de información"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Dirige la salida de este complemento a través de la pantalla de mensajes de BigWigs. Esta pantalla soporta iconos, colores y puede mostrar hasta 4 mensajes en la pantalla a la vez. Los mensajes recién insertados crecerán en tamaño y se reducirán de nuevo rápidamente para notificar al usuario."
L.emphasizedSinkDescription = "Dirige la salida de este complemento a través de la pantalla de mensajes de BigWigs enfatizada. Esta pantalla admite texto y colores, y sólo puede mostrar un mensaje a la vez."
L.resetMessagesDesc = "Restablece todas las opciones relacionadas con los mensajes, incluyendo la posición de anclas de este."
L.toggleMessagesAnchorsBtnShow_desc = "Muestra todos los anclajes móviles, permitiendo mover los mensajes."

--L.testMessagesBtn = "Create Test Message"
--L.testMessagesBtn_desc = "Creates a message for you to test your current display settings with."

L.bwEmphasized = "BigWigs enfatizado"
L.messages = "Mensajes"
L.emphasizedMessages = "Mensajes enfatizados"
L.emphasizedDesc = "El punto de un mensaje enfatizado es conseguir su atención siendo un mensaje grande en el medio de su pantalla. Rara vez está activado de forma predeterminada, pero puedes activarlo para cualquier habilidad del jefe cuando mires la configuración específica del encuentro con el jefe."
L.uppercase = "MAYÚSCULAS"
L.uppercaseDesc = "Todos los mensajes enfatizados se convertirán en MAYÚSCULAS."

L.useIcons = "Usar iconos"
L.useIconsDesc = "Mostrar iconos al lado de los mensajes."
L.classColors = "Colores de clase"
L.classColorsDesc = "Los mensajes a veces contienen nombres de jugadores. Al activar esta opción, esos nombres serán coloreados con los colores de la clase."
L.chatFrameMessages = "Mensajes del marco de chat"
L.chatFrameMessagesDesc = "Todos los mensajes de salida de BigWigs a la ventana de chat por defecto en adición a los ajustes mostrados"

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
-- Nameplates.lua
--

--L.nameplates = "Nameplates"
--L.testNameplateIconBtn = "Show Test Icon"
--L.testNameplateIconBtn_desc = "Creates a test icon for you to test your current display settings with on your targeted nameplate."
--L.testNameplateTextBtn = "Show Text Test"
--L.testNameplateTextBtn_desc = "Creates a test text for you to test your current text settings with on your targeted nameplate."
--L.stopTestNameplateBtn = "Stop Tests"
--L.stopTestNameplateBtn_desc = "Stops the icon and text tests on your nameplates."
--L.noNameplateTestTarget = "You need to have a hostile target which is attackable selected to test nameplate functionality."
--L.anchoring = "Anchoring"
--L.growStartPosition = "Grow Start Position"
--L.growStartPositionDesc = "The starting position for the first icon."
--L.growDirection = "Grow Direction"
--L.growDirectionDesc = "The direction the icons will grow from the starting position."
--L.iconSpacingDesc = "Change the space between each icon."
--L.nameplateIconSettings = "Icon Settings"
--L.keepAspectRatio = "Keep Aspect Ratio"
--L.keepAspectRatioDesc = "Keep the aspect ratio of the icon 1:1 instead of stretching it to fit the size of the frame."
--L.iconColor = "Icon Color"
--L.iconColorDesc = "Change the color of the icon texture."
--L.desaturate = "Desaturate"
--L.desaturateDesc = "Desaturate the icon texture."
--L.zoom = "Zoom"
--L.zoomDesc = "Zoom the icon texture."
--L.showBorder = "Show Border"
--L.showBorderDesc = "Show a border around the icon."
--L.borderColor = "Border Color"
--L.borderSize = "Border Size"
--L.showNumbers = "Show Numbers"
--L.showNumbersDesc = "Show numbers on the icon."
--L.cooldown = "Cooldown"
--L.showCooldownSwipe = "Show Swipe"
--L.showCooldownSwipeDesc = "Show a swipe on the icon when the cooldown is active."
--L.showCooldownEdge = "Show Edge"
--L.showCooldownEdgeDesc = "Show an edge on the cooldown when the cooldown is active."
--L.inverse = "Inverse"
--L.inverseSwipeDesc = "Invert the cooldown animations."
--L.glow = "Glow"
--L.enableExpireGlow = "Enable Expire Glow"
--L.enableExpireGlowDesc = "Show a glow around the icon when the cooldown has expired."
--L.glowColor = "Glow Color"
--L.glowType = "Glow Type"
--L.glowTypeDesc = "Change the type of glow that is shown around the icon."
--L.resetNameplateIconsDesc = "Reset all the options related to nameplate icons."
--L.nameplateTextSettings = "Text Settings"
--L.fixate_test = "Fixate Test" -- Text that displays to test on the frame
--L.resetNameplateTextDesc = "Reset all the options related to nameplate text."
--L.autoScale = "Auto Scale"
--L.autoScaleDesc = "Automatically change scale according to the nameplate scale."
--L.glowAt = "Begin Glow (seconds)"
--L.glowAt_desc = "Choose how many seconds on the cooldown should be remaining when the glow begins."

-- Glow types as part of LibCustomGlow
--L.pixelGlow = "Pixel Glow"
--L.autocastGlow = "Autocast Glow"
--L.buttonGlow = "Button Glow"
--L.procGlow = "Proc Glow"
--L.speed = "Speed"
--L.animation_speed_desc = "The speed at which the glow animation plays."
--L.lines = "Lines"
--L.lines_glow_desc = "The number of lines in the glow animation."
--L.intensity = "Intensity"
--L.intensity_glow_desc = "The intensity of the glow effect, higher means more sparks."
--L.length = "Length"
--L.length_glow_desc = "The length of the lines in the glow animation."
--L.thickness = "Thickness"
--L.thickness_glow_desc = "The thickness of the lines in the glow animation."
--L.scale = "Scale"
--L.scale_glow_desc = "The scale of the sparks in the animation."
--L.startAnimation = "Start Animation"
--L.startAnimation_glow_desc = "This glow has a starting animation, this will enable/disable that animation."

-----------------------------------------------------------------------
-- Proximity.lua
--

L.customRange = "Indicador de rango personalizado"
L.proximityTitle = "%d yd / %d |4jugador:jugadores;" -- yd = yards (short)
L.proximity_name = "Proximidad"
L.soundDelay = "Retraso de sonido"
L.soundDelayDesc = "Especifica el tiempo que BigWigs debería esperar entre cada repetición de sonido cuando alguien está demasiado cerca de ti."

L.resetProximityDesc = "Restablece todas las opciones relacionadas con las proximidad, incluyendo la posición de anclas de este."

L.close = "Cerrar"
L.closeProximityDesc = "Cierra la ventana de proximidad.\n\nPara desactivarla completamente para un encuentro, debes ir a las opciones para ese encuentro module y desactivar la opción de 'Proximidad'."
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
L.showHide = "Mostrar/ocultar"
L.abilityName = "Nombre de habilidad"
L.abilityNameDesc = "Muestra u oculta el nombre de la habilidad sobre la ventana."
L.tooltip = "Tooltip"
L.tooltipDesc = "Muestra u oculta la descripción del hechizo si la ventana de proximidad está ligada a una habilidad del jefe."

-----------------------------------------------------------------------
-- Pull.lua
--

L.countdownType = "Tipo de cuenta regresiva"
L.combatLog = "Registro automático de combate"
L.combatLogDesc = "Automáticamente comienza a registrar el combate cuando se inicia el temporizador de llamada de jefe y lo termina cuando acaba el encuentro."

L.pull = "Llamada de jefe"
L.engageSoundTitle = "Toca un sonido cuando un encuentro con el jefe haya comenzado"
L.pullStartedSoundTitle = "Toca un sonido cuando el temporizador de llamada de jefe se comienza"
L.pullFinishedSoundTitle = "Toca un sonido cuando el temporizador de llamada de jefe se termina"
--L.pullStartedBy = "Pull timer started by %s."
L.pullStopped = "Temporizador de llamada de jefe cancelado por %s."
L.pullStoppedCombat = "Temporizador de llamada de jefe cancelado porque tu entraste en combate"
L.pullIn = "Llamada de jefe en %d seg"
--L.sendPull = "Sending a pull timer to your group."
--L.wrongPullFormat = "Invalid pull timer. A correct example is: /pull 5"
L.countdownBegins = "Comenzar cuenta regresiva"
L.countdownBegins_desc = "Elige cuánto tiempo restante debe de quedar en la llamada de jefe (en segundos) cuando la cuenta regresiva comience."

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L.icons = "Iconos"
L.raidIconsDescription = "Algunos encuentros pueden incluir elementos como habilidades de tipo bomba dirigidas a un jugador específico, un jugador perseguido, o un jugador específico puede ser de interés. Aquí puedes personalizar los iconos de banda que deben utilizarse para marcar a estos jugadores.\n\nSi un encuentro sólo tiene una habilidad por la que vale la pena marcar, sólo se utilizará el primer icono. Un icono nunca se usará para dos habilidades diferentes en el mismo encuentro, y cualquier habilidad dada siempre usará el mismo icono la próxima vez.\n\n|cffff4411Ten en cuenta que si un jugador ya ha sido marcado manualmente, BigWigs nunca cambiará su icono.|r"
L.primary = "Primario"
L.primaryDesc = "El primer icono de banda que un encuentro debería usar. "
L.secondary = "Secundario"
L.secondaryDesc = "El segundo icono de banda que un encuentro debería usar."

-----------------------------------------------------------------------
-- Sound.lua
--

L.Sounds = "Sonidos"
L.soundsDesc = "BigWigs utiliza el canal de sonido 'General' para reproducir todos sus sonidos. Si encuentras que los sonidos son demasiado silenciosos o demasiado fuertes, abre la configuración de sonido de WoW y ajusta el deslizador de 'Volumen general' a un nivel que te guste.\n\nA continuación puedes configurar globalmente los diferentes sonidos que se reproducen para acciones específicas, o ponerlos en 'Ninguno' para desactivarlos. Si sólo quieres cambiar un sonido para una habilidad específica del jefe, puedes hacerlo en la configuración del encuentro con el jefe.\n\n"
L.oldSounds = "Sonidos viejos"

L.Alarm = "Alarma"
L.Info = "Información"
L.Alert = "Alerta"
L.Long = "Largo"
L.Warning = "Aviso"
L.onyou = "Una hechizo, efecto o perjuicio está en ti"
L.underyou = "Debes moverte fuera del hechizo que está debajo de ti"
--L.privateaura = "Whenever a 'Private Aura' is on you"

L.sound = "Sonido"

L.customSoundDesc = "Reproduce el sonido personalizado seleccionado en lugar del suministrado por el módulo."
L.resetSoundDesc = "Restablece los sonidos anteriores a sus valores predeterminados."
L.resetAllCustomSound = "Si has personalizado los sonidos para cualquier encuentro con el jefe, este botón los restablecerá TODOS para que se usen los sonidos definidos aquí."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossStatistics = "Estadísticas del jefe"
L.bossStatsDescription = "Recording of various boss-related statistics such as the amount of times you were victorious, the amount of times you were defeated, date of first victory, and the fastest victory. Estas estadísticas pueden verse en la pantalla de configuración de cada jefe, pero se ocultarán para los jefes que no tengan estadísticas registradas."
L.createTimeBar = "Mostrar la barra 'Mejor tiempo'"
L.bestTimeBar = "Mejor tiempo"
L.healthPrint = "Vida: %s."
L.healthFormat = "%s (%.1f%%)"
L.chatMessages = "Mensajes de chat"
--L.newFastestVictoryOption = "New fastest victory"
--L.victoryOption = "You were victorious"
--L.defeatOption = "You were defeated"
L.bossHealthOption = "Vida del jefe"
--L.bossVictoryPrint = "You were victorious against '%s' after %s." -- You were victorious against 'BOSS_NAME' after COMBAT_DURATION.
--L.bossDefeatPrint = "You were defeated by '%s' after %s." -- You were defeated by 'BOSS_NAME' after COMBAT_DURATION.
--L.newFastestVictoryPrint = "New fastest victory: (-%s)" -- New fastest victory: (-COMBAT_DURATION)

-----------------------------------------------------------------------
-- Victory.lua
--

L.Victory = "Victoria"
L.victoryHeader = "Configura las acciones que deben tomarse después de derrotar un encuentro con el jefe."
L.victorySound = "Reproduce un sonido de victoria"
L.victoryMessages = "Muestra los mensajes de derrota del jefe"
L.victoryMessageBigWigs = "Mostrar el mensaje de BigWigs"
L.victoryMessageBigWigsDesc = "El mensaje de BigWigs es un simple mensaje de \"el jefe ha sido derrotado\""
L.victoryMessageBlizzard = "Mostrar el mensaje de Blizzard"
L.victoryMessageBlizzardDesc = "El mensaje de Blizzard es una gran animación de \"el jefe ha sido derrotado\" en el centro de tu pantalla."
L.defeated = "%s ha sido derrotado"

-----------------------------------------------------------------------
-- Wipe.lua
--

L.wipe = "Derrota"
L.wipeSoundTitle = "Reproduce un sonido cuando tú mueres por un jefe"
L.respawn = "Reaparición"
L.showRespawnBar = "Mostrar la barra de reaparición"
L.showRespawnBarDesc = "Muestra una barra después de que mueres por un jefe mostrando el tiempo hasta que el jefe reaparezca."
