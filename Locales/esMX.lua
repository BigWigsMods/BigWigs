local L = BigWigsAPI:NewLocale("BigWigs", "esMX")
if not L then return end

-- Core.lua
L.berserk = "Enfurecer"
L.berserk_desc = "Muestra un contador que avisa cuando el jefe entrará en enfurecer"
L.altpower = "Indicador de poder alternativo"
L.altpower_desc = "Muestra la ventana de poder alternativo, que indica la cantidad de poder alternativo que tienen los miembros de tu grupo."
L.infobox = "Caja de información"
L.infobox_desc = "Muestra un marco con información relacionada con el encuentro."
L.stages = "Fases"
L.stages_desc = "Activa funciones relacionadas con varias etapas/fases del jefe como cambios de etapa, barras de temporizador de duración de etapa, etc."
L.warmup = "Calentamiento"
L.warmup_desc = "Tiempo hasta que el combate con el jefe comience."
L.proximity = "Pantalla de proximidad"
L.proximity_desc = "Muestra la ventana de proximidad cuando sea apropiado para este encuentro, enumerando los jugadores que están demasiado cerca de ti."
L.adds = "Esbirros"
L.adds_desc = "Activa funciones relacionadas con los esbirros que aparecerán durante un encuentro con un jefe."
L.health = "Salud"
L.health_desc = "Activa funciones para mostrar varias informaciones de salud durante un encuentro con un jefe."

L.already_registered = "|cffff0000ATENCIÓN:|r |cff00ff00%s|r (|cffffff00%s|r) ya existe ese módulo en BigWigs, pero sin embargo está intentando registrarlo de nuevo. Esto normalmente ocurre cuando tienes varias copias de este módulo en tu carpeta de addons posiblemente por una actualización fallida. Es recomendable que borres la carpeta de BigWigs y lo reinstales por completo."
L.testNameplate = "Objetivo detectado, creando una barra test en la placa de nombre sobre la placa de nombre del objetivo. |cFF33FF99Esta funcionalidad se usa muy poco, suele ser de sólo 1 barra, y es necesaria para llevar la cuenta de los enfriamientos cuando se lucha contra varios jefes/esbirros que lanzan el mismo hechizo.|r"

-- Loader / Options.lua
L.officialRelease = "Estás usando la versión oficial de BigWigs %s (%s)"
L.alphaRelease = "Estás usando la VERSIÓN ALFA de BigWigs %s (%s)"
L.sourceCheckout = "Estás usando la versión de BigWigs %s directamente del repositorio."
L.guildRelease = "Estás usando la versión %d de BigWigs hecha para tu hermandad, basado en la versión %d del addon oficial."
L.getNewRelease = "Tu BigWigs está desactualizado (/bwv) pero puedes actualizarlo fácilmente con el cliente de CurseForge. También puedes actualizarlo manualmente desde curseforge.com o wowinterface.com."
L.warnTwoReleases = "Tu BigWigs está 2 versiones desactualizado! Tu versión puede tener fallos, faltarle características, o temporizadores incorrectos. Es muy recomendable que lo actualices."
L.warnSeveralReleases = "|cffff0000Tu BigWigs está desactualizado %d actualizaciones!! Te recomendamos MUCHÍSIMO que lo actualices cuanto antes para prevenir problemas de sincronización con otros jugadores!|r"
L.warnOldBase = "Estás usando la versión de hermandad de BigWigs (%d), pero tu versión base (%d) está %d versiones desactualizada. Esto puede provocar problemas."

L.tooltipHint = "|cffeda55fClic derecho|r para acceder a las opciones."
L.activeBossModules = "Módulos de jefes activos:"

L.oldVersionsInGroup = "Hay gente en tu grupo con versiones antiguas o sin BigWigs. Más detalles con /bwv."
L.upToDate = "Al día:"
L.outOfDate = "Desactualizado"
L.dbmUsers = "Jugadores con DBM:"
L.noBossMod = "Sin boss mod:"
L.offline = "Desconectado"

L.missingAddOn = "¡Falta el addon |cFF436EEE%s|r!"
L.disabledAddOn = "Tienes el addon |cFF436EEE%s|r desactivado, los contadores no se mostrarán."
L.removeAddOn = "Por favor elimina '|cFF436EEE%s|r' ya que está siendo reemplazado por '|cFF436EEE%s|r'."
L.alternativeName = "%s (|cFF436EEE%s|r)"

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
L.currentSeason = "Temporada actual"

-- Media.lua (These are the names of the sounds in the dropdown list in the "sounds" section)
L.Beware = "Cuidado (Algalon)"
L.FlagTaken = "Bandera tomada (JcJ)"
L.Destruction = "Destrucción (Kil'jaeden)"
L.RunAway = "Corre pequeña (El Lobo Feroz)"
L.spell_on_you = "BigWigs: Habilidad en ti"
L.spell_under_you = "BigWigs: Habilidad debajo de ti"

-- Options.lua
L.options = "Opciones"
L.optionsKey = "ID: %s" -- The ID that messages/bars/options use
L.raidBosses = "Jefes de Banda"
L.dungeonBosses = "Jefes de Calabozo"
L.introduction = "Bienvenido a BigWigs. Abróchate el cinturón y come cacahuetes mientras disfrutas del paseo. De manera no intrusiva te ayudará a preparar ese nuevo encuentro de banda como una cena de 7 platos para tu grupo de banda."
L.toggleAnchorsBtnShow = "Mostrar anclajes móviles"
L.toggleAnchorsBtnHide = "Ocultar anclajes móviles"
L.toggleAnchorsBtnShow_desc = "Muestra todos los anclajes móviles, permitiendo mover las barras, los mensajes, etc."
L.toggleAnchorsBtnHide_desc = "Oculta todos los anclajes móviles, bloqueanto todo en su lugar."
L.testBarsBtn = "Crear barra de prueba"
L.testBarsBtn_desc = "Crea barras para que las pruebes con los ajustes actuales"
L.sound = "Sonido"
L.minimapIcon = "Icono del minimapa"
L.minimapToggle = "Cambia entre mostrar/ocultar el icono en el minimapa."
L.compartmentMenu = "Sin icono de compartimento"
L.compartmentMenu_desc = "Al desactivar esta opción, BigWigs aparecerá en el menú de compartimiento de addon. Recomendamos dejar esta opción activada."
L.configure = "Configurar"
L.test = "Probar"
L.resetPositions = "Restablecer posiciones"
L.colors = "Colores"
L.selectEncounter = "Seleccionar encuentro"
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
L.SOUND = "Sonido"
L.SOUND_desc = "Las habilidades de jefes habitualmente reproducen sonidos para ayudarte con ellas. Si desactivas esta opción, ningún sonido adjunto sonará."
L.CASTBAR = "Barras de lanzamiento"
L.CASTBAR_desc = "Barras de lanzamiento se muestran a veces con ciertos jefes, normalmente para atraer la atención de que una habilidad crítica está en camino. Si esta habilidad está acompañada por una barra de lanzamiento que quieres ocultar, desactiva esta opción."
L.SAY_COUNTDOWN = "Decir cuenta regresiva"
L.SAY_COUNTDOWN_desc = "Las burbujas de chat son fáciles de detectar. BigWigs usará múltiples mensajes de cuenta regresiva para alertar a los que estén cerca que una habilidad en ti está a punto de expirar."
L.ME_ONLY_EMPHASIZE = "Enfatizar (sólo en mi)"
L.ME_ONLY_EMPHASIZE_desc = "Al activar esto enfatizará cualquier mensaje asociado con esta habilidad SÓLO si se lanza sobre ti, mostrándolo más grande y visible."
L.NAMEPLATEBAR = "Barras en placas de nombre"
L.NAMEPLATEBAR_desc = "Las barras algunas veces están pegadas a las placas de nombre cuando más de un objetivo lanza el mismo hechizo. Si esta habilidad está acompañada por una barra de placa de nombre que quieres ocultar, desactiva esta opción."
L.PRIVATE = "Aura privada"
L.PRIVATE_desc = "Las auras privadas no se pueden rastrear normalmente, pero el sonido \"sobre ti\" (aviso) se puede configurar en la pestaña Sonido."

L.advanced = "Opciones avanzadas"
L.back = "<< Volver"

L.tank = "|cFFFF0000Solo alertas para tanques.|r "
L.healer = "|cFFFF0000Solo alertas para sanadores.|r "
L.tankhealer = "|cFFFF0000Solo alertas para tanque y sanador.|r "
L.dispeller = "|cFFFF0000Alertas para dispelear únicamente.|r "

-- Statistics
L.statistics = "Estadísticas"
L.LFR = "Buscar Banda"
L.normal = "Normal"
L.heroic = "Heroico"
L.mythic = "Mítico"
L.wipes = "Derrotas:"
L.kills = "Muertes:"
L.best = "El mejor:"
