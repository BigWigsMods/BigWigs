local L = BigWigs:NewBossLocale("Morchok", "koKR")
if not L then return end
if L then
	L.engage_trigger = "계란으로 바위를 치려 드는군. 내가 널 묻어주마."

	L.crush = "갑옷 으깨기"
	L.crush_desc = "탱커 전용 경고입니다. 갑옷 으깨기 중첩과 지속시간 바를 표시합니다."
	L.crush_message = "갑옷 으깨기 x%2$d : %1$s"

	L.blood = "대지의 검은 피"

	L.explosion = "폭발"
end

L = BigWigs:NewBossLocale("Warlord Zon'ozz", "koKR")
if L then
	L.engage_trigger = "조브 슐와. 토크 프쉬 느조스!"

	L.ball = "공허의 구슬"
	L.ball_desc = "플레이어와 보스 사이를 오가는 공허의 구슬입니다."

	L.bounce = "끌어쓰기"
	L.bounce_desc = "구슬이 튕긴 횟수를 카운트합니다."

	L.darkness = "촉수 디스코 파티!"
	L.darkness_desc = "구슬이 보스에게 닿으면 이 단계가 시작 됩니다."

	L.shadows = "그림자"
end

L = BigWigs:NewBossLocale("Yor'sahj the Unsleeping", "koKR")
if L then
	L.engage_trigger = "릴스 퀴요툭 샨마 예글루 셰아스야! 하인 릴스!"

	L.bolt_desc = "탱커 전용 경고입니다. 공허의 화살 중첩과 지속시간 바를 표시합니다."
	L.bolt_message = "공허의 화살 x%2$d : %1$s"

	L.blue = "|cFF0080FF파랑|r"
	L.green = "|cFF088A08초록|r"
	L.purple = "|cFF9932CD보라|r"
	L.yellow = "|cFFFFA901노랑|r"
	L.black = "|cFF424242검정|r"
	L.red = "|cFFFF0404빨강|r"

	L.blobs = "핏방울"
	L.blobs_bar = "~핏방울"
	L.blobs_desc = "보스를 향해 움직이는 핏방울입니다."
end

L = BigWigs:NewBossLocale("Hagara the Stormbinder", "koKR")
if L then
	L.engage_trigger = "감히 폭풍술사에게 덤비다니! 다 쓸어버리겠다."

	L.lightning_or_frost = "번개 또는 얼음"
	L.ice_next = "얼음 단계"
	L.lightning_next = "번개 단계"

	L.assault_desc = "탱커 전용 경고입니다. "..select(2, EJ_GetSectionInfo(4159))

	L.nextphase = "다음 단계"
	L.nextphase_desc = "다음 단계에 대한 알림입니다."
end

L = BigWigs:NewBossLocale("Ultraxion", "koKR")
if L then
	L.engage_trigger = "지금은 황혼의 시간이다!"

	L.warmup = "전투준비"
	L.warmup_desc = "전투준비 타이머입니다."
	L.warmup_trigger = "나는... 종말의 시작이다. 태양을 뒤덮어버리는 그림자이자, 네 파멸을 알리는 종소리이다."

	L.crystal = "버프 수정"
	L.crystal_desc = "여러 NPC들이 소환하는 수정에 대한 타이머 입니다."
	L.crystal_red = "빨간 수정"
	L.crystal_green = "초록색 수정"
	L.crystal_blue = "파란 수정"

	L.twilight = "황혼의 시간"
	L.cast = "황혼의 시간 시전 바"
	L.cast_desc = "황혼의 시간 시전 5초전 바를 표시합니다."

	L.lightyou = "당신에 사그라지는 빛"
	L.lightyou_desc = "사그라지는 빛의 폭발까지 남은 시간을 바에 표시합니다."
	L.lightyou_bar = "<폭발>"

	L.lighttank = "Fading Light on Tanks"
	L.lighttank_desc = "Tank alert only. If a tank has Fading Light, show an explode bar and Flash/Shake."
	L.lighttank_bar = "<%s Explodes>"
	L.lighttank_message = "Exploding Tank"
end

L = BigWigs:NewBossLocale("Warmaster Blackhorn", "koKR")
if L then
	L.harpooning = "작살"

	L.rush = "칼날 돌격"

	L.sunder = "방어구 가르기"
	L.sunder_desc = "탱커 전용 경고입니다. 방어구 가르기 중첩과 지속시간 바를 표시합니다."
	L.sunder_message = "방어구 가르기 : x%2$d : %1$s"

	L.sapper_trigger = "비룡이 빠르게 날아와 황혼의 폭파병을 갑판에 떨어뜨립니다!"
	L.sapper = "폭파병"
	L.sapper_desc = "배에 큰 피해를 입히는 폭파병입니다."

	L.stage2_trigger = "Looks like I'm doing this myself. Good!"
end

L = BigWigs:NewBossLocale("Spine of Deathwing", "koKR")
if L then
	L.left_start = "왼쪽으로 회전합니다!"
	L.right_start = "오른쪽으로 회전합니다!"
	L.left = "왼쪽으로 회전"
	L.right = "오른쪽으로 회전"
	L.not_hooked = "접착되지 않았음!"
	L.roll_message = "He's rolling, rolling, rolling!"
	L.level_trigger = "levels out"
	L.level_message = "Nevermind, he leveled out!"

	L.exposed = "Armor Exposed"
end

L = BigWigs:NewBossLocale("Madness of Deathwing", "koKR")
if L then

end

