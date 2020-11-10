local L = BigWigs:NewBossLocale("Anub'Rekhan", "koKR")
if not L then return end
if L then
	L.bossName = "아눕레칸"

	L.gainwarn10sec = "10초 이내 메뚜기 떼"
	L.gainincbar = "다음 메뚜기 떼"
end

L = BigWigs:NewBossLocale("Grand Widow Faerlina", "koKR")
if L then
	L.bossName = "귀부인 팰리나"

	L.silencewarn = "침묵!"
	L.silencewarn5sec = "5초 후 침묵 종료!"
end

L = BigWigs:NewBossLocale("Gluth", "koKR")
if L then
	L.bossName = "글루스"

	L.startwarn = "글루스 전투 시작! 약 105초 후 좀비 척살!"

	L.decimatesoonwarn = "잠시 후 척살!"
	L.decimatebartext = "좀비 척살"
end

L = BigWigs:NewBossLocale("Gothik the Harvester", "koKR")
if L then
	L.bossName = "영혼 착취자 고딕"

	L.room = "고딕 등장 알림"
	L.room_desc = "고딕 등장을 알립니다."

	L.add = "추가 몹 알림"
	L.add_desc = "추가 몹을 알립니다."

	L.adddeath = "추가 몹 죽음 알림"
	L.adddeath_desc = "추가된 몹 죽음을 알립니다."

	L.starttrigger1 = "어리석은 것들, 스스로 죽음을 자초하다니!"
	L.starttrigger2 = "Teamanare shi rikk mannor rikk lok karkun" -- CHECK
	L.startwarn = "영혼 착취자 고딕 전투 시작! 4:30 후 고딕 등장."

	L.rider = "무자비한 죽음의 기병"
	L.spectral_rider = "기병 망령"
	L.deathknight = "무자비한 죽음의 기사"
	L.spectral_deathknight = "죽음의 기사 망령"
	L.trainee = "무자비한 수습생"
	L.spectral_trainee = "수습생 유령"

	L.riderdiewarn = "기병 죽음!"
	L.dkdiewarn = "죽음의 기사 죽음!"

	L.warn1 = "고딕 등장 3분 전"
	L.warn2 = "고딕 등장 90초 전"
	L.warn3 = "고딕 등장 60초 전"
	L.warn4 = "고딕 등장 30초 전"
	L.warn5 = "고딕 등장 10초 전"

	L.wave = "%d/23: %s"

	L.trawarn = "수습생 3초 후 등장"
	L.dkwarn = "죽음의 기사 3초 후 등장"
	L.riderwarn = "기병 3초 후 등장"

	L.trabar = "수습생 - %d"
	L.dkbar = "죽음의 기사 - %d"
	L.riderbar = "기병 - %d"

	L.inroomtrigger = "오랫동안 기다렸다. 이제 영혼 착취자를 만날 차례다."
	L.inroomwarn = "고딕 등장!!"

	L.inroombartext = "고딕 등장"
end

L = BigWigs:NewBossLocale("Grobbulus", "koKR")
if L then
	L.bossName = "그라불루스"

	L.bomb_message = "돌연변이 유발"
	L.bomb_message_other = "돌연변이 유발: %s!"
end

L = BigWigs:NewBossLocale("Heigan the Unclean", "koKR")
if L then
	L.bossName = "부정의 헤이건"

	L.starttrigger = "이제 넌 내 것이다."
	L.starttrigger2 = "다음은... 너다."
	L.starttrigger3 = "네가 보인다..."

	L.engage = "전투 시작"
	L.engage_desc = "헤이건 전투 시작을 알립니다."
	L.engage_message = "부정의 헤이건, 90초 후 단상으로 순간 이동"

	L.teleport = "순간이동"
	L.teleport_desc = "순간이동을 알립니다."
	L.teleport_trigger = "여기가 너희 무덤이 되리라."
	L.teleport_1min_message = "60초 후 순간이동!"
	L.teleport_30sec_message = "30초 후 순간이동!"
	L.teleport_10sec_message = "10초 후 순간이동!"
	L.on_platform_message = "순간이동! 45초간 단상!"

	L.to_floor_30sec_message = "30초 후 단상 내려옴!"
	L.to_floor_10sec_message = "10초 후 단상 내려옴!"
	L.on_floor_message = "헤이건 내려옴! 90초 후 순간이동!"

	L.teleport_bar = "순간이동!"
	L.back_bar = "단상으로 이동!"
end

L = BigWigs:NewBossLocale("The Four Horsemen", "koKR")
if L then
	L.bossName = "4인 기사단"

	L.mark = "징표"
	L.mark_desc = "징표를 알립니다."

	L.markbar = "징표 (%d)"
	L.markwarn1 = "징표(%d)!"
	L.markwarn2 = "5초 후 징표(%d)"

	L.startwarn = "4인의 기병대 전투 시작! 약 17초 이내 징표"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "koKR")
if L then
	L.bossName = "켈투자드"
	L.KELTHUZADCHAMBERLOCALIZEDLOLHAX = "켈투자드의 방"

	L.start_trigger = "어둠의 문지기와 하수인, 그리고 병사들이여! 나 켈투자드가 부르니 명을 받들라!"
	L.start_warning = "켈투자드 전투 시작! 약 3분 30초 후 활동!"

	L.phase2_trigger1 = "자비를 구하라!" -- CHECK
	L.phase2_trigger2 = "마지막 숨이나 쉬어라!"
	L.phase2_trigger3 = "최후를 맞이하라!"
	L.phase2_warning = "2 단계, 켈투자드!"
	L.phase2_bar = "켈투자드 활동!"

	L.phase3_trigger = "주인님, 도와주소서!"
	L.phase3_soon_warning = "잠시 후 3 단계!"
	L.phase3_warning = "3 단계, 약 15초 이내 수호자 등장!"

	L.guardians = "수호자 생성"
	L.guardians_desc = "3 단계의 수호자 소환을 알립니다."
	L.guardians_trigger = "좋다. 얼어붙은 땅의 전사들이여, 일어나라! 너희에게 싸울 것을 명하노라. 날 위해 죽고, 날 위해 죽여라! 한 놈도 살려두지 마라!"
	L.guardians_warning = "10초 이내 수호자 등장!"
	L.guardians_bar = "수호자 등장!"
end

L = BigWigs:NewBossLocale("Loatheb", "koKR")
if L then
	L.bossName = "로데브"

	L.startwarn = "로데브 전투시작!, 2분 후 피할 수 없는 파멸!"

	L.aura_message = "강령술의 오라 - 17초 지속!"
	L.aura_warning = "3초 후 강령술의 오라 사라짐!"

	L.deathbloom_warning = "5초 후 죽음의 꽃!"

	L.doombar = "피할 수 없는 파멸 %d"
	L.doomwarn = "피할 수 없는 파멸 %d! 다음은 %d초 후!"
	L.doomwarn5sec = "5초 후 피할 수 없는 파멸 %d!"
	L.doomtimerbar = "파멸 - 매 15초"
	L.doomtimerwarn = "%s초 후로 피할 수 없는 파멸의 시간변경!"
	L.doomtimerwarnnow = "피할 수 없는 파멸! 지금부터 매 15초마다."

	L.sporewarn = "포자 %d 소환됨!"
	L.sporebar = "포자 소환! %d"
end

L = BigWigs:NewBossLocale("Noth the Plaguebringer", "koKR")
if L then
	L.bossName = "역병술사 노스"

	L.starttrigger1 = "죽어라, 침입자들아!"
	L.starttrigger2 = "주인님께 영광을!"
	L.starttrigger3 = "너희 생명은 끝이다!"
	L.startwarn = "역병술사 노스와 전투 시작! 90초 후 순간이동"

	L.blink = "점멸"
	L.blink_desc = "점멸을 알립니다."
	L.blinktrigger = "%s|1이;가; 눈 깜짝할 사이에 도망칩니다!"
	L.blinkwarn = "점멸! 어그로 초기화!"
	L.blinkwarn2 = "약 5초 이내 점멸 가능!"
	L.blinkbar = "점멸"

	L.teleport = "순간이동"
	L.teleport_desc = "순간이동을 알립니다."
	L.teleportbar = "순간이동!"
	L.backbar = "방으로 복귀!"
	L.teleportwarn = "발코니로 순간이동!"
	L.teleportwarn2 = "10초 후 순간이동!"
	L.backwarn = "방으로 복귀! %d 초간 최대한 공격!"
	L.backwarn2 = "10초 후 방으로 복귀!"

	L.curseexplosion = "역병술사의 저주!"
	L.cursewarn = "저주! 다음 저주 약 55초 이내"
	L.curse10secwarn = "약 10초 이내 저주"
	L.cursebar = "다음 저주"

	L.wave = "웨이브"
	L.wave_desc = "웨이브를 알립니다."
	L.addtrigger = "일어나라,병사들이여! 다시 일어나 싸워라!"
	L.wave1bar = "웨이브 1"
	L.wave2bar = "웨이브 2"
	L.wave2_message = "10초 이내 웨이브 2"
end

L = BigWigs:NewBossLocale("Patchwerk", "koKR")
if L then
	L.bossName = "패치워크"

	L.enragewarn = "5% - 광기!"
end

L = BigWigs:NewBossLocale("Maexxna", "koKR")
if L then
	L.bossName = "맥스나"

	L.webspraywarn30sec = "10초 이내 거미줄 감싸기"
	L.webspraywarn20sec = "거미줄 감싸기. 10초 후 거미 소환!"
	L.webspraywarn10sec = "거미 소환. 10초 후 거미줄 뿌리기!"
	L.webspraywarn5sec = "5초 후 거미줄 뿌리기!"
	L.enragewarn = "광기!"
	L.enragesoonwarn = "잠시 후 광기!"

	L.cocoonbar = "거미줄 감싸기"
	L.spiderbar = "거미 소환"
end

L = BigWigs:NewBossLocale("Sapphiron", "koKR")
if L then
	L.bossName = "사피론"

	L.deepbreath_trigger = "%s|1이;가; 숨을 깊게 들이쉽니다."

	-- L.air_phase = "Air phase"
	-- L.ground_phase = "Ground phase"

	L.deepbreath = "얼음 폭탄"
	L.deepbreath_warning = "잠시 후 얼음 폭탄!"
	L.deepbreath_bar = "얼음 폭탄 떨어짐!"

	L.icebolt_say = "저 방패에요!"
end

L = BigWigs:NewBossLocale("Instructor Razuvious", "koKR")
if L then
	L.bossName = "훈련교관 라주비어스"
	L.understudy = "죽음의 기사 수습생"

	L.taunt_warning = "5초 후 도발 종료!"
	L.shieldwall_warning = "5초 후 방패의 벽 종료!"
end

L = BigWigs:NewBossLocale("Thaddius", "koKR")
if L then
	L.bossName = "타디우스"

	L.phase = "단계 변경"
	L.phase_desc = "단계 변경을 알립니다."

	L.throw = "던지기"
	L.throw_desc = "탱커 위치 교체를 알립니다."

	L.trigger_phase1_1 = "스탈라그, 박살낸다!"
	L.trigger_phase1_2 = "너 주인님께 바칠꺼야!"
	L.trigger_phase2_1 = "잡아... 먹어주마..."
	L.trigger_phase2_2 = "박살을 내주겠다!"
	L.trigger_phase2_3 = "죽여주마..."

	L.polarity_trigger = "자, 고통을 느껴봐라..."
	L.polarity_message = "타디우스 극성 변환 시전!"
	L.polarity_warning = "3초 이내 극성 변환!"
	L.polarity_bar = "극성 변환"
	L.polarity_changed = "극성 변경됨!"
	L.polarity_nochange = "같은 극성!"

	L.polarity_first_positive = "당신은 플러스!"
	L.polarity_first_negative = "당신은 마이너스!"

	L.phase1_message = "타디우스 1 단계"
	L.phase2_message = "타디우스 2 단계, 6분 후 격노!"

	L.surge_message = "스탈라그 마력의 쇄도!"

	L.throw_bar = "던지기"
	L.throw_warning = "약 5초 후 던지기!"
end
