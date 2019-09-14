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
	L[299249] = "吃球"
	L[299251] = "躲球"
	L[299254] = "集合"
	L[299255] = "躲人"
	L[299252] = "移動"
	L[299253] = "別動"
	L.hugSay = "靠近%s"
	L.hugNoMoveSay = "靠近%s，我不能動"
	L.avoidSay = "避開%s"
	L.yourDecree = "赦令：%s"
	L.yourDecree2 = "赦令：%s和%s"
	L.hulk_killed = "擊殺%s，用時%.1f秒"
	L.fails_message = "%s（%d制裁堆疊失誤）"
	L.reversal = "命運逆轉"
	L.greater_reversal = "強效命運逆轉"
	L.you_die = "你將死亡"
	L.you_die_message = "你將在%d秒後死亡"

	L.custom_off_repeating_decree_chat = "重覆赦令喊話"
	L.custom_off_repeating_decree_chat_desc = "當你中了|cff71d5ff[女王赦令]|r時重覆喊話「靠近我」、「避開我」，也許其他人看到聊天氣泡後會幫助你應對赦令。"
end
