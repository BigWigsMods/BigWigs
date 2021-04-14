local L = BigWigs:NewBossLocale("ArchimondeHyjal", "zhTW")
if not L then return end
if L then
	L.engage_trigger = "你反抗是沒有用的。"
	L.grip_other = "軍團之握"
	L.fear_message = "恐懼術! 42 秒後再次發動!"

	L.killable = "可以擊殺"
end

L = BigWigs:NewBossLocale("Azgalor", "zhTW")
if L then
	L.howl_bar = "亞茲加洛之吼冷卻"
	L.howl_message = "群體沉默"
end

L = BigWigs:NewBossLocale("Kaz'rogal", "zhTW")
if L then
	L.mark_bar = "下一次印記: %d"
	L.mark_warn = "約 5 秒後，施放印記!"
end

L = BigWigs:NewBossLocale("Hyjal Summit Trash", "zhTW")
if L then
	L.waves = "階段警報"
	L.waves_desc = "通報下一波小怪來臨訊息"

	L.ghoul = "食屍鬼"
	L.fiend = "地穴捕獵者"
	L.abom = "憎惡"
	L.necro = "幽暗的死靈法師"
	L.banshee = "女妖"
	L.garg = "石像鬼"
	L.wyrm = "冰龍"
	L.fel = "惡魔捕獵者"
	L.infernal = "巨型地獄火"
	L.one = "第 %d 波：%d %s！"
	L.two = "第 %d 波：%d %s、%d %s！"
	L.three = "第 %d 波：%d %s、%d %s、%d %s！"
	L.four = "第 %d 波：%d %s、%d %s、%d %s、%d %s！"
	L.five = "第 %d 波：%d %s、%d %s、%d %s、%d %s、%d %s！"
	L.barWave = "第 %d 波出現！"

	L.waveInc = "第 %d 波即將來臨！"
	L.message = "%s 約 %d 秒後來臨!"
	L.waveMessage = "第 %d 波約 %d 秒後來臨!"

	L.winterchillGossip = "我和我的同伴都與你同在，普勞德摩爾女士。"
	L.anetheronGossip = "不管阿克蒙德要派誰來對付我們，我們都已經準備好了，普勞德摩爾女士。"
	L.kazrogalGossip = "我與你同在，索爾。"
	L.azgalorGossip = "我們無所畏懼。"
end
