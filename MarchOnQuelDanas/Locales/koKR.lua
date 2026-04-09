local L = BigWigs:NewBossLocale("Belo'ren, Child of Al'ar", "koKR")
if not L then return end
if L then
	L.infused_quills = "레이저"
	L.voidlight_convergence = "색상 변경"
	L.light_void_dive = "빛/공허 바닥"
end

L = BigWigs:NewBossLocale("Midnight Falls", "koKR")
if L then
	L.deaths_dirge = "음표 게임"
	L.heavens_glaives = "칼날"
	L.heavens_lance = "찌르기"
	L.the_dark_archangel = "대천사"
	L.prism_kicks = "차단"
	L.dark_constellation = "별자리"
	L.dark_rune = "음표"
	L.dark_rune_bar = "음표 게임"

	L.starsplinter = "파열" -- Mythic intermission and P4 bar text
	L.starsplinter_you = "파열"

	L.left = "[왼] %s" -- left/west group bars in p3
	L.right = "[오] %s" -- right/east group bars in p3

	L.custom_off_select_limit_warnings = "신화 3단계 그룹"
	L.custom_off_select_limit_warnings_desc = "이 설정을 적용하면, 자신이 속한 스킬에 대한 경고만 표시됩니다."
	L.custom_off_select_limit_warnings_value1 = "서쪽/왼쪽"
	L.custom_off_select_limit_warnings_value2 = "동쪽/오른쪽"
end
