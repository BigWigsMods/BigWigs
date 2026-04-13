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

	--L.custom_select_limit_warnings = "[Mythic] Restrict Stage 3 Warnings"
	--L.custom_select_limit_warnings_desc = "Only show warnings for abilities on your side."
	--L.custom_select_limit_warnings_value1 = "Groups 1 & 2 go left, groups 3 & 4 go right."
	--L.custom_select_limit_warnings_value2 = "Odd groups left, even groups right."
	--L.custom_select_limit_warnings_value3 = "Show warnings for both sides."
end
