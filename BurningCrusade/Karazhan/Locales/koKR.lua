local L = BigWigs:NewBossLocale("Attumen the Huntsman Raid", "koKR")
if not L then return end
if L then
	L.phase = "단계"
	L.phase_desc = "새로운 단계 진입 시 알립니다."
	L.phase2_trigger = "%s|1이;가; 주인을 부릅니다!"
	L.phase2_message = "2 단계 - %s & 어튜멘"
	L.phase3_trigger = "이랴! 이 오합지졸을 데리고 실컷 놀아보자!"
	L.phase3_message = "3 단계"
end

L = BigWigs:NewBossLocale("The Curator Raid", "koKR")
if L then
	L.engage_trigger = "박물관에는 초대받은 손님만 입장하실 수 있습니다."

	L.weaken_message = "환기 - 20초간 약화!"
	L.weaken_fade_message = "환기 종료 - 약화 종료!"
	L.weaken_fade_warning = "5초 후 환기 종료!"
end

L = BigWigs:NewBossLocale("Maiden of Virtue Raid", "koKR")
if L then
	L.engage_trigger = "너희의 행동은 그냥 넘길 수가 없다."
	L.engage_message = "고결의 여신 전투 개시! 약 33초 후 참회"

	L.repentance_message = "참회! 다음은 약 33초 후!"
	L.repentance_warning = "참회 쿨다운 종료 - 잠시후 시전!"
end

L = BigWigs:NewBossLocale("Prince Malchezaar", "koKR")
if L then
	L.wipe_bar = "재생성 시간"

	L.phase = "단계"
	L.phase_desc = "단계 변화 시 알립니다."
	L.phase1_trigger = "여기까지 오다니 정신이 나간 놈들이 분명하구나. 소원이라면 파멸을 시켜주마!"
	L.phase2_trigger = "바보 같으니! 시간은 너의 몸을 태우는 불길이 되리라!"
	L.phase3_trigger = "어찌 감히 이렇게 압도적인 힘에 맞서기를 꿈꾸느냐?"
	L.phase1_message = "1 단계 - 약 40초 후 불지옥!"
	L.phase2_message = "60% - 2 단계"
	L.phase3_message = "30% - 3 단계"

	L.infernal = "불지옥"
	L.infernal_desc = "불지옥 소환에 대한 재사용 대기시간을 표시합니다."
	L.infernal_bar = "불지옥 등장"
	L.infernal_warning = "17초 이내 불지옥 등장!"
	L.infernal_message = "불지옥 등장! 5초 이내 지옥불!"
end

L = BigWigs:NewBossLocale("Moroes Raid", "koKR")
if L then
	L.engage_trigger = "음, 예상치 못한 손님들이군. 준비를 해야겠어..."
	L.engage_message = "%s 전투 시작 - 약 35초 후 소멸!"
end

L = BigWigs:NewBossLocale("Netherspite", "koKR")
if L then
	L.phase = "단계"
	L.phase_desc = "황천의 원령의 다음 단계로 변화 시 경고합니다."
	L.phase1_message = "물러남 - 황천의 숨결 종료!"
	L.phase1_bar = "~물러남 주의"
	L.phase1_trigger = "%s|1이;가; 물러나며 고함을 지르더니 황천의 문을 엽니다."
	L.phase2_message = "분노 - 황천의 숨결 시전!"
	L.phase2_bar = "분노 주의"
	L.phase2_trigger = "%s|1이;가; 황천의 기운을 받고 분노에 휩싸입니다!"

	L.voidzone_warn = "공허의 지대 (%d)!"
end

L = BigWigs:NewBossLocale("Nightbane Raid", "koKR")
if L then
	L.name = "파멸의 어둠"

	L.phase = "단계"
	L.phase_desc = "파멸의 어둠의 단계 변경 시 알립니다."
	L.airphase_trigger = "이 더러운 기생충들, 내가 하늘에서 너희의 씨를 말리리라!"
	L.landphase_trigger1 = "그만! 내 친히 내려가서 너희를 짓이겨주마!"
	L.landphase_trigger2 = "하루살이 같은 놈들! 나의 힘을 똑똑히 보여주겠다!"
	L.airphase_message = "비행!"
	L.landphase_message = "착지!"
	L.summon_trigger = "멀리에서 고대의 존재가 깨어나고 있다..."

	L.engage_trigger = "정말 멍청하군! 고통 없이 빨리 끝내주마!"
end

L = BigWigs:NewBossLocale("Romulo & Julianne", "koKR")
if L then
	L.name = "로밀로 & 줄리엔"

	L.phase = "단계"
	L.phase_desc = "새로운 단계 진입 시 알립니다."
	L.phase1_trigger = "당신들은 대체 누구시기에 절 이리도 괴롭히나요?"
	L.phase1_message = "1 단계 - 줄리엔"
	L.phase2_trigger = "기어코 나를 화나게 하는구나. 그렇다면 받아라, 애송이!"
	L.phase2_message = "2 단계 - 로밀로"
	L.phase3_trigger = "정다운 밤이시여, 어서 와서 나의 로밀로를 돌려주소서!"
	L.phase3_message = "3 단계 - 모두"

	L.poison = "독"
	L.poison_desc = "독에 걸린 플레이어를 알립니다."
	L.poison_message = "중독"

	L.heal = "치유"
	L.heal_desc = "줄리엔이 영원한 사랑 시전 시 경고합니다."
	L.heal_message = "줄리엔 치유 시전 중!"

	L.buff = "버프 알림"
	L.buff_desc = "로밀로와 줄리엔이 버프 획득 시 알립니다."
	L.buff1_message = "로밀로 사랑의 용기 효과 얻음!"
	L.buff2_message = "줄리엔 헌신 효과 얻음!"
end

L = BigWigs:NewBossLocale("Shade of Aran", "koKR")
if L then
	L.adds = "물의 정령"
	L.adds_desc = "물의 정령 소환에 대한 경고입니다."
	L.adds_message = "정령 소환!"
	L.adds_warning = "곧 정령 소환"
	L.adds_bar = "물의 정령"

	L.drink = "음료 마시기"
	L.drink_desc = "아란의 망령의 음료 마시기 시작 시 알립니다."
	L.drink_warning = "마나 낮음 - 잠시 후 음료 마시기!"
	L.drink_message = "음료 마시기 - 광역 변이!"
	L.drink_bar = "불덩이 작열 시전"

	L.blizzard = "눈보라"
	L.blizzard_desc = "눈보라 시전 시 경고합니다."
	L.blizzard_message = "눈보라!"

	L.pull = "전체 광역"
	L.pull_desc = "전체 광역 신비한 폭발에 대한 경고입니다."
	L.pull_message = "신비한 폭발!"
	L.pull_bar = "신비한 폭발"
end

L = BigWigs:NewBossLocale("Terestian Illhoof", "koKR")
if L then
	L.engage_trigger = "^아, 때맞춰 와줬군."

	L.weak = "약화"
	L.weak_desc = "약화 상태에 대한 경고입니다."
	L.weak_message = "약 45초간 약화!"
	L.weak_warning1 = "약 5초 후 약화 종료!"
	L.weak_warning2 = "약화 종료!"
	L.weak_bar = "~약화 사라짐"
end

L = BigWigs:NewBossLocale("The Big Bad Wolf", "koKR")
if L then
	L.name = "커다란 나쁜 늑대"

	L.riding_bar = "빨간 두건 - %s"
end

L = BigWigs:NewBossLocale("The Crone", "koKR")
if L then
	L.name = "마녀"

	L.engage_trigger = "^티토야, 우린 집으로 갈 방법을 찾아야 해!"

	L.spawns = "등장 타이머"
	L.spawns_desc = "피조물 활동 시작에 대한 타이머입니다."
	L.spawns_warning = "5초 이내 %s"

	L.roar = "어흥이"
	L.tinhead = "양철나무꾼"
	L.strawman = "허수아비"
	L.tito = "티토"
end

