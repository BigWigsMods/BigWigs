local L = BigWigs:NewBossLocale("Azuregos", "zhTW")
if not L then return end
if L then
	L.bossName = "艾索雷葛斯"

	L.teleport = "傳送警報"
	L.teleport_desc = "傳送警報"
	L.teleport_trigger = "來吧，小子。面對我！"
	L.teleport_message = "傳送發動！"
end

L = BigWigs:NewBossLocale("Lord Kazzak", "zhTW")
if L then
	L.bossName = "卡札克"

	L.engage_trigger = "為了軍團！為了基爾加德！"

	L.supreme_mode = "上帝模式"
end

local L = BigWigs:NewBossLocale("Emeriss", "zhTW")
if L then
	L.bossName = "艾莫莉絲"

	-- L.engage_trigger = "Hope is a DISEASE of the soul! This land shall wither and die!"
end

local L = BigWigs:NewBossLocale("Lethon", "zhTW")
if L then
	L.bossName = "雷索"

	-- L.engage_trigger = "I can sense the SHADOW on your hearts. There can be no rest for the wicked!"
end

local L = BigWigs:NewBossLocale("Taerar", "zhTW")
if L then
	L.bossName = "泰拉爾"

	-- L.engage_trigger = "Peace is but a fleeting dream! Let the NIGHTMARE reign!"
end

local L = BigWigs:NewBossLocale("Ysondre", "zhTW")
if L then
	L.bossName = "伊索德雷"

	-- L.engage_trigger = "The strands of LIFE have been severed! The Dreamers must be avenged!"
end
