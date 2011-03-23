
local L = BigWigs:NewBossLocale("Atramedes", "koKR")
if not L then return end
if L then
	L.ground_phase = "지상 단계"
	L.ground_phase_desc = "아트라메데스의 착지를 알립니다."
	L.air_phase = "공중 단계"
	L.air_phase_desc = "아트라메데스의 이륙을 알립니다."

	L.air_phase_trigger = "그래, 도망가라! 발을 디딜 때마다 맥박은 빨라지지. 점점 더 크게 울리는구나... 귀청이 터질 것만 같군! 넌 달아날 수 없다!"

	L.obnoxious_soon = "곧 불쾌한 마귀!"

	L.searing_soon = "10초 후 이글거리는 불길!"
	L.sonicbreath_cooldown = "~음파 숨결"
end

L = BigWigs:NewBossLocale("Chimaeron", "koKR")
if L then
	L.bileotron_engage = "담즙로봇이 움직이기 시작하더니 고약한 냄새가 나는 물질을 방출합니다."

	L.next_system_failure = "~다음 시스템 오류"
	L.break_message = "깨부수기 x%2$d : %1$s"

	L.phase2_message = "곧 치명상 단계!"

	L.warmup = "전투 준비"
	L.warmup_desc = "전투가 시작되기까지의 시간입니다."
end

L = BigWigs:NewBossLocale("Magmaw", "koKR")
if L then
	-- heroic
	L.blazing = "이글거리는 지옥불"
	L.blazing_desc = "이글거리는 지옥불 소환을 알립니다."
	L.blazing_message = "해골 추가!"
	L.blazing_bar = "다음 해골"

	L.phase2 = "2 단계"
	L.phase2_desc = "2 단계 알림과 근접창 체크를 표시합니다."
	L.phase2_message = "2 단계!"
	L.phase2_yell = "이런 곤란한 데가! 이러다간 내 용암" --check

	-- normal
	L.pillar_of_flame_cd = "~불꽃 기둥 대기시간"

	L.slump = "슬럼프 (로데오)"
	L.slump_desc = "슬럼프 상태를 알립니다."
	L.slump_bar = "다음 슬럼프"
	L.slump_message = "올라타세요~!"
	L.slump_trigger = "%s|1이;가; 집게를 드러내며 앞으로 몸을 기울입니다!"

	L.infection_message = "당신은 기생 감염!"

	L.expose_trigger = "%s|1이;가; 창에 꽂혀 머리가 노출되었습니다!"
	L.expose_message = "머리 노출!"

	L.spew_bar = "~다음 용암 내뿜기"
	L.spew_warning = "곧 용암 내뿜기!"

	L.mangle_bar = "짓이기기: %s"
	L.mangle_cooldown = "~다음 짓이기기"
end

L = BigWigs:NewBossLocale("Maloriak", "koKR")
if L then
	--heroic
	L.sludge = "어둠의 폐수"
	L.sludge_desc = "어둠의 폐수에 서있을시 알립니다."
	L.sludge_message = "당신은 폐수!"

	--normal
	L.final_phase = "마지막 단계"
	L.final_phase_soon = "곧 마지막 단계!"

	L.release_aberration_message = "돌연변이 %d 남음"
	L.release_all = "모든 실험체 %d!"

	L.flashfreeze = "~순간 빙결"
	L.next_blast = "~맹렬한 폭발"
	L.jets_bar = "다음 마그마 분출"

	L.phase = "단계"
	L.phase_desc = "단계 변화를 알립니다."
	L.next_phase = "다음 단계"
	L.green_phase_bar = "녹색 단계"

	L.red_phase_trigger = "섞고 흔들어서, 열을 가한다..."
	L.red_phase_emote_trigger = "붉은"
	L.red_phase = "|cFFFF0000붉은|r 단계"
	L.blue_phase_trigger = "급격한 온도 변화에 필멸의 육신"
	L.blue_phase_emote_trigger = "푸른"
	L.blue_phase = "|cFF809FFE푸른|r 단계"
	L.green_phase_trigger = "이건 좀 불안정하지만"
	L.green_phase_emote_trigger = "초록"
	L.green_phase = "|cFF33FF00초록|r 단계"
	L.dark_phase_trigger = "혼합물이 너무 약하구나, 말로리악!"
	L.dark_phase_emote_trigger = "암흑"
	L.dark_phase = "|cFF660099암흑|r 단계"
end

L = BigWigs:NewBossLocale("Nefarian", "koKR")
if L then
	L.phase = "단계"
	L.phase_desc = "단계 변화를 알립니다."

	L.discharge_bar = "~번개 방출 대기시간"

	L.phase_two_trigger = "저주받을 필멸자들!"

	L.phase_three_trigger = "품위있는"

	L.crackle_trigger = "전기가"
	L.crackle_message = "곧 감전!"

	L.shadowblaze_message = "당신은 타오르는중!"

	L.onyxia_power_message = "곧 폭발!"

	L.chromatic_prototype = "오색 실험체" -- 3 adds name
end

L = BigWigs:NewBossLocale("Omnotron Defense System", "koKR")
if L then
	L.nef = "군주 빅터 네파리우스"
	L.nef_desc = "군주 빅터 네파리우스의 기술을 알립니다."

	L.pool = "바닥 웅덩이 폭발"

	L.switch = "전환"
	L.switch_desc = "전환을 알립니다."
	L.switch_message = "%s %s"

	L.next_switch = "다음 활성화"

	--L.nef_trigger1 = "맹독골렘의 화학 물질로 다른 골렘에 피해를 줄 생각이었겠지? 영리한 계획이다만, 그렇게 둘 수는 없지."
	--L.nef_trigger2 = "멍청한 드워프 놈들은 왜 그렇게 룬을 좋아하는지! 적을 도울 수도 있는 걸 도대체 왜 만들었는지 모르겠군."

	L.nef_next = "~다음 기술 버프"

	L.acquiring_target = "대상 획득"

	L.bomb_message = "슬라임이 당신을 추적!"
	L.cloud_message = "당신은 화학 구름!"
	L.protocol_message = "독 폭탄!"

	L.iconomnotron = "활성화 보스 전술"
	L.iconomnotron_desc = "활성화된 보스에 공격대 전술을 지정합니다. (공격대장이나 승급된 사람만이 가능합니다)."
end

