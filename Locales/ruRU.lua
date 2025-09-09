local _, addonTbl = ...
local L = addonTbl.API:NewLocale("BigWigs", "ruRU")
if not L then return end

-- API.lua
L.showAddonBar = "Аддон '%s' создал '%s' полосу длительности."

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
L.energy = "Энергия"
L.energy_desc = "Активирует отображение различной информации, связанной с уровнями энергии во время боя с боссом."

L.already_registered = "|cffff0000ВНИМАНИЕ:|r |cff00ff00%s|r (|cffffff00%s|r) уже загружен как модуль BigWigs, но что-то пытается зарегистрировать его ещё раз. Обычно, это означает, что у вас две копии этого модуля в папке с модификациями (возможно, из-за ошибки программы для обновления модификаций). Мы рекомендуем вам удалить все папки BigWigs и установить его с нуля."

-- Loader / Options.lua
L.okay = "OK"
L.officialRelease = "Вы используете официальную версию BigWigs %s (%s)."
L.alphaRelease = "Вы используете АЛЬФА-ВЕРСИЮ BigWigs %s (%s)."
L.sourceCheckout = "Вы используете отладочный BigWigs %s прямо из репозитория."
L.littlewigsOfficialRelease = "Вы используете официальную версию LittleWigs (%s)."
L.littlewigsAlphaRelease = "Вы используете АЛЬФА-ВЕРСИЮ LittleWigs (%s)."
L.littlewigsSourceCheckout = "Вы используете отладочный LittleWigs прямо из репозитория."
L.guildRelease = "Вы используете версию %d BigWigs, созданную для вашей гильдии на версии %d официального дополнения."
L.getNewRelease = "Ваш BigWigs устарел(/bwv), но вы можете легко его обновить с помощью CurseForge Client. Также, Вы можете обновиться вручную на сайтах curseforge.com или addons.wago.io."
L.warnTwoReleases = "Ваш BigWigs устарел на две версии! Ваша версию может содержать ошибки, меньше возможностей, а может быть и неправильные таймеры. Крайне рекомендуется обновиться."
L.warnSeveralReleases = "|cffff0000Ваш BigWigs устарел на %d версий!! ОЧЕНЬ рекомендуется обновиться, чтобы предотвратить ошибки синхронизации с другими игроками!|r"
L.warnOldBase = "Вы используете версию для гильдии BigWigs (%d), но ваша базовая версия (%d) на %d версий устарела. Это может вызвать проблемы."

L.tooltipHint = "|cffeda55fПравый клик|r открыть настройки."
L.activeBossModules = "Активные модули боссов:"

L.oldVersionsInGroup = "В вашей группе есть игроки с устаревшими версиями BigWigs. Для получения более подробной информации введите команду /bwv."
L.upToDate = "Текущий:"
L.outOfDate = "Устарело:"
L.dbmUsers = "Пользователи DBM:"
L.noBossMod = "Нет аддона:"
L.offline = "Не в сети"

L.missingAddOnPopup = "Отсутствует модификация |cFF436EEE%s|r."
L.missingAddOnRaidWarning = "Отсутствует модификация |cFF436EEE%s|r. В этой зоне не будут отображаться таймеры!"
L.outOfDateAddOnPopup = "Аддон |cFF436EEE%s|r устарел!"
L.outOfDateAddOnRaidWarning = "Аддон |cFF436EEE%s|r устарел! Текущая версия: v%d.%d.%d последняя: v%d.%d.%d!"
L.disabledAddOn = "У вас выключена модификация |cFF436EEE%s|r, таймеры не будут показываться."
L.removeAddOn = "Пожалуйста, удалите '|cFF436EEE%s|r', ему на смену пришло '|cFF436EEE%s|r'."
L.alternativeName = "%s (|cFF436EEE%s|r)"
L.outOfDateContentPopup = "ВНИМАНИЕ!\nВы обновили |cFF436EEE%s|r но необходимо также обновить основную модификацию |cFF436EEEBigWigs|r .\nИгнорирование приведёт к ошибочному функционированию."
L.outOfDateContentRaidWarning = "|cFF436EEE%s|r требует %d версию основной модификации |cFF436EEEBigWigs|r для грамотного функционирования. Текущая версия - %d."
L.addOnLoadFailedWithReason = "BigWigs не смог загрузить аддон |cFF436EEE%s|r по причине: %q. Сообщи разрабу BigWigs!"
L.addOnLoadFailedUnknownError = "BigWigs вызвал ошибку при попытке загрузить аддон |cFF436EEE%s|r. Сообщи разрабу BigWigs!"

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
	["LittleWigs_Delves"] = "Вылазки",
	["LittleWigs_CurrentSeason"] = "Текущий сезон",
}

-- Media.lua (These are the names of the sounds in the dropdown list in the "sounds" section)
L.Beware = "Берегитесь (Алгалон)"
L.FlagTaken = "Взятие флага (PvP)"
L.Destruction = "Разрушение (Кил'джеден)"
L.RunAway = "Беги, малышка, беги (Злой и страшный серый волк)"
L.spell_on_you = "BigWigs: Заклинание на тебе"
L.spell_under_you = "BigWigs: Заклинание под тобой"
L.simple_no_voice = "Простой (без звука)"

-- Options.lua
L.options = "Настройки"
L.optionsKey = "ID: %s" -- The ID that messages/bars/options use
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
L.SOUND = L.sound
L.SOUND_desc = "Во время произнесения заклинаний боссов обычно воспроизводится звук. При отключении этой опции ни один из звуков не будет воспроизведён."
L.CASTBAR = "Полосы применения"
L.CASTBAR_desc = "Полосы применения заклинаний иногда отображаются на определённых боссах, чтобы привлечь внимание к важной способности. Если эта способность сопровождается полосой применения, которую вы хотите скрыть, отключите данную опцию."
L.SAY_COUNTDOWN = "Отсчет в /сказать"
L.SAY_COUNTDOWN_desc = "Облачка чата легко заметить. BigWigs будет производить отсчет в /сказать, чтобы оповестить рядом стоящих игроков об окончании времени способности на Вас."
L.ME_ONLY_EMPHASIZE = "Выделить (только для себя)"
L.ME_ONLY_EMPHASIZE_desc = "С включенной опцией все сообщения, связанные с данной способностью будут выделены ТОЛЬКО тогда, когда использованы на Вас, становясь более заметными."
L.NAMEPLATE = "Полосы здоровья"
L.NAMEPLATE_desc = "С включенной опцией, функционал связанный с иконком или текстом, связанный с данной способностью, будет активирован. Это упрощает процесс поиска НПЦ, который использует данную способность, когда таких НПЦ несколько."
L.PRIVATE = "Приватные ауры"
L.PRIVATE_desc = "Приватные ауры не могут быть отслежены как обычно, но звуковое уведомление \"на себе\" может быть включено во вкладке Звука."

L.advanced_options = "Дополнительные настройки"
L.back = "<< Назад"

L.tank = "|cFFFF0000Только для танков.|r "
L.healer = "|cFFFF0000Только для лекарей.|r "
L.tankhealer = "|cFFFF0000Только для танков и лекарей.|r "
L.dispeller = "|cFFFF0000Только для рассеивателей.|r "

-- Sharing.lua
L.import = "Импорт"
L.import_info = "После ввода строки, выберите, какие настройки вы хотите импортировать.\nЕсли настройки не доступны в строке импорта, их нельзя будет выбрать.\n\n|cffff4411Копируются только общие настройки, не затрагивая конкретных боссов.|r"
L.import_info_active = "Выберите, какие настройки вы хотите импортировать, а затем нажмите кнопку импорта."
L.import_info_none = "|cFFFF0000Строка импорта устарела либо несовместима.|r"
L.export = "Экспорт"
L.export_info = "Выбрать настроки, которыми вы хотите поделиться экспортом.\n\n|cffff4411Копируются только общие настройки, не затрагивая конкретных боссов.|r"
L.export_string = "Строка экспорта"
L.export_string_desc = "Скопируйте эту строку, что бы победиться настройками."
L.import_string = "Строка импорта"
L.import_string_desc = "Вставьте сюда строку импорта."
L.position = "Позиция"
L.settings = "Настройки"
L.other_settings = "Другие настройки"
L.nameplate_settings_import_desc = "Импортировать все настройки полос здоровья."
L.nameplate_settings_export_desc = "Экспорт всех настроек полос здоровья."
L.position_import_bars_desc = "Импортировать позицию (якоря) полос."
L.position_import_messages_desc = "Импортировать позицию (якоря) сообщений."
L.position_import_countdown_desc = "Импортировать позицию (якоря) отсчёта."
L.position_export_bars_desc = "Экспортировать позицию (якоря) полос."
L.position_export_messages_desc = "Экспортировать позицию (якоря) сообщений."
L.position_export_countdown_desc = "Экспортировать позицию (якоря) отсчёта."
L.settings_import_bars_desc = "Импортировать общие настройки полос, такие как размер, шрифт и т.д."
L.settings_import_messages_desc = "Импортировать общие настройки сообщений, такие как размер, шрифт и т.д."
L.settings_import_countdown_desc = "Импортировать общие настройки отсчёта, такие как размер, шрифт и т.д."
L.settings_export_bars_desc = "Экспортировать общие настройки полос, такие как размер, шрифт и т.д."
L.settings_export_messages_desc = "Экспортировать общие настройки сообщений, такие как размер, шрифт и т.д."
L.settings_export_countdown_desc = "Экспортировать общие настройки отсчёта, такие как размер, шрифт и т.д."
L.colors_import_bars_desc = "Импортировать цвета полос."
L.colors_import_messages_desc = "Импортировать цвета сообщений."
L.color_import_countdown_desc = "Импортировать цвет отсчёта."
L.colors_export_bars_desc = "Экспортировать цвета полос."
L.colors_export_messages_desc = "Экспортировать цвета сообщений."
L.color_export_countdown_desc = "Экспортировать цвет отсчёта."
L.confirm_import = "Выбранные настройки строки импорта перезапишут настройки в текущем профиле: \n\n|cFF33FF99\"%s\"|r\n\nВы уверенны, что хотите это сделать ?"
L.confirm_import_addon = "Модификация |cFF436EEE\"%s\"|r хочет импортировать настройки BigWigs, перезаписал настройки текущего профиля: \n\n|cFF33FF99\"%s\"|r\n\nВы уверенны, что хотите это сделать ?"
L.confirm_import_addon_new_profile = "Модификация |cFF436EEE\"%s\"|r хочет создать новый профиль BigWigs: \n\n|cFF33FF99\"%s\"|r\n\nПринятия этих изменений переключит профиль на этот."
L.confirm_import_addon_edit_profile = "Модификация |cFF436EEE\"%s\"|r хочет отредактировать один из профилей BigWigs: \n\n|cFF33FF99\"%s\"|r\n\nПринятия этих изменений переключит профиль на этот."
L.no_string_available = "В строке импорте не найдено текста. Сперва импортируйте строку."
L.no_import_message = "Никакие настройки не были импортированны."
L.import_success = "Импортированно: %s" -- Imported: Bar Anchors, Message Colors
L.imported_bar_positions = "Полосы: позиция" -- Intentionally used this format to make it easier on the first glance. Would need to swap first and second words otherwise. Refers to all further lines
L.imported_bar_settings = "Полосы: настройки"
L.imported_bar_colors = "Полосы: цвет"
L.imported_message_positions = "Сообщения: позиция"
L.imported_message_settings = "Сообщения: настройки"
L.imported_message_colors = "Сообщения: цвет"
L.imported_countdown_position = "Отсчёт: позиция"
L.imported_countdown_settings = "Отсчёт: настройки"
L.imported_countdown_color = "Отсчёт: цвет"
L.imported_nameplate_settings = "Настройки полос здоровья"
--L.imported_mythicplus_settings = "Mythic+ Settings"
--L.mythicplus_settings_import_desc = "Import all Mythic+ settings."
--L.mythicplus_settings_export_desc = "Export all Mythic+ settings."
--L.imported_battleres_settings = "Battle Res Settings"
--L.battleres_settings_import_desc = "Import all Battle Res settings."
--L.battleres_settings_export_desc = "Export all Battle Res settings."

-- Statistics
L.statistics = "Статистика"
L.defeat = "Поражение"
L.defeat_desc = "Общее количество поражений от этого босса."
L.victory = "Победа"
L.victory_desc = "Общее количество побед этого босса."
L.fastest = "Самый быстрый"
L.fastest_desc = "Самая быстрая победа, и её дата (Год/Месяц/День)"
L.first = "Первый"
L.first_desc = "Когда первый раз была одержана победа против этого босса, формат:\n[Количество проигрышей до первой победы] - [Длительность боя] - [Год/Месяц/День победы]"

-- Difficulty levels for statistics display on bosses
L.unknown = "Неизвестно"
L.LFR = "LFR"
L.normal = "Обычный"
L.heroic = "Героический"
L.mythic = "Эпохальный"
L.timewalk = "Путешествие во времени"
L.solotier8 = "Соло Уровень 8"
L.solotier11 = "Соло Уровень 11"
L.story = "История"
L.mplus = "М+ %d"
L.SOD = "Сезон Открытий"
L.hardcore = "Хардкор"
L.level1 = "Уровень 1"
L.level2 = "Уровень 2"
L.level3 = "Уровень 3"
L.N10 = "Нормал 10"
L.N25 = "Нормал 25"
L.H10 = "Героик 10"
L.H25 = "Героик 25"

-----------------------------------------------------------------------
-- TOOLS
-----------------------------------------------------------------------

L.tools = "Инструменты"
L.toolsDesc = "BigWigs предоставляет различные инструменты или \"упрощающие жизнь\" функции для ускорения и упрощения процесса убийства боссов."

-----------------------------------------------------------------------
-- AutoRole.lua
--

L.autoRoleTitle = "Автовыбор роли"
L.autoRoleExplainer = "При вступлении в группу или изменении специализации, BigWigs будет автоматически менять вашу роль в группе (Танк, Лекарь, Боец).\n\n"

-----------------------------------------------------------------------
-- BattleRes.lua
--

--L.battleResTitle = "Battle Res"
--L.battleResDesc = "An icon that shows how many battle resurrection charges are available and the time until another charge is gained."
--L.battleResDesc2 = "\nYour |cFF33FF99Battle Resurrection History|r can be viewed in the tooltip when you mouse over the icon.\n\n"
--L.battleResHistory = "Battle Res History:"
--L.battleResResetAll = "Reset all the Battle Resurrection settings to their default values."
--L.battleResDurationText = "Duration Text"
--L.battleResChargesText = "Charges Text"
--L.battleResNoCharges = "0 charges available"
--L.battleResHasCharges = "1 or more charges available"
--L.battleResPlaySound = "Play a sound when a new charge is gained"
--L.iconTextureSpellID = "|T%d:0:0:0:0:64:64:4:60:4:60|t Icon Texture (Spell ID)"
--L.iconTextureSpellIDError = "You must type a valid spell ID to use as the icon texture."
--L.battleResModeIcon = "Mode: Icon"
--L.battleResModeText = "Mode: Text Only"
--L.battleResModeTextTooltip = "Showing a temporary background to help you move the Battle Res feature and to see where the mouseover area is."

-----------------------------------------------------------------------
-- Keystones.lua
--

L.keystoneTitle = "BigWigs: Эпохальные подземелья"
L.keystoneHeaderParty = "Группа"
L.keystoneRefreshParty = "Обновить ключи у группы"
L.keystoneHeaderGuild = "Гильдия"
L.keystoneRefreshGuild = "Обновить ключи у гильдии"
L.keystoneLevelTooltip = "Уровень ключа: |cFFFFFFFF%s|r"
L.keystoneMapTooltip = "Подземелье: |cFFFFFFFF%s|r"
L.keystoneRatingTooltip = "Эпохальный+ рейтинг: |cFFFFFFFF%d|r"
L.keystoneHiddenTooltip = "Игрок предпочёл скрыть эту информацию."
L.keystoneTabOnline = "Онлайн"
L.keystoneTabAlts = "Альты"
L.keystoneTabTeleports = "Телепорты"
L.keystoneHeaderMyCharacters = "Мои персонажи"
L.keystoneTeleportNotLearned = "Заклинание телепортации '|cFFFFFFFF%s|r' ещё |cFFFF4411не получено|r."
L.keystoneTeleportOnCooldown = "Заклинание телепортации '|cFFFFFFFF%s|r' находится |cFFFF4411на перезарядке|r ещё %d |4час:часы:часов; и %d |4минуту:минуты:минут;."
L.keystoneTeleportReady = "Заклинание телепортации '|cFFFFFFFF%s|r' |cFF33FF99доступно|r, нажмите для телепортации."
L.keystoneTeleportInCombat = "Вы не можете использовать телепорт пока находитесь в бою."
L.keystoneTabHistory = "История"
L.keystoneHeaderThisWeek = "Текущая неделя"
L.keystoneHeaderOlder = "Более старые"
L.keystoneScoreGainedTooltip = "Изменение рейтинга: |cFFFFFFFF+%d|r\nСчёт полученный за прохождение подземелья: |cFFFFFFFF%d|r"
--L.keystoneCompletedTooltip = "Пройдено во время: |cFFFFFFFF%d мин %d сек|r\nTime Limit: |cFFFFFFFF%d мин %d сек|r"
--L.keystoneFailedTooltip = "Не пройдено во время: |cFFFFFFFF%d мин %d сек|r\nTime Limit: |cFFFFFFFF%d мин %d сек|r"
L.keystoneExplainer = "Инструменты, которые помогут эпохальными+ подземельями."
L.keystoneAutoSlot = "Автоматически вставлять ключ"
L.keystoneAutoSlotDesc = "Автоматически вставляет эпохальный+ ключ в чашу силы при открытии её интерфейса."
L.keystoneAutoSlotMessage = "%s автоматически вставлен в слот чаши силы."
--L.keystoneAutoSlotFrame = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:14:14|t Keystone Auto Inserted"
L.keystoneModuleName = "Эпохальные+ подземелья"
L.keystoneStartBar = "%s +%d" -- Format is SHORT_DUNGEON_NAME +KEYSTONE_LEVEL e.g. "ROOK +12"
L.keystoneStartMessage = "%s +%d начался!" -- Format is LONG_DUNGEON_NAME +KEYSTONE_LEVEL e.g. "The Rookery +12 begins now!"
L.keystoneCountdownExplainer = "Когда вы начинаете эпохальное+ подземелье начнётся отсчёт. Выберите голос который будет озвучить этот отсчёт.\n\n"
L.keystoneCountdownBeginsDesc = "Выберите время за которое начать отсчёт после запуска эпохального+ подземелья."
L.keystoneCountdownBeginsSound = "Проигрывать звук при начале счётчика эпохального+ подземелья "
L.keystoneCountdownEndsSound = "Проигрывать звук при окончании счётчика эпохального+ подземелья"
L.keystoneViewerTitle = "Обозреватель эпохальных+ подземелий"
L.keystoneHideGuildTitle = "Скрывать мой ключ от согильдейцев"
L.keystoneHideGuildDesc = "|cffff4411Не рекомендуем.|r Данный функционал скроект ключи от согильдейцев, но согильдейцы в группе всё равно будут видеть ваш ключ."
L.keystoneHideGuildWarning = "Отключение возможности просмотра вашего ключа для ваших согильдейцев |cffff4411не рекомендуется|r.\n\nВы уверенны, что хотите сделать это?"
L.keystoneAutoShowEndOfRun = "Показать когда эпохальный+ подземелье завершено"
L.keystoneAutoShowEndOfRunDesc = "Автоматически отображать обозреватель эпохальных+ подземелий BigWigs, когда подземелье завершено.\n\n|cFF33FF99Этот функционал поможет найти ключ, который получили игроки в группе с вами.|r"
L.keystoneViewerExplainer = "Вы можете открыть обозреватель эпохальных+ подземелий используя команду |cFF33FF99/key|r или нажатием кнопки ниже.\n\n"
L.keystoneViewerOpen = "Открыть обозреватель эпохальных+ подземелий BigWigs"
L.keystoneViewerKeybindingExplainer = "\n\nВы можете назначить горячую кнопку для открытия окна с эпохальными+ подземельями:\n\n"
L.keystoneViewerKeybindingDesc = "Выберите кнопку для открытия окна эпохальных+ подземелий в BigWigs."
L.keystoneClickToWhisper = "Нажмите для отправки сообщения игроку"
L.keystoneClickToTeleportNow = "\nНажмите для телепортации сюда"
L.keystoneClickToTeleportCooldown = "\nНе возможно, заклинание ещё не доступно"
L.keystoneClickToTeleportNotLearned = "\nНе возможно, заклинание не изученно"
L.keystoneHistoryRuns = "%d всего"
L.keystoneHistoryRunsThisWeekTooltip = "Общее количество завершённых подземелий пройденных до этой недели: |cFFFFFFFF%d|r"
L.keystoneHistoryRunsOlderTooltip = "Общее количество завершённых подземелий пройденных до этой недели: |cFFFFFFFF%d|r"
L.keystoneHistoryScore = "+%d рейтинга"
L.keystoneHistoryScoreThisWeekTooltip = "Общее количество рейтинга полученное за эту неделю: |cFFFFFFFF+%d|r"
L.keystoneHistoryScoreOlderTooltip = "Общее количество рейтинга полученное до этой недели: |cFFFFFFFF+%d|r"
L.keystoneTimeUnder = "|cFF33FF99-%02d:%02d|r"
L.keystoneTimeOver = "|cFFFF4411+%02d:%02d|r"
--L.keystoneTeleportTip = "Click the dungeon name below to |cFF33FF99TELEPORT|r directly to the dungeon entrance."

-- It doesn't really matter what you call it as long as it's recognizable and limited to ~6 characters
L.keystoneShortName_TheRookery = "ROOK"
L.keystoneShortName_DarkflameCleft = "DFC"
L.keystoneShortName_PrioryOfTheSacredFlame = "PRIORY"
L.keystoneShortName_CinderbrewMeadery = "BREW"
L.keystoneShortName_OperationFloodgate = "FLOOD"
L.keystoneShortName_TheaterOfPain = "TOP"
L.keystoneShortName_TheMotherlode = "ML"
L.keystoneShortName_OperationMechagonWorkshop = "WORK"
L.keystoneShortName_EcoDomeAldani = "ECODOME"
L.keystoneShortName_HallsOfAtonement = "HOA"
L.keystoneShortName_AraKaraCityOfEchoes = "ARAK"
L.keystoneShortName_TazaveshSoleahsGambit = "GAMBIT"
L.keystoneShortName_TazaveshStreetsOfWonder = "STREET"
L.keystoneShortName_TheDawnbreaker = "DAWN"

-- These short names are for the bar that shows during the Mythic+ countdown
-- Use the real dungeon names but make them shorter to fit on the bar better
L.keystoneShortName_TheRookery_Bar = "Гнездовье"
L.keystoneShortName_DarkflameCleft_Bar = "Расселина"
L.keystoneShortName_PrioryOfTheSacredFlame_Bar = "Приорат"
L.keystoneShortName_CinderbrewMeadery_Bar = "Искроварня"
L.keystoneShortName_OperationFloodgate_Bar = "Шлюз"
L.keystoneShortName_TheaterOfPain_Bar = "Теарт боли"
L.keystoneShortName_TheMotherlode_Bar = "Жила"
L.keystoneShortName_OperationMechagonWorkshop_Bar = "Мастерская"
L.keystoneShortName_EcoDomeAldani_Bar = "Заповедник"
L.keystoneShortName_HallsOfAtonement_Bar = "Чертоги"
L.keystoneShortName_AraKaraCityOfEchoes_Bar = "Ара-Кара"
L.keystoneShortName_TazaveshSoleahsGambit_Bar = "Гамбит"
L.keystoneShortName_TazaveshStreetsOfWonder_Bar = "Улицы"
L.keystoneShortName_TheDawnbreaker_Bar = "Рассвет"

-- Instance Keys "Who has a key?"
L.instanceKeysTitle = "У кого есть ключ?"
L.instanceKeysDesc = "При входе в эпохальное подземелье отобразить список игроков, у которых есть подходящий ключ.\n\n"
L.instanceKeysTest8 = "|cFF00FF98Монах:|r +8"
L.instanceKeysTest10 = "|cFFFF7C0AДруид:|r +10"
L.instanceKeysDisplay = "|c%s%s:|r +%d" -- "PLAYER_NAME: +DUNGEON_LEVEL"
L.instanceKeysDisplayWithDungeon = "|c%s%s:|r +%d (%s)" -- "PLAYER_NAME: +DUNGEON_LEVEL (DUNGEON_NAME)"
L.instanceKeysShowAll = "Всегда показывать всех игроков"
L.instanceKeysShowAllDesc = "При включении данной опции будут отображаться ключи всех игроков, даже те, которые не относятся к тому подземелью, в котором вы находитесь."
L.instanceKeysOtherDungeonColor = "Цвет ключей от других подземелий"
L.instanceKeysOtherDungeonColorDesc = "Выберите цвет текста для игроков, ключи которых не подходят к текущему подземелью."
L.instanceKeysEndOfRunDesc = "По умолчанию список отображается при входе в подземелье. При включении данной опции список будет отображаться и при завершении эпохального+ подземелья."
--L.instanceKeysHideTitle = "Hide title"
--L.instanceKeysHideTitleDesc = "Hide the \"Who has a key?\" title."

-----------------------------------------------------------------------
-- LFGTimer.lua
--

L.lfgTimerTitle = "LFG Таймер"
L.lfgTimerExplainer = "Когда приглашение в подземелье появляется BigWigs создаст таймер отображающий сколько времени осталось для принятия прилашения.\n\n"
L.lfgUseMaster = "Проигрывать звук прилашения на 'Основном' аудио канале"
L.lfgUseMasterDesc = "Когда данная опция включена, звук будет проигрываться на основном аудио канале. Если вы отключите эту опцию звук будет проигрываться в канале '%s'."

-----------------------------------------------------------------------
-- PLUGINS
-----------------------------------------------------------------------

L.general = "Общие"
L.advanced = "Расширенные"
L.comma = ", "
L.reset = "Сброс"
L.resetDesc = "Сбросить настройки выше к их стандартным значениям."
L.resetAll = "Сбросить все"
--L.startTest = "Start Test"
--L.stopTest = "Stop Test"
--L.always = "Always"
--L.never = "Never"

L.positionX = "Позиция X"
L.positionY = "Позиция Y"
L.positionExact = "Точная позиция"
L.positionDesc = "Введите в поле или передвиньте якорь если вам нужно точное позиционирование."
L.width = "Ширина"
L.height = "Высота"
L.size = "Размер"
L.sizeDesc = "Обычно размеры меняются перемещением якоря. Если Вам необходим точный размер, можете использовать слайдер или ввести значение в поле."
L.fontSizeDesc = "Отрегулируйте размер шрифта с помощью ползунка или введите значение вручную в поле, если оно выше 200."
L.disabled = "Отключить"
L.disableDesc = "Вы собираетесь отключить функцию '%s', делать это |cffff4411не рекомендуется|r.\n\nВы уверены, что хотите этого?"
L.keybinding = "Назначение клавиш"
L.dragToResize = "Тяните для изменения размера"
--L.cannotMoveInCombat = "You cannot move this whilst you're in combat."

-- Anchor Points
L.UP = "Верх"
L.DOWN = "Низ"
L.TOP = "Сверху"
L.RIGHT = "Справа"
L.BOTTOM = "Снизу"
L.LEFT = "Слева"
L.TOPRIGHT = "Сверху справа"
L.TOPLEFT = "Сверху слева"
L.BOTTOMRIGHT = "Снизу справа"
L.BOTTOMLEFT = "Снизу слева"
L.CENTER = "По центру"
L.customAnchorPoint = "Дополнительно: Пользовательские якоря"
L.sourcePoint = "Начальная точка"
L.destinationPoint = "Конечная точка"
--L.drawStrata = "Strata"
--L.medium = "Medium"
--L.low = "Low"

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "Энергия"
L.altPowerDesc = "Монитор Энергии будет отображаться только для боссов, которые используют 'Дополнительную Энергию' к игрокам, что бывает крайне редко. Монитор измеряет количество 'Дополнительной Энергии', имеющейся у вас и вашей группы, и отображает его в виде списка. Чтобы перемещать монитор, используйте кнопку тестирования ниже."
L.toggleDisplayPrint = "Монитор будет показан в следующий раз. Чтобы отключить его полностью, уберите галочку в настройках битв."
L.disabledDisplayDesc = "Отключить монитор для всех модулей."
L.resetAltPowerDesc = "Сбросить все параметры, связанные с Энергией, включая позицию якоря."
L.test = "Тест"
L.altPowerTestDesc = "Показать монитор 'Дополнительной Энергии', позволяя перемещать его, и симулировать изменение энергии как на сражении с боссом."
L.yourPowerBar = "Ваша полоса Энергии"
L.barColor = "Цвет полосы"
L.barTextColor = "Цвет текста полосы"
L.additionalWidth = "Дополнительная ширина"
L.additionalHeight = "Дополнительная высота"
L.additionalSizeDesc = "Увеличьте размер стандартного монитора с помощью ползунка или введите значение вручную в поле, если оно выше 100."
L.yourPowerTest = "Ваша энергия: %d" -- Your Power: 42
L.yourAltPower = "%s: %d" -- e.g. Your Corruption: 42
L.player = "Игрок %d" -- Player 7
L.disableAltPowerDesc = "Отключить глобально монитор Энергии, он не будет показываться ни для какого сражения."

-----------------------------------------------------------------------
-- AutoReply.lua
--

L.autoReply = "Автоответчик"
L.autoReplyDesc = "Автоматически отвечать на приватные сообщения в бою с боссом."
L.responseType = "Тип ответа"
L.autoReplyFinalReply = "Также отвечать при выходе из боя"
L.guildAndFriends = "Гильдия и Друзья"
L.everyoneElse = "Все остальные"

L.autoReplyBasic = "Сейчас я в бою с боссом."
L.autoReplyNormal = "Сейчас я в бою с '%s'."
L.autoReplyAdvanced = "Сейчас я в бою с '%s' (%s), %d/%d игроков живо."
L.autoReplyExtreme = "Сейчас я в бою с '%s' (%s), %d/%d игроков живо: %s"

L.autoReplyLeftCombatBasic = "Я больше не в бою с боссом."
L.autoReplyLeftCombatNormalWin = "Я победил '%s'."
L.autoReplyLeftCombatNormalWipe = "Я проиграл '%s'."
L.autoReplyLeftCombatAdvancedWin = "Я победил '%s' с %d/%d живыми игроками."
L.autoReplyLeftCombatAdvancedWipe = "Я проиграл '%s' на: %s"

-----------------------------------------------------------------------
-- Bars.lua
--

L.bars = "Полосы"
L.style = "Стиль"
L.bigWigsBarStyleName_Default = "По умолчанию"
L.resetBarsDesc = "Сбросить все параметры, связанные с полосами, включая позицию якоря."
L.testBarsBtn = "Создать тестовый индикатор оповещений"
L.testBarsBtn_desc = "Создаёт индикатор для теста ваших текущих настроек отображения оповещений BigWigs."

L.toggleAnchorsBtnShow = "Показать фиксаторы"
L.toggleAnchorsBtnHide = "Спрятать фиксаторы"
L.toggleAnchorsBtnHide_desc = "Спрятать все фиксаторы, заблокировав их элементы на месте."
L.toggleBarsAnchorsBtnShow_desc = "Показать все фиксаторы, позволяя двигать полосы."

L.emphasizeAt = "Увеличение на... (секунды)"
L.growingUpwards = "Рост вверх"
L.growingUpwardsDesc = "Переключение направления роста вверх или вниз от якоря."
L.texture = "Текстура"
L.emphasize = L.EMPHASIZE
L.emphasizeMultiplier = "Множитель Размера"
L.emphasizeMultiplierDesc = "Если Вы отмените перемещение увеличенных полос к своему якорю, эта опция будет просто определять, насколько будут увеличиваться полосы по отношению к нормальным."

L.enable = "Включить"
L.move = "Перемещение"
L.moveDesc = "Перемещение увеличенных полос. Если эта опция отключена, увеличенные полосы просто будут изменять масштаб и окраску."
L.emphasizedBars = "Увеличенные полосы"
L.align = "Выравнивание"
L.alignText = "Выравнивание текста"
L.alignTime = "Выравнивание времени"
L.time = "Время"
L.timeDesc = "Показывать или скрывать остаток времени на полосах."
L.textDesc = "Показать или скрыть текст на полосах."
L.icon = "Иконка"
L.iconDesc = "Показывать или скрывать иконку полосы."
L.iconPosition = "Позиция Иконки"
L.iconPositionDesc = "Выберите, где на полосе будет находиться иконка."
L.font = "Шрифт"
L.restart = "Перезапуск"
L.restartDesc = "Перезапуск увеличенных полос так, что они стартуют с самого начала, отсчитывая от 10."
L.fill = "Заполнение"
L.fillDesc = "Заполнение полос, вместо убывания."
L.spacing = "Промежуток"
L.spacingDesc = "Изменить промежуток между полосами."
L.visibleBarLimit = "Лимит отображаемых полос"
L.visibleBarLimitDesc = "Установить максимальное количество полос, отображаемых единовременно."

L.localTimer = "Локальный"
L.timerFinished = "%s: Таймер [%s] завершен."
L.customBarStarted = "Таймер '%s' начат %s игроком %s."
L.sendCustomBar = "Отправка таймера '%s' пользователям BigWigs и DBM."

L.requiresLeadOrAssist = "Эта функция требует быть лидером рейда или помощником."
L.encounterRestricted = "Это функция не может быть использована во время битвы."
L.wrongCustomBarFormat = "Неверный формат. Правильно будет: /raidbar 20 текст"
L.wrongTime = "Неверно указанное время. <время> может быть числом в секундах, М:С парой, или Mm. Например, 5, 1:20 или 2m."

L.wrongBreakFormat = "Должно быть между 1 и 60 минутами. Например: /break 5"
L.sendBreak = "Отправка таймера перерыва пользователям BigWigs и DBM."
L.breakStarted = "Перерыв начат %s игроком %s."
L.breakStopped = "%s отменил перерыв."
L.breakBar = "Перерыв"
L.breakMinutes = "Перерыв закончится через %d |4минуту:минуты:минут;!"
L.breakSeconds = "Перерыв закончится через %d секунд!"
L.breakFinished = "Перерыв закончен!"

-----------------------------------------------------------------------
-- BossBlock.lua
--

L.bossBlock = "Фильтр событий"
L.bossBlockDesc = "Настройте вещи, которые вы хотите скрыть в течении боя с боссом.\n\n"
L.bossBlockAudioDesc = "Выбрать, какие звуки отключить во время боя с боссом.\n\n|cff808080Серым|r помечены те звуки, которые отключены в настройках WoW.\n\n"
L.movieBlocked = "Вы видели этот ролик, пропускаем его."
L.blockEmotes = "Скрыть эмоции посередине экрана"
L.blockEmotesDesc = "Некоторые боссы показывают текст для определенных способностей. Эти сообщения и слишком длинные и избыточные. Мы стараемся предоставлять более подходящие сообщения, которые не вмешиваются в ваш геймплей и не говорят вам что конкретно вы должны делать.\n\nОбратите внимание: Эмоции босса всегда будут доступны в чате, если вы захотите их прочитать."
L.blockMovies = "Скрыть повторяющиеся ролики"
L.blockMoviesDesc = "Ролики боссов будут проиграны лишь один раз (то есть вы сможете посмотреть каждый) и последующие воспроизведения будут заблокированы."
L.blockFollowerMission = "Скрыть уведомления заданий соратников"
L.blockFollowerMissionDesc = "Всплывающие сообщения соратников показывают в основном уведомление о выполнении задания.\n\nЭти уведомления могут скрыть важные части вашего интерфейса в течении боя с боссом, поэтому мы рекомендуем скрыть их."
L.blockGuildChallenge = "Скрыть уведомления о гильдейских испытаниях"
L.blockGuildChallengeDesc = "Гильдейские испытания в основном показывают информацию, когда группа людей в вашей гильдии завершает прохождение подземелья в героическом режиме или в режиме испытаний.\n\nЭти уведомления могут скрыть важные части вашего интерфейса в течении боя с боссом, поэтому мы рекомендуем скрыть их."
L.blockSpellErrors = "Скрыть сообщения о неудавшихся заклинаниях"
L.blockSpellErrorsDesc = "Сообщения, такие как \"Заклинание не готово\", которые отображаются наверху экрана, будут скрыты."
L.blockZoneChanges = "Скрывать уведомления о смене текущей зоны"
L.blockZoneChangesDesc = "Скрывает сообщение сверху по центру, когда вы меняете локацию, например '|cFF33FF99Штормград|r' или '|cFF33FF99Оргримар|r'."
L.audio = "Звук"
L.music = "Музыка"
L.ambience = "Фоновые звуки"
L.sfx = "Звуковые эффекты"
L.errorSpeech = "Сообщения об ошибках"
L.disableMusic = "Выключить музыку (рекомендуется)"
L.disableAmbience = "Выключить фоновые звуки (рекомендуется)"
L.disableSfx = "Выключить звуковые эффекты (не рекомендуется)"
L.disableErrorSpeech = "Заглушить звук сообщений об ошибках (рекомендуется)"
L.disableAudioDesc = "Во время боя с боссом '%s' будут выключены для того чтобы помочь вам сконцентрироваться на звуках предупреждений BigWigs. После выхода из боя звуки будут включены обратно."
L.blockTooltipQuests = "Заблокировать цели квестов в подсказке"
L.blockTooltipQuestsDesc = "Когда вам требуется убить босса для квеста, подсказка показывает обычно \"0/1 выполнено\", при наведении мышкой на босса. Эта опция скрывает список целей других игроков, чтобы подсказка не разрослась слишком высоко."
L.blockObjectiveTracker = "Скрыть панель отслеживания квестов"
L.blockObjectiveTrackerDesc = "Панель отслеживания квестов будет скрыта во время боя с боссом чтобы освободить место на экране.\n\nЭтого НЕ случится если вы находитесь в эпохальном+ подземелье или отслеживаете достижение."

L.blockTalkingHead = "Скрыть окно диалога 'Говорящая голова'"
L.blockTalkingHeadDesc = "'Говорящая голова' это всплывающее окно с диалогом NPC, в котором есть голова и текст, расположенное в нижней центральной части экрана и которое |cffff4411иногда|r отображается во время разговора NPC.\n\nВы можете выбрать тип подземелья, в котором оно будет заблокировано.\n\n|cFF33FF99Обратите внимание:|r\n 1) Эта функция позволит голосу NPC воспроизводиться, чтобы вы могли его слышать.\n 2) В целях безопасности будут заблокированы только определенные говорящие головы. Ничего особенного или уникального, например одноразового квеста, не будет заблокировано."
L.blockTalkingHeadDungeons = "Обычные и Героические подземелья"
L.blockTalkingHeadMythics = "Эпохальные подземелья и ключи"
L.blockTalkingHeadRaids = "Рейды"
L.blockTalkingHeadTimewalking = "Путешествия во времени (подземелья и рейды)"
L.blockTalkingHeadScenarios = "Сценарии"

L.redirectPopups = "Перенапрявлять выскакивающие уведомления в BigWigs"
L.redirectPopupsDesc = "Выскакивающие уведомления посреди экрана по типу '|cFF33FF99ячейки великого хранилища доступны|r' будут теперь показываться в виде сообщений BigWigs. Эти уведомления бывают слишком большими, длиться слишком долго и могут блокировать возможность клика сквозь них."
L.redirectPopupsColor = "Цвет перенаправленного уведомления"
L.blockDungeonPopups = "Скрывать уведомления о входе в подземелья"
L.blockDungeonPopupsDesc = "Уведомления о входе в подземелья иногда бывают очень длинными. Включив эту настройку, они будут полностью скрыты."
L.itemLevel = "Уровень предмета: %d"
L.newRespawnPoint = "Новая точка воскрешения"

L.userNotifySfx = "Звуковые эффекты были отключён BossBlock-ом, включаю обратно..."
L.userNotifyMusic = "Музыка была отключена BossBlock-ом, включаю обратно..."
L.userNotifyAmbience = "Звуки мира были отключены BossBlock-ом, включаю обратно..."
L.userNotifyErrorSpeech = "Звук ошибок был отключён BossBlock-ом, включаю обратно..."

L.subzone_grand_bazaar = "Большой базар" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "Порт Зандалара" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_eastern_transept = "Восточный трансепт" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

L.colors = "Цвета"

L.text = "Текст"
L.textShadow = "Тень текста"
L.expiring_normal = "Обычные"
L.emphasized = "Увеличенные"

L.resetColorsDesc = "Сброс цветов на стандартные значения."
L.resetAllColorsDesc = "Если вы настроили цвета для каких-либо событий боя с боссом, эта кнопка сбросит ВСЕ такие настройки."

L.red = "Красный"
L.redDesc = "Общие оповещения боя."
L.blue = "Синий"
L.blueDesc = "Оповещение событий, касающихся непосредственно Вас, например, наложение дебаффа."
L.orange = "Оранжевый"
L.yellow = "Желтый"
L.green = "Зеленый"
L.greenDesc = "Оповещение хороших событий, например, снятие дебаффа с Вас."
L.cyan = "Циановый"
L.cyanDesc = "Оповещение о изменении статуса боя, например, переход на следующую фазу."
L.purple = "Фиолетовый"
L.purpleDesc = "Оповещение о способностях только для танков, например, стаки дебаффа на танке."

-----------------------------------------------------------------------
-- Countdown.lua
--

L.textCountdown = "Текст отсчета"
L.textCountdownDesc = "Показывать цифры во время отсчета"
L.countdownColor = "Цвет отсчета"
L.countdownVoice = "Голос отсчета"
L.countdownTest = "Тестировать отсчет"
L.countdownAt = "Отсчет с... (секунд)"
L.countdownAt_desc = "Выберите, сколько времени должно оставаться до способности босса (в секундах), когда начнется обратный отсчет."
L.countdown = "Отсчет"
L.countdownDesc = "Функция обратного отсчета включает голосовой и текстовый обратный отсчет. По умолчанию он обычно выключен, но вы можете включить его для любой способности босса при просмотре настроек боя с конкретным боссом."
L.countdownAudioHeader = "Голосовой звук отсчета"
L.countdownTextHeader = "Отображаемый текст отсчета"
L.resetCountdownDesc = "Сбрасывает все указанные выше настройки обратного отсчета на значения по умолчанию."
L.resetAllCountdownDesc = "Если вы выбрали свои голоса обратного отсчета для какого-либо боя с боссом, эта кнопка сбросит ВСЕ их, а также сбросит все указанные выше настройки обратного отсчета на значения по умолчанию."

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infobox_short = "ИнфоБлок"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Пути вывода сообщений. Отображение поддерживает иконки, цвета и позволяет вывести до 4х сообщений на экран. Новые сообщения будут расти в размерах, и вновь сокращаться, чтобы уведомить игрока."
L.emphasizedSinkDescription = "Пути вывода увеличенных сообщений. Отображение поддерживает текст и цвета, и позволяет вывести одно сообщение за один раз."
L.resetMessagesDesc = "Сбросить все параметры, связанные с сообщениями, включая позиции якорей сообщений."
L.toggleMessagesAnchorsBtnShow_desc = "Показать все фиксаторы, позволяя двигать позиции сообщений."

L.testMessagesBtn = "Создать текстовое сообщение"
L.testMessagesBtn_desc = "Создаёт текстовое сообщение для тестирования текущих настроек."

L.bwEmphasized = "BigWigs Увеличение"
L.messages = "Сообщения"
L.emphasizedMessages = "Увеличенные сообщения"
L.emphasizedDesc = "Смысл увеличенного сообщения - привлечь ваше внимание огромным сообщением в центре экрана. Оно редко включено по умолчанию, но вы можете включить его для любой способности в настройках боя с конкретным боссом."
L.uppercase = "БОЛЬШИМИ БУКВАМИ"
L.uppercaseDesc = "Все увеличенные сообщения будут отображаться ЗАГЛАВНЫМИ буквами."

L.useIcons = "Использовать иконки"
L.useIconsDesc = "Показывать иконку возле сообщения."
L.classColors = "Окраска по классу"
L.classColorsDesc = "Сообщения иногда содержат имена игроков. При включении опции эти имена будут окрашены в цвета классов."
L.chatFrameMessages = "Сообщения в чат"
L.chatFrameMessagesDesc = "Выводить все сообщения BigWigs в стандартное окно чата в дополнение к настройкам отображения."

L.fontSize = "Размер шрифта"
L.none = "Нет"
L.thin = "Тонкий"
L.thick = "Толстый"
L.outline = "Контур"
L.monochrome = "Монохромный"
L.monochromeDesc = "Включение монохромного флага, убирается любое сглаживание краев шрифта."
L.fontColor = "Цвет шрифта"

L.displayTime = "Время отображения"
L.displayTimeDesc = "Сколько секунд будет показываться сообщение"
L.fadeTime = "Время затухания"
L.fadeTimeDesc = "Сколько секунд будет затухать сообщение"

--L.messagesOptInHeaderOff = "Boss mod messages 'opt-in' mode: Enabling this option will turn off messages across ALL of your boss modules.\n\nYou will need to go through each one and manually turn on the messages you want.\n\n"
--L.messagesOptInHeaderOn = "Boss mod messages 'opt-in' mode is |cFF33FF99ACTIVE|r. To see boss mod messages, go into the settings of a specific boss ability and turn on the '|cFF33FF99Messages|r' option.\n\n"
--L.messagesOptInTitle = "Boss mod messages 'opt-in' mode"
--L.messagesOptInWarning = "|cffff4411WARNING!|r\n\nEnabling 'opt-in' mode will turn off messages across ALL of your boss modules. You will need to go through each one and manually turn on the messages you want.\n\nYour UI will now reload, are you sure?"

-----------------------------------------------------------------------
-- Nameplates.lua
--

L.nameplates = "Полосы здоровья"
L.testNameplateIconBtn = "Показать тестовую иконку"
L.testNameplateIconBtn_desc = "Создаёт тестовую иконку с текущими настройками для проверки на полосе здоровья цели."
L.testNameplateTextBtn = "Показать тестовый текст"
L.testNameplateTextBtn_desc = "Создаёт тест текста для текущих настроек на полосе здоровья цели."
L.stopTestNameplateBtn = "Остановить тесты"
L.stopTestNameplateBtn_desc = "Останавливает тесты иконки и текста на полосах здоровья."
L.noNameplateTestTarget = "Необходимо взять в цель враждебную цель, которую можно атаковать, ради работы теста."
L.anchoring = "Якоря"
L.growStartPosition = "Позиция начала роста"
L.growStartPositionDesc = "Стартовая позиция для первой иконки."
L.growDirection = "Направление роста"
L.growDirectionDesc = "Направление, в котором иконку будут расти со стартовой позиции."
L.iconSpacingDesc = "Изменить свободное пространство между иконками."
L.nameplateIconSettings = "Настройки иконик"
L.keepAspectRatio = "Сохранять соотношение сторон"
L.keepAspectRatioDesc = "Сохранять соотношение сторон иконки 1:1 вместо растягивания по панели."
L.iconColor = "Цвет иконки"
L.iconColorDesc = "Меняет цвет текстуры иконки."
L.desaturate = "Обесцветить"
L.desaturateDesc = "Обесцвечивает текстурку иконки."
L.zoom = "Приближение"
L.zoomDesc = "Приблизить текстурку иконки."
L.showBorder = "Показать границу"
L.showBorderDesc = "Показывает границу вокруг иконки."
L.borderColor = "Цвет границы"
L.borderSize = "Размер границы"
--L.borderOffset = "Border Offset"
--L.borderName = "Border Name"
L.showNumbers = "Показывать цифры"
L.showNumbersDesc = "Показывает цифры на иконке."
L.cooldown = "Кулдаун"
--L.cooldownEmphasizeHeader = "By default, Emphasize is disabled (0 seconds). Setting it to 1 second or higher will enable Emphasize. This will allow you to set a different font color and font size for those numbers."
L.showCooldownSwipe = "Показывать анимацию"
L.showCooldownSwipeDesc = "Показывать свайп анимацию активной иконки."
L.showCooldownEdge = "Показывать кромку"
L.showCooldownEdgeDesc = "Показывать кромку на активном кулдауне."
L.inverse = "Инверсия"
L.inverseSwipeDesc = "Инвертировать анимацию кулдауна."
L.glow = "Свечение"
L.enableExpireGlow = "Активировать свечение окончания"
L.enableExpireGlowDesc = "Показывать свечение вокруг иконки при завершении кулдауна."
L.glowColor = "Цвет Cвечения"
L.glowType = "Тип Cвечения"
L.glowTypeDesc = "Меняет тип свечения вокруг иконки."
L.resetNameplateIconsDesc = "Сбросить все настройки, связанные с иконками панели здоровья."
L.nameplateTextSettings = "Настройки текста"
L.fixate_test = "Тест фиксации" -- Text that displays to test on the frame
L.resetNameplateTextDesc = "Сбросить все настройки, связанные с текстом панели здоровья."
L.glowAt = "Начало свечения (секунды)"
L.glowAt_desc = "Выбрать, на скольки секундах оставшегося кулдауна начинается свечение."
--L.offsetX = "Offset X"
--L.offsetY = "Offset Y"
L.headerIconSizeTarget = "Размер иконки текущей цели"
L.headerIconSizeOthers = "Размер иконки всех других целей"
L.headerIconPositionTarget = "Позиция иконки текущей цели"
L.headerIconPositionOthers = "Позиция иконки всех других целей"

-- Glow types as part of LibCustomGlow
L.pixelGlow = "Пиксельное свечение"
L.autocastGlow = "Свечение автоприменения"
L.buttonGlow = "Свечение кнопки"
L.procGlow = "Проковое свечение"
L.speed = "Скорость"
L.animation_speed_desc = "Скорость анимации свечения."
L.lines = "Линии"
L.lines_glow_desc = "Количество линий в анимации свечения."
L.intensity = "Интенсивность"
L.intensity_glow_desc = "Интенсивность эффекта свечения, выше значения - больше искр."
L.length = "Длина"
L.length_glow_desc = "Длина линий в анимации свечения."
L.thickness = "Толщина"
L.thickness_glow_desc = "Толщина полосок в анимации свечения."
L.scale = "Масштаб"
L.scale_glow_desc = "Масштаб искр в анимации."
L.startAnimation = "Начать анимацию"
L.startAnimation_glow_desc = "Это свечение имеет анимацию начала, эта настройка активирует/деактивирует эту анимацию."

--L.nameplateOptInHeaderOff = "\n\n\n\nBoss mod nameplates 'opt-in' mode: Enabling this option will turn off nameplates across ALL of your boss modules.\n\nYou will need to go through each one and manually turn on the nameplates you want.\n\n"
--L.nameplateOptInHeaderOn = "\n\n\n\nBoss mod nameplates 'opt-in' mode is |cFF33FF99ACTIVE|r. To see boss mod nameplates, go into the settings of a specific boss ability and turn on the '|cFF33FF99Nameplates|r' option.\n\n"
--L.nameplateOptInTitle = "Boss mod nameplates 'opt-in' mode"
--L.nameplateOptInWarning = "|cffff4411WARNING!|r\n\nEnabling 'opt-in' mode will turn off nameplates across ALL of your boss modules. You will need to go through each one and manually turn on the nameplates you want.\n\nYour UI will now reload, are you sure?"

-----------------------------------------------------------------------
-- Proximity.lua
--

L.customRange = "Пользовательский радар"
L.proximityTitle = "%d м / %d |4игрок:игрока:игроков;"
L.proximity_name = "Радар близости"
L.soundDelay = "Задержка звука"
L.soundDelayDesc = "Определяет как долго BigWigs должен подождать между повторением заданного звука, когда кто-то слишком близко к вам."

L.resetProximityDesc = "Сбросить все параметры, связанные с радаром близости, включая позицию якоря."

L.close = "Закрыть"
L.closeProximityDesc = "Закрывает окно радара близости.\n\nЧтобы полностью его отключить для любого боя, вам нужно зайти в опции соответствующего босса и там отключить опцию 'Близость'."
L.lock = "Фиксировать"
L.lockDesc = "Фиксирование рамки, предотвращает перемещение и изменение размера."
L.title = "Название"
L.titleDesc = "Показать или скрыть название."
L.background = "Фон"
L.backgroundDesc = "Показать или скрыть фон."
L.toggleSound = "Переключение звука"
L.toggleSoundDesc = "Включить/выключить звуковое оповещение окна близости, когда вы находитесь слишком близко к другому игроку."
L.soundButton = "Кнопка звука"
L.soundButtonDesc = "Показать или скрыть кнопку звука."
L.closeButton = "Кнопка закрытия"
L.closeButtonDesc = "Показать или скрыть кнопку закрытия."
L.showHide = "Показ/скрыть"
L.abilityName = "Название способности"
L.abilityNameDesc = "Показывает или скрывает название способности в верхней части окна."
L.tooltip = "Подсказка"
L.tooltipDesc = "Показывает или скрывает подсказку заклинания в окне близости, если эта способность связана боссом."

-----------------------------------------------------------------------
-- Pull.lua
--

L.countdownType = "Тип обратного отсчета"
L.combatLog = "Автоматическая запись лога боя"
L.combatLogDesc = "Лог боя будет автоматически запускаться когда таймер атаки будет запущен и останавливаться по окончании боя с боссом."

L.pull = "Атака"
L.engageSoundTitle = "Воспроизвести звук, когда начинается бой с боссом"
L.pullStartedSoundTitle = "Воспроизвести звук, когда запускается таймер атаки"
--L.pullStartedMessageTitle = "Show a message when the pull timer is started"
L.pullFinishedSoundTitle = "Воспроизвести звук, когда завершается таймер атаки"
L.pullStartedBy = "Пулл таймер начат: %s."
L.pullStopped = "%s отменил таймер атаки."
L.pullStoppedCombat = "Таймер атаки  отменен, поскольку Вы вступили в бой."
L.pullIn = "Атакуем через %d сек"
L.sendPull = "Отправляю пулл таймер группе."
L.wrongPullFormat = "Неправильная команда. Пример правильного формата: /pull 5"
L.countdownBegins = "Начать отсчет"
L.countdownBegins_desc = "Выберите, сколько времени должно оставаться до пулла (в секундах), когда начнется обратный отсчет."
L.pullExplainer = "\n|cFF33FF99/pull|r начнёт обычный таймер отсчёта атаки.\n|cFF33FF99/pull 7|r начнёт таймер отсчёта на 7 секунд, вы можете выбрать любое число для отсчёта.\nТак-же вы можете назначить клавишу для запуска таймера отсчёта атаки.\n\n"
L.pullKeybindingDesc = "Выберите кнопку для начала таймера отсчёта."

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L.icons = "Метки"
L.raidIconsDescription = "Некоторые битвы могут включать способности типа 'бомба', накладываемые на определенных игроков или способности преследования. Здесь вы можете настроить рейдовые метки, используемые для обозначения таких игроков.\n\nЕсли в битве имеется только одна такая способность, будет использована первая метка. Одна метка никогда не будет использована для разных способностей, в следующий раз будет использована та же иконка.\n\n|cffff4411Помните, если игрок был отмечен вручную, BigWigs не будет менять его метку.|r"
L.primary = "Основная"
L.primaryDesc = "Первая метка рейда, которая будет использоваться скриптом события."
L.secondary = "Второстепенная"
L.secondaryDesc = "Вторая метка рейда, которая будет использоваться скриптом события."

-----------------------------------------------------------------------
-- Sound.lua
--

L.Sounds = "Звуки"
L.soundsDesc = "BigWigs использует звуковой канал 'Общая громкость' для воспроизведения всех своих звуков.Для настройки громкости звуков из аддона, откройте настроки WoW и измените значение ползунка 'Общая громкость' до желаемого уровня.\n\nТут вы можете настроить различные звуковые сообщения аддона для конкретных случаев, или отключить их, выбрав значение 'None'. Что бы изменить звук для конкретной способности босса, необходимо настроить это в окне способностей босса.\n\n"
L.oldSounds = "Старые звуки"

L.Alarm = "Тревога"
L.Info = "Информация"
L.Alert = "Оповещение"
L.Long = "Долгий"
L.Warning = "Предупреждение"
L.onyou = "Заклинание, бафф или дебафф на тебе"
L.underyou = "Тебе нужно выйти из заклинания под ногами"
L.privateaura = "Когда на вас 'Приватная Аура'"

L.customSoundDesc = "Воспроизводить пользовательский звук, вместо используемого в модуле."
L.resetSoundDesc = "Сбрасывает указанные выше звуки к значениям по умолчанию."
L.resetAllCustomSound = "Если вы используете свои звуки для какой-либо битвы, это кнопка спросит ВСЕ такие звуки на стандартные."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossStatistics = "Статистика боссов"
L.bossStatsDescription = "Запись различных статистик связанных с боссами, такие как количество побед, поражений; дату первого убийства и информацию о самой быстрой победе. Эта статистика видна для каждого босса в окне настроек, либо спрятана, если нет записей."
L.createTimeBar = "Отображать полосу 'Лучшее время'"
L.bestTimeBar = "Лучшее время"
L.healthPrint = "Здоровье: %s."
L.healthFormat = "%s (%.1f%%)"
L.chatMessages = "Сообщения в чат"
L.newFastestVictoryOption = "Новая самая быстрая победа"
L.victoryOption = "Вы победили"
L.defeatOption = "Вы проиграли"
L.bossHealthOption = "Здоровье босса"
L.bossVictoryPrint = "Вы победили '%s' спустя %s." -- You were victorious against 'BOSS_NAME' after COMBAT_DURATION.
L.bossDefeatPrint = "Вы проиграли '%s' спустя %s." -- You were defeated by 'BOSS_NAME' after COMBAT_DURATION.
L.newFastestVictoryPrint = "Новая самая быстрая победа: (-%s)" -- New fastest victory: (-COMBAT_DURATION)

-----------------------------------------------------------------------
-- Victory.lua
--

L.Victory = "Победа"
L.victoryHeader = "Настройки действий, которые должны быть выполнены после победы над боссом."
L.victorySound = "Проигрывать звук победы над боссом"
L.victoryMessages = "Показывать сообщения о победе над боссом"
L.victoryMessageBigWigs = "Показывать сообщение BigWigs"
L.victoryMessageBigWigsDesc = "Сообщение BigWigs - это простая надпись \"босс был побежден\"."
L.victoryMessageBlizzard = "Показывать сообщение Blizzard"
L.victoryMessageBlizzardDesc = "Сообщение Blizzard - это очень большая анимация \"босс был побежден\" в центре вашего экрана."
L.defeated = "%s терпит поражение"

-----------------------------------------------------------------------
-- Wipe.lua
--

L.wipe = "Вайп"
L.wipeSoundTitle = "Проигрывать звук после вайпа"
L.respawn = "Появление босса"
L.showRespawnBar = "Показывать таймер появления"
L.showRespawnBarDesc = "Показывать таймер, который отсчитывает время до появления босса после вайпа."
