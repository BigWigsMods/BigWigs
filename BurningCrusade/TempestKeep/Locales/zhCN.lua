local L = BigWigs:NewBossLocale("Void Reaver", "zhCN")
if not L then return end
if L then
	L.engage_trigger = "警报！消灭入侵者。"
end

L = BigWigs:NewBossLocale("High Astromancer Solarian", "zhCN")
if L then
	L.engage_trigger = "Tal anu'men no sin'dorei!"

	L.phase = "阶段"
	L.phase_desc = "阶段改变警报。"
	L.phase1_message = "第一阶段 - 约50秒后，分裂！"
	L.phase2_warning = "即将 第二阶段！"
	L.phase2_trigger = "^我受够了！现在我要让你们看看宇宙的愤怒！"
	L.phase2_message = "20% - 第二阶段！"

	L.wrath_other = "愤怒"

	L.split = "分裂"
	L.split_desc = "当分裂和增加救援时发出警报。"
	L.split_trigger1 = "我要让你们自以为是的错觉荡然无存！"
	L.split_trigger2 = "你们势单力薄！"
	L.split_bar = "下一分裂"
	L.split_warning = "约7秒后，分裂！"

	L.agent_warning = "分裂！ - 6秒后，日晷密探！"
	L.agent_bar = "日晷密探"
	L.priest_warning = "3秒后，日晷祭司/索兰莉安！"
	L.priest_bar = "日晷祭司/索兰莉安"
end

L = BigWigs:NewBossLocale("Kael'thas Sunstrider", "zhCN")
if L then
	L.engage_trigger = "魔法，能量，我的人民陷入其中不能自拔……自从太阳之井被摧毁之后就是如此。欢迎来到未来。真遗憾，你们无法阻止什么。没有人可以阻止我了！Selama ashal’anore！"
	L.engage_message = "第一阶段 - 四顾问！"

	L.gaze = "凝视"
	L.gaze_desc = "当亵渎者萨拉德雷凝视玩家时发出警报。"
	L.gaze_trigger = "凝视着"

	L.fear_soon_message = "即将 恐惧！"
	L.fear_message = "恐惧！"
	L.fear_bar = "恐惧 冷却"

	L.rebirth = "凤凰复生"
	L.rebirth_desc = "凤凰复生计时条。"
	L.rebirth_warning = "约5秒后，凤凰复生！"
	L.rebirth_bar = "凤凰重生"

	L.pyro = "炎爆术"
	L.pyro_desc = "显示60秒的炎爆术记时条。"
	L.pyro_trigger = "%s开始施放炎爆术！"
	L.pyro_warning = "5秒后，炎爆术！"
	L.pyro_message = "正在施放 炎爆术！"

	L.phase = "阶段警报"
	L.phase_desc = "每阶段首领来领发出警报。"
	L.thaladred_inc_trigger = "让我们来看看你们如何面对亵渎者萨拉德雷！ "
	L.sanguinar_inc_trigger = "你们击败了我最强大的顾问……但是没有人能战胜鲜血之锤。出来吧，萨古纳尔男爵！"
	L.capernian_inc_trigger = "卡波妮娅会很快解决你们的。"
	L.telonicus_inc_trigger = "干得不错。看来你们有能力挑战我的首席技师，塔隆尼库斯。"
	L.weapons_inc_trigger = "你们看，我的个人收藏中有许多武器……"
	L.phase3_trigger = "也许我确实低估了你们。虽然让你们同时面对我的四位顾问显得有些不公平，但是我的人民从来都没有得到过公平的待遇。我只是在以牙还牙。"
	L.phase4_trigger = "唉，有些时候，有些事情，必须得亲自解决才行。Balamore shanal！"

	L.flying_trigger = "我的心血是不会被你们轻易浪费的！我精心谋划的未来是不会被你们轻易破坏的！感受我真正的力量吧！"
	L.flying_message = "第五阶段 - 1分钟后引力失效！"

	L.weapons_inc_message = "第二阶段 - 准备与神器作战！"
	L.phase3_message = "第三阶段 - 四顾问复生！"
	L.phase4_message = "第四阶段 - 凯尔萨斯！"
	L.phase4_bar = "凯尔萨斯 来临"

	L.mc = "精神控制"
	L.mc_desc = "当玩家受到精神控制时发出警报。"

	L.revive_bar = "凤凰复活"
	L.revive_warning = "5秒后，凤凰复活！"

	L.dead_message = "%s死亡了。"

	L.capernian = "星术师卡波妮娅"
	L.sanguinar = "萨古纳尔男爵"
	L.telonicus = "首席技师塔隆尼库斯"
	L.thaladred = "亵渎者萨拉德雷"
end

