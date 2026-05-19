if not BigWigsAPI.IsLocale("zhTW") then return end
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
	empowered_searing_radiance_desc = "顯示強化熾熱烈光的計時條",

	empowered_avengers_shield = "強化神聖之盾",
	empowered_avengers_shield_desc = "顯示強化神聖之盾的計時條",

	empowered_divine_storm = "強化神性風暴",
	empowered_divine_storm_desc = "顯示強化神性風暴的計時條",
	tornadoes = "神聖暴風", -- The renamed empowered Divine Storm 手冊裡這麼叫

	empowered = "強化%s", -- Empowered version of an ability, [E] Avengers Shield
})

BigWigsAPI.SetBossModuleLocale("Crown of the Cosmos", {
	silverstrike_arrow = "箭矢",
	grasp_of_emptiness = "方尖碑",
	interrupting_tremor = "震顫", --用法術名，或者斷法
	ravenous_abyss = "深淵", -- 貪婪深淵
	silverstrike_barrage = "箭雨",  -- 銀殤箭雨
	cosmic_barrier = "屏障",
	rangers_captains_mark = "箭頭", --遊俠隊長印記，是個箭頭
	voidstalker_sting = "釘刺", -- 虛無潛獵者釘刺
	aspect_of_the_end = "拉斷", -- 終結守護
	devouring_cosmos = "下個平台", -- 換場地/換平台/下個平台
})
