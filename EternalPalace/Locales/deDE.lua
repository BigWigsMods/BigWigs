local L = BigWigs:NewBossLocale("Za'qul, Herald of Ny'alotha", "deDE")
if not L then return end
if L then
	L.stage3_early = "Za'qul reißt den Weg zum Reich des Deliriums auf!"  -- Yell is 14.5s before the actual cast start
end

L = BigWigs:NewBossLocale("Lady Ashvane", "deDE")
if L then
	L.linkText = "|T%d:15:15:0:0:64:64:4:60:4:60|t(%s+%s) "
end

L = BigWigs:NewBossLocale("Queen Azshara", "deDE")
if L then
	L[299249] = "Kugeln absorbieren"
	L[299251] = "Kugeln meiden"
	L[299254] = "Zusammenstehen"
	L[299255] = "Allein stehen"
	L[299252] = "Laufen"
	L[299253] = "Stehen"
	--L.hugSay = "HUG %s"
	--L.avoidSay = "AVOID %s"
	--L.yourDecree = "Decree: %s"
	--L.yourDecree2 = "Decree: %s & %s"
	L.hulk_killed = "%s getötet - %.1f Sek"
	L.fails_message = "%s (%d Sanktion Fehler-Stapel)"
	L.reversal = "Wendung"
	L.greater_reversal = "Große Wendung"
	L.you_die = "Du stirbst"
	L.you_die_message = "Du stirbst in %d Sek"

	--L.custom_off_repeating_decree_chat = "Repeating Decree Chat"
	--L.custom_off_repeating_decree_chat_desc = "Spam the words 'HUG me' in yell chat, or 'AVOID me' in say chat, while you have |cff71d5ff[Queen's Decree]|r. Maybe they'll help you if they see the chat bubble."
end
