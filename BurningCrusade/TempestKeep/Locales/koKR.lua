local L = BigWigs:NewBossLocale("Void Reaver", "koKR")
if not L then return end
if L then
	L.engage_trigger = "경고! 제거 대상 발견!"
end

L = BigWigs:NewBossLocale("High Astromancer Solarian", "koKR")
if L then
	L.engage_trigger = "탈 아누멘 노 신도레이!"

	L.phase = "단계"
	L.phase_desc = "단계 변경에 대해 알립니다."
	L.phase1_message = "1 단계 - 약 50초 이내 분리"
	L.phase2_warning = "잠시 후 2 단계!"
	L.phase2_trigger = "^나는 공허의"
	L.phase2_message = "20% - 2 단계"

	L.wrath_other = "분노"

	L.split = "분리"
	L.split_desc = "분리와 소환에 대한 경고입니다."
	L.split_trigger1 = "그 오만한 콧대를 꺾어주마!"
	L.split_trigger2 = "한 줌의 희망마저 짓밟아주마!"
	L.split_bar = "~다음 분리"
	L.split_warning = "약 7초 이내 분리"

	L.agent_warning = "분리! - 6초 이내 요원"
	L.agent_bar = "요원"
	L.priest_warning = "3초 이내 사제/솔라리안"
	L.priest_bar = "사제/솔라리안"
end

L = BigWigs:NewBossLocale("Kael'thas Sunstrider", "koKR")
if L then
	L.engage_trigger = "^나의 백성은"
	L.engage_message = "1 단계"

	L.gaze = "주시"
	L.gaze_desc = "플레이어에게 탈라드레드의 주시를 경고합니다."
	L.gaze_trigger = "노려봅니다"

	L.fear_soon_message = "잠시 후 공포!"
	L.fear_message = "공포!"
	L.fear_bar = "~공포 대기 시간"

	L.rebirth = "불사조 환생"
	L.rebirth_desc = "불사조 환생 접근 타이머입니다."
	L.rebirth_warning = "5초 이내 불사조 환생!"
	L.rebirth_bar = "~환생 가능"

	L.pyro = "불덩이 작렬"
	L.pyro_desc = "불덩이 작렬에 대한 60초 타이머를 표시합니다."
	L.pyro_trigger = "%s|1이;가; 불덩이 작렬을 시전합니다!"
	L.pyro_warning = "약 5초 이내 불덩이 작렬!"
	L.pyro_message = "불덩이 작렬 시전!"

	L.phase = "단계 경고"
	L.phase_desc = "단계 변경에 대해 알립니다."
	L.thaladred_inc_trigger = "암흑의 인도자 탈라드레드를 상대로 얼마나 버틸지 볼까?"
	L.sanguinar_inc_trigger = "최고의 조언가를 상대로 잘도 버텨냈군. 허나 그 누구도 붉은 망치의 힘에는 대항할 수 없지. 보아라, 군주 생귀나르를!"
	L.capernian_inc_trigger = "카퍼니안, 놈들이 여기 온 것을 후회하게 해 줘라."
	L.telonicus_inc_trigger = "좋아, 그 정도 실력이면 수석기술자 텔로니쿠스를 상대해 볼만하겠어."
	L.weapons_inc_trigger = "보다시피 내 무기고에는 굉장한 무기가 아주 많지."
	L.phase3_trigger = "네놈들을 과소평가했나 보군. 모두를 한꺼번에 상대하라는 건 불공평한 처사지만, 나의 백성도 공평한 대접을 받은 적 없기는 매한가지. 받은 대로 돌려주겠다."
	L.phase4_trigger = "때론 직접 나서야 할 때도 있는 법이지. 발라모어 샤날!"

	L.flying_trigger = "이대로 물러날 내가 아니다! 반드시 내가 설계한 미래를 실현하리라! 이제 진정한 힘을 느껴 보아라!"
	L.flying_message = "5 단계 - 1분후 중력 붕괴"

	L.weapons_inc_message = "2 단계 - 무기 임박!"
	L.phase3_message = "3 단계 - 조언가와 무기!"
	L.phase4_message = "4 단계 - 캘타스!"
	L.phase4_bar = "잠시 후 캘타스"

	L.mc = "정신 지배"
	L.mc_desc = "정신 지배에 걸린 플레이어를 알립니다."

	L.revive_bar = "조언가 부활"
	L.revive_warning = "5초 이내 조언가 부활!"

	L.dead_message = "%s 처치! 루팅하세요!"

	L.capernian = "대점성술사 카퍼니안"
	L.sanguinar = "군주 생귀나르"
	L.telonicus = "수석기술자 텔로니쿠스"
	L.thaladred = "암흑의 인도자 탈라드레드"
end

