
local L = BigWigs:NewBossLocale("Argaloth", "ruRU")
if not L then return end
if L then
	L.darkness_message = "Всепожирающая тьма"
	L.firestorm_message = "Скоро Огненная буря!"
end

L = BigWigs:NewBossLocale("Occu'thar", "ruRU")
if not L then return end
if L then
	L.shadows_bar = "~Тень"
	L.destruction_bar = "<Взрыв>"
	L.eyes_bar = "~Глаза"

	L.fire_message = "Лазер, пиу-пиу!"
	L.fire_bar = "~Лазер"
end

L = BigWigs:NewBossLocale("Alizabal", "ruRU")
if L then
	L.first_ability = "Вертел или Ненависть"
	L.dance_message = "Танец клинков %d из 3"
end

