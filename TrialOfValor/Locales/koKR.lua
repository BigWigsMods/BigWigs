local L = BigWigs:NewBossLocale("Odyn-TrialOfValor", "koKR")
if not L then return end
if L then
	L.yields = "%s 굴복함" -- used when Hymdall and Helya leave the fight in P2: "Hymdall yields"
	L[227490] = "|cFF800080우측 상단|r (|T1323037:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Purple
	L[227491] = "|cFFFFA500우측 하단|r (|T1323039:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Orange
	L[227498] = "|cFFFFFF00좌측 하단|r (|T1323038:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Yellow
	L[227499] = "|cFF0000FF좌측 상단|r (|T1323035:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Blue
	L[227500] = "|cFF008000상단|r (|T1323036:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Green
end

L = BigWigs:NewBossLocale("Guarm-TrialOfValor", "koKR")
if L then
	L.lick = "혓바닥" -- For translators: common name of 228248, 228253, 228228
	L.lick_desc = "다른 혓바닥 바를 표시합니다."
end

L = BigWigs:NewBossLocale("Helya-TrialOfValor", "koKR")
if L then
	L.nearTrigger = "가까운 곳" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t %s가 헬리아와 가까운 곳에 나타납니다! -- Translate this comment with the emote
	L.farTrigger = "먼 곳" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t %s가 헬리아와 먼 곳에 나타납니다! -- Translate this comment with the emote
	L.tentacle_near = "헬리아 근처 촉수"
	L.tentacle_near_desc = "후려치는 촉수가 헬리아와 가까운 곳에 나타났을 때 메시지를 강조하거나 숨기는 데 이 옵션을 사용할 수 있습니다."
	L.tentacle_far = "헬리아 먼 곳 촉수"
	L.tentacle_far_desc = "후려치는 촉수가 헬리아와 먼 곳에 나타났을 때 메시지를 강조하거나 숨기는 데 이 옵션을 사용할 수 있습니다."

	L.orb_melee = "보주: 근접 타이머"
	L.orb_melee_desc = "근접 거리에 생성되는 보주의 타이머를 표시합니다."
	L.orb_melee_bar = "근접 거리 보주"

	L.orb_ranged = "보주: 원거리 타이머"
	L.orb_ranged_desc = "원거리에 생성되는 보주의 타이머를 표시합니다."
	L.orb_ranged_bar = "원거리 보주"

	L.orb_say = "보주"
	L.taint_say = "오염물"
end
