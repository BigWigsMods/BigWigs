local L = BigWigs:NewBossLocale("Harjatan the Bludger", "koKR")
if not L then return end
if L then
	L.custom_on_fixate_plates = "적 이름표에 시선 고정 아이콘"
	L.custom_on_fixate_plates_desc = "당신에게 시선을 고정한 대상 이름표에 아이콘을 표시합니다.\n적 이름표를 사용해야 합니다. 이 기능은 현재 KuiNameplates만 지원합니다."
end

L = BigWigs:NewBossLocale("Demonic Inquisition", "koKR")
if L then
	L.custom_on_stop_timers = "능력 바 항상 표시"
	L.custom_on_stop_timers_desc = "악마 심문관은 시전 방해/다른 시전에 의해 시전이 지연되는 주문을 사용합니다. 이 옵션을 사용하면 이 능력들의 바가 화면에 유지됩니다."
end

L = BigWigs:NewBossLocale("The Desolate Host", "koKR")
if L then
	L.infobox_players = "플레이어"
	L.armor_remaining = "%s 남음 (%d)" -- Bonecage Armor Remaining (#)
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
end

L = BigWigs:NewBossLocale("Fallen Avatar", "koKR")
if L then
	L.touch_impact = "손길 분출" -- Touch of Sargeras Impact (short)

	L.custom_on_stop_timers = "능력 바 항상 표시"
	L.custom_on_stop_timers_desc = "몰락한 화신은 재사용 대기시간이 끝난 능력 중 하나를 무작위로 다음에 사용합니다. 이 옵션을 사용하면 이 능력들의 바가 화면에 유지됩니다."
end

L = BigWigs:NewBossLocale("Kil'jaeden", "koKR")
if L then
	L.singularityImpact = "특이점 파열"
	L.obeliskExplosion = "방첨탑 폭발"

	L.darkness = "어둠" -- Shorter name for Darkness of a Thousand Souls (238999)
	L.reflectionErupting = "반영: 분출" -- Shorter name for Shadow Reflection: Erupting (236710)
	L.reflectionWailing = "반영: 통곡" -- Shorter name for Shadow Reflection: Wailing (236378)
	L.reflectionHopeless = "반영: 절망" -- Shorter name for Shadow Reflection: Hopeless (237590)
end

L = BigWigs:NewBossLocale("Tomb of Sargeras Trash", "koKR")
if L then
	L.chaosbringer = "지옥불 혼돈인도자"
	L.rez = "무덤감시자 레즈"
	L.custodian = "깊은바다 관리인"
	L.sentry = "수호의 감시자"
end
