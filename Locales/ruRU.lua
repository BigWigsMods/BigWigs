local L = BigWigsAPI:NewLocale("BigWigs", "ruRU")
if not L then return end

L.tempMessage = "Позиции панелей были изменены. Теперь возможен импорт/экспорт конфигурации."

-- Core.lua
L.berserk = "Берсерк"
L.berserk_desc = "Предупреждать и отсчитывать время до берсерка."
L.altpower = "Отображение альтернативной энергии"
L.altpower_desc = "Показывать окно с альтернативной энергией, в котором выводится информация о значениях этой энергии для каждого игрока вашего рейда."
L.infobox = "Информационный блок"
L.infobox_desc = "Показать блок с информацией, связанной с текущим боем."
L.stages = "Фазы"
L.stages_desc = "Включает функционал, связанный с различными фазами боя, такие как уведомление о смене фазы, полоска длительности фазы, и т.д."
L.warmup = "Подготовка"
L.warmup_desc = "Время, когда начнется схватка с боссом."
L.proximity = "Отображение близости"
L.proximity_desc = "Показывать окно близости при соответствующей схватке, выводя список игроков, которые стоят слишком близко к вам."
L.adds = "Адды"
L.adds_desc = "Включает функционал связанный с различными помощниками во время боя с боссом."
L.health = "Здоровье"
L.health_desc = "Активирует отображение различной информации, связанной со здоровьем во время боя с боссом."

L.already_registered = "|cffff0000ВНИМАНИЕ:|r |cff00ff00%s|r (|cffffff00%s|r) уже загружен как модуль BigWigs, но что-то пытается зарегистрировать его ещё раз. Обычно, это означает, что у вас две копии этого модуля в папке с модификациями (возможно, из-за ошибки программы для обновления модификаций). Мы рекомендуем вам удалить все папки BigWigs и установить его с нуля."

-- Loader / Options.lua
L.okay = "OK"
L.officialRelease = "Вы используете официальную версию BigWigs %s (%s)"
L.alphaRelease = "Вы используете АЛЬФА-ВЕРСИЮ BigWigs %s (%s)"
L.sourceCheckout = "Вы используете отладочный BigWigs %s прямо из репозитория."
L.guildRelease = "Вы используете версию %d BigWigs, созданную для вашей гильдии на версии %d официального дополнения."
L.getNewRelease = "Ваш BigWigs устарел(/bwv), но вы можете легко его обновить с помощью CurseForge Client. Также, Вы можете обновиться вручную на сайтах curseforge.com или wowinterface.com."
L.warnTwoReleases = "Ваш BigWigs устарел на две версии! Ваша версию может содержать ошибки, меньше возможностей, а может быть и неправильные таймеры. Крайне рекомендуется обновиться."
L.warnSeveralReleases = "|cffff0000Ваш BigWigs устарел на %d версий!! ОЧЕНЬ рекомендуется обновиться, чтобы предотвратить ошибки синхронизации с другими игроками!|r"
L.warnOldBase = "Вы используете версию для гильдии BigWigs (%d), но ваша базовая версия (%d) на %d версий устарела. Это может вызвать проблемы."

L.tooltipHint = "|cffeda55fПравый клик|r открыть настройки."
L.activeBossModules = "Активные модули боссов:"

L.oldVersionsInGroup = "В вашей группе есть игроки с устаревшими версиями или без BigWigs. Для получения более подробной информации введите команду /bwv." -- XXX needs updated
L.upToDate = "Текущий:"
L.outOfDate = "Устарело:"
L.dbmUsers = "Пользователи DBM:"
L.noBossMod = "Нет аддона:"
L.offline = "Не в сети"

L.missingAddOn = "Отсутствует модификация |cFF436EEE%s|r."
L.disabledAddOn = "У вас выключена модификация |cFF436EEE%s|r, таймеры не будут показываться."
L.removeAddOn = "Пожалуйста, удалите '|cFF436EEE%s|r', ему на смену пришло '|cFF436EEE%s|r'."
L.alternativeName = "%s (|cFF436EEE%s|r)"

L.expansionNames = {
	"Классика", -- Classic
	"The Burning Crusade", -- The Burning Crusade -- would rather leave untranslated
	"Гнев Короля Лича", -- Wrath of the Lich King
	"Катаклизм", -- Cataclysm
	"Туманы Пандарии", -- Mists of Pandaria
	"Воеводы Дренора", -- Warlords of Draenor
	"Легион", -- Legion
	"Битва за Азерот", -- Battle for Azeroth
	"Темные Земли", -- Shadowlands
	"Dragonflight", -- Dragonflight -- Can't figure a out a good way to translate this
	"The War Within", -- The War Within
}
L.littleWigsExtras = {
	["LittleWigs_Delves"] = "Delves",
	["LittleWigs_CurrentSeason"] = "Текущий сезон",
}

-- Media.lua (These are the names of the sounds in the dropdown list in the "sounds" section)
L.Beware = "Берегитесь (Алгалон)"
L.FlagTaken = "Взятие флага (PvP)"
L.Destruction = "Разрушение (Кил'джеден)"
L.RunAway = "Беги, малышка, беги (Злой и страшный серый волк)"
L.spell_on_you = "BigWigs: Заклинание на тебе"
L.spell_under_you = "BigWigs: Заклинание под тобой"

-- Options.lua
L.options = "Настройки"
L.optionsKey = "ID заклинания: %s" -- The ID that messages/bars/options use
L.raidBosses = "Рейдовые боссы"
L.dungeonBosses = "Боссы подземелий"
L.introduction = "Добро пожаловать в BigWigs, где бродят боссы. Пожалуйста, пристегните ремни безопасности, запаситесь печеньками и наслаждайтесь поездкой. Он не cъест ваших детей, но поможет подготовиться к встречи с новыми боссами, словно для обеда из 7-ми блюд вашего рейда."
L.sound = "Звук"
L.minimapIcon = "Иконка у миникарты"
L.minimapToggle = "Показать/скрыть иконку у миникарты."
L.compartmentMenu = "Не показывать иконку в списке карты"
L.compartmentMenu_desc = "Отключение этой настройки будет показывать BigWigs в списке аддонов возле карты. Советуется оставить эту настройку активной."
L.configure = "Настройка"
L.resetPositions = "Сброс позиции"
L.colors = "Цвета"
L.selectEncounter = "Выберите схватку"
L.privateAuraSounds = "Приватные Ауры - Звуки"
L.privateAuraSounds_desc = "Приватные ауры нельзя отслеживать стандартным методом, но есть возможность настроить звук, если вы цель заклинания."
L.listAbilities = "Вывести способности в групповой чат"

L.dbmFaker = "Маскировка под DBM"
L.dbmFakerDesc = "Если пользователь DBM делает проверку версий, чтобы увидеть у кого стоит аддон, он обнаружит вас в этом списке. Полезно для гильдий, которые заставляют использовать DBM."
L.zoneMessages = "Показывать сообщения для игровой зоны"
L.zoneMessagesDesc = "Отключив, вы перестанете получать сообщения при входе в зону, для которой нет таймеров BigWigs. Мы рекомендуем оставить включенной, чтобы в случае создания таймеров для новой зоны, вы могли сразу узнать об этом."
L.englishSayMessages = "Сообщения в чат только на Английском"
L.englishSayMessagesDesc = "Все сообщения типа 'сказать' и 'крикруть' во время босса будут всегда отправленны исключительно на английском языке. Потенциально полезно, если в группе игроки с разными родными языками."

L.slashDescTitle = "|cFFFED000Быстрые команды:|r"
L.slashDescPull = "|cFFFED000/pull:|r Отправляет отсчет атаки в рейд."
L.slashDescBreak = "|cFFFED000/break:|r Отправляет таймер перерыва в рейд."
L.slashDescRaidBar = "|cFFFED000/raidbar:|r Отправляет свою полосу в рейд."
L.slashDescLocalBar = "|cFFFED000/localbar:|r Создает таймер, который видите только вы."
L.slashDescRange = "|cFFFED000/range:|r Открывает индикатор близости."
L.slashDescVersion = "|cFFFED000/bwv:|r Выполняет проверку версий BigWigs."
L.slashDescConfig = "|cFFFED000/bw:|r Открывает настройки BigWigs."

L.gitHubDesc = "|cFF33FF99BigWigs это программное обеспечение с открытым исходным кодом, который размещен на GitHub. Мы всегда ищем новых людей, чтобы помочь нам, и каждый желающий может осмотреть наш код, внести свой вклад и отправить отчеты об ошибках. BigWigs хорош, только благодаря помощи большей части сообщества WoW.|r"

L.BAR = "Полосы"
L.MESSAGE = "Сообщения"
L.ICON = "Иконка"
L.SAY = "Сказать"
L.FLASH = "Мигание"
L.EMPHASIZE = "Увеличение"
L.ME_ONLY = "Только, когда на мне"
L.ME_ONLY_desc = "Когда вы включите данную опцию, сообщения для способности будут показываться, только если затрагивают вас. Например, 'Бомба: Игрок' будет показываться только, когда на вас."
L.PULSE = "Импульс"
L.PULSE_desc = "В дополнение к мигающему экрану, вы также получите иконку, связанную с конкретной способностью, в центре экрана, для привлечения внимания."
L.MESSAGE_desc = "Большинство способностей сопровождаются одним или несколькими сообщениями, которые BigWigs будет отображать на экране. Если вы отключите эту опцию, существующие сообщения не будут отображаться."
L.BAR_desc = "Полосы отображаются для некоторых способностей, если это необходимо. Если способность сопровождается полоской, которую вы хотите скрыть, отключите эту опцию"
L.FLASH_desc = "Некоторые способности могут быть более важными, чем другие. Если вы хотите, чтобы ваш экран мигал, при использовании таких способностей, отметьте эту опцию."
L.ICON_desc = "BigWigs может отмечать пострадавших от способностей иконкой. Это способствует их легкому обнаружению."
L.SAY_desc = "Сообщения над головами персонажей легко обнаружить. BigWigs будет использовать канал 'cказать' для оповещения персонажей поблизости, если на вас враждебный эффект."
L.EMPHASIZE_desc = "Включение этой опции увеличит любые сообщения связанные с данной способностью, делая их более видимыми. Вы можете настроить размер и шрифт увеличенных сообщений в главных настройках \"Сообщений\"."
L.PROXIMITY = "Радар"
L.PROXIMITY_desc = "Иногда способности требуют от вас рассредоточиться. Отображение близости будет специально показываться для таких способностей, так что вы сможете понять с одного взгляда, в безопасности вы или нет."
L.ALTPOWER = "Отображение альтернативной энергии"
L.ALTPOWER_desc = "Некоторые битвы используют механику альтернативной энергии. Отображение альтернативной энергии позволяет увидеть минимальные и максимальные значения энергии, что может пригодится для определенных видов тактик."
L.TANK = "Только танки"
L.TANK_desc = "Некоторые способности важны только для танков. Если вы хотите видеть предупреждения для таких способностей, несмотря на вашу роль, отключите эту опцию."
L.HEALER = "Только лекари"
L.HEALER_desc = "Некоторые способности важны только для лекарей. Если вы хотите видеть предупреждения для таких способностей, несмотря на вашу роль, отключите эту опцию."
L.TANK_HEALER = "Только танки и лекари"
L.TANK_HEALER_desc = "Некоторые способности важны только для танков и лекарей. Если вы хотите видеть предупреждения для таких способностей, несмотря на вашу роль, отключите эту опцию."
L.DISPEL = "Только для рассеивателей"
L.DISPEL_desc = "Если вы хотите видеть предупреждения для способности, которую не можете рассеять, отключите опцию."
L.VOICE = "Голосовое оповещение"
L.VOICE_desc = "Если установлен плагин голосового оповещения, эта опция позволит проиграть звуковой файл с голосовым предупреждением для вас."
L.COUNTDOWN = "Обратный отсчет"
L.COUNTDOWN_desc = "Если включено, будет звуковое и визуальное оповещение обратного отсчета 5 последних секунд. Представьте, кто-то отсчитывает \"5... 4... 3... 2... 1...\" большими цифрами посередине экрана."
L.CASTBAR_COUNTDOWN = "Отсчёт (только полоски заклинаний)"
L.CASTBAR_COUNTDOWN_desc = "Если включено, звуковой и аудиоотсчёт будет добавлен для последних 5 секунд полоски."
L.INFOBOX = L.infobox
L.INFOBOX_desc = L.infobox_desc
L.SOUND = "Звук"
L.SOUND_desc = "Во время произнесения заклинаний боссов обычно воспроизводится звук. При отключении этой опции ни один из звуков не будет воспроизведён."
L.CASTBAR = "Полосы применения"
L.CASTBAR_desc = "Полосы применения заклинаний иногда отображаются на определённых боссах, чтобы привлечь внимание к важной способности. Если эта способность сопровождается полосой применения, которую вы хотите скрыть, отключите данную опцию."
L.SAY_COUNTDOWN = "Отсчет в /сказать"
L.SAY_COUNTDOWN_desc = "Облачка чата легко заметить. BigWigs будет производить отсчет в /сказать, чтобы оповестить рядом стоящих игроков об окончании времени способности на Вас."
L.ME_ONLY_EMPHASIZE = "Выделить (только для себя)"
L.ME_ONLY_EMPHASIZE_desc = "С включенной опцией все сообщения, связанные с данной способностью будут выделены ТОЛЬКО тогда, когда использованы на Вас, становясь более заметными."
L.NAMEPLATEBAR = "Полосы неймплейтов"
L.NAMEPLATEBAR_desc = "Полосы прикрепляются к неймплейтам, когда более чем один моб одновременно применяет одинаковое заклинание. Если вы хотите убрать эти полосы с неймплейтов, выключите данную опцию."
L.PRIVATE = "Приватные ауры"
L.PRIVATE_desc = "Приватные ауры не могут быть отслежены как обычно, но звуковое уведомление \"на себе\" может быть включено во вкладке Звука."

L.advanced = "Дополнительные настройки"
L.back = "<< Назад"

L.tank = "|cFFFF0000Только для танков.|r "
L.healer = "|cFFFF0000Только для лекарей.|r "
L.tankhealer = "|cFFFF0000Только для танков и лекарей.|r "
L.dispeller = "|cFFFF0000Только для рассеивателей.|r "

-- Sharing.lua
--L.import = "Import"
--L.import_info = "After entering a string you can select what settings you would like to import.\nIf settings are not available in the import string they will not be selectable.\n\nThis import will only affect the general settings and does not affect boss specific settings."
--L.import_info_active = "Choose what parts you would like to import and then click the import button."
--L.import_info_none = "|cFFFF0000The import string is incompatible or out of date.|r"
--L.export = "Export"
--L.export_info = "Select which settings you would like to export and share with others.\n\nYou can only share general settings and these have no effect on boss specific settings."
--L.export_string = "Export String"
--L.export_string_desc = "Copy this BigWigs string if you want to share your settings."
--L.import_string = "Import String"
--L.import_string_desc = "Paste the BigWigs string you want to import here."
--L.position = "Position"
--L.settings = "Settings"
--L.position_import_bars_desc = "Import the position (anchors) of the bars."
--L.position_import_messages_desc = "Import the position (anchors) of the messages."
--L.position_import_countdown_desc = "Import the position (anchors) of the countdown."
--L.position_export_bars_desc = "Export the position (anchors) of the bars."
--L.position_export_messages_desc = "Export the position (anchors) of the messages."
--L.position_export_countdown_desc = "Export the position (anchors) of the countdown."
--L.settings_import_bars_desc = "Import the general bar settings such as size, font, etc."
--L.settings_import_messages_desc = "Import the general message settings such as size, font, etc."
--L.settings_import_countdown_desc = "Import the general countdown settings such as voice, size, font, etc."
--L.settings_export_bars_desc = "Export the general bar settings such as size, font, etc."
--L.settings_export_messages_desc = "Export the general message settings such as size, font, etc."
--L.settings_export_countdown_desc = "Export the general countdown settings such as voice, size, font, etc."
--L.colors_import_bars_desc = "Import the colors of the bars."
--L.colors_import_messages_desc = "Import the colors of the messages."
--L.color_import_countdown_desc = "Import the color of the countdown."
--L.colors_export_bars_desc = "Export the colors of the bars."
--L.colors_export_messages_desc = "Export the colors of the messages."
--L.color_export_countdown_desc = "Export the color of the countdown."
--L.confirm_import = "The selected settings you are about to import will overwrite the settings in your currently selected profile:\n\n|cFF33FF99\"%s\"|r\n\nAre you sure you want to do this?"
--L.confirm_import_addon = "The addon |cFF436EEE\"%s\"|r wants to automatically import new BigWigs settings that will overwrite the settings in your currently selected BigWigs profile:\n\n|cFF33FF99\"%s\"|r\n\nAre you sure you want to do this?"
--L.confirm_import_addon_new_profile = "The addon |cFF436EEE\"%s\"|r wants to automatically create a new BigWigs profile called:\n\n|cFF33FF99\"%s\"|r\n\nAccepting this new profile will also swap to it."
--L.confirm_import_addon_edit_profile = "The addon |cFF436EEE\"%s\"|r wants to automatically edit one of your BigWigs profiles called:\n\n|cFF33FF99\"%s\"|r\n\nAccepting these changes will also swap to it."
--L.no_string_available = "No import string stored to import. First import a string."
--L.no_import_message = "No settings were imported."
--L.import_success = "Imported: %s" -- Imported: Bar Anchors, Message Colors
--L.imported_bar_positions = "Bar Positions"
--L.imported_bar_settings = "Bar Settings"
--L.imported_bar_colors = "Bar Colors"
--L.imported_message_positions = "Message Positions"
--L.imported_message_settings = "Message Settings"
--L.imported_message_colors = "Message Colors"
--L.imported_countdown_position = "Countdown Position"
--L.imported_countdown_settings = "Countdown Settings"
--L.imported_countdown_color = "Countdown Color"

-- Statistics
L.statistics = "Статистика"
L.LFR = "LFR"
L.normal = "Обычный"
L.heroic = "Героический"
L.mythic = "Эпохальный"
L.wipes = "Поражений:"
L.kills = "Побед:"
L.best = "Лучшее:"
--L.SOD = "Unknown"
--L.level1 = "Level 1"
--L.level2 = "Level 2"
--L.level3 = "Level 3"
