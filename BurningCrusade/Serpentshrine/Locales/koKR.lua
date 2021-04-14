local L = BigWigs:NewBossLocale("Hydross the Unstable", "koKR")
if not L then return end
if L then
	L.start_trigger = "방해하도록 놔두지 않겠습니다!"

	L.mark = "징표"
	L.mark_desc = "징표에 대한 경고와 카운터를 표시합니다."

	L.stance = "태세 변경"
	L.stance_desc = "불안정한 히드로스의 태세 변경 시 경고합니다."
	L.poison_stance = "히드로스 오염!"
	L.water_stance = "히드로스 정화!"

	L.debuff_warn = "징표 - %s%%!"
end

L = BigWigs:NewBossLocale("Fathom-Lord Karathress", "koKR")
if L then
	L.enrage_trigger = "경비병! 여기 침입자들이 있다..."

	L.totem = "불 뿜는 토템"
	L.totem_desc = "불 뿜는 토템을 시전 시 경고합니다."
	L.totem_message1 = "타이달베스: 불뿜는 토템"
	L.totem_message2 = "카라드레스: 불뿜는 토템"
	L.heal_message = "카리브디스 치유 시전!"

	L.priest = "심연의 경비병 카리브디스"
end

L = BigWigs:NewBossLocale("Leotheras the Blind", "koKR")
if L then
	L.enrage_trigger = "드디어, 내가 풀려났도다!"

	L.phase = "악마 형상"
	L.phase_desc = "악마 형상 예측 타이머입니다."
	L.phase_trigger = "꺼져라, 엘프 꼬맹이. 지금부터는 내가 주인이다!"
	L.phase_demon = "60초간 악마 형상"
	L.phase_demonsoon = "악마 형상 5초 전!"
	L.phase_normalsoon = "보통 형상 5초 전"
	L.phase_normal = "보통 형상!"
	L.demon_bar = "악마 형상"
	L.demon_nextbar = "다음 악마 형상"

	L.mindcontrol = "정신 지배"
	L.mindcontrol_desc = "정신 지배에 걸린 플레이어를 알립니다."
	L.mindcontrol_warning = "정신 지배"

	L.image = "이미지"
	L.image_desc = "15% 이미지 분리에 대한 경고입니다."
	L.image_trigger = "안 돼... 안 돼! 무슨 짓이냐? 내가 주인이야! 내 말 듣지 못해? 나란 말이야! 내가... 으아악! 놈을 억누를 수... 없... 어."
	L.image_message = "15% - 이미지 생성!"
	L.image_warning = "곧 이미지!"

	L.whisper = "음흉한 속삭임"
	L.whisper_desc = "음흉한 속삭임에 걸린 플레이어를 알립니다."
	L.whisper_message = "악마"
	L.whisper_bar = "악마 사라짐"
	L.whisper_soon = "~악마 대기시간"
end

L = BigWigs:NewBossLocale("The Lurker Below", "koKR")
if L then
	L.engage_warning = "%s 전투 시작 - 90초 이내 잠수"

	L.dive = "잠수"
	L.dive_desc = "심연의 잠복꾼 잠수 시 타이머입니다."

	L.dive_warning = "%d초 이내 잠수!"
	L.dive_bar = "~잠수"
	L.dive_message = "잠수 - 60초 이내 출현"

	L.spout = "분출"
	L.spout_desc = "분출에 대한 타이머입니다. 항상 정확하지 않을 수 있습니다."
	L.spout_message = "분출 시전 중!"
	L.spout_warning = "약 3초 이내 분출!"
	L.spout_bar = "분출 가능"

	L.emerge_warning = "%d초 이내 출현"
	L.emerge_message = "출현 - 90초 이내 잠수"
	L.emerge_bar = "출현"
end

L = BigWigs:NewBossLocale("Morogrim Tidewalker", "koKR")
if L then
	L.grave_bar = "<수중 무덤>"
	L.grave_nextbar = "~무덤 대기시간"

	L.murloc = "멀록"
	L.murloc_desc = "멀록 등장에 대한 경고입니다."
	L.murloc_bar = "~멀록 등장 대기시간"
	L.murloc_message = "멀록 등장!"
	L.murloc_soon_message = "잠시 후 멀록 등장!"
	L.murloc_engaged = "%s 전투 시작, 약 40초 후 멀록"

	L.globules = "물방울"
	L.globules_desc = "물방울 등장에 대한 경고입니다."
	L.globules_trigger1 = "곧 끝장내주마!"
	L.globules_trigger2 = "숨을 곳은 아무 데도 없다!"
	L.globules_message = "물방울 등장!"
	L.globules_warning = "잠시 후 물방울!"
	L.globules_bar = "물방울 사라짐"
end

L = BigWigs:NewBossLocale("Lady Vashj", "koKR")
if L then
	L.engage_trigger1 = "천한 놈들을 상대하며 품위를 손상시키고 싶진 않았는데... 제 손으로 무덤을 파는구나."
	L.engage_trigger2 = "육지에 사는 더러운 놈들같으니!"
	L.engage_trigger3 = "일리단 군주님께 승리를!"
	L.engage_trigger4 = "머리부터 발끝까지 성치 못할 줄 알아라!"
	L.engage_trigger5 = "침입자들에게 죽음을!"
	L.engage_message = "1단계 시작"

	L.phase = "단계 경고"
	L.phase_desc = "바쉬가 다음 단계로 변경 시 알림니다."
	L.phase2_trigger = "때가 왔다! 한 놈도 살려두지 마라!"
 	L.phase2_soon_message = "잠시 후 2 단계!"
	L.phase2_message = "2 단계, 4 종류의 몹 등장!"
	L.phase3_trigger = "숨을 곳이나 마련해 둬라!"
	L.phase3_message = "3 단계 - 4분 이내 격노!"

	L.elemental = "오염된 정령 등장"
	L.elemental_desc = "2 단계에서 오염된 정령 등장 시 경고합니다."
	L.elemental_bar = "오염된 정령 등장"
	L.elemental_soon_message = "잠시 후 오염된 정령!"

	L.strider = "포자손 등장"
	L.strider_desc = "2 단계에서 포자손 등장 시 경고합니다."
	L.strider_bar = "포자손 등장"
	L.strider_soon_message = "잠시 후 포자손!"

	L.naga = "갈퀴송곳니 정예병 나가 등장"
	L.naga_desc = "2 단계에서 갈퀴송곳니 정예병 나가 등장 시 경고합니다."
	L.naga_bar = "갈퀴송곳니 정예병 등장"
	L.naga_soon_message = "잠시 후 정예병!"

	L.barrier_desc = "보호막 손실 시 알립니다."
	L.barrier_down_message = "보호막 %d/4 손실!"
end

