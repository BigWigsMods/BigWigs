local L = BigWigs:NewBossLocale("Gruul", "zhCN")
if not L then return end
if L then
	L.first_ability = "粉碎打击或石化猛击"
end

L = BigWigs:NewBossLocale("Oregorger", "zhCN")
if L then
	L.berserk_trigger = "奥尔高格饿了，他要吃更多的黑石矿石！"

	L.shard_explosion = "爆裂残片爆炸"
	L.shard_explosion_desc = "爆裂残片分散计时条，如你是近战职业希望启用爆裂残片冷却。"

	L.hunger_drive_power = "%d层 >%s< - %d矿石剩余！"
end

L = BigWigs:NewBossLocale("The Blast Furnace", "zhCN")
if L then
	L.custom_on_shieldsdown_marker = "护盾消失标记"
	L.custom_on_shieldsdown_marker_desc = "使用 {rt8} 标记一个容易遭受伤害的元素尊者，需要权限。"

	L.heat_increased_message = "高热提高！每%s秒冲击！"

	L.bombs_dropped = "炸弹 掉落！(%d)"
end

L = BigWigs:NewBossLocale("Hans'gar and Franzok", "zhCN")
if L then

end

L = BigWigs:NewBossLocale("Flamebender Ka'graz", "zhCN")
if L then
	L.molten_torrent_self = "自身熔岩激流"
	L.molten_torrent_self_desc = "当你中了熔岩激流时显示特殊冷却。"
	L.molten_torrent_self_bar = ">你< 爆炸！"
end

L = BigWigs:NewBossLocale("Kromog", "zhCN")
if L then

end

L = BigWigs:NewBossLocale("Beastlord Darmac", "zhCN")
if L then
	L.next_mount = "即将 上坐骑！"

	L.custom_off_pinned_marker = "长矛钉刺标记"
	L.custom_off_pinned_marker_desc = "使用 {rt8}{rt7}{rt6}{rt5}{rt4} 标记长矛钉刺，需要权限。\n|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突。|r\n|cFFADFF2F提示：如果团队选择你打开此选项，鼠标快速指向长矛是标记他们的最快方式。|r"

	L.custom_off_conflag_marker = "烈火标记"
	L.custom_off_conflag_marker_desc = "使用 {rt1}{rt2}{rt3} 标记烈火目标，需要权限。\n|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突。|r"
end

L = BigWigs:NewBossLocale("Operator Thogar", "zhCN")
if L then
	L.custom_off_firemender_marker = "格罗姆卡控火师标记"
	L.custom_off_firemender_marker_desc = "使用 {rt1}{rt2} 标记格罗姆卡控火师，需要权限。\n|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突。|r\n|cFFADFF2F提示：如果团队选择你打开此选项，鼠标快速指向是标记他们的最快方式。|r"

	L.trains = "火车警报"
	L.trains_desc = "当下一次火车到来时显示每条车道计时器和信息。车道标记为从首领到入口顺序，如：首领 1234 入口。"

	L.lane = "轨道%s：%s"
	L.train = "火车"
	L.adds_train = "火车增援"
	L.big_add_train = "大型火车增援"
	L.cannon_train = "火炮火车"
	L.deforester = "伐林者"
	L.random = "随机火车"
end

L = BigWigs:NewBossLocale("The Iron Maidens", "zhCN")
if L then
	L.ship_trigger = "准备" -- prepares to man the Dreadnaught's Main Cannon! PH

	L.ship = "跳上舰船"

	L.custom_off_heartseeker_marker = "浸血觅心者标记"
	L.custom_off_heartseeker_marker_desc = "使用 {rt1}{rt2}{rt3} 标记浸血觅心者目标，需要权限。"

	L.power_message = ">%d< 钢铁之怒！"
end

L = BigWigs:NewBossLocale("Blackhand", "zhCN")
if L then
	L.custom_off_markedfordeath_marker = "死亡标记标记"
	L.custom_off_markedfordeath_marker_desc = "使用 {rt1}{rt2} 标记死亡标记目标，需要权限。"
end

