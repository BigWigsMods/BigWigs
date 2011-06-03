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
	L.tornado_trigger = "These skies are MINE!" -- transcription needed
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

end

L = BigWigs:NewBossLocale("Ragnaros", "frFR")
if L then
	L.stage_one = "Phase 1 : Par le Feu soyez purifiés !" -- not yet translated in the EJ
	L.intermission = "Intermission"
	L.stage_two = "Phase 2 : Sulfuras sera votre fin !" -- not yet translated in the EJ
	L.stage_three = "Phase 3 : Barrez-vous de mon royaume !" -- not yet translated in the EJ
	L.sons_dead = "Fils morts !"
	L.sons_left = "Il reste %d Fils"
end

