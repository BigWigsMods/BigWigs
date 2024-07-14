local L = BigWigs:NewBossLocale("Ulgrax the Devourer", "zhTW")
if not L then return end
if L then
	L.chunky_viscera_message = "使用額外快捷鍵餵食首領！"
end

L = BigWigs:NewBossLocale("The Bloodbound Horror", "zhTW")
if L then
	--L.grasp_from_beyond = "Tentacles" -- 觸手
	--L.grasp_from_beyond_say = "Tentacles"
	--L.bloodcurdle = "Spreads"
	--L.bloodcurdle_on_you = "Spread" -- Singular of Spread
	L.goresplatter = "遠離"
end

L = BigWigs:NewBossLocale("Sikran, Captain of the Sureki", "zhTW")
if L then
	L.custom_on_repeating_phase_blades = "重覆相位之刃喊話"
	--L.custom_on_repeating_phase_blades_desc = "Repeating say messages for the Phase Blades ability using '1{rt1}' or '22{rt2}' or '333{rt3}' or '4444{rt4}' to make it clear in what order you will be hit."
end

L = BigWigs:NewBossLocale("Eggtender Ovi'nax", "zhTW")
if L then
	L.unstable_web_say = "蛛網"
	L.casting_infest_on_you = "正在對你施放寄生！"
end
