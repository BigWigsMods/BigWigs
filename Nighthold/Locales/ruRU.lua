local L = BigWigs:NewBossLocale("Skorpyron", "ruRU")
if not L then return end
if L then
	L.blue = "Синий"
	L.red = "Красный"
	L.green = "Зеленый"
	L.mode = "%s режим"
end

L = BigWigs:NewBossLocale("Chronomatic Anomaly", "ruRU")
if L then
	L.timeLeft = "%.1fс" -- s = seconds
end

L = BigWigs:NewBossLocale("Trilliax", "ruRU")
if L then
	L.yourLink = "Вы связаны с %s"
	L.yourLinkShort = "Связан с %s"
	--L.imprint = "Imprint"
end

L = BigWigs:NewBossLocale("Tichondrius", "ruRU")
if L then
	L.addsKilled = "Аддов убито"
	L.gotEssence = "Взято эссенций"

	L.adds_desc = "Таймеры и предупреждения о появлении аддов."
	L.adds_yell1 = "Прислужники! Живо ко мне!"
	L.adds_yell2 = "Покажите этим ничтожествам, как сражаться!"
end

L = BigWigs:NewBossLocale("Krosus", "ruRU")
if L then
	L.leftBeam = "Левый луч"
	L.rightBeam = "Правый луч"

	L.goRight = "> НАПРАВО >"
	L.goLeft = "< НАЛЕВО <"

	L.smashingBridge = "Уничтожение моста"
	L.smashingBridge_desc = "Удар, который сломает мост. Вы можете использовать данную опцию для настройки отсчёта или увеличения."

	L.removedFromYou = "%s спало с вас"
end

L = BigWigs:NewBossLocale("Star Augur Etraeus", "ruRU")
if L then
	L.yourSign = "Ваш знак"
	L.with = "с"
	L[205429] = "|T1391538:15:15:0:0:64:64:4:60:4:60|t|cFFFFDD00Краб|r"
	L[205445] = "|T1391537:15:15:0:0:64:64:4:60:4:60|t|cFFFF0000Волк|r"
	L[216345] = "|T1391536:15:15:0:0:64:64:4:60:4:60|t|cFF00FF00Охотник|r"
	L[216344] = "|T1391535:15:15:0:0:64:64:4:60:4:60|t|cFF00DDFFДракон|r"
end

L = BigWigs:NewBossLocale("Grand Magistrix Elisande", "ruRU")
if L then
	L.elisande = "Элисанда"

	L.ring_yell = "Волны времени сметут вас!"
	L.orb_yell = "Время нестабильно – сейчас вы сами в этом убедитесь."

	L.slowTimeZone = "Зона замедления времени"
	L.fastTimeZone = "Зона ускорения времени"

	L.boss_active = "Элисанда активна"
	L.boss_active_desc = "Время до активации Элисанды после зачистки комнаты."
	L.elisande_trigger = "Я предвидела ваш приход, нити судьбы, что привели вас сюда, и ваши жалкие попытки остановить Легион."
end

L = BigWigs:NewBossLocale("Gul'dan", "ruRU")
if L then
	L.warmup_trigger = "Вы уже забыли" -- Have you forgotten your humiliation on the Broken Shore? How your precious high king was bent and broken before me? Will you beg for your lives as he did, whimpering like some worthless dog?

	L.empowered = "(E) %s" -- (E) Eye of Gul'dan
	L.gains = "Гул'дан получает %s"
	L.p4_mythic_start_yell = "Вернем душу Иллидана в тело... Владыка Легиона не должен его заполучить."

	L.nightorb_desc = "Призывает Ночную Сферу, её убийство образует Зону Остановки Времени."
	L.timeStopZone = "Зона Остановки Времени"

	L.manifest_desc = "Призывает Фрагмент души Аззинота, после убийства образуется Демоническая сущность."

	L.winds_desc = "Гул'дан призывает Жестокие Ветра, сталкивающие игроков с платформы."
end

L = BigWigs:NewBossLocale("Nighthold Trash", "ruRU")
if L then
	--[[ Skorpyron to Trilliax ]]--
	L.torm = "Торм Громила"
	L.fulminant = "Молниеносец"
	L.pulsauron = "Пульсарон"

	--[[ Chronomatic Anomaly to Trilliax ]]--
	L.sludgerax = "Слизерон"

	--[[ Trilliax to Aluriel ]]--
	L.karzun = "Кар'зун"
	L.guardian = "Золоченый страж"
	L.battle_magus = "Боевой маг из Сумеречной стражи"
	L.chronowraith = "Призрак времени"
	L.protector = "Заступник Цитадели Ночи"

	--[[ Aluriel to Etraeus ]]--
	L.jarin = "Астролог Джарин"

	--[[ Aluriel to Telarn ]]--
	L.defender = "Астральный защитник"
	L.weaver = "Заклинатель из Сумеречной стражи"
	L.archmage = "Шал'дорай - верховный маг"
	L.manasaber = "Прирученный манопард"
	L.naturalist = "Шал'дорай-натуралист"

	--[[ Aluriel to Krosus ]]--
	L.infernal = "Опаляющий инфернал"

	--[[ Aluriel to Tichondrius ]]--
	L.chaosmage = "Скверноподданный маг Хаоса"
	L.watcher = "Дозорный из бездны"
end
