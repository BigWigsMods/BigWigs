local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "ruRU")
if not L then return end

L.abilityName = "Название способности"
L.abilityNameDesc = "Показывает или скрывает название способности в верхней части окна."
L.Alarm = "Тревога"
L.Alert = "Оповещение"
L.align = "Выравнивание"
L.alignText = "Выравнивание текста"
L.alignTime = "Выравнивание времени"
L.altPowerTitle = "Энергия"
L.Attention = "Внимание"
L.background = "Фон"
L.backgroundDesc = "Показать или скрыть фон."
L.bars = "Полосы"
L.bestTimeBar = "Лучшее время"
L.Beware = "Берегитесь (Алгалон)"
L.bigWigsBarStyleName_Default = "По умолчанию"
L.blockEmotes = "Скрыть эмоции посередине экрана"
L.blockEmotesDesc = [=[Некоторые боссы показывают текст для определенных способностей. Эти сообщения и слишком длинные и избыточные. Мы стараемся предоставлять более подходящие сообщения, которые не вмешиваются в ваш геймплей и не говорят вам что конкретно вы должны делать.

Обратите внимание: Эмоции босса всегда будут доступны в чате, если вы захотите их прочитать.]=]
L.blockGarrison = "Скрыть уведомления гарнизона"
L.blockGarrisonDesc = [=[Всплывающие сообщения гарнизона показывают в основном уведомление о выполнении соратником задания.

Эти уведомления могут скрыть важные части вашего интерфейса в течении боя с боссом, поэтому мы рекомендуем скрыть их.]=]
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
L.customSoundDesc = "Воспроизводить пользовательский звук, вместо используемого в модуле"
L.defeated = "%s терпит поражение"
L.Destruction = "Разрушение (Кил'джеден)"
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
L.emphasizedCountdown = "Увеличенный обратный отсчет"
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
L.FlagTaken = "Взятие флага (PvP)"
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
L.Important = "Важные"
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
L.Neutral = "Нейтральные"
L.newBestTime = "Рекордное убийство!"
L.none = "Нет"
L.normal = "Обычные"
L.normalMessages = "Обычные сообщения"
L.outline = "Контур"
L.output = "Вывод"
L.Personal = "Личные"
L.positionDesc = "Введите в поле или передвиньте якорь если вам нужно точное позиционирование."
L.positionExact = "Точная позиция"
L.positionX = "Позиция X"
L.positionY = "Позиция Y"
L.Positive = "Положительные"
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
L.pulling = "Выступаем!"
L.pullStarted = "Таймер атаки начат %s игроком %s."
L.pullStopped = "%s отменил таймер атаки."
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
L.RunAway = "Беги, малышка, беги (Злой и страшный серый волк)"
L.scale = "Масштаб"
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
L.superEmphasize = "Увеличение"
L.superEmphasizeDesc = [=[Увеличивает полосы и сообщения, относящиеся к определенным способностям босса.

Здесь вы можете настроить, что должно произойти, когда вы включаете супер увеличение в расширенном разделе способностей босса.

|cffff4411Помните, что супер увеличение отключено по умолчанию для всех способностей.|r
]=]
L.superEmphasizeDisableDesc = "Отключить Супер Увеличение для всех модулей."
L.tempEmphasize = "Временное Супер Увеличение полосы и всех связанных с ней сообщений в течение всего срока действия."
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
L.uppercase = "БОЛЬШИМИ БУКВАМИ"
L.uppercaseDesc = "Отображать все сообщения, связанные с настройками супер увеличения, в верхнем регистре"
L.Urgent = "Экстренные"
L.useColors = "Использовать цвета"
L.useColorsDesc = "Не раскрашивать сообщения (белый текст)."
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
L.wrongBreakFormat = "Должно быть между 1 и 60 минутами. Например: /break 5"
L.wrongCustomBarFormat = "Неверный формат. Правильно будет: /raidbar 20 текст"
L.wrongPullFormat = "Должно быть между 1 и 60 секундами. Например: /pull 5"
L.wrongTime = "Неверно указанное время. <время> может быть числом в секундах, М:С парой, или Mm. Например, 5, 1:20 или 2m."

-----------------------------------------------------------------------
-- AutoReply.lua
--

--L.autoReply = "Auto Reply"
--L.autoReplyDesc = "Automatically reply to whispers when engaged in a boss encounter."
--L.responseType = "Response Type"
--L.autoReplyFinalReply = "Also whisper when leaving combat"
--L.guildAndFriends = "Guild & Friends"
--L.everyoneElse = "Everyone else"

--L.autoReplyBasic = "I'm busy in combat with a boss encounter."
--L.autoReplyNormal = "I'm busy in combat with '%s'."
--L.autoReplyAdvanced = "I'm busy in combat with '%s' (%s) and %d/%d people are alive."
--L.autoReplyExtreme = "I'm busy in combat with '%s' (%s) and %d/%d people are alive: %s"

--L.autoReplyLeftCombatBasic = "I am no longer in combat with a boss encounter."
--L.autoReplyLeftCombatNormalWin = "I won against '%s'."
--L.autoReplyLeftCombatNormalWipe = "I lost against '%s'."
--L.autoReplyLeftCombatAdvancedWin = "I won against '%s' with %d/%d people alive."
--L.autoReplyLeftCombatAdvancedWipe = "I lost against '%s' at: %s"

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infoBox = "ИнфоБлок"

-----------------------------------------------------------------------
-- Statistics.lua
--

L.printHealthOption = "Здоровье босса"
L.healthPrint = "Здоровье: %s."
L.healthFormat = "%s (%.1f%%)"
