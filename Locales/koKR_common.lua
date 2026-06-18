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
L.intermission_over = "사잇단계 종료"
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
L.add_incoming = "곧 추가 몹" -- singular
L.adds_incoming = "곧 추가 몹" -- plural
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
L.eat_adds = "추가 몹 흡수" -- When a boss is going to eat/consume any adds remaining to empower/heal itself. Usually this is a timer. You have to kill all adds in X seconds or they will be eaten.

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

-- GUI boss dropdown for cast counters
-- Cast counters are the numbers you see next to spell names that keep increasing e.g. "Bad Spell (3)" <-- that number
-- This dropdown option will let you choose when that number should reset back to 1
L.counter_reset_name = "%s번 시전 카운터" -- SPELL_NAME cast counter
L.counter_reset_desc = "카운터를 초기화할 시점을 선택하세요."
L.reset_casts = "%d번 시전마다 초기화" -- Reset every 3 casts
L.reset_stages = "단계 변경 시 초기화"
L.reset_casts_and_stages = "%d번 시전 및 단계 변경 시 초기화"
L.reset_never = "절대 초기화 안 함"

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

-- GUI notes
L.intermissionOnly = "사잇단계 전용" -- A note to explain that a specific ability only happens during the intermission stage of a boss fight
L.stage1Only = "1단계 전용" -- A note to explain that a specific ability only happens during stage 1 of a boss fight
L.stage2Only = "2단계 전용"
L.stage3Only = "3단계 전용"

-- GUI notes for renames
L.generalNote = "일반적으로 사용될 텍스트"
L.timerNote = "이 텍스트는 타이머에 사용됨"
L.castTimerNote = "시전 타이머에만 사용될 텍스트"
L.messageCastOverNote = "이 텍스트는 시전이 끝났을 때 메시지를 표시하는 데 사용됨"
L.messageCastStartNote = "이 텍스트는 시전이 시작될 때 메시지를 표시하는 데 사용됨"
L.messageBeforeCastStartNote = "이 텍스트는 시전이 시작되기 전에 메시지를 표시하는 데 사용됨"
L.messageDuringCastNote = "이 텍스트는 시전 중에 메시지를 표시하는 데 사용됩니다."
L.messageNote = "이 텍스트는 메시지에 사용됨"
L.messageOnYouNote = "이 능력이 본인에게 적용되었을 때 표시되는 메시지"
--L.messageOnOtherNote = "The message shown when this ability is on other people"
--L.messageTauntNowNote = "The message shown when you're a tank and you need to taunt"
L.messageSpecificHealth = "보스의 체력이 %d%%일 때 표시되는 메시지"
L.timerOnYouNote = "이 능력이 본인에게 적용되었을 때 타이머에 표시되는 텍스트"
L.mythicOnlyNote = "이 텍스트는 신화 난이도에서만 사용됨"
L.otherDifficultiesNote = "이 텍스트는 다른 모든 난이도에서 사용됨"

-- GUI notes for debuffs
L.debuffFailureNote = "실패할 경우 이 디버프가 적용됨"
L.debuffFailureMoveFromExplosionNote = "폭발 지점에서 벗어나지 못하면 이 디버프가 적용됨"
L.debuffFailureInterruptNote = "|cFFFFFFFF%s|r 시전을 방해하는 데 실패하면 이 디버프가 적용됨" -- This debuff will apply to you if you fail to interrupt the cast of SPELL_NAME
L.preDebuffNote = "이것은 주요 디버프가 적용되기 전의 사전 디버프"
L.mainDebuffNote = "이것은 당신에게 적용되는 주요 디버프"
L.postDebuffNote = "|cFFFFFFFF%s|r 효과가 종료되면 이 디버프가 적용됨" -- This debuff will apply to you after OTHER_DEBUFF expires
L.debuffUnderYouNote = "위험한 위치에 서 있으면 이 디버프가 적용됨" -- Usually when a player is standing in a pool of something bad, a debuff will apply to them
L.debuffDotAfterCastNote = "이 디버프는 보스가 |cFFFFFFFF%s|r 시전을 완료한 후 지속 피해를 주는 효과" -- This debuff is a damage over time effect after the boss finishes casting SPELL_NAME
L.debuffPossibleAfterCastNote = "이 디버프는 보스가 |cFFFFFFFF%s|r 시전을 마친 후에 적용될 수 있음" -- This debuff might apply to you after the boss finishes casting SPELL_NAME
L.debuffTankAfterCastNote = "보스가 |cFFFFFFFF%s|r 시전을 완료하면 탱커에게 이 디버프가 적용됩" -- This debuff will apply to the tank after the boss finishes casting SPELL_NAME
L.debuffWalkIntoObjectNote = "|cFFFFFFFF%s|r 범위 안으로 의도적으로 걸어 들어갈 때 이 디버프가 적용됨" -- This debuff will apply to you if you purposely walk into the OBJECT_NAME (e.g. trap, mine, bomb)
L.debuffHitByCastNote = "|cFFFFFFFF%s|r 주문 시전에 맞으면 이 디버프가 적용됩니다" -- This debuff will apply to you if you are hit by the the SPELL_NAME cast
L.debuffAddsCast = "이 디버프는 |cFFFFFFFF%s|r 의해 적용됨" -- This debuff is applied to you by NPC_NAME

-- Common ability name replacements
L.laser = "레이저" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.lasers = "레이저" -- Plural of L.lasers
L.beam = "광선" -- Similar to "Laser" (a beam from boss to player/boss to area) but can be used to better describe certain abilities that don't look like a Laser
L.beams = "광선" -- Plural of L.beam
L.bomb = "폭탄" -- Used for debuffs that make players explode
L.bombs = "폭탄" -- Plural of L.bomb
L.explosion = "폭발" -- When the explosion from a bomb-like ability will occur
L.explosions = "폭발" -- Plural of L.explosion
L.knockback = "넉백" -- Used when an ability knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
L.knockbacks = "넉백" -- Plural of L.knockback
L.pushback = "밀림" -- Used when an ability slowly and continually pushes a player away, like winds gradually pushing you away over time
L.traps = "덫" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
L.meteor = "유성" -- This one will probably only ever be used for actual meteors
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
L.spirit = "영혼" -- Sometimes a boss will summon spirits, similar to ghosts, but not exactly, although you might have the same word for both. e.g. "Spirits of X" or "Wild Spirits"
L.spirits = "영혼" -- Plural of L.spirit
L.tornado = "뇌우" -- 'A tornado is a violently rotating column of air that is in contact with both the surface of the Earth and a cloud' - Wikipedia
L.tornadoes = "뇌우" -- Plural of L.tornado
L.mark = "징표" -- Short name for abilites with "Mark" in the name, for example "Mark of Death" or "Toxic Mark" or "Mark of Frost" etc.
L.marks = "징표" -- Plural of L.marks
L.mind_control = "정신 지배" -- Any kind of Mind Control ability, where a player loses control of their character
L.mind_control_short = "정신 지배" -- Short version of Mind Control, mainly for bars
L.spell_reflection = "주문 반사" -- Any ability that reflects spells
L.rooted = "묶임" -- Any ability that roots you in place, preventing you from moving

-- Common ability name replacements A-Z
L.arrow = "화살" -- Any type of ability that looks like an arrow, or has "arrow" in the name. Like an archer's arrow.
L.arrows = "화살" -- Plural of L.arrow
L.ball = "공" -- A ball, like a football, basketball, etc
L.balls = "공" -- Plural of L.ball
L.blind = "실명" -- Any ability that blinds or disorientates you. Usually an ability a boss casts and you need to turn away from the boss or it will blind you.
L.bouncing_ball = "튕기는 공" -- A ball, but it bounces, usually you need to prevent it touching the ground so it bounces to a different location
L.bouncing_balls = "튕기는 공" -- Plural of L.bouncing_ball
L.chakram = "차크람" -- Short for any ability with the name "Chakram" in it e.g. "Wind Chakram" (1258152) or "Solar Chakram" (186046)
L.dodge = "피하기" -- When you need to continually run around to dodge abilities, like missiles landing on the ground under you
L.enrage = "격노" -- Any enrage buff that can be removed by players using abilities like Soothe (Druid), Tranquilizing Shot (Hunter) and Shiv (Rogue)
L.fear = "공포" -- Similar to a warlock or priest ability, when a boss casts a fear on a player or multiple players, that makes them run around out of control
L.fixate = "시선 고정" -- Used when a boss or add is chasing/fixated on a player
L.fixates = "시선 고정" -- Plural of L.fixate
L.frontal = "전방기" -- Usually a bad Area-of-Effect ability cast by the boss in front of them
L.frontal_cone = "전방기" -- Usually a bad Area-of-Effect ability cast by the boss in a cone/triangle/pizza shape in front of them, don't stand in front of the boss!
L.grip = "당기기" -- When a boss grapples a player towards them. We use "Grip" because of the Death Knight ability "Death Grip" (49576) but you can use "Grapple" if it makes more sense
L.grips = "당기기" -- Plural of L.grip
L.group_damage = "파티 피해" -- Any ability that causes damage to every player in the 5 player group
L.health_drain = "생명력 흡수" -- Any ability that drains health from the player
L.madness = "광기" -- Any ability that contains the word "Madness" in it e.g. "Rift Madness" (1264756) or "Burning Madness" (307013)
L.miasma = "독기" -- Any ability that contains the word "Miasma" in it e.g. "Consuming Miasma" (1257087) or "Black Miasma" (1275059)
L.missile = "탄막" -- Short for any ability with the name "Missile" in it e.g. "Fey Missile" (188046) or "Water Missile" (68250)
L.missiles = "탄막" -- Plural of L.missile
L.parasite = "기생충" -- Any ability where a parasite is involved e.g. "Parasitic Infection", "Parasitic Growth", etc
L.parasites = "기생충" -- Plural of L.parasite
L.pull_in = "끌어당김" -- An ability that pulls you in towards the boss against your will
L.quills = "깃털" -- Short for any ability with the name "Quills" in it e.g. "Searing Quills" (159382) or "Infused Quills" (1242260)
L.raid_damage = "공격대 피해" -- Any ability that causes damage to every player in the raid
L.silence = "침묵" -- Any ability that silences a player, preventing their spells being cast
L.smash = "강타" -- Short for any ability with the name "smash" in it e.g. "Darkrift Smash" or "Seismic Smash" or "Arcing Smash"
L.soak = "맞아주기" -- Abilities you have to stand in on purpose to soak the damage, like a sponge soaks water. Commonly for abilities that split damage between everyone standing in them.
L.soaks = "맞아주기" -- Plural of L.soak
L.spike = "가시" -- Short for any ability with the name "spike" in it e.g. "Glacial Spike" or "Fel Spike" or "Volatile Spike"
L.spikes = "가시" -- Plural of L.spike
L.spread = "산개" -- An ability that forces you to spread out away from other players, or you might damage them
L.stomp = "발구르기" -- Short for any ability with the name "Stomp" in it e.g. "Cryostomp" (1261847) or "Powerful Stomp" (296691)
L.tentacle = "촉수" -- Used for bosses that summon tentacles
L.tentacles = "촉수" -- Plural of L.tentacle
L.vines = "덩굴" -- Short for any ability with the name "Vines" in it e.g. "Festering Vines" (1222088) or "Choking Vines" (238593)
L.waves = "웨이브" -- Multiple waves of a bad ability coming from a boss, like waves in the ocean
L.whelp = "새끼용" -- Short for Whelpling, a baby dragonkin (Dragon Whelp)
L.whelps = "새끼용" -- Plural of L.whelp

-- Absorb / Shield related spell renames
L.absorb = "흡수" -- Used for shield-like abilities that absorb damage or healing
L.heal_absorb = "치유 흡수" -- Used for shield-like abilities that absorb healing only
L.heal_absorbs = "치유 흡수" -- Plural of L.heal_absorb
L.break_shield = "보호막 파괴" -- When you need to do something to break an absorb shield on the boss.
L.break_shields = "보호막 파괴" -- Plural of L.break_shield
L.shield = "보호막" -- Abilities that absorb damage/healing creating a "shield" around the boss/player e.g. "Shield on boss" or "Shield remaining"

-- Debuff-related spell renames
L.debuff = "디버프"
L.debuffs = "디버프" -- Plural of L.debuff
L.fire_debuffs = "화염 디버프"

-- Dispel-related spell renames
L.curse = "저주" -- Any curse-type dispellable debuff, or debuffs called "Curse of XYZ", etc.
L.curses = "저주" -- Plural of L.curse
L.disease = "질병" -- Any disease-type dispellable debuff, or debuffs called "Disease of XYZ", etc.
L.dispel = "해제" -- General term for any debuff that is dispellable
L.dispels = "해제" -- Plural of L.dispel
L.dispel_boss = "보스 해제" -- When the boss gains a buff (magic or enrage) that you need to dispel
L.poison = "독" -- Any poison-type dispellable debuff, or debuffs called "Poison of XYZ", etc.
L.bleed = "출혈" -- Any bleed-type debuff
L.bleeds = "출혈" -- Plural of L.bleed

-- Clearing-related spell renames (when you get a buff that allows you to clear/cleanse/remove other objects in the world, like pools on the ground, traps, or bombs)
L.clear_bombs = "폭탄 제거"
L.clear_pools = "바닥 제거"

-- Interrupt-related spell renames
L.interrupts = "차단" -- General term used when a player needs to interrupt a spell being cast
L.kick = "발차기" -- General term used when a player needs to interrupt a spell being cast, named after spell "Kick" (1766) from the Rogue class
L.kicks = "차단" -- Plural of L.kick

-- Tank-related spell renames
L.tank_bomb = "탱커 폭탄" -- Similar to L.bomb but only applies to tanks
L.tank_combo = "탱커 연계기" -- Used for tank swap mechanics where the boss casts a sequence of tank buster attacks
L.tank_debuff = "탱커 디버프" -- Used for debuffs that only apply to tanks, usually an indicator that you need to taunt
L.tank_frontal = "탱커 전방기" -- Similar to L.frontal_cone but only applies to tanks
L.tank_hit = "탱커 피해" -- An attack that will only target the tank, usually a spell that does a lot of heavy damage to the tank
L.tank_knockback = "탱커 넉백" -- Similar to L.knockback but only applies to tanks"
L.tank_soak = "탱커 맞아주기" -- Similar to L.soak but only applies to tanks
L.tank_grip = "탱커 당기기" -- When a boss grapples the tank towards them. We use "Grip" because of the Death Knight ability "Death Grip" (49576) but you can use "Grapple" if it makes more sense
