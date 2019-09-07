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
	L.hugSay = "靠近 %s"
	--L.hugNoMoveSay = "HUG %s, I can't move"
	L.avoidSay = "远离 %s"
	L.yourDecree = "法令：%s"
	L.yourDecree2 = "法令：%s 和 %s"
	L.hulk_killed = "%s已击杀 - %.1f秒"
	L.fails_message = "%s（%d制裁堆叠失误）"
	L.reversal = "命运逆转"
	L.greater_reversal = "强力命运逆转"
	L.you_die = "你将死亡"
	L.you_die_message = "你将在%d秒后死亡"

	L.custom_off_repeating_decree_chat = "反复法令到聊天"
	L.custom_off_repeating_decree_chat_desc = "反复发送“靠近我”“远离我”文字到聊天，直到你有|cff71d5ff[女王法令]|r。如果他们看到聊天泡泡也许会帮助你。"
end
