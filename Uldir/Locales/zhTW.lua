local L = BigWigs:NewBossLocale("MOTHER", "zhTW")
if not L then return end
if L then
	L.sideLaser = "側面光束" -- short for: (location) Uldir Defensive Beam
	L.upLaser = "頂部光束"
	L.mythic_beams = "雙重光束"
end

L = BigWigs:NewBossLocale("Zek'voz, Herald of N'zoth", "zhTW")
if L then
	L.surging_darkness_eruption = "Eruption (%d)"
	L.mythic_adds = "傳奇模式增援"
	--L.mythic_adds_desc = "Show timers for when the adds will spawn in Mythic (both Qiraji Warrior and Anub'ar Voidweaver spawn at the same time)."
end

L = BigWigs:NewBossLocale("Fetid Devourer", "zhTW")
if L then
	L.breath = "{262292} （{18609}）" -- Rotting Regurgitation (Breath)
end

L = BigWigs:NewBossLocale("Zul", "zhTW")
if L then
	L.crawg_msg = "克洛格Crawg" -- Short for 'Bloodthirsty Crawg'
	--L.crawg_desc = "Warnings and timers for when the Bloodthirsty Crawg spawns."

	L.bloodhexer_msg = "血咒師" -- Short for 'Nazmani Bloodhexer'
	--L.bloodhexer_desc = "Warnings and timers for when the Nazmani Bloodhexer spawns."

	L.crusher_msg = "粉碎者" -- Short for 'Nazmani Crusher'
	--L.crusher_desc = "Warnings and timers for when the Nazmani Crusher spawns."

	--L.custom_off_decaying_flesh_marker = "Decaying Flesh Marker"
	--L.custom_off_decaying_flesh_marker_desc = "Mark the enemy forces afflicted by Decaying Flesh with {rt8}, requires promoted or leader."
end

L = BigWigs:NewBossLocale("Mythrax the Unraveler", "zhTW")
if L then
	L.destroyer_cast = "恩拉奇毀滅者：%s" -- npc id: 139381
	L.xalzaix_returned = "薩爾札克斯出現！Xalzaix returned!" -- npc id: 138324
	--L.add_blast = "Add Blast"
	--L.boss_blast = "Boss Blast"
end

L = BigWigs:NewBossLocale("G'huun", "zhTW")
if L then
	L.orbs_deposited = "充能（%d／3） - %.1f秒"
	L.orb_spawning = "能量矩陣出現"

	--L.custom_on_fixate_plates = "Fixate icon on Enemy Nameplate"
	--L.custom_on_fixate_plates_desc = "Show an icon on the target nameplate that is fixating on you.\nRequires the use of Enemy Nameplates. This feature is currently only supported by KuiNameplates."
end
