local L = BigWigsAPI:NewLocale("BigWigs: Common", "ruRU")
if not L then return end

-- Prototype.lua common words
L.you = "%s на ТЕБЕ"
L.you_icon = "%s на |T13700%d:0|tТЕБЕ"
L.underyou = "%s под ТОБОЙ"
L.other = "%s: %s"
L.onboss = "%s на БОССЕ"
L.buff_boss = "Бафф на БОССЕ: %s"
L.buff_other = "Бафф на %s: %s"
L.on = "%s на %s"
L.stack = "%dx %s на %s"
L.stackyou = "%dx %s на ТЕБЕ"
L.cast = "<Чтение %s>"
L.casting = "Чтение %s"
L.soon = "%s скоро"
L.count = "%s (%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.rticon = "%s ({rt%d})"
L.near = "%s возле ТЕБЯ"
L.on_group = "%s на ГРУППЕ" -- spell on group

L.phase = "Фаза %d"
L.stage = "Этап %d"
L.normal = "Обычный режим"
L.heroic = "Героический режим"
L.mythic = "Эпохальный режим"
L.active = "Активен" -- When a boss becomes active, after speech finishes
L.general = "Общее" -- General settings, i.e. things that apply to normal, heroic and mythic mode.

L.duration = "%s для %s сек" -- Spell for 10 seconds
L.over = "%s завершается" -- Spell Over
L.removed = "%s снято" -- Spell Removed
L.removed_from = "%s Снято С %s" -- Spell removed from Player
L.removed_by = "%s был снят %s" -- Spell removed by Player
L.incoming = "%s на подходе" -- Spell Incoming
L.interrupted = "%s прервано" -- Spell Interrupted
L.interrupted_by = "%s прерван %s" -- Spell interrupted by Player
L.no = "Нет %s" -- No Spell
L.intermission = "Перерыв"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s отменено" -- Spell Cancelled

-- Add related
L.add_spawned = "Помощник появился"
L.spawned = "Появление: %s"
L.spawning = "%s появление"
L.next_add = "Следующий помощник"
L.add_killed = "Помощник убит (%d/%d)"
L.add_remaining = "Помощник убит, %d осталось"
L.add = "Помощник"
L.adds = "Помощники"
L.big_add = "Большой помощник" -- singular
L.big_adds = "Большие помощники" -- plural
L.small_add = "Маленький помощник" -- singular
L.small_adds = "Маленькие помощники" -- plural

-- Mob related
L.mob_killed = "%s убит (%d/%d)"
L.mob_remaining = "%s убит, %d осталось"

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = "%s вступает в бой - %s через %d мин"
L.custom_start_s = "%s вступает в бой - %s через %d сек"
L.custom_end = "%s входит в %s"
L.custom_min = "%s через %d мин"
L.custom_sec = "%s через %d сек"

L.focus_only = "|cffff0000Оповещения только для фокуса.|r "
L.trash = "Трэш"

-- Common raid marking locale
L.marker = "Метка %s"
L.marker_player_desc = "Отмечать игроков, затронутых %s меткой %s, требуется быть помощником или лидером рейда."
L.marker_npc_desc = "Отмечать %s меткой %s, требуется быть помощником или лидером рейда."

-- Ability where two players have to move close to each other
L.link = "Связь"
L.link_with = "Связан с %s"
L.link_with_icon = "Связан с |T13700%d:0|t%s"
L.link_short = "Связь: %s"
L.link_both = "%s связан с %s"
L.link_removed = "Связь прервана"

-- Abbreviated numbers
L.amount_one = "%dмлрд" -- Billions 1,000,000,000
L.amount_two = "%dмлн" -- Millions 1,000,000
L.amount_three = "%dт" -- Thousands 1,000
L.seconds = "%.1fс" -- 1.1 seconds

-- Common ability name replacements
L.tank_combo = "Танковское комбо" -- Used for tank swap mechanics where the boss casts a sequence of tank buster attacks
L.laser = "Лазер" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.beam = "Луч" -- Similar to "Laser" (a beam from boss to player/boss to area) but can be used to better describe certain abilities that don't look like a Laser
L.beams = "Лучи" -- Plural of L.beam
L.bomb = "Бомба" -- Used for debuffs that make players explode
L.bombs = "Бомбы" -- Plural of L.bomb
L.explosion = "Взрыв" -- When the explosion from a bomb-like ability will occur
L.fixate = "Фиксация" -- Used when a boss or add is chasing/fixated on a player
L.knockback = "Отбрасывание" -- Used when an ability knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
L.traps = "Ловушки" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
L.meteor = "Метеор" -- This one will probably only ever be used for actual meteors
L.shield = "Щит" -- Abilities that absorb damage/healing creating a "shield" around the boss/player e.g. "Shield on boss" or "Shield remaining"
L.teleport = "Телепортация" -- A boss/add/etc teleported somewhere
L.fear = "Страх" -- For abilities that cause you to flee in fear
