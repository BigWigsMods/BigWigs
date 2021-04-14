local L = BigWigs:NewBossLocale("ArchimondeHyjal", "ruRU")
if not L then return end
if L then
	L.engage_trigger = "Ваше сопротивление нас не остановит."
	L.grip_other = "Хватка"
	L.fear_message = "Страх! Следующий через ~ 42сек!"

	L.killable = "Becomes Killable"
end

L = BigWigs:NewBossLocale("Azgalor", "ruRU")
if L then
	L.howl_bar = "~перезарядка Воя"
	L.howl_message = "МАСС Молчание"
end

L = BigWigs:NewBossLocale("Kaz'rogal", "ruRU")
if L then
	L.mark_bar = "След Матка (%d)"
	L.mark_warn = "Метка через 5 сек!"
end

L = BigWigs:NewBossLocale("Hyjal Summit Trash", "ruRU")
if L then
	--L.waves = "Wave Warnings"
	--L.waves_desc = "Announce approximate warning messages for the next wave."

	L.ghoul = "Вурдалаков"
	L.fiend = "Некрорахнидов"
	L.abom = "Поганищ"
	L.necro = "Мрачных некроманта"
	L.banshee = "Банши"
	L.garg = "Горгулии"
	L.wyrm = "Ледяная змея"
	L.fel = "Ловчих Скверны"
	L.infernal = "Инферналов"
	L.one = "%d волна! %d %s"
	L.two = "%d волна! %d %s, %d %s"
	L.three = "%d волна! %d %s, %d %s, %d %s"
	L.four = "%d волна! %d %s, %d %s, %d %s, %d %s"
	L.five = "%d волна! %d %s, %d %s, %d %s, %d %s, %d %s"
	L.barWave = "до прихода %d волны"

	L.waveInc = "Идет %d волна!"
	L.message = "%s через ~%d сек!"
	L.waveMessage = "%d волна через ~%d сек!"

	L.winterchillGossip = "Мои спутники и я – с вами, леди Праудмур."
	L.anetheronGossip = "Мы готовы встретить любого, кого пошлет Архимонд, леди Праудмур."
	L.kazrogalGossip = "Я с тобой, Тралл."
	L.azgalorGossip = "Нам нечего бояться."
end
