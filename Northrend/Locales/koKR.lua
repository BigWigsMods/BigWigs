local L = LibStub("AceLocale-3.0"):NewLocale("BigWigsArchavon the Stone Watcher", "koKR")
if L then
	L.stomp_message = "발 구르기 - 곧 돌진!"
	L.stomp_warning = "약 5초 후 발구르기 가능!"
	L.stomp_bar = "~발 구르기 대기시간"

	L.cloud_message = "당신은 숨막히는 구름!"

	L.charge = "돌진"
	L.charge_desc = "돌진의 대상인 플레이어를 알립니다."

	L.icon = "전술 표시"
	L.icon_desc = "바위 조각 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)"
end


L = LibStub("AceLocale-3.0"):NewLocale("BigWigsEmalon the Storm Watcher", "koKR")
if L then
	L.nova_next = "~번개 대기시간"

	L.overcharge_message = "하수인 과충전!"
	L.overcharge_bar = "폭발"
	L.overcharge_next = "~과충전 대기시간"

	L.icon = "과충전 아이콘"
	L.icon_desc = "과충전에 걸린 하수인에게 해골 표시를 지정합니다. (승급자 이상 권한 필요)"
end


L = LibStub("AceLocale-3.0"):NewLocale("BigWigsMalygos", "koKR")
if L then
	L.sparks = "불꽃 소환"
	L.sparks_desc = "마력의 불꽃 소환을 알립니다."
	L.sparks_message = "마력의 불꽃 소환!"
	L.sparks_warning = "약 5초 후 마력의 불꽃!"

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

L = Libstub("AceLocale-3.0"):NewLocale("BigWigsSartharion", "koKR")
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
