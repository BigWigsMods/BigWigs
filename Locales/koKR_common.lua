local _, addonTbl = ...
local L = addonTbl.API:NewLocale("BigWigs: Common", "koKR")
if not L then return end

-- Prototype.lua common words
L.you = "당신에게 %s"
L.you_icon = "|T13700%2$d:0|t당신에게 %1$s"
L.underyou = "당신 발밑에 %s"
L.aboveyou = "당신 위에 %s"
L.other = "%s: %s"
L.onboss = "보스: %s"
L.buff_boss = "보스 버프: %s"
L.buff_other = "%s 버프: %s"
L.magic_buff_boss = "보스 마법 버프: %s" -- Magic buff on BOSS: SPELL_NAME
L.magic_buff_other = "%s 마법 버프: %s" -- Magic buff on NPC_NAME: SPELL_NAME
L.on = "%s: %s"
L.stack = "%3$s: %1$d중첩 %2$s" -- "5x SPELL_NAME on PLAYER_OR_NPC" showing how many stacks of a buff/debuff are on a player or NPC
L.stackyou = "당신: %d중첩 %s" -- "5x SPELL_NAME on YOU" showing how many stacks of a buff/debuff are on you
L.stackboss = "보스: %d중첩 %s" -- "5x SPELL_NAME on BOSS" showing how many stacks of a buff/debuff are on the boss
L.stack_gained = "%d중첩 추가" -- "Gained 5x" for situations where we show how many stacks of a buff were gained since last time a message showed
L.cast = "<시전: %s>"
L.casting = "%s 시전 중"
L.soon = "곧 %s"
L.count = "%s (%d)"
L.count_amount = "%s (%d/%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.rticon = "%s ({rt%d})"
L.near = "당신 근처에 %s"
L.on_group = "파티에 %s" -- spell on group
L.boss = "보스"
L.plus = "%s + %s" -- Spell 1 + Spell 2
L.extra = "%s (%s)" -- SPELL_NAME (short spell name or extra information)

L.phase = "%d단계"
L.stage = "%d단계"
L.wave = "%d웨이브" -- e.g. "Wave 1" (Waves of adds)
L.wave_count = "%d/%d웨이브" -- Wave 1 of 3 (Usually waves of adds)
L.normal = "일반 난이도"
L.heroic = "영웅 난이도"
L.mythic = "신화 난이도"
L.hard = "어려움 모드"
L.active = "활성화" -- When a boss becomes active, after speech finishes
L.ready = "준비 완료" -- When a player is ready to do something
L.dead = "사망" -- When a player is dead
L.general = "일반" -- General settings, i.e. things that apply to normal, heroic and mythic mode.
L.health = "생명력" -- The health of an NPC
L.health_percent = "%d%% 생명력" -- "10% Health" The health percentage of an NPC
L.energy = "기력"
L.energy_percent = "%d%% 기력" -- "80% Energy" The energy percentage of an NPC
L.door_open = "문 열림" -- When a door is open, usually after a speech from an NPC
L.gate_open = "문 열림" -- When a gate is open, usually after a speech from an NPC
L.threat = "위협 수준"

L.remaining = "%d 남음" -- 5 remaining
L.duration = "%s %s초 남음" -- Spell for 10 seconds
L.over = "%s 종료" -- Spell Over
L.removed = "%s 제거됨" -- Spell Removed
L.removed_from = "%2$s의 %1$s 제거됨" -- Spell removed from Player
L.removed_by = "%2$s|1이;가; %1$s 제거함" -- Spell removed by Player
L.removed_after = "%s %.1f초 후 제거됨" -- "Spell removed after 1.1s" (s = seconds)
L.incoming = "곧 %s" -- Spell Incoming
L.interrupted = "%s 시전 방해됨" -- Spell Interrupted
L.interrupted_by = "%2$s|1이;가; %1$s 차단" -- Spell interrupted by Player
L.interruptible = "차단 가능" -- when a spell is interruptible
L.no = "%s 없음" -- No Spell
L.intermission = "사잇단계"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s 취소됨" -- Spell Cancelled
L.you_die = "당신은 죽습니다" -- You will die
L.you_die_sec = "당신은 %d초 후 죽습니다" -- "You die in 15 sec" (sec = seconds)
L.next_ability = "다음 능력" -- We don't know what ability will be next, we only know when it will happen (showing a bar)
L.boss_landing = "%s 착륙 중" -- "NPC_NAME is landing" Used when a flying NPC/dragon/boss is landing
L.landing = "착륙" -- Used when a flying NPC/dragon/boss is landing
L.flying_available = "비행 가능"
L.bosses_too_close = "보스가 너무 가까움" -- When 2 or more bosses are too close to each other, buffing each other with a shield, extra damage, etc.
L.keep_moving = "계속 이동" -- An ability that forces you to keep moving or you will take damage
L.stand_still = "정지" -- An ability that forces you to stand still or you will take damage
L.safe_to_stop = "정지 가능" -- When an ability that forces you to keep moving fades from you, allowing you to stop moving
L.safe_to_move = "이동 가능" -- When an ability to forces you to stand still fades from you, allowing you to move again
L.safe = "안전" -- You are safe from a bad ability
L.unsafe = "위험" -- You are unsafe (in danger) of a bad ability

-- Add related
L.add_spawned = "추가 몹 생성" -- singular
L.adds_spawned = "추가 몹 생성" -- plural
L.adds_spawned_count = "%d 추가 몹 생성됨" -- 1 add spawned / 2 adds spawned
L.add_spawning = "추가 몹 생성 중" -- singular
L.adds_spawning = "추가 몹 생성 중" -- plural
L.spawned = "%s 생성됨"
L.spawning = "%s 생성중"
L.next_add = "다음 추가 몹"
L.add_killed = "추가 몹 처치 (%d/%d)"
L.add_remaining = "추가 몹 처치, %d 남음"
L.add = "추가 몹"
L.adds = "추가 몹"
L.big_add = "대형 추가 몹" -- singular
L.big_adds = "대형 추가 몹" -- plural
L.small_add = "소형 추가 몹" -- singular
L.small_adds = "소형 추가 몹" -- plural

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
L.breka = "장군 브레카 그림액스" -- AI warrior tank (NPC 215517)
L.breka_short = "*브레카"
L.henry = "헨리 개릭" -- AI priest healer (NPC 215011)
L.henry_short = "*헨리"

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = "%1$s 전투 시작 - %3$d분 후 %2$s"
L.custom_start_s = "%1$s 전투 시작 - %3$d초 후 %2$s"
L.custom_end = "%s - %s"
L.custom_min = "%2$d분 후 %1$s"
L.custom_sec = "%2$d초 후 %1$s"

L.focus_only = "|cffff0000주시 대상만 경고합니다.|r "
L.trash = "일반 몹"
L.affixes = "어픽스" -- Seasonal affixes for raids and mythic+ dungeons

-- Common raid marking locale
L.marker = "%s 징표 설정"
L.marker_player_desc = "'%s' 영향을 받는 플레이어를 %s|1으로;로; 징표 설정합니다. (부공대장 이상 권한 필요)" -- Mark players affected by 'SPELL_NAME' with SKULL_ICON
L.marker_npc_desc = "%s|1을;를; %s|1으로;로; 징표 설정합니다. (부공대장 이상 권한 필요)" -- Mark NPC_NAME with SKULL_ICON
L.marker_npc_aura_desc = "'%s' 영향을 받은 NPC를 %s|1으로;로; 표시합니다. (부공대장 이상 권한 필요)" -- Mark NPCs affected by 'SPELL_NAME' with SKULL_ICON
L.disabled = "비활성화"
L.none = "없음"
L.markers = "징표" -- Plural of marker

-- Ability where two players have to move close to each other
L.link = "연결"
L.link_with = "%s|1과;와; 연결됨"
L.link_with_icon = "|T13700%d:0|t%s|1과;와; 연결됨"
L.link_with_rticon = "%s와 연결됨{rt%d}"
L.link_both = "%s|1과;와; %s|1이;가; 연결됨"
L.link_both_icon = "|T13700%d:0|t%s|1과;와; |T13700%d:0|t%s|1이;가; 연결됨"
L.link_removed = "연결 해제됨"
L.link_say_option_name = "'연결' 알림 반복 설정"
L.link_say_option_desc = "연결된 대상을 일반 채팅으로 반복 알립니다."

-- Abbreviated numbers
L.amount_one = "%.2f억" -- Billions 1,000,000,000
L.amount_two = "%.1f만" -- Millions 1,000,000
L.amount_three = "%d천" -- Thousands 1,000
L.seconds = "%.1f초" -- 1.1 seconds

-- Directions
L.top = "상단"
L.top_right = "우측 상단"
L.top_left = "좌측 상단"
L.up = "위쪽"
L.middle = "중앙"
L.down = "아래쪽"
L.bottom = "하단"
L.bottom_right = "우측 하단"
L.bottom_left = "좌측 하단"
L.left = "좌측"
L.right = "우측"
L.north = "북"
L.north_east = "북동"
L.east = "동"
L.south_east = "남동"
L.south = "남"
L.south_west = "남서"
L.west = "서"
L.north_west = "북서"

-- Sizes
L.small = "소형"
L.medium = "중형"
L.large = "대형"

-- Schools
L.fire = "화염"
L.frost = "냉기"
L.shadow = "암흑"
L.nature = "자연"
L.arcane = "비전"

-- Autotalk
L.autotalk = "NPC 자동 상호작용"
L.autotalk_boss_desc = "보스 전투 시작 NPC 대화를 자동 선택합니다."
L.autotalk_generic_desc = "던전 다음 단계 진행에 필요한 NPC 대화를 자동 선택합니다."
L.autotalk_notice = "NPC %s와 자동으로 상호 작용합니다."

-- Common ability name replacements
L.absorb = "흡수" -- Used for shield-like abilities that absorb damage or healing
L.heal_absorb = "치유 흡수" -- Used for shield-like abilities that absorb healing only
L.heal_absorbs = "치유 흡수" -- Plural of L.heal_absorb
L.laser = "레이저" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.lasers = "레이저" -- Plural of L.lasers
L.beam = "광선" -- Similar to "Laser" (a beam from boss to player/boss to area) but can be used to better describe certain abilities that don't look like a Laser
L.beams = "광선" -- Plural of L.beam
L.bomb = "폭탄" -- Used for debuffs that make players explode
L.bombs = "폭탄" -- Plural of L.bomb
L.explosion = "폭발" -- When the explosion from a bomb-like ability will occur
L.knockback = "넉백" -- Used when an ability knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
L.pushback = "밀림" -- Used when an ability slowly and continually pushes a player away, like winds gradually pushing you away over time
L.traps = "덫" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
L.meteor = "유성" -- This one will probably only ever be used for actual meteors
L.shield = "보호막" -- Abilities that absorb damage/healing creating a "shield" around the boss/player e.g. "Shield on boss" or "Shield remaining"
L.teleport = "순간이동" -- A boss/add/etc teleported somewhere
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
L.mark = "징표" -- Short name for abilites with "Mark" in the name, for example "Mark of Death" or "Toxic Mark" or "Mark of Frost" etc.
L.marks = "징표" -- Plural of L.marks
L.mind_control = "정신 지배" -- Any kind of Mind Control ability, where a player loses control of their character
L.mind_control_short = "정신 지배" -- Short version of Mind Control, mainly for bars
L.spell_reflection = "주문 반사" -- Any ability that reflects spells
L.rooted = "묶임" -- Any ability that roots you in place, preventing you from moving

-- Common ability name replacements A-Z
L.ball = "공" -- A ball, like a football, basketball, etc
L.balls = "공" -- Plural of L.ball
L.blind = "실명" -- Any ability that blinds or disorientates you. Usually an ability a boss casts and you need to turn away from the boss or it will blind you.
L.dodge = "피하기" -- When you need to continually run around to dodge abilities, like missiles landing on the ground under you
L.enrage = "격노" -- Any enrage buff that can be removed by players using abilities like Soothe (Druid), Tranquilizing Shot (Hunter) and Shiv (Rogue)
L.fear = "공포" -- Similar to a warlock or priest ability, when a boss casts a fear on a player or multiple players, that makes them run around out of control
L.fixate = "시선 고정" -- Used when a boss or add is chasing/fixated on a player
L.fixates = "시선 고정" -- Plural of L.fixate
L.group_damage = "파티 피해" -- Any ability that causes damage to every player in the 5 player group
L.health_drain = "생명력 흡수" -- Any ability that drains health from the player
L.parasite = "기생충" -- Any ability where a parasite is involved e.g. "Parasitic Infection", "Parasitic Growth", etc
L.parasites = "기생충" -- Plural of L.parasite
L.pull_in = "끌어당김" -- An ability that pulls you in towards the boss against your will
L.raid_damage = "공격대 피해" -- Any ability that causes damage to every player in the raid
L.smash = "강타" -- Short for any ability with the name "smash" in it e.g. "Darkrift Smash" or "Seismic Smash" or "Arcing Smash"
L.soak = "맞아주기" -- Abilities you have to stand in on purpose to soak the damage, like a sponge soaks water. Commonly for abilities that split damage between everyone standing in them.
L.soaks = "맞아주기" -- Plural of L.soak
L.spike = "가시" -- Short for any ability with the name "spike" in it e.g. "Glacial Spike" or "Fel Spike" or "Volatile Spike"
L.spikes = "가시" -- Plural of L.spike
L.spread = "산개" -- An ability that forces you to spread out away from other players, or you might damage them
L.tank_bomb = "탱커 폭탄" -- Similar to L.bomb but only applies to tanks
L.tank_combo = "탱커 연계기" -- Used for tank swap mechanics where the boss casts a sequence of tank buster attacks
L.tank_debuff = "탱커 디버프" -- Used for debuffs that only apply to tanks, usually an indicator that you need to taunt
L.tank_frontal = "탱커 정면기" -- Similar to L.frontal_cone but only applies to tanks
L.tank_soak = "탱커 맞아주기" -- Similar to L.soak but only applies to tanks
L.tentacle = "촉수" -- Used for bosses that summon tentacles
L.tentacles = "촉수" -- Plural of L.tentacle
L.waves = "웨이브" -- Multiple waves of a bad ability coming from a boss, like waves in the ocean
L.whelp = "새끼용" -- Short for Whelpling, a baby dragonkin (Dragon Whelp)
L.whelps = "새끼용" -- Plural of L.whelp
