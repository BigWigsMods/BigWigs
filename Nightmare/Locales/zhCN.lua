local L = BigWigs:NewBossLocale("Cenarius", "zhCN")
if not L then return end
if L then
	L.forces = "梦魇大军"
	L.bramblesSay = ">%s< 附近荆棘"
	L.custom_off_multiple_breath_bar = "显示多重腐败之息计时条"
	L.custom_off_multiple_breath_bar_desc = "默认 BigWigs 将只显示一条幼龙的腐败之息。启用此选项将看到每条幼龙的腐败之息。"
end

L = BigWigs:NewBossLocale("Elerethe Renferal", "zhCN")
if L then
	L.isLinkedWith = ">%s< 与 >%s< 相连"
	L.yourLink = ">你< 与 >%s< 相连"
	L.yourLinkShort = "与 >%s< 相连"
end

L = BigWigs:NewBossLocale("Il'gynoth", "zhCN")
if L then
	L.remaining = "剩余"
	L.missed = "缺少"
end

L = BigWigs:NewBossLocale("Emerald Nightmare Trash", "zhCN")
if L then
	L.gelatinizedDecay = "腐朽软泥怪"
	L.befouler = "污心腐蚀者"
	L.shaman = "可怕的萨满"
end

L = BigWigs:NewBossLocale("Ursoc", "zhCN")
if L then
	L.custom_on_gaze_assist = "专注凝视助手"
	L.custom_on_gaze_assist_desc = "在计时条和信息显示专注凝视团队标记。使用 {rt4} 标记奇数轮，{rt6} 标记偶数轮。需要权限。"
end

L = BigWigs:NewBossLocale("Xavius", "zhCN")
if L then
	L.linked = ">你< 恐惧连结！- 与 >%s< 相连！"
	L.dreamHealers = "梦境治疗者"
end
