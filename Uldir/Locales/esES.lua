local L = BigWigs:NewBossLocale("MOTHER", "esES") or BigWigs:NewBossLocale("MOTHER", "esMX")
if not L then return end
if L then
	--L.sideLaser = "(Side) Beams" -- short for: (location) Uldir Defensive Beam
	--L.upLaser = "(Roof) Beams"
	--L.mythic_beams = "(Side + Roof) Beams"
end

L = BigWigs:NewBossLocale("Zek'voz, Herald of N'zoth", "esES") or BigWigs:NewBossLocale("Zek'voz, Herald of N'zoth", "esMX")
if L then
	--L.surging_darkness_eruption = "Eruption (%d)"
	--L.mythic_adds = "Mythic Adds"
	--L.mythic_adds_desc = "Show timers for when the adds will spawn in Mythic (both Qiraji Warrior and Anub'ar Voidweaver spawn at the same time)."
end

L = BigWigs:NewBossLocale("Zul", "esES") or BigWigs:NewBossLocale("Zul", "esMX")
if L then
	--L.crawg_msg = "Crawg" -- Short for 'Bloodthirsty Crawg'
	--L.crawg_desc = "Warnings and timers for when the Bloodthirsty Crawg spawns."

	--L.bloodhexer_msg = "Bloodhexer" -- Short for 'Nazmani Bloodhexer'
	--L.bloodhexer_desc = "Warnings and timers for when the Nazmani Bloodhexer spawns."

	--L.crusher_msg = "Crusher" -- Short for 'Nazmani Crusher'
	--L.crusher_desc = "Warnings and timers for when the Nazmani Crusher spawns."

	--L.custom_off_decaying_flesh_marker = "Decaying Flesh Marker"
	--L.custom_off_decaying_flesh_marker_desc = "Mark the enemy forces afflicted by Decaying Flesh with {rt8}, requires promoted or leader."
end

L = BigWigs:NewBossLocale("Mythrax the Unraveler", "esES") or BigWigs:NewBossLocale("Zul", "esMX")
if L then
	--L.destroyer_cast = "%s (N'raqi Destroyer)" -- npc id: 139381
	--L.xalzaix_returned = "Xalzaix returned!" -- npc id: 138324
	--L.add_blast = "Add Blast"
	--L.boss_blast = "Boss Blast"
end

L = BigWigs:NewBossLocale("G'huun", "esES") or BigWigs:NewBossLocale("G'huun", "esMX")
if L then
	--L.orbs_deposited = "Orbs Deposited (%d/3) - %.1f sec"
	--L.orb_spawning = "Orb Spawning"
	--L.orb_spawning_side = "Orb Spawning (%s)"
	--L.left = "Left"
	--L.right = "Right"

	--L.custom_on_fixate_plates = "Fixate icon on Enemy Nameplate"
	--L.custom_on_fixate_plates_desc = "Show an icon on the target nameplate that is fixating on you.\nRequires the use of Enemy Nameplates. This feature is currently only supported by KuiNameplates."
end
