local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "ruRU")

if not L then return end

-----------------------------------------------------------------------
-- Bars.lua
--

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

L.soundDefaultDescription = "With this option set, Big Wigs will only use the default Blizzard raid warning sound for messages that come with a sound alert. Note that only some messages from encounter scripts will trigger a sound alert."

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
L["If you don't want to see any tips, ever, you can toggle them off here. Tips sent by your raid leader will also be blocked by this, so be careful."] = "Если вы не хотите видеть какие-либо советы, здесь вы можете отключить их. Советы присланные вашым лидером рейда также будет заблокирован, так что будьте осторожны."
L["Automatic tips"] = "Авто-советы"
L["If you don't want to see the awesome tips we have, contributed by some of the best PvE players in the world, pop up when you zone in to a raid instance, you can disable this option."] = "Если вы не хотите видеть потрясающие советы, которые всплывают при входе в рейд, предоставленные одними из лучших PvE игроков в мире, вы можете смело отключить эту опцию."
L["Manual tips"] = "Советы в ручную"
L["Raid leaders have the ability to show the players in the raid a manual tip with the /sendtip command. If you have a raid leader who spams these things, or for some other reason you just don't want to see them, you can disable it with this option."] = "Рейд лидеры имеют возможность показать игрокам в рейде свои советы командой с /sendtip. Если ваш рейд лидер использует данную команду и спамит советы, или по какой другой причине, и вы просто не хотят их видеть, вы можете отключить это с помощью этой опции."
L["Output to chat frame"] = "Вывод в окно чата"
L["By default the tips will be shown in their own, awesome window in the middle of your screen. If you toggle this, however, the tips will ONLY be shown in your chat frame as pure text, and the window will never bother you again."] = "По умолчанию советы будут показаны в их собственном окно в центре экрана. Если вы переключите это, тем не менее, советы будут отображаться только в окне чата как простой текст, и окно никогда не будет беспокоить вас снова."
L["Usage: /sendtip <index|\"Custom tip\">"] = "Используйте: /sendtip <index|\"свот совет\">"
L["You must be the raid leader to broadcast a tip."] = "Вы должны быть лидером рейды для передачи советов."
L["Tip index out of bounds, accepted indexes range from 1 to %d."] = "Индекс совета выходит за пределы поля, допустимый деапазон индекса от 1 до %d."