local L = BigWigs:NewBossLocale("Lord Marrowgar", "ruRU")
if L then
	L.impale_cd = "~Прокалывание"

	L.bonestorm_cd = "~Вихрь костей"
	L.bonestorm_warning = "Вихрь костей через 5 сек!"

	L.coldflame_message = "На ВАС - Холодное пламя!"

	--L.engage_trigger = "The Scourge will wash over this world as a swarm of death and destruction!"
end

L = BigWigs:NewBossLocale("Icecrown Gunship Battle", "ruRU")
if L then
	--L.mage = "Mage"
	--L.mage_desc = "Warn when a mage spawns to freeze your guns."
	--L.mage_message = "Mage Spawned!"

	--L.enable_trigger_alliance = "Fire up the engines! We got a meetin' with destiny, lads!"
	--L.enable_trigger_horde = "Need Horde Yell Here - Fake Placeholder"

	--L.disable_trigger_alliance = "Don't say I didn't warn ya, scoundrels! Onward, brothers and sisters!"
	--L.disable_trigger_horde = "Need Horde Yell Here - Fake Placeholder"
end

L = BigWigs:NewBossLocale("Lady Deathwhisper", "ruRU")
if L then
	L.engage_trigger = "Как вы смеете ступать в эти священные покои? Это место станет вашей могилой!"
	L.phase2_message = "Пропал Барьер маны - 2-ая фаза!"

	L.dnd_message = "На ВАС - Смерть и разложение!"

	L.adds = "Вестники Смерти"
	L.adds_desc = "Таймеры появления Вестников Смерти."
	L.adds_bar = "~новые вестники смерти"
	L.adds_warning = "Новые Вестники Смерти через 5 сек!"

	L.touch_message = "%2$dx Прикосновений у: %1$s"
	L.touch_bar = "~Прикосновение"
end

L = BigWigs:NewBossLocale("Deathbringer Saurfang", "ruRU")
if L then
	L.adds = "Кровавые чудовища"
	L.adds_desc = "Сообщать о призыве кровавых чудовищ"
	L.adds_warning = "Кровавые чудовища через 5 сек!"
	L.adds_message = "Призваны кровавые чудовища"
	L.adds_bar = "~Кровавые чудовища"

	L.rune_bar = "~следующая Руна"

	L.mark = "Метка %d"

	--L.engage_trigger = "BY THE MIGHT OF THE LICH KING!"
	--L.warmup_alliance = "Let's get a move on then! Move ou..."
	--L.warmup_horde = "Kor'kron, move out! Champions, watch your backs. The Scourge have been..."
end

L = BigWigs:NewBossLocale("Festergut", "ruRU")
if L then

end

L = BigWigs:NewBossLocale("Rotface", "ruRU")
if L then
	L.infection_bar = "Инфекция на |3-5(%s)!"

	--L.flood_trigger1 = "Good news, everyone! I've fixed the poison slime pipes!"
	--L.flood_trigger2 = "Great news, everyone! The slime is flowing again!"
	L.flood_warning = "A new area is being flooded soon!"
end

L = BigWigs:NewBossLocale("Professor Putricide", "ruRU")
if L then
	L.engage_trigger = "Good news, everyone!"

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
	--L.airphase_trigger = "Your incursion ends here! None shall survive!"
	L.airphase = "Воздушная фаза"
	L.airphase_message = "Воздушная фаза"
	L.airphase_desc = "Сообщать когда Синдрагоса отрывается от земли"
	L.boom = "Взрыв!"
end

L = BigWigs:NewBossLocale("Putricide Dogs", "ruRU")
if L then
	L.wound_message = "%2$dx смертельных ран у: %1$s"
end

