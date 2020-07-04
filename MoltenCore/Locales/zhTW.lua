local L = BigWigs:NewBossLocale("Lucifron", "zhTW")
if not L then return end
if L then
	L.bossName = "魯西弗隆"

	L.mc_bar = "控制：%s"
end

L = BigWigs:NewBossLocale("Magmadar", "zhTW")
if L then
	L.bossName = "瑪格曼達"
end

L = BigWigs:NewBossLocale("Gehennas", "zhTW")
if L then
	L.bossName = "基赫納斯"
end

L = BigWigs:NewBossLocale("Garr", "zhTW")
if L then
	L.bossName = "加爾"
end

L = BigWigs:NewBossLocale("Baron Geddon", "zhTW")
if L then
	L.bossName = "迦頓男爵"
end

L = BigWigs:NewBossLocale("Shazzrah", "zhTW")
if L then
	L.bossName = "沙斯拉爾"
end

L = BigWigs:NewBossLocale("Sulfuron Harbinger", "zhTW")
if L then
	L.bossName = "薩弗隆先驅者"
end

L = BigWigs:NewBossLocale("Golemagg the Incinerator", "zhTW")
if L then
	L.bossName = "『焚化者』古雷曼格"
end

L = BigWigs:NewBossLocale("Majordomo Executus", "zhTW")
if L then
	L.bossName = "管理者埃克索圖斯"

	L.disabletrigger = "不……不可能！等一下……我投降！我投降！"
	L.power_next = "下一能量"
end

L = BigWigs:NewBossLocale("Ragnaros", "zhTW")
if L then
	L.bossName = "拉格納羅斯"

	-- L.warmup_message = "RP started, engaging in ~73s"

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

