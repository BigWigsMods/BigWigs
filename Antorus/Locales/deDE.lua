local L = BigWigs:NewBossLocale("Argus the Unmaker", "deDE")
if not L then return end
if L then
	L.combinedBurstAndBomb = "Seelenexplosion und Seelenbombe zusammenfassen"
	L.combinedBurstAndBomb_desc = "|cff71d5ffSeelenbomben|r werden immer in Kombination mit |cff71d5ffSeelenexplosionen|r eingesetzt. Aktiviere dies Option, um diese 2 Nachrichten in einer zu vereinen."

	L.custom_off_always_show_combined = "Immer die zusammengefasste Nachricht für Seelenexplosion und Seelenbombe anzeigen."
	L.custom_off_always_show_combined_desc = "Die zusammengefasste Nachricht wird nicht angezeigt, wenn du die |cff71d5ffSeelenbombe|r oder die |cff71d5ffSeelenexplosion|r erhältst. Aktiviere diese Option, damit immer die zusammengefasste Nachricht angezeigt wird, selbst wenn du betroffen bist. |cff33ff99Nützlich für Schlachtzugsleiter.|r"

	L.fear_help = "Kombination Sargeras' Furcht"
	L.fear_help_desc = "Sage eine spezielle Nachricht, wenn du von |cff71d5ffSargeras' Furcht|r and |cff71d5ffSeelenseuche|r/|cff71d5ffSeelenexplosion|r/|cff71d5ffSeelenbombe|r/|cff71d5ffUrteil des Sargeras|r betroffen bist."

	L[257931] = "Furcht" -- short for Sargeras' Fear
	L[248396] = "Seuche" -- short for Soulblight
	L[251570] = "Bombe" -- short for Soulbomb
	L[250669] = "Explosion" -- short for Soulburst
	L[257966] = "Urteil" -- short for Sentence of Sargeras

	L.stage2_early = "Der Zorn der Ozeane soll diese Verderbnis fortspülen!"
	L.stage3_early = "Keine Hoffnung. Nur Schmerz. Nur Schmerz!"

	L.gifts = "Geschenke: %s (Himmel), %s (Meer)"
	L.burst = "|T1778229:15:15:0:0:64:64:4:60:4:60|tExplosion:%s" -- short for Soulburst
	L.bomb = "|T1778228:15:15:0:0:64:64:4:60:4:60|tBombe (%d):|T137002:0|t%s - " -- short for Soulbomb

	L.sky_say = "{rt5} Krit/Meist" -- short for Critical Strike/Mastery (stats)
	L.sea_say = "{rt6} Tempo/Viels" -- short for Haste/Versatility (stats)

	L.bomb_explosions = "Bombenexplosionen"
	L.bomb_explosions_desc = "Zeigt einen Timer für explodierende Seelenexplosion und Seelenbombe."
end

L = BigWigs:NewBossLocale("Aggramar", "deDE")
if L then
	L.wave_cleared = "Welle %d erledigt!" -- Wave 1 Cleared!

	L.track_ember = "Tracker Funke von Taeshalach"
	L.track_ember_desc = "Zeigt Nachrichten für jeden Tod einer Funke von Taeshalach an."

	L.custom_off_ember_marker_desc = "Markiert Funken von Taeshalach mit {rt1}{rt2}{rt3}{rt4}{rt5}, benötigt Schlachtzugsleiter oder Assistent.\n|cff33ff99Mythisch: Dies markiert nur Adds in der momentanen Welle bei mehr als 45 Energie.|r"
end

L = BigWigs:NewBossLocale("The Coven of Shivarra", "deDE")
if L then
	L.torment_of_the_titans_desc = "Die Shivarra zwingt die Titanenseelen dazu, ihre Fähigkeiten gegen die Spieler einzusetzen."

	L.timeLeft = "%.1fs" -- s = seconds
	L.torment = "Pein: %s"
	L.nextTorment = "Nächste Pein: |cffffffff%s|r"
	L.tormentHeal = "Heal/DoT" -- something like Heal/DoT (max 10 characters)
	L.tormentLightning = "Blitz" -- short for "Chain Lightning" (or similar, max 10 characters)
	L.tormentArmy = "Heer" -- short for "Spectral Army of Norgannon" (or similar, max 10 characters)
	L.tormentFlames = "Flammen" -- short for "Flames of Khaz'goroth" (or similar, max 10 characters)
end

L = BigWigs:NewBossLocale("Eonar the Life-Binder", "deDE")
if L then
	L.warp_in_desc = "Zeigt Timer und Nachrichten für jede Welle sowie spezielle Adds in der Welle an."

	L.top_lane = "Oben"
	L.mid_lane = "Mitte"
	L.bot_lane = "Unten"

	L.purifier = "Läuterer" -- Fel-Powered Purifier
	L.destructor = "Zerstörer" -- Fel-Infused Destructor
	L.obfuscator = "Verdunkler" -- Fel-Charged Obfuscator
	L.bats = "Teufelsfledermäuse"
end

L = BigWigs:NewBossLocale("Portal Keeper Hasabel", "deDE")
if L then
	L.custom_on_stop_timers = "Fähigkeitsleisten immer anzeigen"
	L.custom_on_stop_timers_desc = "Hasabel nutzt zufällig eine nicht abklingende Fähigkeit. Falls diese Option aktiviert ist, werden die Leisten für diese Fähigkeiten auf dem Bildschirm angezeigt."
	L.custom_on_filter_platforms = "Nebenplattform-Warnungen und -Leisten ausblenden"
	L.custom_on_filter_platforms_desc = "Entfernt unnötige Nachrichten und Leisten, wenn du nicht auf einer Nebenplattform bist. Es werden immer Leisten und Warnungen von der Hauptplattform: Nexus angezeigt."
	L.worldExplosion_desc = "Zeigt einen Timer für die Explosion der kollabierenden Welt."
	L.platform_active = "%s Aktiv!" -- Platform: Xoroth Active!
	L.add_killed = "%s getötet!"
	L.achiev = "'Voll Portal' achievement debuffs" -- Achievement 11928
end

L = BigWigs:NewBossLocale("Kin'garoth", "deDE")
if L then
	L.empowered = "(M) %s" -- (E) Ruiner, Deutsch: Mächtig
	L.gains = "Kin'garoth erhält %s" -- Kin'garoth gains Empowered Ruiner
end

L = BigWigs:NewBossLocale("Antoran High Command", "deDE")
if L then
	L.felshieldActivated = "Teufelsschild aktiviert von %s"
	L.felshieldUp = "Teufelsschild Aktiv"
end

L = BigWigs:NewBossLocale("Gorothi Worldbreaker", "deDE")
if L then
	L.cannon_ability_desc = "Zeigt Nachrichten und Balken bezüglich der 2 Kanonen auf dem Rücken des Weltenbrechers der Garothi an."

	L.missileImpact = "Vernichtung-Einschlag"
	L.missileImpact_desc = "Zeigt einen Timer für einschlagende Vernichtungsgeschosse."

	L.decimationImpact = "Dezimierung-Einschlag"
	L.decimationImpact_desc = "Zeigt einen Timer für einschlagende Dezimierungsgeschosse."
end

L = BigWigs:NewBossLocale("Antorus Trash", "deDE")
if L then
	-- [[ Before Garothi Worldbreaker ]] --
	L.felguard = "Antorische Teufelswache"

	-- [[ After Garothi Worldbreaker ]] --
	L.flameweaver = "Flammenwirker"

	-- [[ Before Antoran High Command ]] --
	L.ravager = "Klingenverschriebener Verheerer"
	L.deconix = "Imperator Deconix"
	L.clobex = "Clobex"

	-- [[ Before Portal Keeper Hasabel ]] --
	L.stalker = "Hungernder Pirscher"

	-- [[ Before Varimathras / Coven of Shivarra ]] --
	L.tarneth = "Tarneth"
	L.priestess = "Priesterin des Deliriums"

	-- [[ Before Aggramar ]] --
	L.aedis = "Dunkler Hüter Aedis"
end
