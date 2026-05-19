if not BigWigsAPI.IsLocale("zhCN") then return end
BigWigsAPI.SetBossModuleLocale("Vorasius", {
	shadowclaw_slam = "重击", --“影爪重击”简称
})

BigWigsAPI.SetBossModuleLocale("Fallen-King Salhadaar", {
	fractured_projection = "镜像", -- 打断？
})

BigWigsAPI.SetBossModuleLocale("Vaelgor & Ezzorak", {
	grappling_maw = "抓钩之颚", -- 直接使用技能名称
})

BigWigsAPI.SetBossModuleLocale("Lightblinded Vanguard", {
	aura_of_wrath = "愤怒光环",
	execution_sentence = "处决宣判",
	executes_mythic = "处决 + 躲避",
	judgement_red = "审判 [红]", -- 红色图标
	aura_of_devotion = "虔诚光环",
	judgement_blue = "审判 [蓝]", -- 蓝色图标
	aura_of_peace = "平心光环",
	tyrs_wrath_mythic = "吸收盾 + 处决",
	divine_toll_mythic = "躲避 + 吸收盾",
	zealous_spirit = "狂热之魂", -- “狂热之魂”全称合适

	empowered_searing_radiance = "强化灼热光辉",
	empowered_searing_radiance_desc = "显示强化灼热光辉的计时器",

	empowered_avengers_shield = "强化复仇者之盾",
	empowered_avengers_shield_desc = "显示强化复仇者之盾的计时器",

	empowered_divine_storm = "强化神圣风暴",
	empowered_divine_storm_desc = "显示强化神圣风暴的计时器",
	tornadoes = "旋风", -- The renamed empowered Divine Storm

	empowered = "[强] %s", -- Empowered version of an ability, [E] Avengers Shield
})

BigWigsAPI.SetBossModuleLocale("Crown of the Cosmos", {
	silverstrike_arrow = "箭矢",
	grasp_of_emptiness = "方尖碑",
	interrupting_tremor = "干扰震荡",
	ravenous_abyss = "躲避",
	silverstrike_barrage = "弹幕",  -- 银锋弹幕射击
	cosmic_barrier = "屏障",
	rangers_captains_mark = "箭矢",
	voidstalker_sting = "钉刺",  -- 虚空追猎者钉刺
	aspect_of_the_end = "拉断",  -- 终末守护
	devouring_cosmos = "换场地",
})
