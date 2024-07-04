local L = BigWigs:NewBossLocale("Ulgrax the Devourer", "zhCN")
if not L then return end
if L then
	L.chunky_viscera_message = "喂食首领！（额外快捷键）"
end

L = BigWigs:NewBossLocale("The Bloodbound Horror", "zhCN")
if L then
	L.grasp_from_beyond = "触手"
	L.grasp_from_beyond_say = "触手"
	L.bloodcurdle = "分散"
	L.bloodcurdle_on_you = "分散" -- Singular of Spread
	L.goresplatter = "跑开"
end

L = BigWigs:NewBossLocale("Sikran, Captain of the Sureki", "zhCN")
if L then
	L.custom_on_repeating_phase_blades = "重复 相位之刃"
	L.custom_on_repeating_phase_blades_desc = "使用 '1{rt1}' 或 '22{rt2}' 或 '333{rt3}' 或 '4444{rt4}' 重复技能 相位之刃 的信息，明确你将被击中的顺序。"
end

L = BigWigs:NewBossLocale("Eggtender Ovi'nax", "zhCN")
if L then
	L.unstable_web_say = "网"
	L.casting_infest_on_you = "对你施放感染！"
end
