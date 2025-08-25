local L = BigWigs:NewBossLocale("Loom'ithar", "ruRU")
if not L then return end
if L then
	L.lair_weaving = "Паутина" -- Webs that spawn on the edge of the room
	L.infusion_pylons = "Пилоны" -- Short for Infusion Pylons
end

L = BigWigs:NewBossLocale("Soulbinder Naazindhri", "ruRU")
if L then
	L.voidblade_ambush = "Внезапный удар" -- Short for Voidblade Ambush
	L.soulfray_annihilation = "Линии" -- Lines that shoot out an orb along that path
	L.soulfray_annihilation_single = "Линия" -- Single from Lines
	L.remaining_adds = "Оставшиеся адды" -- All remaining adds from Soul Calling spawn
end

L = BigWigs:NewBossLocale("Forgeweaver Araz", "ruRU")
if L then
	L.invoke_collector = "Сборщик" -- Short for Arcane Collector
end

L = BigWigs:NewBossLocale("Fractillus", "ruRU")
if L then
	L.crystalline_shockwave = "Стены"
	L.shattershell = "Ломание стен"
	L.shockwave_slam = "Танковская стена"
	L.nexus_shrapnel = "Шрапнель падает"
	L.crystal_lacerations = "Кровотечение"
end

L = BigWigs:NewBossLocale("Nexus-King Salhadaar", "ruRU")
if L then
	--L.fractal_images = "Dragons"
	L.oath_bound_removed_dose = "1x Узы клятвы снято"
	L.behead = "Когти" -- Claws of a dragon
	L.netherbreaker = "Круги"
	L.galaxy_smash = "Сокрушение" -- Short for Galactic Smash, and multiple of them.
	L.starkiller_swing = "Убийцы звезд" -- Short for Starkiller Swing, and multiple of them.
	L.vengeful_oath = "Духи"
end

L = BigWigs:NewBossLocale("Dimensius, the All-Devouring", "ruRU")
if L then
	L.gravity = "Гравитация" -- Short for Reverse Gravity
	L.extinction = "Фрагмент" -- Dimensius hurls a fragment of a broken world
	L.slows = "Замедления"
	L.slow = "Замедление" -- Singular of Slows
	--L.mass_destruction = "Lines"
	--L.mass_destruction_single = "Line"
	L.stardust_nova = "Кольцо" -- Short for Stardust Nova
	L.extinguish_the_stars = "Звезды" -- Short for Extinguish the Stars
	L.darkened_sky = "Кольца"
	--L.cosmic_collapse = "Tank Pull"
	--L.cosmic_collapse_easy = "Tank Smash"
	L.soaring_reshii = "Маунт доступен" -- On the timer for when flying is available

	--L.left_living_mass = "Living Mass (Left)"
	--L.right_living_mass = "Living Mass (Right)"

	--L.soaring_reshii_monster_yell = "You've done well so far." -- [CHAT_MSG_MONSTER_YELL] You've done well so far. Surprising. But we're not done yet.#Xal'atath###Meeresflask##0#0##0#256#nil#0#false#false#false#false",

	L.weakened_soon_monster_yell = "Атакуем его! Сейчас!" -- [CHAT_MSG_MONSTER_YELL] We must strike--now!#Xal'atath###Xal'atath##0#0##0#4873#nil#0#false#false#false#false",
end
