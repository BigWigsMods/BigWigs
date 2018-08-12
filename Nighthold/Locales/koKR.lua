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
	L.timeLeft = "%.1fs" -- s = seconds
end

L = BigWigs:NewBossLocale("Trilliax", "koKR")
if L then
	L.yourLink = "당신은 %s|1과;와; 연결됨"
	L.yourLinkShort = "%s|1과;와; 연결됨"
	L.imprint = "인격"
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
	L.with = "같음"
	L[205429] = "|T1391538:15:15:0:0:64:64:4:60:4:60|t|cFFFFDD00게|r"
	L[205445] = "|T1391537:15:15:0:0:64:64:4:60:4:60|t|cFFFF0000늑대|r"
	L[216345] = "|T1391536:15:15:0:0:64:64:4:60:4:60|t|cFF00FF00사냥꾼|r"
	L[216344] = "|T1391535:15:15:0:0:64:64:4:60:4:60|t|cFF00DDFF용|r"
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
	L.warmup_trigger = "부서진 해변에서의 치욕을 잊었느냐?"
        --    Horde : 부서진 해변에서의 치욕을 잊었느냐? 너희의 그 잘난 족장이 나약한 돼지 새끼처럼 배를 찔린 것을 잊었나? 그자처럼, 너희도 지옥의 타락에 물든 채 제발 죽여 달라고 빌며 서서히 죽어 갈 작정이냐?
        -- Alliance : 부서진 해변에서의 치욕을 잊었느냐? 너희의 그 소중한 왕이 내 앞에서 부서지고 망가진 모습을 잊었나? 그자가 그랬듯, 개처럼 낑낑대며 목숨을 구걸할 작정이냐?

	L.empowered = "(강화) %s" -- (E) Eye of Gul'dan
	L.gains = "굴단 %s 획득"
	L.p4_mythic_start_yell = "악마사냥꾼의 영혼을 육신으로 돌려보내야 할 때요... 군단의 주인을 거부해야 하오!"

	L.nightorb_desc = "밤의 보주를 소환합니다, 처치하면 시간 지역이 생성됩니다."
	L.timeStopZone = "시간 정지 지역"

	L.manifest_desc = "아지노스의 영혼 파편을 소환합니다, 처치하면 악마의 정수가 생성됩니다."

	L.winds_desc = "굴단이 난폭한 바람을 소환하여 플레이어를 단상에서 밀어냅니다."
end

L = BigWigs:NewBossLocale("Nighthold Trash", "koKR")
if L then
	--[[ Skorpyron to Trilliax ]]--
	L.torm = "육중한 토름"
	L.fulminant = "전격폭풍"
	L.pulsauron = "펄사우론"

	--[[ Chronomatic Anomaly to Trilliax ]]--
	L.sludgerax = "슬러지락스"

	--[[ Trilliax to Aluriel ]]--
	L.karzun = "카르준"
	L.guardian = "금박 수호자"
	L.battle_magus = "황혼감시대 전투마법사"
	L.chronowraith = "시간격노"
	L.protector = "밤의 요새 수호자"

	--[[ Aluriel to Etraeus ]]--
	L.jarin = "점성술사 자린"

	--[[ Aluriel to Telarn ]]--
	L.defender = "별의 수호병"
	L.weaver = "황혼감시대 역술사"
	L.archmage = "샬도레이 대마법사"
	L.manasaber = "길들인 마나호랑이"
	L.naturalist = "샬도레이 박물학자"

	--[[ Aluriel to Krosus ]]--
	L.infernal = "불타는 지옥불정령"

	--[[ Aluriel to Tichondrius ]]--
	L.chaosmage = "지옥서약 혼돈마법사"
	L.watcher = "심연 감시자"
end
