-- March on Quel'Danas

BigWigsAPI.SetBossModuleLocale("Belo'ren, Child of Al'ar", {
	color_swaps = "颜色转换",
	["1241292"] = "圣光/虚空俯冲",
})

BigWigsAPI.SetBossModuleLocale("Midnight Falls", {
	deaths_dirge = "记忆游戏",
	heavens_glaives = "战刃",
	heavens_lance = "天穹枪",
	the_dark_archangel = "大爆炸",
	prism_kicks = "打断",
	dark_constellation = "星座",
	dark_rune_bar = "解密",

	left = "[左] %s", -- left/west group bars in p3
	right = "[右] %s", -- right/east group bars in p3

	custom_select_limit_warnings = "[史诗] 限制第3阶段警报",
	custom_select_limit_warnings_desc = "仅显示你所在半场的技能警报。",
	custom_select_limit_warnings_value1 = "1、2组去左面，3、4组去右面。",
	custom_select_limit_warnings_value2 = "奇数组去左面，偶数组去右面。",
	custom_select_limit_warnings_value3 = "显示两面的所有警报。",
	custom_select_limit_warnings_value4 = "仅显示左面警报。",
	custom_select_limit_warnings_value5 = "仅显示右面警报。",
})

-- Midnight World

BigWigsAPI.SetBossModuleLocale("Thorm'belan", {
	ball_incoming = "球来了 - 不要让他落地",
	ball_fail = "失败 - 球落地了",
	tendrils = "藤蔓",
	tendrils_incoming = "快跑开，拉断藤蔓",
})

-- The Voidspire

BigWigsAPI.SetBossModuleLocale("Vorasius", {
	shadowclaw_slam = "重击", --“影爪重击”简称
})

BigWigsAPI.SetBossModuleLocale("Vaelgor & Ezzorak", {
	aspect_of_the_end = "拉断",  -- 终末守护
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

	empowered_searing_radiance = "强化灼热光辉",
	empowered_searing_radiance_desc = "显示强化灼热光辉的计时器。",

	empowered_avengers_shield = "强化复仇者之盾",
	empowered_avengers_shield_desc = "显示强化复仇者之盾的计时器。",

	empowered_divine_storm = "强化神圣风暴",
	empowered_divine_storm_desc = "显示强化神圣风暴的计时器。",
	tornadoes = "旋风", -- The renamed empowered Divine Storm

	empowered = "[强] %s", -- Empowered version of an ability, [E] Avengers Shield
})

BigWigsAPI.SetBossModuleLocale("Crown of the Cosmos", {
	grasp_of_emptiness = "方尖碑",
	interrupting_tremor = "干扰震荡",
	ravenous_abyss = "躲避",
	silverstrike_barrage = "弹幕",  -- 银锋弹幕射击
	cosmic_barrier = "屏障",
	voidstalker_sting = "钉刺",  -- 虚空追猎者钉刺
	aspect_of_the_end = "拉断",  -- 终末守护
	devouring_cosmos = "换场地",
})
