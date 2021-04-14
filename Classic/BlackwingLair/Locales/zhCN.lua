local L = BigWigs:NewBossLocale("Razorgore the Untamed", "zhCN")
if not L then return end
if L then
	L.bossName = "狂野的拉佐格尔"

	L.start_trigger = "入侵者"
	L.start_message = "狂野的拉佐格尔进入战斗！45秒后小怪出现！"
	L.start_soon = "5秒后小怪出现！"
	L.start_mob = "小怪出现"

	L.eggs = "龙蛋计数"
	L.eggs_desc = "已摧毁龙蛋计数。"
	L.eggs_message = "%d/30 龙蛋已被摧毁！"

	L.phase2_message = "已摧毁所有龙蛋"
end

L = BigWigs:NewBossLocale("Vaelastrasz the Corrupt", "zhCN")
if L then
	L.bossName = "堕落的瓦拉斯塔兹"

	L.warmup_trigger = "太晚了，朋友们！奈法利安的堕落力量已经生效……我无法……控制自己。"
	L.warmup_message = "大约 43秒 后战斗开始"
end

L = BigWigs:NewBossLocale("Broodlord Lashlayer", "zhCN")
if L then
	L.bossName = "勒什雷尔"
end

L = BigWigs:NewBossLocale("Firemaw", "zhCN")
if L then
	L.bossName = "费尔默"
end

L = BigWigs:NewBossLocale("Ebonroc", "zhCN")
if L then
	L.bossName = "埃博诺克"
end

L = BigWigs:NewBossLocale("Flamegor", "zhCN")
if L then
	L.bossName = "弗莱格尔"
end

L = BigWigs:NewBossLocale("Chromaggus", "zhCN")
if L then
	L.bossName = "克洛玛古斯"

	L.breath = "吐息警报"
	L.breath_desc = "吐息警报"

	L.debuffs_message = "3/5 减益，注意！"
	L.debuffs_warning = "4/5 减益， 5层后将%s！"
end

L = BigWigs:NewBossLocale("NefarianBWL", "zhCN")
if L then
	L.bossName = "奈法利安"

	L.landing_soon_trigger = "干得好，我的手下。"
	L.landing_trigger = "燃烧吧！"
	L.zerg_trigger = "^不可能"

	L.triggershamans = "^萨满祭司"
	L.triggerwarlock = "^术士"
	L.triggerhunter = "^猎人"
	L.triggermage = "^你们也是法师"

	L.landing_soon_warning = "奈法利安将在10秒后降落！"
	L.landing_warning = "奈法利安已降落！"
	L.zerg_warning = "骨龙群出现！"
	L.classcall_warning = "职业点名！"

	L.warnshaman = "萨满祭司 - 图腾出现！"
	L.warndruid = "德鲁伊 - 强制猫形态，无法治疗和解诅咒！"
	L.warnwarlock = "术士 - 地狱火出现，输出职业尽快将其消灭！"
	L.warnpriest = "牧师 - 停止治疗，静等25秒！"
	L.warnhunter = "猎人 - 远程武器损坏！"
	L.warnwarrior = "战士 - 强制狂暴姿态，加大对坦克的治疗量！"
	L.warnrogue = "盗贼 - 被传送和麻痹！"
	L.warnpaladin = "圣骑士 - 首领受到保护祝福，物理攻击无效！"
	L.warnmage = "法师 - 变形术发动，注意解除！"

	L.classcall_bar = "职业点名"

	L.classcall = "职业点名警报"
	L.classcall_desc = "职业点名警报"

	L.otherwarn = "其他警报"
	L.otherwarn_desc = "降落与骨龙群出现时发出警报"

	L.add = "龙兽死亡"
	L.add_desc = "第1阶段奈法利安降落之前增援击杀计数警报。"
end
