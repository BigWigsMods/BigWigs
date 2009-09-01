local L = LibStub("AceLocale-3.0"):NewLocale("BigWigs:Extras", "ruRU")

if not L then return end


-- Custombars.lua

L["Local"] = "Локальный"
L["%s: Timer [%s] finished."] = "%s: Таймер [%s] готов."
L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Неверное время (|cffff0000%q|r) или отсутствие текста в пользовательской полосе запущенной |cffd9d919%s|r. <время> может вводится цифрами в секундах, М:С парный, или Мм. К примеру 5, 1:20 или 2м."

-- Version.lua

L["should_upgrade"] = "У вас вероятно старая версия Big Wigs. Мы рекомендуем вам обновить её перед началом боя с боссом."
L["out_of_date"] = "Игроки, которые используют старую версию: %s."
L["not_using"] = "Участники группы не использующие Big Wigs: %s."

-- Proximity.lua

L["Proximity"] = "Близость"
L["Close Players"] = "Слишком близко"
L["Options for the Proximity Display."] = "Опции отображения близости."
L["|cff777777Nobody|r"] = "|cff777777Никого|r"
L["Sound"] = "Звук"
L["Play sound on proximity."] = "Проиграть звук при приближении игроков."
L["Disabled"] = "Отключить"
L["Disable the proximity display for all modules that use it."] = "Отключить отображение окна близости для всех модулей использующих его."
L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = "Модуль близости будет показан в следующий раз. Чтобы полностью его отключить для данного боя, вам нужно зайти в опции этого боя и отключить его там."
L["The proximity display has been locked, you need to right click the Big Wigs icon, go to Extras -> Proximity -> Display and toggle the Lock option if you want to move it or access the other options."] = "Отображение модуля близости зафиксировано, вам нужно нажать правую клавишу мыши по иконке Big Wigs, перейти в Extras -> Близость -> Отображение и переключить опцию Фиксировать, если вы хотите его переместить или получить доступ к другим опциям."

proximity = "Отображение близости"
proximity_desc = "Показывать окно близости при соответствующей схватке, выводя список игроков которые стоят слишком близко к вам."

font = "Fonts\\NIM_____.ttf"

L["Close"] = "Закрыть"
L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = "Закрыть окно модуля близости.\n\nЧтобы полностью его отключить для любого боя, вам нужно зайти в опции соответствующего босса и там отключить опцию 'Близость'."
L["Test"] = "Тест"
L["Perform a Proximity test."] = "Тест близости"
L["Display"] = "Отображение"
L["Options for the Proximity display window."] = "Настройки окна близости."
L["Lock"] = "Фиксировать"
L["Locks the display in place, preventing moving and resizing."] = "Фиксирование рамки, предотвращает перемещение и изменение размера."
L["Title"] = "Заглавие"
L["Shows or hides the title."] = "Показать или скрыть заглавие."
L["Background"] = "Фон"
L["Shows or hides the background."] = "Показать или скрыть фон."
L["Toggle sound"] = "Вкл/Выкл звук"
L["Toggle whether or not the proximity window should beep when you're too close to another player."] = "Включить/выключить звуковое оповещение окна близости, когда вы находитесь слишком близко к другому игроку."
L["Sound button"] = "Кнопка звука"
L["Shows or hides the sound button."] = "Показывать или скрывать кнопку звука."
L["Close button"] = "Кнопка закрытия"
L["Shows or hides the close button."] = "Показывать или скрывать кнопку закрытия."
L["Show/hide"] = "Показ/скрыть"
