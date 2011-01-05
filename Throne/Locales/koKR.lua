local L = BigWigs:NewBossLocale("Al'Akir", "koKR")
if L then
	L.windburst = (GetSpellInfo(87770))
	
	L.phase3_yell = "그만!"	--check

	L.phase_change = "단계 변화"
	L.phase_change_desc = "단계 변화를 알립니다."
	L.phase_message = "%d 단계"

	L.feedback_message = "역순환 %dx"

	L.you = "당신은 %s!"
end

local L = BigWigs:NewBossLocale("Conclave of Wind", "koKR")
if L then
	L.gather_strength = "힘 모으기: %s"
	
	L.storm_shield = GetSpellInfo(95865)
	L.storm_shield_desc = "폭풍 방패"

	L.full_power = "극의 힘"
	L.full_power_desc = "힘이 극에 달했을시 특별한 능력에 대해 알립니다.(현재 3가지중 미풍에 대해서만 알립니다.)"	--check
	L.gather_strength_emote = "%s의 힘이 극에 달합니다!"

	L.wind_chill = "당신은 바람 한기 중첩 x%s"
end
