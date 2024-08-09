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

L = BigWigs:NewBossLocale("Rasha'nan", "zhTW")
if L then
	L.rolling_acid = "波浪"
	L.spinnerets_strands = "絲線" -- 絲囊?
	L.enveloping_webs = "蛛網"
	L.enveloping_web_say = "蛛網" -- Singular of Webs
	L.erosive_spray = "酸液"
	L.caustic_hail = "下個位置"
end

L = BigWigs:NewBossLocale("Broodtwister Ovi'nax", "zhTW")
if L then
	L.sticky_web_say = "蛛網"
	L.infest_message = "正在對你施放寄生！"
	L.infest_say = "寄生"
	--L.experimental_dosage_say = "Soak Egg"
	--L.unstable_infusion = "Swirls"
	L.custom_on_experimental_dosage_marks = "實驗療法分配"
	L.custom_on_experimental_dosage_marks_desc = "將受到「實驗療法」影響的玩家，按照近戰 > 遠程 > 治療的優先級，標記為 {rt6}{rt4}{rt3}{rt7}，包含喊話與目標訊息。"
end

L = BigWigs:NewBossLocale("Nexus-Princess Ky'veza", "zhTW")
if L then
	L.assasination = "幻影"
	L.twiligt_massacre = "衝鋒"
	L.nexus_daggers = "匕首"
end
