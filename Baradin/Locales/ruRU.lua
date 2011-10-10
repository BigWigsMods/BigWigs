
local L = BigWigs:NewBossLocale("Argaloth", "ruRU")
if not L then return end
if L then
	L.darkness_message = "Всепожирающая тьма"
	L.firestorm_message = "Скоро Огненная буря!"
	L.meteor_bar = "~Метеоритный дождь"
end

L = BigWigs:NewBossLocale("Occu'thar", "ruRU")
if not L then return end
if L then
	L.shadows_bar = "~След. тени"
	L.destruction_bar = "Взрыв"
	L.eyes_bar = "~След. глаза"

	L.fire_message = "Лазер, пиу-пиу!"
	L.fire_bar = "~След. лазер"
end

