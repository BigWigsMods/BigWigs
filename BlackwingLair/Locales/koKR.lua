local L = BigWigs:NewBossLocale("Razorgore the Untamed", "koKR")
if not L then return end
if L then
	L.bossName = "폭군 서슬송곳니"
	L.start_trigger = "침입자들이 들어왔다! 어떤 희생이 있더라도 알을 반드시 수호하라!"
	L.start_message = "폭군 서슬송곳니 전투 시작"
	L.start_soon = "몹 소환 5초전!"
	L.start_mob = "몹 소환"

	L.eggs = "알 개수 알림 미사용"
	L.eggs_desc = "남은 알 개수 알림 미사용"
	L.eggs_message = "%d/30 알을 파괴하였습니다."

	L.phase2_message = "모든 알이 파괴되었습니다, 서슬송곳니가 풀려납니다." -- CHECK
end

L = BigWigs:NewBossLocale("Vaelastrasz the Corrupt", "koKR")
if L then
	L.bossName = "타락한 밸라스트라즈"
end

L = BigWigs:NewBossLocale("Broodlord Lashlayer", "koKR")
if L then
	L.bossName = "용기대장 래쉬레이어"
end

L = BigWigs:NewBossLocale("Firemaw", "koKR")
if L then
	L.bossName = "화염아귀"
end

L = BigWigs:NewBossLocale("Ebonroc", "koKR")
if L then
	L.bossName = "에본로크"
end

L = BigWigs:NewBossLocale("Flamegor", "koKR")
if L then
	L.bossName = "플레임고르"
end

L = BigWigs:NewBossLocale("Chromaggus", "koKR")
if L then
	L.bossName = "크로마구스"
	L.breath = "브레스 경고"
	L.breath_desc = "브레스에 대한 경고"

	--L.debuffs_message = "3/5 debuffs, carefull!"
	--L.debuffs_warning = "4/5 debuffs, %s on 5th!"
end

L = BigWigs:NewBossLocale("NefarianBWL", "koKR")
if L then
	L.bossName = "네파리안"
	L.landing_soon_trigger = "적들의 사기가 떨어지고 있다"
	L.landing_trigger = "불타라! 활활!"
	L.zerg_trigger = "말도 안 돼! 일어나라!"

	L.triggershamans = "주술사"
	L.triggerwarlock = "흑마법사여, 네가 이해하지도 못하는"
	L.triggerhunter = "그 장난감"
	L.triggermage = "네가 마법사냐?"

	L.landing_soon_warning = "네파리안이 10초 후 착지합니다!"
	L.landing_warning = "네파리안이 착지했습니다!"
	L.zerg_warning = "해골 등장!"
	L.classcall_warning = "곧 직업이 지목됩니다!"

	L.warnshaman = "주술사 - 토템 파괴!"
	L.warndruid = "드루이드 - 강제 표범 변신!"
	L.warnwarlock = "흑마법사 - 지옥불정령 등장!"
	L.warnpriest = "사제 - 치유 주문 금지!"
	L.warnhunter = "사냥꾼 - 원거리 무기 파손!"
	L.warnwarrior = "전사 - 광태 강제 전환!"
	L.warnrogue = "도적 - 강제 소환!"
	L.warnpaladin = "성기사 - 강제 보축 사용!"
	L.warnmage = "마법사 - 변이!"

	L.classcall_bar = "직업 지목"

	L.classcall = "직업 지목 경고"
	L.classcall_desc = "직업 지목에 대한 경고"

	L.otherwarn = "기타 경고"
	L.otherwarn_desc = "착지와 소환에 대한 경고"
end

