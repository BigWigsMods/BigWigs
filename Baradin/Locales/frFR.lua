
local L = BigWigs:NewBossLocale("Argaloth", "frFR")
if not L then return end
if L then
	L.darkness_message = "Ténèbres"
	L.firestorm_message = "Tempête de feu imminente !"
	L.meteor_bar = "~Attaque météorique"
end

L = BigWigs:NewBossLocale("Occu'thar", "frFR")
if not L then return end
if L then
	L.shadows_bar = "~Ombres incendiaires"
	L.destruction_bar = "Explosion des yeux"
	L.eyes_bar = "~Prochains yeux"

	L.fire_message = "Feu focalisé"
	L.fire_bar = "~Prochain Feu focalisé"
end

