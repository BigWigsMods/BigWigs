local L = BigWigs:NewBossLocale("Lord Marrowgar", "ruRU")
if L then
	L.impale_cd = "~Прокалывание"

	L.bonestorm_cd = "~Вихрь костей"
	--L.bonestorm_warning = "Bonestorm in 5 sec!"

	L.coldflame_message = "На ВАС - Холодное пламя!"
end

L = BigWigs:NewBossLocale("Lady Deathwhisper", "ruRU")
if L then
	L.dnd_message = "На ВАС - Смерть и разложение!"
	L.phase2_message = "Пропал Барьер маны - 2-ая фаза!"
end

L = BigWigs:NewBossLocale("Deathbringer Saurfang", "ruRU")
if L then
	L.adds_message = "Призваны кровавые чудовища"
	L.adds = "Кровавые чудовища"
	L.adds_desc = "Сообщать о призыве кровавых чудовищ"
end

L = BigWigs:NewBossLocale("Festergut", "ruRU")
if L then
	
end

L = BigWigs:NewBossLocale("Rotface", "ruRU")
if L then
	L.infection_bar = "Инфекция на |3-5(%s)!"

	L.flood_trigger1 = "Good news, everyone! I've fixed the poison slime pipes!"
	L.flood_trigger2 = "Great news, everyone! The slime is flowing again!"
	L.flood_warning = "A new area is being flooded soon!"
end

L = BigWigs:NewBossLocale("Professor Putricide", "ruRU")
if L then
	L.blight_message = "Газовое вздутие на |3-5(%s)!"
	L.violation_message = "Выделения слизнюка на |3-5(%s)!"
end

L = BigWigs:NewBossLocale("Blood Princes", "ruRU")
if L then
	L.switch_message = "Vulnerability switch"
end

L = BigWigs:NewBossLocale("Blood-Queen Lana'thel", "ruRU")
if L then
	
end

L = BigWigs:NewBossLocale("Valithria Dreamwalker", "ruRU")
if L then
	L.manavoid_message = "На ВАС - Магическая воронка!"
	L.portal = "Портал к кошмарам"
	L.portal_desc = "Сообщать когда Валитрия открывает портал."
	L.portal_message = "Портал!"
	L.portal_trigger = "I have opened a portal into the Dream. Your salvation lies within, heroes..."
end

L = BigWigs:NewBossLocale("Sindragosa", "ruRU")
if L then
	L.airphase_trigger = "Your incursion ends here! None shall survive!"
	L.airphase = "Воздушная фаза"
	L.airphase_message = "Воздушная фаза"
	L.airphase_desc = "Сообщать когда Синдрагоса отрывается от земли"
	L.boom = "Взрыв!"
end

L = BigWigs:NewBossLocale("Stinky", "ruRU")
if L then
	L.wound_message = "%2$dx смертельных ран у: %1$s"
	L.decimate_cd = "~истребление" -- 33sec cd
end

L = BigWigs:NewBossLocale("Precious", "ruRU")
if L then
	L.zombies = GetSpellInfo(71159)
	L.zombies_desc = "Заклинатель призывает на помощь 11 чумных зомби."
	L.zombies_message = "Зомби призваны!"
	L.zombies_cd = "~чумные зомби" -- 20sek cd (11 Zombies)

	L.wound_message = "%2$dx смертельных ран у: %1$s"

	L.decimate_cd = "~истребление" -- 33 sec cd
end

