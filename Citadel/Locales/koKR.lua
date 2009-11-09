local L = BigWigs:NewBossLocale("Lady Deathwhisper", "koKR")
if L then
	L.DnD_aura_message = "당신은 죽음과 부패!"
	L.Phase2 = "마나 보호막 사라짐 - 2 단계"
end

L = BigWigs:NewBossLocale("Lord Marrowgar", "koKR")
if L then
	L.impale_cd = "~다음 뼈의 쐐기"
	L.whirlwind_cd = "~다음 소용돌이"

	L.coldflame_message = "당신은 냉기불길!"
end

L = BigWigs:NewBossLocale("Precious", "koKR")
if L then
	L.zombies = GetSpellInfo(71159)
	L.zombies_desc = "Summons 11 Plague Zombie to assist the caster."
	L.wound_message = "%2$dx Mortal Wound on %1$s"
	L.decimate_cd = "~다음 Decimate" --33sec cd
	L.zombies = "좀비 소환"
	L.zombie_cd = "~다음 좀비" --20sek cd (11Zombies)
end

L = BigWigs:NewBossLocale("Rotface", "koKR")
if L then
	L.infection_bar = "돌연변이 전염병: %s!"

	L.flood_trigger1 = "Good news, everyone! I've fixed the poison slime pipes!"
	L.flood_trigger2 = "Great news, everyone! The slime is flowing again!"
	L.flood_warning = "A new area is being flooded soon!"
end

L = BigWigs:NewBossLocale("Sindragosa", "koKR")
if L then
	L.airphase_trigger = "Your incursion ends here! None shall survive!"
	L.airphase = "비행 단계"
	L.airphase_message = "비행 단계"
	L.airphase_desc = "신드라고사의 착지&비행에 대한 단계를 알립니다."
	L.boom = "폭발!"
end

L = BigWigs:NewBossLocale("Stinky", "koKR")
if L then
	L.wound_message = "%2$dx Mortal Wound on %1$s"
	L.decimate_cd = "~다음 Decimate" --33sec cd
end

L = BigWigs:NewBossLocale("Valithria Dreamwalker", "koKR")
if L then
	L.manavoid_message = "Mana Void on YOU!"
	L.nightmareportal = "Nightmareportal"
	L.nightmareportal_desc = "Warns when Valithria opens a Portal"
	L.nightmareportal_message = "Nightmare Portal summoned" 
	L.nightmareportal_trigger = "I have opened a portal into the Dream. Your salvation lies within, heroes..."
end