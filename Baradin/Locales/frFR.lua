
local L = BigWigs:NewBossLocale("Argaloth", "frFR")
if not L then return end
if L then
	L.darkness_message = "Ténèbres"
	L.firestorm_message = "Tempête de feu imminente !"
end

L = BigWigs:NewBossLocale("Occu'thar", "frFR")
if not L then return end
if L then
	L.shadows_bar = "~Ombres incendiaires"
	L.destruction_bar = "<Explosion des yeux>"
	L.eyes_bar = "~Yeux"

	L.fire_message = "Feu focalisé"
	L.fire_bar = "~Feu focalisé"
end

L = BigWigs:NewBossLocale("Alizabal", "frFR")
if L then
	L.first_ability = "Embrocher ou Haine"
	L.dance_message = "Danse des lames %d sur 3"
end

