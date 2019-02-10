local L = BigWigs:NewBossLocale("Battle of Dazar'alor Trash", "koKR")
if not L then return end
if L then
	L.enforcer = "영원의 집행자"
	L.punisher = "라스타리 응징자"
	L.vessel = "브원삼디의 매개체"

	L.victim = "%s 가 당신을 %s 로 찌름!"
	L.witness = "%s 가 %s 를 %s 로 찌름!"
end

L = BigWigs:NewBossLocale("Champion of the Light Horde", "koKR")
if L then
	L.disorient_desc = " |cff71d5ff[눈부신 신념]|r 바 표시.\n주로 신념 카운트 해주는 바를 이걸로 쓰는 것이 편할 것입니다." -- Blinding Faith = 283650
end

L = BigWigs:NewBossLocale("Champion of the Light Alliance", "koKR")
if L then
	L.disorient_desc = "|cff71d5ff[눈부신 신념]|r 바 표시.\n주로 카운트 해주는 바를 이걸로 쓰는 것이 편할 것입니다." -- Blinding Faith = 283650
end

L = BigWigs:NewBossLocale("Jadefire Masters Horde", "koKR")
if L then
	L.custom_on_fixate_plates = "적 네임플레이트에 추적 아이콘 표시"
	L.custom_on_fixate_plates_desc = "당신이 추적 당하면 대상 생명력 바 위에 아이콘 표시.\n적 생명력 표시 사용 필수. 지금은 KuiNameplates에서만 지원함 ."

	L.absorb = "피해 흡수"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "시전"
	L.cast_text = "%.1f초 (|cff%s%.0f%%|r)"

	L.interrupted_after = "%s 가 %s에 의해 차단됨! (%.1f 초 남음!)"
end

L = BigWigs:NewBossLocale("Jadefire Masters Alliance", "koKR")
if L then
	L.custom_on_fixate_plates = "적 네임플레이트에 추적 아이콘 표시"
	L.custom_on_fixate_plates_desc = "당신이 추적 당하면 대상 생명력 바 위에 아이콘 표시.\n적 생명력 표시 사용 필수. 지금은 KuiNameplates에서만 지원함."

	L.absorb = "피해 흡수"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "시전"
	L.cast_text = "%.1f초 (|cff%s%.0f%%|r)"

	L.interrupted_after = "%s 가 %s에 의해 차단됨!(%.1f 초 남음!)"
end

L = BigWigs:NewBossLocale("Opulence", "koKR")
if L then
	--L.room = "방 (%d/8)"
	L.no_jewel = "보석 없음:"
	L.seconds = "%.1f초"

	L.custom_on_fade_out_bars = "1페이지 바 숨기기"
	L.custom_on_fade_out_bars_desc = "1페이지 동안 반대편 피조물 타이머 바 숨기기."

	L.custom_on_hand_timers = "인자쉬의 손"
	L.custom_on_hand_timers_desc = "인자쉬의 손의 능력들에 대한 경보와 바 표시."
	--hand_cast = "Hand: %s"

	L.custom_on_bulwark_timers = "얄랏의 보루"
	L.custom_on_bulwark_timers_desc = "얄랏의 보루의 능력들에 대한 경보와 바 표시."
	--L.bulwark_cast = "Bulwark: %s"
end

L = BigWigs:NewBossLocale("Conclave of the Chosen", "koKR")
if L then
	L.killed = "%s 처치!"
	L.count_of = "%s (%d/%d)"
end

L = BigWigs:NewBossLocale("High Tinker Mekkatorque", "koKR")
if L then
	L.gigavolt_alt_text = "폭탄"

	L.custom_off_sparkbot_marker = "불꽃봇 징표 표시"
	L.custom_off_sparkbot_marker_desc = "불꽃봇에 {rt4}{rt5}{rt6}{rt7}{rt8} 징표로 표시."

	L.custom_off_repeating_shrunk_say = "축소 상태 알림" -- Shrunk = 284168
	L.custom_off_repeating_shrunk_say_desc = "|cff71d5ff[축소]|r의 영향을 받는 동안 계속 채팅으로 알림. 그럼 다른 사람들이 피해갈수도 있겠지"

	L.custom_off_repeating_tampering_say = "로봇 조종 상태 알림" -- Tampering = 286105
	L.custom_off_repeating_tampering_say_desc = "불꽃봇을 컨트롤하는 동안 계속 채팅으로 알림."
end

L = BigWigs:NewBossLocale("Lady Jaina Proudmoore", "koKR")
if L then
	L.starbord_ship_emote = "쿨 티란 함선이 오른쪽에서 접근!"
	L.port_side_ship_emote = "쿨 티란 함선이 왼쪽에서 접근!"

	--L.starbord_txt = "Right Ship" -- starboard
	--L.port_side_txt = "Left Ship" -- port

	--L.ship_icon = "inv_garrison_cargoship"

	L.custom_on_stop_timers = "능력 바 항상 표시"
	L.custom_on_stop_timers_desc = "제이나는 쿨이 온 기술들을 무작위로 사용합니다. 이 옵션이 활성화되면, 다음 쓸 수 있는 능력들을 표시하는 바가 화면에 남아있습니다.."

	L.frozenblood_player = "%s (%d 명)"

	L.intermission_stage2 = "Stage 2 - %.1f 초"
end
