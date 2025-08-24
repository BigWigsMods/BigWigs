local L = BigWigs:NewBossLocale("Loom'ithar", "frFR")
if not L then return end
if L then
	L.lair_weaving = "Toiles" -- Webs that spawn on the edge of the room
	L.infusion_pylons = "Pylônes" -- Short for Infusion Pylons
end

L = BigWigs:NewBossLocale("Soulbinder Naazindhri", "frFR")
if L then
	L.voidblade_ambush = "Embuscade" -- Short for Voidblade Ambush
	L.soulfray_annihilation = "Lignes" -- Lines that shoot out an orb along that path
	L.soulfray_annihilation_single = "Ligne" -- Single from Lines
	L.remaining_adds = "Adds restants" -- All remaining adds from Soul Calling spawn
end

L = BigWigs:NewBossLocale("Forgeweaver Araz", "frFR")
if L then
	L.invoke_collector = "Collecteur" -- Short for Arcane Collector
end

L = BigWigs:NewBossLocale("Fractillus", "frFR")
if L then
	L.crystalline_shockwave = "Murs"
	L.shattershell = "Casser"
	L.shockwave_slam = "Mur Tank"
	L.nexus_shrapnel = "Éclats atterrissent"
	L.crystal_lacerations = "Saignement"
end

L = BigWigs:NewBossLocale("Nexus-King Salhadaar", "frFR")
if L then
	--L.fractal_images = "Dragons"
	L.oath_bound_removed_dose = "1x Lien par serment enlevé"
	L.behead = "Griffes" -- Claws of a dragon
	L.netherbreaker = "Cercles"
	L.galaxy_smash = "Chocs" -- Short for Galactic Smash, and multiple of them.
	L.starkiller_swing = "Fléaux stellaires" -- Short for Starkiller Swing, and multiple of them.
	L.vengeful_oath = "Esprits"
end

L = BigWigs:NewBossLocale("Dimensius, the All-Devouring", "frFR")
if L then
	L.gravity = "Gravité" -- Short for Reverse Gravity
	L.extinction = "Fragment" -- Dimensius hurls a fragment of a broken world
	L.slows = "Ralentissements"
	L.slow = "Ralentissement" -- Singular of Slows
	--L.mass_destruction = "Lines"
	L.stardust_nova = "Nova" -- Short for Stardust Nova
	L.extinguish_the_stars = "Étoiles" -- Short for Extinguish the Stars
	L.darkened_sky = "Anneaux"
	L.cosmic_collapse = "Effondrement" -- Short for Cosmic Collapse
	L.soaring_reshii = "Monture disponible" -- On the timer for when flying is available

	--L.weakened_soon_monster_yell = "We must strike--now!" -- [CHAT_MSG_MONSTER_YELL] We must strike--now!#Xal'atath###Xal'atath##0#0##0#4873#nil#0#false#false#false#false",
end
