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
	L.affected = "Под воздействием"
	L.totalAbsorb = "Всего абсорба"
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
	--L.adds_yell1 = "Underlings! Get in here!"
	--L.adds_yell2 = "Show these pretenders how to fight!"
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

	--L.ring_yell = "Let the waves of time crash over you!"
	--L.orb_yell = "You'll find time can be quite volatile."

	--L.slowTimeZone = "Slow Time Zone"
	L.fastTimeZone = "Зона ускорения времени"

	--L.boss_active = "Elisande Active"
	--L.boss_active_desc = "Time until Elisande is active after clearing the trash event."
	--L.elisande_trigger = "I foresaw your coming, of course. The threads of fate that led you to this place. Your desperate attempt to stop the Legion."
end

L = BigWigs:NewBossLocale("Gul'dan", "ruRU")
if L then
	--L.empowered = "(E) %s" -- (E) Eye of Gul'dan
	L.gains = "Гул'дан получает %s"
	--L.p4_mythic_start_yell = "Time to return the demon hunter's soul to his body... and deny the Legion's master a host!"

	--L.nightorb_desc = "Summons a Nightorb, killing it will spawn a Time Zone."

	--L.manifest_desc = "Summons a Soul Fragment of Azzinoth, killing it will spawn a Demonic Essence."

	--L.winds_desc = "Gul'dan summons Violent Winds to push the players off the platform."
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
	--L.karzun = "Kar'zun"
	L.guardian = "Золоченый страж"
	L.battle_magus = "Боевой маг из Сумеречной стражи"
	L.chronowraith = "Призрак времени"
	L.protector = "Заступник Цитадели Ночи"

	--[[ Aluriel to Etraeus ]]--
	L.jarin = "Астролог Джарин"

	--[[ Aluriel to Telarn ]]--
	L.weaver = "Заклинатель из Сумеречной стражи"
	L.archmage = "Шал'дорай - верховный маг"
	L.manasaber = "Прирученный манопард"
	L.naturalist = "Шал'дорай-натуралист"

	--[[ Aluriel to Krosus ]]--
	L.infernal = "Опаляющий инфернал"

	--[[ Aluriel to Tichondrius ]]--
	L.watcher = "Дозорный из бездны"
end

