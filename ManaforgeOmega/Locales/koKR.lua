local L = BigWigs:NewBossLocale("Loom'ithar", "koKR")
if not L then return end
if L then
	L.lair_weaving = "거미줄" -- Webs that spawn on the edge of the room
	L.infusion_pylons = "수정탑" -- Short for Infusion Pylons
end

L = BigWigs:NewBossLocale("Soulbinder Naazindhri", "koKR")
if L then
	L.voidblade_ambush = "매복" -- Short for Voidblade Ambush
	L.soulfray_annihilation = "구슬" -- Lines that shoot out an orb along that path
	L.soulfray_annihilation_single = "라인" -- Single from Lines
end

L = BigWigs:NewBossLocale("Forgeweaver Araz", "koKR")
if L then
	--L.invoke_collector = "Collector" -- Short for Arcane Collector
end

L = BigWigs:NewBossLocale("Fractillus", "koKR")
if L then
	L.crystalline_eruption = "벽"
	L.shattershell = "제거"
	L.shockwave_slam = "탱커 벽"
	L.nexus_shrapnel = "파편"
	L.crystal_lacerations = "출혈"
end

L = BigWigs:NewBossLocale("Nexus-King Salhadaar", "koKR")
if L then
	--L.oath_bound_removed_dose = "1x Oath-Bound Removed"
	--L.behead = "Claws" -- Claws of a dragon
	--L.netherbreaker = "Circles"
	--L.galaxy_smash = "Smashes" -- Short for Galactic Smash, and multiple of them.
	--L.starkiller_swing = "Starkillers" -- Short for Starkiller Swing, and multiple of them.
	--L.vengeful_oath = "Spirits"
end
