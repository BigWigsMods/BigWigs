local L = BigWigs:NewBossLocale("The Prophet Skeram", "frFR")
if not L then return end
if L then
	L.bossName = "Le prophète Skeram"
end

local L = BigWigs:NewBossLocale("Silithid Royalty", "frFR")
if L then
	L.bossName = "Famille royale silithide"
end

local L = BigWigs:NewBossLocale("Battleguard Sartura", "frFR")
if L then
	L.bossName = "Garde de guerre Sartura"
end

local L = BigWigs:NewBossLocale("Fankriss the Unyielding", "frFR")
if L then
	L.bossName = "Fankriss l'Inflexible"
end

L = BigWigs:NewBossLocale("Viscidus", "frFR")
if L then
	L.bossName = "Viscidus"

	-- L.freeze = "Freezing States"
	-- L.freeze_desc = "Warn for the different frozen states."

	L.freeze_trigger1 = "%s commence à ralentir !"
	L.freeze_trigger2 = "%s est gelé !"
	L.freeze_trigger3 = "%s est congelé !"
	L.freeze_trigger4 = "%s commence à se briser !"
	L.freeze_trigger5 = "%s semble prêt à se briser !"

	-- L.freeze_warn1 = "First freeze phase!"
	-- L.freeze_warn2 = "Second freeze phase!"
	-- L.freeze_warn3 = "Viscidus is frozen!"
	-- L.freeze_warn4 = "Cracking up - keep going!"
	-- L.freeze_warn5 = "Cracking up - almost there!"
	-- L.freeze_warn_melee = "%d melee attacks - %d more to go"
	-- L.freeze_warn_frost = "%d frost attacks - %d more to go"
end

local L = BigWigs:NewBossLocale("Princess Huhuran", "frFR")
if L then
	L.bossName = "Princesse Huhuran"
end

local L = BigWigs:NewBossLocale("The Twin Emperors", "frFR")
if L then
	L.bossName = "Empereurs jumeaux"
end

L = BigWigs:NewBossLocale("Ouro", "frFR")
if L then
	L.bossName = "Ouro"

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

L = BigWigs:NewBossLocale("C'Thun", "frFR")
if L then
	L.bossName = "C’Thun"

	-- L.tentacle = "Tentacles"
	-- L.tentacle_desc = "Warn for Tentacles"

	-- L.giant = "Giant Eye Alert"
	-- L.giant_desc = "Warn for Giant Eyes"

	-- L.weakened = "Weakened Alert"
	-- L.weakened_desc = "Warn for Weakened State"
	L.weakenedtrigger = "%s est affaibli !"

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

L = BigWigs:NewBossLocale("Ahn'Qiraj Trash", "frFR")
if L then
	L.defender = "Défenseur Anubisath"
	L.crawler = "Rampant de la ruche vekniss"
end
