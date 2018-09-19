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
	--L.mythic_adds_desc = "Show timers for when the adds will spawn in Mythic (both Qiraji Warrior and Anub'ar Voidweaver spawn at the same time)."
end

L = BigWigs:NewBossLocale("Fetid Devourer", "zhCN")
if L then
	L.breath = "{262292} （{18609}）" -- Rotting Regurgitation (Breath)
end

L = BigWigs:NewBossLocale("Zul", "zhCN")
if L then
	L.crawg_msg = "抱齿兽" -- Short for 'Bloodthirsty Crawg'
	--L.crawg_desc = "Warnings and timers for when the Bloodthirsty Crawg spawns."

	L.bloodhexer_msg = "鲜血妖术师" -- Short for 'Nazmani Bloodhexer'
	--L.bloodhexer_desc = "Warnings and timers for when the Nazmani Bloodhexer spawns."

	L.crusher_msg = "碾压者" -- Short for 'Nazmani Crusher'
	--L.crusher_desc = "Warnings and timers for when the Nazmani Crusher spawns."

	--L.custom_off_decaying_flesh_marker = "Decaying Flesh Marker"
	--L.custom_off_decaying_flesh_marker_desc = "Mark the enemy forces afflicted by Decaying Flesh with {rt8}, requires promoted or leader."
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

	--L.custom_on_fixate_plates = "Fixate icon on Enemy Nameplate"
	--L.custom_on_fixate_plates_desc = "Show an icon on the target nameplate that is fixating on you.\nRequires the use of Enemy Nameplates. This feature is currently only supported by KuiNameplates."
end
