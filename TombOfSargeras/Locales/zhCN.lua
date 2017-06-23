local L = BigWigs:NewBossLocale("Harjatan the Bludger", "zhCN")
if not L then return end
if L then
	L.custom_on_fixate_plates = "敌对姓名板固定图标"
	L.custom_on_fixate_plates_desc = "在目标姓名板上显示一个图标。\n需要使用敌对姓名板。此功能当前只支持 KuiNameplates。"
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

L = BigWigs:NewBossLocale("Tomb of Sargeras Trash", "zhCN")
if L then
	L.chaosbringer = "地狱火混沌使者"
	L.rez = "守墓人瑞兹"
	L.custodian = "海底监察者"
	L.sentry = "守护者哨兵"
end
