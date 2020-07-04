local L = BigWigs:NewBossLocale("The Prophet Skeram", "zhCN")
if not L then return end
if L then
	L.bossName = "预言者斯克拉姆"
end

local L = BigWigs:NewBossLocale("Silithid Royalty", "zhCN")
if L then
	L.bossName = "安其拉三宝"
end

local L = BigWigs:NewBossLocale("Battleguard Sartura", "zhCN")
if L then
	L.bossName = "沙尔图拉"
end

local L = BigWigs:NewBossLocale("Fankriss the Unyielding", "zhCN")
if L then
	L.bossName = "顽强的范克瑞斯"
end

L = BigWigs:NewBossLocale("Viscidus", "zhCN")
if L then
	L.bossName = "维希度斯"

	L.freeze = "冻结状态"
	L.freeze_desc = "当冻结状态改变时发出警报。"

	L.freeze_trigger1 = "%s的速度慢下来了！"
	L.freeze_trigger2 = "%s冻结了！"
	L.freeze_trigger3 = "%s变成了坚硬的固体！"
	L.freeze_trigger4 = "%s突然裂开了！"
	L.freeze_trigger5 = "%s看起来就要碎裂了！"

	L.freeze_warn1 = "第一冻结阶段！"
	L.freeze_warn2 = "第二冻结阶段！"
	L.freeze_warn3 = "维希度斯冻住了！"
	L.freeze_warn4 = "开始碎了 - 继续！"
	L.freeze_warn5 = "快裂开了 - 加油！"
	L.freeze_warn_melee = "%d物理攻击 - 还需%d下！"
	L.freeze_warn_frost = "%d冰霜攻击 - 还需%d下！"
end

local L = BigWigs:NewBossLocale("Princess Huhuran", "zhCN")
if L then
	L.bossName = "哈霍兰公主"
end

local L = BigWigs:NewBossLocale("The Twin Emperors", "zhCN")
if L then
	L.bossName = "双子皇帝"
end

L = BigWigs:NewBossLocale("Ouro", "zhCN")
if L then
	L.bossName = "奥罗"

	L.engage_message = "奥罗已进入战斗！90秒后可能下潜！"

	L.emerge = "出现"
	L.emergewarn = "15秒后可能下潜！"
	L.emergewarn2 = "15秒后奥罗下潜！"
	L.emergebartext = "奥罗下潜"

	L.submerge = "消失"
	L.possible_submerge_bar = "可能下潜"

	L.scarab = "甲虫消失"
	L.scarab_desc = "当甲虫消失时发出警报。"
	L.scarabdespawn = "10秒后甲虫消失"
	L.scarabbar = "甲虫消失"
end

L = BigWigs:NewBossLocale("C'Thun", "zhCN")
if L then
	L.bossName = "克苏恩"

	L.tentacle = "触须"
	L.tentacle_desc = "触须警报。"

	L.giant = "巨眼警报"
	L.giant_desc = "巨眼警报。"

	L.weakened = "虚弱警报"
	L.weakened_desc = "虚弱状态警报。"

	L.weakenedtrigger = "%s的力量被削弱了！"

	L.weakened_msg = "克苏恩已虚弱持续45秒"
	L.invulnerable2 = "5秒后结束"
	L.invulnerable1 = "克苏恩无敌"

	L.giant3 = "10秒后 - 巨眼"
	L.giant2 = "5秒后 - 巨眼"
	L.giant1 = "巨眼 - 快打！"

	L.startwarn = "克苏恩进入战斗 - 45秒后黑暗闪耀和眼睛"

	L.tentacleParty = "大量触须！"
	L.barWeakened = "克苏恩已虚弱！"
	L.barGiant = "巨眼！"

	L.groupwarning = "黑暗闪耀位于队伍%s（%s）"
	L.phase2starting = "眼睛已死！真身降临！"
end

L = BigWigs:NewBossLocale("Ahn'Qiraj Trash", "zhCN")
if L then
	L.anubisath = "阿努比萨斯"
	L.sentinel = "阿努比萨斯哨兵"
	L.defender = "阿努比萨斯防御者"
	L.crawler = "维克尼爬行者"
end
