local L = BigWigs:NewBossLocale("Azuregos", "koKR")
if not L then return end
if L then
	L.bossName = "아주어고스"

	L.teleport = "소환 경고"
	L.teleport_desc = "소환에 대한 경고"
	L.teleport_trigger = "오너라, 조무래기들아! 덤벼봐라!"
	L.teleport_message = "강제 소환!"
end

L = BigWigs:NewBossLocale("Lord Kazzak", "koKR")
if L then
	L.bossName = "군주 카자크"

	L.engage_trigger = "군단을 위하여! 킬제덴을 위하여!" --CHECK

	L.supreme_mode = "무적 모드"
end

local L = BigWigs:NewBossLocale("Emeriss", "koKR")
if L then
	L.bossName = "에메리스"

	-- L.engage_trigger = "Hope is a DISEASE of the soul! This land shall wither and die!"
end

local L = BigWigs:NewBossLocale("Lethon", "koKR")
if L then
	L.bossName = "레손"

	-- L.engage_trigger = "I can sense the SHADOW on your hearts. There can be no rest for the wicked!"
end

local L = BigWigs:NewBossLocale("Taerar", "koKR")
if L then
	L.bossName = "타에라"

	-- L.engage_trigger = "Peace is but a fleeting dream! Let the NIGHTMARE reign!"
end

local L = BigWigs:NewBossLocale("Ysondre", "koKR")
if L then
	L.bossName = "이손드레"

	-- L.engage_trigger = "The strands of LIFE have been severed! The Dreamers must be avenged!"
end
