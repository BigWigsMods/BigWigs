local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs", "ruRU")

if not L then return end

-- Core.lua
L["%s has been defeated"] = "%s побеждён"     -- "<boss> has been defeated"
L["%s have been defeated"] = "%s побеждены"    -- "<bosses> have been defeated"

L["Bosses"] = "Боссы"
L["Options for bosses in %s."] = "Опции для боссов в %s." -- "Options for bosses in <zone>"
L["Options for %s (r%d)."] = "Опции для %s (r%d)."     -- "Options for <boss> (<revision>)"
L["Plugins"] = "Плагины"
L["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = "Плагины - это основная особенность Big Wigs,они показывают сообщения, время в полосках и другие важные моменты при битве с боссами."
L["Extras"] = "Дополнения"
L["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = "Дополнительные настройки для рейдов без которых Big Wigs не будет должным образом работать"
L["Active"] = "Активен"
L["Activate or deactivate this module."] = "Активация или деактивация модуля"
L["Reboot"] = "Перезагрузка"
L["Reboot this module."] = "Перезагрузка данного модуля"
L["Options"] = "Опции"
L["Minimap icon"] = "Иконка у мини-карты"
L["Toggle show/hide of the minimap icon."] = "Показать/скрыть иконку у мини-карты."
L["Advanced"] = "Расширенные настройки"
L["You shouldn't really need to touch these options, but if you want to tweak them then you're welcome to do so!"] = "Вам не нужно трогать данную опцию, но если вы хотите подстроить, тогда вперёд!"

L["Toggles whether or not the boss module should warn about %s."] = "Включение/отключение вывода оповещений об %s."
L.bosskill = "Смерть босса"
L.bosskill_desc = "Объявлять о смерти босса."
L.enrage = "Исступление"
L.enrage_desc = "Предупреждать, когда босс входит в состояние исступления."
L.berserk = "Берсерк"
L.berserk_desc = "Предупреждать, когда босс входит в состояние берсерк."

L["Load"] = "Загрузить"
L["Load All"] = "Загрузить все"
L["Load all %s modules."] = "Загрузить все модули %s."

-- L.already_registered = "|cffff0000Внимание:|r |cff00ff00%s|r (|cffffff00%d|r) уже существует как модуль Big Wigs,но чтото снова пытается его зарегистрировать (ревизия |cffffff00%d|r). Это обычно означает, что у вас две копии этого модуля в папке модификации, возможно из-за ошибки обновления программой обновления модификаций. Мы рекомендуем вам удалить все папки Big Wigs , а затем установить его заново с нуля."

-- Loader / Options.lua
L["You are running an official release of Big Wigs 3.0 (revision %d)"] = "Вы используете оффициальный выпуск Big Wigs 3.0 (ревизии %d)"
L["You are running an ALPHA RELEASE of Big Wigs 3.0 (revision %d)"] = "Вы используете ALPHA ВЫПУСК Big Wigs 3.0 (ревизии %d)"
L["You are running a source checkout of Big Wigs 3.0 directly from the repository."] = "Вы используете отладочный Big Wigs 3.0 прямо из репозитория."
L["There is a new release of Big Wigs available. You can visit curse.com, wowinterface.com, wowace.com or use the Curse Updater to get the new release."] = "Доступен новый выпуск Big Wigs. Для получения нового выпуска почетите curse.com, wowinterface.com, wowace.com или воспользуйтесь Curse Updater."

L["|cff00ff00Module running|r"] = "|cff00ff00Модуль запущен|r"
L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them."] = "|cffeda55fЩёлкните|r, чтобы сбросить все запущенные модули. |cffeda55fAlt+Левый Клик|r - чтобы отключить их."
L["Active boss modules:"] = "Активные модули боссов:"
L["All running modules have been reset."] = "Все запущенные модули сброшены."
L["Menu"] = "Меню"
L["Menu options."] = "Меню опций."

L["Big Wigs is currently disabled."] = "В данный момент Big Wigs отключен."
L["|cffeda55fClick|r to enable."] = "|cffeda55fЩёлкните|r чтобы включить."
L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."] = "|cffeda55fЩёлкните|r, чтобы сбросить все запущенные модули. |cffeda55fAlt-Клик|r - чтобы отключить их. |cffeda55fCtrl-Alt-Клик|r - чтобы отключить Big Wigs полностью."
L["All running modules have been disabled."] = "Все запущенные модули были отключены."

-- Options.lua
L["Customize ..."] = "Настройки ..."
L["Welcome to Big Wigs, where the boss encounters roam. Please fasten your seatbelt, eat peanuts and enjoy the ride. It will not eat your children, but it will assist you in preparing that new boss encounter as a 7-course dinner for your raid group.\n"] = "Welcome to Big Wigs, where the boss encounters roam. Please fasten your seatbelt, eat peanuts and enjoy the ride. It will not eat your children, but it will assist you in preparing that new boss encounter as a 7-course dinner for your raid group.\n"
L["Configure ..."] = "Настройка..."
L["Closes the interface options window and lets you configure displays for things like bars and messages.\n\nIf you want to customize more behind-the-scenes things, you can expand Big Wigs in the left tree and find the 'Customize ...' subsection."] = "Closes the interface options window and lets you configure displays for things like bars and messages.\n\nIf you want to customize more behind-the-scenes things, you can expand Big Wigs in the left tree and find the 'Customize ...' subsection."
L["Sound"] = "Звук"
L["Messages might come with a sound. Some people find it easier to listen for these after they've learned which sound goes with which message, as opposed to reading the actual messages.\n\n|cffff4411Even when off, the default raid warning sound might be played by incoming raid warnings from other players. That sound, however, is different from the sounds we use.|r"] = "Messages might come with a sound. Some people find it easier to listen for these after they've learned which sound goes with which message, as opposed to reading the actual messages.\n\n|cffff4411Even when off, the default raid warning sound might be played by incoming raid warnings from other players. That sound, however, is different from the sounds we use.|r"
L["Blizzard warnings"] = "Оповещения Blizzard"
L["Blizzard provides their own messages for some abilities on some encounters. In our opinion, these messages are both way too long and descriptive. We try to produce smaller, more fitting messages that do not interfere with the gameplay, and that don't tell you specifically what to do.\n\n|cffff4411When off, Blizzards warnings will not be shown in the middle of the screen, but they will still show in your chat frame.|r"] = "Blizzard provides their own messages for some abilities on some encounters. In our opinion, these messages are both way too long and descriptive. We try to produce smaller, more fitting messages that do not interfere with the gameplay, and that don't tell you specifically what to do.\n\n|cffff4411When off, Blizzards warnings will not be shown in the middle of the screen, but they will still show in your chat frame.|r"
L["Raid icons"] = "Иконка рейда"
L["Some encounter scripts use raid icons to mark players that are of special interest to your group. For example 'bomb'-type effects and mind control. If you turn this off, you won't mark anyone.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r"] = "Некоторые скрипты события используют иконки рейда, чтобы помечать игроков, которые представляют особый интерес для вашей группы. К примеру 'бомба'-тип эффекта и контроль разума.\n\n|cffff4411Применимо только когда вы Лидер группы/рейда!|r"
L["Whisper warnings"] = "Оповещения шопотом"
L["Send a whisper notification to fellow players about certain encounter abilities that affect them. Think 'bomb'-type effects and such.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r"] = "Отправлять коллегам уведомления шепотом об определённых способностях, которые их затрагивают.\n\n|cffff4411Применимо только когда вы Лидер группы/рейда!|r"
L["Broadcast"] = "Вывод сообщений"
L["Broadcast all messages from Big Wigs to the raid warning channel.\n\n|cffff4411Only applies if you are raid leader or in a 5-man party!|r"] = "Выводить все сообщения Big Wigs, в канал объявлений рейду.\n\n|cffff4411Применимо только когда вы Лидер рейда или в группе 5-чел!|r"
L["Raid channel"] = "Канал рейда"
L["Use the raid channel instead of raid warning for broadcasting messages."] = "Для передачи сообщений, использовать канал рейда вместо объявлений рейду."
L["|cffccccccMooses don't appreciate being prodded with long pointy sticks.\nContact us on irc.freenode.net/#wowace. [Ammo] and vhaarr can service all your needs.|r\n|cff44ff44"] = "|cffccccccMooses don't appreciate being prodded with long pointy sticks.\nContact us on irc.freenode.net/#wowace. [Ammo] and vhaarr can service all your needs.|r\n|cff44ff44"
L["Configure"] = "Настройка"
L["Test"] = "Тест"
L["Reset positions"] = "Сброс позиции"
L["Options for %s."] = "Опции для %s."
