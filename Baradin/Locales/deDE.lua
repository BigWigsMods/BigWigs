
local L = BigWigs:NewBossLocale("Argaloth", "deDE")
if not L then return end
if L then
	L.darkness_message = "Dunkelheit"
	L.firestorm_message = "Feuersturm bald!"
end

L = BigWigs:NewBossLocale("Occu'thar", "deDE")
if not L then return end
if L then
	L.shadows_bar = "~Sengende Schatten"
	L.destruction_bar = "Zerstörung!"
	L.eyes_bar = "~Augen"

	L.fire_message = "Laserz, pew-pew!"
	L.fire_bar = "~Laserz"
end

