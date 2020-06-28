local L = BigWigs:NewBossLocale("Azuregos", "zhCN")
if not L then return end
if L then
	L.bossName = "艾索雷苟斯"

	L.teleport = "传送警报"
	L.teleport_desc = "传送警报"
	L.teleport_trigger = "来吧，小子。面对我！"
	L.teleport_message = "传送发动！"
end

L = BigWigs:NewBossLocale("Lord Kazzak", "zhCN")
if L then
	L.bossName = "卡扎克"

	L.engage_trigger = "为了军团！为了基尔加丹！"

	L.supreme_mode = "无敌模式"
end

local L = BigWigs:NewBossLocale("Emeriss", "zhCN")
if L then
	L.bossName = "艾莫莉丝"

	L.engage_trigger = "希望是灵魂染上的疾病！这片土地应该枯竭，从此死气腾腾！"
end

local L = BigWigs:NewBossLocale("Lethon", "zhCN")
if L then
	L.bossName = "莱索恩"

	L.engage_trigger = "我能感受到你内心的阴影。邪恶的侵蚀永远不会停止！"
end

local L = BigWigs:NewBossLocale("Taerar", "zhCN")
if L then
	L.bossName = "泰拉尔"

	L.engage_trigger = "和平不过是短暂的梦想！让梦魇统治整个世界吧！"
end

local L = BigWigs:NewBossLocale("Ysondre", "zhCN")
if L then
	L.bossName = "伊森德雷"

	L.engage_trigger = "生命的希冀已被切断！梦游者要展开报复！"
end
