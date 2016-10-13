local L = BigWigs:NewBossLocale("Cenarius", "zhTW")
if not L then return end
if L then
	L.forces = "夢魘大軍"
	L.bramblesSay = "荊棘在%s附近"
	--L.custom_off_multiple_breath_bar = "Show multiple Rotten Breath bars"
	--L.custom_off_multiple_breath_bar_desc = "Per default BigWigs will only show the Rotten Breath bar of one drake. Enable this option if you want to see the timer for each drake."
end

L = BigWigs:NewBossLocale("Elerethe Renferal", "zhTW")
if L then
	L.isLinkedWith = ">%s< 與 >%s< 相連"
	L.yourLink = ">你< 與 >%s< 相連"
	L.yourLinkShort = "與 >%s< 相連"
end

L = BigWigs:NewBossLocale("Il'gynoth", "zhTW")
if L then
	L.custom_off_deathglare_marker = "死凝觸手標記"
	L.custom_off_deathglare_marker_desc = "使用 {rt6}{rt5}{rt4}{rt3} 標記死凝觸手，需要權限。\n|cFFFF0000團隊中只需一名玩家啟用此選項以防止衝突。|r\n|cFFADFF2F提示：如果團隊選擇由你開啟此選項，開啟姓名板並滑鼠指向來標記死凝觸手是最快的方式。|r"

	L.bloods_remaining = "還需要%d個黏液"
end

L = BigWigs:NewBossLocale("Emerald Nightmare Trash", "zhTW")
if L then
	L.gelatinizedDecay = "膠化腐泥怪"
	L.befouler = "腐化玷污者"
	L.shaman = "兇暴薩滿"
	--L.custom_on_mark_totem = "Mark the Totems"
	--L.custom_on_mark_totem_desc = "Mark the Totems with {rt8}{rt7}, requires promoted or leader."
end

L = BigWigs:NewBossLocale("Ursoc", "zhTW")
if L then
	L.custom_on_gaze_assist = "專注凝視助手"
	L.custom_on_gaze_assist_desc = "在計時條和訊息顯示專注凝視團隊標記。使用 {rt4} 標記奇數輪， {rt6} 標記偶數輪，需要權限。"
end

L = BigWigs:NewBossLocale("Xavius", "zhTW")
if L then
	L.custom_off_blade_marker = "夢魘之刃標記"
	L.custom_off_blade_marker_desc = "使用 {rt1}{rt2} 標記夢魘之刃的目標，需要權限。"

	L.linked = ">你< 恐懼束縛！- 與 >%s< 相連！"
end
