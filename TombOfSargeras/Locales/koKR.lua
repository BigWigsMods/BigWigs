local L = BigWigs:NewBossLocale("Harjatan the Bludger", "koKR")
if not L then return end
if L then
	L.custom_on_fixate_plates = "적 이름표에 시선 고정 아이콘"
	L.custom_on_fixate_plates_desc = "당신에게 시선을 고정한 대상 이름표에 아이콘을 표시합니다.\n적 이름표를 사용해야 합니다. 이 기능은 현재 KuiNameplates만 지원합니다."
end

L = BigWigs:NewBossLocale("The Desolate Host", "koKR")
if L then
	L.infobox_players = "플레이어"
	L.armor_remaining = "%s 남음 (%d)" -- Bonecage Armor Remaining (#)
end

L = BigWigs:NewBossLocale("Maiden of Vigilance", "koKR")
if L then
	L.infusionChanged = "주입 변경: %s"
	L.sameInfusion = "같은 주입: %s"
	L.fel = "지옥"
	L.light = "빛"
end

L = BigWigs:NewBossLocale("Fallen Avatar", "koKR")
if L then
	--L.touch_impact = "Touch Impact" -- Touch of Sargeras Impact (short)
end

L = BigWigs:NewBossLocale("Kil'jaeden", "koKR")
if L then
	--L.singularityImpact = "Singularity Impact"
	--L.obeliskExplosion = "Obelisk Explosion"

	--L.darkness = "Darkness" -- Shorter name for Darkness of a Thousand Souls (238999)
	--L.reflectionErupting = "Reflection: Erupting" -- Shorter name for Shadow Reflection: Erupting (236710)
	--L.reflectionWailing = "Reflection: Wailing" -- Shorter name for Shadow Reflection: Wailing (236378)
	--L.reflectionHopeless = "Reflection: Hopeless" -- Shorter name for Shadow Reflection: Hopeless (237590)
end

L = BigWigs:NewBossLocale("Tomb of Sargeras Trash", "koKR")
if L then
	L.chaosbringer = "Infernal Chaosbringer"
	L.rez = "Rez the Tombwatcher"
	L.custodian = "Undersea Custodian"
	L.sentry = "Guardian Sentry"
end
