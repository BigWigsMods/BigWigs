local L = LibStub("AceLocale-3.0"):NewLocale("BigWigs:Plugins", "ruRU")

if not L then return end

-- Bars2.lua

L["Bars"] = "Полосы"
L["Normal Bars"] = "Обычные полосы"
L["Emphasized Bars"] = "Увеличенные полосы"
L["Options for the timer bars."] = "Опции полос времени."
L["Toggle anchors"] = "Переключение якоря"
L["Show or hide the bar anchors for both normal and emphasized bars."] = "Показать или скрыть якорь полосы для обычных и увеличенных полос."
L["Scale"] = "Масштаб"
L["Set the bar scale."] = "Настройка масштаба полос."
L["Grow upwards"] = "Рост вверх"
L["Toggle bars grow upwards/downwards from anchor."] = "Преключение роста полос от якоря вверх или вниз."
L["Texture"] = "Текстуры"
L["Set the texture for the timer bars."] = "Установка текстур для полос времени."
L["Test"] = "Тест"
L["Close"] = "Закрыть"
L["Emphasize"] = "Увеличение"
L["Emphasize bars that are close to completion (<10sec). Also note that bars started at less than 15 seconds initially will be emphasized right away."] = "Увеличение полос которые близятся к завершению (<10сек). Так же имейте ввиду что полосы продолжительностью менее 15 секунд буду увеличенные сразу."
L["Enable"] = "Включить"
L["Enables emphasizing bars."] = "Включить увеличение полос."
L["Move"] = "Перемещение"
L["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."] = "Перемещение увеличенных полос. Если эта опция отключена, увеличенные полосы просто можно будет изменить масштаб, окраску, и задать мигание."
L["Set the scale for emphasized bars."] = "Установка масштаба увеличенных полос."
L["Reset position"] = "Сброс позиции"
L["Reset the anchor positions, moving them to their default positions."] = "Сброс позиций якоря, вернув его в стандартное положение."
L["Test"] = "Тест"
L["Creates a new test bar."] = "Создаёт новые тестовые полосы."
L["Hide"] = "Скрыть"
L["Hides the anchors."] = "Скрыть якорь."
L["Flash"] = "Мерцание"
L["Flashes the background of emphasized bars, which could make it easier for you to spot them."] = "Мерцание фона увеличенных полос, что может подчеркнуть их заметность."
L["Regular bars"] = "Обычные полосы"
L["Emphasized bars"] = "Увеличенные полосы"
L["Align"] = "Выравнивание"
L["How to align the bar labels."] = "Как выравнивать текстовые данные полосы."
L["Left"] = "Влево"
L["Center"] = "По центру"
L["Right"] = "Вправо"
L["Time"] = "Время"
L["Whether to show or hide the time left on the bars."] = "Показывать или скрывать остаток времени на полосах."
L["Icon"] = "Иконка"
L["Shows or hides the bar icons."] = "Показывать или скрывать иконку полосы."
L["Font"] = "Шрифт"
L["Set the font for the timer bars."] = "Установка шрифта, кторый будет отображаться на полосах."

-- Colors.lua
L["Colors"] = "Цвета"

L["Messages"] = "Сообщения"
L["Bars"] = "Полосы"
L["Short"] = "Короткие"
L["Long"] = "Длинные"
L["Short bars"] = "Короткие полосы"
L["Long bars"] = "Длинные полосы"
L["Color "] = "Цвет"
L["Number of colors"] = "Число цветов"
L["Background"] = "Фон"
L["Text"] = "Текст"
L["Reset"] = "Сброс"

L["Bar"] = "Полосы"
L["Change the normal bar color."] = "Изменение цвета обычных полос."
L["Emphasized bar"] = "Увеличенные полосы"
L["Change the emphasized bar color."] = "Изменение цвета увеличенных полос."

L["Colors of messages and bars."] = "Цвета сообщений и полос"
L["Change the color for %q messages."] = "Изменить цвет %q сообщений"
L["Change the %s color."] = "Изменить цвет %s"
L["Change the bar background color."] = "Изменить цвет фона полосы"
L["Change the bar text color."] = "Изменить цвет текста полосы"
L["Resets all colors to defaults."] = "Сброс всех цветов на стандартные значения"

L["Important"] = "Важные"
L["Personal"] = "Личные"
L["Urgent"] = "Экстренные"
L["Attention"] = "Внимание"
L["Positive"] = "Позитивные"
L["Bosskill"] = "Убийство Босса"
L["Core"] = "Ядро"

L["color_upgrade"] = "Ваши установленные цвета для сообщений и полос, были сброшены в целях упрощения обновления последней версии. Если вы хотите настроить их снова, щелкните правой кнопкой мыши по Big Wigs и перейдите в Плагины -> Цвета."

	
-- Messages.lua
L["Messages"] = "Сообщения"
L["Options for message display."] = "Опции отображения сообщений"

L["BigWigs Anchor"] = "Якорь BigWigs"
L["Output Settings"] = "Настройки вывода"

L["Show anchor"] = "Показать якорь"
L["Show the message anchor frame.\n\nNote that the anchor is only usable if you select 'BigWigs' as Output."] = "Отображение якоря сообщений\n\nЗаметьте, что якорь доступен только если вы выбрали 'BigWigs' для вывода сообщений."

L["Use colors"] = "Использовать цвета"
L["Toggles white only messages ignoring coloring."] = "Не раскрашивать сообщения (белый текст)."

L["Scale"] = "Масштаб"
L["Set the message frame scale."] = "Настройка масштаба фрейма сообщений."

L["Use icons"] = "Использовать иконки"
L["Show icons next to messages, only works for Raid Warning."] = "Отображать иконки сообщений, работает только для объявлений рейда."

L["Class colors"] = "Окраска по классу"
L["Colors player names in messages by their class."] = "Окрашивает имя игрока в сообщениях в соответствии с его классом."

L["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = "|cffff0000Co|cffff00fflo|cff00ff00r|r"
L["White"] = "Белый"

L["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "Выводить все сообщения BigWigs в стандартное окно чата в дополнении с настройками отображения"

L["Chat frame"] = "Окно чата"

L["Test"] = "Тест"
L["Close"] = "Закрыть"

L["Reset position"] = "Сброс"
L["Reset the anchor position, moving it to the center of your screen."] = "Сбрасывает позицию якоря, перемещая его в центр вашего экрана."

L["Spawns a new test warning."] = "Вывод новых тестовых сообщений."
L["Hide"] = "Скрыть"
L["Hides the anchors."] = "Скрывает якорь."

-- RaidIcon.lua
L["Raid Icons"] = "Иконки рейда"
L["Configure which icon Big Wigs should use when placing raid target icons on players for important 'bomb'-type boss abilities."] = "Настройка иконки Big Wigsа, какая должна быть поставлена на игрока при выполненных важных способностей боссов, к примеру 'бомба'."

L["RaidIcon"] = "ИконкиРейда"

L["Place"] = "Ставить"
L["Place Raid Icons"] = "Ставить иконку рейда"
L["Toggle placing of Raid Icons on players."] = "Вкл/Выкл размещение рейдовых иконок на игроках"

L["Icon"] = "Иконка"
L["Set Icon"] = "Установка иконки"
L["Set which icon to place on players."] = "Установите какая иконка будет ставиться на игроках"

L["Use the %q icon when automatically placing raid icons for boss abilities."] = "Использует иконку %q которая автоматически ставится на игрока при выполненных способностей босса."

L["Star"] = "Звезда"
L["Circle"] = "Круг"
L["Diamond"] = "Ромб"
L["Triangle"] = "Треугольник"
L["Moon"] = "Луна"
L["Square"] = "Квадрат"
L["Cross"] = "Крест"
L["Skull"] = "Череп"

-- RaidWarn.lua
L["RaidWarning"] = "Объявление рейду"

L["Whisper"] = "Шептание"
L["Toggle whispering warnings to players."] = "Вкл/Выкл шептание предупреждений игрокам."

L["raidwarning_desc"] = "Позволяет настроить куда BigWigs будет передовать предупреждения о действиях босса в дополнении с локальным выводом."

-- Sound.lua
L["Sounds"] = "Звуки"
L["Options for sounds."] = "Опции звуков."

L["Alarm"] = "Тревога"
L["Info"] = "Информация"
L["Alert"] = "Предупреждения"
L["Long"] = "Длинный"
L["Victory"] = "Победа"

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "Установите звук для использования в %q.\n\nCtrl-Клик для предварительного прослушивания звука."
L["Use sounds"] = "Использовать звуки"
L["Toggle all sounds on or off."] = "Вкл/Выкл все звуки"
L["Default only"] = "Только стандартные"
L["Use only the default sound."] = "Использовать только стандартные звуки."
