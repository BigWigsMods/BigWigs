local L = BigWigs:NewBossLocale("Loom'ithar", "itIT")
if not L then return end
if L then
	L.lair_weaving = "Ragnatele" -- Webs that spawn on the edge of the room
	L.infusion_pylons = "Piloni" -- Short for Infusion Pylons
end

L = BigWigs:NewBossLocale("Soulbinder Naazindhri", "itIT")
if L then
	L.voidblade_ambush = "Imboscata" -- Short for Voidblade Ambush
	L.soulfray_annihilation = "Linee" -- Lines that shoot out an orb along that path
	L.soulfray_annihilation_single = "Linea" -- Single from Lines
	L.remaining_adds = "Addini Rimanenti" -- All remaining adds from Soul Calling spawn
end

L = BigWigs:NewBossLocale("Forgeweaver Araz", "itIT")
if L then
	L.invoke_collector = "Collectore" -- Short for Arcane Collector
end

L = BigWigs:NewBossLocale("Fractillus", "itIT")
if L then
	L.crystalline_shockwave = "Muri"
	L.shattershell = "Spacca"
	L.shockwave_slam = "Muro Tank"
	L.nexus_shrapnel = "Arriva la Scheggia"
	L.crystal_lacerations = "Sanguinamento"
end

L = BigWigs:NewBossLocale("Nexus-King Salhadaar", "itIT")
if L then
	L.fractal_images = "Draghi"
	L.oath_bound_removed_dose = "1x Conquista Rimossa"
	L.behead = "Artigli" -- Claws of a dragon
	L.netherbreaker = "Cerchi"
	L.galaxy_smash = "Frantumazioni" -- Short for Galactic Smash, and multiple of them.
	L.starkiller_swing = "Annientastelle" -- Short for Starkiller Swing, and multiple of them.
	L.vengeful_oath = "Spettri"
end

L = BigWigs:NewBossLocale("Dimensius, the All-Devouring", "itIT")
if L then
	L.gravity = "Gravità" -- Short for Reverse Gravity
	L.extinction = "frammento" -- Dimensius hurls a fragment of a broken world
	L.slows = "Rallentamenti"
	L.slow = "Rallentamento" -- Singular of Slows
	L.mass_destruction = "Linee"
	L.mass_destruction_single = "Linea"
	L.stardust_nova = "Nova" -- Short for Stardust Nova
	L.extinguish_the_stars = "Stelle" -- Short for Extinguish the Stars
	L.darkened_sky = "Anelli"
	L.cosmic_collapse = "Tank Pulla"
	L.cosmic_collapse_easy = "Frantumazione"
	L.soaring_reshii = "Mount Disponibile" -- On the timer for when flying is available

	L.left_living_mass = "Living Mass (Sinistra)"
	L.right_living_mass = "Living Mass (Destra)"

	L.soaring_reshii_monster_yell = "Finora avete agito bene." -- [CHAT_MSG_MONSTER_YELL] You've done well so far. Surprising. But we're not done yet.#Xal'atath###Meeresflask##0#0##0#256#nil#0#false#false#false#false",

	L.weakened_soon_monster_yell = "Dobbiamo colpire, ora!" -- [CHAT_MSG_MONSTER_YELL] We must strike--now!#Xal'atath###Xal'atath##0#0##0#4873#nil#0#false#false#false#false",
end
