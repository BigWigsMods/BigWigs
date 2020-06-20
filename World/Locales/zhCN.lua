local L = BigWigs:NewBossLocale("Azuregos", "zhCN")
if not L then return end
if L then
	L.bossName = "艾索雷苟斯"

	L.teleport = "传送警报"
	L.teleport_desc = "传送警报"
	L.teleport_trigger = "来吧，小子。面对我！"
	L.teleport_message = "传送发动！"
end

L = BigWigs:NewBossLocale("Lord Kazzak", "zhCN")
if L then
	L.bossName = "卡扎克"

	L.engage_trigger = "为了燃烧军团！为了基尔加丹！"

	L.supreme_mode = "无敌模式"
end

local L = BigWigs:NewBossLocale("Emeriss", "zhCN")
if L then
	L.bossName = "艾莫莉丝"

	-- L.engage_trigger = "Hope is a DISEASE of the soul! This land shall wither and die!"
end

local L = BigWigs:NewBossLocale("Lethon", "zhCN")
if L then
	L.bossName = "莱索恩"

	-- L.engage_trigger = "I can sense the SHADOW on your hearts. There can be no rest for the wicked!"
end

local L = BigWigs:NewBossLocale("Taerar", "zhCN")
if L then
	L.bossName = "泰拉尔"

	-- L.engage_trigger = "Peace is but a fleeting dream! Let the NIGHTMARE reign!"
end

local L = BigWigs:NewBossLocale("Ysondre", "zhCN")
if L then
	L.bossName = "伊森德雷"

	-- L.engage_trigger = "The strands of LIFE have been severed! The Dreamers must be avenged!"
end
