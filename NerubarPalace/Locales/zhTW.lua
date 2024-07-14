local L = BigWigs:NewBossLocale("Ulgrax the Devourer", "zhTW")
if not L then return end
if L then
	L.chunky_viscera_message = "使用額外快捷鍵餵食首領！"
end

L = BigWigs:NewBossLocale("The Bloodbound Horror", "zhTW")
if L then
	L.grasp_from_beyond = "地刺" -- 觸手
	L.grasp_from_beyond_say = "地刺"
	L.bloodcurdle = "分散"
	L.bloodcurdle_on_you = "分散" -- Singular of Spread
	L.goresplatter = "遠離"
end

L = BigWigs:NewBossLocale("Sikran, Captain of the Sureki", "zhTW")
if L then
	L.custom_on_repeating_phase_blades = "重覆相位之刃喊話"
	L.custom_on_repeating_phase_blades_desc = "以 「1{rt1}」、「22{rt2}」、「333{rt3}」和「4444{rt4}」持續喊話，提示你被相位之刃擊中的順序。"
end

L = BigWigs:NewBossLocale("Eggtender Ovi'nax", "zhTW")
if L then
	L.unstable_web_say = "蛛網"
	L.casting_infest_on_you = "正在對你施放寄生！"
end
