local L = BigWigs:NewBossLocale("Harjatan the Bludger", "koKR")
if not L then return end
if L then
	L.custom_on_fixate_plates = "적 이름표에 시선 고정 아이콘"
	L.custom_on_fixate_plates_desc = "당신에게 시선을 고정한 대상 이름표에 아이콘을 표시합니다.\n적 이름표를 사용해야 합니다. 이 기능은 현재 KuiNameplates만 지원합니다."
end

L = BigWigs:NewBossLocale("Demonic Inquisition", "koKR")
if L then
	L.custom_on_fixate_plates = "적 이름표에 시선 고정 아이콘"
	L.custom_on_fixate_plates_desc = "당신에게 시선을 고정한 대상 이름표에 아이콘을 표시합니다.\n적 이름표를 사용해야 합니다. 이 기능은 현재 KuiNameplates만 지원합니다."

	L.infobox_title_prisoners = "%d 죄수"

	L.custom_on_stop_timers = "능력 바 항상 표시"
	L.custom_on_stop_timers_desc = "악마 심문관은 시전 방해/다른 시전에 의해 시전이 지연되는 주문을 사용합니다. 이 옵션을 사용하면 이 능력들의 바가 화면에 유지됩니다."
end

L = BigWigs:NewBossLocale("Mistress Sassz'ine", "koKR")
if L then
	L.inks_fed_count = "먹물 (%d/%d)"
	L.inks_fed = "먹은 먹물: %s" -- %s = List of players
end

L = BigWigs:NewBossLocale("The Desolate Host", "koKR")
if L then
	L.infobox_players = "플레이어"
	L.armor_remaining = "%s 남음 (%d)" -- Bonecage Armor Remaining (#)
	L.custom_on_mythic_armor = "신화 난이도에서 되살아난 기사단원의 뼈껍질 방어구 무시하기"
	L.custom_on_mythic_armor_desc = "되살아난 기사단원을 방어 중이지 않을 때 되살아난 기사단원의 뼈껍질 방어구에 대한 경보와 횟수를 무시하려면 이 옵션을 활성화하세요"
	L.custom_on_armor_plates = "적 이름표에 뼈껍질 방어구 아이콘"
	L.custom_on_armor_plates_desc = "뼈껍질 방어구를 가진 되살아난 기사단원의 이름표에 아이콘을 표시합니다.\n적 이름표를 사용해야 합니다. 이 기능은 현재 KuiNameplates만 지원합니다."
	L.tormentingCriesSay = "외침" -- Tormenting Cries (short say)
end

L = BigWigs:NewBossLocale("Maiden of Vigilance", "koKR")
if L then
	L.infusionChanged = "주입 변경: %s"
	L.sameInfusion = "같은 주입: %s"
	L.fel = "지옥"
	L.light = "빛"
	L.felHammer = "지옥 망치" -- Better name for "Hammer of Obliteration"
	L.lightHammer = "빛 망치" -- Better name for "Hammer of Creation"
	L.absorb = "흡수"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "시전"
	L.cast_text = "%.1f초 (|cff%s%.0f%%|r)" -- s = seconds
	L.stacks = "중첩"
end

L = BigWigs:NewBossLocale("Fallen Avatar", "koKR")
if L then
	L.touch_impact = "손길 분출" -- Touch of Sargeras Impact (short)

	L.custom_on_stop_timers = "능력 바 항상 표시"
	L.custom_on_stop_timers_desc = "몰락한 화신은 재사용 대기시간이 끝난 능력 중 하나를 무작위로 다음에 사용합니다. 이 옵션을 사용하면 이 능력들의 바가 화면에 유지됩니다."

	L.energy_leak = "마력 누출"
	L.energy_leak_desc = "1단계에서 우두머리에게 마력이 누출되면 경보를 표시합니다."
	L.energy_leak_msg = "마력 누출! (%d)"

	L.warmup_trigger = "네 눈앞의 껍데기는 한때 살게라스의 무지막지한 힘을 담던 그릇이었다." -- 네 눈앞의 껍데기는 한때 살게라스의 무지막지한 힘을 담던 그릇이었다. 그러나 이 사원 자체가 우리에겐 포상이다. 이곳이 우리가 너희 세상을 잿더미로 만드는 발판이 되리라!

	L.absorb = "흡수"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "시전"
	L.cast_text = "%.1f초 (|cff%s%.0f%%|r)" -- s = seconds
end

L = BigWigs:NewBossLocale("Kil'jaeden", "koKR")
if L then
	L.singularityImpact = "특이점 파열"
	L.obeliskExplosion = "방첨탑 폭발"
	L.obeliskExplosion_desc = "방첨탑 폭발의 타이머입니다"

	L.darkness = "어둠의 영혼" -- Shorter name for Darkness of a Thousand Souls (238999)
	L.reflectionErupting = "반영: 분출" -- Shorter name for Shadow Reflection: Erupting (236710)
	L.reflectionWailing = "반영: 통곡" -- Shorter name for Shadow Reflection: Wailing (236378)
	L.reflectionHopeless = "반영: 절망" -- Shorter name for Shadow Reflection: Hopeless (237590)

	L.rupturingKnock = "특이점 파열 밀쳐내기"
	L.rupturingKnock_desc = "밀쳐내기 타이머를 표시합니다"

	L.meteorImpact_desc = "유성 충돌 타이머를 표시합니다"

	L.shadowsoul = "어둠영혼 생명력 추적기"
	L.shadowsoul_desc = "어둠영혼 5개체의 현재 생명력을 보여주는 정보 상자를 표시합니다."

	L.custom_on_track_illidan = "자동 인간형 추적"
	L.custom_on_track_illidan_desc = "당신이 사냥꾼이거나 야성 드루이드라면 이 옵션이 일리단을 추적할 수 있도록 자동으로 인간형 추적을 활성화합니다."

	L.custom_on_zoom_in = "자동 미니맵 확대"
	L.custom_on_zoom_in_desc = "이 기능은 일리단을 쉽게 추적할 수 있도록 미니맵을 4배 확대합니다, 단계가 끝나면 미니맵 확대를 이전 배율로 복원합니다."
end

L = BigWigs:NewBossLocale("Tomb of Sargeras Trash", "koKR")
if L then
	L.rune = "오크 룬"
	L.chaosbringer = "지옥불 혼돈인도자"
	L.rez = "무덤감시자 레즈"
	L.erduval = "에르두발"
	L.varah = "히포그리프 군주 바라"
	L.seacaller = "물결비늘 바다소환사"
	L.custodian = "깊은바다 관리인"
	L.dresanoth = "드레사노스"
	L.stalker = "공포의 추적자"
	L.darjah = "전쟁군주 다르자"
	L.sentry = "수호의 감시자"
	L.acolyte = "유령 수행사제"
	L.ryul = "희미한 자 률"
	L.countermeasure = "방어 장치"
end
