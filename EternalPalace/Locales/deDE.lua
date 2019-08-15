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
	L[299249] = "%s (Kugeln absorbieren)"
	L[299251] = "%s (Kugeln meiden)"
	L[299254] = "%s (Zusammenstehen)"
	L[299255] = "%s (Allein stehen)"
	L[299252] = "%s (Laufen)"
	L[299253] = "%s (Stehen)"
	L.hulk_killed = "%s getötet - %.1f Sek"
	L.fails_message = "%s (%d Sanktion Fehler-Stapel)"
	L.reversal = "Wendung"
	L.greater_reversal = "Große Wendung"
	L.you_die = "Du stirbst"
	L.you_die_message = "Du stirbst in %d Sek"
end
