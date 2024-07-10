local L = BigWigs:NewBossLocale("Ulgrax the Devourer", "frFR")
if not L then return end
if L then
	L.chunky_viscera_message = "Nourrissez le boss! (Bouton d'action spécial)"
end

L = BigWigs:NewBossLocale("The Bloodbound Horror", "frFR")
if L then
	L.grasp_from_beyond = "Tentacule"
	L.grasp_from_beyond_say = "Tentacules"
	L.bloodcurdle = "Écartez-vous"
	L.bloodcurdle_on_you = "Écartez-vous" -- Singular of Spread
	L.goresplatter = "Courez"
end

L = BigWigs:NewBossLocale("Sikran, Captain of the Sureki", "frFR")
if L then
	--L.custom_on_repeating_phase_blades = "Repeating Phase Blades Say"
	--L.custom_on_repeating_phase_blades_desc = "Repeating say messages for the Phase Blades ability using '1{rt1}' or '22{rt2}' or '333{rt3}' or '4444{rt4}' to make it clear in what order you will be hit."
end

L = BigWigs:NewBossLocale("Eggtender Ovi'nax", "frFR")
if L then
	L.unstable_web_say = "Toiles"
	L.casting_infest_on_you = "Lance Infester sur vous !"
end
