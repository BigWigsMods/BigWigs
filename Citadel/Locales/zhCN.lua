local L = BigWigs:NewBossLocale("Blood Princes", "zhCN")
if L then
	L.switch_message = "虛弱转换！"
end

L = BigWigs:NewBossLocale("Festergut", "zhCN")
if L then

end

L = BigWigs:NewBossLocale("Lady Deathwhisper", "zhCN")
if L then
	L.dnd_message = ">你< 死亡凋零！"
	L.phase2_message = "第二阶段 - Mana barrier gone！"
	L.engage_trigger = "What is this disturbance?"

	L.adds = "增援"
	L.adds_desc = "当召唤增援时显示计时条。"
	L.adds_bar = "<下一增援>"
	L.adds_warning = "5秒后，新的增援！"
end

L = BigWigs:NewBossLocale("Lord Marrowgar", "zhCN")
if L then
	L.impale_cd = "<下一穿刺>"
	L.whirlwind_cd = "<下一旋风斩>"
	L.ww_start = "开始旋风斩！"
	L.ww_end = "旋风斩结束！"

	L.coldflame_message = ">你< Coldflame！"
end

L = BigWigs:NewBossLocale("Precious", "zhCN")
if L then
	L.zombies = GetSpellInfo(71159)
	L.zombies_desc = "召唤11个Plague Zombies协助施法者。"
	L.zombies_message = "召唤Zombies！"
	L.zombies_cd = "<下一Zombies>" -- 20sek cd (11 Zombies)

	L.wound_message = " Mortal Wound%2$dx：>%1$s<！"

	L.decimate_cd = "<下一Decimate>" -- 33 sec cd
end

L = BigWigs:NewBossLocale("Professor Putricide", "zhCN")
if L then
	L.blight_message = "Blight：>%s<！"
	L.violation_message = "Violation：>%s<！"
end

L = BigWigs:NewBossLocale("Rotface", "zhCN")
if L then
	L.infection_bar = "Infection：>%s<！"

	L.flood_trigger1 = "Good news, everyone! I've fixed the poison slime pipes!"
	L.flood_trigger2 = "Great news, everyone! The slime is flowing again!"
	L.flood_warning = "A new area is being flooded soon!"
end

L = BigWigs:NewBossLocale("Deathbringer Saurfang", "zhCN")
if L then
	L.adds = "Blood Beasts"
	L.adds_desc = "当召唤Blood Beasts时发出警报和显示计时条。"
	L.adds_warning = "5秒后，Blood Beasts！"
	L.adds_message = "Blood Beasts！"
	L.adds_bar = "<下一Blood Beasts>"

	L.rune_bar = "<下一Rune of Blood>"

	L.nova_bar = "<下一Blood Nova>"

	L.mark = "Mark of the Fallen Champion"
end

L = BigWigs:NewBossLocale("Sindragosa", "zhCN")
if L then
	L.airphase_trigger = "Your incursion ends here! None shall survive!"
	L.airphase = "空中阶段"
	L.airphase_message = "空中阶段！"
	L.airphase_desc = "当辛达苟萨起飞时发出警报。"
	L.boom = "Explosion！"
end

L = BigWigs:NewBossLocale("Stinky", "zhCN")
if L then
	L.wound_message = " Mortal Wound%2$dx：>%1$s<！"
	L.decimate_cd = "<下一Decimate>" -- 33sec cd
end

L = BigWigs:NewBossLocale("Valithria Dreamwalker", "zhCN")
if L then
	L.manavoid_message = ">你< Mana Void！"
	L.portal = "Nightmare Portal"
	L.portal_desc = "当Valithria打开Portal时发出警报。"
	L.portal_message = "打开Portal！"
	L.portal_trigger = "I have opened a portal into the Dream. Your salvation lies within, heroes..."
end