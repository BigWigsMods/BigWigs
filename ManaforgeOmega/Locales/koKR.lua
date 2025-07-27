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

L = BigWigs:NewBossLocale("Fractillus", "koKR")
if L then
	--L.crystalline_eruption = "Walls"
	--L.shattershell = "Breaks"
	--L.shockwave_slam = "Tank Wall"
	--L.nexus_shrapnel = "Shrapnel Lands"
	--L.crystal_lacerations = "Bleed"
end
