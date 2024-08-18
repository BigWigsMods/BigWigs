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

L = BigWigs:NewBossLocale("Rasha'nan", "zhCN")
if L then
	L.rolling_acid = "波浪"
	L.spinnerets_strands = "丝线"
	L.enveloping_webs = "蛛网"
	L.enveloping_web_say = "蛛网" -- Singular of Webs
	L.erosive_spray = "喷涌"
	L.caustic_hail = "下一个位置"
end

L = BigWigs:NewBossLocale("Broodtwister Ovi'nax", "zhCN")
if L then
	--L.sticky_web = "Webs"
	L.sticky_web_say = "蛛网" -- Singular of Webs
	L.infest_message = "对你施放感染！"
	L.infest_say = "寄生"
	--L.experimental_dosage = "Egg Breaks"
	--L.experimental_dosage_say = "Egg Break"
	--L.ingest_black_blood = "Next Container"
	L.unstable_infusion = "紫圈"

	L.custom_on_experimental_dosage_marks = "试验性剂量分配"
	L.custom_on_experimental_dosage_marks_desc = "将受到“试验性剂量” 的玩家，按照 近战 > 远程 > 治疗 的优先顺序分配 {rt6}{rt4}{rt3}{rt7} 标记。 包含喊话和目标信息。"
end

L = BigWigs:NewBossLocale("Nexus-Princess Ky'veza", "zhCN")
if L then
	L.assasination = "幻影"
	L.twiligt_massacre = "冲锋"
	L.nexus_daggers = "匕首"
end

L = BigWigs:NewBossLocale("The Silken Court", "zhCN")
if L then
	--L.skipped_cast = "Skipped %s (%d)"

	--L.venomous_rain = "Rain"
	--L.burrowed_eruption = "Burrow"
	--L.stinging_swarm = "Dispel Debuffs"
	--L.strands_of_reality = "Frontal [S]" -- S for Skeinspinner Takazj
	--L.impaling_eruption = "Frontal [A]" -- A for Anub'arash
	--L.entropic_desolation = "Run Out"
	--L.cataclysmic_entropy = "Big Boom" -- Interrupt before it casts
	--L.spike_eruption = "Spikes"
	--L.unleashed_swarm = "Swarm"
end
