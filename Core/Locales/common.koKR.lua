local L = BigWigsAPI:NewLocale("BigWigs: Common", "koKR")
if not L then return end

-- Prototype.lua common words
L.you = "당신에게 %s"
L.you_icon = "%s on |T13700%d:0|tYOU"
L.underyou = "당신 밑에 %s"
L.other = "%s: %s"
L.onboss = "우두머리에게 %s"
L.on = "%2$s에게 %1$s"
L.buff_boss = "넴드에게 버프: %s"
L.buff_other = "%s 에게 버프: %s"
L.stack = "%3$s에게 %1$dx %2$s"
L.stackyou = "당신에게 %dx %s"
L.cast = "<시전: %s>"
L.casting = "%s 시전"
L.soon = "곧 %s"
L.count = "%s (%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.near = "당신 근처에 %s"
L.on_group = "파티에 %s" -- spell on group

L.phase = "%d단계"
L.stage = "%d단계"
L.normal = "일반 난이도"
L.heroic = "영웅 난이도"
L.mythic = "신화 난이도"
L.active = "활성화" -- When a boss becomes active, after speech finishes
L.general = "일반" -- General settings, i.e. things that apply to normal, heroic and mythic mode.

L.duration = "%s %s초 남음"
L.over = "%s 종료"
L.removed = "%s 제거됨"
L.removed_from = "%2$s의 %1$s 제거됨"
L.removed_by = "%2$s|1이;가; %1$s 제거함" -- spell removed by player
L.incoming = "곧 %s"
L.interrupted = "%s 시전 방해됨"
L.interrupted_by = "%s 를 %s 가 차단!" -- spell interrupted by player
L.no = "%s 없음"
L.intermission = "사잇단계"
--L.percent = "%d%% - %s" -- 20% - spell

-- Add related
L.add_spawned = "추가 몹 생성"
L.spawned = "%s 생성"
L.spawning = "%s 생성"
L.next_add = "다음 몹 추가"
L.add_killed = "추가 몹 처치 (%d/%d)"
L.add_remaining = "추가 몹 처치, %d 남음"
L.add = "추가 몹"
L.adds = "추가 몹들"
L.big_add = "큰 추가 몹"
L.small_adds = "작은 추가 몹들"

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

-- Common raid marking locale
L.marker = "%s 징표 표시"
L.marker_player_desc = "%s에 영향받는 플레이어를 %s|1으로;로; 징표 표시합니다, 부공격대장 이상의 권한이 필요합니다."
L.marker_npc_desc = "%s|1을;를; %s|1으로;로; 징표 표시합니다, 부공격대장 이상의 권한이 필요합니다."

-- Ability where two players have to move close to each other
L.link = "연결"
L.link_with = "%s|1과;와; 연결됨"
L.link_short = "연결됨: %s"
L.link_both = "%s|1과;와; %s|1이;가; 연결됨"
L.link_removed = "연결 사라짐"

-- Abbreviated numbers
L.amount_one = "%.2f억" -- Billions 1,000,000,000
L.amount_two = "%.1f만" -- Millions 1,000,000
L.amount_three = "%d천" -- Thousands 1,000
L.seconds = "%.1f초" -- 1.1 seconds

-- Common ability name replacements
L.laser = "레이저" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.bomb = "폭탄" -- Used for debuffs that make players explode
L.fixate = "시선 고정" -- Used when a boss or add is chasing/fixated on a player
