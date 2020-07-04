local L = BigWigs:NewBossLocale("Lucifron", "zhCN")
if not L then return end
if L then
	L.bossName = "鲁西弗隆"

	L.mc_bar = "控制：%s"
end

L = BigWigs:NewBossLocale("Magmadar", "zhCN")
if L then
	L.bossName = "玛格曼达"
end

L = BigWigs:NewBossLocale("Gehennas", "zhCN")
if L then
	L.bossName = "基赫纳斯"
end

L = BigWigs:NewBossLocale("Garr", "zhCN")
if L then
	L.bossName = "加尔"
end

L = BigWigs:NewBossLocale("Baron Geddon", "zhCN")
if L then
	L.bossName = "迦顿男爵"
end

L = BigWigs:NewBossLocale("Shazzrah", "zhCN")
if L then
	L.bossName = "沙斯拉尔"
end

L = BigWigs:NewBossLocale("Sulfuron Harbinger", "zhCN")
if L then
	L.bossName = "萨弗隆先驱者"
end

L = BigWigs:NewBossLocale("Golemagg the Incinerator", "zhCN")
if L then
	L.bossName = "焚化者古雷曼格"
end

L = BigWigs:NewBossLocale("Majordomo Executus", "zhCN")
if L then
	L.bossName = "管理者埃克索图斯"

	L.disabletrigger = "不……不可能！等一下……我投降！我投降！"
	L.power_next = "下一能量"
end

L = BigWigs:NewBossLocale("Ragnaros", "zhCN")
if L then
	L.bossName = "拉格纳罗斯"

	L.warmup_message = "大约 73 秒后战斗开始"

	L.engage_trigger = "现在轮到你们了"
	L.submerge_trigger = "出现吧，我的奴仆"

	L.knockback_message = "群体击退！"
	L.knockback_bar = "群体击退"

	L.submerge = "消失"
	L.submerge_desc = "当拉格纳罗斯消失时发出警报。"
	L.submerge_message = "拉格纳罗斯消失90秒！"
	L.submerge_bar = "消失"

	L.emerge = "出现"
	L.emerge_desc = "当拉格纳罗斯出现时发出警报。"
	L.emerge_message = "拉格纳罗斯已经激活，3分钟后消失！"
	L.emerge_bar = "出现"
end

