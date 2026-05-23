if not BigWigsAPI.IsLocale("zhTW") then return end
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
