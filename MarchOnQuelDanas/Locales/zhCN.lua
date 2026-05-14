if not BigWigsAPI.IsLocale("zhCN") then return end
BigWigsAPI.SetBossModuleLocale("Belo'ren, Child of Al'ar", {
	infused_quills = "注能飞羽",
	voidlight_convergence = "颜色转换",
	light_void_dive = "圣光/虚空俯冲",
})

BigWigsAPI.SetBossModuleLocale("Midnight Falls", {
	deaths_dirge = "记忆游戏",
	heavens_glaives = "战刃",
	heavens_lance = "天穹枪",
	the_dark_archangel = "大爆炸",
	prism_kicks = "打断",
	dark_constellation = "星座",
	dark_rune_bar = "解密",

	left = "[左] %s", -- left/west group bars in p3
	right = "[右] %s", -- right/east group bars in p3

	custom_select_limit_warnings = "[史诗] 限制第3阶段警报",
	custom_select_limit_warnings_desc = "仅显示你所在半场的技能警报。",
	custom_select_limit_warnings_value1 = "1、2组去左面，3、4组去右面。",
	custom_select_limit_warnings_value2 = "奇数组去左面，偶数组去右面。",
	custom_select_limit_warnings_value3 = "显示两面的所有警报。",
	custom_select_limit_warnings_value4 = "仅显示左面警报。",
	custom_select_limit_warnings_value5 = "仅显示右面警报。",

	dark_quasar_stage1_note = "仅限第1阶段",
	dark_quasar_intermission_note = "仅限转阶段",
})
