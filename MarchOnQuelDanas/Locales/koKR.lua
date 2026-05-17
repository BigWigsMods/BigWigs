if not BigWigsAPI.IsLocale("koKR") then return end
BigWigsAPI.SetBossModuleLocale("Belo'ren, Child of Al'ar", {
	infused_quills = "레이저",
	voidlight_convergence = "색상 변경",
	light_void_dive = "빛/공허 바닥",
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

	dark_quasar_stage1_note = "1단계만",
	dark_quasar_intermission_note = "사잇단계만",
})
