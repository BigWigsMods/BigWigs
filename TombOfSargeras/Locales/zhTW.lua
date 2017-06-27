local L = BigWigs:NewBossLocale("Harjatan the Bludger", "zhTW")
if not L then return end
if L then
	L.custom_on_fixate_plates = "在敵方姓名板顯示追擊圖示"
	L.custom_on_fixate_plates_desc = "當你被凝視時，在敵方姓名板上顯示一個圖示。\n需要啟用敵方姓名板，此功能目前只支援KuiNameplates。"
end

L = BigWigs:NewBossLocale("The Desolate Host", "zhTW")
if L then
	L.infobox_players = "玩家"
	L.armor_remaining = "剩餘%s（%d）" -- Bonecage Armor Remaining (#)
end

L = BigWigs:NewBossLocale("Maiden of Vigilance", "zhTW")
if L then
	L.infusionChanged = "注入改變：%s"
	L.sameInfusion = "相同注入：%s"
	L.fel = "魔化"
	L.light = "聖光"
end

L = BigWigs:NewBossLocale("Fallen Avatar", "zhTW")
if L then
	L.touch_impact = "薩格拉斯之觸衝擊" -- Touch of Sargeras Impact (short)
end

L = BigWigs:NewBossLocale("Kil'jaeden", "zhTW")
if L then
	L.singularityImpact = "奇異點衝擊"
	L.obeliskExplosion = "石碑爆炸"

	L.darkness = "千魂之暗" -- Shorter name for Darkness of a Thousand Souls (238999)
	L.reflectionErupting = "分身：爆發" -- Shorter name for Shadow Reflection: Erupting (236710)
	L.reflectionWailing = "分身：哀號" -- Shorter name for Shadow Reflection: Wailing (236378)
	L.reflectionHopeless = "分身：絕望" -- Shorter name for Shadow Reflection: Hopeless (237590)
end

L = BigWigs:NewBossLocale("Tomb of Sargeras Trash", "zhTW")
if L then
	L.chaosbringer = "煉獄火混亂使者"
	L.rez = "守墓者瑞茲"
	L.custodian = "深海守衛"
	L.sentry = "守護者哨衛"
end
