local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "ruRU")
if not L then return end

-----------------------------------------------------------------------
-- Bars.lua
--

L["Style"] = "Стиль"
L.bigWigsBarStyleName_Default = "По умолчанию"

L["Clickable Bars"] = "Интерактивные полосы"
L.clickableBarsDesc = "Полосы Big Wigs по умолчанию не реагируют на щелчки мыши в их области. Таким образом, можно выделять объекты или применять АоЕ заклинания за ними, изменять ракурс камеры и т.д., в то время, как курсор находится в области полос. |cffff4411Если вы включите полосы, реагирующие на щелчки мыши, всё это будет невозможно.|r Полосы будут перехватывать любые щелчки мыши в пределах их области.\n"
L["Enables bars to receive mouse clicks."] = "Включает реагирование полос на щелчки мыши."
L["Modifier"] = "Модификатор"
L["Hold down the selected modifier key to enable click actions on the timer bars."] = "Удерживайте выбранную клавишу, чтобы разрешить нажатие по полосе таймера."
L["Only with modifier key"] = "Только с клавишей-модификатором"
L["Allows bars to be click-through unless the specified modifier key is held down, at which point the mouse actions described below will be available."] = "Блокирует нажатие на полосы, за исключением удерживания заданной клавиши, после чего действия мышкой, описанные ниже, будут доступны."

L["Temporarily Super Emphasizes the bar and any messages associated with it for the duration."] = "Временное Супер Увеличение полосы и всех связанных с ней сообщений в течение всего срока действия."
L["Report"] = "Сообщить"
L["Reports the current bars status to the active group chat; either instance chat, raid, party or say, as appropriate."] = "Сообщает текущий статус полосы в активный групповой чат; будь то чат подземелья, рейда, группы или гильдии."
L["Remove"] = "Убрать"
L["Temporarily removes the bar and all associated messages."] = "Временно убирает полосу и все связанные с ней сообщения."
L["Remove other"] = "Убрать другие"
L["Temporarily removes all other bars (except this one) and associated messages."] = "Временно удаляет все другие полосы (кроме этой) и связанные с ними сообщения."
L.disable = "Отключить"
L["Permanently disables the boss encounter ability option that spawned this bar."] = "Полностью отключает способность босса, которая вызывает эту полосу."

L["Emphasize at... (seconds)"] = "Увеличение на... (секунды)"
L["Scale"] = "Масштаб"
L["Grow upwards"] = "Рост вверх"
L["Toggle bars grow upwards/downwards from anchor."] = "Переключение направления роста полос вверх или вниз."
L["Texture"] = "Текстура"
L["Emphasize"] = "Увеличение"
L["Enable"] = "Включить"
L["Move"] = "Перемещение"
L.moveDesc = "Перемещение увеличенных полос. Если эта опция отключена, увеличенные полосы просто будут изменять масштаб и окраску."
L["Regular bars"] = "Обычные полосы"
L["Emphasized bars"] = "Увеличенные полосы"
L["Align"] = "Выравнивание"
L["Left"] = "Влево"
L["Center"] = "По центру"
L["Right"] = "Вправо"
L["Time"] = "Время"
L["Whether to show or hide the time left on the bars."] = "Показывать или скрывать остаток времени на полосах."
L["Icon"] = "Иконка"
L["Shows or hides the bar icons."] = "Показывать или скрывать иконку полосы."
L.font = "Шрифт"
L["Restart"] = "Перезапуск"
L["Restarts emphasized bars so they start from the beginning and count from 10."] = "Перезапуск увеличенных полос так, что они стартуют с самого начала, отсчитывая от 10."
L["Fill"] = "Заполнение"
L["Fills the bars up instead of draining them."] = "Заполнение полос, вместо убывания."

L["Local"] = "Локальный"
L["%s: Timer [%s] finished."] = "%s: Таймер [%s] готов."
L["Custom bar '%s' started by %s user %s."] = "Таймер '%s' начат %s игроком %s."

L["Pull"] = "Атака"
L["Pulling!"] = "Выступаем!"
L["Pull timer started by %s user %s."] = "Таймер атаки начат %s игроком %s."
L["Pull in %d sec"] = "Атакуем через %d сек"
L["Sending a pull timer to Big Wigs and DBM users."] = "Отправка таймера атаки пользователям Big Wigs и DBM."
L["Sending custom bar '%s' to Big Wigs and DBM users."] = "Отправка таймера '%s' пользователям Big Wigs и DBM."
L["This function requires raid leader or raid assist."] = "Эта функция требует быть лидером рейда или помощником."
L["Must be between 1 and 60. A correct example is: /pull 5"] = "Должно быть между 1 и 60. Например: /pull 5"
L["Incorrect format. A correct example is: /raidbar 20 text"] = "Неверный формат. Правильно будет: /raidbar 20 текст"
L["Invalid time specified. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Неверно указанное время. <время> может быть числом в секундах, М:С парой, или Mm. Например, 5, 1:20 или 2m."
L["This function can't be used during an encounter."] = "Это функция не может быть использована во время битвы."
L["Pull timer cancelled by %s."] = "Таймер атаки отменен |3-4(%s)."



-- These localization strings are translated on WoWAce: http://www.wowace.com/addons/big-wigs/localization/
--@localization(locale="ruRU", namespace="Plugins", format="lua_additive_table", handle-unlocalized="ignore")@

