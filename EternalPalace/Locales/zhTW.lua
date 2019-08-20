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
	--L.hugSay = "HUG %s"
	--L.avoidSay = "AVOID %s"
	--L.yourDecree = "Decree: %s"
	--L.yourDecree2 = "Decree: %s & %s"
	L.hulk_killed = "%s擊殺，用時%.1f秒"
	L.fails_message = "%s（%d制裁堆疊失誤）"
	L.reversal = "命運逆轉"
	L.greater_reversal = "強效命運逆轉"
	L.you_die = "你將死亡"
	L.you_die_message = "你將在%d秒後死亡"

	--L.custom_off_repeating_decree_chat = "Repeating Decree Chat"
	--L.custom_off_repeating_decree_chat_desc = "Spam the words 'HUG me' in yell chat, or 'AVOID me' in say chat, while you have |cff71d5ff[Queen's Decree]|r. Maybe they'll help you if they see the chat bubble."
end
