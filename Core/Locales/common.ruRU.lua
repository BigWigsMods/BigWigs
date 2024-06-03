local L = BigWigsAPI:NewLocale("BigWigs: Common", "ruRU")
if not L then return end

-- Prototype.lua common words
L.you = "%s на ТЕБЕ"
L.you_icon = "%s на |T13700%d:0|tТЕБЕ"
L.underyou = "%s под ТОБОЙ"
L.aboveyou = "%s над ТОБОЙ"
L.other = "%s: %s"
L.onboss = "%s на БОССЕ"
L.buff_boss = "Бафф на БОССЕ: %s"
L.buff_other = "Бафф на %s: %s"
--L.magic_buff_boss = "Magic buff on BOSS: %s" -- Magic buff on BOSS: SPELL_NAME
--L.magic_buff_other = "Magic buff on %s: %s" -- Magic buff on NPC_NAME: SPELL_NAME
L.on = "%s на %s"
L.stack = "%dx %s на %s"
L.stackyou = "%dx %s на ТЕБЕ"
L.cast = "<Чтение %s>"
L.casting = "Чтение %s"
L.soon = "%s скоро"
L.count = "%s (%d)"
L.count_amount = "%s (%d/%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.rticon = "%s ({rt%d})"
L.near = "%s возле ТЕБЯ"
L.on_group = "%s на ГРУППЕ" -- spell on group
L.boss = "БОСС"
L.plus = "%s + %s" -- Spell 1 + Spell 2
L.extra = "%s (%s)" -- SPELL_NAME (short spell name or extra information)

L.phase = "Фаза %d"
L.stage = "Этап %d"
--L.wave = "Wave %d" -- e.g. "Wave 1" (Waves of adds)
--L.wave_count = "Wave %d of %d" -- Wave 1 of 3 (Usually waves of adds)
L.normal = "Обычный режим"
L.heroic = "Героический режим"
L.mythic = "Эпохальный режим"
L.hard = "Сложный режим"
L.active = "Активен" -- When a boss becomes active, after speech finishes
L.ready = "Готов" -- When a player is ready to do something
L.dead = "Смерть" -- When a player is dead
L.general = "Общее" -- General settings, i.e. things that apply to normal, heroic and mythic mode.
--L.health = "Health" -- The health of an NPC
--L.health_percent = "%d%% Health" -- "10% Health" The health percentage of an NPC
L.door_open = "Дверь открыта" -- When a door is open, usually after a speech from an NPC
L.gate_open = "Врата открыты" -- When a gate is open, usually after a speech from an NPC

L.duration = "%s для %s сек" -- Spell for 10 seconds
L.over = "%s завершается" -- Spell Over
L.removed = "%s снято" -- Spell Removed
L.removed_from = "%s Снято С %s" -- Spell removed from Player
L.removed_by = "%s был снят %s" -- Spell removed by Player
L.removed_after = "%s убран спустя %.1fс" -- "Spell removed after 1.1s" (s = seconds)
L.incoming = "%s на подходе" -- Spell Incoming
L.interrupted = "%s прервано" -- Spell Interrupted
L.interrupted_by = "%s прерван %s" -- Spell interrupted by Player
--L.interruptible = "Interruptible" -- when a spell is interruptible
L.no = "Нет %s" -- No Spell
L.intermission = "Перерыв"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s отменено" -- Spell Cancelled
L.you_die = "Умираешь" -- You will die
L.you_die_sec = "Умрёшь через %d сек" -- "You die in 15 sec" (sec = seconds)
--L.next_ability = "Next ability" -- We don't know what ability will be next, we only know when it will happen (showing a bar)

-- Add related
L.add_spawned = "Помощник появился"
L.adds_spawned = "Помощники появились"
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
L.killed = "%s убит"
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
L.affixes = "Аффикс" -- Seasonal affixes for raids and mythic+ dungeons

-- Common raid marking locale
L.marker = "Метка %s"
L.marker_player_desc = "Отмечать игроков, затронутых %s меткой %s, требуется быть помощником или лидером рейда." -- Mark players affected by 'SPELL_NAME' with SKULL_ICON
L.marker_npc_desc = "Отмечать %s меткой %s, требуется быть помощником или лидером рейда." -- Mark NPC_NAME with SKULL_ICON
--L.marker_npc_aura_desc = "Mark NPCs affected by '%s' with %s, requires promoted or leader." -- Mark NPCs affected by 'SPELL_NAME' with SKULL_ICON

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

-- Directions
L.top = "Верх" -- need to make sure usage is good (1)
L.up = "Вверх" -- need to make sure usage is good (1)
L.middle = "Центр"
L.down = "Вниз" -- need to make sure usage is good (2)
L.bottom = "Низ" -- need to make sure usage is good (2)
L.left = "Лево"
L.right = "Право"
L.north = "Север"
L.north_east = "Северо-Восток"
L.east = "Восток"
L.south_east = "Юго-Восток"
L.south = "Юг"
L.south_west = "Юго-Запад"
L.west = "Запад"
L.north_west = "Северо-Запад"

-- Schools
L.fire = "Огонь"
L.frost = "Лед"
L.shadow = "Тень"
L.nature = "Природа"
L.arcane = "Тайная магия"

-- Common ability name replacements
L.absorb = "Поглoщ." -- Used for shield-like abilities that absorb damage or healing
L.heal_absorb = "Поглощение лечения" -- Used for shield-like abilities that absorb healing only
L.heal_absorbs = "Поглощения лечения" -- Plural of L.heal_absorb
L.tank_combo = "Танковское комбо" -- Used for tank swap mechanics where the boss casts a sequence of tank buster attacks
L.laser = "Лазер" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.lasers = "Лазеры" -- Plural of L.lasers
L.beam = "Луч" -- Similar to "Laser" (a beam from boss to player/boss to area) but can be used to better describe certain abilities that don't look like a Laser
L.beams = "Лучи" -- Plural of L.beam
L.bomb = "Бомба" -- Used for debuffs that make players explode
L.bombs = "Бомбы" -- Plural of L.bomb
L.explosion = "Взрыв" -- When the explosion from a bomb-like ability will occur
L.fixate = "Фиксация" -- Used when a boss or add is chasing/fixated on a player
L.knockback = "Отбрасывание" -- Used when an ability knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
L.pushback = "Отталкивание" -- Used when an ability slowly and continually pushes a player away, like winds gradually pushing you away over time
L.traps = "Ловушки" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
L.meteor = "Метеор" -- This one will probably only ever be used for actual meteors
L.shield = "Щит" -- Abilities that absorb damage/healing creating a "shield" around the boss/player e.g. "Shield on boss" or "Shield remaining"
L.teleport = "Телепортация" -- A boss/add/etc teleported somewhere
L.fear = "Страх" -- For abilities that cause you to flee in fear
L.breath = "Дыхание" -- When a boss breathes fire/frost/etc on to a player or the raid e.g. a Dragon breathing fire on everyone
L.roar = "Рык" -- When a boss opens their mouth to let out a loud roar, sometimes used to inflict damage on the raid
L.leap = "Прыжок" -- When a boss leaps through the air from one location to another location, or from a location to a player, etc
L.charge = "Рывок" -- When a boss select a new target and charges at it quickly, in the same way someone playing a warrior can charge at a target
L.full_energy = "Макс. энергя" -- When a boss reaches full/maximum energy, usually the boss will cast something big and powerful when this happens
L.weakened = "Ослабленный" -- When a boss becomes weakened and sometimes takes extra damage, usually the "hit all your cooldowns" part of the fight
L.immune = "Невосприимчивость" -- When a boss becomes immune to all damage and you can no longer hurt it
L.pool = "Лужа" -- A pool or puddle on the ground, usually something bad that you should avoid standing in
L.pools = "Лужи" -- Plural of L.pool
L.totem = "Тотем" -- A totem, usually summoned by a boss, the same thing that shamans summon
L.totems = "Тотемы" -- Plural of L.totem
L.portal = "Портал" -- A portal somewhere, usually leading to a different location
L.portals = "Порталы" -- Plural of L.portal
L.rift = "Разлом" -- Can be used in a similar way as a portal e.g. "Time Rift" but can also be used as a debuff/pool underneath you that you need to run through to remove/despawn it e.g. "Dread Rift"
L.rifts = "Разломы" -- Plural of L.rift
L.orb = "Сфера" -- A ball/sphere object usually moving and you need to avoid it
L.orbs = "Сферы" -- Plural for L.orb
L.curse = "Проклятие" -- Any curse-type dispellable debuff, or debuffs called "Curse of XYZ", etc.
L.curses = "Проклятия" -- Plural of L.curse
L.disease = "Болезнь" -- Any disease-type dispellable debuff, or debuffs called "Disease of XYZ", etc.
L.poison = "Яд" -- Any poison-type dispellable debuff, or debuffs called "Poison of XYZ", etc.
L.spirit = "Дух" -- Sometimes a boss will summon spirits, similar to ghosts, but not exactly, although you might have the same word for both. e.g. "Spirits of X" or "Wild Spirits"
L.spirits = "Духи" -- Plural of L.spirit
L.tornado = "Торнадо" -- 'A tornado is a violently rotating column of air that is in contact with both the surface of the Earth and a cloud' - Wikipedia
L.tornadoes = "Торнадо" -- Plural of L.tornado
L.frontal_cone = "Фронтал клив" -- Usually a bad Area-of-Effect ability cast by the boss in a cone/triangle/pizza shape in front of them, don't stand in front of the boss!
L.fear = "Страх" -- Similar to a warlock or priest ability, when a boss casts a fear on a player or multiple players, that makes them run around out of control
L.mark = "Знак" -- Short name for abilites with "Mark" in the name, for example "Mark of Death" or "Toxic Mark" or "Mark of Frost" etc.
L.marks = "Знаки" -- Plural of L.marks
L.mind_control = "Контроль над разумом" -- Any kind of Mind Control ability, where a player loses control of their character
L.mind_control_short = "КР" -- Short version of Mind Control, mainly for bars
L.soak = "Сока" -- Abilities you have to stand in on purpose to soak the damage, like a sponge soaks water. Commonly for abilities that split damage between everyone standing in them.
L.soaks = "Соки" -- Plural of L.soak
L.spell_reflection = "Отражение заклинаний" -- Any ability that reflects spells
L.parasite = "Паразит" -- Any ability where a parasite is involved e.g. "Parasitic Infection", "Parasitic Growth", etc
L.rooted = "Обездвиживание" -- Any ability that roots you in place, preventing you from moving
