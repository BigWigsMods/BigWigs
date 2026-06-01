-- March on Quel'Danas

BigWigsAPI.SetBossModuleLocale("Belo'ren, Child of Al'ar", {
	color_swaps = "換色",
	["1241292"] = "俯衝",
})

BigWigsAPI.SetBossModuleLocale("Midnight Falls", {
	deaths_dirge = "記憶遊戲",
	heavens_glaives = "戰刃",
	heavens_lance = "長槍",
	the_dark_archangel = "大爆炸",
	prism_kicks = "打斷",
	dark_constellation = "星宿",
	dark_rune_bar = "排列符文", -- 解密、玩游戲、把符文按順續排列

	left = "左：%s", -- left/west group bars in p3
	right = "右：%s", -- right/east group bars in p3

	custom_select_limit_warnings = "傳奇模式：第三階段警報限制",
	custom_select_limit_warnings_desc = "只顯示你這一側的技能警報。",
	custom_select_limit_warnings_value1 = "一二隊往左，三四隊往右。",
	custom_select_limit_warnings_value2 = "奇數隊往左，偶數隊往右。",
	custom_select_limit_warnings_value3 = "顯示雙側警報。",
	custom_select_limit_warnings_value4 = "只顯示左側警報。",
	custom_select_limit_warnings_value5 = "只顯示右側警報。",
})

-- Midnight World

BigWigsAPI.SetBossModuleLocale("Thorm'belan", {
	--ball = "Ball",
	--ball_incoming = "Ball Incoming - Don't let it touch the ground",
	--ball_fail = "FAIL - Ball touched the ground",
	--tendrils = "Tendrils",
	--tendrils_incoming = "RUN AWAY to snap tendrils",
})

-- The Voidspire

BigWigsAPI.SetBossModuleLocale("Vorasius", {
	shadowclaw_slam = "猛擊",
})

BigWigsAPI.SetBossModuleLocale("Lightblinded Vanguard", {
	aura_of_wrath = "憤慨光環", -- Short for Aura of Wrath 不用縮寫
	execution_sentence = "死刑宣判", -- Short for Execution Sentence  不用縮寫，或者處決?
	executes_mythic = "死刑+躲開", -- 死刑宣判+神聖鳴響
	judgement_red = "紅色審判", -- R for the Red icon. 審判+裁決
	aura_of_devotion = "奉獻光環", -- Short for Aura of Devotion
	judgement_blue = "藍色審判", -- B for the Blue icon. 審判+盾猛
	aura_of_peace = "和平光環", -- Short for Aura of Peace
	tyrs_wrath_mythic = "吸收+死刑", -- 提爾之盾+死刑宣判，吸收盾/治療吸收盾太長了
	divine_toll_mythic = "躲開 + 吸收", -- 神聖鳴響+提爾之盾

	empowered_searing_radiance = "強化熾熱烈光",
	empowered_searing_radiance_desc = "顯示強化熾熱烈光的計時條。",

	empowered_avengers_shield = "強化神聖之盾",
	empowered_avengers_shield_desc = "顯示強化神聖之盾的計時條。",

	empowered_divine_storm = "強化神性風暴",
	empowered_divine_storm_desc = "顯示強化神性風暴的計時條。",
	tornadoes = "神聖暴風", -- The renamed empowered Divine Storm 手冊裡這麼叫

	empowered = "強化%s", -- Empowered version of an ability, [E] Avengers Shield
})

BigWigsAPI.SetBossModuleLocale("Crown of the Cosmos", {
	grasp_of_emptiness = "方尖碑",
	interrupting_tremor = "震顫", --用法術名，或者斷法
	ravenous_abyss = "深淵", -- 貪婪深淵
	silverstrike_barrage = "箭雨",  -- 銀殤箭雨
	cosmic_barrier = "屏障",
	voidstalker_sting = "釘刺", -- 虛無潛獵者釘刺
	aspect_of_the_end = "拉斷", -- 終結守護
	devouring_cosmos = "下個平台", -- 換場地/換平台/下個平台
})
