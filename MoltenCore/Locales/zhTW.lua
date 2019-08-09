local L = BigWigs:NewBossLocale("Lucifron", "zhTW")
if not L then return end
if L then
	L.mc_bar = "控制：%s"
end

L = BigWigs:NewBossLocale("Majordomo Executus", "zhTW")
if L then
	L.disabletrigger = "不……不可能！等一下……我投降！我投降！"
	L.power_next = "下一能量"
end

L = BigWigs:NewBossLocale("Ragnaros ", "zhTW")
if L then
	L.engage_trigger = "現在輪到你們了"
	L.submerge_trigger = "出現吧，我的奴僕"

	L.knockback_message = "群體擊退！"
	L.knockback_bar = "群體擊退"

	L.submerge = "消失"
	L.submerge_desc = "當拉格納羅斯消失時發出警報"
	L.submerge_message = "消失 90 秒！ 烈焰之子出現！"
	L.submerge_bar = "拉格納羅斯消失"

	L.emerge = "出現"
	L.emerge_desc = "當拉格納羅斯出現時發出警報。"
	L.emerge_message = "拉格納羅斯已經進入戰鬥，3分鐘後消失！"
	L.emerge_bar = "出現"
end

