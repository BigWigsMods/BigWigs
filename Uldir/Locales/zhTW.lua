local L = BigWigs:NewBossLocale("MOTHER", "zhTW")
if not L then return end
if L then
	L.sideLaser = "側面光束" -- short for: (location) Uldir Defensive Beam
	L.upLaser = "頂部光束"
	L.mythic_beams = "光束"
end

L = BigWigs:NewBossLocale("Zek'voz, Herald of N'zoth", "zhTW")
if L then
	L.surging_darkness_eruption = "Eruption (%d)"
	L.mythic_adds = "傳奇模式增援"
	L.mythic_adds_desc = "替傳奇模式特有的小怪組合顯示計時器（異種蠍戰士和奈幽虛織者同時出現的那一波）。"
end

L = BigWigs:NewBossLocale("Fetid Devourer", "zhTW")
if L then
	L.breath = "{262292} （{18609}）" -- Rotting Regurgitation (Breath)
end

L = BigWigs:NewBossLocale("Zul", "zhTW")
if L then
	L.crawg_msg = "克洛格" -- Short for 'Bloodthirsty Crawg'
	L.crawg_desc = "替克洛格的生成顯示計時器和警告"

	L.bloodhexer_msg = "血咒師" -- Short for 'Nazmani Bloodhexer'
	L.bloodhexer_desc = "替血咒師的生成顯示計時器和警告"

	L.crusher_msg = "粉碎者" -- Short for 'Nazmani Crusher'
	L.crusher_desc = "替粉碎者的生成顯示計時器和警告"

	L.custom_off_decaying_flesh_marker = "腐朽肉體標記"
	L.custom_off_decaying_flesh_marker_desc = "用 {rt8} 標記受到腐朽肉體效果的敵人，需要權限。"
end

L = BigWigs:NewBossLocale("Mythrax the Unraveler", "zhTW")
if L then
	L.destroyer_cast = "恩拉奇毀滅者：%s" -- npc id: 139381
	L.xalzaix_returned = "薩爾札克斯出現！" -- npc id: 138324
	L.add_blast = "小怪滅寂衝擊"
	L.boss_blast = "首領滅寂衝擊"
end

L = BigWigs:NewBossLocale("G'huun", "zhTW")
if L then
	L.orbs_deposited = "充能（%d／3） - %.1f秒"
	L.orb_spawning = "能量矩陣出現"
	L.orb_spawning_side = "能量矩陣出現 (%s)"
	L.left = "左"
	L.right = "右"

	L.custom_on_fixate_plates = "在敵方名條顯示追擊圖示"
	L.custom_on_fixate_plates_desc = "當你被凝視時，在敵方名條上顯示一個圖示。\n需要啟用敵方名條，此功能目前只支援KuiNameplates。"
end
