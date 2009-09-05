if true then return end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Algalon", "enUS", true)
L:RegisterTranslations("koKR", function() return {
	phase = "단계",
	phase_desc = "단계 변경을 알립니다.",
	engage_warning = "1 단계",
	phase2_warning = "곧 2단계",
	phase_bar = "%d 단계",
	engage_trigger = "^너희 행동은 비논리적이다.",

	punch_message = "위상의 주먹 %dx: %s",
	smash_message = "곧 우주의 강타!",
	blackhole_message = "검은 구멍 폭발 %dx 소환",
	bigbang_soon = "곧 대폭발!",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Auriaya", "enUS", true)
L:RegisterTranslations("koKR", function() return {
	fear_warning = "곧 공포!",
	fear_message = "공포 시전!",
	fear_bar = "~공포 대기시간",

	swarm_message = "Swarm",
	swarm_bar = "~무리 대기시간",

	defender = "수호 야수",
	defender_desc = "수호 야수의 남은 생명 횟수를 알립니다.",
	defender_message = "수호 야수 (생명: %d/9)!",

	sonic_bar = "~음파 대기시간",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Freya", "enUS", true)
L:RegisterTranslations("koKR", function() return {
	engage_trigger1 = "어떻게 해서든 정원을 수호해야 한다!",
	engage_trigger2 = "장로여, 내게 힘을 나눠다오!",

	phase = "단계",
	phase_desc = "단계 변화를 알립니다.",
	phase2_message = "2 단계 !",

	wave = "웨이브",
	wave_desc = "웨이브에 대해 알립니다.",
	wave_bar = "다음 웨이브",
	conservator_trigger = "이오나여, 당신의 종이 도움을 청합니다!",
	detonate_trigger = "정령의 무리가 너희를 덮치리라!",
	elementals_trigger = "얘들아, 날 도와라!",
	tree_trigger = "|cFF00FFFF생명의 어머니의 선물|r이 자라기 시작합니다!",
	conservator_message = "수호자 소환",
	detonate_message = "폭발 덩굴손 소환",
	elementals_message = "정령 3 소환",
	
	tree = "이오나의 선물",
	tree_desc = "프레이야의 이오나의 선물 소환을 알립니다.",
	tree_message = "이오나의 선물 소환",

	fury_message = "격노",
	fury_other = "자연의 격노: %s!",

	tremor_warning = "곧 지진!",
	tremor_bar = "~다음 지진",
	energy_message = "당신은 불안정한 힘!",
	sunbeam_message = "태양 광선!",
	sunbeam_bar = "~다음 태양 광선",

	icon = "전술 표시",
	icon_desc = "태양 광선과 자연의 격노의 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	end_trigger = "내게서 그의 지배력이 걷혔다. 다시 온전한 정신을 찾았도다. 영웅들이여, 고맙다.",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Hodir", "enUS", true)
L:RegisterTranslations("koKR", function() return {
	engage_trigger = "침입자는 쓴맛을 보게 될 게다!",

	cold = "매서운 추위(업적)",
	cold_desc = "매서운 추위 2중첩이상을 알립니다.",
	cold_message = "매서운 추위 x%d - 이동!",

	flash_warning = "순간 빙결 시전!",
	flash_soon = "5초 후 순간 빙결",

	hardmode = "도전 모드 시간",
	hardmode_desc = "도전 모드의 시간을 표시합니다.",

	icon = "전술 표시",
	icon_desc = "폭풍 구름을 획득한 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	end_trigger = "드디어... 드디어 그의 손아귀를... 벗어나는구나.",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Ignis", "enUS", true)
L:RegisterTranslations("koKR", function() return {
	engage_trigger = "건방진 젖먹이들이! 세상을 되찾는 데 쓸 무기를 네놈들의 피로 담금질하겠다!",	--check

	construct_message = "피조물 활성화!",
	construct_bar = "다음 피조물",
	brittle_message = "피조물 부서지는 몸!",
	flame_bar = "~분출 대기시간",
	scorch_message = "당신은 불태우기!",
	scorch_soon = "약 5초 후 불태우기!",
	scorch_bar = "다음 불태우기",
	slagpot_message = "용암재 단지: %s",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Iron Council", "enUS", true)
L:RegisterTranslations("koKR", function() return {
	engage_trigger1 = "무쇠 평의회가 그리 쉽게 무너질 것 같으냐, 침입자들아!",
	engage_trigger2 = "남김없이 쓸어버려야 속이 시원하겠군.",
	engage_trigger3 = "세상에서 가장 큰 모기건 세상에서 가장 위대한 영웅이건, 너흰 어차피 필멸의 존재야.",

	overload_message = "6초 후 과부하!",
	death_message = "당신은 죽음의 룬!",
	summoning_message = "소환의 룬 - 곧 정령 등장!",

	chased_other = "%s 추적 중!",
	chased_you = "당신을 추적 중!",

	overwhelm_other = "압도적인 힘: %s",

	shield_message = "룬의 보호막!",

	icon = "전술 표시",
	icon_desc = "추적 중인 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	council_dies = "%s 죽음",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Kologarn", "enUS", true)
L:RegisterTranslations("koKR", function() return {
	arm = "팔 죽음",
	arm_desc = "왼팔 & 오른팔의 죽음을 알립니다.",
	left_dies = "왼팔 죽음",
	right_dies = "오른팔 죽음",
	left_wipe_bar = "왼팔 재생성",
	right_wipe_bar = "오른팔 재생성",

	shockwave = "충격파",
	shockwave_desc = "다음 충격파에 대하여 알립니다.",
	shockwave_trigger = "망각!",

	eyebeam = "안광 집중",
	eyebeam_desc = "안광 집중의 대상이된 플레이어를 알립니다.",
	eyebeam_trigger = "콜로간이 당신에게 안광을 집중합니다!",
	eyebeam_message = "안광 집중: %s",
	eyebeam_bar = "~안광 집중",
	eyebeam_you = "당신에게 안광 집중!",
	eyebeam_say = "저 안광 집중요!",

	eyebeamsay = "안광 일반 대화",
	eyebeamsay_desc = "안광 집중의 대상시 일반 대화로 알립니다.",

	armor_message = "방어구 씹기 x%2$d: %1$s",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Flame Leviathan", "enUS", true)
L:RegisterTranslations("koKR", function() return {
	engage_trigger = "^적대적인 존재 감지.",
	engage_message = "%s 전투 시작!",

	pursue = "추격",
	pursue_desc = "플레이어에게 거대 화염전차의 추적을 알립니다.",
	pursue_trigger = "([^%s]+)|1을;를; 쫓습니다.$",
	pursue_other = "%s 추격!",

	shutdown_message = "시스템 작동 정지!",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Mimiron", "enUS", true)
L:RegisterTranslations("koKR", function() return {
	phase = "단계",
	phase_desc = "단계 변화를 알립니다.",
	engage_warning = "1 단계",
	engage_trigger = "^시간이 없어, 친구들!",
	phase2_warning = "곧 2 단계",
	phase2_trigger = "^멋지군!",
	phase3_warning = "곧 3 단계",
	phase3_trigger = "^고맙다, 친구들!",
	phase4_warning = "곧 4 단계",
	phase4_trigger = "^예비 시험은 이걸로 끝이다",
	phase_bar = "%d 단계",

	hardmode = "도전 모드 시간",
	hardmode_desc = "도전 모드의 시간을 표시합니다.",
	hardmode_trigger = "^아니, 대체 왜 그런 짓을 한 게지?",
	hardmode_message = "도전 모드 활성화!",
	hardmode_warning = "폭발!",

	plasma_warning = "플라스마 폭발 시전!",
	plasma_soon = "곧 플라스마!",
	plasma_bar = "다음 플라스마",

	shock_next = "다음 충격파",

	laser_soon = "회전 가속!",
	laser_bar = "레이저 탄막",

	magnetic_message = "공중 지휘기! 극딜!",

	suppressant_warning = "곧 화염 억제!",

	fbomb_soon = "잠시후 서리 폭탄 가능!",
	fbomb_bar = "다음 서리 폭탄",

	bomb_message = "폭발로봇 소환!",

	end_trigger = "^내가 계산을 좀 잘못한 것 같군",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Razorscale", "enUS", true)
L:RegisterTranslations("koKR", function() return {
	phase = "단계",
	phase_desc = "칼날비늘의 단계 변경을 알립니다.",
	ground_trigger = "움직이세요! 오래 붙잡아둘 순 없을 겁니다!",
	ground_message = "칼날비늘 묶임!",
	air_trigger = "저희에게 잠깐 포탑을 설치할 시간을 주세요.",
	air_trigger2 = "불꽃이 꺼졌어요! 포탑을 재설치합시다!",
	air_message = "이륙!",
	phase2_trigger = "%s|1이;가; 완전히 땅에 내려앉았습니다!",
	phase2_message = "2 단계!",
	phase2_warning = "곧 2 단계!",
	stun_bar = "기절",

	breath_trigger = "%s|1이;가; 숨을 깊게 들이쉽니다.",
	breath_message = "화염 숨결!",
	breath_bar = "~숨결 대기시간",

	flame_message = "당신은 파멸의 불길!",

	harpoon = "작살 포탑",
	harpoon_desc = "작살 포탑의 준비를 알립니다.",
	harpoon_message = "작살 포탑 (%d)",
	harpoon_trigger = "작살 포탑이 준비되었습니다!",
	harpoon_nextbar = "다음 작살 (%d)",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Thorim", "enUS", true)
L:RegisterTranslations("koKR", function() return {
	phase = "단계",
	phase_desc = "단계 변화를 알립니다.",
	phase1_message = "1 단계 시작",
	phase2_trigger = "침입자라니! 감히 내 취미 생활을 방해하는 놈들은 쓴맛을 단단히... 잠깐... 너는...",
	phase2_message = "2 단계 - 6분 15초 후 광폭화!",
	phase3_trigger = "건방진 젖먹이 같으니... 감히 여기까지 기어올라와 내게 도전해? 내 손으로 쓸어버리겠다!",
	phase3_message = "3 단계 - %s 전투시작!",

	hardmode = "도전 모드 시간",
	hardmode_desc = "도전 모드의 시간을 표시합니다.",
	hardmode_warning = "도전 모드 종료",

	shock_message = "당신은 번개 충격! 이동!",
	barrier_message = "거인 - 룬문자 방벽!",

	detonation_say = "저 푹탄이에요! 피하세요!",

	charge_message = "충전 (%d)!",
	charge_bar = "충전 (%d)",

	strike_bar = "혼란의 일격 대기시간",

	end_trigger = "무기를 거둬라! 내가 졌다!",

	icon = "전술 표시",
	icon_desc = "룬 폭발 또는 폭풍망치에 걸린 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: General Vezax", "enUS", true)
L:RegisterTranslations("koKR", function() return {
	engage_trigger = "^너희의 파멸은 새로운 고통의 시대를 열 것이다!",

	surge_message = "어둠 쇄도 (%d)!",
	surge_cast = "쇄도 시전 (%d)!",
	surge_bar = "쇄도 %d",

	animus = "사로나이트 원혼",
	animus_desc = "사로나이트 원혼 소환을 알립니다.",
	animus_trigger = "사로나이트 증기가 한 덩어리가 되어 맹렬하게 소용돌이치며, 무시무시한 형상으로 변화합니다!",
	animus_message = "원혼 소환!",

	vapor = "사로나이트 증기",
	vapor_desc = "사로나이트 증기 소환을 알립니다.",
	vapor_message = "사로나이트 증기 (%d)!",
	vapor_bar = "다음 증기 %d/6",
	vapor_trigger = "가까운 사로나이트 증기 구름이 합쳐집니다!",

	vaporstack = "증기 중첩",
	vaporstack_desc = "사로나이트 증기 5중첩이상을 알립니다.",
	vaporstack_message = "증기 x%d 중첩!",

	crashsay = "붕괴 일반 대화",
	crashsay_desc = "어둠의 붕괴 대상시 일반 대화로 알립니다.",
	crash_say = "저 어둠 붕괴요!",

	crashicon = "붕괴 아이콘",
	crashicon_desc = "어둠 붕괴의 대상 플레이어에게 두번째 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	mark_message = "징표",
	mark_message_other = "얼굴 없는 자의 징표: %s",

	icon = "징표 아이콘",
	icon_desc = "얼굴 없는 자의 징표의 대상 플레이어에게 기본 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: XT-002", "enUS", true)
L:RegisterTranslations("koKR", function() return {
	exposed_warning = "잠시 후 심장 노출!",
	exposed_message = "심장 노출 - 로봇들 추가!",

	gravitybomb_other = "중력 폭탄: %s!",

	gravitybombicon = "중력 폭탄 아이콘",
	gravitybombicon_desc = "중력 폭탄에 걸린 플레이어를 네모 전술로 지정합니다. (승급자 이상 권한 필요)",

	lightbomb_other = "빛의 폭탄: %s!",

	tantrum_bar = "~땅울림 대기시간",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Yogg-Saron", "enUS", true)
L:RegisterTranslations("koKR", function() return {
	["Crusher Tentacle"] = "분쇄의 촉수",
	["The Observation Ring"] = "관찰 지구",

	phase = "단계",
	phase_desc = "단계 변화를 알립니다.",
	engage_warning = "1 단계",
	engage_trigger = "^짐승의 대장을 칠 때가 곧 다가올 거예요",
	phase2_warning = "2 단계",
	phase2_trigger = "^나는, 살아 있는 꿈이다",
	phase3_warning = "3 단계",
	phase3_trigger = "^죽음의 진정한 얼굴을 보아라",

	portal = "차원문",
	portal_desc = "차원문을 알립니다.",
	portal_trigger = "%s의 마음속으로 가는 차원문이 열립니다!",
	portal_message = "차원문 열림!",
	portal_bar = "다음 차원문",

	sanity_message = "당신의 이성 위험!",

	weakened = "기절",
	weakened_desc = "기절 상태를 알립니다.",
	weakened_message = "%s 기절!",
	weakened_trigger = "환상이 부서지며, 중앙에 있는 방으로 가는 길이 열립니다!",

	madness_warning = "5초 후 광기 유발!",
	malady_message = "병든 정신: %s",

	tentacle = "촉수 소환",
	tentacle_desc = "촉수 소환을 알립니다.",
	tentacle_message ="분쇄의 촉수(%d)",

	link_warning = "당신은 두뇌의 고리!",

	gaze_bar = "~시선 대기시간",
	empower_bar = "~강화 대기시간",

	guardian_message = "수호자 소환 %d!",

	empowericon = "암흑 강화 아이콘",
	empowericon_desc = "암흑 강화에 걸린 수호병에게 해골 표시를 지정합니다. (승급자 이상 권한 필요)",
	empowericon_message = "암흑 강화 사라짐!",

	roar_warning = "5초 후 포효!",
	roar_bar = "다음 포효",
} end )
