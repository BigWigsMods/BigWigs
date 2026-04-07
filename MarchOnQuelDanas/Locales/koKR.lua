local L = BigWigs:NewBossLocale("Belo'ren, Child of Al'ar", "koKR")
if not L then return end
if L then
	L.infused_quills = "레이저"
	L.voidlight_convergence = "색상 변경"
	L.light_void_dive = "빛/공허 바닥"
end

L = BigWigs:NewBossLocale("Midnight Falls", "koKR")
if L then
	L.deaths_dirge = "음표"
	L.heavens_glaives = "칼날"
	L.heavens_lance = "찌르기"
	--L.the_dark_archangel = "Big Boom"
	--L.prism_kicks = "Kicks"
	--L.dark_constellation = "Stars"
	--L.dark_rune = "Memory Mark"
	--L.dark_rune_bar = "Solve the Game"

	--L.starsplinter = "Blazes" -- Mythic intermission and P4 bar text
	--L.starsplinter_you = "Blaze"

	--L.left = "[L] %s" -- left/west group bars in p3
	--L.right = "[R] %s" -- right/east group bars in p3

	--L.custom_off_select_limit_warnings = "Mythic Stage Three Group"
	--L.custom_off_select_limit_warnings_desc = "When set, only warnings for abilities on your side of the room will be shown."
	--L.custom_off_select_limit_warnings_value1 = "West/Left"
	--L.custom_off_select_limit_warnings_value2 = "East/Right"
end
