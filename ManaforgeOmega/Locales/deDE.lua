local L = BigWigs:NewBossLocale("Loom'ithar", "deDE")
if not L then return end
if L then
	L.lair_weaving = "Netze" -- Webs that spawn on the edge of the room
	L.infusion_pylons = "Pylonen" -- Short for Infusion Pylons
end

L = BigWigs:NewBossLocale("Soulbinder Naazindhri", "deDE")
if L then
	L.voidblade_ambush = "Hinterhalt" -- Short for Voidblade Ambush
	L.soulfray_annihilation = "Linien" -- Lines that shoot out an orb along that path
	L.soulfray_annihilation_single = "Linie" -- Single from Lines
	--L.remaining_adds = "Remaining Adds" -- All remaining adds from Soul Calling spawn
end

L = BigWigs:NewBossLocale("Forgeweaver Araz", "deDE")
if L then
	L.invoke_collector = "Sammler" -- Short for Arcane Collector
end

L = BigWigs:NewBossLocale("Fractillus", "deDE")
if L then
	L.crystalline_eruption = "Wände"
	L.shattershell = "Brechen"
	L.shockwave_slam = "Tank Wand"
	L.nexus_shrapnel = "Schrapnell landet"
	L.crystal_lacerations = "Blutung"
end

L = BigWigs:NewBossLocale("Nexus-King Salhadaar", "deDE")
if L then
	L.oath_bound_removed_dose = "1x Eidgebunden entfernt"
	L.behead = "Klauen" -- Claws of a dragon
	L.netherbreaker = "Zirkel"
	L.galaxy_smash = "Schmettern" -- Short for Galactic Smash, and multiple of them.
	L.starkiller_swing = "Sternentöter" -- Short for Starkiller Swing, and multiple of them.
	L.vengeful_oath = "Geister"
end

L = BigWigs:NewBossLocale("Dimensius, the All-Devouring", "deDE")
if L then
	L.shattered_space = "Hände" -- Dimensius reaches down with both hands
	L.reverse_gravity = "Gravitation" -- Short for Reverse Gravity
	L.extinction = "Fragment" -- Dimensius hurls a fragment of a broken world
	L.slows = "Verlangsamungen"
	L.slow = "Verlangsamung" -- Singular of Slows
	L.stardust_nova = "Nova" -- Short for Stardust Nova
	L.extinguish_the_stars = "Sterne" -- Short for Extinguish the Stars
	L.darkened_sky = "Ringe"
	L.cosmic_collapse = "Kollaps" -- Short for Cosmic Collapse
end
