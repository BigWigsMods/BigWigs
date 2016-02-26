local L = BigWigs:NewBossLocale("Gruul", "koKR")
if not L then return end
if L then
L.first_ability = "내려치기 강타 또는 석화의 강타" -- Needs review

end

L = BigWigs:NewBossLocale("Oregorger", "koKR")
if L then
L.roll_message = "구르기 %d - %d 광물!" -- Needs review

end

L = BigWigs:NewBossLocale("The Blast Furnace", "koKR")
if L then
L.bombs_dropped = "폭탄이 떨어졌습니다! (%d)"
L.bombs_dropped_p2 = "가열로 기술자를 죽였습니다. 폭탄를 떨어뜨렸습니다." -- Needs review
L.custom_off_firecaller_marker = "불꽃소환사" -- Needs review
L.custom_off_firecaller_marker_desc = [=[불꽃소환사를 {rt7}{rt6}의 징표로 설정합니다. 공격대장이거나 권한이 필요합니다.
|cFFFF0000징표 설정 충돌을 막기 위해선 공격대에서 단 한 사람에게만 이 설정이 허용되어야만 합니다.|r
cFFADFF2FTIP: 공격대에서 당신에게 이 역할을 맡겼다면 불꽃소환사에게 마우스 커서를 옮기는 것이 징표 설정하는 가장 빠른 방법입니다.|r
]=] -- Needs review
L.custom_on_shieldsdown_marker = "보호막 소멸 징표 설정"
L.custom_on_shieldsdown_marker_desc = "보호막이 소멸된 원시의 정령술사를 {rt8}의 징표로 설정합니다. 공격대장이거나 권한이 필요합니다."
L.engineer = "가열로 기술자 출현" -- Needs review
L.engineer_desc = "2페이즈가 진행되는 동안 가열로 기술자는 가열로 양쪽 방에 각각 1마리씩 총 2마리가 출현할 겁니다." -- Needs review
L.firecaller = "불꽃소환사 출현" -- Needs review
L.firecaller_desc = "2페이즈가 진행되는 동안 불꽃소환사는 가열로 양쪽 방에 각각 1마리씩 총 2마리가 주기적으로 출현할 겁니다." -- Needs review
L.guard = "보안 경비병 출현" -- Needs review
L.guard_desc = "2페이즈가 진행되는 동안 보안 경비병은 가열로 양쪽 방 입구에 각각 1마리씩 총 2마리가 주기적으로 출현할 겁니다." -- Needs review
L.heat_increased_message = "열기가 증가합니다! %s초마다 폭파합니다."
L.operator = "풀무 조작기사" -- Needs review
L.operator_desc = "2페이즈가 진행되는 동안 풀무 조작기사는 가열로 양쪽 방에 각각 1마리씩 2마리가 주기적으로 출현할 겁니다." -- Needs review

end

L = BigWigs:NewBossLocale("Flamebender Ka'graz", "koKR")
if L then
L.custom_off_wolves_marker = "잿불늑대 대상자" -- Needs review
L.custom_off_wolves_marker_desc = "잿불늑대에게 {rt3}{rt4}{rt5}{rt6}의 징표를 설정합니다. 공격대장이거나 권한이 필요합니다." -- Needs review
L.molten_torrent_self = "나에게 시전한 녹아내린 격류"
L.molten_torrent_self_bar = "폭발합니다!"
L.molten_torrent_self_desc = "녹아내린 격류의 대상이 당신일 때 특수 카운트를 해줍니다."

end

L = BigWigs:NewBossLocale("Kromog", "koKR")
if L then
L.custom_off_hands_marker = "휘감는 대지의 룬 방어 전담 징표" -- Needs review
L.custom_off_hands_marker_desc = "방어 전담 플레이어를 움켜쥔 휘감는 대지의 룬을 {rt7}{rt8} 징표로 설정합니다. 공격대장이거나 권한이 필요합니다." -- Needs review
L.destroy_pillars = "기둥 파괴" -- Needs review
L.prox = "방어 전담 근접 표시" -- Needs review
L.prox_desc = "바위 주먹을 다른 방어 전담과 같이 맞기 위해 15미터 근접 표시창을 표시합니다." -- Needs review

end

L = BigWigs:NewBossLocale("Beastlord Darmac", "koKR")
if L then
L.custom_off_conflag_marker = "거대한 불길 징표 설정"
L.custom_off_conflag_marker_desc = [=[거대한 불길의 대상을 {rt1}{rt2}{rt3}의 징표로 설정합니다.
|cFFFF0000징표 설정에서 문제가 발생하는 것을 막기 위해 공격대에서 오직 1명만 이 옵션을 활성화해야 합니다.|r]=]
L.custom_off_pinned_marker = "봉쇄 징표 설정"
L.custom_off_pinned_marker_desc = [=[땅에 꽂힌 창을 {rt8}{rt7}{rt6}{rt5}{rt4}의 징표로 설정합니다.
|cFFFF0000징표 설정에서 문제가 발생하는 것을 막기 위해 공격대에서 오직 1명만 이 옵션을 활성화해야 합니다.|r
|cFFADFF2F팁: 만약 공격대에서 이 옵션을 사용하기로 결정했다면, 징표를 설정하기 위한 가장 빠른 방법은 창 위에 마우스를 올리는 것입니다.|r]=]
L.next_mount = "곧 탈것에 탑승합니다!"

end

L = BigWigs:NewBossLocale("Operator Thogar", "koKR")
if L then
L.adds_train = "쫄 기차"
L.big_add_train = "큰 쫄 기차"
L.cannon_train = "대포 기차"
L.custom_on_firemender_marker = "그롬카르 화염치유사 대상자" -- Needs review
L.custom_on_firemender_marker_desc = "그롬카르 화염치유사를 {rt7}의 징표로 설정합니다. 공격대장이거나 권한이 필요합니다." -- Needs review
L.custom_on_manatarms_marker = "그롬카르 무장병 대상자" -- Needs review
L.custom_on_manatarms_marker_desc = "그롬카르 무장병을 {rt8}의 징표로 설정합니다. 공격대장이거나 권한이 필요합니다." -- Needs review
L.deforester = "삼림방화포"
L.lane = "%s번째 라인 : %s"
L.random = "무작위 기차"
L.train = "기차"
L.trains = "기차 경고"
L.trains_desc = "각 라인마다 다음 기차가 언제 올 지에 대해서 타이머와 메시지를 표시합니다. 라인은 보스부터 입구쪽으로 '보스 1 2 3 4 입구'로 숫자가 매겨져 있습니다."
L.train_you = "현재 선로에 열차! (%d)" -- Needs review

end

L = BigWigs:NewBossLocale("The Iron Maidens", "koKR")
if L then
L.custom_off_heartseeker_marker = "피에 젖은 심장추적자 징표 설정"
L.custom_off_heartseeker_marker_desc = "피에 젖은 심장추적자의 대상을 {rt1}{rt2}{rt3}의 징표로 설정합니다. 공격대장이거나 권한이 필요합니다."
L.power_message = "강철 분노 %d!"
L.ship = "배로 점프"
L.ship_trigger = "무쌍호 주 대포를 쏠 준비를 합니다!"

end

L = BigWigs:NewBossLocale("Blackhand", "koKR")
if L then
L.custom_off_markedfordeath_marker = "죽음의 표적 징표 설정"
L.custom_off_markedfordeath_marker_desc = "죽음의 징표의 대상을 {rt1}{rt2}{rt3}의 징표로 설정합니다. 공격대장 또는 부공격대장 권한이 필요합니다." -- Needs review
L.custom_off_massivesmash_marker = "거대 분쇄의 강타 대상" -- Needs review
L.custom_off_massivesmash_marker_desc = "거대 분쇄의 강타 대상에게 {rt6}의 징표로 설정합니다. 공격대장이거나 권한이 필요합니다." -- Needs review

end

L = BigWigs:NewBossLocale("Blackrock Foundry Trash", "koKR")
if L then
L.beasttender = "천둥군주 야수치유사" -- Needs review
L.brute = "잿가루 작업장 투사" -- Needs review
L.earthbinder = "강철 대지결속사" -- Needs review
L.enforcer = "검은바위 집행자"
L.furnace = "열기 조절 장치" -- Needs review
L.furnace_msg1 = "흠, 누군가 해야하지 않겠어?" -- Needs review
L.furnace_msg2 = "마시멜로우 타임!" -- Needs review
-- L.furnace_msg3 = "This can't be good..."
L.gnasher = "어둠파편 갈갈이" -- Needs review
L.gronnling = "그론링 노동자"
L.guardian = "작업장 수호병" -- Needs review
L.hauler = "오그론 운반자" -- Needs review
L.mistress = "제련여제 플레임핸드" -- Needs review
L.taskmaster = "강철 장인" -- Needs review

end

