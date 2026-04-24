local L = BigWigs:NewBossLocale("Belo'ren, Child of Al'ar", "zhTW")
if not L then return end
if L then
	L.infused_quills = "擋線"
	L.voidlight_convergence = "換色"
	L.light_void_dive = "俯衝"
end

L = BigWigs:NewBossLocale("Midnight Falls", "zhTW")
if L then
	L.deaths_dirge = "記憶遊戲"
	L.heavens_glaives = "戰刃"
	L.heavens_lance = "長槍"
	L.the_dark_archangel = "大爆炸"
	L.prism_kicks = "打斷"
	L.dark_constellation = "星宿"
	L.dark_rune = "記住符文"
	L.dark_rune_bar = "排列符文" -- 解密、玩游戲、把符文按順續排列

	L.starsplinter = "星辰破片" -- Mythic intermission and P4 bar text
	L.starsplinter_you = "星辰破片"

	L.left = "左：%s" -- left/west group bars in p3
	L.right = "右：%s" -- right/east group bars in p3

	L.custom_select_limit_warnings = "傳奇模式：第三階段警報限制"
	L.custom_select_limit_warnings_desc = "只顯示你這一側的技能警報。"
	L.custom_select_limit_warnings_value1 = "一二隊往左，三四隊往右。"
	L.custom_select_limit_warnings_value2 = "奇數隊往左，偶數隊往右。"
	L.custom_select_limit_warnings_value3 = "顯示雙側警報。"
	L.custom_select_limit_warnings_value4 = "只顯示左側警報。"
	L.custom_select_limit_warnings_value5 = "只顯示右側警報。"
end
