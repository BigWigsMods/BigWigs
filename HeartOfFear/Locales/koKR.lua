local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "koKR")
if not L then return end
if L then
	L.engage_yell = "신성하신 분께서 당신의 신성한 뜻을 실현하라고 우리에게 목소리를 주셨다. 우리는 도구일 뿐이다."
	L.force_message = "힘과 활력"

	L.attenuation = EJ_GetSectionInfo(6426) .. " (Discs)"
	L.attenuation_bar = "Discs... Dance!"
	L.attenuation_message = "%s Dancing %s"
	L.echo = "|c001cc986감쇠|r"
	L.zorlok = "|c00ed1ffa조르로크|r"
	L.left = "|c00008000<- 왼쪽 <-|r"
	L.right = "|c00FF0000-> 오른쪽 ->|r"

	L.platform_emote = "단상" -- 황실 장로 조르로크가 단상으로 날아갑니다!
	L.platform_emote_final = "열광" -- 황실 장로 조르로크가 열광의 페로몬을 들이마십니다!
	L.platform_message = "단상 변경"
end

L = BigWigs:NewBossLocale("Blade Lord Ta'yak", "koKR")
if L then
	L.engage_yell = "무기를 들어라. 나, 칼날군주 타마크가 상대해주마."

	L.unseenstrike_soon = "보이지 않는 일격 (%d) ~ 5-10초 전!"
	L.assault_message = "압도적인 공격"
	L.side_swap = "복도 전환" -- Side Swap

	--L.custom_off_windstep = "Wind step marker"
	--L.custom_off_windstep_desc = "To help healing assignments, mark the people who have wind step on them with {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}, requires promoted or leader."
end

L = BigWigs:NewBossLocale("Garalon", "koKR")
if L then
	L.phase2_trigger = "가랄론의 육중한 장갑이 갈라지면서 쪼개지기 시작합니다!"

	L.removed = "%s 사라짐!"
end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "koKR")
if L then
	L.spear_removed = "당신의 꿰뚫는 창이 제거되었습니다!"

	L.mending_desc = "|cFFFF0000경고: 모든 자르티크 전쟁치유사들이 별도의 치유 재사용 대기시간을 가지고 있기 때문에 주시대상에 대한 타이머를 표시합니다.|r "
	L.mending_warning = "당신의 주시대상이 치유 주문 시전!"
	L.mending_bar = "주시대상: 전쟁치유사"
end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "koKR")
if L then
	L.explosion_by_other = "몬스터/주시대상의 호박석 폭발 재사용 대기시간 바"
	L.explosion_by_other_desc = "호박석 괴수나 주시대상의 호박석 폭발에 대한 재사용 대기시간이나 바를 표시합니다."

	L.explosion_casting_by_other = "몬스터/주시대상의 호박석 폭발 시전 바"
	L.explosion_casting_by_other_desc = "호박석 회수나 당신의 주시대상의 호박석 폭발 시전을 경고합니다. 이것을 강조하는걸 추천합니다!"

	L.explosion_by_you = "자신의 호박석 폭발 대기시간"
	L.explosion_by_you_desc = "자신의 호박석 폭발 재사용 대기시간을 경고합니다."
	L.explosion_by_you_bar = "당신이 폭발 시전 시작..."

	L.explosion_casting_by_you = "자신의 호박석 폭발 시전 바"
	L.explosion_casting_by_you_desc = "자신의 호박석 폭발 시작 시전을 경고합니다. 이것을 강조하는걸 추천합니다!"

	L.willpower = "의지력"
	L.willpower_message = "%d 의지력!"

	L.break_free_message = "%d%%의 생명력!"
	L.fling_message = "내던지기!"
	L.parasite = "기생충"

	L.monstrosity_is_casting = "괴수: 폭발"
	L.you_are_casting = "당신이 시전중!"

	L.unsok_short = "우두머리"
	L.monstrosity_short = "괴수"
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "koKR")
if L then
	L.engage_trigger = "내 제국에 맞서는 모든 이들에게 죽음을!"

	L.phases = "단계"
	L.phases_desc = "단계 변경을 경고합니다."

	L.eyes = "여제의 눈"
	L.eyes_desc = "여제의 눈 중첩과 지속시간 바를 표시합니다."
	L.eyes_message = "눈"

	L.visions_message = "파멸의 환영" -- Visions
	L.visions_dispel = "플레이어 파멸의 환영!" -- Players have been feared!
	L.fumes_bar = "Your fumes buff"
end