local L = LibStub("AceLocale-3.0"):NewLocale("BigWigsArchavon the Stone Watcher", "zhCN")
if L then
	L.stomp_message = "践踏 - 即将 冲锋！"
	L.stomp_warning = "约5秒后，可能践踏！"
	L.stomp_bar = "<践踏 冷却>"

	L.cloud_message = ">你< 窒息云雾！"

	L.charge = "冲锋"
	L.charge_desc = "当玩家中了冲锋时发出警报。"

	L.icon = "团队标记"
	L.icon_desc = "为中了岩石碎片的玩家打上团队标记。（需要权限）"
end


L = LibStub("AceLocale-3.0"):NewLocale("BigWigsEmalon the Storm Watcher", "zhCN")
if L then
	L.nova_next = "<闪电新星 冷却>"

	L.overcharge_message = "minion - 超载！"
	L.overcharge_bar = "<爆炸>"
	L.overcharge_next = "<下一超载>"

	L.icon = "超载标记"
	L.icon_desc = "为中了超载的怪物打上团队标记。（需要权限）"
end


L = LibStub("AceLocale-3.0"):NewLocale("BigWigsMalygos", "zhCN")
if L then
	L.sparks = "能量火花"
	L.sparks_desc = "当能量火花出现时发出警报。"
	L.sparks_message = "出现 能量火花！"
	L.sparks_warning = "约5秒后，能量火花！"

	L.sparkbuff_message = "玛里苟斯获得：>能量火花<！"
	
	L.vortex = "漩涡"
	L.vortex_desc = "当施放漩涡时发出警报及显示计时条。"
	L.vortex_message = "漩涡！"
	L.vortex_warning = "约5秒后，可能漩涡！"
	L.vortex_next = "<漩涡 冷却>"

	L.breath = "深呼吸"
	L.breath_desc = "当施放深呼吸时发出警报。"
	L.breath_message = "深呼吸！"
	L.breath_warning = "约5秒后，深呼吸！"

	L.surge = "能量涌动"
	L.surge_desc = "当玩家中了能量涌动时发出警报。"
	L.surge_you = ">你< 能量涌动！"
	L.surge_trigger = "%s fixes his eyes on you!" -- yell required

	L.phase = "阶段"
	L.phase_desc = "当进入不同阶段时发出警报。"
	L.phase2_warning = "即将 第二阶段！"
	L.phase2_trigger = "I had hoped to end your lives quickly" -- yell required
	L.phase2_message = "第二阶段 - 魔枢领主与永恒子嗣!"
	L.phase2_end_trigger = "ENOUGH! If you intend to reclaim Azeroth's magic" -- yell required
	L.phase3_warning = "即将 第三阶段！"
	L.phase3_trigger = "Now your benefactors make their" -- yell required
	L.phase3_message = "第三阶段！"
end

L = Libstub("AceLocale-3.0"):NewLocale("BigWigsSartharion", "zhCN")
if L then
	L.tsunami = "烈焰之啸"
	L.tsunami_desc = "当熔岩搅动时显示计时条。"
	L.tsunami_warning = "约5秒，烈焰之啸！"
	L.tsunami_message = "烈焰之啸！"
	L.tsunami_cooldown = "烈焰之啸冷却！"
	L.tsunami_trigger = "The lava surrounding %s churns!" --check

	L.breath_cooldown = "烈焰吐息冷却！"

	L.drakes = "幼龙增援"
	L.drakes_desc = "当每只幼龙增援加入战斗时发出警报。"
	L.drakes_incomingsoon = "约5秒后，%s即将到来！"

	L.twilight = "暮光召唤"
	L.twilight_desc = "当暮光召唤时发出警报。"
	L.twilight_trigger_tenebron = "塔尼布隆在暮光中孵化龙蛋！" --check
	L.twilight_trigger_vesperon = "一个维斯匹隆的信徒从暮光中出现！" --check
	L.twilight_trigger_shadron = "一个沙德隆的信徒从暮光中出现！" --check
	L.twilight_message_tenebron = "正在孵卵！"
	L.twilight_message = "%s到来！"
end
