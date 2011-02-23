
local L = BigWigs:NewBossLocale("Al'Akir", "koKR")
if not L then return end
if L then
	L.stormling = "작은 폭풍 정령"
	L.stormling_desc = "작은 폭풍 정령 소환을 알립니다."
	L.stormling_message = "곧 폭풍 정령!"
	L.stormling_bar = "다음 폭풍 정령"
	L.stormling_yell = "폭풍이여! 너를 소환하노라!"

	L.acid_rain = "산성 비 (%d)"

	L.phase3_yell = "그만!" --check

	L.phase = "단계 변화"
	L.phase_desc = "단계 변화를 알립니다."

	L.cloud_message = "번개 구름!"
	L.feedback_message = "역순환 x%d"
end

L = BigWigs:NewBossLocale("Conclave of Wind", "koKR")
if L then
	L.gather_strength = "힘 모으기: %s"

	L.storm_shield = GetSpellInfo(95865)
	L.storm_shield_desc = "폭풍 방패"

	L.full_power = "극의 힘"
	L.full_power_desc = "힘이 극에 달했을시 특별한 능력에 대해 알립니다.(현재 3가지중 미풍에 대해서만 알립니다.)" --check
	L.gather_strength_emote = "%s의 힘이 극"	--check

	L.wind_chill = "당신은 바람 한기 중첩 x%s"
end

