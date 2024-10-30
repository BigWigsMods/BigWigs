local L = BigWigs:NewBossLocale("Ulgrax the Devourer", "zhCN")
if not L then return end
if L then
	L.carnivorous_contest_pull = "拉扯"
	L.chunky_viscera_message = "喂食首领！（额外快捷键）"
end

L = BigWigs:NewBossLocale("The Bloodbound Horror", "zhCN")
if L then
	L.gruesome_disgorge_debuff = "内场"
	L.grasp_from_beyond = "触手"
	L.grasp_from_beyond_say = "触手"
	L.bloodcurdle = "分散"
	L.bloodcurdle_on_you = "分散" -- Singular of Spread
	L.goresplatter = "远离"
end

L = BigWigs:NewBossLocale("Rasha'nan", "zhCN")
if L then
	L.spinnerets_strands = "丝线"
	L.enveloping_webs = "蛛网"
	L.enveloping_web_say = "蛛网" -- Singular of Webs
	L.erosive_spray = "喷涌"
	L.caustic_hail = "下个位置"
end

L = BigWigs:NewBossLocale("Broodtwister Ovi'nax", "zhCN")
if L then
	L.sticky_web = "蛛网"
	L.sticky_web_say = "蛛网" -- Singular of Webs
	L.infest_message = "对你施放感染！"
	L.infest_say = "寄生"
	L.experimental_dosage = "破蛋"
	L.experimental_dosage_say = "破蛋"
	L.ingest_black_blood = "下个容器"
	L.unstable_infusion = "紫圈"

	L.custom_on_experimental_dosage_marks = "试验性剂量分配"
	L.custom_on_experimental_dosage_marks_desc = "将受到“试验性剂量” 的玩家，按照 近战 > 远程 > 治疗 的优先顺序分配 {rt6}{rt4}{rt3}{rt7} 标记。 包含喊话和目标信息。"

	L.volatile_concoction_explosion_desc = "显示受到不稳定的混合物减益效果影响的目标计时条。"
end

L = BigWigs:NewBossLocale("Nexus-Princess Ky'veza", "zhCN")
if L then
	L.assasination = "幻影"
	L.twiligt_massacre = "冲锋"
	L.nexus_daggers = "匕首"
end

L = BigWigs:NewBossLocale("The Silken Court", "zhCN")
if L then
	L.skipped_cast = "跳过 %s (%d)"
	L.intermission_trigger = "巅峰之力！" -- Skeinspinner Takazj 100 energy yell

	L.venomous_rain = "毒雨"
	L.burrowed_eruption = "钻地"
	L.stinging_swarm = "驱散减益"
	L.strands_of_reality = "正面 [塔卡]" -- S for Skeinspinner Takazj 使用了首领名字前二个字“塔卡兹基”
	L.strands_of_reality_message = "正面 [纺束者塔卡兹基]"
	L.impaling_eruption = "正面 [阿努]" -- A for Anub'arash 使用了首领名字前二个字“阿努巴拉什”
	L.impaling_eruption_message = "正面 [阿努巴拉什]"
	L.entropic_desolation = "熵能"  --使用技能名称。
	L.cataclysmic_entropy = "大爆炸" -- Interrupt before it casts
	L.spike_eruption = "尖刺"
	L.unleashed_swarm = "虫群"
	L.void_degeneration = "蓝球"
	L.burning_rage = "红球"
end

L = BigWigs:NewBossLocale("Queen Ansurek", "zhCN")
if L then
	L.stacks_onboss = "首领：%d层 %s"

	L.reactive_toxin = "毒素"
	L.reactive_toxin_say = "毒素"
	L.venom_nova = "新星"  -- 剧毒新星，暂时用新星，也可以用毒环
	L.web_blades = "网刃"  -- 中文技能名称短直接使用技能名称
	L.silken_tomb = "缠绕" -- Raid being rooted in place
	L.wrest = "拉扯"
	L.royal_condemnation = "镣铐"
	L.frothing_gluttony = "能量环"

	L.stage_two_end_message_storymode = "快进传送门"
end
