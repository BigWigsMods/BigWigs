local L = BigWigs:NewBossLocale("MOTHER", "zhCN")
if not L then return end
if L then
	L.sideLaser = "侧面射线" -- short for: (location) Uldir Defensive Beam
	L.upLaser = "顶部射线"
	L.mythic_beams = "射线"
end

L = BigWigs:NewBossLocale("Zek'voz, Herald of N'zoth", "zhCN")
if L then
	L.surging_darkness_eruption = "翻腾黑暗（%d）"
	L.mythic_adds = "史诗增援"
	L.mythic_adds_desc = "当在史诗模式下即将出现增援时显示计时器。（异种虫战士和蛛魔虚空编织者同时出现）"
end

L = BigWigs:NewBossLocale("Fetid Devourer", "zhCN")
if L then
	L.breath = "{262292} （{18609}）" -- Rotting Regurgitation (Breath)
end

L = BigWigs:NewBossLocale("Zul", "zhCN")
if L then
	L.crawg_msg = "抱齿兽" -- Short for 'Bloodthirsty Crawg'
	L.crawg_desc = "当嗜血的抱齿兽出现时的计时器和警报。"

	L.bloodhexer_msg = "鲜血妖术师" -- Short for 'Nazmani Bloodhexer'
	L.bloodhexer_desc = "当纳兹曼尼鲜血妖术师出现时的计时器和警报。"

	L.crusher_msg = "碾压者" -- Short for 'Nazmani Crusher'
	L.crusher_desc = "当纳兹曼尼碾压者出现时的计时器和警报。"

	L.custom_off_decaying_flesh_marker = "腐烂血肉标记"
	L.custom_off_decaying_flesh_marker_desc = "使用 {rt8} 标记受到腐烂血肉效果的敌人，需要权限。"
end

L = BigWigs:NewBossLocale("Mythrax the Unraveler", "zhCN")
if L then
	L.destroyer_cast = "恩拉其毁灭者：%s" -- npc id: 139381
	L.xalzaix_returned = "夏尔扎克斯返场！" -- npc id: 138324
	L.add_blast = "增援湮灭冲击"
	L.boss_blast = "首领湮灭冲击"
end

L = BigWigs:NewBossLocale("G'huun", "zhCN")
if L then
	L.orbs_deposited = "充能（%d／3） - %.1f秒"
	L.orb_spawning = "能量矩阵出现"
	L.orb_spawning_side = "能量矩阵出现 (%s)"
	L.left = "左"
	L.right = "右"

	L.custom_on_fixate_plates = "敌对姓名板凝视图标"
	L.custom_on_fixate_plates_desc = "当你被凝视时在目标姓名板上显示一个图标。\n需要使用敌对姓名板。此功能目前只支持 KuiNameplates。"

	L.custom_on_stop_timers = "总是显示技能条"
	L.custom_on_stop_timers_desc = "戈霍恩可以延迟它的技能。当此选项开启时，这些技能条将会保留在屏幕上。"
end

L = BigWigs:NewBossLocale("Uldir Trash", "zhCN")
if L then
	L.watcher = "腐化的守护者"
	L.ascendant = "纳兹曼尼晋升者"
	L.dominator = "纳兹曼尼统御者"
end
