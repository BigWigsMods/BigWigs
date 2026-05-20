if not BigWigsAPI.IsLocale("koKR") then return end
BigWigsAPI.SetBossModuleLocale("Vorasius", {
	shadowclaw_slam = "바닥",
})

BigWigsAPI.SetBossModuleLocale("Lightblinded Vanguard", {
	aura_of_wrath = "진노", -- Short for Aura of Wrath
	executes_mythic = "선고 + 피하기",
	execution_sentence = "선고", -- Short for Execution Sentence
	judgement_red = "심판 [빨]", -- R for the Red icon.
	aura_of_devotion = "헌오", -- Short for Aura of Devotion
	judgement_blue = "심판 [파]", -- B for the Blue icon.
	aura_of_peace = "바닥", -- Short for Aura of Peace
	tyrs_wrath_mythic = "보호막 + 선고",
	divine_toll_mythic = "피하기 + 보호막",

	empowered_searing_radiance = "강화된 이글거리는 광휘",
	empowered_searing_radiance_desc = "강화된 이글거리는 광휘 타이머 표시.",

	empowered_avengers_shield = "강화된 응징의 방패",
	empowered_avengers_shield_desc = "강화된 응징의 방패 타이머 표시.",

	empowered_divine_storm = "강화된 천상의 폭풍",
	empowered_divine_storm_desc = "강화된 천상의 폭풍 타이머 표시.",
	tornadoes = "토네이도", -- The renamed empowered Divine Storm

	empowered = "[강화] %s", -- Empowered version of an ability, [E] Avengers Shield
})

BigWigsAPI.SetBossModuleLocale("Crown of the Cosmos", {
	grasp_of_emptiness = "방첨탑",
	interrupting_tremor = "차단",
	ravenous_abyss = "바닥",
	silverstrike_barrage = "라인",
	cosmic_barrier = "보호막",
	voidstalker_sting = "독침",
	aspect_of_the_end = "사슬",
	devouring_cosmos = "단상 이동",
})
