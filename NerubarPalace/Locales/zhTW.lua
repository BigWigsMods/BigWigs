local L = BigWigs:NewBossLocale("Ulgrax the Devourer", "zhTW")
if not L then return end
if L then
	L.carnivorous_contest_pull = "拉扯" -- 要不...吃人?
	L.chunky_viscera_message = "使用額外快捷鍵餵食首領！"
end

L = BigWigs:NewBossLocale("The Bloodbound Horror", "zhTW")
if L then
	L.gruesome_disgorge_debuff = "內場" -- 非表象之境 名字太長了
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
	L.sticky_web = "蛛網"
	L.sticky_web_say = "蛛網" -- Singular of Webs
	L.infest_message = "正在對你施放寄生！"
	L.infest_say = "寄生"
	L.experimental_dosage = "破蛋"
	L.experimental_dosage_say = "破蛋"
	L.ingest_black_blood = "換場" -- 或 下個容器
	L.unstable_infusion = "黑圈"  -- 或 旋渦

	L.custom_on_experimental_dosage_marks = "實驗療法分配"
	L.custom_on_experimental_dosage_marks_desc = "將受到「實驗療法」影響的玩家，按照近戰 > 遠程 > 治療的優先級，標記為 {rt6}{rt4}{rt3}{rt7}，包含喊話與目標訊息。"
end

L = BigWigs:NewBossLocale("Nexus-Princess Ky'veza", "zhTW")
if L then
	L.assasination = "幻影"
	L.twiligt_massacre = "衝鋒"
	L.nexus_daggers = "匕首"
end

L = BigWigs:NewBossLocale("The Silken Court", "zhTW")
if L then
	--L.skipped_cast = "Skipped %s (%d)"

	L.venomous_rain = "毒雨" -- 毒圈 綠圈
	L.burrowed_eruption = "鑽地"
	L.stinging_swarm = "驅散魔法"
	L.strands_of_reality = "塔卡正面" -- S for Skeinspinner Takazj 塔卡震懾波
	L.impaling_eruption = "阿努正面" -- A for Anub'arash 阿努震懾波
	L.entropic_desolation = "跑開"
	L.cataclysmic_entropy = "大爆炸" -- 災變無序/災變
	L.spike_eruption = "尖刺"
	L.unleashed_swarm = "蟲群"
end
