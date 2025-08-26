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
	L.remaining_adds = "남은 추가 몹" -- All remaining adds from Soul Calling spawn
end

L = BigWigs:NewBossLocale("Forgeweaver Araz", "koKR")
if L then
	L.invoke_collector = "수집기" -- Short for Arcane Collector
end

L = BigWigs:NewBossLocale("Fractillus", "koKR")
if L then
	L.crystalline_shockwave = "벽"
	L.shattershell = "제거"
	L.shockwave_slam = "탱커 벽"
	L.nexus_shrapnel = "파편"
	L.crystal_lacerations = "출혈"
end

L = BigWigs:NewBossLocale("Nexus-King Salhadaar", "koKR")
if L then
	L.fractal_images = "환영"
	L.oath_bound_removed_dose = "1x 서약결속 제거됨"
	L.behead = "발톱" -- Claws of a dragon
	L.netherbreaker = "차원문"
	L.galaxy_smash = "강타" -- Short for Galactic Smash, and multiple of them.
	L.starkiller_swing = "별 부수기" -- Short for Starkiller Swing, and multiple of them.
	L.vengeful_oath = "영혼"
end

L = BigWigs:NewBossLocale("Dimensius, the All-Devouring", "koKR")
if L then
	L.gravity = "역중력" -- Short for Reverse Gravity
	L.extinction = "파편" -- Dimensius hurls a fragment of a broken world
	L.slows = "이감"
	L.slow = "이감" -- Singular of Slows
	L.mass_destruction = "라인"
	L.mass_destruction_single = "라인"
	L.stardust_nova = "바닥" -- Short for Stardust Nova
	L.extinguish_the_stars = "별" -- Short for Extinguish the Stars
	L.darkened_sky = "충격파"
	L.cosmic_collapse = "탱커 당기기"
	L.cosmic_collapse_easy = "탱커 강타"
	L.soaring_reshii = "비행 가능" -- On the timer for when flying is available

	L.left_living_mass = "살아있는 질량체 (왼쪽)"
	L.right_living_mass = "살아있는 질량체 (오른쪽)"

	L.soaring_reshii_monster_yell = "지금까진 잘했어요." -- [CHAT_MSG_MONSTER_YELL] You've done well so far. Surprising. But we're not done yet.#Xal'atath###Meeresflask##0#0##0#256#nil#0#false#false#false#false",

	L.weakened_soon_monster_yell = "지금 공격해야 해요!" -- [CHAT_MSG_MONSTER_YELL] We must strike--now!#Xal'atath###Xal'atath##0#0##0#4873#nil#0#false#false#false#false",
end
