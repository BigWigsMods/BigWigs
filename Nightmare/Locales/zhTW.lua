local L = BigWigs:NewBossLocale("Cenarius", "zhTW")
if not L then return end
if L then
	L.forces = "夢魘大軍"
	L.bramblesSay = "荊棘在%s附近"
	L.custom_off_multiple_breath_bar = "顯示多重腐臭之息計時條"
	L.custom_off_multiple_breath_bar_desc = "預設 BigWigs 只顯示一條腐化飛龍的腐臭之息。啟用此選項將可以看到每條腐化飛龍的腐臭之息。"
end

L = BigWigs:NewBossLocale("Elerethe Renferal", "zhTW")
if L then
	L.isLinkedWith = ">%s< 與 >%s< 相連"
	L.yourLink = ">你< 與 >%s< 相連"
	L.yourLinkShort = "與 >%s< 相連"
end

L = BigWigs:NewBossLocale("Il'gynoth", "zhTW")
if L then
	L.remaining = "剩餘"
	L.missed = "缺少"
end

L = BigWigs:NewBossLocale("Emerald Nightmare Trash", "zhTW")
if L then
	L.gelatinizedDecay = "膠化腐泥怪"
	L.befouler = "腐化玷污者"
	L.shaman = "兇暴薩滿"
end

L = BigWigs:NewBossLocale("Ursoc", "zhTW")
if L then
	L.custom_on_gaze_assist = "專注凝視助手"
	L.custom_on_gaze_assist_desc = "在計時條和訊息顯示專注凝視團隊標記。使用 {rt4} 標記奇數輪， {rt6} 標記偶數輪，需要權限。"
end

L = BigWigs:NewBossLocale("Xavius", "zhTW")
if L then
	L.linked = ">你< 恐懼束縛！- 與 >%s< 相連！"
	L.dreamHealers = "夢境治療者"
end
