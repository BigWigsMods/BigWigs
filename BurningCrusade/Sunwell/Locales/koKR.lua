local L = BigWigs:NewBossLocale("Kil'jaeden", "koKR")
if not L then return end
if L then
	L.bomb_cast = "잠시 후 큰 폭탄!"
	L.bomb_nextbar = "~폭탄 가능"
	L.bomb_warning = "약 10초 이내 폭탄 가능!"

	L.orb = "보호의 구슬"
	L.orb_desc = "보호의 구슬의 어둠 화살을 알립니다."
	L.orb_shooting = "구슬 활동 - 어활 공격!"

	L.shield_up = "푸른용의 보호막!"
	L.deceiver_dies = "심복 #%d 처치"

	L.blueorb = "푸른용군단의 수정구"
	L.blueorb_desc = "푸른용군단의 수정구의 생성을 알립니다."
	L.blueorb_message = "푸른용군단의 수정구 준비됨!"

	L.kalec_yell = "수정구에 힘을 쏟겠습니다! 준비하세요!"
	L.kalec_yell2 = "다른 수정구에 힘을 불어넣었습니다! 어서요!"
	L.kalec_yell3 = "다른 수정구가 준비됐습니다! 서두르세요!"
	L.kalec_yell4 = "모든 힘을 수정구에 실었습니다! 이제 그대들의 몫입니다!"
	L.phase3_trigger = "나를 부정할 수는 없다! 이 세계는 멸망하리라!"
	L.phase4_trigger = "헛된 꿈을 꾸고 있구나! 너흰 이길 수 없어!"
	L.phase5_trigger = "으아! 태양샘의 마력이... 나를... 거부한다! 무슨 짓을 한 거지? 무슨 짓을 한 거냐???"
end

L = BigWigs:NewBossLocale("Felmyst", "koKR")
if L then
	L.phase = "단계"
	L.phase_desc = "이륙과 착지 단계에 대해 알립니다."
	L.airphase_trigger = "나는 어느 때보다도 강하다!"
	L.takeoff_bar = "이륙"
	L.takeoff_message = "5초 이내 이륙!"
	L.landing_bar = "착지"
	L.landing_message = "10초 이내 착지!"

	L.breath = "깊은 숨결"
	L.breath_desc = "깊은 숨결을 알립니다."
end

L = BigWigs:NewBossLocale("Brutallus", "koKR")
if L then
	L.engage_trigger = "하, 새끼 양이 잔뜩 몰려오는구나!"

	L.burnresist = "불사르기 저항"
	L.burnresist_desc = "불사르기에 저항한 플레이어를 알립니다."
	L.burn_resist = "%s 불사르기 저항"
end

L = BigWigs:NewBossLocale("M'uru", "koKR")
if L then
	L.sentinel = "공허의 파수병"
	L.sentinel_desc = "공허의 파수병의 소환을 알립니다."
	L.sentinel_next = "공허의 파수병(%d)"

	L.humanoid = "타락한 엘프"
	L.humanoid_desc = "타락한 엘프 등장을 알립니다."
	L.humanoid_next = "타락한 엘프(%d)"
end

L = BigWigs:NewBossLocale("Kalecgos", "koKR")
if L then
	L.engage_trigger = "으아!! 난 이제 말리고스의 노예가 아니다! 덤벼라, 끝장을 내주마!"
	L.enrage_trigger = "사스로바르가 칼렉고스를 억제할 수 없는 분노의 소용돌이에 빠뜨립니다!"

	L.sathrovarr = "타락의 사스로바르"

	L.portal = "차원문"
	L.portal_message = "약 5초이내 차원문!"

	L.realm_desc = "정신 세계에 들어간 플레이어를 알립니다."
	L.realm_message = "정신 세계: %s (%d 파티)"
	L.nobody = "아무도"

	L.curse = "저주"

	L.wild_magic_healing = "마법 폭주 (힐량 증가)"
	L.wild_magic_healing_desc = "당신이 마법 폭주에 의해 힐량이 증가할때 알려줍니다."
	L.wild_magic_healing_you = "마법 폭주 - 힐량 증가!"

	L.wild_magic_casting = "마법 폭주 (시전시간 지연)"
	L.wild_magic_casting_desc = "힐러가 마법 폭주에 의해 시전시간이 지연될때 알려줍니다."
	L.wild_magic_casting_you = "마법 폭주 - 당신은 시전시간 지연!"
	L.wild_magic_casting_other = "마법 폭주 - %s 시전시간 지연!"

	L.wild_magic_hit = "마법 폭주 (적중률 감소)"
	L.wild_magic_hit_desc = "탱커가 마법 폭주에 의해 적중률이 감소할때 알려줍니다."
	L.wild_magic_hit_you = "마법 폭주 - 당신은 적중률 감소!"
	L.wild_magic_hit_other = "마법 폭주 - %s 적중률 감소!"

	L.wild_magic_threat = "마법 폭주 (위협수준 증가)"
	L.wild_magic_threat_desc = "당신이 마법 폭주에 의해 위협수준이 증가할때 알려줍니다."
	L.wild_magic_threat_you = "마법 폭주 - 위협 생성 증가!"
end

L = BigWigs:NewBossLocale("The Eredar Twins", "koKR")
if L then
	L.lady = "사크로래쉬 #3:"
	L.lock = "알리테스 #2:"

	L.threat = "위협"

	-- L.custom_on_threat = "Threat InfoBox"
	-- L.custom_on_threat_desc = "Show second on threat for Grand Warlock Alythess and third on threat for Lady Sacrolash."
end

