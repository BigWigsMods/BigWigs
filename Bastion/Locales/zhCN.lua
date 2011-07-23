
local L = BigWigs:NewBossLocale("Cho'gall", "zhCN")
if not L then return end
if L then
	L.orders = "形态转换"
	L.orders_desc = "当古加尔改变暗影/火焰援助令形态时发出警报。"

	L.worship_cooldown = "<膜拜>"

	L.adherent_bar = "<腐蚀信徒：#%d>"
	L.adherent_message = "即将 腐蚀信徒：>%d<！"
	L.ooze_bar = "<古神血雨：%d>"
	L.ooze_message = "即将 古神血雨：>%d<！"

	L.tentacles_bar = "<黑暗的造物出现>"
	L.tentacles_message = "大量黑暗的造物！"

	L.sickness_message = ">你< 快要呕吐了!"
	L.blaze_message = ">你< 光芒！"
	L.crash_say = ">我< 腐蚀碾压！"

	L.fury_bar = "<下一古加尔之怒>"
	L.fury_message = "古加尔之怒！"
	L.first_fury_soon = "即将 古加尔之怒！"
	L.first_fury_message = "85% - 开始古加尔之怒！"

	L.unleashed_shadows = "暗影释放！"

	L.phase2_message = "第二阶段"
	L.phase2_soon = "即将 第二阶段！"
end

L = BigWigs:NewBossLocale("Valiona and Theralion", "zhCN")
if L then
	L.phase_switch = "阶段转换"
	L.phase_switch_desc = "当进入不同阶段时发出警报。"

	L.phase_bar = "<%s落地>"
	L.breath_message = "即将 深呼吸！"
	L.dazzling_message = "即将 暮光领域！"

	L.blast_message = "暮光冲击波！"
	L.engulfingmagic_say = ">我< 噬体魔法！"
	L.engulfingmagic_cooldown = "<噬体魔法>"

	L.devouringflames_cooldown = "<噬体烈焰>"

	L.valiona_trigger = "瑟纳利昂，我去包抄门厅。堵住他们的退路！"
	L.win_trigger = "At least... Theralion dies with me..."

	L.twilight_shift = "暮光位移%2$dx：>%1$s<！"
end

L = BigWigs:NewBossLocale("Halfus Wyrmbreaker", "zhCN")
if L then
	L.paralysis_bar = "<下一麻痹>"
	L.strikes_message = "致伤打击%2$dx：>%1$s<！"

	L.breath_message = "即将 灼热气息！"
	L.breath_bar = "<灼热气息>"

	L.engage_yell = "古加尔想要你们全部的脑袋！"
end

L = BigWigs:NewBossLocale("Sinestra", "zhCN")
if L then
	L.whelps = "暮光幼龙"
	L.whelps_desc = "当每波暮光幼龙到来时发出警报。"

	L.slicer_message = "可能暮光切割射线目标！"

	L.egg_vulnerable = "集中火力攻击！"

	L.whelps_trigger = "Feed, children!  Take your fill from their meaty husks!"
	L.omelet_trigger = "You mistake this for weakness?  Fool!"

	L.phase13 = "第一和第三阶段"
	L.phase = "阶段"
	L.phase_desc = "当进入不同阶段时发出警报。"
end

L = BigWigs:NewBossLocale("Ascendant Council", "zhCN")
if L then
	L.static_overload_say = ">我< 静电过载！"
	L.gravity_core_say = ">我< 重力核心！"
	L.health_report = "%s生命值>%d%%<，即将阶段转换！"
	L.switch = "转换"
	L.switch_desc = "当首领转换时发出警报。"

	L.shield_up_message = "烈火之盾 出现！"
	L.shield_down_message = "烈火之盾 消失！"
	L.shield_bar = "<下一烈火之盾>"

	L.switch_trigger = "我们会解决他们！"

	L.thundershock_quake_soon = "约10秒后，%s！"

	L.quake_trigger = "你脚下的地面发出不祥的“隆隆”声……"
	L.thundershock_trigger = "周围的空气因为充斥着强大的能量而发出“噼啪”声……"

	L.thundershock_quake_spam = ">%s< %d！"

	L.last_phase_trigger = "令人印象深刻……"
end

