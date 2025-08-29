local _, addonTbl = ...
local L = addonTbl.API:NewLocale("BigWigs", "esMX")
if not L then return end

-- API.lua
--L.showAddonBar = "The addon '%s' created the '%s' bar."

-- Core.lua
L.berserk = "Enfurecer"
L.berserk_desc = "Muestra un contador que avisa cuando el jefe entrará en enfurecer"
L.altpower = "Indicador de poder alternativo"
L.altpower_desc = "Muestra la ventana de poder alternativo, que indica la cantidad de poder alternativo que tienen los miembros de tu grupo."
L.infobox = "Caja de información"
L.infobox_desc = "Muestra un marco con información relacionada con el encuentro."
L.stages = "Fases"
L.stages_desc = "Activa las funciones relacionadas con varias etapas/fases del jefe como cambios de etapa, barras de temporizador de duración de etapa, etc."
L.warmup = "Calentamiento"
L.warmup_desc = "Tiempo hasta que el combate con el jefe comience."
L.proximity = "Pantalla de proximidad"
L.proximity_desc = "Muestra la ventana de proximidad cuando sea apropiado para este encuentro, enumerando los jugadores que están demasiado cerca de ti."
L.adds = "Esbirros"
L.adds_desc = "Activa las funciones relacionadas con los esbirros que aparecerán durante un encuentro con un jefe."
L.health = "Salud"
L.health_desc = "Activa las funciones para mostrar varias informaciones de salud durante un encuentro con un jefe."
L.energy = "Energía"
L.energy_desc = "Activa las funciones para mostrar varias informaciones de energía durante un encuentro con un jefe."

L.already_registered = "|cffff0000ATENCIÓN:|r |cff00ff00%s|r (|cffffff00%s|r) ya existe ese módulo en BigWigs, pero sin embargo está intentando registrarlo de nuevo. Esto normalmente ocurre cuando tienes varias copias de este módulo en tu carpeta de addons posiblemente por una actualización fallida. Es recomendable que borres la carpeta de BigWigs y lo reinstales por completo."

-- Loader / Options.lua
L.okay = "Aceptar"
L.officialRelease = "Estás usando la versión oficial de BigWigs %s (%s)."
L.alphaRelease = "Estás usando la VERSIÓN ALFA de BigWigs %s (%s)."
L.sourceCheckout = "Estás usando la versión de BigWigs %s directamente del repositorio."
L.littlewigsOfficialRelease = "Estás usando la versión oficial de LittleWigs (%s)."
L.littlewigsAlphaRelease = "Estás usando la VERSIÓN ALFA de LittleWigs (%s)."
L.littlewigsSourceCheckout = "Estás usando la versión de LittleWigs directamente del repositorio."
L.guildRelease = "Estás usando la versión %d de BigWigs hecha para tu hermandad, basado en la versión %d del addon oficial."
L.getNewRelease = "Tu BigWigs está desactualizado (/bwv) pero puedes actualizarlo fácilmente con el cliente de CurseForge. También puedes actualizarlo manualmente desde curseforge.com o addons.wago.io."
L.warnTwoReleases = "Tu BigWigs está 2 versiones desactualizado! Tu versión puede tener fallos, faltarle características, o temporizadores incorrectos. Es muy recomendable que lo actualices."
L.warnSeveralReleases = "|cffff0000Tu BigWigs está desactualizado %d actualizaciones!! Te recomendamos MUCHÍSIMO que lo actualices cuanto antes para prevenir problemas de sincronización con otros jugadores!|r"
L.warnOldBase = "Estás usando la versión de hermandad de BigWigs (%d), pero tu versión base (%d) está %d versiones desactualizada. Esto puede provocar problemas."

L.tooltipHint = "|cffeda55fClic derecho|r para acceder a las opciones."
L.activeBossModules = "Módulos de jefes activos:"

L.oldVersionsInGroup = "Hay personas en tu grupo con |cffff0000versiones antiguas|r de BigWigs. Puedes obtener mas detalles con /bwv."
L.upToDate = "Al día:"
L.outOfDate = "Desactualizado"
L.dbmUsers = "Jugadores con DBM:"
L.noBossMod = "Sin boss mod:"
L.offline = "Desconectado"

L.missingAddOnPopup = "¡Falta el addon |cFF436EEE%s|r!"
L.missingAddOnRaidWarning = "¡Falta el addon |cFF436EEE%s|r! No se mostraran contadores en esta zona!"
L.outOfDateAddOnPopup = "El |cFF436EEE%s|r addon esta desactualizado!"
L.outOfDateAddOnRaidWarning = "El |cFF436EEE%s|r addon esta desactualizado! Tienes la version v%d.%d.%d siendo que la última es v%d.%d.%d!"
L.disabledAddOn = "Tienes el addon |cFF436EEE%s|r desactivado, los contadores no se mostrarán."
L.removeAddOn = "Por favor elimina '|cFF436EEE%s|r' ya que está siendo reemplazado por '|cFF436EEE%s|r'."
L.alternativeName = "%s (|cFF436EEE%s|r)"
L.outOfDateContentPopup = "CUIDADO!\nActualizaste |cFF436EEE%s|r pero también necesitas actualizar el addon |cFF436EEEBigWigs|r principal.\nIgnorar esto, significa que no funcionará correctamente."
L.outOfDateContentRaidWarning = "|cFF436EEE%s|r requiere la versión %d del addon principal de|cFF436EEEBigWigs|r para que funcione correctamente, pero tu estan en la versión %d."
L.addOnLoadFailedWithReason = "BigWigs falló al cargar el addon |cFF436EEE%s|r por razones %q. ¡Avisa a los desarrolladores de BigWigs!"
L.addOnLoadFailedUnknownError = "BigWigs ha encontrado un error al cargar el addon |cFF436EEE%s|r. ¡Avisa a los desarrolladores de BigWigs!"

L.expansionNames = {
	"Clásico", -- Classic
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
	["LittleWigs_Delves"] = "Abismos",
	["LittleWigs_CurrentSeason"] = "Temporada actual",
}

-- Media.lua (These are the names of the sounds in the dropdown list in the "sounds" section)
L.Beware = "Cuidado (Algalon)"
L.FlagTaken = "Bandera tomada (JcJ)"
L.Destruction = "Destrucción (Kil'jaeden)"
L.RunAway = "Corre pequeña (El Lobo Feroz)"
L.spell_on_you = "BigWigs: Habilidad en ti"
L.spell_under_you = "BigWigs: Habilidad debajo de ti"
--L.simple_no_voice = "Simple (No Voice)"

-- Options.lua
L.options = "Opciones"
L.optionsKey = "ID: %s" -- The ID that messages/bars/options use
L.raidBosses = "Jefes de Banda"
L.dungeonBosses = "Jefes de Calabozo"
L.introduction = "Bienvenido a BigWigs. Abróchate el cinturón y come cacahuetes mientras disfrutas del paseo. De manera no intrusiva te ayudará a preparar ese nuevo encuentro de banda como una cena de 7 platos para tu grupo de banda."
L.sound = "Sonido"
L.minimapIcon = "Icono del minimapa"
L.minimapToggle = "Cambia entre mostrar/ocultar el icono en el minimapa."
L.compartmentMenu = "Sin icono de compartimento"
L.compartmentMenu_desc = "Al desactivar esta opción, BigWigs aparecerá en el menú de compartimiento de addon. Recomendamos dejar esta opción activada."
L.configure = "Configurar"
L.resetPositions = "Restablecer posiciones"
L.selectEncounter = "Seleccionar encuentro"
L.privateAuraSounds = "Sonidos de aura privada"
L.privateAuraSounds_desc = "Las auras privadas no pueden ser trackeadas correctamente, pero puedes asignar un sonido para cuando seas objetivo de la habilidad."
L.listAbilities = "Listar las habilidades en el chat"

L.dbmFaker = "Fingir que estoy usando DBM"
L.dbmFakerDesc = "Si un usuario de DBM hace un chequeo de versión para ver quien está usando DBM, ellos te verán a ti en la lista. Muy útil para hermandades que obligan a usar DBM."
L.zoneMessages = "Mostrar mensajes de la zona"
L.zoneMessagesDesc = "Desactivando esto dejará de mostrar mensajes cuando entres en una zona donde BigWigs tenga un módulo, pero no lo tengas instalado. Recomendamos que dejes esto activo, pues será la única notificación que recibirás si creamos módulos nuevos para una zona que encuentres útil"
L.englishSayMessages = "Mensajes de texto sólo en inglés"
L.englishSayMessagesDesc = "Todos los mensajes de 'decir' y 'gritar' que envíes en el chat durante un encuentro con un jefe siempre estarán en inglés. Puede resultar útil si estás con un grupo de jugadores que mezclan idiomas."

L.slashDescTitle = "|cFFFED000Atajo de comandos:|r"
L.slashDescPull = "|cFFFED000/pull:|r Envía una cuenta regresiva de llamada al jefe a tu banda."
L.slashDescBreak = "|cFFFED000/break:|r Crea un temporizador de descanso para tu banda."
L.slashDescRaidBar = "|cFFFED000/raidbar:|r Envía una barra personalizada a tu banda."
L.slashDescLocalBar = "|cFFFED000/localbar:|r Crea una barra personal que sólo puedes ver tú."
L.slashDescRange = "|cFFFED000/range:|r Abre el indicador de rango."
L.slashDescVersion = "|cFFFED000/bwv:|r Realiza un chequeo de versiones de BigWigs."
L.slashDescConfig = "|cFFFED000/bw:|r Abre la configuración de BigWigs."

L.gitHubDesc = "|cFF33FF99BigWigs es de código abierto alojado en GitHub. Siempre estamos buscando gente para ayudarnos y cualquiera es bienvenido para inspeccionar nuestro código, hacer contribuciones y reportar errores. BigWigs es tan genial a día de hoy en gran parte por la gran comunidad de WoW que nos ayuda.|r"

L.BAR = "Barras"
L.MESSAGE = "Mensajes"
L.ICON = "Icono"
L.SAY = "Decir"
L.FLASH = "Destello"
L.EMPHASIZE = "Enfatizar"
L.ME_ONLY = "En mí únicamente"
L.ME_ONLY_desc = "Cuando activas esta opción los mensajes para esta habilidad sólo serán mostrados cuando te afecten. Por ejemplo, 'Bomba: Jugador' sólo se mostrará si está en ti."
L.PULSE = "Pulso"
L.PULSE_desc = "Para complementar el destello de pantalla, también puedes tener un icono relacionado con esta habilidad especifica que se mostrará momentáneamente en el medio de la pantalla para tratar de atraer tu atención."
L.MESSAGE_desc = "La mayoria de las abilidades de los encuentros se presentan con uno o más mensajes que BigWigs mostrará en tu pantalla. Si desactivas esta opción, ningún mensaje de esta opción, si lo hay, será mostrado en pantalla."
L.BAR_desc = "Las barras serán mostradas en el momento apropiado. Si esta habilidad está acompañada por una barra que quieres ocultar, desactiva esta opción."
L.FLASH_desc = "Algunas habilidades son más importantes que otras. Si quieres ver un destello cuando esta habilidad sea inminente o usada, activa esta opción."
L.ICON_desc = "BigWigs puede marcar personajes afectados por habilidades con un icono. Esto hace que sea más fácil detectarlos."
L.SAY_desc = "Las burbujas de chat son fáciles de ver. BigWigs usará un mensaje para anunciar a la gente cercana sobre un efecto en ti."
L.EMPHASIZE_desc = "Activando esto enfatizará algunos mensajes asociados con esta habilidad, haciéndolos más grandes y visibles. Puedes ajustar el tamaño y la fuente de los mensajes enfatizados en las opciones principales debajo de \"Mensajes\"."
L.PROXIMITY = "Ventana de proximidad"
L.PROXIMITY_desc = "La ventana de proximidad se ajustará especificamente para esa habilidad para que sepas de un vistazo si estás a salvo o no."
L.ALTPOWER = "Indicador de poder alternativo"
L.ALTPOWER_desc = "Algunos encuentros usarán la mecánica de poder alternativo en jugadores de tu grupo. El indicador de poder alternativo proporciona un breve repaso sobre quien tiene menos/más poder alternativo, lo que puede ser útil para tácticas o asignaciones especificas."
L.TANK = "Tanques únicamente"
L.TANK_desc = "Algunas habilidades son importantes sólo para tanques. Si quieres ver avisos para este tipo de habilidades independientemente de tu rol, desactiva esta opción."
L.HEALER = "Sanadores únicamente"
L.HEALER_desc = "Algunas habilidades son importantes sólo para sanadores. Si quieres ver avisos para este tipo de habilidades independientemente de tu rol, desactiva esta opción."
L.TANK_HEALER = "Sólo Tanques y Sanadores"
L.TANK_HEALER_desc = "Algunas habilidades son importantes sólo para tanques y sanadores. Si quieres ver advertencias para este tipo de habilidades independientemente de tu rol, desactiva esta opción."
L.DISPEL = "Disipables únicamente"
L.DISPEL_desc = "Si quieres ver avisos para esta habilidad incluso cuando no puedas disiparla, desactiva esta opción."
L.VOICE = "Voz"
L.VOICE_desc = "Si tienes un plugin de voz instalado, esta opción le permitirá reproducir un archivo de sonido que hable en este aviso para ti."
L.COUNTDOWN = "Cuenta regresiva"
L.COUNTDOWN_desc = "Si está activo, una cuenta regresiva vocal y visual será agregada para los últimos 5 segundos. Imagina a alguien contando hacia atrás \"5... 4... 3... 2... 1...\" con un número grande en el medio de la pantalla."
L.CASTBAR_COUNTDOWN = "Cuenta regresiva (sólo barras de lanzamiento)"
L.CASTBAR_COUNTDOWN_desc = "Si está activado, se agregará una cuenta regresiva vocal y visual durante los últimos 5 segundos de las barras de lanzamiento."
L.INFOBOX = L.infobox
L.INFOBOX_desc = L.infobox_desc
L.SOUND = L.sound
L.SOUND_desc = "Las habilidades de jefes habitualmente reproducen sonidos para ayudarte con ellas. Si desactivas esta opción, ningún sonido adjunto sonará."
L.CASTBAR = "Barras de lanzamiento"
L.CASTBAR_desc = "Barras de lanzamiento se muestran a veces con ciertos jefes, normalmente para atraer la atención de que una habilidad crítica está en camino. Si esta habilidad está acompañada por una barra de lanzamiento que quieres ocultar, desactiva esta opción."
L.SAY_COUNTDOWN = "Decir cuenta regresiva"
L.SAY_COUNTDOWN_desc = "Las burbujas de chat son fáciles de detectar. BigWigs usará múltiples mensajes de cuenta regresiva para alertar a los que estén cerca que una habilidad en ti está a punto de expirar."
L.ME_ONLY_EMPHASIZE = "Enfatizar (sólo en mi)"
L.ME_ONLY_EMPHASIZE_desc = "Al activar esto enfatizará cualquier mensaje asociado con esta habilidad SÓLO si se lanza sobre ti, mostrándolo más grande y visible."
L.NAMEPLATE = "Placa de nombre"
L.NAMEPLATE_desc = "Si se activa, algunas funciones, como iconos y texto relacionado con esta habilidad en concreto serán mostradas en tus placas de nombre. Esto hace mucho más fácil ver que NPC específicamente está lanzando la habilidad, cuando hay muchos NPCs casteando la misma."
L.PRIVATE = "Aura privada"
L.PRIVATE_desc = "Las auras privadas no se pueden rastrear normalmente, pero el sonido \"sobre ti\" (aviso) se puede configurar en la pestaña Sonido."

L.advanced_options = "Opciones avanzadas"
L.back = "<< Volver"

L.tank = "|cFFFF0000Solo alertas para tanques.|r "
L.healer = "|cFFFF0000Solo alertas para sanadores.|r "
L.tankhealer = "|cFFFF0000Solo alertas para tanque y sanador.|r "
L.dispeller = "|cFFFF0000Alertas para dispelear únicamente.|r "

-- Sharing.lua
L.import = "Importar"
L.import_info = "Después de ingresar la cadena de importación, puedes seleccionar que opciones quieres importar.\nSi no hay opciones disponibles en la cadena de importación estas no podrán ser seleccionadas.\n\n|cffff4411Este importe solo afectará las opciones generales y no afecta ninguna opcion especifica de jefes.|r"
L.import_info_active = "Elige que partes te gustaría importar y luego presiona el botom de importar."
L.import_info_none = "|cFFFF0000La cadena de importación está mala o vencida (fuera de fecha).|r"
L.export = "Exportar"
L.export_info = "Selecciona que opciones te gustaria exportar y compartir con los demás.\n\n|cffff4411Solo puedes compartir opciones generales, que no afectarán opciones de jefes.|r"
L.export_string = "Cadena de exportación"
L.export_string_desc = "Copia esta cadena de exportación de BigWigs si quieres compartir tus opciones."
L.import_string = "Cadena de importación"
L.import_string_desc = "Pega la cadena de importación de BigWigs que quieras importar aquí."
L.position = "Posición"
L.settings = "Opciones"
L.other_settings = "Otras opciones"
L.nameplate_settings_import_desc = "Importar todas las opciones de las placas de nombre."
L.nameplate_settings_export_desc = "Exportar todas las opciones de las placas de nombre."
L.position_import_bars_desc = "Importar la posición (anclajes) de las barras."
L.position_import_messages_desc = "Importar la posición (anclajes) de los mensajes."
L.position_import_countdown_desc = "Importar la posición (anclajes) de los contadores."
L.position_export_bars_desc = "Exportar la posición (anclajes) de las barras."
L.position_export_messages_desc = "Exportar la posición (anclajes) de los mensajes."
L.position_export_countdown_desc = "Exportar la posición (anclajes) de los contadores."
L.settings_import_bars_desc = "Importar las opciones generales, como tamaño, fuente, etc."
L.settings_import_messages_desc = "Importar las opciones generales de los mensajes, como tamaño, fuente, etc."
L.settings_import_countdown_desc = "Importar las opciones generales de los contadores, como tamaño, voz, fuente, etc."
L.settings_export_bars_desc = "Exportar las opciones generales de las barras,como tamaño, fuente, etc."
L.settings_export_messages_desc = "Exportar las opciones generales de los mensajes, como tamaño, fuente, etc."
L.settings_export_countdown_desc = "Exportar las opciones generales de los contadores the general countdown settings such as voice, size, font, etc."
L.colors_import_bars_desc = "Importar el color de las barras."
L.colors_import_messages_desc = "Importar el color de los mensajes."
L.color_import_countdown_desc = "Importar el color de los contadores."
L.colors_export_bars_desc = "Exportar el color de las barras."
L.colors_export_messages_desc = "Exportar el color de los mensajes."
L.color_export_countdown_desc = "Exportar el color de los contadores."
L.confirm_import = "Las opciones que seleccionaste para importar, reescribiran las opciones selecionadas del perfil actuale:\n\n|cFF33FF99\"%s\"|r\n\n¿Estás seguro que quieres hacer esto?"
L.confirm_import_addon = "El addon |cFF436EEE\"%s\"|r quiere importar de manera automática nuevas opciones para BigWigsa que sobreescribiran las actuales del perfil:\n\n|cFF33FF99\"%s\"|r\n\n¿Estás seguro que quieres hacer esto?"
L.confirm_import_addon_new_profile = "El addon |cFF436EEE\"%s\"|r quiere de manera automática creer un nuevo perfil:\n\n|cFF33FF99\"%s\"|r\n\nAceptar esto, tambien creará un nuevo perfil."
L.confirm_import_addon_edit_profile = "El addon |cFF436EEE\"%s\"|r editar uno de tus perfiles:\n\n|cFF33FF99\"%s\"|r\n\nAceptar estos cambios harán que también cambies a este mismo."
L.no_string_available = "No hay cadena de importación para importar. Necesitas una cadena primero."
L.no_import_message = "No se importaron opciones."
L.import_success = "Importado: %s" -- Imported: Bar Anchors, Message Colors
L.imported_bar_positions = "Posiciones de barra"
L.imported_bar_settings = "Opciones de barra"
L.imported_bar_colors = "Colores de barra"
L.imported_message_positions = "Posiciones de los mensajes"
L.imported_message_settings = "Opciones de los mensajes"
L.imported_message_colors = "Colores de los mensajes"
L.imported_countdown_position = "Posiciones de los contadores"
L.imported_countdown_settings = "Opciones de los contadores"
L.imported_countdown_color = "Color de los contadores"
L.imported_nameplate_settings = "Opciones de las barras de nombre"
--L.imported_mythicplus_settings = "Mythic+ Settings"
--L.mythicplus_settings_import_desc = "Import all Mythic+ settings."
--L.mythicplus_settings_export_desc = "Export all Mythic+ settings."

-- Statistics
L.statistics = "Estadísticas"
L.defeat = "Derrota"
L.defeat_desc = "El total de veces que este jefe te ha derrotado."
L.victory = "Victoria"
L.victory_desc = "El total de veces que has resultado victorioso en contra este jefe."
L.fastest = "Más rápida"
L.fastest_desc = "La victoria más rápida y ocurrio el (Año/Mes/Día)"
L.first = "Primera"
L.first_desc = "La primera victoria ante este jefe, formateada como:\n[Número de derrotas antes de la primera derrota] - [Duración de combate] - [Año/Mes/Día de la Victoria.]"

-- Difficulty levels for statistics display on bosses
L.unknown = "Desconocido"
L.LFR = "Buscardor de Banda"
L.normal = "Normal"
L.heroic = "Heroico"
L.mythic = "Mítico"
L.timewalk = "Cronoviaje"
--L.solotier8 = "Solo Tier 8"
--L.solotier11 = "Solo Tier 11"
L.story = "Historia"
L.mplus = "Mítica+ %d"
L.SOD = "Temporada de descubrimiento"
L.hardcore = "Hardcore"
L.level1 = "Nivel 1"
L.level2 = "Nivel 2"
L.level3 = "Nivel 3"
L.N10 = "Normal 10"
L.N25 = "Normal 25"
L.H10 = "Heroico 10"
L.H25 = "Heroico 25"

-----------------------------------------------------------------------
-- TOOLS
-----------------------------------------------------------------------

L.tools = "Herramientas"
L.toolsDesc = "BigWigs ofrece varias herramientas o características de \"calidad de vida\" para acelerar y simplificar el proceso de enfrentamiento con los jefes. Expande el menú clicando el |cFF33FF99+|r icono para mostrarlas todas."

-----------------------------------------------------------------------
-- AutoRole.lua
--

L.autoRoleTitle = "Auto Rol"
L.autoRoleExplainer = "Cuando te unas a un grupo o cambies tu especialización de talentos mientras estés en un grupo, BigWigs ajustará automáticamente tu rol de grupo (Tanque, Sanador, Daño) como corresponda.\n\n"

-----------------------------------------------------------------------
-- Keystones.lua
--

L.keystoneTitle = "BigWigs Piedras angulares"
L.keystoneHeaderParty = "Grupo"
L.keystoneRefreshParty = "Actualizar Grupo"
L.keystoneHeaderGuild = "Hermandad"
L.keystoneRefreshGuild = "Actualizar Hermandad"
L.keystoneLevelTooltip = "Nivel de Piedra: |cFFFFFFFF%s|r"
L.keystoneMapTooltip = "Mazmorra: |cFFFFFFFF%s|r"
L.keystoneRatingTooltip = "Puntuación Mítica+: |cFFFFFFFF%d|r"
L.keystoneHiddenTooltip = "El jugador ha escogido ocultar esta información."
L.keystoneTabOnline = "En línea"
L.keystoneTabAlts = "Alters"
L.keystoneTabTeleports = "Teletransportes"
L.keystoneHeaderMyCharacters = "Mis Personajes"
--L.keystoneTeleportNotLearned = "The teleport spell '|cFFFFFFFF%s|r' is |cFFFF4411not learned|r yet."
--L.keystoneTeleportOnCooldown = "The teleport spell '|cFFFFFFFF%s|r' is currently |cFFFF4411on cooldown|r for %d |4hour:hours; and %d |4minute:minutes;."
--L.keystoneTeleportReady = "The teleport spell '|cFFFFFFFF%s|r' is |cFF33FF99ready|r, click to cast it."
--L.keystoneTeleportInCombat = "You cannot teleport here whilst you are in combat."
--L.keystoneTabHistory = "History"
--L.keystoneHeaderThisWeek = "This Week"
--L.keystoneHeaderOlder = "Older"
--L.keystoneScoreTooltip = "Dungeon Score: |cFFFFFFFF%d|r"
--L.keystoneScoreGainedTooltip = "Score Gained: |cFFFFFFFF+%d|r"
--L.keystoneCompletedTooltip = "Completed in time"
--L.keystoneFailedTooltip = "Failed to complete in time"
--L.keystoneExplainer = "A collection of various tools to improve the Mythic+ experience."
--L.keystoneAutoSlot = "Auto slot keystone"
--L.keystoneAutoSlotDesc = "Automatically place your keystone into the slot when opening the keystone holder."
--L.keystoneAutoSlotMessage = "Automatically placed %s into the keystone slot."
--L.keystoneModuleName = "Mythic+"
--L.keystoneStartBar = "%s +%d" -- Format is SHORT_DUNGEON_NAME +KEYSTONE_LEVEL e.g. "ROOK +12"
--L.keystoneStartMessage = "%s +%d begins now!" -- Format is LONG_DUNGEON_NAME +KEYSTONE_LEVEL e.g. "The Rookery +12 begins now!"
--L.keystoneCountdownExplainer = "When you start a Mythic+ dungeon a countdown will play. Choose what voice you'd like to hear and when you want the countdown to start.\n\n"
--L.keystoneCountdownBeginsDesc = "Choose how much time should be remaining on the Mythic+ start timer when the countdown will begin to play."
--L.keystoneCountdownBeginsSound = "Play a sound when the Mythic+ countdown starts"
--L.keystoneCountdownEndsSound = "Play a sound when the Mythic+ countdown ends"
--L.keystoneViewerTitle = "Keystone Viewer"
--L.keystoneHideGuildTitle = "Hide my keystone from my guild members"
--L.keystoneHideGuildDesc = "|cffff4411Not recommended.|r This feature will prevent your guild members seeing what keystone you have. Anyone in your group will still be able to see it."
--L.keystoneHideGuildWarning = "Disabling the ability for your guild members to see your keystone is |cffff4411not recommended|r.\n\nAre you sure you want to do this?"
--L.keystoneAutoShowEndOfRun = "Show when the Mythic+ is over"
--L.keystoneAutoShowEndOfRunDesc = "Automatically show the keystone viewer when when the Mythic+ dungeon is over.\n\n|cFF33FF99This can help you see what new keystones your party has received.|r"
--L.keystoneViewerExplainer = "You can open the keystone viewer using the |cFF33FF99/key|r command or by clicking the button below.\n\n"
--L.keystoneViewerOpen = "Open the keystone viewer"
--L.keystoneViewerKeybindingExplainer = "\n\nYou can also set a keybinding to open the keystone viewer:\n\n"
--L.keystoneViewerKeybindingDesc = "Choose a keybinding to open the keystone viewer."
--L.keystoneClickToWhisper = "Click to open a whisper dialog"
--L.keystoneClickToTeleportNow = "\nClick to teleport here"
--L.keystoneClickToTeleportCooldown = "\nCannot teleport, spell on cooldown"
--L.keystoneClickToTeleportNotLearned = "\nCannot teleport, spell not learned"
--L.keystoneHistoryRuns = "%d Total"
--L.keystoneHistoryRunsThisWeekTooltip = "Total amount of dungeons this week: |cFFFFFFFF%d|r"
--L.keystoneHistoryRunsOlderTooltip = "Total amount of dungeons before this week: |cFFFFFFFF%d|r"
--L.keystoneHistoryScore = "+%d Score"
--L.keystoneHistoryScoreThisWeekTooltip = "Total score gained this week: |cFFFFFFFF+%d|r"
--L.keystoneHistoryScoreOlderTooltip = "Total score gained before this week: |cFFFFFFFF+%d|r"

-- It doesn't really matter what you call it as long as it's recognizable and limited to ~6 characters
--L.keystoneShortName_TheRookery = "ROOK"
--L.keystoneShortName_DarkflameCleft = "DFC"
--L.keystoneShortName_PrioryOfTheSacredFlame = "PRIORY"
--L.keystoneShortName_CinderbrewMeadery = "BREW"
--L.keystoneShortName_OperationFloodgate = "FLOOD"
--L.keystoneShortName_TheaterOfPain = "TOP"
--L.keystoneShortName_TheMotherlode = "ML"
--L.keystoneShortName_OperationMechagonWorkshop = "WORK"
--L.keystoneShortName_EcoDomeAldani = "ALDANI"
--L.keystoneShortName_HallsOfAtonement = "HOA"
--L.keystoneShortName_AraKaraCityOfEchoes = "ARAK"
--L.keystoneShortName_TazaveshSoleahsGambit = "GAMBIT"
--L.keystoneShortName_TazaveshStreetsOfWonder = "STREET"
--L.keystoneShortName_TheDawnbreaker = "DAWN"

-- These short names are for the bar that shows during the Mythic+ countdown
-- Use the real dungeon names but make them shorter to fit on the bar better
--L.keystoneShortName_TheRookery_Bar = "Rookery"
--L.keystoneShortName_DarkflameCleft_Bar = "Darkflame"
--L.keystoneShortName_PrioryOfTheSacredFlame_Bar = "Priory"
--L.keystoneShortName_CinderbrewMeadery_Bar = "Cinderbrew"
--L.keystoneShortName_OperationFloodgate_Bar = "Floodgate"
--L.keystoneShortName_TheaterOfPain_Bar = "Theater"
--L.keystoneShortName_TheMotherlode_Bar = "Motherlode"
--L.keystoneShortName_OperationMechagonWorkshop_Bar = "Workshop"
--L.keystoneShortName_EcoDomeAldani_Bar = "Al'dani"
--L.keystoneShortName_HallsOfAtonement_Bar = "Halls"
--L.keystoneShortName_AraKaraCityOfEchoes_Bar = "Ara-Kara"
--L.keystoneShortName_TazaveshSoleahsGambit_Bar = "Gambit"
--L.keystoneShortName_TazaveshStreetsOfWonder_Bar = "Streets"
--L.keystoneShortName_TheDawnbreaker_Bar = "Dawnbreaker"

-- Instance Keys "Who has a key?"
--L.instanceKeysTitle = "Who has a key?"
--L.instanceKeysDesc = "When you enter a Mythic dungeon, the players that have a keystone for that dungeon will be displayed as a list.\n\n"
--L.instanceKeysTest8 = "|cFF00FF98Monk:|r +8"
--L.instanceKeysTest10 = "|cFFFF7C0ADruid:|r +10"
--L.instanceKeysDisplay = "|c%s%s:|r +%d" -- "PLAYER_NAME: +DUNGEON_LEVEL"
--L.instanceKeysDisplayWithDungeon = "|c%s%s:|r +%d (%s)" -- "PLAYER_NAME: +DUNGEON_LEVEL (DUNGEON_NAME)"
--L.instanceKeysShowAll = "Always show all players"
--L.instanceKeysShowAllDesc = "Enabling this option will show all players in the list, even if their keystone doesn't belong to the dungeon you are in."
--L.instanceKeysOtherDungeonColor = "Other dungeon color"
--L.instanceKeysOtherDungeonColorDesc = "Choose the font color for players that have keystones that don't belong to the dungeon you are in."
--L.instanceKeysEndOfRunDesc = "By default the list will only show when you enter a mythic dungeon. Enabling this option will also show the list when the Mythic+ is over."

-----------------------------------------------------------------------
-- LFGTimer.lua
--

L.lfgTimerTitle = "LFG Timer"
L.lfgTimerExplainer = "Whenever the LFG queue popup appears, BigWigs will create a timer bar telling you how long you have to accept the queue.\n\n"
L.lfgUseMaster = "Play LFG ready sound on 'Master' audio channel"
L.lfgUseMasterDesc = "When this option is enabled the LFG ready sound will play over the 'Master' audio channel. If you disable this option it will play over the '%s' audio channel instead."

-----------------------------------------------------------------------
-- PLUGINS
-----------------------------------------------------------------------

L.general = "General"
L.advanced = "Avanzado"
L.comma = ", "
L.reset = "Restablecer"
--L.resetDesc = "Reset the above settings to their default values."
L.resetAll = "Restablecer todo"

L.positionX = "Posición X"
L.positionY = "Posición Y"
L.positionExact = "Posicionamiento exacto"
L.positionDesc = "Escriba en el recuadro o mueva el deslizador si necesita un posicionamiento exacto desde el ancla."
L.width = "Anchura"
L.height = "Altura"
--L.size = "Size"
L.sizeDesc = "Normalmente se ajusta el tamaño arrastrando el ancla. Si necesitas un tamaño exacto puedes usar este deslizador o escribir el valor en el recuadro."
L.fontSizeDesc = "Ajuste el tamaño de la fuente utilizando el control deslizante o escriba el valor en la casilla que tiene un máximo de 200."
L.disabled = "Desactivado"
L.disableDesc = "Está a punto de desactivar la función '%s' que |cffff4411no se recomienda|r.\n\n¿Estás seguro de que quieres hacer esto?"
L.keybinding = "Atajo de teclado"
--L.dragToResize = "Drag to resize"

-- Anchor Points
L.UP = "Arriba"
L.DOWN = "Abajo"
L.TOP = "Superior"
L.RIGHT = "Derecha"
L.BOTTOM = "Inferior"
L.LEFT = "Izquierda"
L.TOPRIGHT = "Superior Derecho"
L.TOPLEFT = "Superior Izquierdo"
L.BOTTOMRIGHT = "Inferior Derecho"
L.BOTTOMLEFT = "Inferior Izquierdo"
L.CENTER = "Centrp"
L.customAnchorPoint = "Avanzado: Punto de anclaje personalizado"
L.sourcePoint = "Punto de Origen"
L.destinationPoint = "Punto de destino"
--L.drawStrata = "Draw Strata"
--L.medium = "MEDIUM"
--L.low = "LOW"

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
L.emphasize = L.EMPHASIZE
L.emphasizeMultiplier = "Multiplicador de tamaño"
L.emphasizeMultiplierDesc = "Si desactiva las barras moviéndose el anclaje enfatizado, esta opción decidirá el tamaño de las barras enfatizadas multiplicando el tamaño de las barras normales."

L.enable = "Activar"
L.move = "Mover"
L.moveDesc = "Mueve las barras enfatizadas al anclaje de Enfatizar. Si esta opción está desactivada, las barras enfatizadas simplemente cambiarán de tamaño y color."
L.emphasizedBars = "Barras enfatizadas"
L.align = "Alinear"
L.alignText = "Alinear el texto"
L.alignTime = "Alinear el tiempo"
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
L.redirectPopupsDesc = "Carteles emergentes en medio de la pantalla, tales como: '|cFF33FF99Espacio del gran boveda desbloqueado|r' El cartel será mostrado como mensaje de BigWigs. Estos carteles pueden ser bastante grandes, durar mucho tiempo y bloquear la posibilidad de hacer clic en ellos."
L.redirectPopupsColor = "Color del mensaje redirigido"
L.blockDungeonPopups = "Bloquear carteles emergentes de calabozos"
L.blockDungeonPopupsDesc = "Los carteles emergentes que se muestran al entrar a un calabozo a veces pueden contener texto muy largo. Al activar esta función los bloqueará completamente."
L.itemLevel = "Nivel de objeto %d"
--L.newRespawnPoint = "New Respawn Point"

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
L.expiring_normal = "Normal"
L.emphasized = "Enfatizado"

L.resetColorsDesc = "Restablece los colores anteriores a sus valores predeterminados."
L.resetAllColorsDesc = "Si has personalizado los colores de cualquier encuentro con el jefe, este botón los restablecerá TODOS para que se usen los colores definidos aquí."

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

L.infobox_short = "Caja de información"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Dirige la salida de este complemento a través de la pantalla de mensajes de BigWigs. Esta pantalla soporta iconos, colores y puede mostrar hasta 4 mensajes en la pantalla a la vez. Los mensajes recién insertados crecerán en tamaño y se reducirán de nuevo rápidamente para notificar al usuario."
L.emphasizedSinkDescription = "Dirige la salida de este complemento a través de la pantalla de mensajes de BigWigs enfatizada. Esta pantalla admite texto y colores, y sólo puede mostrar un mensaje a la vez."
L.resetMessagesDesc = "Restablece todas las opciones relacionadas con los mensajes, incluyendo la posición de anclas de este."
L.toggleMessagesAnchorsBtnShow_desc = "Muestra todos los anclajes móviles, permitiendo mover los mensajes."

L.testMessagesBtn = "Crear un mensaje de prueba"
L.testMessagesBtn_desc = "Crea un mensaje para probar tus opciones actuales."

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

--L.messagesOptInHeaderOff = "Boss mod messages 'opt-in' mode: Enabling this option will turn off messages across ALL of your boss modules.\n\nYou will need to go through each one and manually turn on the messages you want.\n\n"
--L.messagesOptInHeaderOn = "Boss mod messages 'opt-in' mode is |cFF33FF99ACTIVE|r. To see boss mod messages, go into the settings of a specific boss ability and turn on the '|cFF33FF99Messages|r' option.\n\n"
--L.messagesOptInTitle = "Boss mod messages 'opt-in' mode"
--L.messagesOptInWarning = "|cffff4411WARNING!|r\n\nEnabling 'opt-in' mode will turn off messages across ALL of your boss modules. You will need to go through each one and manually turn on the messages you want.\n\nYour UI will now reload, are you sure?"

-----------------------------------------------------------------------
-- Nameplates.lua
--

L.nameplates = "Placa de nombre"
L.testNameplateIconBtn = "Mostrar icono de prueba"
L.testNameplateIconBtn_desc = "Crea un icono para que pruebe las opciones actuales en tu placa de nombre objetivo."
L.testNameplateTextBtn = "Mostrar texto de prueba"
L.testNameplateTextBtn_desc = "Crea un texto de prueba para que pruebes las opciones actuales en tu placa de nombre objetivo."
L.stopTestNameplateBtn = "Detener pruebas"
L.stopTestNameplateBtn_desc = "Detiene la prueba de iconos y textos en tus barras de nombre."
L.noNameplateTestTarget = "Necesitas de un objetivo hostil, atacable  para probar la funcionalidad de la placa de nombre."
L.anchoring = "Anclaje"
L.growStartPosition = "Posición inicial de crecimiento"
L.growStartPositionDesc = "La posición inicial del primer icono."
L.growDirection = "Dirección de crecimiento"
L.growDirectionDesc = "La dirección en la que los iconos saldrán, a partir de la posición inicial."
L.iconSpacingDesc = "Cambiar el espacio entre cada icono."
L.nameplateIconSettings = "Opciones de iconos"
L.keepAspectRatio = "Mantener el radio de aspecto"
L.keepAspectRatioDesc = "Mantener un radio de aspecto de 1:1 en vez de estirarlo para que cubra el tamaño del cuadro."
L.iconColor = "Color de icono"
L.iconColorDesc = "Cambiar el color de la textura del icono."
L.desaturate = "Desaturar"
L.desaturateDesc = "Desaturar la textura del icono."
L.zoom = "Zoom"
L.zoomDesc = "Zoom en la textura del icono."
L.showBorder = "Mostrar un borde"
L.showBorderDesc = "Mostrar un borde alrededor del icono."
L.borderColor = "Color del borde"
L.borderSize = "Tamaño del borde"
--L.borderOffset = "Border Offset"
--L.borderName = "Border Name"
L.showNumbers = "Mostrar números"
L.showNumbersDesc = "Mostrar números en el icono."
L.cooldown = "Enfriamiento"
--L.cooldownEmphasizeHeader = "By default, Emphasize is disabled (0 seconds). Setting it to 1 second or higher will enable Emphasize. This will allow you to set a different font color and font size for those numbers."
L.showCooldownSwipe = "Mostrar deslizador"
L.showCooldownSwipeDesc = "Mostrar un deslizador en el icono cuando el enfriamiento está activo."
L.showCooldownEdge = "Mostrar borde"
L.showCooldownEdgeDesc = "Mostrar un borde en el enfriamiento cuando este está activo."
L.inverse = "Invertir"
L.inverseSwipeDesc = "Invertir las animaciones de enfriamiento."
L.glow = "Brillo"
L.enableExpireGlow = "Habilitar el brillo de expiración"
L.enableExpireGlowDesc = "Mostrar un brillo alrededor del icono cuando el enfriamiento ha expirado."
L.glowColor = "Color de brillo"
L.glowType = "Tipo de brillo"
L.glowTypeDesc = "Cambia el tipo de brillo que se muestra alrededor del icono."
L.resetNameplateIconsDesc = "Resetea todas las opciones relacionadas con los iconos de las barras de nombre."
L.nameplateTextSettings = "Opciones de texto"
L.fixate_test = "Texto fijado" -- Text that displays to test on the frame
L.resetNameplateTextDesc = "Reiniciar todas las opciones relacionadas con el texto de las barras de nombre."
L.glowAt = "Comienza el brillo (segundos)"
L.glowAt_desc = "Elige cuantos segundos de enfriamiento deberian quedar cuando el brillo empieza."
--L.offsetX = "Offset X"
--L.offsetY = "Offset Y"
L.headerIconSizeTarget = "Tamaño de icono de tu objetivo actual"
L.headerIconSizeOthers = "El tamaño del icono de los otros objetivos"
--L.headerIconPositionTarget = "Icon position of your current target"
--L.headerIconPositionOthers = "Icon position of all other targets"

-- Glow types as part of LibCustomGlow
L.pixelGlow = "Brillo del pixel"
L.autocastGlow = "Autolanzar Brillo"
L.buttonGlow = "Brillo de botón"
L.procGlow = "Brillo del proc"
L.speed = "Velocidad"
L.animation_speed_desc = "La velocidad con la que la animación del brillo ocurre."
L.lines = "Lineas"
L.lines_glow_desc = "Número de lineas en la animación de brillo."
L.intensity = "Intensidad"
L.intensity_glow_desc = "La intensidad del efecto de brillo, mayor significa mas chispas."
L.length = "Largo"
L.length_glow_desc = "El largo de las lineas en la animación del brillo."
L.thickness = "Grosor"
L.thickness_glow_desc = "El grosor de las lineas en la animación de brillo."
L.scale = "Escala"
L.scale_glow_desc = "La escala del brillo en la animación."
L.startAnimation = "Comenzar animación"
L.startAnimation_glow_desc = "Este brillo tiene una animación de inicio, esto activara/desactivara dicha animación."

--L.nameplateOptInHeaderOff = "\n\n\n\nBoss mod nameplates 'opt-in' mode: Enabling this option will turn off nameplates across ALL of your boss modules.\n\nYou will need to go through each one and manually turn on the nameplates you want.\n\n"
--L.nameplateOptInHeaderOn = "\n\n\n\nBoss mod nameplates 'opt-in' mode is |cFF33FF99ACTIVE|r. To see boss mod nameplates, go into the settings of a specific boss ability and turn on the '|cFF33FF99Nameplates|r' option.\n\n"
--L.nameplateOptInTitle = "Boss mod nameplates 'opt-in' mode"
--L.nameplateOptInWarning = "|cffff4411WARNING!|r\n\nEnabling 'opt-in' mode will turn off nameplates across ALL of your boss modules. You will need to go through each one and manually turn on the nameplates you want.\n\nYour UI will now reload, are you sure?"

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
L.pullStartedBy = "%s Lanzó un pull."
L.pullStopped = "Temporizador de llamada de jefe cancelado por %s."
L.pullStoppedCombat = "Temporizador de llamada de jefe cancelado porque tu entraste en combate"
L.pullIn = "Llamada de jefe en %d seg"
L.sendPull = "Mandar un pull para tu grupo."
L.wrongPullFormat = "Contador inválido para el pull. Usa algo como: /pull 5"
L.countdownBegins = "Comenzar cuenta regresiva"
L.countdownBegins_desc = "Elige cuánto tiempo restante debe de quedar en la llamada de jefe (en segundos) cuando la cuenta regresiva comience."
L.pullExplainer = "\n|cFF33FF99/pull|r empezará una cuenta atrás normal.\n|cFF33FF99/pull 7|r empezará una cuenta atrás de 7 segundos, puedes utilizar cualquier número.\nO bien puedes asignar un atajo debajo.\n\n"
L.pullKeybindingDesc = "Elige un atajo para empezar una cuenta atrás."

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
L.privateaura = "Cuando un 'Aura Privada' esta sobre ti"

L.customSoundDesc = "Reproduce el sonido personalizado seleccionado en lugar del suministrado por el módulo."
L.resetSoundDesc = "Restablece los sonidos anteriores a sus valores predeterminados."
L.resetAllCustomSound = "Si has personalizado los sonidos para cualquier encuentro con el jefe, este botón los restablecerá TODOS para que se usen los sonidos definidos aquí."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossStatistics = "Estadísticas del jefe"
L.bossStatsDescription = "Registro de varias estadísticas relacionadas con los jefes como la cantidad de veces que has salido victorioso, la cantidad de veces que has sido derrotado, la fecha de la primera victoria y la victoria más rápida. Estas estadísticas se pueden ver en la ventana de configuración de cada jefe, pero permanecerán ocultas en los jefes que no tengan todavía registro de estadísticas."
L.createTimeBar = "Mostrar la barra 'Mejor tiempo'"
L.bestTimeBar = "Mejor tiempo"
L.healthPrint = "Vida: %s."
L.healthFormat = "%s (%.1f%%)"
L.chatMessages = "Mensajes de chat"
L.newFastestVictoryOption = "Nueva victoria más rápida"
L.victoryOption = "Fuiste victorioso"
L.defeatOption = "Fuiste derrotado"
L.bossHealthOption = "Vida del jefe"
L.bossVictoryPrint = "Fuiste victorioso ante '%s' despues de %s." -- You were victorious against 'BOSS_NAME' after COMBAT_DURATION.
L.bossDefeatPrint = "Fuiste derrotado por '%s' despues de %s." -- You were defeated by 'BOSS_NAME' after COMBAT_DURATION.
L.newFastestVictoryPrint = "Nueva victoria más rápida: (-%s)" -- New fastest victory: (-COMBAT_DURATION)

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
