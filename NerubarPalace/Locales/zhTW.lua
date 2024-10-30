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

	--L.volatile_concoction_explosion_desc = "Show a target bar for the Volatile Concoction debuff."
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
	--L.intermission_trigger = "Apex of power!" -- Skeinspinner Takazj 100 energy yell

	L.venomous_rain = "毒雨" -- 毒圈 綠圈
	L.burrowed_eruption = "鑽地"
	L.stinging_swarm = "驅散魔法"
	L.strands_of_reality = "塔卡正面" -- S for Skeinspinner Takazj 塔卡震懾波
	L.strands_of_reality_message = "塔卡茲：正面衝擊波"
	L.impaling_eruption = "阿努正面" -- A for Anub'arash 阿努震懾波
	L.impaling_eruption_message = "阿努巴拉許：正面衝擊波"
	L.entropic_desolation = "跑開"
	L.cataclysmic_entropy = "大爆炸" -- 災變無序/災變
	L.spike_eruption = "尖刺"
	L.unleashed_swarm = "蟲群"
	L.void_degeneration = "藍球"
	L.burning_rage = "紅球"
end

L = BigWigs:NewBossLocale("Queen Ansurek", "zhTW")
if L then
	L.stacks_onboss = "首領：%d 層%s"

	L.reactive_toxin = "毒素" -- 技能描述用了「毒素」
	L.reactive_toxin_say = "毒素"
	L.venom_nova = "新星"
	L.web_blades = "刀刃" -- 技能描述「刀刃絲網」
	L.silken_tomb = "絲網" -- Raid being rooted in place
	L.wrest = "拉扯" -- 好像也不用轉？搶奪只有兩個字
	L.royal_condemnation = "鐐銬"
	L.frothing_gluttony = "暴食" -- 起沫暴食/黑環

	L.stage_two_end_message_storymode = "快進傳送門"
end
