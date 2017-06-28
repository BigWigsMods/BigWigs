local L = BigWigs:NewBossLocale("Harjatan the Bludger", "zhCN")
if not L then return end
if L then
	L.custom_on_fixate_plates = "敌对姓名板凝视图标"
	L.custom_on_fixate_plates_desc = "当你被凝视时在目标姓名板上显示一个图标。\n需要使用敌对姓名板。此功能当前只支持 KuiNameplates。"
end

L = BigWigs:NewBossLocale("The Desolate Host", "zhCN")
if L then
	L.infobox_players = "玩家"
	L.armor_remaining = "%s 剩余（%d）" -- Bonecage Armor Remaining (#)
end

L = BigWigs:NewBossLocale("Maiden of Vigilance", "zhCN")
if L then
	L.infusionChanged = "灌注>改变<：%s"
	L.sameInfusion = "相同灌注：%s"
	L.fel = "邪能"
	L.light = "光明"
end

L = BigWigs:NewBossLocale("Fallen Avatar", "zhCN")
if L then
	L.touch_impact = "萨格拉斯之触冲击" -- Touch of Sargeras Impact (short)
end

L = BigWigs:NewBossLocale("Kil'jaeden", "zhCN")
if L then
	L.singularityImpact = "奇点冲击"
	L.obeliskExplosion = "方尖碑爆炸"

	L.darkness = "千魂" -- Shorter name for Darkness of a Thousand Souls (238999)
	L.reflectionErupting = "映像：爆发" -- Shorter name for Shadow Reflection: Erupting (236710)
	L.reflectionWailing = "映像：哀嚎" -- Shorter name for Shadow Reflection: Wailing (236378)
	L.reflectionHopeless = "映像：绝望" -- Shorter name for Shadow Reflection: Hopeless (237590)
end

L = BigWigs:NewBossLocale("Tomb of Sargeras Trash", "zhCN")
if L then
	L.chaosbringer = "地狱火混沌使者"
	L.rez = "守墓人瑞兹"
	L.custodian = "海底监察者"
	L.sentry = "守护者哨兵"
end
