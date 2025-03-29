local L = BigWigsAPI:NewLocale("BigWigs", "esES")
if not L then return end

-- Core.lua
L.berserk = "Rabia"
L.berserk_desc = "Muestra un contador que avisa cuando el jefe entrará en rabia"
L.altpower = "Indicador de poder alternativo"
L.altpower_desc = "Muestra la ventana de poder alternativo, que indica la cantidad de poder alternativo que tienen los miembros de tu grupo."
L.infobox = "Caja de información"
L.infobox_desc = "Muestra un marco con información relacionada con el encuentro."
L.stages = "Fases"
L.stages_desc = "Activa funciones relacionadas con varias etapas/fases del jefe como cambios de etapa, barras de temporizador de duración de etapa, etc."
L.warmup = "Calentamiento"
L.warmup_desc = "Tiempo hasta que el combate con el jefe comience."
L.proximity = "Visualizar proximidad"
L.proximity_desc = "Muestra la ventana de proximidad cuando sea apropidada para este encuentro, lista los jugadores que están demasiado cerca tuya."
L.adds = "Esbirros"
L.adds_desc = "Activa funciones relacionadas con los esbirros que aparecerán durante un encuentro con un jefe."
L.health = "Salud"
L.health_desc = "Activa funciones para mostrar varias informaciones de salud durante un encuentro con un jefe."

L.already_registered = "|cffff0000ATENCIóN:|r |cff00ff00%s|r (|cffffff00%s|r) ya existe ese módulo en BigWigs, pero sin embargo está intentando registrarlo de nuevo. Esto normalmente ocurre cuando tienes varias copias de este módulo en tu carpeta de addons posiblemente por una actualización fallida. Es recomendable que borres la carpeta de BigWigs y lo reinstales por completo."

-- Loader / Options.lua
L.okay = "Aceptar"
L.officialRelease = "Estás usando la versión oficial de BigWigs %s (%s)"
L.alphaRelease = "Estás usando la VERSIÓN ALFA de BigWigs %s (%s)"
L.sourceCheckout = "Estás usando la versión de BigWigs %s directamente del repositorio."
L.littlewigsOfficialRelease = "Estás usando la versión oficial de LittleWigs (%s)"
L.littlewigsAlphaRelease = "Estás usando la VERSIÓN ALFA de LittleWigs (%s)"
L.littlewigsSourceCheckout = "Estás usando la versión de LittleWigs directamente del repositorio."
L.guildRelease = "Estás usando la vestión de BigWigs %d hecha para tu hermandad, basada en la versión %d del addon oficial."
L.getNewRelease = "Tu BigWigs está desfasado (/bwv) pero puedes actualizarlo fácilmente con el cliente de CurseForge. También puedes actualizarlo manualmente desde curseforge.com o wowinterface.com."
L.warnTwoReleases = "Tu BigWigs está 2 versiones desfasado! Tu versión puede tener fallos, faltarle características, o temporizadores incorrectos. Es muy recomendable que lo actualices."
L.warnSeveralReleases = "|cffff0000Tu BigWigs está desfasado %d actualizaciones!! Te recomendamos MUCHÍSIMO que lo actualices cuanto antes para prevenir problemas de sincronización con otros jugadores!|r"
L.warnOldBase = "Estás usando un versión de hermandad de BigWigs (%d), pero tu versión de base (%d) está desfasada de %d actualizaciones. Ésto puede causar problemas."

L.tooltipHint = "|cffeda55fClic derecho|r para acceder a las opciones."
L.activeBossModules = "Módulos de jefes activos:"

L.oldVersionsInGroup = "Alguien de tu grupo tiene la versión |cffff0000older versions|r de BigWigs. Para más detalles escribe /bwv."
L.upToDate = "Al día:"
L.outOfDate = "Desactualizado"
L.dbmUsers = "Jugadores con DBM:"
L.noBossMod = "Sin boss mod:"
L.offline = "Desconectado"

L.missingAddOnPopup = "No se encuentra el addon |cFF436EEE%s|r !"
L.missingAddOnRaidWarning = "No se encuentra el addon |cFF436EEE%s|r ! No se mostrarán temporizadores en esta zona."
L.outOfDateAddOnPopup = "El addon |cFF436EEE%s|r está desactualizado!"
L.outOfDateAddOnRaidWarning = "El addon |cFF436EEE%s|r está desactualizado. Tienes v%s.%s.%s%s la última es v%d.%d.%d!"
L.disabledAddOn = "Tienes el addon |cFF436EEE%s|r deshabilitado, los contadores no se mostraran."
L.removeAddOn = "Por favor elimina '|cFF436EEE%s|r' ya que está siendo reemplazado por '|cFF436EEE%s|r'."
L.alternativeName = "%s (|cFF436EEE%s|r)"
L.outOfDateContentPopup = "¡ADVERTENCIA!\nHas actualizado |cFF436EEE%s|r pero también necesitas actualizar el addon principal |cFF436EEEBigWigs|r.\nIgnorar esto resultará en un mal funcionamiento."
L.outOfDateContentRaidWarning = "|cFF436EEE%s|r requiere la versión %d del addon principal |cFF436EEEBigWigs|r para funcionar correctamente, pero estás en la versión %d."

L.expansionNames = {
	"Classic", -- Classic
	"The Burning Crusade", -- The Burning Crusade
	"Wrath of the Lich King", -- Wrath of the Lich King
	"Cataclysm", -- Cataclysm
	"Mists of Pandaria", -- Mists of Pandaria
	"Warlords of Draenor", -- Warlords of Draenor
	"Legion", -- Legion
	"Battle for Azeroth", -- Battle for Azeroth
	"Shadowlands", -- Shadowlands
	"Dragonflight", -- Dragonflight
	"The War Within", -- The War Within
}
L.littleWigsExtras = {
	["LittleWigs_Delves"] = "Delves",
	["LittleWigs_CurrentSeason"] = "Temporada actual",
}

-- Media.lua (These are the names of the sounds in the dropdown list in the "sounds" section)
L.Beware = "Cuidado (Algalon)"
L.FlagTaken = "Bandera tomada (JcJ)"
L.Destruction = "Destrucción (Kil'jaeden)"
L.RunAway = "Corre pequeña (El Lobo Feroz)"
L.spell_on_you = "BigWigs: Hechizo sobre tí"
L.spell_under_you = "BigWigs: Hechizo debajo de tí"

-- Options.lua
L.options = "Opciones"
L.optionsKey = "ID: %s" -- The ID that messages/bars/options use
L.raidBosses = "Jefes de Banda"
L.dungeonBosses = "Jefes de Mazmorras"
L.introduction = "Bienvenido a BigWigs. Abróchese el cinturón y a comer cacahuetes mientras disfrutas del paseo. De manera no intrusiva te ayudará a preparar ese nuevo encuentro de banda como una cena de 7 platos para tu grupo de banda."
L.sound = "Sonido"
L.minimapIcon = "Icono del minimapa"
L.minimapToggle = "Cambia entre mostrar/ocultar el icono en el minimapa."
L.compartmentMenu = "Sin icono de compartimento"
L.compartmentMenu_desc =  "Desactivar esta opcion hará que BigWigs no se muestre en el menu de compartimiento de addons. Recomendamos dejar esta opción activada."
L.configure = "Configurar"
L.resetPositions = "Reiniciar posiciones"
L.colors = "Colores"
L.selectEncounter = "Seleccionar encuentro"
L.privateAuraSounds = "Sonidos de Aura Privada"
L.privateAuraSounds_desc = "Las auras privadas no pueden ser rastreadas normalmente, pero puedes configurar un sonido para que se reproduzca cuando seas el objetivo de la habilidad."
L.listAbilities = "Listar las habilidades en el chat"

L.dbmFaker = "Fingir que estoy usando DBM"
L.dbmFakerDesc = "Si un usuario de DBM hace un chequeo de versión para ver quien está usando DBM, ellos te verán a ti en la lista. Muy útil para guilds que forzan a usar DBM."
L.zoneMessages = "Mostrar mensajes de la zona"
L.zoneMessagesDesc = "Desactivando esto dejará de mostrar mensajes cuando entres en una zona donde BigWigs tenga un modulo, pero no lo tengas instalado. Recomendamos que dejes esto activo pues será la única notificación que recibirás si creamos módulos nuevos para una zona que encontréis útil"
L.englishSayMessages = "Mensajes de texto solo en inglés"
L.englishSayMessagesDesc = "Todos los mensajes de 'decir' y 'gritar' que envíes en el chat durante un encuentro con un jefe siempre estarán en inglés. Puede resultar útil si estás con un grupo de jugadores que mezclan idiomas."

L.slashDescTitle = "|cFFFED000Atajo de comandos:|r"
L.slashDescPull = "|cFFFED000/pull:|r Envia una cuenta atrás de puleo a tu raid."
L.slashDescBreak = "|cFFFED000/break:|r Crea un temporizador de descanso para tu raid."
L.slashDescRaidBar = "|cFFFED000/raidbar:|r Envia una barra personalizada a tu raid."
L.slashDescLocalBar = "|cFFFED000/localbar:|r Crea una barra personal que solo puedes ver tu."
L.slashDescRange = "|cFFFED000/range:|r Abre el indicador de rango."
L.slashDescVersion = "|cFFFED000/bwv:|r Realiza un chequeo de versiónes de BigWigs."
L.slashDescConfig = "|cFFFED000/bw:|r Abre la configuración de BigWigs."

L.gitHubDesc = "|cFF33FF99BigWigs es de código abierto alojado en GitHub. Siempre estamos buscando gente para ayudarnos y cualquiera es bienvenido para inspeccionar nuestro código, hacer contribuciones y reportar errores. BigWigs es tan genial a día de hoy en gran parte por la gran comunidad de WoW que nos ayuda.|r"

L.BAR = "Barras"
L.MESSAGE = "Mensajes"
L.ICON = "Icono"
L.SAY = "Decir"
L.FLASH = "Destello"
L.EMPHASIZE = "Enfatizar"
L.ME_ONLY = "En mi únicamente"
L.ME_ONLY_desc = "Cuando activas esta opción los mensajes para esta habilidad solo serán mostrados cuando te afecten. Por ejemplo, 'Bomba: Jugador' solo se mostrará si está en ti."
L.PULSE = "Pulso"
L.PULSE_desc = "Para complementar el flash de pantalla, también puedes tener un icono relacionado con esta habilidad especifica que se mostrará momentáneamente en el medio de la pantalla para tratar de atraer tu atención."
L.MESSAGE_desc = "La mayoria de las abilidades de los encuentros se presentan con uno o más mensajes que BigWigs mostrará en tu pantalla. Si desactivas esta opción, ningún mensaje de esta opción, si lo hay, será mostrado en pantalla."
L.BAR_desc = "Las barras serán mostradas en el momento apropiado. Si esta habilidad está acompañada por una barra que quieres ocultar, desactiva esta opción."
L.FLASH_desc = "Algunas habilidades son más importantes que otras. Si quieres ver un flash cuando esta habilidad sea inminente o usada, activa esta opción."
L.ICON_desc = "BigWigs puede marcar personajes afectados por habilidades con un icono. Esto hace que sea más fácil detectarlos."
L.SAY_desc = "Los bocadillos de chat son fáciles de ver. BigWigs usará un mensaje para anunciar a la gente cercana sobre un efecto en ti."
L.EMPHASIZE_desc = "Activando esto enfatizará algunos mensajes asociados con esta habilidad, haciéndolos más grandes y visibles. Puedes ajustar el tamaño y la fuente de los mensajes enfatizados en las opciones principales debajo de \"Mensajes\"."
L.PROXIMITY = "Ventana de proximidad"
L.PROXIMITY_desc = "La ventana de proximidad se ajustará especificamente para esa habilidad para que sepas de un vistazo si estás a salvo o no."
L.ALTPOWER = "Indicador de poder alternativo"
L.ALTPOWER_desc = "Algunos encuentros usarán la mecánica de poder alternativo en jugadores de tu grupo. El indicador de poder alternativo proporciona un breve repaso sobre quien tiene menos/más poder alternativo, lo que puede ser útil para tácticas o asignaciones especificas."
L.TANK = "Tanques únicamente"
L.TANK_desc = "Algunas habilidades son importantes solo para tanques. Si quieres ver advertencias para este tipo de habilidades independientemente de tu rol, desactiva esta opción."
L.HEALER = "Sanadores únicamente"
L.HEALER_desc = "Algunas habilidades sólo son importantes para sanadores. Si quieres ver alertas para este tipo de habilidades independientemente de tu rol, desactiva esta opción."
L.TANK_HEALER = "Sólo Tanques y Sanadores"
L.TANK_HEALER_desc = "Algunas habilidades son importantes solo para tanques y sanadores. Si quieres ver advertencias para este tipo de habilidades independientemente de tu rol, desactiva esta opción."
L.DISPEL = "Disipables únicamente"
L.DISPEL_desc = "Si quieres ver avisos para esta habilidad incluso cuando no puedas disiparla, desactiva esta opción."
L.VOICE = "Voz"
L.VOICE_desc = "Si tienes un plugin de voz instalado, esta opción le permitirá reproducir un archivo de sonido que hable en este aviso para ti."
L.COUNTDOWN = "Cuenta atrás"
L.COUNTDOWN_desc = "Si está activo, una cuenta atrás vocal y visual será agregada para los últimos 5 segundos. Imagina a alguien contando hacia atrás \"5... 4... 3... 2... 1...\" con un número grande en el medio de la pantalla."
L.CASTBAR_COUNTDOWN = "Cuenta atrás (solo para barras de lanzamiento)"
L.CASTBAR_COUNTDOWN_desc = "Si está activo, una cuenta atrás vocal y visual se añadirá para los ultimos 5 segundos de las barras de lanzamiento."
L.INFOBOX = L.infobox
L.INFOBOX_desc = L.infobox_desc
L.SOUND = "Sonido"
L.SOUND_desc = "Las habilidades de jefes habitualmente reproducen sonidos para ayudarte con ellas. Si desactivas esta opción, ningún sonido adjunto sonará."
L.CASTBAR = "Barras de lanzamiento"
L.CASTBAR_desc = "Barras de lanzamiento se muestran a veces con ciertos jefes, normalmente para atraer la atención de que una habilidad crítica está en camino. Si esta habilidad está acompañada por una barra de lanzamiento que quieres ocultar, desactiva esta opción."
L.SAY_COUNTDOWN = "Decir cuenta atrás"
L.SAY_COUNTDOWN_desc = "Las burbujas de chat son fáciles de detectar. BigWigs usará múltiples mensajes de cuenta atrás para alertar a los que estén cerca que una habilidad en ti está a punto de expirar."
L.ME_ONLY_EMPHASIZE = "Enfatizar (sólo en mi)"
L.ME_ONLY_EMPHASIZE_desc = "Habilitar esto enfatizará cualquier mensaje asociado con esta habilidad SOLO si se lanza sobre ti, mostrandolo más grande y visible."
L.NAMEPLATE = "Placas de Nombre"
L.NAMEPLATE_desc = "Si está habilitado, características como íconos y texto relacionados con esta habilidad específica se mostrarán en tus placas de nombre. Esto facilita ver qué NPC específico está lanzando una habilidad cuando hay múltiples NPCs que la lanzan."
L.PRIVATE = "Auras privadas"
L.PRIVATE_desc = "Las auras privadas no pueden registrarse normalmente, pero el sonido de \"en mi\" (alerta) se puede configurar en la pestaña de sonido."

L.advanced = "Opciones avanzadas"
L.back = "<< Volver"

L.tank = "|cFFFF0000Solo alertas para tanques.|r "
L.healer = "|cFFFF0000Solo alertas para sanadores.|r "
L.tankhealer = "|cFFFF0000Solo alertas para tanque y sanador.|r "
L.dispeller = "|cFFFF0000Alertas para dispelear únicamente.|r "

-- Sharing.lua
L.import = "Importar"
L.import_info = "Después de ingresar el código de importación, puedes seleccionar qué configuraciones te gustaría importar.\nSi las configuraciones no están disponibles en el código de importación, no serán seleccionables.\n\n|cffff4411Esta importación solo afectará las configuraciones generales y no afectará las configuraciones específicas del jefe.|r"
L.import_info_active = "Elige qué partes te gustaría importar y luego haz clic en el botón de importar."
L.import_info_none = "|cFFFF0000La código de importación es incompatible o está desactualizada.|r"
L.export = "Exportar"
L.export_info = "Selecciona qué configuraciones te gustaría exportar y compartir con otros.\n\n|cffff4411Solo puedes compartir configuraciones generales y estas no tienen efecto en las configuraciones específicas del jefe.|r"
L.export_string = "Código de Exportación"
L.export_string_desc = "Copia este codigo de BigWigs si deseas compartir tus configuraciones."
L.import_string = "Código de Importación"
L.import_string_desc = "Pega aquí el código de BigWigs que deseas importar."
L.position = "Posición"
L.settings = "Configuraciones"
L.other_settings = "Otras Configuraciones"
L.nameplate_settings_import_desc = "Importar todas las configuraciones de placas de nombre."
L.nameplate_settings_export_desc = "Exportar todas las configuraciones de placas de nombre."
L.position_import_bars_desc = "Importar la posición (anclajes) de las barras."
L.position_import_messages_desc = "Importar la posición (anclajes) de los mensajes."
L.position_import_countdown_desc = "Importar la posición (anclajes) de la cuenta regresiva."
L.position_export_bars_desc = "Exportar la posición (anclajes) de las barras."
L.position_export_messages_desc = "Exportar la posición (anclajes) de los mensajes."
L.position_export_countdown_desc = "Exportar la posición (anclajes) de la cuenta regresiva."
L.settings_import_bars_desc = "Importar las configuraciones generales de las barras, como tamaño, fuente, etc."
L.settings_import_messages_desc = "Importar las configuraciones generales de los mensajes, como tamaño, fuente, etc."
L.settings_import_countdown_desc = "Importar las configuraciones generales de la cuenta regresiva, como voz, tamaño, fuente, etc."
L.settings_export_bars_desc = "Exportar las configuraciones generales de las barras, como tamaño, fuente, etc."
L.settings_export_messages_desc = "Exportar las configuraciones generales de los mensajes, como tamaño, fuente, etc."
L.settings_export_countdown_desc = "Exportar las configuraciones generales de la cuenta regresiva, como voz, tamaño, fuente, etc."
L.colors_import_bars_desc = "Importar los colores de las barras."
L.colors_import_messages_desc = "Importar los colores de los mensajes."
L.color_import_countdown_desc = "Importar el color de la cuenta regresiva."
L.colors_export_bars_desc = "Exportar los colores de las barras."
L.colors_export_messages_desc = "Exportar los colores de los mensajes."
L.color_export_countdown_desc = "Exportar el color de la cuenta regresiva."
L.confirm_import = "Las configuraciones seleccionadas que estás a punto de importar sobrescribirán las configuraciones en tu perfil actualmente seleccionado:\n\n|cFF33FF99\"%s\"|r\n\n¿Estás seguro de que deseas hacer esto?"
L.confirm_import_addon = "El addon |cFF436EEE\"%s\"|r quiere importar automáticamente nuevas configuraciones de BigWigs que sobrescribirán las configuraciones en tu perfil de BigWigs actualmente seleccionado:\n\n|cFF33FF99\"%s\"|r\n\n¿Estás seguro de que deseas hacer esto?"
L.confirm_import_addon_new_profile = "El addon |cFF436EEE\"%s\"|r quiere crear automáticamente un nuevo perfil de BigWigs llamado:\n\n|cFF33FF99\"%s\"|r\n\nAceptar este nuevo perfil también lo cambiará."
L.confirm_import_addon_edit_profile = "El addon |cFF436EEE\"%s\"|r quiere editar automáticamente uno de tus perfiles de BigWigs llamado:\n\n|cFF33FF99\"%s\"|r\n\nAceptar estos cambios también lo cambiará."
L.no_string_available = "No hay código de importación almacenada para importar. Primero importa un código."
L.no_import_message = "No se importaron configuraciones."
L.import_success = "Importado: %s" -- Importado: Anclajes de Barras, Colores de Mensajes
L.imported_bar_positions = "Posiciones de Barras"
L.imported_bar_settings = "Configuraciones de Barras"
L.imported_bar_colors = "Colores de Barras"
L.imported_message_positions = "Posiciones de Mensajes"
L.imported_message_settings = "Configuraciones de Mensajes"
L.imported_message_colors = "Colores de Mensajes"
L.imported_countdown_position = "Posición de Cuenta Regresiva"
L.imported_countdown_settings = "Configuraciones de Cuenta Regresiva"
L.imported_countdown_color = "Color de Cuenta Regresiva"
L.imported_nameplate_settings = "Configuraciones de Placas de Nombre"

-- Statistics
L.statistics = "Estadísticas"
L.defeat = "Derrota"
L.defeat_desc = "La cantidad total de veces que has sido derrotado en este encuentro con este jefe."
L.victory = "Victoria"
L.victory_desc = "La cantidad total de veces que has salido victorioso en este encuentro con este jefe."
L.fastest = "Más Rápido"
L.fastest_desc = "La victoria más rápida y la fecha en que ocurrió (Año/Mes/Día)"
L.first = "Primera"
L.first_desc = "La primera vez que saliste victorioso en este encuentro, formato:\n[Cantidad de derrotas antes de la primera victoria] - [Duración del combate] - [Año/Mes/Día de la victoria]"
-- Difficulty levels for statistics display on bosses
L.unknown = "Desconocido"
L.LFR = "LFR"
L.normal = "Normal"
L.heroic = "Heroico"
L.mythic = "Mítico"
L.timewalk = "Paseo en el Tiempo"
L.story = "Historia"
L.mplus = "Mítica+ %d"
L.SOD = "Season of Discovery"
L.hardcore = "Hardcore"
L.level1 = "Nivel 1"
L.level2 = "Nivel 2"
L.level3 = "Nivel 3"
L.N10 = "Normal 10"
L.N25 = "Normal 25"
L.H10 = "Heroico 10"
L.H25 = "Heroico 25"



-----------------------------------------------------------------------
-- PLUGINS
-----------------------------------------------------------------------

L.general = "General"
L.advanced = "Avanzado"
L.comma = ", "

L.positionX = "Posición X"
L.positionY = "Posición Y"
L.positionExact = "Posicionamiento preciso"
L.positionDesc = "Introduce o mueve el deslizador si necesitas posicionar de manera precisa desde el anclaje."
L.width = "Ancho"
L.height = "Alto"
L.sizeDesc = "Normalmente ajusta el tamaño deslizando por la barra. Si necesitas un tamaño exacto puedes usar este deslizador o teclea el valor dentro de la caja."
L.fontSizeDesc = "Ajusta el tamaño de la letra con el control deslizante o escribe el valor en la casilla cuyo máximo es 200."
L.disabled = "Desactivado"
L.disableDesc = "Estás a punto de desactivar la función '%s', aunque |cffff4411no se recomienda|r.\n\n¿Estás seguro de que quieres hacerlo?"

-- Anchor Points
L.UP = "Arriba"
L.DOWN = "Abajo"
L.TOP = "Superior"
L.RIGHT = "Derecha"
L.BOTTOM = "Inferior"
L.LEFT = "Izquierda"
L.TOPRIGHT = "Superior Derecha"
L.TOPLEFT = "Superior Izquierda"
L.BOTTOMRIGHT = "Inferior Derecha"
L.BOTTOMLEFT = "Inferior Izquierda"
L.CENTER = "Centrado"
L.customAnchorPoint = "Avanzado: Punto de anclaje personalizado"
L.sourcePoint = "Punto de Origen"
L.destinationPoint = "Punto de Destino"

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "Poder alternativo"
L.altPowerDesc = "El marco de poder alternativo solo aparecerá en los jefes que utilicen el poder alternativo con los jugadores, lo cual es muy poco frecuente. El marco mide la cantidad de 'Poder alternativo' que tienes tú y tu grupo, mostrándolo en una lista. Para mover el marco, utiliza el botón de prueba de abajo."
L.toggleDisplayPrint = "El marco se mostrará la próxima vez. Para desactivarlo completamente para este encuentro, tienes que desactivarlo en las opciones del encuentro."
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
L.testBarsBtn = "Crear Barra de prueba"
L.testBarsBtn_desc = "Crea barras para que las pruebes con los ajustes actuales"

L.toggleAnchorsBtnShow = "Mostrar anclajes móviles"
L.toggleAnchorsBtnHide = "Ocultar anclajes móviles"
L.toggleAnchorsBtnHide_desc = "Oculta todos los anclajes móviles, bloqueando todo en su lugar."
L.toggleBarsAnchorsBtnShow_desc = "Muestra todos los anclajes móviles, permitiendo mover los mensajes."

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
L.redirectPopupsDesc = "Las ventanas emergentes en el centro de tu pantalla, como el cartel '|cFF33FF99ranura de la bóveda desbloqueada|r' se mostrarán en su lugar como mensajes de BigWigs. Estos carteles pueden ser bastante grandes, durar mucho tiempo y bloquear tu capacidad de hacer clic a través de ellos."
L.redirectPopupsColor = "Color del mensaje redirigido"
L.blockDungeonPopups = "Bloquear los carteles emergentes de mazmorras"
L.blockDungeonPopupsDesc = "Los carteles emergentes que aparecen cuando entras a una mazmorras pueden contener texto que es muy largo. Activar esta opcion los bloqueara directamente."
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
L.toggleMessagesAnchorsBtnShow_desc = "Muestra todos los anclajes móviles, permitiendo mover los mensajes."

L.testMessagesBtn = "Crear Mensaje de Prueba"
L.testMessagesBtn_desc = "Crea un mensaje para que pruebes tus configuraciones de visualización actuales."

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
-- Nameplates.lua
--

L.nameplates = "Placas de Nombre"
L.testNameplateIconBtn = "Mostrar Ícono de Prueba"
L.testNameplateIconBtn_desc = "Crea un ícono para que pruebes tus configuraciones de visualización actuales en la placa de nombre seleccionada."
L.testNameplateTextBtn = "Mostrar Texto de Prueba"
L.testNameplateTextBtn_desc = "Crea un texto para que pruebes tus configuraciones de texto actuales en la placa de nombre seleccionada."
L.stopTestNameplateBtn = "Detener Pruebas"
L.stopTestNameplateBtn_desc = "Detiene las pruebas de íconos y textos en tus placas de nombre."
L.noNameplateTestTarget = "Necesitas tener un objetivo hostil seleccionable para probar la funcionalidad de las placas de nombre."
L.anchoring = "Anclaje"
L.growStartPosition = "Posición Inicial de Crecimiento"
L.growStartPositionDesc = "La posición inicial para el primer ícono."
L.growDirection = "Dirección de Crecimiento"
L.growDirectionDesc = "La dirección en la que los íconos crecerán desde la posición inicial."
L.iconSpacingDesc = "Cambiar el espacio entre cada ícono."
L.nameplateIconSettings = "Configuraciones de Íconos"
L.keepAspectRatio = "Mantener Relación de Aspecto"
L.keepAspectRatioDesc = "Mantener la relación de aspecto del ícono 1:1 en lugar de estirarlo para que se ajuste al tamaño del marco."
L.iconColor = "Color del Ícono"
L.iconColorDesc = "Cambiar el color de la textura del ícono."
L.desaturate = "Desaturar"
L.desaturateDesc = "Desaturar la textura del ícono."
L.zoom = "Zoom"
L.zoomDesc = "Hacer zoom en la textura del ícono."
L.showBorder = "Mostrar Borde"
L.showBorderDesc = "Mostrar un borde alrededor del ícono."
L.borderColor = "Color del Borde"
L.borderSize = "Tamaño del Borde"
L.showNumbers = "Mostrar Números"
L.showNumbersDesc = "Mostrar números en el ícono."
L.cooldown = "Tiempo de Reutilización"
L.showCooldownSwipe = "Mostrar Barrido"
L.showCooldownSwipeDesc = "Mostrar un barrido en el ícono cuando el tiempo de reutilización está activo."
L.showCooldownEdge = "Mostrar Borde"
L.showCooldownEdgeDesc = "Mostrar un borde en el tiempo de reutilización cuando está activo."
L.inverse = "Invertir"
L.inverseSwipeDesc = "Invertir las animaciones de tiempo de reutilización."
L.glow = "Brillo"
L.enableExpireGlow = "Habilitar Brillo al Expirar"
L.enableExpireGlowDesc = "Mostrar un brillo alrededor del ícono cuando el tiempo de reutilización ha expirado."
L.glowColor = "Color del Brillo"
L.glowType = "Tipo de Brillo"
L.glowTypeDesc = "Cambiar el tipo de brillo que se muestra alrededor del ícono."
L.resetNameplateIconsDesc = "Restablecer todas las opciones relacionadas con los íconos de las placas de nombre."
L.nameplateTextSettings = "Configuraciones de Texto"
L.fixate_test = "Prueba de Fijación" -- Text that displays to test on the frame
L.resetNameplateTextDesc = "Restablecer todas las opciones relacionadas con el texto de las placas de nombre."
L.glowAt = "Comenzar Brillo (segundos)"
L.glowAt_desc = "Elige cuántos segundos deben quedar en el tiempo de reutilización para que comience el brillo."
L.headerIconSizeTarget = "Tamaño del icono de tu objetivo actual"
L.headerIconSizeOthers = "Tamaño del icono de otros de objetivos"

-- Glow types as part of LibCustomGlow
L.pixelGlow = "Brillo de Píxel"
L.autocastGlow = "Brillo de Autolanzamiento"
L.buttonGlow = "Brillo de Botón"
L.procGlow = "Brillo de activación"
L.speed = "Velocidad"
L.animation_speed_desc = "La velocidad a la que se reproduce la animación de brillo."
L.lines = "Líneas"
L.lines_glow_desc = "El número de líneas en la animación de brillo."
L.intensity = "Intensidad"
L.intensity_glow_desc = "La intensidad del efecto de brillo, a mayor intensidad, más chispas."
L.length = "Longitud"
L.length_glow_desc = "La longitud de las líneas en la animación de brillo."
L.thickness = "Grosor"
L.thickness_glow_desc = "El grosor de las líneas en la animación de brillo."
L.scale = "Escala"
L.scale_glow_desc = "La escala de las chispas en la animación."
L.startAnimation = "Iniciar Animación"
L.startAnimation_glow_desc = "Este brillo que tiene una animación inicial, esto habilitará/deshabilitará esa animación."

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
L.pullStartedBy = "Temporizador de pull iniciado por %s."
L.pullStopped = "Pull cancelado por %s."
L.pullStoppedCombat = "Temporizador de pull cancelado porque entraste en combate."
L.pullIn = "Pull en %d seg"
L.sendPull = "Enviando un temporizador de pull a tu grupo."
L.wrongPullFormat = "Temporizador de pull inválido o formato inválido. Un ejemplo correcto es: /pull 5"
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
L.privateaura = "Siempre que tengas una 'Aura Privada'"

L.sound = "Sonido"

L.customSoundDesc = "Reproduce el sonido personalizado seleccionado en lugar del proporcionado por el módulo."
L.resetSoundDesc = "Restablece los sonidos anteriores a sus valores predeterminados."
L.resetAllCustomSound = "Si has personalizado sonidos para algún encuentro con jefes, este botón los reiniciará TODOS para que se utilicen los sonidos definidos aquí."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossStatistics = "Estadísticas de jefe"
L.bossStatsDescription = "Recording of various boss-related statistics such as the amount of times you were victorious, the amount of times you were defeated, date of first victory, and the fastest victory. Estas estadísticas se pueden ver en la ventana de configuración de cada jefe, pero permanecerán ocultas en los jefes que no tengan todavía registro de estadísticas."
L.createTimeBar = "Mostrar barra de 'Mejor tiempo'"
L.bestTimeBar = "Mejor tiempo"
L.healthPrint = "Salud: %s."
L.healthFormat = "%s (%.1f%%)"
L.chatMessages = "Mensajes de chat"
L.newFastestVictoryOption = "Nueva victoria más rápida"
L.victoryOption = "Fuiste vencedor"
L.defeatOption = "Fuiste derrotado"
L.bossHealthOption = "Salud del jefe"
L.bossVictoryPrint = "Has vencido a '%s' después de %s." -- You were victorious against 'BOSS_NAME' after COMBAT_DURATION.
L.bossDefeatPrint = "Fuiste derrotado por '%s' después de %s." -- You were defeated by 'BOSS_NAME' after COMBAT_DURATION.
L.newFastestVictoryPrint = "Nuevo registro victoria más rápida: (-%s)" -- New fastest victory: (-COMBAT_DURATION)

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
