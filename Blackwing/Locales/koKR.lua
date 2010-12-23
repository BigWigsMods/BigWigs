local L = BigWigs:NewBossLocale("Atramedes", "koKR")
if L then
	L.tracking_me = "나를 추적!"

	L.shield = "고대 드워프 보호막"
	L.shield_desc = "남아있는 고대 드워프 보호막을 알립니다."
	L.shield_message = "%d 고대 드워프 보호막 남음"

	L.ground_phase = "지상 단계"
	L.ground_phase_desc = "아트라메데스의 착지를 알립니다."
	L.air_phase = "공중 단계"
	L.air_phase_desc = "아트라메데스의 이륙을 알립니다."

	L.air_phase_trigger = "그래, 도망가라! 발을 디딜 때마다 맥박은 빨라지지. 점점 더 크게 울리는구나... 귀청이 터질 것만 같군! 넌 달아날 수 없다!"

	L.sonicbreath_cooldown = "~음파 숨결"
end

L = BigWigs:NewBossLocale("Chimaeron", "koKR")
if L then
	L.bileotron_engage = "담즙로봇이 움직이기 시작하더니 고약한 냄새가 나는 물질을 방출합니다."

	L.next_system_failure = "다음 시스템 오류"
	L.break_message = "깨부수기 x%2$d : %1$s"

	L.warmup = "전투 준비"
	L.warmup_desc = "전투가 시작되기까지의 시간입니다."
end

L = BigWigs:NewBossLocale("Magmaw", "koKR")
if L then
	L.inferno = (GetSpellInfo(92191))
	L.inferno_desc = "이글거리는 지옥불 소환을 알립니다."

	L.slump = "슬럼프"
	L.slump_desc = "슬럼프 상태를 알립니다."

	L.slump_trigger = "%s|1이;가; 창에 꽂혀 머리가 노출되었습니다!"
end

L = BigWigs:NewBossLocale("Maloriak", "koKR")
if L then
	--heroic
	L.darkSludge = (GetSpellInfo(92987))
	L.darkSludge_desc = ("%s 에 서있다면 알립니다."):format((GetSpellInfo(92987)))

	--normal
	L.final_phase = "마지막 단계"

	L.release_aberration_message = "돌연변이 %s 남음"
	L.release_all = "모든 실험체 %s!"

	L.bitingchill_say = "나에게 살을 에는 추위!"

	L.flashfreeze = "~순간 빙결"

	L.phase = "단계"
	L.phase_desc = "단계 변화를 알립니다."
	L.next_phase = "다음 단계"

	L.you = "당신은 %s!"

	L.red_phase_trigger = "섞고 흔들어서, 열을 가한다..."
	L.red_phase = "|cFFFF0000붉은|r 단계"
	L.blue_phase_trigger = "급격한 온도 변화에 필멸의 육신"
	L.blue_phase = "|cFF809FFE푸른|r 단계"
	L.green_phase_trigger = "이건 좀 불안정하지만"
	L.green_phase = "|cFF33FF00초록|r 단계"
	L.dark_phase = "|cFF660099암흑|r 단계"
	L.dark_phase_trigger = "혼합물이 너무 약하구나, 말로리악!"
end

L = BigWigs:NewBossLocale("Nefarian", "koKR")
if L then
	L.phase = "단계"
	L.phase_desc = "단계 변화를 알립니다."
	
	L.phase_two_trigger = "저주받을 필멸자들!"	--check
	
	L.phase_three_trigger = "품위있는"	--check

	L.shadowblaze_trigger = "Flesh turns to ash!"

	L.chromatic_prototype = "오색 실험체" -- 3 adds name
end

L = BigWigs:NewBossLocale("Omnotron Defense System", "koKR")
if L then
	L.nef = "군주 빅터 네파리우스"
	L.nef_desc = "군주 빅터 네파리우스의 기술을 알립니다."
	L.switch = "전환"
	L.switch_desc = "전환을 알립니다."

	L.next_switch = "다음 전환"

	L.nef_trigger1 = "Were you planning on using Toxitron's chemicals to damage the other constructs? Clever plan, let me ruin that for you."	--check
	L.nef_trigger2 = "Stupid Dwarves and your fascination with runes! Why would you create something that would help your enemy?"	--check

	L.nef_next = "~Next ability buff"

	L.acquiring_target = "대상 획득"

	L.cloud_message = "당신은 화학 구름!"
end
