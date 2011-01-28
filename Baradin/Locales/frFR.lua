
do
	local L = BigWigs:NewBossLocale("Argaloth", "frFR")
	if not L then return end
	if L then
		L.darkness_message = "Ténèbres"
		L.firestorm_message = "Tempête de feu imminente !"
		L.meteor_bar = "~Attaque météorique"
	end
end

