local L = BigWigs:NewBossLocale("Blood Princes", "zhTW")
if L then
	L.switch_message = "虛弱转换！"
end

local L = BigWigs:NewBossLocale("Festergut", "zhTW")
if L then

end

L = BigWigs:NewBossLocale("Lady Deathwhisper", "zhTW")
if L then
	L.dnd_message = ">你< 死亡凋零！"
	L.phase2_message = "第二階段 - 失去法力屏障！"
end

L = BigWigs:NewBossLocale("Lord Marrowgar", "zhTW")
if L then
	L.impale_cd = "<下一刺穿>"
	L.whirlwind_cd = "<下一旋風斬>"
	L.ww_start = "開始旋風斬！"
	L.ww_end = "旋風斬結束！"

	L.coldflame_message = ">你< 冷焰！"
end

L = BigWigs:NewBossLocale("Precious", "zhTW")
if L then
	L.zombies = GetSpellInfo(71159)
	L.zombies_desc = "召喚11個瘟疫殭屍協助施法者。"
	L.zombies_message = "召喚 瘟疫殭屍！"
	L.zombies_cd = "<下一瘟疫殭屍>" -- 20sek cd (11 Zombies)

	L.wound_message = "致死重傷%2$dx：>%1$s<！"

	L.decimate_cd = "<下一虐殺>" -- 33 sec cd
end

L = BigWigs:NewBossLocale("Professor Putricide", "zhTW")
if L then
	L.blight_message = "毒氣膨脹：>%s<！"
	L.violation_message = "暴躁軟泥怪黏著：>%s<！"
end

L = BigWigs:NewBossLocale("Rotface", "zhTW")
if L then
	L.infection_bar = "突變感染：>%s<！"

	L.flood_trigger1 = "Good news, everyone! I've fixed the poison slime pipes!"
	L.flood_trigger2 = "Great news, everyone! The slime is flowing again!"
	L.flood_warning = "A new area is being flooded soon!"
end

L = BigWigs:NewBossLocale("Deathbringer Saurfang", "zhTW")
if L then
	L.adds_message = "召喚增援！"
	L.adds = "增援！"
	L.adds_desc = "當召喚增援時發出警報。"
end

L = BigWigs:NewBossLocale("Sindragosa", "zhTW")
if L then
	L.airphase_trigger = "Your incursion ends here! None shall survive!"
	L.airphase = "空中階段"
	L.airphase_message = "空中階段！"
	L.airphase_desc = "當辛德拉苟莎起飛時發出警報。"
	L.boom = "極凍之寒！"
end

L = BigWigs:NewBossLocale("Stinky", "zhTW")
if L then
	L.wound_message = "致死重傷%2$dx：>%1$s<！"
	L.decimate_cd = "<下一虐殺>" -- 33sec cd
end

L = BigWigs:NewBossLocale("Valithria Dreamwalker", "zhTW")
if L then
	L.manavoid_message = ">你< 潰法力場！"
	L.portal = "夢魘之門！"
	L.portal_desc = "當瓦莉絲瑞雅·夢行者打開夢魘之門時發出警報。"
	L.portal_message = "打開夢魘之門！"
	L.portal_trigger = "I have opened a portal into the Dream. Your salvation lies within, heroes..."
end