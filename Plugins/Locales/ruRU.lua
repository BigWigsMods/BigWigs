local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "ruRU")

if not L then return end

-----------------------------------------------------------------------
-- Bars.lua
--

L["Clickable Bars"] = "Полосы активизируемые щелчком мыши"
L.clickableBarsDesc = "Полосы Big Wigs по умолчанию не реагируют на щелчки мыши в их области. Таким образом, можно целится в объекты или запустить массовое, целенаправленное заклинаний за ними, изменить ракурс камеры, и так далее, в то время как курсор находится в области полос.|cffff4411Если вы включите полосы активизируемые щелчком мыши, это больше работать не будет.|r Полосы будут перехватывать любые щелчки мыши выполняемые в их области.\n"
L["Enables bars to receive mouse clicks."] = "Включает восприятие щелчков мыши в области полос."

L["Temporarily Super Emphasizes the bar and any messages associated with it for the duration."] = "Временное супер увеличение полос и всех сообщений, связанные с ним в течение всего срока действия."
L["Report"] = "Сообщить"
L["Reports the current bars status to the active group chat; either battleground, raid, party or guild, as appropriate."] = "Сообщает текущий статус полосы в активный чат группы чата; либо поля боя, рейда, группы или гильдии, по мере необходимости."
L["Remove"] = "Убрать"
L["Temporarily removes the bar and all associated messages."] = "Временно убирает полосу и все связанные с ней сообщения."
L["Remove other"] = "Убрать другие"
L["Temporarily removes all other bars (except this one) and associated messages."] = "Временно удаляет все другие полосу (кроме одной) и связанные с ними сообщения."
L["Disable"] = "Отключить"
L["Permanently disables the boss encounter ability option that spawned this bar."] = "Полностью отключает способность события босса, которое порождает эту полосу."

L["Scale"] = "Масштаб"
L["Grow upwards"] = "Рост вверх"
L["Toggle bars grow upwards/downwards from anchor."] = "Преключение роста полос от якоря вверх или вниз."
L["Texture"] = "Текстуры"
L["Emphasize"] = "Увеличение"
L["Enable"] = "Включить"
L["Move"] = "Перемещение"
L["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."] = "Перемещение увеличенных полос. Если эта опция отключена, увеличенные полосы просто можно будет изменить масштаб, окраску, и задать мигание."
L["Flash"] = "Мерцание"
L["Flashes the background of emphasized bars, which could make it easier for you to spot them."] = "Мерцание фона увеличенных полос, что может подчеркнуть их заметность."
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
L["Font"] = "Шрифт"

L["Local"] = "Локальный"
L["%s: Timer [%s] finished."] = "%s: Таймер [%s] готов."
L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Неверное время (|cffff0000%q|r) или отсутствие текста в пользовательской полосе запущенной |cffd9d919%s|r. <время> может вводится цифрами в секундах, М:С парный, или Мм. К примеру 5, 1:20 или 2м."

-----------------------------------------------------------------------
-- Colors.lua
--

L["Colors"] = "Цвета"

L["Messages"] = "Сообщения"
L["Bars"] = "Полосы"
L["Background"] = "Фон"
L["Text"] = "Текст"
L["Flash and shake"] = "Мигание и тряска"
L["Normal"] = "Обычные"
L["Emphasized"] = "Увеличенные"

L["Reset"] = "Сброс"
L["Resets the above colors to their defaults."] = "Сброс цветов наже на стандартные значения."
L["Reset all"] = "Сбросить все"
L["If you've customized colors for any boss encounter settings, this button will reset ALL of them so the colors defined here will be used instead."] = "Если вы настроили цвета для каких-либо событий боя с боссом, эта кнопка сбросит ВСЕ эти настройки."

L["Important"] = "Важные"
L["Personal"] = "Личные"
L["Urgent"] = "Экстренные"
L["Attention"] = "Внимание"
L["Positive"] = "Позитивные"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Route output from this addon through the Big Wigs message display. This display supports icons, colors and can show up to 4 messages on the screen at a time. Newly inserted messages will grow in size and shrink again quickly to notify the user."

L["Messages"] = "Сообщения"

L["Use colors"] = "Использовать цвета"
L["Toggles white only messages ignoring coloring."] = "Не раскрашивать сообщения (белый текст)."

L["Use icons"] = "Использовать иконки"
L["Show icons next to messages, only works for Raid Warning."] = "Отображать иконки сообщений, работает только для объявлений рейда."

L["Class colors"] = "Окраска по классу"
L["Colors player names in messages by their class."] = "Окрашивает имя игрока в сообщениях в соответствии с его классом."

L["Chat frame"] = "Окно чата"
L["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "Выводить все сообщения BigWigs в стандартное окно чата в дополнении с настройками отображения."

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L["Icons"] = "Иконки"

L.raidIconDescription = "Some encounters might include elements such as bomb-type abilities targetted on a specific player, a player being chased, or a specific player might be of interest in other ways. Here you can customize which raid icons should be used to mark these players.\n\nIf an encounter only has one ability that is worth marking for, only the first icon will be used. One icon will never be used for two different abilities on the same encounter, and any given ability will always use the same icon next time.\n\n|cffff4411Note that if a player has already been marked manually, Big Wigs will never change his icon.|r"
L["Primary"] = "Основная"
L["The first raid target icon that a encounter script should use."] = "Основная иконка рейда которая будет первой использоваться скриптом события."
L["Secondary"] = "Вторичная"
L["The second raid target icon that a encounter script should use."] = "Второстипенная иконка рейда которая будет использоваться скриптом события."

L["Star"] = "Звезда"
L["Circle"] = "Круг"
L["Diamond"] = "Ромб"
L["Triangle"] = "Треугольник"
L["Moon"] = "Луна"
L["Square"] = "Квадрат"
L["Cross"] = "Крест"
L["Skull"] = "Череп"
L["|cffff0000Disable|r"] = "|cffff0000Disable|r"

-----------------------------------------------------------------------
-- Sound.lua
--

L.soundDefaultDescription = "При выборе данной опции Big Wigs будет использовать только стандартные звуки объявления рейду для тех сообщений которые будут сопровождаться звуковым сигналом. Помните, что только некоторые сообщения из скриптов сражений соппровождаются звуковым сигналом."

L["Sounds"] = "Звуки"

L["Alarm"] = "Тревога"
L["Info"] = "Информация"
L["Alert"] = "Предупреждения"
L["Long"] = "Длинный"
L["Victory"] = "Победа"

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "Установите звук для использования в %q.\n\n[Ctrl-Клик] для предварительного прослушивания звука."
L["Default only"] = "Только стандартные"

-----------------------------------------------------------------------
-- Proximity.lua
--

L["%d yards"] = "%d метров"
L["Proximity"] = "Близость"
L["Sound"] = "Звук"
L["Disabled"] = "Отключить"
L["Disable the proximity display for all modules that use it."] = "Отключить отображение окна близости для всех модулей использующих его."
L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = "Модуль близости будет показан в следующий раз. Чтобы полностью его отключить для данного боя, вам нужно зайти в опции этого боя и отключить его там."

L.proximity = "Отображение близости"
L.proximity_desc = "Показывать окно близости при соответствующей схватке, выводя список игроков которые стоят слишком близко к вам."
L.proximityfont = "Fonts\\FRIZQT__.TTF"

L["Close"] = "Закрыть"
L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = "Закрыть окно модуля близости.\n\nЧтобы полностью его отключить для любого боя, вам нужно зайти в опции соответствующего босса и там отключить опцию 'Близость'."
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

-----------------------------------------------------------------------
-- Tips.lua
--

L["|cff%s%s|r says:"] = "|cff%s%s|r говорит:"
L["Cool!"] = "Cool!"
L["Tips"] = "Советы"
L["Tip of the Raid"] = "Советы рейда"
L["Tip of the raid will show by default when you zone in to a raid instance, you are not in combat, and your raid group has more than 9 players in it. Only one tip will be shown per session, typically.\n\nHere you can tweak how to display that tip, either using the pimped out window (default), or outputting it to chat. If you play with raid leaders who overuse the |cffff4411/sendtip command|r, you might want to show them in chat frame instead!"] = "Советы рейда будет показыны по умолчанию, когда вы входите в рейдовую зону, когда вы вне боя, и ваша рейд группа состоит более чем из 9 игроков. За сессию будет показан всего один совет.\n\nЗдесь вы можете настроить способ отображения советов, либо с помощью всплываючего окна (по умолчанию), или выводить их в чате. Если ваш рейд лидером, злоупотребляет командой |cffff4411/sendtip command|r, вы можете выводить их в окно чата!"
L["If you don't want to see any tips, ever, you can toggle them off here. Tips sent by your raid officers will also be blocked by this, so be careful."] = "Если вы не хотите видеть какие-либо советы, здесь вы можете отключить их. Советы присланные вашыми офицерами рейда также будет заблокированы, так что будьте осторожны."
L["Automatic tips"] = "Авто-советы"
L["If you don't want to see the awesome tips we have, contributed by some of the best PvE players in the world, pop up when you zone in to a raid instance, you can disable this option."] = "Если вы не хотите видеть потрясающие советы, которые всплывают при входе в рейд, предоставленные одними из лучших PvE игроков в мире, вы можете смело отключить эту опцию."
L["Manual tips"] = "Советы в ручную"
L["Raid officers have the ability to show manual tips with the /sendtip command. If you have an officer who spams these things, or for some other reason you just don't want to see them, you can disable it with this option."] = "Офицеры рейда имеют возможность показать игрокам в рейде свои советы командой /sendtip. Если ваш офицер использует данную команду и спамит советы, или по какой другой причине, и вы просто не хотят их видеть, вы можете отключить это с помощью этой опции."
L["Output to chat frame"] = "Вывод в окно чата"
L["By default the tips will be shown in their own, awesome window in the middle of your screen. If you toggle this, however, the tips will ONLY be shown in your chat frame as pure text, and the window will never bother you again."] = "По умолчанию советы будут показаны в их собственном окно в центре экрана. Если вы переключите это, тем не менее, советы будут отображаться только в окне чата как простой текст, и окно никогда не будет беспокоить вас снова."
L["Usage: /sendtip <index|\"Custom tip\">"] = "Используйте: /sendtip <index|\"свот совет\">"
L["You must be an officer in the raid to broadcast a tip."] = "Вы должны быть офицером в рейде для передачи советов."
L["Tip index out of bounds, accepted indexes range from 1 to %d."] = "Индекс совета выходит за пределы поля, допустимый деапазон индекса от 1 до %d."

-----------------------------------------------------------------------
-- Emphasize.lua
--

L["Super Emphasize"] = "Супер увеличение"
L.superEmphasizeDesc = "Увеличивает полосы и сообщения, относящиеся к определенным способностям босса.\n\nЗдесь вы можете настроить, что должно произойти, когда вы включаете супер увеличение в расширенном разделе способностей босса.\n\n|cffff4411Отметим, что супер увеличение отключено по умолчанию для всех способностей.|r\n"
L["UPPERCASE"] = "ЗАГЛАВНЫЙ"
L["Uppercases all messages related to a super emphasized option."] = "Отобаржать все сообщения в верхнем регистре, связанные с настройками супер увеличения."
L["Double size"] = "Двойно размер"
L["Doubles the size of super emphasized bars and messages."] = "Удвоит размер супер увеличенных полос и сообщений."
L["Countdown"] = "Отсчет времени"
L["If a related timer is longer than 5 seconds, a vocal and visual countdown will be added for the last 5 seconds. Imagine someone counting down \"5... 4... 3... 2... 1... COUNTDOWN!\" and big numbers in the middle of your screen."] = "Если соответствующий таймер больше, чем 5 секунд, звуковой и визуальный отсчет времени будет добавлен в течение последних 5 секунд."
L["Flash"] = "Мигание"
L["Flashes the screen red during the last 3 seconds of any related timer."] = "Вспышки экрана красным в течение последних 3 секунды любого связанного таймера."
