local L = BigWigs:NewBossLocale("Immerseus", "zhTW")
if not L then return end
if L then
--@localization(locale="zhTW", namespace="SiegeOfOrgrimmar/Immerseus", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("The Fallen Protectors", "zhTW")
if L then
--@localization(locale="zhTW", namespace="SiegeOfOrgrimmar/TheFallenProtectors", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("Norushen", "zhTW")
if L then
--@localization(locale="zhTW", namespace="SiegeOfOrgrimmar/Norushen", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("Sha of Pride", "zhTW")
if L then
--@localization(locale="zhTW", namespace="SiegeOfOrgrimmar/ShaOfPride", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("Galakras", "zhTW")
if L then
	L.demolisher_message = "石毀車"

	L.towers = "高塔"
	L.towers_desc = "當高塔被突破時發出警報"
	L.south_tower_trigger = "封鎖南塔的門已經遭到破壞!"
	L.south_tower = "南塔"
	L.north_tower_trigger = "封鎖北塔的門已經遭到破壞!"
	L.north_tower = "北塔"
	L.tower_defender = "Tower defender"

	L.drakes = "元龍"

	L.custom_off_shaman_marker = "薩滿標記"
	L.custom_off_shaman_marker_desc = "To help interrupt assignments, mark the Dragonmaw Tidal Shamans with {rt1}{rt2}{rt3}{rt4}{rt5}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, quickly mousing over the shamans is the fastest way to mark them.|r"
end

L = BigWigs:NewBossLocale("Iron Juggernaut", "zhTW")
if L then
	L.custom_off_mine_marks = "Mine marker"
	L.custom_off_mine_marks_desc = "To help soaking assignments, mark the Crawler Mines with {rt1}{rt2}{rt3}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, quickly mousing over all the mines is the fastest way to mark them.|r"
end

L = BigWigs:NewBossLocale("Kor'kron Dark Shaman", "zhTW")
if L then
	L.blobs = "Blobs"

	L.custom_off_mist_marks = "Toxic Mist marker"
	L.custom_off_mist_marks_desc = "To help healing assignments, mark the people who have Toxic Mist on them with {rt1}{rt2}{rt3}{rt4}{rt5}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
end

L = BigWigs:NewBossLocale("General Nazgrim", "zhTW")
if L then
	L.custom_off_bonecracker_marks = "Bonecracker marker"
	L.custom_off_bonecracker_marks_desc = "To help healing assignments, mark the people who have Bonecracker on them with {rt1}{rt2}{rt3}{rt4}{rt5}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"

	L.stance_bar = "%s(現在:%s)"
	L.battle = "戰鬥"
	L.berserker = "狂暴"
	L.defensive = "防禦"

	L.adds_trigger1 = "守住大門!"
	L.adds_trigger2 = "重整部隊!"
	L.adds_trigger3 = "下一隊，來前線!"
	L.adds_trigger4 = "戰士們，快點過來!"
	L.adds_trigger5 = "柯爾克隆，來我身邊!"
	L.adds_trigger_extra_wave = "所有科爾克隆...聽我號令...殺死他們!"
	L.extra_adds = "額外增援部隊"

	L.chain_heal_message = "Your focus is casting Chain Heal!"

	L.arcane_shock_message = "Your focus is casting Arcane Shock!"

	L.focus_only = "|cffff0000Focus target alerts only.|r "
end

L = BigWigs:NewBossLocale("Malkorok", "zhTW")
if L then

end

L = BigWigs:NewBossLocale("Spoils of Pandaria", "zhTW")
if L then

end

L = BigWigs:NewBossLocale("Thok the Bloodthirsty", "zhTW")
if L then
--@localization(locale="zhTW", namespace="SiegeOfOrgrimmar/ThokTheBloodthirsty", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("Siegecrafter Blackfuse", "zhTW")
if L then

end

L = BigWigs:NewBossLocale("Paragons of the Klaxxi", "zhTW")
if L then


end

L = BigWigs:NewBossLocale("Garrosh Hellscream", "zhTW")
if L then
	L.intermission = "中場休息"
	L.mind_control = "亚煞极之触"
	L.empowered_message = ">%s< 強化腐化！"
end

