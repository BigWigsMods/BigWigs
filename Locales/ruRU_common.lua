local _, addonTbl = ...
local L = addonTbl.API:NewLocale("BigWigs: Common", "ruRU")
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
L.magic_buff_boss = "Магический бафф на боссе: %s" -- Magic buff on BOSS: SPELL_NAME
L.magic_buff_other = "Магический бафф на %s: %s" -- Magic buff on NPC_NAME: SPELL_NAME
L.on = "%s на %s"
L.stack = "%dx %s на %s" -- "5x SPELL_NAME on PLAYER_OR_NPC" showing how many stacks of a buff/debuff are on a player or NPC
L.stackyou = "%dx %s на ТЕБЕ" -- "5x SPELL_NAME on YOU" showing how many stacks of a buff/debuff are on you
L.stackboss = "%dx %s на БОССЕ" -- "5x SPELL_NAME on BOSS" showing how many stacks of a buff/debuff are on the boss
L.stack_gained = "Получил %dx" -- "Gained 5x" for situations where we show how many stacks of a buff were gained since last time a message showed
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
L.plus = "%s + %s" -- Способность 1 + Способность 2
L.extra = "%s (%s)" -- SPELL_NAME (short spell name or extra information)

L.phase = "Фаза %d"
L.stage = "Этап %d"
L.wave = "Волна %d" -- e.g. "Wave 1" (Waves of adds)
L.wave_count = "Волна %d из %d" -- Wave 1 of 3 (Usually waves of adds)
L.normal = "Обычный режим"
L.heroic = "Героический режим"
L.mythic = "Эпохальный режим"
L.hard = "Сложный режим"
L.active = "Активен" -- When a boss becomes active, after speech finishes
L.ready = "Готов" -- When a player is ready to do something
L.dead = "Смерть" -- When a player is dead
L.general = "Общее" -- General settings, i.e. things that apply to normal, heroic and mythic mode.
L.health = "Здоровья" -- The health of an NPC
L.health_percent = "%d%% Здоровья" -- "10% Health" The health percentage of an NPC
L.energy = "Энергия"
L.energy_percent = "%d%% Энергии" -- "80% Energy" The energy percentage of an NPC
L.door_open = "Дверь открыта" -- When a door is open, usually after a speech from an NPC
L.gate_open = "Врата открыты" -- When a gate is open, usually after a speech from an NPC
L.threat = "Угрозе"

L.remaining = "%d |4осталось:остались:осталось;" -- 5 remaining
L.duration = "%s для %s сек" -- Spell for 10 seconds
L.over = "%s завершается" -- Spell Over
L.removed = "%s снято" -- Spell Removed
L.removed_from = "%s Снято С %s" -- Spell removed from Player
L.removed_by = "%s был снят %s" -- Spell removed by Player
L.removed_after = "%s убран спустя %.1fс" -- "Spell removed after 1.1s" (s = seconds)
L.incoming = "%s на подходе" -- Spell Incoming
L.interrupted = "%s прервано" -- Spell Interrupted
L.interrupted_by = "%s прерван %s" -- Spell interrupted by Player
L.interruptible = "Прерываемое" -- when a spell is interruptible
L.no = "Нет %s" -- No Spell
L.intermission = "Перерыв"
--L.intermission_over = "Конец перерыва"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s отменено" -- Spell Cancelled
L.you_die = "Умираешь" -- You will die
L.you_die_sec = "Умрёшь через %d сек" -- "You die in 15 sec" (sec = seconds)
L.next_ability = "Следующая способность" -- We don't know what ability will be next, we only know when it will happen (showing a bar)
L.boss_landing = "%s приземляется" -- "NPC_NAME is landing" Used when a flying NPC/dragon/boss is landing
L.landing = "Приземление" -- Used when a flying NPC/dragon/boss is landing
L.flying_available = "Доступен полет"
L.bosses_too_close = "Разведи боссов" -- When 2 or more bosses are too close to each other, buffing each other with a shield, extra damage, etc. -- changed translation meaning, but intent is the same
L.keep_moving = "Двигайся" -- An ability that forces you to keep moving or you will take damage
L.stand_still = "Стой смирно" -- An ability that forces you to stand still or you will take damage
L.safe_to_stop = "Можно остановиться" -- When an ability that forces you to keep moving fades from you, allowing you to stop moving
L.safe_to_move = "Можно двигаться" -- When an ability to forces you to stand still fades from you, allowing you to move again
L.safe = "Безопасность" -- You are safe from a bad ability
L.unsafe = "Опасность" -- You are unsafe (in danger) of a bad ability

-- Add related
L.add_spawned = "АДД появился" -- singular
L.adds_spawned = "АДДЫ появились" -- plural
L.adds_spawned_count = "%d |4АДД появился:АДДа появилось:АДДов появилось;" -- 1 add spawned / 2 adds spawned
L.add_spawning = "Спаун АДДа" -- singular
L.adds_spawning = "Спаун АДДов" -- plural
--L.add_incoming = "АДД на подходе" -- singular
--L.adds_incoming = "АДДы на подходе" -- plural
L.spawned = "Появление: %s"
L.spawning = "%s появление"
L.next_add = "Следующий АДД"
L.add_killed = "АДД убит (%d/%d)"
L.add_remaining = "АДД убит, %d осталось"
L.add = "АДД"
L.adds = "АДДы"
L.big_add = "Большой АДД" -- singular
L.big_adds = "Большие АДДы" -- plural
L.small_add = "Маленький АДД" -- singular
L.small_adds = "Маленькие АДДы" -- plural
--L.eat_adds = "ЖРЕТ помощников" -- When a boss is going to eat/consume any adds remaining to empower/heal itself. Usually this is a timer. You have to kill all adds in X seconds or they will be eaten.

-- Mob related
L.killed = "%s убит"
L.mob_killed = "%s убит (%d/%d)"
L.mob_remaining = "%s убит, %d осталось"

-- NPCs for follower dungeons
L.garrick = "Капитан Гэррик" -- AI paladin tank (NPC 209057)
L.garrick_short = "*Гэррик"
L.meredy = "Мереди Крепкая Охота" -- AI mage dps (NPC 209059)
L.meredy_short = "*Мереди"
L.shuja = "Шуджа Люторез" -- AI shaman dps (NPC 214390)
L.shuja_short = "*Шуджа"
L.crenna = "Кренна Дочь Земли" -- AI druid healer (NPC 209072)
L.crenna_short = "*Кренна"
L.austin = "Остин Хаксворт" -- AI hunter dps (NPC 209065)
L.austin_short = "*Остин"
L.breka = "Воевода Брека Люторез" -- AI warrior tank (NPC 215517)
L.breka_short = "*Брека"
L.henry = "Генри Гэррик" -- AI priest healer (NPC 215011)
L.henry_short = "*Генри"

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

-- GUI boss dropdown for cast counters
-- Cast counters are the numbers you see next to spell names that keep increasing e.g. "Bad Spell (3)" <-- that number
-- This dropdown option will let you choose when that number should reset back to 1
--L.counter_reset_name = "%s каст(а)" -- SPELL_NAME cast counter
--L.counter_reset_desc = "Выберите когда сбрасывать счетчик кастов."
--L.reset_casts = "Сбрасывать каждые %d каста" -- Reset every 3 casts
--L.reset_stages = "Сбрасывать при смене этапа"
--L.reset_casts_and_stages = "Сбрасывать каждые %d каста и при смене этапа"
--L.reset_never = "Никогда не сбрасывать"

-- Common raid marking locale
L.marker = "Метка %s"
L.marker_player_desc = "Отмечать игроков, затронутых %s меткой %s, требуется быть помощником или лидером рейда." -- Mark players affected by 'SPELL_NAME' with SKULL_ICON
L.marker_npc_desc = "Отмечать %s меткой %s, требуется быть помощником или лидером рейда." -- Mark NPC_NAME with SKULL_ICON
L.marker_npc_aura_desc = "Отмечает НИП под воздействием '%s' меткой %s, требуется быть помощником или лидером рейда." -- Mark NPCs affected by 'SPELL_NAME' with SKULL_ICON
L.disabled = "Отключено"
L.none = "Нет"
L.markers = "Метки" -- Plural of marker

-- Ability where two players have to move close to each other
L.link = "Связь"
L.link_with = "Связан с %s"
L.link_with_icon = "Связан с |T13700%d:0|t%s"
L.link_with_rticon = "{rt%d}Связан с %s"
L.link_both = "%s + %s связанны"
L.link_both_icon = "|T13700%d:0|t%s + |T13700%d:0|t%s связанны"
L.link_removed = "Связь прервана"
L.link_say_option_name = "Повторять 'Связан' сообщения в чат"
L.link_say_option_desc = "Повторяет сообщения в чат с ником связанного игрока."

-- Abbreviated numbers
L.amount_one = "%dмлрд" -- Billions 1,000,000,000
L.amount_two = "%dмлн" -- Millions 1,000,000
L.amount_three = "%dт" -- Thousands 1,000
L.seconds = "%.1fс" -- 1.1 seconds

-- Directions
L.top = "Верх" -- need to make sure usage is good (1)
L.top_right = "Сверху справа"
L.top_left = "Сверху слева"
L.up = "Вверх" -- need to make sure usage is good (1)
L.middle = "Центр"
L.down = "Вниз" -- need to make sure usage is good (2)
L.bottom = "Низ" -- need to make sure usage is good (2)
L.bottom_right = "Снизу справа"
L.bottom_left = "Снизу слева"
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

-- Sizes
L.small = "Маленький" -- Male gender used. Maybe neutral ?
L.medium = "Средний"
L.large = "Большой"

-- Schools
L.fire = "Огонь"
L.frost = "Лед"
L.shadow = "Тень"
L.nature = "Природа"
L.arcane = "Тайная магия"

-- Autotalk
L.autotalk = "Автоматическое взаимодействие с НИП"
L.autotalk_boss_desc = "Автоматический выбирать вариант диалога с НИП для начала боя."
L.autotalk_generic_desc = "Автоматический выбирать вариант диалога с НИП для продвижения по подземелью."
L.autotalk_notice = "Произведено автоматическое взаидействовие с НИП %s."

-- GUI notes
--L.intermissionOnly = "Только Перерыв"
--L.stage1Only = "Только 1 этап"
--L.stage2Only = "Только 2 этап"
--L.stage3Only = "Только 3 этап"

-- GUI notes for renames
--L.generalNote = "Обычное сообщение"
--L.timerNote = "Сообщение для таймеров"
--L.castTimerNote = "Сообщение только для таймеров кастов"
--L.messageCastOverNote = "Сообщение для конца каста"
--L.messageCastStartNote = "Сообщение для начала каста"
--L.messageBeforeCastStartNote = "Сообщение перед началом каста"
--L.messageDuringCastNote = "Сообщение во время каста"
--L.messageNote = "Текст для сообщений"
--L.messageOnYouNote = "Сообщение когда способность НА ТЕБЕ"
--L.messageOnOtherNote = "Сообщение когда споробность НА ДРУГОМ персонаже"
--L.messageTauntNowNote = "Сообщение для ТАНКА затаунтить СЕЙЧАС"
--L.messageSpecificHealth = "Сообщение когда у БОССА %d%% здоровья"
--L.timerOnYouNote = "Сообщение в таймере когда способность НА ТЕБЕ"
--L.mythicOnlyNote = "Сообщение только для Эпохальной сложности"
--L.otherDifficultiesNote = "Сообщение для остальных сложностей"

-- GUI notes for debuffs
--L.debuffFailureNote = "Дебафф наложится на тебя, если не успеешь отреагировать"
--L.debuffFailureMoveFromExplosionNote = "Дебафф наложится на тебя, если не успеешь выйти из взрыва"
--L.debuffFailureInterruptNote = "Дебафф наложится на тебя если ты не успеешь кикнуть: |cFFFFFFFF%s|r" -- This debuff will apply to you if you fail to interrupt the cast of SPELL_NAME
--L.preDebuffNote = "Дебафф предшествующий основному"
--L.mainDebuffNote = "Основной дебафф применяемый к тебе"
--L.postDebuffNote = "Дебафф наложится на тебя, когда |cFFFFFFFF%s|r истечет" -- This debuff will apply to you after OTHER_DEBUFF expires
--L.debuffUnderYouNote = "Дебафф наложится на тебя если будешь стоять в луже" -- Usually when a player is standing in a pool of something bad, a debuff will apply to them
--L.debuffDotAfterCastNote = "ДОТа наложится на тебя, после того как босс докастует: |cFFFFFFFF%s|r" -- This debuff is a damage over time effect after the boss finishes casting SPELL_NAME
--L.debuffPossibleAfterCastNote = "Дебафф может наложиться на тебя, когда босс докастует: |cFFFFFFFF%s|r" -- This debuff might apply to you after the boss finishes casting SPELL_NAME
--L.debuffTankAfterCastNote = "Дебафф наложится на танка, когда босс докастует: |cFFFFFFFF%s|r" -- This debuff will apply to the tank after the boss finishes casting SPELL_NAME
--L.debuffWalkIntoObjectNote = "Дебафф наложится на тебя, если ты специально зайдешь в объект: |cFFFFFFFF%s|r" -- This debuff will apply to you if you purposely walk into the OBJECT_NAME (e.g. trap, mine, bomb)
--L.debuffHitByCastNote = "Дебафф наложится на тебя, если ты поймаешь каст: |cFFFFFFFF%s|r" -- This debuff will apply to you if you are hit by the the SPELL_NAME cast
--L.debuffAddsCast = "Дебафф на тебе от: |cFFFFFFFF%s|r" -- This debuff is applied to you by NPC_NAME

-- Common ability name replacements
L.laser = "Лазер" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.lasers = "Лазеры" -- Plural of L.lasers
L.beam = "Луч" -- Similar to "Laser" (a beam from boss to player/boss to area) but can be used to better describe certain abilities that don't look like a Laser
L.beams = "Лучи" -- Plural of L.beam
L.bomb = "Бомба" -- Used for debuffs that make players explode
L.bombs = "Бомбы" -- Plural of L.bomb
L.explosion = "Взрыв" -- When the explosion from a bomb-like ability will occur
--L.explosions = "Взрывы" -- Plural of L.explosion
L.knockback = "Отбрасывание" -- Used when an ability knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
--L.knockbacks = "Отбрасывания" -- Plural of L.knockback
L.pushback = "Отталкивание" -- Used when an ability slowly and continually pushes a player away, like winds gradually pushing you away over time
L.traps = "Ловушки" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
L.meteor = "Метеор" -- This one will probably only ever be used for actual meteors
L.teleport = "Телепортация" -- A boss/add/etc teleported somewhere
L.breath = "Дыхание" -- When a boss breathes fire/frost/etc on to a player or the raid e.g. a Dragon breathing fire on everyone
L.roar = "Рык" -- When a boss opens their mouth to let out a loud roar, sometimes used to inflict damage on the raid
L.leap = "Прыжок" -- When a boss leaps through the air from one location to another location, or from a location to a player, etc
L.charge = "Рывок" -- When a boss select a new target and charges at it quickly, in the same way someone playing a warrior can charge at a target
L.full_energy = "Макс. энергия" -- When a boss reaches full/maximum energy, usually the boss will cast something big and powerful when this happens
L.weakened = "Ослабленный" -- When a boss becomes weakened and sometimes takes extra damage, usually the "hit all your cooldowns" part of the fight
L.immune = "Невосприимчивость" -- When a boss becomes immune to all damage and you can no longer hurt it
L.stunned = "Оглушение" -- When a boss becomes stunned and cannot cast abilities or move
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
L.spirit = "Дух" -- Sometimes a boss will summon spirits, similar to ghosts, but not exactly, although you might have the same word for both. e.g. "Spirits of X" or "Wild Spirits"
L.spirits = "Духи" -- Plural of L.spirit
L.tornado = "Торнадо" -- 'A tornado is a violently rotating column of air that is in contact with both the surface of the Earth and a cloud' - Wikipedia
L.tornadoes = "Торнадо" -- Plural of L.tornado
L.mark = "Знак" -- Short name for abilites with "Mark" in the name, for example "Mark of Death" or "Toxic Mark" or "Mark of Frost" etc.
L.marks = "Знаки" -- Plural of L.marks
L.mind_control = "Контроль над разумом" -- Any kind of Mind Control ability, where a player loses control of their character
L.mind_control_short = "Контр.Разум." -- Short version of Mind Control, mainly for bars
L.spell_reflection = "Отражение заклинаний" -- Any ability that reflects spells
L.rooted = "Обездвиживание" -- Any ability that roots you in place, preventing you from moving

-- Common ability name replacements A-Z
--L.arrow = "Стрела" -- Any type of ability that looks like an arrow, or has "arrow" in the name. Like an archer's arrow.
L.arrows = "Стрелы" -- Plural of L.arrow
L.ball = "Шар" -- A ball, like a football, basketball, etc
L.balls = "Шары" -- Plural of L.ball
L.blind = "Ослепление" -- Any ability that blinds or disorientates you. Usually an ability a boss casts and you need to turn away from the boss or it will blind you.
--L.bouncing_ball = "Прыгающий Шар" -- A ball, but it bounces, usually you need to prevent it touching the ground so it bounces to a different location
--L.bouncing_balls = "Прыгающие Шары" -- Plural of L.bouncing_ball
L.chakram = "Шакрам" -- Short for any ability with the name "Chakram" in it e.g. "Wind Chakram" (1258152) or "Solar Chakram" (186046)
L.dodge = "Избегай" -- When you need to continually run around to dodge abilities, like missiles landing on the ground under you
L.enrage = "Исступление" -- Any enrage buff that can be removed by players using abilities like Soothe (Druid), Tranquilizing Shot (Hunter) and Shiv (Rogue)
L.fear = "Страх" -- Similar to a warlock or priest ability, when a boss casts a fear on a player or multiple players, that makes them run around out of control
L.fixate = "Фиксация" -- Used when a boss or add is chasing/fixated on a player
L.fixates = "Фиксации" -- Plural of L.fixate
--L.frontal = "Фронтал" -- Usually a bad Area-of-Effect ability cast by the boss in front of them
L.frontal_cone = "Фронтал клив" -- Usually a bad Area-of-Effect ability cast by the boss in a cone/triangle/pizza shape in front of them, don't stand in front of the boss!
--L.grip = "Притяжка" -- When a boss grapples a player towards them. We use "Grip" because of the Death Knight ability "Death Grip" (49576) but you can use "Grapple" if it makes more sense
--L.grips = "Притяжки" -- Plural of L.grip
L.group_damage = "Пати Урон" -- Any ability that causes damage to every player in the 5 player group
L.health_drain = "Потеря здоровья" -- Any ability that drains health from the player
L.madness = "Безумие" -- Any ability that contains the word "Madness" in it e.g. "Rift Madness" (1264756) or "Burning Madness" (307013)
L.miasma = "Миазмы" -- Any ability that contains the word "Miasma" in it e.g. "Consuming Miasma" (1257087) or "Black Miasma" (1275059)
--L.missile = "Стрела" -- Short for any ability with the name "Missile" in it e.g. "Fey Missile" (188046) or "Water Missile" (68250)
--L.missiles = "Стрелы" -- Plural of L.missile
L.parasite = "Паразит" -- Any ability where a parasite is involved e.g. "Parasitic Infection", "Parasitic Growth", etc
L.parasites = "Паразиты" -- Plural of L.parasite
L.pull_in = "Притяжка" -- An ability that pulls you in towards the boss against your will
L.quills = "Перья" -- Short for any ability with the name "Quills" in it e.g. "Searing Quills" (159382) or "Infused Quills" (1242260)
L.raid_damage = "Рейд Урон" -- Any ability that causes damage to every player in the raid
L.silence = "Безмолвие" -- Any ability that silences a player, preventing their spells being cast
L.smash = "Удар" -- Short for any ability with the name "smash" in it e.g. "Darkrift Smash" or "Seismic Smash" or "Arcing Smash"
L.soak = "Соак" -- Abilities you have to stand in on purpose to soak the damage, like a sponge soaks water. Commonly for abilities that split damage between everyone standing in them.
L.soaks = "Соаки" -- Plural of L.soak
L.spike = "Шип" -- Short for any ability with the name "spike" in it e.g. "Glacial Spike" or "Fel Spike" or "Volatile Spike"
L.spikes = "Шипы" -- Plural of L.spike
L.spread = "Спредай" -- An ability that forces you to spread out away from other players, or you might damage them
L.stomp = "Топот" -- Short for any ability with the name "Stomp" in it e.g. "Cryostomp" (1261847) or "Powerful Stomp" (296691)
L.tentacle = "Щупальце" -- Used for bosses that summon tentacles
L.tentacles = "Щупальца" -- Plural of L.tentacle
--L.vines = "Лозы" -- Short for any ability with the name "Vines" in it e.g. "Festering Vines" (1222088) or "Choking Vines" (238593)
L.waves = "Волны" -- Multiple waves of a bad ability coming from a boss, like waves in the ocean -- technically speaking "waves" is "Волны" but current tl is a very common name
L.whelp = "Дракончик" -- Short for Whelpling, a baby dragonkin (Dragon Whelp)
L.whelps = "Дракончики" -- Plural of L.whelp

-- Absorb / Shield related spell renames
L.absorb = "Поглoщ." -- Used for shield-like abilities that absorb damage or healing
L.heal_absorb = "Поглощение лечения" -- Used for shield-like abilities that absorb healing only
L.heal_absorbs = "Поглощения лечения" -- Plural of L.heal_absorb
--L.break_shield = "Пробей ЩИТ" -- When you need to do something to break an absorb shield on the boss.
--L.break_shields = "Пробей ЩИТЫ" -- Plural of L.break_shield
L.shield = "Щит" -- Abilities that absorb damage/healing creating a "shield" around the boss/player e.g. "Shield on boss" or "Shield remaining"

-- Debuff-related spell renames
--L.debuff = "Дебафф"
--L.debuffs = "Дебаффы" -- Plural of L.debuff
--L.fire_debuffs = "Огненные лучи"

-- Dispel-related spell renames
L.curse = "Проклятие" -- Any curse-type dispellable debuff, or debuffs called "Curse of XYZ", etc.
L.curses = "Проклятия" -- Plural of L.curse
L.disease = "Болезнь" -- Any disease-type dispellable debuff, or debuffs called "Disease of XYZ", etc.
--L.dispel = "Рассеиваимый" -- General term for any debuff that is dispellable
L.dispels = "Рассеиваемые" -- Plural of L.dispel
--L.dispel_boss = "Рассеивание на Босса" -- When the boss gains a buff (magic or enrage) that you need to dispel
L.poison = "Яд" -- Any poison-type dispellable debuff, or debuffs called "Poison of XYZ", etc.
--L.bleed = "Кровотечение" -- Any bleed-type debuff
--L.bleeds = "Кровотечения" -- Plural of L.bleed

-- Clearing-related spell renames (when you get a buff that allows you to clear/cleanse/remove other objects in the world, like pools on the ground, traps, or bombs)
--L.clear_bombs = "Чистка Бомб"
--L.clear_pools = "Чистка Луж"

-- Interrupt-related spell renames
--L.interrupts = "Прерывания" -- General term used when a player needs to interrupt a spell being cast
L.kick = "Прерывание" -- General term used when a player needs to interrupt a spell being cast, named after spell "Kick" (1766) from the Rogue class
--L.kicks = "Прерывания" -- Plural of L.kick

-- Tank-related spell renames
L.tank_bomb = "Бомба на танке" -- Similar to L.bomb but only applies to tanks
L.tank_combo = "Танковское комбо" -- Used for tank swap mechanics where the boss casts a sequence of tank buster attacks
L.tank_debuff = "Танк Дебафф" -- Used for debuffs that only apply to tanks, usually an indicator that you need to taunt
L.tank_frontal = "Танк Фронтал" -- Similar to L.frontal_cone but only applies to tanks
--L.tank_hit = "Танк Удар" -- An attack that will only target the tank, usually a spell that does a lot of heavy damage to the tank
--L.tank_knockback = "Танк Отталкивание" -- Similar to L.knockback but only applies to tanks"
L.tank_soak = "Танк Соак" -- Similar to L.soak but only applies to tanks
--L.tank_grip = "Танк Притяжка" -- When a boss grapples the tank towards them. We use "Grip" because of the Death Knight ability "Death Grip" (49576) but you can use "Grapple" if it makes more sense
