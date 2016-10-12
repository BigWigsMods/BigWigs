local L = BigWigs:NewBossLocale("Cenarius", "zhCN")
if not L then return end
if L then
	L.forces = "梦魇大军"
	L.bramblesSay = ">%s< 附近荆棘"
	--L.custom_off_multiple_breath_bar = "Show multiple Rotten Breath bars"
	--L.custom_off_multiple_breath_bar_desc = "Per default BigWigs will only show the Rotten Breath bar of one drake. Enable this option if you want to see the timer for each drake."
end

L = BigWigs:NewBossLocale("Elerethe Renferal", "zhCN")
if L then
	L.isLinkedWith = ">%s< 与 >%s< 相连"
	L.yourLink = ">你< 与 >%s< 相连"
	L.yourLinkShort = "与 >%s< 相连"
end

L = BigWigs:NewBossLocale("Il'gynoth", "zhCN")
if L then
	L.custom_off_deathglare_marker = "死光触须标记"
	L.custom_off_deathglare_marker_desc = "使用 {rt6}{rt5}{rt4}{rt3} 标记死光触须，需要权限。\n|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突。|r\n|cFFADFF2F提示：如果团队选择你打开此选项，鼠标快速指向死光触须是标记他们的最快方式。|r"

	L.bloods_remaining = ">%d< 脓液剩余"
end

L = BigWigs:NewBossLocale("Emerald Nightmare Trash", "zhCN")
if L then
	L.gelatinizedDecay = "胶状腐烂"
	--L.befouler = "Taintheart Befouler"
	--L.shaman = "Dire Shaman"
	--L.custom_on_mark_totem = "Mark the Totems"
	--L.custom_on_mark_totem_desc = "Mark the Totems with {rt8}{rt7}, requires promoted or leader."
end

L = BigWigs:NewBossLocale("Ursoc", "zhCN")
if L then
	L.custom_off_gaze_assist = "专注凝视助手"
	L.custom_off_gaze_assist_desc = "在计时条和信息显示专注凝视团队标记。使用 {rt4} 和 {rt6} 分别标记。需要权限。"
end

L = BigWigs:NewBossLocale("Xavius", "zhCN")
if L then
	L.custom_off_blade_marker = "梦魇之刃标记"
	L.custom_off_blade_marker_desc = "使用 {rt1}{rt2} 标记梦魇之刃的目标，需要权限。"

	L.linked = ">你< 恐惧连结！- 与 >%s< 相连！"
end
