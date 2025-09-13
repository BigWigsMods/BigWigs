local L = BigWigs:NewBossLocale("Loom'ithar", "zhTW")
if not L then return end
if L then
	L.lair_weaving = "織網" -- Webs that spawn on the edge of the room
	L.infusion_pylons = "注能" -- Short for Infusion Pylons 注能塔
end

L = BigWigs:NewBossLocale("Soulbinder Naazindhri", "zhTW")
if L then
	L.voidblade_ambush = "伏擊" -- Short for Voidblade Ambush
	L.soulfray_annihilation = "射線" -- 傷魂滅殺/出球/射線
	L.soulfray_annihilation_single = "射線" -- 傷魂滅殺/出球/射線
	L.remaining_adds = "剩餘增援" -- 剩餘增援來襲
end

L = BigWigs:NewBossLocale("Forgeweaver Araz", "zhTW")
if L then
	L.invoke_collector = "收集器" -- Short for Arcane Collector
end

L = BigWigs:NewBossLocale("Fractillus", "zhTW")
if L then
	L.crystalline_shockwave = "水晶牆" -- 出牆
	L.shattershell = "破牆"
	L.shockwave_slam = "坦克牆"
	L.nexus_shrapnel = "碎片落地" -- 粉碎反擊小圈
	L.crystal_lacerations = "流血"
end

L = BigWigs:NewBossLocale("Nexus-King Salhadaar", "zhTW")
if L then
	L.fractal_images = "飛龍"
	L.oath_bound_removed_dose = "移除一層誓言"
	L.behead = "利爪" -- Claws of a dragon 斬首
	L.netherbreaker = "大圈"
	L.galaxy_smash = "撞擊" -- 星河撞擊
	L.starkiller_swing = "弒星" -- 弒星揮擊，或者射線
	L.vengeful_oath = "靈魂"
end

L = BigWigs:NewBossLocale("Dimensius, the All-Devouring", "zhTW")
if L then
	L.gravity = "重力"
	L.extinction = "滅絕" -- Dimensius hurls a fragment of a broken world
	L.slows = "緩速"
	L.slow = "緩速" -- Singular of Slows
	L.mass_destruction = "射線"
	L.mass_destruction_single = "射線"
	L.stardust_nova = "新星" -- Short for Stardust Nova
	L.extinguish_the_stars = "星晨" -- Short for Extinguish the Stars
	L.darkened_sky = "星環"
	L.cosmic_collapse = "坦克拉人"
	L.cosmic_collapse_easy = "坦克大圈"
	L.soaring_reshii = "可飛行" -- On the timer for when flying is available

	L.left_living_mass = "左側過剩物質"
	L.right_living_mass = "右側過剩物質"

	L.soaring_reshii_monster_yell = "你的表現很不錯。" -- [CHAT_MSG_MONSTER_YELL] You've done well so far. Surprising. But we're not done yet.#Xal'atath###Meeresflask##0#0##0#256#nil#0#false#false#false#false",

	L.weakened_soon_monster_yell = "必需現在就出擊！" -- [CHAT_MSG_MONSTER_YELL] We must strike--now!#Xal'atath###Xal'atath##0#0##0#4873#nil#0#false#false#false#false",
end
