local L = BigWigs:NewBossLocale("Za'qul, Herald of Ny'alotha", "zhCN")
if not L then return end
if L then
	L.stage3_early = "扎库尔撕开了通往谵妄领域的通路！"  -- Yell is 14.5s before the actual cast start
end

L = BigWigs:NewBossLocale("Lady Ashvane", "zhCN")
if L then
	L.linkText = "|T%d:15:15:0:0:64:64:4:60:4:60|t（%s+%s） "
end

L = BigWigs:NewBossLocale("Queen Azshara", "zhCN")
if L then
	L[299249] = "吸收宝珠"
	L[299251] = "远离宝珠"
	L[299254] = "集合"
	L[299255] = "远离人群"
	L[299252] = "保持移动"
	L[299253] = "站定不动"
	--L.hugSay = "HUG %s"
	--L.avoidSay = "AVOID %s"
	--L.yourDecree = "Decree: %s"
	--L.yourDecree2 = "Decree: %s & %s"
	L.hulk_killed = "%s已击杀 - %.1f秒"
	L.fails_message = "%s（%d制裁堆叠失误）"
	L.reversal = "命运逆转"
	L.greater_reversal = "强力命运逆转"
	L.you_die = "你将死亡"
	L.you_die_message = "你将在%d秒后死亡"

	--L.custom_off_repeating_decree_chat = "Repeating Decree Chat"
	--L.custom_off_repeating_decree_chat_desc = "Spam the words 'HUG me' in yell chat, or 'AVOID me' in say chat, while you have |cff71d5ff[Queen's Decree]|r. Maybe they'll help you if they see the chat bubble."
end
