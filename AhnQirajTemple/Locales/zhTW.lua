local L = BigWigs:NewBossLocale("The Prophet Skeram", "zhTW")
if not L then return end
if L then
	L.bossName = "預言者斯克拉姆"
end

local L = BigWigs:NewBossLocale("Silithid Royalty", "zhTW")
if L then
	L.bossName = "異種蠍皇族"
end

local L = BigWigs:NewBossLocale("Battleguard Sartura", "zhTW")
if L then
	L.bossName = "戰地衛士沙爾圖拉"
end

local L = BigWigs:NewBossLocale("Fankriss the Unyielding", "zhTW")
if L then
	L.bossName = "不屈的范克里斯"
end

L = BigWigs:NewBossLocale("Viscidus", "zhTW")
if L then
	L.bossName = "維希度斯"

	-- L.freeze = "Freezing States"
	-- L.freeze_desc = "Warn for the different frozen states."

	L.freeze_trigger1 = "的速度慢下來了！"
	L.freeze_trigger2 = "凍住了！"
	L.freeze_trigger3 = "變成了堅硬的固體！"
	L.freeze_trigger4 = "開始碎裂了！"
	L.freeze_trigger5 = "馬上就要碎裂的樣子！"

	-- L.freeze_warn1 = "First freeze phase!"
	-- L.freeze_warn2 = "Second freeze phase!"
	-- L.freeze_warn3 = "Viscidus is frozen!"
	-- L.freeze_warn4 = "Cracking up - keep going!"
	-- L.freeze_warn5 = "Cracking up - almost there!"
	-- L.freeze_warn_melee = "%d melee attacks - %d more to go"
	-- L.freeze_warn_frost = "%d frost attacks - %d more to go"
end

local L = BigWigs:NewBossLocale("Princess Huhuran", "zhTW")
if L then
	L.bossName = "哈霍蘭公主"
end

local L = BigWigs:NewBossLocale("The Twin Emperors", "zhTW")
if L then
	L.bossName = "雙子帝王"
end

L = BigWigs:NewBossLocale("Ouro", "zhTW")
if L then
	L.bossName = "奧羅"

	-- L.engage_message = "Ouro engaged! Possible Submerge in 90sec!"
	-- L.possible_submerge_bar = "Possible submerge"

	-- L.emergeannounce = "Ouro has emerged!"
	-- L.emergewarn = "15 sec to possible submerge!"
	-- L.emergewarn2 = "15 sec to Ouro sumberge!"
	-- L.emergebartext = "Ouro submerge"

	-- L.submergeannounce = "Ouro has submerged!"
	-- L.submergewarn = "5 seconds until Ouro Emerges!"
	-- L.submergebartext = "Ouro Emerge"

	-- L.scarab = "Scarab Despawn"
	-- L.scarab_desc = "Warn for Scarab Despawn."
	-- L.scarabdespawn = "Scarabs despawn in 10 Seconds"
	-- L.scarabbar = "Scarabs despawn"
end

L = BigWigs:NewBossLocale("C'Thun", "zhTW")
if L then
	L.bossName = "克蘇恩"

	-- L.tentacle = "Tentacles"
	-- L.tentacle_desc = "Warn for Tentacles"

	-- L.giant = "Giant Eye Alert"
	-- L.giant_desc = "Warn for Giant Eyes"

	-- L.weakened = "Weakened Alert"
	-- L.weakened_desc = "Warn for Weakened State"
	L.weakenedtrigger = "%s變弱了！"

	-- L.weakened_msg = "C'Thun is weakened for 45 sec"
	-- L.invulnerable2 = "Party ends in 5 seconds"
	-- L.invulnerable1 = "Party over - C'Thun invulnerable"

	-- L.giant3 = "Giant Eye - 10 sec"
	-- L.giant2 = "Giant Eye - 5 sec"
	-- L.giant1 = "Giant Eye - Poke it!"

	-- L.startwarn = "C'Thun engaged! - 45 sec until Dark Glare and Eyes"

	-- L.tentacleParty = "Tentacle party!"
	-- L.barWeakened = "C'Thun is weakened!"
	-- L.barGiant = "Giant Eye!"

	-- L.groupwarning = "Dark Glare on group %s (%s)"
	-- L.phase2starting = "The Eye is dead! Body incoming!"
end

L = BigWigs:NewBossLocale("Ahn'Qiraj Trash", "zhTW")
if L then
	-- L.anubisath = "Anubisath"
	-- L.sentinel = "Anubisath Sentinel"
	-- L.defender = "Anubisath Defender"
	-- L.crawler = "Vekniss Hive Crawler"
end
