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
	L.gotEssence = "Получено эссенций"

	L.adds_desc = "Таймеры и предупреждения о появлении аддов."
	--L.adds_yell1 = "Underlings! Get in here!"
	--L.adds_yell2 = "Show these pretenders how to fight!"
end

L = BigWigs:NewBossLocale("Krosus", "ruRU")
if L then
	L.leftBeam = "Левый луч"
	L.rightBeam = "Правый луч"

	L.goRight = "> БЕЖАТЬ НАПРАВО >"
	L.goLeft = "< БЕЖАТЬ НАЛЕВО <"

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

	L.nameplate_requirement = "Эта функция пока лишь поддерживается аддоном KuiNameplates. Только эпохальная сложность."

	L.custom_off_icy_ejection_nameplates = "Показывать {206936} на дружелюбных неймплейтах" -- Icy Ejection
	L.custom_off_icy_ejection_nameplates_desc = L.nameplate_requirement

	L.custom_on_fel_ejection_nameplates = "Показывать {205649} на дружелюбных неймплейтах" -- Fel Ejection
	L.custom_on_fel_ejection_nameplates_desc = L.nameplate_requirement

	L.custom_on_gravitational_pull_nameplates = "Показывать {214335} на дружелюбных неймплейтах" -- Gravitational Pull
	L.custom_on_gravitational_pull_nameplates_desc = L.nameplate_requirement

	L.custom_on_grand_conjunction_nameplates = "Показывать {205408} на дружелюбных неймплейтах" -- Grand Conjunction
	L.custom_on_grand_conjunction_nameplates_desc = L.nameplate_requirement
end

L = BigWigs:NewBossLocale("Grand Magistrix Elisande", "ruRU")
if L then
	L.elisande = "Элисанда"

	--L.ring_yell = "Let the waves of time crash over you!"
	--L.orb_yell = "You'll find time can be quite volatile."

	L.fastTimeZone = "Зона ускорения времени"
end

L = BigWigs:NewBossLocale("Gul'dan", "ruRU")
if L then
	--L[211152] = "(E) %s" -- (E) Eye of Gul'dan
	L.gains = "Гул'дан получает %s"
	--L.p4_mythic_start_yell = "Time to return the demon hunter's soul to his body... and deny the Legion's master a host!"

	--L.nightorb_desc = "Summons a Nightorb, killing it will spawn a Time Zone."

	--L.manifest_desc = "Summons a Soul Fragment of Azzinoth, killing it will spawn a Demonic Essence."
end

L = BigWigs:NewBossLocale("Nighthold Trash", "ruRU")
if L then
	--[[ Skorpyron to Trilliax ]]--
	--L.torm = "Torm the Brute"
	--L.fulminant = "Fulminant"
	--L.pulsauron = "Pulsauron"

	--[[ Chronomatic Anomaly to Trilliax ]]--
	--L.sludgerax = "Sludgerax"

	--[[ Trilliax to Aluriel ]]--
	--L.karzun = "Kar'zun"
	--L.guardian = "Gilded Guardian"
	--L.battle_magus = "Duskwatch Battle-Magus"
	--L.chronowraith = "Chronowraith"
	--L.protector = "Nighthold Protector"

	--[[ Aluriel to Etraeus ]]--
	--L.jarin = "Astrologer Jarin"

	--[[ Aluriel to Telarn ]]--
	--L.weaver = "Duskwatch Weaver"
	--L.archmage = "Shal'dorei Archmage"
	--L.manasaber = "Domesticated Manasaber"

	--[[ Aluriel to Krosos ]]--
	--L.infernal = "Searing Infernal"

	--[[ Aluriel to Tichondrius ]]--
	--L.watcher = "Abyss Watcher"
end

