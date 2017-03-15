local L = BigWigs:NewBossLocale("Skorpyron", "koKR")
if not L then return end
if L then
	L.blue = "푸른색"
	L.red = "붉은색"
	L.green = "녹색"
	L.mode = "%s 모드"
end

L = BigWigs:NewBossLocale("Chronomatic Anomaly", "koKR")
if L then
	L.affected = "영향 받음"
	L.totalAbsorb = "총 흡수"
end

L = BigWigs:NewBossLocale("Trilliax", "koKR")
if L then
	L.yourLink = "당신은 %s|1과;와; 연결됨"
	L.yourLinkShort = "%s|1과;와; 연결됨"
	L.imprint = "피조물"
end

L = BigWigs:NewBossLocale("Tichondrius", "koKR")
if L then
	L.addsKilled = "쫄 처치"
	L.gotEssence = "정수 획득"

	L.adds_desc = "쫄 생성에 대한 타이머와 경보입니다."
	L.adds_yell1 = "부하들아! 이리 와라!"
	L.adds_yell2 = "이 멍청이들에게 싸우는 법을 알려 줘라!"
end

L = BigWigs:NewBossLocale("Krosus", "koKR")
if L then
	L.leftBeam = "왼쪽 광선"
	L.rightBeam = "오른쪽 광선"

	L.goRight = "> 오른쪽 이동 >"
	L.goLeft = "< 왼쪽 이동 <"

	L.smashingBridge = "다리 파괴"
	L.smashingBridge_desc = "다리를 파괴하는 격돌입니다. 이 옵션을 사용하여 강조하거나 초읽기를 활성화할 수 있습니다."

	L.removedFromYou = "당신에게서 %s 사라짐" -- "Searing Brand removed from YOU!"
end

L = BigWigs:NewBossLocale("Star Augur Etraeus", "koKR")
if L then
	L.yourSign = "당신의 별자리"
	L.with = "같은"
	L[205429] = "|T1391538:15:15:0:0:64:64:4:60:4:60|t|cFFFFDD00게|r"
	L[205445] = "|T1391537:15:15:0:0:64:64:4:60:4:60|t|cFFFF0000늑대|r"
	L[216345] = "|T1391536:15:15:0:0:64:64:4:60:4:60|t|cFF00FF00사냥꾼|r"
	L[216344] = "|T1391535:15:15:0:0:64:64:4:60:4:60|t|cFF00DDFF용|r"

	L.nameplate_requirement = "이 기능은 현재 KuiNameplates만 지원됩니다. 신화 난이도만."

	L.custom_off_icy_ejection_nameplates = "아군 이름표에 {206936} 표시" -- Icy Ejection
	L.custom_off_icy_ejection_nameplates_desc = L.nameplate_requirement

	L.custom_on_fel_ejection_nameplates = "아군 이름표에 {205649} 표시" -- Fel Ejection
	L.custom_on_fel_ejection_nameplates_desc = L.nameplate_requirement

	L.custom_on_gravitational_pull_nameplates = "아군 이름표에 {214335} 표시" -- Gravitational Pull
	L.custom_on_gravitational_pull_nameplates_desc = L.nameplate_requirement

	L.custom_on_grand_conjunction_nameplates = "아군 이름표에 {205408} 표시" -- Grand Conjunction
	L.custom_on_grand_conjunction_nameplates_desc = L.nameplate_requirement
end

L = BigWigs:NewBossLocale("Grand Magistrix Elisande", "koKR")
if L then
	L.elisande = "엘리산드"

	L.ring_yell = "시간의 파도가 널 덮치기를!"
	L.orb_yell = "시간은 제멋대로 사라져 버리지."

	L.slowTimeZone = "느린 시간 지역"
	L.fastTimeZone = "빠른 시간 지역"

	L.boss_active = "엘리산드 활성화"
	L.boss_active_desc = "일반몹 이벤트를 끝낸 후에 엘리산드가 활성화되기까지의 시간입니다."
	L.elisande_trigger = "모두 예견했다. 너희를 여기로 이끈 운명의 실마리를. 군단을 막으려는 너희의 필사적인 몸부림을."
end

L = BigWigs:NewBossLocale("Gul'dan", "koKR")
if L then
	L.empowered = "(강화) %s" -- (E) Eye of Gul'dan
	L.gains = "굴단 %s 획득"
	L.p4_mythic_start_yell = "악마사냥꾼의 영혼을 육신으로 돌려보내야 할 때요... 군단의 주인을 거부해야 하오!"

	L.nightorb_desc = "밤의 보주를 소환합니다, 처치하면 시간 지역이 생성됩니다."

	L.manifest_desc = "아지노스의 영혼 파편을 소환합니다, 처치하면 악마의 정수가 생성됩니다."

	L.winds_desc = "굴단이 난폭한 바람을 소환하여 플레이어를 단상에서 밀어냅니다."
end

L = BigWigs:NewBossLocale("Nighthold Trash", "koKR")
if L then
	--[[ Skorpyron to Trilliax ]]--
	L.torm = "육중한 토름"
	L.fulminant = "전격폭풍"
	L.pulsauron = "펄사우론n"

	--[[ Chronomatic Anomaly to Trilliax ]]--
	L.sludgerax = "슬러지락스"

	--[[ Trilliax to Aluriel ]]--
	--L.karzun = "Kar'zun"
	--L.guardian = "Gilded Guardian"
	--L.battle_magus = "Duskwatch Battle-Magus"
	--L.chronowraith = "Chronowraith"
	--L.protector = "Nighthold Protector"

	--[[ Aluriel to Etraeus ]]--
	--L.jarin = "Astrologer Jarin"

	--[[ Aluriel to Telarn ]]--
	--L.weaver = "Duskwatch Weaver"
	--L.archmage = "Shal'dorei Archmage"
	--L.manasaber = "Domesticated Manasaber"
	--L.naturalist = "Shal'dorei Naturalist"

	--[[ Aluriel to Krosus ]]--
	--L.infernal = "Searing Infernal"

	--[[ Aluriel to Tichondrius ]]--
	--L.watcher = "Abyss Watcher"
end
