local L = BigWigs:NewBossLocale("Belo'ren, Child of Al'ar", "zhCN")
if not L then return end
if L then
	L.infused_quills = "注能飞羽"
	L.voidlight_convergence = "颜色转换"
	L.light_void_dive = "圣光/虚空俯冲"
end

L = BigWigs:NewBossLocale("Midnight Falls", "zhCN")
if L then
	L.deaths_dirge = "记忆游戏"
	L.heavens_glaives = "战刃"
	L.heavens_lance = "天穹枪"
	L.the_dark_archangel = "大爆炸"
	L.prism_kicks = "打断"
	L.dark_constellation = "星座"
	L.dark_rune = "记忆符号"
	L.dark_rune_bar = "解密"

	L.starsplinter = "星辰裂片" -- Mythic intermission and P4 bar text
	L.starsplinter_you = "星辰裂片"

	L.left = "[左] %s" -- left/west group bars in p3
	L.right = "[右] %s" -- right/east group bars in p3

	L.custom_select_limit_warnings = "[史诗] 限制第3阶段警报"
	L.custom_select_limit_warnings_desc = "仅显示你所在半场的技能警报。"
	L.custom_select_limit_warnings_value1 = "1、2组去左面，3、4组去右面。"
	L.custom_select_limit_warnings_value2 = "奇数组去左面，偶数组去右面。"
	L.custom_select_limit_warnings_value3 = "显示两面的所有警报。"
	L.custom_select_limit_warnings_value4 = "仅显示左面警报。"
	L.custom_select_limit_warnings_value5 = "仅显示右面警报。"
end
