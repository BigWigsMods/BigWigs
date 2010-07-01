
local L = BigWigs:NewBossLocale("Archavon the Stone Watcher", "zhTW")
if L then
	L.stomp_message = "踐踏 - 即將 衝鋒！"
	L.stomp_warning = "約5秒後，可能踐踏！"
	L.stomp_bar = "<踐踏 冷卻>"

	L.cloud_message = ">你< 窒息之雲！"

	L.charge = "衝鋒"
	L.charge_desc = "當玩家中了衝鋒時發出警報。"
end

L = BigWigs:NewBossLocale("Emalon the Storm Watcher", "zhTW")
if L then
	L.nova_next = "<閃電新星 冷卻>"

	L.overcharge_message = "暴雨爪牙 - 超載！"
	L.overcharge_bar = "<爆炸>"
	L.overcharge_next = "<下一超載>"
end

L = BigWigs:NewBossLocale("Halion", "zhTW")
if L then
	L.engage_trigger = "你們的世界在滅亡的邊緣搖搖欲墜。你們接下來全都會見證這個毀滅新紀元的來臨!"

	L.phase_two_trigger = "在暮光的國度只有磨難在等著你!有膽量的話就進去吧!"

	L.twilight_cutter_trigger = "暗影無所不在!"
	L.twilight_cutter_bar = "<暮光切割>"
	L.twilight_cutter_warning = "即將 暮光切割！"

	L.fire_message = "熾熱燃灼！"
	L.shadow_message = "靈魂耗損！"

	L.meteorstrike_bar = "<隕石轟擊>"

	L.breath_cooldown = "下一闇息術！"
end

L = BigWigs:NewBossLocale("Koralon the Flame Watcher", "zhTW")
if L then
	L.cinder_message = ">你< 燃焰餘燼！"

	L.breath_bar = "<燃燒之息：%d>"
	L.breath_message = "即將 燃燒之息：>%d<！"
end

L = BigWigs:NewBossLocale("Malygos", "zhTW")
if L then
	L.sparks = "力量火花"
	L.sparks_desc = "當力量火花出現時發出警報。"
	L.sparks_message = "出現 力量火花！"
	L.sparks_warning = "約5秒後，力量火花！"

	L.sparkbuff = "瑪里苟斯獲得力量火花"
	L.sparkbuff_desc = "當瑪里苟斯獲得力量火花時發出警報。"
	L.sparkbuff_message = "瑪里苟斯：>力量火花<！"

	L.vortex = "漩渦"
	L.vortex_desc = "當施放漩渦時發出警報及顯示計時條。"
	L.vortex_message = "漩渦！"
	L.vortex_warning = "約5秒後，可能漩渦！"
	L.vortex_next = "<漩渦 冷卻>"

	L.breath = "深呼吸"
	L.breath_desc = "當施放深呼吸時發出警報。"
	L.breath_message = "深呼吸！"
	L.breath_warning = "約5秒後，深呼吸！"

	L.surge = "力量奔騰"
	L.surge_desc = "當玩家中了力量奔騰時發出警報。"
	L.surge_you = ">你< 力量奔騰！"
	L.surge_trigger = "%s將他的目光鎖在你身上!"

	L.phase = "階段"
	L.phase_desc = "當進入不同階段時發出警報。"
	L.phase2_warning = "即將 第二階段！"
	L.phase2_trigger = "我原本只是想盡快結束你們的生命"
	L.phase2_message = "第二階段 - 奧核領主與永恆之裔！"
	L.phase2_end_trigger = "夠了!既然你們這麼想奪回艾澤拉斯的魔法，我就給你們!"
	L.phase3_warning = "即將 第三階段！"
	L.phase3_trigger = "現在你們幕後的主使終於出現"
	L.phase3_message = "第三階段！"
end

L = BigWigs:NewBossLocale("Sartharion", "zhTW")
if L then
	L.engage_trigger = "我的職責就是要看守這些龍蛋。在他們受到任何傷害之前，我將會看著你陷入火焰之中!"

	L.tsunami = "炎嘯"
	L.tsunami_desc = "當熔岩攪動時發出警報及顯示計時條。"
	L.tsunami_warning = "約5秒，炎嘯！"
	L.tsunami_message = "炎嘯！"
	L.tsunami_cooldown = "炎嘯冷卻！"
	L.tsunami_trigger = "圍繞著%s的熔岩開始劇烈地翻騰!"

	L.breath_cooldown = "火息術冷卻！"

	L.drakes = "飛龍增援"
	L.drakes_desc = "當每只飛龍增援加入戰鬥時發出警報。"
	L.drakes_incomingsoon = "約5秒後。%s即將到來！"

	L.twilight = "暮光召喚"
	L.twilight_desc = "當暮光召喚時發出警報。"
	L.twilight_trigger_tenebron = "坦納伯朗在暮光中孵化龍蛋!"
	L.twilight_trigger_vesperon = "一個維斯佩朗信徒從暮光中出現!"
	L.twilight_trigger_shadron = "一個夏德朗信徒從暮光中出現!"
	L.twilight_message_tenebron = "正在孵卵！"
	L.twilight_message = "%s到來！"
end

L = BigWigs:NewBossLocale("Toravon the Ice Watcher", "zhTW")
if L then
	L.whiteout_bar = "寒霜厲雪：>%d<！"
	L.whiteout_message = "即將寒霜厲雪：>%d<！"

	L.frostbite_message = "%2$dx霜寒刺骨：>%1$s<！"

	L.freeze_message = "冰凍之地！"

	L.orb_bar = "<下一冰凍寶珠>"
end