local L = BigWigsAPI:NewLocale("BigWigs: Common", "ruRU")
if not L then return end

L.add = "Помощник"
L.add_killed = "Помощник убит (%d/%d)"
L.add_remaining = "Помощник убит, %d осталось"
L.adds = "Помощники"
L.add_spawned = "Помощник появился"
L.big_add = "Большой помощник"
L.cast = "<Чтение %s>"
L.casting = "Чтение %s"
L.count = "%s (%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.custom_end = "%s входит в %s"
L.custom_min = "%s через %d мин"
L.custom_sec = "%s через %d сек"
L.custom_start = "%s вступает в бой - %s через %d мин"
L.custom_start_s = "%s вступает в бой - %s через %d сек"
L.duration = "%s для %s сек"
L.focus_only = "|cffff0000Оповещения только для фокуса.|r "
L.general = "Общее" -- General settings, i.e. things that apply to normal, heroic and mythic mode.
L.heroic = "Героический режим"
L.incoming = "%s на подходе"
L.intermission = "Перерыв"
L.interrupted = "%s прервано"
L.interrupted_by = "%s прерван %s" -- spell interrupted by player
L.mob_killed = "%s убит (%d/%d)"
L.mob_remaining = "%s убит, %d осталось"
L.mythic = "Эпохальный режим"
L.near = "%s возле ТЕБЯ"
L.next_add = "Следующий помощник"
L.no = "Нет %s"
L.normal = "Обычный режим"
L.on = "%s на %s"
L.onboss = "%s на БОССЕ"
L.buff_boss = "Бафф на БОССЕ: %s"
L.buff_other = "Бафф на %s: %s"
L.other = "%s: %s"
L.over = "%s завершается"
--L.percent = "%d%% - %s" -- 20% - spell
L.phase = "Фаза %d"
L.removed = "%s снято"
L.removed_from = "%s Снято С %s"
L.removed_by = "%s был снят %s" -- spell removed by player
L.small_adds = "Маленькие помощники"
L.soon = "%s скоро"
L.spawned = "Появление: %s"
L.spawning = "%s появление"
L.stack = "%dx %s на %s"
L.stackyou = "%dx %s на ТЕБЕ"
L.stage = "Этап %d"
L.trash = "Трэш"
L.underyou = "%s под ТОБОЙ"
L.you = "%s на ТЕБЕ"
L.you_icon = "%s на |T13700%d:0|tТЕБЕ"
L.on_group = "%s на ГРУППЕ" -- spell on group

L.active = "Активен" -- When a boss becomes active, after speech finishes

-- Common raid marking locale
L.marker = "Метка %s"
L.marker_player_desc = "Отмечать игроков, затронутых %s меткой %s, требуется быть помощником или лидером рейда."
L.marker_npc_desc = "Отмечать %s меткой %s, требуется быть помощником или лидером рейда."

-- Ability where two players have to move close to each other
L.link = "Связь"
L.link_with = "Связан с %s"
L.link_short = "Связь: %s"
L.link_both = "%s связан с %s"
L.link_removed = "Связь прервана"

-- Abbreviated numbers
L.amount_one = "%dмлрд" -- Billions 1,000,000,000
L.amount_two = "%dмлн" -- Millions 1,000,000
L.amount_three = "%dт" -- Thousands 1,000
L.seconds = "%.1fс" -- 1.1 seconds

-- Common ability name replacements
L.laser = "Лазер" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.bomb = "Бомба" -- Used for debuffs that make players explode
L.fixate = "Сосредоточение внимания" -- Used when a boss or add is chasing/fixated on a player
