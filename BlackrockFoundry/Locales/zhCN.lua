local L = BigWigs:NewBossLocale("Gruul", "zhCN")
if not L then return end
if L then
L.first_ability = "粉碎打击或石化猛击"

end

L = BigWigs:NewBossLocale("Oregorger", "zhCN")
if L then
L.roll_message = "翻滚%d - %d矿石剩余！"

end

L = BigWigs:NewBossLocale("The Blast Furnace", "zhCN")
if L then
L.bombs_dropped = "炸弹掉落！（%d）"
L.bombs_dropped_p2 = "工程师已击杀，炸弹掉落！"
L.custom_off_firecaller_marker = "召火者标记"
L.custom_off_firecaller_marker_desc = [=[使用 {rt7}{rt6} 标记召火者，需要权限。
|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突。|r
|cFFADFF2F提示：如果团队选择你打开此选项，鼠标快速指向召火者是标记他们的最快方式。|r]=]
L.custom_on_shieldsdown_marker = "护盾消失标记"
L.custom_on_shieldsdown_marker_desc = "使用 {rt8} 标记一个容易遭受伤害的元素尊者，需要权限。"
L.engineer = "熔炉工程师出现"
L.engineer_desc = "第1阶段时，2个熔炉工程师将重复出现，房间每侧1个。"
L.firecaller = "召火者出现"
L.firecaller_desc = "第2阶段时，2个召火者将重复出现，房间每侧1个。"
L.guard = "保安出现"
L.guard_desc = "第1阶段时，2个保安将重复出现，房间每侧1个，第2阶段时，1个保安将在房间入口重复出现。"
L.heat_increased_message = "高热提高！每%s秒冲击！"
L.operator = "鼓风者出现"
L.operator_desc = "第1阶段时，2个鼓风者将重复出现，房间每侧1个。"

end

L = BigWigs:NewBossLocale("Flamebender Ka'graz", "zhCN")
if L then
L.custom_off_wolves_marker = "烬狼标记"
L.custom_off_wolves_marker_desc = "使用 {rt3}{rt4}{rt5}{rt6} 标记烬狼，需要权限。"
L.molten_torrent_self = "自身熔岩激流"
L.molten_torrent_self_bar = ">你< 爆炸！"
L.molten_torrent_self_desc = "当你中了熔岩激流时显示特殊冷却。"

end

L = BigWigs:NewBossLocale("Kromog", "zhCN")
if L then
L.custom_off_hands_marker = "纠缠之地坦克标记"
L.custom_off_hands_marker_desc = "使用 {rt7}{rt8} 标记受到纠缠之地举起的坦克，需要权限。"
L.destroy_pillars = "摧毁石柱"
L.prox = "坦克近距离"
L.prox_desc = "开启一个15码近距离显示其它坦克以帮助处理岩石之拳技能。"

end

L = BigWigs:NewBossLocale("Beastlord Darmac", "zhCN")
if L then
L.custom_off_conflag_marker = "烈火标记"
L.custom_off_conflag_marker_desc = [=[使用 {rt1}{rt2}{rt3} 标记烈火目标，需要权限。
|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突。|r]=]
L.custom_off_pinned_marker = "长矛钉刺标记"
L.custom_off_pinned_marker_desc = [=[使用 {rt8}{rt7}{rt6}{rt5}{rt4} 标记长矛钉刺，需要权限。
|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突。|r
|cFFADFF2F提示：如果团队选择你打开此选项，鼠标快速指向长矛是标记他们的最快方式。|r]=]
L.next_mount = "即将 上坐骑！"

end

L = BigWigs:NewBossLocale("Operator Thogar", "zhCN")
if L then
L.adds_train = "火车增援"
L.big_add_train = "大型火车增援"
L.cannon_train = "火炮火车"
L.custom_on_firemender_marker = "格罗姆卡控火师标记"
L.custom_on_firemender_marker_desc = "使用 {rt7} 标记格罗姆卡控火师，需要权限。"
L.custom_on_manatarms_marker = "格罗姆卡重装步兵标记"
L.custom_on_manatarms_marker_desc = "使用 {rt8} 标记格罗姆卡重装步兵，需要权限。"
L.deforester = "伐林者"
L.lane = "轨道%s：%s"
L.random = "随机火车"
L.train = "火车"
L.trains = "火车警报"
L.trains_desc = "当下一次火车到来时显示每条车道计时器和信息。车道标记为从首领到入口顺序，如：首领 1234 入口。"
L.train_you = "你在的轨道有火车！（%d）"

end

L = BigWigs:NewBossLocale("The Iron Maidens", "zhCN")
if L then
L.custom_off_heartseeker_marker = "浸血觅心者标记"
L.custom_off_heartseeker_marker_desc = "使用 {rt1}{rt2}{rt3} 标记浸血觅心者目标，需要权限。"
L.power_message = ">%d< 钢铁之怒！"
L.ship = "跳上舰船"
L.ship_trigger = "准备操纵无畏舰的主炮！"

end

L = BigWigs:NewBossLocale("Blackhand", "zhCN")
if L then
L.custom_off_markedfordeath_marker = "死亡标记标记"
L.custom_off_markedfordeath_marker_desc = "使用 {rt1}{rt2}{rt3} 标记死亡标记目标，需要权限。"
L.custom_off_massivesmash_marker = "巨力粉碎猛击标记"
L.custom_off_massivesmash_marker_desc = "使用 {rt6} 标记受到巨力粉碎猛击的坦克，需要权限。"

end

L = BigWigs:NewBossLocale("Blackrock Foundry Trash", "zhCN")
if L then
L.beasttender = "雷神驯兽者"
L.brute = "炉渣车间蛮兵"
L.earthbinder = "钢铁缚地者"
L.enforcer = "黑石执行者"
L.furnace = "爆裂熔炉废气"
L.furnace_msg1 = "嗯，有点热不是吗？"
L.furnace_msg2 = "烤棉花糖时间到啦！"
L.furnace_msg3 = "这可不好……"
L.gnasher = "暗裂噬咬者"
L.gronnling = "小戈隆劳工"
L.guardian = "车间守卫"
L.hauler = "独眼魔搬运工"
L.mistress = "女铁匠火手"
L.taskmaster = "钢铁工头"

end

