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

L = BigWigs:NewBossLocale("Broodtwister Ovi'nax", "zhTW")
if L then
	L.sticky_web_say = "蛛網"
	L.infest_message = "正在對你施放寄生！"
	--L.infest_say = "Parasites"
	--L.experimental_dosage_say = "Soak Egg"
	--L.unstable_infusion = "Swirls"
	--L.custom_on_experimental_dosage_marks = "Experimental Dosage assignments"
	--L.custom_on_experimental_dosage_marks_desc = "Assign players affected by 'Experimental Dosage' to {rt6}{rt4}{rt3}{rt7} with a melee > ranged > healer priority. Affects Say and Target messages."
end
