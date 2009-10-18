local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs", "ruRU")

if not L then return end

-- Core.lua
L["%s enabled"] = "%s включен"	-- "<boss> enabled"  -- XXX used ?
L["%s has been defeated"] = "%s побеждён"     -- "<boss> has been defeated"

L.bosskill = "Смерть босса"
L.bosskill_desc = "Объявлять о смерти босса."
L.berserk = "Берсерк"
L.berserk_desc = "Предупреждать, когда босс входит в состояние берсерк."

-- L.already_registered = "|cffff0000Внимание:|r |cff00ff00%s|r (|cffffff00%d|r) уже существует как модуль Big Wigs,но чтото снова пытается его зарегистрировать (ревизия |cffffff00%d|r). Это обычно означает, что у вас две копии этого модуля в папке модификации, возможно из-за ошибки обновления программой обновления модификаций. Мы рекомендуем вам удалить все папки Big Wigs , а затем установить его заново с нуля."

-- Loader / Options.lua
L["You are running an official release of Big Wigs %s (revision %d)"] = "Вы используете оффициальный выпуск Big Wigs %s (ревизии %d)"
L["You are running an ALPHA RELEASE of Big Wigs %s (revision %d)"] = "Вы используете ALPHA ВЫПУСК Big Wigs %s (ревизии %d)"
L["You are running a source checkout of Big Wigs %s directly from the repository."] = "Вы используете отладочный Big Wigs %s прямо из репозитория."
L["There is a new release of Big Wigs available. You can visit curse.com, wowinterface.com, wowace.com or use the Curse Updater to get the new release."] = "Доступен новый выпуск Big Wigs. Для получения нового выпуска почетите curse.com, wowinterface.com, wowace.com или воспользуйтесь Curse Updater."

 -- XXX Our tooltip sucks, I want these things gone and automated!
L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them."] = "|cffeda55fЩёлкните|r, чтобы сбросить все запущенные модули. |cffeda55fAlt+Левый Клик|r - чтобы отключить их."
L["Active boss modules:"] = "Активные модули боссов:"
L["All running modules have been reset."] = "Все запущенные модули сброшены."
L["Big Wigs is currently disabled."] = "В данный момент Big Wigs отключен."
L["|cffeda55fClick|r to enable."] = "|cffeda55fЩёлкните|r чтобы включить."
L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."] = "|cffeda55fЩёлкните|r, чтобы сбросить все запущенные модули. |cffeda55fAlt-Клик|r - чтобы отключить их. |cffeda55fCtrl-Alt-Клик|r - чтобы отключить Big Wigs полностью."
L["All running modules have been disabled."] = "Все запущенные модули были отключены."

L["There are people in your group with older versions or without Big Wigs. You can get more details with /bwv."] = "В группе есть люди с более ранними версиями или без Big Wigs. Вы можете получить более подробную информацию введя /bwv."
L["Up to date:"] = "Текущий:"
L["Out of date:"] = "Устарелый:"
L["No Big Wigs 3.0:"] = "Нет Big Wigs 3.0:"

-- Options.lua
-- XXX Perhaps option descriptions should be in key form, so it's
-- XXX L.iconDesc = .. instead of L["Bla bla bla ...
L["Big Wigs Encounters"] = "Big Wigs Encounters"
L["Customize ..."] = "Настройки ..."
L["Welcome to Big Wigs, where the boss encounters roam. Please fasten your seatbelt, eat peanuts and enjoy the ride. It will not eat your children, but it will assist you in preparing that new boss encounter as a 7-course dinner for your raid group.\n"] = "Welcome to Big Wigs, where the boss encounters roam. Please fasten your seatbelt, eat peanuts and enjoy the ride. It will not eat your children, but it will assist you in preparing that new boss encounter as a 7-course dinner for your raid group.\n"
L["Configure ..."] = "Настройка..."
L["Closes the interface options window and lets you configure displays for things like bars and messages.\n\nIf you want to customize more behind-the-scenes things, you can expand Big Wigs in the left tree and find the 'Customize ...' subsection."] = "Closes the interface options window and lets you configure displays for things like bars and messages.\n\nIf you want to customize more behind-the-scenes things, you can expand Big Wigs in the left tree and find the 'Customize ...' subsection."
L["Sound"] = "Звук"
L["Messages might come with a sound. Some people find it easier to listen for these after they've learned which sound goes with which message, as opposed to reading the actual messages.\n\n|cffff4411Even when off, the default raid warning sound might be played by incoming raid warnings from other players. That sound, however, is different from the sounds we use.|r"] = "Сообщения могут сопровождаться звуком. Некоторым людям легче услышать звук и опознать к какому он сообщению относиться, нежели читать сообщения.\n\n|cffff4411Даже когда отключено, по умолчанию звук объявления рейда будет сопровождать входящие объявления рейда от других игроков. Этот звук, отличаются от используемых звуков.|r"
L["Blizzard warnings"] = "Оповещения Blizzard"
L["Blizzard provides their own messages for some abilities on some encounters. In our opinion, these messages are both way too long and descriptive. We try to produce smaller, more fitting messages that do not interfere with the gameplay, and that don't tell you specifically what to do.\n\n|cffff4411When off, Blizzards warnings will not be shown in the middle of the screen, but they will still show in your chat frame.|r"] = "Blizzard provides their own messages for some abilities on some encounters. In our opinion, these messages are both way too long and descriptive. We try to produce smaller, more fitting messages that do not interfere with the gameplay, and that don't tell you specifically what to do.\n\n|cffff4411When off, Blizzards warnings will not be shown in the middle of the screen, but they will still show in your chat frame.|r"
L["Flash and shake"] = "Мигание и тряска"
L["Certain abilities are important enough to need your full attention. When these abilities affect you Big Wigs can flash and shake the screen.\n\n|cffff4411If you are playing with the nameplates turned on the shaking function will not work due to Blizzard restrictions, the screen will only flash then.|r"] = "Некоторые способности/эффекты являются достаточно важными, которые нуждаются во внимания. Когда вы попадаете под эффект таких способностей/эффектов, Big Wigs воспроизводит мигание и тряску экрана.\n\n|cffff4411Если вы играете с включенными табличками, функция тряски не будет работать в связи с ограничениями Blizzard, экран будет только мигать.|r"
L["Raid icons"] = "Иконка рейда"
L["Some encounter scripts use raid icons to mark players that are of special interest to your group. For example 'bomb'-type effects and mind control. If you turn this off, you won't mark anyone.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r"] = "Некоторые скрипты события используют иконки рейда, чтобы помечать игроков, которые представляют особый интерес для вашей группы. К примеру 'бомба'-тип эффекта и контроль разума.\n\n|cffff4411Применимо только когда вы Лидер группы/рейда!|r"
L["Whisper warnings"] = "Оповещения шопотом"
L["Send a whisper notification to fellow players about certain encounter abilities that affect them. Think 'bomb'-type effects and such.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r"] = "Отправлять коллегам уведомления шепотом об определённых способностях, которые их затрагивают.\n\n|cffff4411Применимо только когда вы Лидер группы/рейда!|r"
L["Broadcast"] = "Вывод сообщений"
L["Broadcast all messages from Big Wigs to the raid warning channel.\n\n|cffff4411Only applies if you are raid leader or in a 5-man party!|r"] = "Выводить все сообщения Big Wigs, в канал объявлений рейду.\n\n|cffff4411Применимо только когда вы Лидер рейда или в группе 5-чел!|r"
L["Raid channel"] = "Канал рейда"
L["Use the raid channel instead of raid warning for broadcasting messages."] = "Для передачи сообщений, использовать канал рейда вместо объявлений рейду."
L["Minimap icon"] = "Иконка у мини карты"
L["Toggle show/hide of the minimap icon."] = "Показать/скрыть иконку у мини-карты."
L["Configure"] = "Настройка"
L["Test"] = "Тест"
L["Reset positions"] = "Сброс позиции"
L["Options for %s."] = "Опции для %s."

L["BAR"] = "Полосы"
L["MESSAGE"] = "Сообщения"
L["SOUND"] = "Свуки"
L["ICON"] = "Иконка"
L["PROXIMITY"] = "Близость"
L["WHISPER"] = "Шепот"
L["SAY"] = "Сказать"
L["FLASHSHAKE"] = "Мигпние и тряска"
L["PING"] = "Импульс"
L["EMPHASIZE"] = "Увеличение"
L["MESSAGE_desc"] = "Большинство способностей событий сопровождаются с одним или несколькими сообщениями, которые Big Wigs будет отображать на экране. Если вы отключите эту опцию, ни одно из сообщений, прилагаемый к этой опции, если таковые будут, не бутет отображаться."
L["BAR_desc"] = "Полосы отображаются для некоторых способностей событий когда необхадимо. Если эта способность сопровождается полоской, которую вы хотите скрыть, отключите эту опцию"
L["FLASHSHAKE_desc"] = "Некоторые способности могут быть более важными, чем другие. Если вы хотите, чтобы ваш экран мигал и трясся, при использовании таких способностей, отметьте эту опцию."
L["ICON_desc"] = "Big Wigs может отмечать пострадавших от способностей иконой. Это способствует их легкому обнаружению."
L["WHISPER_desc"] = "Некоторые эффекты являются достаточно важными, Big Wigs будет отсылать предупреждение шепотом, пострадавшей персоне."
L["SAY_desc"] = "Сообщения над головой персонажей легко обнаружить. Big Wigs будут использоваться канал \"сказать\" для оповещения персонажей поблизости о эффекте на вас."
L["PING_desc"] = "Иногда местонахождение играет не малую роль, Big Wigs будет издавать импульс по миникарте, чтобы люди знали, где вы находитесь."
L["EMPHASIZE_desc"] = "Включив это, будет СУПЕР УВЕЛИЧЕНИЕ любого сообщение или полосы, связанные с способностью события. Сообщений будет больше, полосы будет мигать и имеют различные цвета, звуки будут использоваться для отсчета времени, при надвигающейся способности. В общем, вы сами всё увидите."
L["Advanced options"] = "Расширенны опции"
L["<< Back"] = "<< назад"

L["About"] = "Об Big Wigs"
L["Main Developers"] = "Hазработчики"
L["Maintainers"] = "Помощники"
L["License"] = "Лицензия"
L["Website"] = "Сайт"
L["Contact"] = "Связь"
L["See license.txt in the main Big Wigs folder."] = "Смотрите license.txt в основной папке Big Wigs."
L["irc.freenode.net in the #wowace channel"] = "irc.freenode.net в канале #wowace"
L["Thanks to the following for all their help in various fields of development"] = "Благодарим следующих лиц за их помощь в различных областях развития"


