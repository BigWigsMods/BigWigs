local L = BigWigs:NewBossLocale("Festergut", "zhTW")
if L then

end

L = BigWigs:NewBossLocale("Lady Deathwhisper", "zhTW")
if L then
	L.dnd_message = ">你< Death and Decay！"
	L.phase2_message = "第二階段 - Mana barrier gone！"
end

L = BigWigs:NewBossLocale("Lord Marrowgar", "zhTW")
if L then
	L.impale_cd = "<下一impale>"
	L.whirlwind_cd = "<下一旋風斬>"

	L.coldflame_message = ">你< Coldflame！"
end

L = BigWigs:NewBossLocale("Precious", "zhTW")
if L then
	L.zombies = GetSpellInfo(71159)
	L.zombies_desc = "Summons 11 Plague Zombies to assist the caster."
	L.zombies_message = "Zombies summoned!"
	L.zombies_cd = "<下一Zombies>" -- 20sek cd (11 Zombies)

	L.wound_message = "%2$dx Mortal Wound on %1$s"

	L.decimate_cd = "<下一Decimate>" -- 33 sec cd
end

L = BigWigs:NewBossLocale("Rotface", "zhTW")
if L then
	L.infection_bar = "Infection：>%s<！"

	L.flood_trigger1 = "Good news, everyone! I've fixed the poison slime pipes!"
	L.flood_trigger2 = "Great news, everyone! The slime is flowing again!"
	L.flood_warning = "A new area is being flooded soon!"
end

L = BigWigs:NewBossLocale("Sindragosa", "zhTW")
if L then
	L.airphase_trigger = "Your incursion ends here! None shall survive!"
	L.airphase = "Airphase"
	L.airphase_message = "Airphase！"
	L.airphase_desc = "當Sindragosas lift-off時發出警報。"
	L.boom = "Explosion！"
end

L = BigWigs:NewBossLocale("Stinky", "zhTW")
if L then
	L.wound_message = "%2$dx Mortal Wound：>%1$s<！"
	L.decimate_cd = "<下一Decimate>" -- 33sec cd
end

L = BigWigs:NewBossLocale("Valithria Dreamwalker", "zhTW")
if L then
	L.manavoid_message = ">你< Mana Void！"
	L.portal = "Nightmare Portal"
	L.portal_desc = "當Valithria打開Portal時發出警報。"
	L.portal_message = "Portal up！"
	L.portal_trigger = "I have opened a portal into the Dream. Your salvation lies within, heroes..."
end