local L = BigWigs:NewBossLocale("Loom'ithar", "esES")
if not L then return end
if L then
	L.lair_weaving = "Telarañas" -- Webs that spawn on the edge of the room
	L.infusion_pylons = "Pilones" -- Short for Infusion Pylons
end

L = BigWigs:NewBossLocale("Soulbinder Naazindhri", "esES")
if L then
	L.voidblade_ambush = "Emboscada" -- Short for Voidblade Ambush
	L.soulfray_annihilation = "Líneas" -- Lines that shoot out an orb along that path
	L.soulfray_annihilation_single = "Línea" -- Single from Lines
	L.remaining_adds = "Esbirros restantes" -- All remaining adds from Soul Calling spawn
end

L = BigWigs:NewBossLocale("Forgeweaver Araz", "esES")
if L then
	L.invoke_collector = "Recolector" -- Short for Arcane Collector
end

L = BigWigs:NewBossLocale("Fractillus", "esES")
if L then
	L.crystalline_eruption = "Muros"
	L.shattershell = "Romper"
	L.shockwave_slam = "Muro de tanque"
	L.nexus_shrapnel = "Cae metralla"
	L.crystal_lacerations = "Sangrado"
end

L = BigWigs:NewBossLocale("Nexus-King Salhadaar", "esES")
if L then
	L.oath_bound_removed_dose = "1x Vinculado por el voto eliminado"
	L.behead = "Garras" -- Claws of a dragon
	L.netherbreaker = "Círculos"
	L.galaxy_smash = "Machaques" -- Short for Galactic Smash, and multiple of them.
	L.starkiller_swing = "Mataestrellas" -- Short for Starkiller Swing, and multiple of them.
	L.vengeful_oath = "Espíritus"
end

L = BigWigs:NewBossLocale("Dimensius, the All-Devouring", "esES")
if L then
	L.reverse_gravity = "Gravedad" -- Short for Reverse Gravity
	L.extinction = "Fragmento" -- Dimensius hurls a fragment of a broken world
	L.slows = "Frenados"
	L.slow = "Frenado" -- Singular of Slows
	L.stardust_nova = "Nova" -- Short for Stardust Nova
	L.extinguish_the_stars = "Estrellas" -- Short for Extinguish the Stars
	L.darkened_sky = "Anillos"
	L.cosmic_collapse = "Colapso" -- Short for Cosmic Collapse
	L.soaring_reshii = "Montura disponible" -- On the timer for when flying is available

	L.weakened_soon_monster_yell = "¡Debemos de atacar ya!" -- [CHAT_MSG_MONSTER_YELL] We must strike--now!#Xal'atath###Xal'atath##0#0##0#4873#nil#0#false#false#false#false",
end
