
local L = BigWigs:NewBossLocale("Archavon the Stone Watcher", "koKR")
if L then
	L.stomp_message = "발 구르기 - 곧 돌진!"
	L.stomp_warning = "약 5초 후 발구르기 가능!"
	L.stomp_bar = "~발 구르기 대기시간"

	L.cloud_message = "당신은 숨막히는 구름!"

	L.charge = "돌진"
	L.charge_desc = "돌진의 대상인 플레이어를 알립니다."
end

L = BigWigs:NewBossLocale("Emalon the Storm Watcher", "koKR")
if L then
	L.nova_next = "~번개 대기시간"

	L.overcharge_message = "하수인 과충전!"
	L.overcharge_bar = "폭발"
	L.overcharge_next = "~과충전 대기시간"
end

L = BigWigs:NewBossLocale("Koralon the Flame Watcher", "koKR")
if L then
	L.cinder_message = "당신은 잿더미!"
end

L = BigWigs:NewBossLocale("Toravon the Ice Watcher", "koKR")
if L then
	L.whiteout_bar = "시아상실 %d"
	L.whiteout_message = "곧 시아상실 %d !"

	L.frostbite_message = "동상 %2$dx : %1$s"

	L.freeze_message = "땅얼리기"

	L.orb_bar = "다음 구슬"
end

L = BigWigs:NewBossLocale("Malygos", "koKR")
if L then
	L.sparks = "불꽃 소환"
	L.sparks_desc = "마력의 불꽃 소환을 알립니다."
	L.sparks_message = "마력의 불꽃 소환!"
	L.sparks_warning = "약 5초 후 마력의 불꽃!"

	L.sparkbuff = "말리고스의 마력의 불꽃"
	L.sparkbuff_desc = "말리고스의 마력의 불꽃 획득을 알립니다."
	L.sparkbuff_message = "말리고스 마력의 불꽃 획득!"

	L.vortex = "회오리"
	L.vortex_desc = "1단계에서 회오리를 알립니다."
	L.vortex_message = "회오리!"
	L.vortex_warning = "약 5초 후 회오리 사용가능!"
	L.vortex_next = "회오리 대기시간"

	L.breath = "깊은 숨결"
	L.breath_desc = "2단계에서 말리고스가 사용하는 깊은 숨결을 알립니다."
	L.breath_message = "깊은 숨결!"
	L.breath_warning = "약 5초 후 깊은 숨결!"

	L.surge = "마력의 쇄도"
	L.surge_desc = "3단계에서 말리고스가 당신에게 마력의 쇄도를 사용시 알립니다."
	L.surge_you = "당신에게 마력의 쇄도!"
	L.surge_trigger = "%s|1이;가; 당신을 주시합니다!"

	L.phase = "단계"
	L.phase_desc = "단계 변화를 알립니다."
	L.phase2_warning = "잠시 후 2 단계!"
	L.phase2_trigger = "되도록 빨리 끝내 주고 싶었다만"
	L.phase2_message = "2 단계 - 마력의 군주 & 영원의 후예!"
	L.phase2_end_trigger = "그만! 아제로스의 마력을 되찾고"
	L.phase3_warning = "잠시 후 3 단계!"
	L.phase3_trigger = "네놈들의 후원자가 나타났구나"
	L.phase3_message = "3 단계!"
end

L = BigWigs:NewBossLocale("Sartharion", "koKR")
if L then
	L.engage_trigger = "내 임무는 알을 보호하는 것. 알에 손대지 못하게 모두 불태워 주마."

	L.tsunami = "용암 파도"
	L.tsunami_desc = "용암파도에 바와 알림입니다."
	L.tsunami_warning = "약 5초 후 용암 파도!"
	L.tsunami_message = "용암 파도!"
	L.tsunami_cooldown = "용암 파도 대기시간"
	L.tsunami_trigger = "%s|1을;를; 둘러싼 용암이 끓어오릅니다!"

	L.breath_cooldown = "화염 숨결 대기시간"

	L.drakes = "비룡 추가"
	L.drakes_desc = "각 비룡이 전투에 추가되는 것을 알립니다."
	L.drakes_incomingsoon = "약 5초 후 %s 착지!"

	L.twilight = "황혼 이벤트"
	L.twilight_desc = "황혼의 안에서 무엇이 일어나는지 알립니다."
	L.twilight_trigger_tenebron = "테네브론이 황혼에서 알을 부화하기 시작합니다!"
	L.twilight_trigger_vesperon = "베스페론의 신도가 황혼에서 나타납니다!"
	L.twilight_trigger_shadron = "샤드론의 신도가 황혼에서 나타납니다!"
	L.twilight_message_tenebron = "알 부화중"
	L.twilight_message = "%s 신도 추가!"
end

L = BigWigs:NewBossLocale("Halion", "koKR")
if L then
	L.engage_trigger = "너희 세상에 파멸의 바람이 불어온다"

	L.phase_two_trigger = "황혼 세계에서는 고통만이 있으리라"

	L.twilight_cutter_trigger = "주위를 회전하는 구슬들이 고동치며 어둠의 기운을 내뿜습니다"
	L.twilight_cutter_bar = "~황혼 절단기"
	L.twilight_cutter_warning = "곧 황혼 절단기"
	
	L.fire_damage_message = "당신의 발이 불타오르는 중!"
	L.fire_message = "맹렬한 발화"
	L.fire_bar = "다음 맹렬한 발화"
	L.fire_say = "나에게 맹렬한 발화!"
	L.shadow_message = "영혼 소진"
	L.shadow_bar = "다음 영혼 소진"
	L.shadow_say = "나에게 영혼 소진!"

	L.meteorstrike_yell = "하늘이 타오른다!"
	L.meteorstrike_bar = "유성 충돌"
	L.meteor_warning_message = "곧 유성 충돌!"

	L.breath_cooldown = "다음 숨결"
end
