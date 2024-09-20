local L = BigWigsAPI:NewLocale("BigWigs: Common", "koKR")
if not L then return end

-- Prototype.lua common words
L.you = "당신에게 %s"
L.you_icon = "|T13700%2$d:0|t당신에게 %1$s"
L.underyou = "당신 밑에 %s"
L.aboveyou = "당신 위에 %s"
L.other = "%s: %s"
L.onboss = "우두머리에게 %s"
L.buff_boss = "넴드에게 버프: %s"
L.buff_other = "%s 에게 버프: %s"
L.magic_buff_boss = "보스에 마법 강화 효과: %s" -- Magic buff on BOSS: SPELL_NAME
L.magic_buff_other = " %s에 마법 강화 효과: %s" -- Magic buff on NPC_NAME: SPELL_NAME
L.on = "%2$s에게 %1$s"
L.stack = "%3$s에게 %1$dx %2$s"
L.stackyou = "당신에게 %dx %s"
L.cast = "<시전: %s>"
L.casting = "%s 시전"
L.soon = "곧 %s"
L.count = "%s (%d)"
L.count_amount = "%s (%d/%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.rticon = "%s ({rt%d})"
L.near = "당신 근처에 %s"
L.on_group = "파티에 %s" -- spell on group
L.boss = "우두머리"
L.plus = "%s + %s" -- Spell 1 + Spell 2
L.extra = "%s (%s)" -- SPELL_NAME (short spell name or extra information)

L.phase = "%d단계"
L.stage = "%d단계"
L.wave = "웨이브 %d" -- e.g. "Wave 1" (Waves of adds)
L.wave_count = "웨이브 %d 의 %d" -- Wave 1 of 3 (Usually waves of adds)
L.normal = "일반 난이도"
L.heroic = "영웅 난이도"
L.mythic = "신화 난이도"
L.hard = "어려움 모드"
L.active = "활성화" -- When a boss becomes active, after speech finishes
L.ready = "준비" -- When a player is ready to do something
L.dead = "죽음" -- When a player is dead
L.general = "일반" -- General settings, i.e. things that apply to normal, heroic and mythic mode.
L.health = "체력" -- The health of an NPC
L.health_percent = "%d%% 체력" -- "10% Health" The health percentage of an NPC
L.door_open = "문 열림" -- When a door is open, usually after a speech from an NPC
L.gate_open = "문 열림" -- When a gate is open, usually after a speech from an NPC
L.threat = "위협 수준"
L.energy = "기력"

L.remaining = "%d 남음" -- 5 remaining
L.duration = "%s %s초 남음" -- Spell for 10 seconds
L.over = "%s 종료" -- Spell Over
L.removed = "%s 제거됨" -- Spell Removed
L.removed_from = "%2$s의 %1$s 제거됨" -- Spell removed from Player
L.removed_by = "%2$s|1이;가; %1$s 제거함" -- Spell removed by Player
L.removed_after = "%s %.1f초 후 제거됨" -- "Spell removed after 1.1s" (s = seconds)
L.incoming = "곧 %s" -- Spell Incoming
L.interrupted = "%s 시전 방해됨" -- Spell Interrupted
L.interrupted_by = "%s 를 %s 가 차단" -- Spell interrupted by Player
L.interruptible = "차단 가능" -- when a spell is interruptible
L.no = "%s 없음" -- No Spell
L.intermission = "사잇단계"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s 취소됨" -- Spell Cancelled
L.you_die = "당신은 죽습니다" -- You will die
L.you_die_sec = "당신은 %d 초 후 죽습니다" -- "You die in 15 sec" (sec = seconds)
L.next_ability = "다음 능력" -- We don't know what ability will be next, we only know when it will happen (showing a bar)
L.landing = "%s 착륙 중" -- "NPC_NAME is landing" Used when a flying NPC/dragon/boss is landing
L.flying_available = "비행 가능"

-- Add related
L.add_spawned = "추가 몹 생성" -- singular
L.adds_spawned = "추가 몹들 생성" -- plural
L.adds_spawned_count = "%d |4추가 몹:추가 몹들; 생성됨" -- 1 add spawned / 2 adds spawned
L.add_spawning = "추가 몹 생성 중" -- singular
L.adds_spawning = "추가 몹들 생성 중" -- plural
L.spawned = "%s 생성"
L.spawning = "%s 생성"
L.next_add = "다음 몹 추가"
L.add_killed = "추가 몹 처치 (%d/%d)"
L.add_remaining = "추가 몹 처치, %d 남음"
L.add = "추가 몹"
L.adds = "추가 몹들"
L.big_add = "큰 추가 몹" -- singular
L.big_adds = "큰 추가 몹들" -- plural
L.small_add = "작은 추가 몹" -- singular
L.small_adds = "작은 추가 몹들" -- plural

-- Mob related
L.killed = "%s 처치"
L.mob_killed = "%s 처치 (%d/%d)"
L.mob_remaining = "%s 처치, %d 남음"

-- NPCs for follower dungeons
L.garrick = "대장 개릭" -- AI paladin tank (NPC 209057)
L.garrick_short = "*개릭"
L.meredy = "메레디 헌츠웰" -- AI mage dps (NPC 209059)
L.meredy_short = "*메레디"
L.shuja = "슈자 그림액스" -- AI shaman dps (NPC 214390)
L.shuja_short = "*슈자"
L.crenna = "대지의 딸 크렌나" -- AI druid healer (NPC 209072)
L.crenna_short = "*크렌나"
L.austin = "오스틴 헉스워스" -- AI hunter dps (NPC 209065)
L.austin_short = "*오스틴"

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = "%1$s 전투 개시 - %3$d분 후 %2$s"
L.custom_start_s = "%1$s 전투 개시 - %3$d초 후 %2$s"
L.custom_end = "%s - %s"
L.custom_min = "%2$d분 후 %1$s"
L.custom_sec = "%2$d초 후 %1$s"

L.focus_only = "|cffff0000주시 대상만 경고합니다.|r "
L.trash = "일반몹"
L.affixes = "어픽스" -- Seasonal affixes for raids and mythic+ dungeons

-- Common raid marking locale
L.marker = "%s 징표 표시"
L.marker_player_desc = "%s에 영향받는 플레이어를 %s|1으로;로; 징표 표시합니다, 부공격대장 이상의 권한이 필요합니다." -- Mark players affected by 'SPELL_NAME' with SKULL_ICON
L.marker_npc_desc = "%s|1을;를; %s|1으로;로; 징표 표시합니다, 부공격대장 이상의 권한이 필요합니다." -- Mark NPC_NAME with SKULL_ICON
L.marker_npc_aura_desc = "'%s'에 영향을 받은 NPC들을 %s로 표시합니다. (부공격대장이나 공격대장 권한 필요)" -- Mark NPCs affected by 'SPELL_NAME' with SKULL_ICON

-- Ability where two players have to move close to each other
L.link = "연결"
L.link_with = "%s|1과;와; 연결됨"
L.link_with_icon = "|T13700%d:0|t%s|1과;와; 연결됨"
L.link_with_rticon = "%s와 연결됨{rt%d}"
L.link_both = "%s|1과;와; %s|1이;가; 연결됨"
L.link_both_icon = "|T13700%d:0|t%s|1과;와; |T13700%d:0|t%s|1이;가; 연결됨"
L.link_removed = "연결 사라짐"
L.link_say_option_name = "'연결됨' 반복 말하기 옵션"
L.link_say_option_desc = "일반 채팅에서 내가 누구와 연결되어 있는지 알려주는 메시지를 반복합니다."

-- Abbreviated numbers
L.amount_one = "%.2f억" -- Billions 1,000,000,000
L.amount_two = "%.1f만" -- Millions 1,000,000
L.amount_three = "%d천" -- Thousands 1,000
L.seconds = "%.1f초" -- 1.1 seconds

-- Directions
L.top = "최상단"
L.up = "상단"
L.middle = "중간"
L.down = "하단"
L.bottom = "최하"
L.left = "왼쪽"
L.right = "오른쪽"
L.north = "북쪽"
L.north_east = "북동쪽"
L.east = "동쪽"
L.south_east = "남동쪽"
L.south = "남쪽"
L.south_west = "남서쪽"
L.west = "서쪽"
L.north_west = "북서쪽"

-- Schools
L.fire = "화염"
L.frost = "냉기"
L.shadow = "암흑"
L.nature = "자연"
L.arcane = "비전"

-- Autotalk
L.autotalk = "자동 NPC 상호작용"
L.autotalk_boss_desc = "보스 전투를 시작하는 NPC 대화 옵션을 자동으로 선택합니다."
L.autotalk_generic_desc = "던전의 다음 단계로 진행하기 위해 필요한 NPC 대화 옵션을 자동으로 선택합니다."

-- Common ability name replacements
L.absorb = "흡수" -- Used for shield-like abilities that absorb damage or healing
L.heal_absorb = "치유 흡수" -- Used for shield-like abilities that absorb healing only
L.heal_absorbs = "치유 흡수" -- Plural of L.heal_absorb
L.tank_combo = "탱크 콤보" -- Used for tank swap mechanics where the boss casts a sequence of tank buster attacks
L.laser = "레이저" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.lasers = "레이저" -- Plural of L.lasers
L.beam = "광선" -- Similar to "Laser" (a beam from boss to player/boss to area) but can be used to better describe certain abilities that don't look like a Laser
L.beams = "광선" -- Plural of L.beam
L.bomb = "폭탄" -- Used for debuffs that make players explode
L.bombs = "폭탄" -- Plural of L.bomb
L.explosion = "폭발" -- When the explosion from a bomb-like ability will occur
L.fixate = "시선 고정" -- Used when a boss or add is chasing/fixated on a player
L.knockback = "넉백" -- Used when an ability knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
L.pushback = "밀림" -- Used when an ability slowly and continually pushes a player away, like winds gradually pushing you away over time
L.traps = "덫" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
L.meteor = "유성" -- This one will probably only ever be used for actual meteors
L.shield = "보호막" -- Abilities that absorb damage/healing creating a "shield" around the boss/player e.g. "Shield on boss" or "Shield remaining"
L.teleport = "순간이동" -- A boss/add/etc teleported somewhere
L.fear = "공포" -- For abilities that cause you to flee in fear
L.breath = "브레스" -- When a boss breathes fire/frost/etc on to a player or the raid e.g. a Dragon breathing fire on everyone
L.roar = "포효" -- When a boss opens their mouth to let out a loud roar, sometimes used to inflict damage on the raid
L.leap = "도약" -- When a boss leaps through the air from one location to another location, or from a location to a player, etc
L.charge = "돌진" -- When a boss select a new target and charges at it quickly, in the same way someone playing a warrior can charge at a target
L.full_energy = "기력 최대" -- When a boss reaches full/maximum energy, usually the boss will cast something big and powerful when this happens
L.weakened = "약화" -- When a boss becomes weakened and sometimes takes extra damage, usually the "hit all your cooldowns" part of the fight
L.immune = "면역" -- When a boss becomes immune to all damage and you can no longer hurt it
L.stunned = "기절함" -- When a boss becomes stunned and cannot cast abilities or move
L.pool = "바닥" -- A pool or puddle on the ground, usually something bad that you should avoid standing in
L.pools = "바닥" -- Plural of L.pool
L.totem = "토템" -- A totem, usually summoned by a boss, the same thing that shamans summon
L.totems = "토템" -- Plural of L.totem
L.portal = "차원문" -- A portal somewhere, usually leading to a different location
L.portals = "차원문" -- Plural of L.portal
L.rift = "균열" -- Can be used in a similar way as a portal e.g. "Time Rift" but can also be used as a debuff/pool underneath you that you need to run through to remove/despawn it e.g. "Dread Rift"
L.rifts = "균열" -- Plural of L.rift
L.orb = "보주" -- A ball/sphere object usually moving and you need to avoid it
L.orbs = "보주" -- Plural for L.orb
L.curse = "저주" -- Any curse-type dispellable debuff, or debuffs called "Curse of XYZ", etc.
L.curses = "저주" -- Plural of L.curse
L.disease = "질병" -- Any disease-type dispellable debuff, or debuffs called "Disease of XYZ", etc.
L.poison = "독" -- Any poison-type dispellable debuff, or debuffs called "Poison of XYZ", etc.
L.spirit = "영혼" -- Sometimes a boss will summon spirits, similar to ghosts, but not exactly, although you might have the same word for both. e.g. "Spirits of X" or "Wild Spirits"
L.spirits = "영혼" -- Plural of L.spirit
L.tornado = "뇌우" -- 'A tornado is a violently rotating column of air that is in contact with both the surface of the Earth and a cloud' - Wikipedia
L.tornadoes = "뇌우" -- Plural of L.tornado
L.frontal_cone = "전방기" -- Usually a bad Area-of-Effect ability cast by the boss in a cone/triangle/pizza shape in front of them, don't stand in front of the boss!
L.fear = "공포" -- Similar to a warlock or priest ability, when a boss casts a fear on a player or multiple players, that makes them run around out of control
L.mark = "징표" -- Short name for abilites with "Mark" in the name, for example "Mark of Death" or "Toxic Mark" or "Mark of Frost" etc.
L.marks = "징표" -- Plural of L.marks
L.mind_control = "정신 지배" -- Any kind of Mind Control ability, where a player loses control of their character
L.mind_control_short = "정신 지배" -- Short version of Mind Control, mainly for bars
L.soak = "같이 맞기" -- Abilities you have to stand in on purpose to soak the damage, like a sponge soaks water. Commonly for abilities that split damage between everyone standing in them.
L.soaks = "같이 맞기" -- Plural of L.soak
L.spell_reflection = "주문 반사" -- Any ability that reflects spells
L.parasite = "기생충" -- Any ability where a parasite is involved e.g. "Parasitic Infection", "Parasitic Growth", etc
L.rooted = "묶임" -- Any ability that roots you in place, preventing you from moving

-- Common ability name replacements A-Z
L.dodge = "피하기" -- When you need to continually run around to dodge abilities, like missiles landing on the ground under you
L.health_drain = "체력 흡수" -- Any ability that drains health from the player
L.smash = "강타" -- Short for any ability with the name "smash" in it e.g. "Darkrift Smash" or "Seismic Smash" or "Arcing Smash"
L.spike = "쐐기" -- Short for any ability with the name "spike" in it e.g. "Glacial Spike" or "Fel Spike" or "Volatile Spike"
L.spikes = "쐐기" -- Plural of L.spike
L.waves = "웨이브" -- Multiple waves of a bad ability coming from a boss, like waves in the ocean
