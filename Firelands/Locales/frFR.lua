local L = BigWigs:NewBossLocale("Beth'tilac", "frFR")
if not L then return end
if L then
	L.kiss_message = "%2$dx Baisers sur %1$s"
end

L = BigWigs:NewBossLocale("Lord Rhyolith", "frFR")
if L then
	L.phase2_message = "Phase Immoler imminente ! Le boss a %dx %s"
end

L = BigWigs:NewBossLocale("Alysrazor", "frFR")
if L then
	L.tornado_trigger = "Ce ciel est à MOI !" -- à vérifier
	L.claw_message = "%2$dx Griffes sur %1$s"
	L.fullpower_message = "%s imminent !"
end

L = BigWigs:NewBossLocale("Shannox", "frFR")
if L then
	L.safe = "%s sauvé"
end

L = BigWigs:NewBossLocale("Baleroc", "frFR")
if L then
	L.torment_message = "%2$dx Tourments sur %1$s"
end

L = BigWigs:NewBossLocale("Majordomo Staghelm", "frFR")
if L then
	L.seed_explosion = "Explosion de la graîne imminente !"
end

L = BigWigs:NewBossLocale("Ragnaros", "frFR")
if L then
	L.intermission = "Intervalle"
	L.sons_left = "Il reste %d Fils"
	L.engulfing_close = "%s proches"
	L.engulfing_middle = "%s éloignées"
	L.engulfing_far = "%s au milieu"
end
