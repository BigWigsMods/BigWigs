local L = BigWigs:NewBossLocale("Beth'tilac", "zhCN")
if not L then return end
if L then
	L.flare = GetSpellInfo(100936)
	L.flare_desc = "Show a timer bar for AoE flare."
	L.devastate_message = "阴燃毁灭：>#%d<"
	L.drone_bar = "下一烬网工虫"
	L.drone_message = "即将 烬网工虫！"
	L.kiss_message = "寡妇蛛之吻！"
end

L = BigWigs:NewBossLocale("Lord Rhyolith", "zhCN")
if L then
	L.armor = "黑曜石护甲"
	L.armor_desc = "当黑曜石护甲堆叠从雷奥利斯领主身上移除时发出警报。"
	L.armor_message = "%d%% 黑曜石护甲剩余！"
	L.armor_gone_message = "黑曜石护甲消失！"

	L.adds_header = "增援"
	L.big_add_message = "雷奥利斯的火花 出现！"
	L.small_adds_message = "即将 雷奥利斯的碎片！"

	L.phase2_warning = "第二阶段！"

	L.molten_message = "首领熔岩护甲堆叠：>%d<层！"

	L.stomp_message = "震荡践踏！"
	L.stomp = "震荡践踏"
end

L = BigWigs:NewBossLocale("Alysrazor", "zhCN")
if L then
	L.claw_message = "炽热之爪%2$d层：>%1$s<！"
	L.fullpower_soon_message = "即将 完全的力量！"
	L.halfpower_soon_message = "第四阶段！"
	L.encounter_restart = "蓄满力量"
	L.no_stacks_message = "你沒有羽毛！"
	L.moonkin_message = "去拿一些羽毛！"
	L.molt_bar = "下一羽蜕"

	L.meteor = "熔火流星"
	L.meteor_desc = "当熔火流星被召唤时发出警报。"
	L.meteor_message = "熔火流星！"

	L.stage_message = "阶段：>%d<！"
	L.kill_message = "就是现在 - 杀了她！"
	L.engage_message = "奥利瑟拉佐尔激活 - 约%d分钟后第二阶段！"

	L.worm_emote = "熔岩火虫从地下涌出来了！"
	L.phase2_soon_emote = "奥利瑟拉佐尔开始高速盘旋！狂风将移除火焰之翼的效果！"

	L.flight = "飞行助手"
	L.flight_desc = "当你“烈焰之翼”持续时显示计时条，使用超级醒目功能。"

	L.initiate = "炽炎之爪新兵出现"
	L.initiate_desc = "炽炎之爪新兵计时条。"
	L.initiate_both = "炽炎之爪新兵：>双向<！"
	L.initiate_west = "炽炎之爪新兵：>西<！"
	L.initiate_east = "炽炎之爪新兵：>东<！"
end

L = BigWigs:NewBossLocale("Shannox", "zhCN")
if L then
	L.safe = ">%s< 安全！"
	L.wary_dog = "警惕：>%s<！"
	L.crystal_trap = "水晶牢笼陷阱！"

	L.traps_header = "陷阱"
	L.immolation = "献祭陷阱"
	L.immolation_desc = "当狂脸或裂肢阶段献祭陷阱时发出警报，获得“警惕”状态。"
	L.immolationyou = ">你<脚下 献祭陷阱！"
	L.immolationyou_desc = "当你脚下献祭陷阱被召唤时发出警报。"
	L.immolationyou_message = "献祭陷阱"
	L.crystal = "投掷水晶牢笼陷阱"
	L.crystal_desc = "当沙恩诺克斯施放水晶牢笼陷阱时发出警报。"
end

L = BigWigs:NewBossLocale("Baleroc", "zhCN")
if L then
	L.torment = "焦点磨难堆叠"
	L.torment_desc = "当焦点受到磨难堆叠时发出警报。"

	L.blade_bar = "毁灭之刃"
	L.shard_message = "磨难碎片：>%d<！"
	L.focus_message = "焦点目标已有 >%d< 层磨难！"
	L.link_message = "倒计时"
end

L = BigWigs:NewBossLocale("Majordomo Staghelm", "zhCN")
if L then
	L.seed_explosion = ">你< 即将灼热之种爆炸！"
	L.seed_bar = "你：灼热之种爆炸"
	L.adrenaline_message = "肾上腺素：>%d<层！"
	L.leap_say = ">我< 烈焰镰刀！"
end

L = BigWigs:NewBossLocale("Ragnaros", "zhCN")
if L then
	L.intermission_end_trigger1 = "萨弗拉斯将会是你的末日。"
	L.intermission_end_trigger2 = "跪下吧，凡人们！一切都结束了。"
	L.intermission_end_trigger3 = "够了！我会亲自解决。"
	L.phase4_trigger = "太早了……"
	L.seed_explosion = "熔火之种爆炸！"
	L.intermission_bar = "中场"
	L.intermission_message = "中场！"
	L.sons_left = ">%d< 烈焰之子剩餘！"
	L.engulfing_close = "噬体烈焰：>近场<！"
	L.engulfing_middle = "噬体烈焰：>中场<！"
	L.engulfing_far = "噬体烈焰：>远场<！"
	L.hand_bar = "拉格纳罗斯之手"
	L.ragnaros_back_message = "拉格纳罗斯返回，集合！"

	L.wound = "灼烧之伤"
	L.wound_desc = "只对坦克警报。灼烧之伤堆叠计数并显示持续计时条。"
	L.wound_message = "灼烧之伤%2$d层：>%1$s<！"
end

