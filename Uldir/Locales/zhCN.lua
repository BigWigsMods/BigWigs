local L = BigWigs:NewBossLocale("MOTHER", "zhCN")
if not L then return end
if L then
	L.sideLaser = "侧面光束" -- short for: (location) Uldir Defensive Beam
	L.upLaser = "顶部光束"
	L.mythic_beams = "双重光束"
end

L = BigWigs:NewBossLocale("Zek'voz, Herald of N'zoth", "zhCN")
if L then
	L.surging_darkness_eruption = "翻腾黑暗（%d）"
	L.mythic_adds = "史诗模式增援"
	L.mythic_adds_desc = "替史詩模式特有的小怪組合顯示計時器（异种虫战士和蛛魔虚空编织者同时出现的那一波）。"
end

L = BigWigs:NewBossLocale("Fetid Devourer", "zhCN")
if L then
	L.breath = "{262292} （{18609}）" -- Rotting Regurgitation (Breath)
end

L = BigWigs:NewBossLocale("Zul", "zhCN")
if L then
	L.crawg_msg = "抱齿兽" -- Short for 'Bloodthirsty Crawg'
	L.crawg_desc = "替抱齿兽的生成显示计时器和警告。"

	L.bloodhexer_msg = "鲜血妖术师" -- Short for 'Nazmani Bloodhexer'
	L.bloodhexer_desc = "替鲜血妖术师的生成显示计时器和警告。"

	L.crusher_msg = "碾压者" -- Short for 'Nazmani Crusher'
	L.crusher_desc = "替碾压者的生成显示计时器和警告。"

	L.custom_off_decaying_flesh_marker = "腐烂血肉标记"
	L.custom_off_decaying_flesh_marker_desc = "使用 {rt8} 标记受到腐烂血肉效果的敌人，需要权限。"
end

L = BigWigs:NewBossLocale("Mythrax the Unraveler", "zhCN")
if L then
	L.destroyer_cast = "恩拉其毁灭者：%s" -- npc id: 139381
	L.xalzaix_returned = "夏尔扎克斯出现！" -- npc id: 138324
	L.add_blast = "小怪湮灭冲击"
	L.boss_blast = "首领湮灭冲击"
end

L = BigWigs:NewBossLocale("G'huun", "zhCN")
if L then
	L.orbs_deposited = "充能（%d／3） - %.1f秒"
	L.orb_spawning = "能量矩阵出现"
	L.orb_spawning_side = "能量矩阵出现 (%s)"
	--L.left = "Left"
	--L.right = "Right"

	L.custom_on_fixate_plates = "敌对姓名板凝视图标"
	L.custom_on_fixate_plates_desc = "当你被凝视时在目标姓名板上显示一个图标。\n需要使用敌对姓名板。此功能目前只支持 KuiNameplates。"
end
