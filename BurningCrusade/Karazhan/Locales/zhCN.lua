local L = BigWigs:NewBossLocale("Attumen the Huntsman Raid", "zhCN")
if not L then return end
if L then
	L.phase = "阶段"
	L.phase_desc = "当进入下一阶段时发出警报。"
	L.phase2_trigger = "%s呼喊着她的主人！"
	L.phase2_message = "第二阶段"
	L.phase3_trigger = "来吧，午夜，让我们解决这群乌合之众！"
	L.phase3_message = "第三阶段"
end

L = BigWigs:NewBossLocale("The Curator Raid", "zhCN")
if L then
	L.engage_trigger = "展览厅只对访客开放。"

	L.weaken_message = "唤醒 - 20秒虚弱计时开始。"
	L.weaken_fade_message = "唤醒结束，准备击杀小电球！"
	L.weaken_fade_warning = "5秒后，唤醒结束！"
end

L = BigWigs:NewBossLocale("Maiden of Virtue Raid", "zhCN")
if L then
	L.engage_trigger = "你们的行为是不可饶恕的。"
	L.engage_message = "战斗开始！约33秒后，释放悔改！"

	L.repentance_message = "悔改！约33秒后发动。"
	L.repentance_warning = "悔改 冷却结束，即将发动！"
end

L = BigWigs:NewBossLocale("Prince Malchezaar", "zhCN")
if L then
	L.wipe_bar = "重置计时器"

	L.phase = "阶段提示"
	L.phase_desc = "进入战斗及每阶段的提示。"
	L.phase1_trigger = "疯狂将你们带到我的面前，而我将以死亡终结你们！"
	L.phase2_trigger = "愚蠢的家伙！时间就是吞噬你躯体的烈焰！"
	L.phase3_trigger = "你如何抵挡这无坚不摧的力量？"
	L.phase1_message = "第一阶段 - 约40秒后，地狱火！"
	L.phase2_message = "60% - 第二阶段！"
	L.phase3_message = "30% - 第三阶段！"

	L.infernal = "地狱火警报"
	L.infernal_desc = "显示召唤地狱火冷却时间计时条。"
	L.infernal_bar = "即将 地狱火"
	L.infernal_warning = "20秒后，地狱火！"
	L.infernal_message = "地狱火出现！5秒后发动，地狱烈焰！"
	L.infernal_trigger1 = "还有我所号令的军团"
	L.infernal_trigger2 = "所有的世界都向我敞开大门"
end

L = BigWigs:NewBossLocale("Moroes Raid", "zhCN")
if L then
	L.engage_trigger = "啊，不速之客。我得准备一下……"
	L.engage_message = "%s 激活！约35秒后，消失！"
end

L = BigWigs:NewBossLocale("Netherspite", "zhCN")
if L then
	L.phase = "阶段警报"
	L.phase_desc = "当进入下一阶段时发出警报。"
	L.phase1_message = "快撤！- 虚空吐息来临！"
	L.phase1_bar = "虚空吐息 - 撤退"
	L.phase1_trigger = "%s在撤退中大声呼喊着，打开了回到虚空的传送门。"
	L.phase2_message = "狂怒！- 地狱吐息来临！"
	L.phase2_bar = "地狱吐息 - 狂怒"
	L.phase2_trigger = "%s的怒火甚至可以充满整个虚空！"

	L.voidzone_warn = "虚空领域：>%d<！"
end

L = BigWigs:NewBossLocale("Nightbane Raid", "zhCN")
if L then
	L.name = "夜之魇"

	L.phase = "阶段警报"
	L.phase_desc = "当进入下阶段时发出警报。"
	L.airphase_trigger = "可怜的渣滓。我要腾空而起，让你尝尝毁灭的滋味！"
	L.landphase_trigger1 = "够了！我要落下来把你们打得粉碎！"
	L.landphase_trigger2 = "没用的虫子！让你们见识一下我的力量吧！"
	L.airphase_message = "升空"
	L.landphase_message = "降落"
	L.summon_trigger = "一个远古的生物在远处被唤醒了……"

	L.engage_trigger = "愚蠢的家伙！我会很快终结你们的痛苦！"
end

L = BigWigs:NewBossLocale("Romulo & Julianne", "zhCN")
if L then
	L.name = "罗密欧和朱丽叶"

	L.phase = "阶段警报"
	L.phase_desc = "当进入下阶段发出警报。"
	L.phase1_trigger = "你是个什么魔鬼，这样煎熬着我？"
	L.phase1_message = "第 I 幕 - 朱丽叶"
	L.phase2_trigger = "你要激怒我吗？那就来吧！"
	L.phase2_message = "第 II 幕 - 罗密欧"
	L.phase3_trigger = "来吧，可爱的黑颜的夜，把我的罗密欧给我！"
	L.phase3_message = "第 III 幕 - 同时出场"

	L.poison = "中毒"
	L.poison_desc = "当玩家中毒时发出警报。"
	L.poison_message = "浸毒之刺"

	L.heal = "治疗"
	L.heal_desc = "当朱丽叶施放治疗时警报。"
	L.heal_message = "朱丽叶 施放治疗！"

	L.buff = "自身增益效果警报"
	L.buff_desc = "当罗密欧与朱丽叶获得增益效果时发出警报。"
	L.buff1_message = "罗密欧 获得 卤莽！"
	L.buff2_message = "朱丽叶 获得 虔诚光环！"
end

L = BigWigs:NewBossLocale("Shade of Aran", "zhCN")
if L then
	L.adds = "水元素"
	L.adds_desc = "当召唤水元素时发出警报。"
	L.adds_message = "水元素 来临！"
	L.adds_warning = "即将召唤 水元素！"
	L.adds_bar = "召唤水元素"

	L.drink = "群体变形"
	L.drink_desc = "当即将施放回魔时发出警报。"
	L.drink_warning = "低法力 - 即将回魔！"
	L.drink_message = "回魔 - 群体变形！"
	L.drink_bar = "群体变形术"

	L.blizzard = "暴风雪"
	L.blizzard_desc = "当暴风雪开始施放发出警报。"
	L.blizzard_message = "暴风雪！"

	L.pull = "魔爆术"
	L.pull_desc = "当释放魔爆术时发出警报。"
	L.pull_message = "魔爆术！"
	L.pull_bar = "魔爆术"
end

L = BigWigs:NewBossLocale("Terestian Illhoof", "zhCN")
if L then
	L.engage_trigger = "啊，你们来的正是时候。仪式就要开始了！"

	L.weak = "虚弱"
	L.weak_desc = "当虚弱阶段时发出警报。"
	L.weak_message = "进入虚弱状态！约45秒。"
	L.weak_warning1 = "约5秒后，虚弱状态结束！"
	L.weak_warning2 = "虚弱结束！"
	L.weak_bar = "虚弱"
end

L = BigWigs:NewBossLocale("The Big Bad Wolf", "zhCN")
if L then
	L.name = "大灰狼"

	L.riding_bar = "快跑：%s"
end

L = BigWigs:NewBossLocale("The Crone", "zhCN")
if L then
	L.name = "巫婆"

	L.engage_trigger = "^啊，托托，我们必须找到回家的路！"

	L.spawns = "启动时间"
	L.spawns_desc = "每个角色激活时间计时。"
	L.spawns_warning = "%s 5秒后，开始攻击！"

	L.roar = "胆小的狮子"
	L.tinhead = "铁皮人"
	L.strawman = "稻草人"
	L.tito = "托托"
end

