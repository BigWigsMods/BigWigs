local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "ruRU")
if not L then return end

L.comma = ", "
L.width = "Ширина"
L.height = "Высота"
L.sizeDesc = "Обычно размеры меняются перемещением якоря. Если Вам необходим точный размер, можете использовать слайдер или ввести значение в поле, максимума нет."

L.abilityName = "Название способности"
L.abilityNameDesc = "Показывает или скрывает название способности в верхней части окна."
L.Alarm = "Тревога"
L.Alert = "Оповещение"
L.align = "Выравнивание"
L.alignText = "Выравнивание текста"
L.alignTime = "Выравнивание времени"
L.altPowerTitle = "Энергия"
L.background = "Фон"
L.backgroundDesc = "Показать или скрыть фон."
L.bars = "Полосы"
L.nameplateBars = "Полосы неймплейтов"
L.nameplateAutoWidth = "Умещать в ширину неймплейта"
L.nameplateAutoWidthDesc = "Устанавливает ширину полосы неймплейта в соответствии неймплейта, к которому он привязан."
L.nameplateOffsetY = "Смещение по Y"
L.nameplateOffsetYDesc = "Для растущих вверх полос - смещение от верха неймплейта. Для растущих полос вниз - смещение от низа неймплейта."
L.bestTimeBar = "Лучшее время"
L.bigWigsBarStyleName_Default = "По умолчанию"
L.blockEmotes = "Скрыть эмоции посередине экрана"
L.blockEmotesDesc = [=[Некоторые боссы показывают текст для определенных способностей. Эти сообщения и слишком длинные и избыточные. Мы стараемся предоставлять более подходящие сообщения, которые не вмешиваются в ваш геймплей и не говорят вам что конкретно вы должны делать.

Обратите внимание: Эмоции босса всегда будут доступны в чате, если вы захотите их прочитать.]=]
L.blockGuildChallenge = "Скрыть уведомления о гильдейских испытаниях"
L.blockGuildChallengeDesc = [=[Гильдейские испытания в основном показывают информацию, когда группа людей в вашей гильдии завершает прохождение подземелья в героическом режиме или в режиме испытаний.

Эти уведомления могут скрыть важные части вашего интерфейса в течении боя с боссом, поэтому мы рекомендуем скрыть их.]=]
L.blockMovies = "Скрыть повторяющиеся ролики"
L.blockMoviesDesc = "Ролики боссов будут проиграны лишь один раз (то есть вы сможете посмотреть каждый) и последующие воспроизведения будут заблокированы."
L.blockSpellErrors = "Скрыть сообщения о неудавшихся заклинаниях"
L.blockSpellErrorsDesc = "Сообщения, такие как \"Заклинание не готово\", которые отображаются наверху экрана, будут скрыты."
L.bossBlock = "Фильтр событий"
L.bossBlockDesc = "Настройте вещи, которые вы хотите скрыть в течении боя с боссом."
L.bossDefeatDurationPrint = "'%s' терпит поражение спустя %s"
L.bossStatistics = "Статистика боссов"
L.bossStatsDescription = "Запись статистики боссов, включает в себя количество побед, поражений, общее время сражений или самое быстрое убийство. Эта статистика видна для каждого босса в окне настроек, либо спрятана, если нет записей."
L.bossWipeDurationPrint = "'%s' побеждает спустя %s"
L.breakBar = "Перерыв"
L.breakFinished = "Перерыв закончен!"
L.breakMinutes = "Перерыв закончится через %d |4минуту:минуты:минут;!"
L.breakSeconds = "Перерыв закончится через %d секунд!"
L.breakStarted = "Перерыв начат %s игроком %s."
L.breakStopped = "%s отменил перерыв."
L.bwEmphasized = "BigWigs Увеличение"
L.center = "По центру"
L.chatMessages = "Сообщения в чат"
L.classColors = "Окраска по классу"
L.classColorsDesc = "Имена игроков окрасятся в их класс."
L.clickableBars = "Интерактивные полосы"
L.clickableBarsDesc = [=[Полосы BigWigs по умолчанию не реагируют на щелчки мыши в их области. Таким образом, можно выделять объекты или применять АоЕ заклинания за ними, изменять ракурс камеры и т.д., в то время, как курсор находится в области полос. |cffff4411Если вы включите полосы, реагирующие на щелчки мыши, всё это будет невозможно.|r Полосы будут перехватывать любые щелчки мыши в пределах их области.
]=]
L.close = "Закрыть"
L.closeButton = "Кнопка закрытия"
L.closeButtonDesc = "Показать или скрыть кнопку закрытия."
L.closeProximityDesc = [=[Закрывает окно радара близости.

Чтобы полностью его отключить для любого боя, вам нужно зайти в опции соответствующего босса и там отключить опцию 'Близость'.]=]
L.colors = "Цвета"
L.combatLog = "Автоматическая запись лога боя"
L.combatLogDesc = "Лог боя будет автоматически запускаться когда таймер атаки будет запущен и останавливаться по окончании боя с боссом."
L.countDefeats = "Количество побед"
L.countdownAt = "Отсчет с... (секунд)"
L.countdownColor = "Цвет отсчета"
L.countdownTest = "Тестировать отсчет"
L.countdownType = "Тип обратного отсчета"
L.countdownVoice = "Голос отсчета"
L.countWipes = "Количество поражений"
L.createTimeBar = "Отображать полосу 'Лучшее время'"
L.customBarStarted = "Таймер '%s' начат %s игроком %s."
L.customRange = "Пользовательский радар"
L.customSoundDesc = "Воспроизводить пользовательский звук, вместо используемого в модуле."
L.defeated = "%s терпит поражение"
L.disable = "Отключить"
L.disabled = "Отключить"
L.disabledDisplayDesc = "Отключить монитор для всех модулей."
L.disableDesc = "Полностью отключает способность босса, которая вызывает эту полосу."
L.displayTime = "Время отображения"
L.displayTimeDesc = "Сколько секунд будет показываться сообщение"
L.emphasize = "Увеличение"
L.emphasizeAt = "Увеличение на... (секунды)"
L.emphasized = "Увеличенные"
L.emphasizedBars = "Увеличенные полосы"
L.emphasizedCountdownSinkDescription = "Пути вывода увеличенных сообщений с обратным отсчетом. Отображение поддерживает текст и цвета, и позволяет вывести одно сообщение за один раз."
L.emphasizedMessages = "Увеличенные сообщения"
L.emphasizedSinkDescription = "Пути вывода увеличенных сообщений. Отображение поддерживает текст и цвета, и позволяет вывести одно сообщение за один раз."
L.enable = "Включить"
L.enableStats = "Включить Статистику"
L.encounterRestricted = "Это функция не может быть использована во время битвы."
L.fadeTime = "Время затухания"
L.fadeTimeDesc = "Сколько секунд будет затухать сообщение"
L.fill = "Заполнение"
L.fillDesc = "Заполнение полос, вместо убывания."
L.flash = "Мигание"
L.font = "Шрифт"
L.fontColor = "Цвет шрифта"
L.fontSize = "Размер шрифта"
L.general = "Главный модуль"
L.growingUpwards = "Рост вверх"
L.growingUpwardsDesc = "Переключение направления роста вверх или вниз от якоря."
L.icon = "Иконка"
L.iconDesc = "Показывать или скрывать иконку полосы."
L.icons = "Метки"
L.Info = "Информация"
L.interceptMouseDesc = "Включает реагирование полос на щелчки мыши."
L.left = "Влево"
L.localTimer = "Локальный"
L.lock = "Фиксировать"
L.lockDesc = "Фиксирование рамки, предотвращает перемещение и изменение размера."
L.Long = "Долгий"
L.messages = "Сообщения"
L.modifier = "Модификатор"
L.modifierDesc = "Удерживайте выбранную клавишу, чтобы разрешить нажатие по полосе таймера."
L.modifierKey = "Только с клавишей-модификатором"
L.modifierKeyDesc = "Блокирует нажатие на полосы, за исключением удерживания заданной клавиши, после чего действия мышкой, описанные ниже, будут доступны."
L.monochrome = "Монохромный"
L.monochromeDesc = "Включение монохромного флага, убирается любое сглаживание краев шрифта."
L.move = "Перемещение"
L.moveDesc = "Перемещение увеличенных полос. Если эта опция отключена, увеличенные полосы просто будут изменять масштаб и окраску."
L.movieBlocked = "Вы видели этот ролик, пропускаем его."
L.newBestTime = "Рекордное убийство!"
L.none = "Нет"
L.normal = "Обычные"
L.normalMessages = "Обычные сообщения"
L.outline = "Контур"
L.output = "Вывод"
L.positionDesc = "Введите в поле или передвиньте якорь если вам нужно точное позиционирование."
L.positionExact = "Точная позиция"
L.positionX = "Позиция X"
L.positionY = "Позиция Y"
L.primary = "Основная"
L.primaryDesc = "Первая метка рейда, которая будет использоваться скриптом события."
L.printBestTimeOption = "Уведомление о лучшем убийстве"
L.printDefeatOption = "Время победы"
L.printWipeOption = "Время поражения"
L.proximity = "Отображение близости"
L.proximity_desc = "Показывать окно близости при соответствующей схватке, выводя список игроков, которые стоят слишком близко к вам."
L.proximity_name = "Радар близости"
L.proximityTitle = "%d м / %d |4игрок:игрока:игроков;"
L.pull = "Атака"
L.pullIn = "Атакуем через %d сек"
L.engageSoundTitle = "Воспроизвести звук, когда начинается бой с боссом"
L.pullStartedSoundTitle = "Воспроизвести звук, когда запускается таймер атаки"
L.pullFinishedSoundTitle = "Воспроизвести звук, когда завершается таймер атаки"
L.pullStarted = "Таймер атаки начат %s игроком %s."
L.pullStopped = "%s отменил таймер атаки."
L.pullStoppedCombat = "Таймер атаки  отменен, поскольку Вы вступили в бой."
L.raidIconsDesc = [=[Некоторые скрипты событий используют рейдовые метки, чтобы помечать игроков, которые оказывают особое влияние на вашу группу. Например, такой тип эффектов как 'бомба' и контроль разума.

|cffff4411Применимо, если вы Лидер рейда или помощник!|r]=]
L.raidIconsDescription = [=[Некоторые битвы могут включать способности типа 'бомба', накладываемые на определенных игроков или способности преследования. Здесь вы можете настроить рейдовые метки, используемые для обозначения таких игроков.

Если в битве имеется только одна такая способность, будет использована первая метка. Одна метка никогда не будет использована для разных способностей, в следующий раз будет использована та же иконка.

|cffff4411Помните, если игрок был отмечен вручную, BigWigs не будет менять его метку.|r]=]
L.recordBestTime = "Запоминать лучшее убийство"
L.regularBars = "Обычные полосы"
L.remove = "Убрать"
L.removeDesc = "Временно убирает полосу и все связанные с ней сообщения."
L.removeOther = "Убрать другие"
L.removeOtherDesc = "Временно удаляет все другие полосы (кроме этой) и связанные с ними сообщения."
L.report = "Сообщить"
L.reportDesc = "Сообщает текущий статус полосы в активный групповой чат; будь то чат подземелья, рейда, группы или гильдии."
L.requiresLeadOrAssist = "Эта функция требует быть лидером рейда или помощником."
L.reset = "Сброс"
L.resetAll = "Сбросить все"
L.resetAllCustomSound = "Если вы используете свои звуки для какой-либо битвы, это кнопка спросит ВСЕ такие звуки на стандартные."
L.resetAllDesc = "Если вы настроили цвета для каких-либо событий боя с боссом, эта кнопка сбросит ВСЕ такие настройки."
L.resetDesc = "Сброс цветов на стандартные значения."
L.respawn = "Появление босса"
L.restart = "Перезапуск"
L.restartDesc = "Перезапуск увеличенных полос так, что они стартуют с самого начала, отсчитывая от 10."
L.right = "Вправо"
L.secondary = "Второстепенная"
L.secondaryDesc = "Вторая метка рейда, которая будет использоваться скриптом события."
L.sendBreak = "Отправка таймера перерыва пользователям BigWigs и DBM."
L.sendCustomBar = "Отправка таймера '%s' пользователям BigWigs и DBM."
L.sendPull = "Отправка таймера атаки пользователям BigWigs и DBM."
L.showHide = "Показ/скрыть"
L.showRespawnBar = "Показывать таймер появления"
L.showRespawnBarDesc = "Показывать таймер, который отсчитывает время до появления босса после вайпа."
L.sinkDescription = "Пути вывода сообщений. Отображение поддерживает иконки, цвета и позволяет вывести до 4х сообщений на экран. Новые сообщения будут расти в размерах, и вновь сокращаться, чтобы уведомить игрока."
L.sound = "Звук"
L.soundButton = "Кнопка звука"
L.soundButtonDesc = "Показать или скрыть кнопку звука."
L.soundDelay = "Задержка звука"
L.soundDelayDesc = "Определяет как долго BigWigs должен подождать между повторением заданного звука, когда кто-то слишком близко к вам."
L.soundDesc = "Сообщения могут сопровождаться звуком. Некоторым людям проще услышать звук и опознать к какому сообщению он относится, нежели читать сообщения."
L.Sounds = "Звуки"
L.style = "Стиль"
L.text = "Текст"
L.textCountdown = "Текст отсчета"
L.textCountdownDesc = "Показывать цифры во время отсчета"
L.textShadow = "Тень текста"
L.texture = "Текстура"
L.thick = "Толстый"
L.thin = "Тонкий"
L.time = "Время"
L.timeDesc = "Показывать или скрывать остаток времени на полосах."
L.timerFinished = "%s: Таймер [%s] завершен."
L.title = "Название"
L.titleDesc = "Показать или скрыть название."
L.toggleDisplayPrint = "Монитор будет показан в следующий раз. Чтобы отключить его полностью, уберите галочку в настройках битв."
L.toggleSound = "Переключение звука"
L.toggleSoundDesc = "Включить/выключить звуковое оповещение окна близости, когда вы находитесь слишком близко к другому игроку."
L.tooltip = "Подсказка"
L.tooltipDesc = "Показывает или скрывает подсказку заклинания в окне близости, если эта способность связана боссом."
L.useIcons = "Использовать иконки"
L.useIconsDesc = "Показывать иконку возле сообщения."
L.Victory = "Победа"
L.victoryHeader = "Настройки действий, которые должны быть выполнены после победы над боссом."
L.victoryMessageBigWigs = "Показывать сообщение BigWigs"
L.victoryMessageBigWigsDesc = "Сообщение BigWigs - это простая надпись \"босс был побежден\"."
L.victoryMessageBlizzard = "Показывать сообщение Blizzard"
L.victoryMessageBlizzardDesc = "Сообщение Blizzard - это очень большая анимация \"босс был побежден\" в центре вашего экрана."
L.victoryMessages = "Показывать сообщения о победе над боссом"
L.victorySound = "Проигрывать звук победы над боссом"
L.Warning = "Предупреждение"
L.wipe = "Вайп"
L.wipeSoundTitle = "Пригрывать звук после вайпа"
L.wrongBreakFormat = "Должно быть между 1 и 60 минутами. Например: /break 5"
L.wrongCustomBarFormat = "Неверный формат. Правильно будет: /raidbar 20 текст"
L.wrongPullFormat = "Должно быть между 1 и 60 секундами. Например: /pull 5"
L.wrongTime = "Неверно указанное время. <время> может быть числом в секундах, М:С парой, или Mm. Например, 5, 1:20 или 2m."

-----------------------------------------------------------------------
-- AltPower.lua
--

--L.resetAltPowerDesc = "Reset all the options related to AltPower, including the position of the AltPower anchor."

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

L.spacing = "Промежуток"
L.spacingDesc = "Изменить промежуток между полосами."
L.emphasizeMultiplier = "Множитель Размера"
L.emphasizeMultiplierDesc = "Если Вы отмените перемещение увеличенных полос к своему якорю, эта опция будет просто определять, насколько будут увеличиваться полосы по отношению к нормальным."
--L.temporaryCountdown = "Temporarily enable countdown on the ability associated with this bar."
L.iconPosition = "Позиция Иконки"
L.iconPositionDesc = "Выберите, где на полосе будет находиться иконка."
L.visibleBarLimit = "Лимит отображаемых полос"
L.visibleBarLimitDesc = "Установить максимальное количество полос, отображаемых единовременно."
L.textDesc = "Показать или скрыть текст на полосах."
--L.resetBarsDesc = "Reset all the options related to bars, including the position of the bar anchors."

-----------------------------------------------------------------------
-- BossBlock.lua
--

L.audio = "Звук"
L.music = "Музыка"
L.ambience = "Фоновые звуки"
L.sfx = "Звуковые эффекты"
--L.disableMusic = "Mute music (recommended)"
--L.disableAmbience = "Mute ambient sounds (recommended)"
--L.disableSfx = "Mute sound effects (not recommended)"
L.disableAudioDesc = "Во время боя с боссом '%s' будут выключены для того чтобы помочь вам сконцентрироваться на звуках предупреждений BigWigs. После выхода из боя звуки будут включены обратно."
L.blockTooltipQuests = "Заблокировать цели квестов в подсказке"
L.blockTooltipQuestsDesc = "Когда вам требуется убить босса для квеста, подсказка показывает обычно \"0/1 выполнено\", при наведении мышкой на босса. Эта опция скрывает список целей других игроков, чтобы подсказка не разрослась слишком высоко."
L.blockFollowerMission = "Скрыть уведомления заданий соратников"
L.blockFollowerMissionDesc = "Всплывающие сообщения соратников показывают в основном уведомление о выполнении задания.\n\nЭти уведомления могут скрыть важные части вашего интерфейса в течении боя с боссом, поэтому мы рекомендуем скрыть их."
L.blockObjectiveTracker = "Скрыть панель отслеживания квестов"
L.blockObjectiveTrackerDesc = "Панель отслеживания квестов будет скрыта во время боя с боссом чтобы освободить место на экране.\n\nЭтого НЕ случится если вы находитесь в эпохальном+ подземельи или отслеживаете достижение."

L.subzone_grand_bazaar = "Большой базар" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "Порт Зандалара" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_eastern_transept = "Восточный трансепт" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

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

--L.countdownAt_desc = "Choose how much time should be remaining on a boss ability (in seconds) when the countdown begins."
--L.countdown = "Countdown"
--L.countdownDesc = "The countdown feature involves a spoken audio countdown and a visual text countdown. It is rarely enabled by default, but you can enable it for any boss ability when looking at the specific boss encounter settings."
--L.countdownAudioHeader = "Spoken Audio Countdown"
--L.countdownTextHeader = "Visual Text Countdown"
--L.resetCountdownDesc = "Resets all the above countdown settings to their defaults."
--L.resetAllCountdownDesc = "If you've selected custom countdown voices for any boss encounter settings, this button will reset ALL of them as well as resetting all the above countdown settings to their defaults."

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infoBox = "ИнфоБлок"

-----------------------------------------------------------------------
-- Messages.lua
--

--L.resetMessagesDesc = "Reset all the options related to messages, including the position of the message anchors."
L.uppercase = "БОЛЬШИМИ БУКВАМИ"
--L.uppercaseDesc = "All emphasized messages will be converted to UPPERCASE."

-----------------------------------------------------------------------
-- Proximity.lua
--

--L.resetProximityDesc = "Reset all the options related to proximity, including the position of the proximity anchor."

-----------------------------------------------------------------------
-- Sound.lua
--

--L.oldSounds = "Old Sounds"
--L.resetSoundDesc = "Resets the above sounds to their defaults."
--L.onyou = "A spell, buff, or debuff is on you"
--L.underyou = "You need to move out of a spell under you"

-----------------------------------------------------------------------
-- Statistics.lua
--

L.printHealthOption = "Здоровье босса"
L.healthPrint = "Здоровье: %s."
L.healthFormat = "%s (%.1f%%)"
