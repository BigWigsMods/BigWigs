local L = BigWigs:NewBossLocale("Za'qul, Herald of Ny'alotha", "zhTW")
if not L then return end
if L then
	L.stage3_early = "札奎爾撕開了一條通往狂亂領域的通道！"  -- Yell is 14.5s before the actual cast start
end

L = BigWigs:NewBossLocale("Lady Ashvane", "zhTW")
if L then
	L.linkText = "|T%d:15:15:0:0:64:64:4:60:4:60|t（%s+%s） "
end

L = BigWigs:NewBossLocale("Queen Azshara", "zhTW")
if L then
	L[299249] = "%s（吃球）"
	L[299251] = "%s（躲球）"
	L[299254] = "%s（抱團）"
	L[299255] = "%s（躲人）"
	L[299252] = "%s（移動）"
	L[299253] = "%s（別動）"
	L.hulk_killed = "%s擊殺，用時%.1f秒"
	L.fails_message = "%s（%d制裁堆疊失誤）"
	L.reversal = "命運逆轉"
	L.greater_reversal = "強效命運逆轉"
	L.you_die = "你將死亡"
	L.you_die_message = "你將在%s秒後死亡"
end
