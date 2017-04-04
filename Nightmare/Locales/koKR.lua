local L = BigWigs:NewBossLocale("Cenarius", "koKR")
if not L then return end
if L then
	L.forces = "세력"
	L.bramblesSay = "%s 근처에 가시나무"
	L.custom_off_multiple_breath_bar = "다중 썩은 숨결 바 표시"
	L.custom_off_multiple_breath_bar_desc = "기본적으로 BigWigs는 하나의 비룡의 썩은 숨결 바만 표시합니다. 각 비룡의 타이머를 보고싶다면 이 옵션을 활성화하세요."
end

L = BigWigs:NewBossLocale("Elerethe Renferal", "koKR")
if L then
	L.isLinkedWith = "%s|1이;가; %s|1과;와; 연결됨"
	L.yourLink = "당신은 %s|1과;와; 연결됨"
	L.yourLinkShort = "%s|1과;와; 연결됨"
end

L = BigWigs:NewBossLocale("Il'gynoth", "koKR")
if L then
	L.remaining = "남음"
	L.missed = "빗나감"
end

L = BigWigs:NewBossLocale("Emerald Nightmare Trash", "koKR")
if L then
	L.gelatinizedDecay = "아교질 부패"
	L.befouler = "타락심장 암흑오염자"
	L.shaman = "광포한 주술사"
end

L = BigWigs:NewBossLocale("Ursoc", "koKR")
if L then
	L.custom_on_gaze_assist = "시선 집중 지원"
	L.custom_on_gaze_assist_desc = "시선 집중 바와 메시지에 공격대 아이콘을 표시합니다. 한쪽은 {rt4}|1을;를; 사용하고, 다른 한쪽은 {rt6}|1을;를; 사용합니다. 부공격대장 이상의 권한이 필요합니다."
end

L = BigWigs:NewBossLocale("Xavius", "koKR")
if L then
	L.linked = "당신에게 공포의 결속! - %s|1과;와; 연결됨!"
	L.dreamHealers = "꿈 치유 전담"
end
