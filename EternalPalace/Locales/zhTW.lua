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
	L[299249] = "%s (吸收球)"
	L[299251] = "%s (避開球)"
	L[299254] = "%s (蹭隊友)"
	L[299255] = "%s (單獨散開)"
	L[299252] = "%s (保持移動)"
	L[299253] = "%s (不要動)"
	L.hulk_killed = "%s 已擊殺 - %.1f 秒"
	L.fails_message = "%s (%d 制裁堆疊失敗)"
	L.reversal = "反轉"
	L.greater_reversal = "反轉 (強力)"
	L.you_die = "你死定了"
end
