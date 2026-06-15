-- March on Quel'Danas

BigWigsAPI.SetBossModuleLocale("Belo'ren, Child of Al'ar", {
	color_swaps = "색상 변경",
	["1241292"] = "빛/공허 바닥",
})

BigWigsAPI.SetBossModuleLocale("Midnight Falls", {
	deaths_dirge = "음표 게임",
	heavens_glaives = "칼날",
	heavens_lance = "찌르기",
	the_dark_archangel = "대천사",
	prism_kicks = "차단",
	dark_constellation = "별자리",
	dark_rune_bar = "음표 게임",

	left = "[왼] %s", -- left/west group bars in p3
	right = "[오] %s", -- right/east group bars in p3

	custom_select_limit_warnings = "[신화] 3단계 알림 제한 설정",
	custom_select_limit_warnings_desc = "자신 위치의 스킬에 대한 알림만 표시합니다.",
	custom_select_limit_warnings_value1 = "1, 2파티 왼쪽으로, 3, 4파티 오른쪽으로 이동합니다.",
	custom_select_limit_warnings_value2 = "홀수 파티는 왼쪽으로, 짝수 파티는 오른쪽으로 이동합니다.",
	custom_select_limit_warnings_value3 = "양쪽 모두에 대한 알림를 표시합니다.",
	custom_select_limit_warnings_value4 = "왼쪽에만 대한 알림를 표시합니다.",
	custom_select_limit_warnings_value5 = "오른쪽에만 대한 알림를 표시합니다.",
})

-- Midnight World

BigWigsAPI.SetBossModuleLocale("Thorm'belan", {
	ball_incoming = "공이 다가옵니다 - 땅에 닿지 않게 하세요",
	ball_fail = "실패 - 공이 땅에 닿았습니다",
	tendrils = "덩굴손",
	tendrils_incoming = "덩굴손을 끊으려면 빨리 도망가세요",
})

-- The Voidspire

BigWigsAPI.SetBossModuleLocale("Vorasius", {
	shadowclaw_slam = "바닥",
})

BigWigsAPI.SetBossModuleLocale("Vaelgor & Ezzorak", {
	nullzone = "사슬",
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
