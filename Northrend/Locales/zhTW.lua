local L = LibStub("AceLocale-3.0"):NewLocale("BigWigsArchavon the Stone Watcher", "zhTW")
if L then
	L.stomp_message = "踐踏 - 即將 衝鋒！"
	L.stomp_warning = "約5秒後，可能踐踏！"
	L.stomp_bar = "<踐踏 冷卻>"

	L.cloud_message = ">你< 窒息之雲！"

	L.charge = "衝鋒"
	L.charge_desc = "當玩家中了衝鋒時發出警報。"

	L.icon = "團隊標記"
	L.icon_desc = "為中了岩石裂片的玩家打上團隊標記。（需要權限）"
end


L = LibStub("AceLocale-3.0"):NewLocale("BigWigsEmalon the Storm Watcher", "zhTW")
if L then
	L.nova_next = "<閃電新星 冷卻>"

	L.overcharge_message = " 暴雨爪牙 - 超載！"
	L.overcharge_bar = "<爆炸>"
	L.overcharge_next = "<下一超載>"

	L.icon = "超載標記"
	L.icon_desc = "為中了超載的怪物打上團隊標記。（需要權限）"
end


L = LibStub("AceLocale-3.0"):NewLocale("BigWigsMalygos", "zhTW")
if L then
	L.sparks = "力量火花"
	L.sparks_desc = "當力量火花出現時發出警報。"
	L.sparks_message = "出現 力量火花！"
	L.sparks_warning = "約5秒後，力量火花！"

	L.sparkbuff_message = "瑪里苟斯獲得：>力量火花<！"

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

L = LibStub("AceLocale-3.0"):NewLocale("BigWigsSartharion", "zhTW")
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
