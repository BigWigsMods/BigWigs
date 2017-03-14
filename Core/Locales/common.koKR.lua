local L = BigWigsAPI:NewLocale("BigWigs: Common", "koKR")
if not L then return end

-- Prototype.lua common words
L.you = "당신에게 %s!"
L.underyou = "당신 아래에 %s!"
L.other = "%s: %s"
L.onboss = "우두머리에게 %s!"
L.on = "%2$s에게 %1$s"
L.stack = "%3$s에게 %1$dx %2$s"
L.stackyou = "당신에게 %dx %s"
L.cast = "<시전: %s>"
L.casting = "%s 시전 중!"
L.soon = "곧 %s!"
L.count = "%s (%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.near = "당신 근처에 %s!"

L.phase = "%d단계"
L.stage = "%d단계"
L.normal = "일반 모드"
L.heroic = "영웅 모드"
L.hard = "도전 모드"
L.mythic = "신화 모드"
L.general = "일반" -- General settings, i.e. things that apply to normal, heroic and mythic mode.

L.duration = "%s %s초 남음"
L.over = "%s 종료!"
L.removed = "%s 사라짐"
L.incoming = "곧 %s!"
L.interrupted = "%s 시전 방해됨"
L.no = "%s 없음!"
L.intermission = "사잇단계"

-- Add related
L.add_spawned = "쫄 생성!"
L.spawned = "%s 생성"
L.spawning = "%s 생성 중!"
L.next_add = "다음 쫄"
L.add_killed = "쫄 처치! (%d/%d)"
L.add_remaining = "쫄 처치, %d 남음"
L.add = "하수인 등장"
L.adds = "병력 등장"
L.big_add = "큰 쫄"
L.small_adds = "작은 쫄"

-- Mob related
L.mob_killed = "%s 처치! (%d/%d)"
L.mob_remaining = "%s 처치, %d 남음"

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = "%1$s 전투 개시 - %3$d분 후 %2$s"
L.custom_start_s = "%1$s 전투 개시 - %3$d초 후 %2$s"
L.custom_end = "%s - %s!"
L.custom_min = "%2$d분 후 %1$s"
L.custom_sec = "%2$d초 후 %1$s!"

L.focus_only = "|cffff0000주시 대상 경보만.|r "
L.trash = "일반몹"

-- Common raid marking locale
L.marker = "%s 징표"
L.marker_player_desc = "%s에 영향받는 플레이어에 %s|1을;를; 표시합니다, 부공격대장 또는 공격대장 권한이 필요합니다."
L.marker_npc_desc = "%s|1을;를; %s|1으로;로; 표시합니다, 부공격대장 또는 공격대장 권한이 필요합니다."
