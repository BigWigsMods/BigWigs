local L = BigWigs:NewBossLocale("Za'qul, Herald of Ny'alotha", "ruRU")
if not L then return end
if L then
	--L.stage3_early = "Za'qul tears open the pathway to Delirium Realm!"  -- Yell is 14.5s before the actual cast start
end

L = BigWigs:NewBossLocale("Lady Ashvane", "ruRU")
if L then
	L.linkText = "|T%d:15:15:0:0:64:64:4:60:4:60|t(%s+%s) "
end

L = BigWigs:NewBossLocale("Queen Azshara", "ruRU")
if L then
	--L[299249] = "%s (Soak Orbs)"
	--L[299251] = "%s (Avoid Orbs)"
	--L[299254] = "%s (Hug Others)"
	--L[299255] = "%s (Avoid Everyone)"
	--L[299252] = "%s (Keep Moving)"
	--L[299253] = "%s (Stand Still)"
	--L.hulk_killed = "%s killed - %.1f sec"
	--L.fails_message = "%s (%d Sanction stack fails)"
	--L.reversal = "Reversal"
	--L.greater_reversal = "Reversal (Greater)"
	--L.you_die = "You die"
	--L.you_die_message = "You will die in %d sec"
end
