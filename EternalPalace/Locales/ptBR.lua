local L = BigWigs:NewBossLocale("Za'qul, Herald of Ny'alotha", "ptBR")
if not L then return end
if L then
	--L.stage3_early = "Za'qul tears open the pathway to Delirium Realm!"  -- Yell is 14.5s before the actual cast start
end

L = BigWigs:NewBossLocale("Lady Ashvane", "ptBR")
if L then
	L.linkText = "|T%d:15:15:0:0:64:64:4:60:4:60|t(%s+%s) "
end

L = BigWigs:NewBossLocale("Queen Azshara", "ptBR")
if L then
	--L[299249] = "SOAK Orbs"
	--L[299251] = "AVOID Orbs"
	--L[299254] = "HUG Others"
	--L[299255] = "Stand ALONE"
	--L[299252] = "Keep MOVING"
	--L[299253] = "Stand STILL"
	--L.hugSay = "HUG %s"
	--L.avoidSay = "AVOID %s"
	--L.yourDecree = "Decree: %s"
	--L.yourDecree2 = "Decree: %s & %s"
	--L.hulk_killed = "%s killed - %.1f sec"
	--L.fails_message = "%s (%d Sanction stack fails)"
	--L.reversal = "Reversal"
	--L.greater_reversal = "Reversal (Greater)"
	--L.you_die = "You die"
	--L.you_die_message = "You will die in %d sec"

	--L.custom_off_repeating_decree_chat = "Repeating Decree Chat"
	--L.custom_off_repeating_decree_chat_desc = "Spam the words 'HUG me' in yell chat, or 'AVOID me' in say chat, while you have |cff71d5ff[Queen's Decree]|r. Maybe they'll help you if they see the chat bubble."
end
