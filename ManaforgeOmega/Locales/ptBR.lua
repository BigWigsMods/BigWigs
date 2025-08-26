local L = BigWigs:NewBossLocale("Loom'ithar", "ptBR")
if not L then return end
if L then
	L.lair_weaving = "Teias" -- Webs that spawn on the edge of the room
	L.infusion_pylons = "Pilares" -- Short for Infusion Pylons
end

L = BigWigs:NewBossLocale("Soulbinder Naazindhri", "ptBR")
if L then
	L.voidblade_ambush = "Emboscada" -- Short for Voidblade Ambush
	L.soulfray_annihilation = "Linhas" -- Lines that shoot out an orb along that path
	L.soulfray_annihilation_single = "Linha" -- Single from Lines
	L.remaining_adds = "Adds restantes" -- All remaining adds from Soul Calling spawn
end

L = BigWigs:NewBossLocale("Forgeweaver Araz", "ptBR")
if L then
	L.invoke_collector = "Coletor" -- Short for Arcane Collector
end

L = BigWigs:NewBossLocale("Fractillus", "ptBR")
if L then
	L.crystalline_shockwave = "Paredes"
	L.shattershell = "Quebrar parede"
	L.shockwave_slam = "Parede do tanque"
	--L.nexus_shrapnel = "Shrapnel Lands"
	L.crystal_lacerations = "Sangramento"
end

L = BigWigs:NewBossLocale("Nexus-King Salhadaar", "ptBR")
if L then
	L.fractal_images = "Dragões"
	--L.oath_bound_removed_dose = "1x Oath-Bound Removed"
	L.behead = "Garras" -- Claws of a dragon
	L.netherbreaker = "Circulos"
	L.galaxy_smash = "Esmagamento" -- Short for Galactic Smash, and multiple of them.
	L.starkiller_swing = "Mata-estrela" -- Short for Starkiller Swing, and multiple of them.
	L.vengeful_oath = "Espírito"
end

L = BigWigs:NewBossLocale("Dimensius, the All-Devouring", "ptBR")
if L then
	L.gravity = "Gravidade" -- Short for Reverse Gravity
	L.extinction = "Fragmento" -- Dimensius hurls a fragment of a broken world
	L.slows = "Lentidões"
	L.slow = "Lentidão" -- Singular of Slows
	L.mass_destruction = "Linhas"
	L.mass_destruction_single = "Linha"
	L.stardust_nova = "Nova" -- Short for Stardust Nova
	L.extinguish_the_stars = "Estrelas" -- Short for Extinguish the Stars
	L.darkened_sky = "Anéis"
	--L.cosmic_collapse = "Tank Pull"
	--L.cosmic_collapse_easy = "Tank Smash"
	L.soaring_reshii = "Montaria Disponível" -- On the timer for when flying is available

	L.left_living_mass = "Massa Viva (Esquerda)"
	L.right_living_mass = "Massa Viva (Direita)"

	L.soaring_reshii_monster_yell = "Você se saiu bem até agora." -- [CHAT_MSG_MONSTER_YELL] You've done well so far. Surprising. But we're not done yet.#Xal'atath###Meeresflask##0#0##0#256#nil#0#false#false#false#false",

	L.weakened_soon_monster_yell = "Devemos atacar agora!" -- [CHAT_MSG_MONSTER_YELL] We must strike--now!#Xal'atath###Xal'atath##0#0##0#4873#nil#0#false#false#false#false",
end
