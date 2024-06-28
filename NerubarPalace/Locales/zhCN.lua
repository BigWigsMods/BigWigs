local L = BigWigs:NewBossLocale("Ulgrax the Devourer", "zhCN")
if not L then return end
if L then
	L.chunky_viscera_message = "喂食首领！（额外快捷键）"
end

L = BigWigs:NewBossLocale("The Bloodbound Horror", "zhCN")
if L then
	--L.grasp_from_beyond = "Tentacles"
	L.grasp_from_beyond_say = "触手"
	--L.bloodcurdle = "Spreads"
	--L.bloodcurdle_on_you = "Spread" -- Singular of Spread
	--L.goresplatter = "Run Away"
end

L = BigWigs:NewBossLocale("Sikran, Captain of the Sureki", "zhCN")
if L then
	--L.custom_on_repeating_phase_blades = "Repeating Phase Blades Say"
	--L.custom_on_repeating_phase_blades_desc = "Repeating say messages for the Phase Blades ability using '1{rt1}' or '22{rt2}' or '333{rt3}' or '4444{rt4}' to make it clear in what order you will be hit."
end

L = BigWigs:NewBossLocale("Eggtender Ovi'nax", "zhCN")
if L then
	L.unstable_web_say = "网"
	L.casting_infest_on_you = "对你施放感染！"
end
