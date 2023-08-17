local L = BigWigsAPI:NewLocale("BigWigs: Common", "koKR")
if not L then return end

-- Prototype.lua common words
L.you = "당신에게 %s"
L.you_icon = "%s on |T13700%d:0|tYOU"
L.underyou = "당신 밑에 %s"
L.other = "%s: %s"
L.onboss = "우두머리에게 %s"
L.buff_boss = "넴드에게 버프: %s"
L.buff_other = "%s 에게 버프: %s"
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
--L.boss = "BOSS"

L.phase = "%d단계"
L.stage = "%d단계"
L.normal = "일반 난이도"
L.heroic = "영웅 난이도"
L.mythic = "신화 난이도"
L.hard = "어려움 모드"
L.active = "활성화" -- When a boss becomes active, after speech finishes
L.general = "일반" -- General settings, i.e. things that apply to normal, heroic and mythic mode.
L.absorb = "흡수" -- Used for shield-like abilities that absorb damage or healing

L.duration = "%s %s초 남음" -- Spell for 10 seconds
L.over = "%s 종료" -- Spell Over
L.removed = "%s 제거됨" -- Spell Removed
L.removed_from = "%2$s의 %1$s 제거됨" -- Spell removed from Player
L.removed_by = "%2$s|1이;가; %1$s 제거함" -- Spell removed by Player
L.removed_after = "%s %.1f초 후 제거됨" -- "Spell removed after 1.1s" (s = seconds)
L.incoming = "곧 %s" -- Spell Incoming
L.interrupted = "%s 시전 방해됨" -- Spell Interrupted
L.interrupted_by = "%s 를 %s 가 차단" -- Spell interrupted by Player
L.no = "%s 없음" -- No Spell
L.intermission = "사잇단계"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s 취소됨" -- Spell Cancelled

-- Add related
L.add_spawned = "추가 몹 생성"
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
L.mob_killed = "%s 처치 (%d/%d)"
L.mob_remaining = "%s 처치, %d 남음"

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
L.marker_player_desc = "%s에 영향받는 플레이어를 %s|1으로;로; 징표 표시합니다, 부공격대장 이상의 권한이 필요합니다."
L.marker_npc_desc = "%s|1을;를; %s|1으로;로; 징표 표시합니다, 부공격대장 이상의 권한이 필요합니다."

-- Ability where two players have to move close to each other
L.link = "연결"
L.link_with = "%s|1과;와; 연결됨"
L.link_with_icon = "|T13700%d:0|t%s|1과;와; 연결됨"
L.link_short = "연결됨: %s"
L.link_both = "%s|1과;와; %s|1이;가; 연결됨"
L.link_removed = "연결 사라짐"

-- Abbreviated numbers
L.amount_one = "%.2f억" -- Billions 1,000,000,000
L.amount_two = "%.1f만" -- Millions 1,000,000
L.amount_three = "%d천" -- Thousands 1,000
L.seconds = "%.1f초" -- 1.1 seconds

-- Directions
--L.top = "Top"
--L.up = "Up"
--L.middle = "Middle"
--L.down = "Down"
--L.bottom = "Bottom"
--L.left = "Left"
--L.right = "Right"
L.north = "북쪽"
--L.north_east = "North-East"
--L.east = "East"
--L.south_east = "South-East"
L.south = "남쪽"
--L.south_west = "South-West"
--L.west = "West"
--L.north_west = "North-West"

-- Common ability name replacements
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
L.full_energy = "기력 최대" -- When a boss reaches full/maximum energy, usually the boss will cast something big and powerful when this happens
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
