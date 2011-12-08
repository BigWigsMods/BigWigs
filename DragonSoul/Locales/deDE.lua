local L = BigWigs:NewBossLocale("Morchok", "deDE")
if not L then return end
if L then
	L.engage_trigger = "You seek to halt an avalanche. I will bury you."

	L.crush = "Rüstung zerschmettern"
	L.crush_desc = "Nur für Tanks. Zählt die Stapel von Rüstung zerschmettern und zeigt eine Timerleiste an."
	L.crush_message = "%2$dx Rüstung zerschmettern auf %1$s"

	L.blood = "Blut"

	L.explosion = "Explosion"
end

L = BigWigs:NewBossLocale("Warlord Zon'ozz", "deDE")
if L then
	L.engage_trigger = "Zzof Shuul'wah. Thoq fssh N'Zoth!"

	L.ball = "Leere der Apokalypse"
	L.ball_desc = "Leere der Apokalypse, welche von den Spielern und abprallt und den Boss schwächt."

	L.bounce = "Abprallen der Leerenkugel"
	L.bounce_desc = "Zählt, wie häufig die Leerenkugel abprallt."

	L.darkness = "Tentakel Disco Party!"
	L.darkness_desc = "Diese Phase beginnt, sobald die Leerenkugel auf den Boss trifft."

	L.shadows = "Schatten"
end

L = BigWigs:NewBossLocale("Yor'sahj the Unsleeping", "deDE")
if L then
	L.engage_trigger = "Iilth qi'uothk shn'ma yeh'glu Shath'Yar! H'IWN IILTH!"

	L.bolt_desc = "Nur für Tanks. Zählt die Stapel von Leerenblitz und zeigt eine Timerleiste an."
	L.bolt_message = "%2$dx Blitz auf %1$s"

	L.blue = "|cFF0080FFBlau|r"
	L.green = "|cFF088A08Grünn|r"
	L.purple = "|cFF9932CDViolett|r"
	L.yellow = "|cFFFFA901Gelb|r"
	L.black = "|cFF424242Schwarz|r"
	L.red = "|cFFFF0404Rot|r"

	L.blobs = "Kugeln"
	L.blobs_bar = "Nächste Kugeln"
	L.blobs_desc = "Die Kugeln spawnen und bewegen sich auf den Boss zu"
end

L = BigWigs:NewBossLocale("Hagara the Stormbinder", "deDE")
if L then
	L.engage_trigger = "You cross the Stormbinder! I'll slaughter you all."

	L.lightning_or_frost = "Blitz oder Frost"
	L.ice_next = "Eisphase"
	L.lightning_next = "Blitzphase"

	L.nextphase = "Nächste Phase"
	L.nextphase_desc = "Warnungen für die nächste Phase"
end

L = BigWigs:NewBossLocale("Ultraxion", "deDE")
if L then
	L.engage_trigger = "Now is the hour of twilight!"

	L.warmup = "Warmup"
	L.warmup_desc = "Zeit bis zum Starten des Bosskampfes."
	L.warmup_trigger = "I am the beginning of the end...the shadow which blots out the sun"

	L.crystal = "Buff-Kristalle"
	L.crystal_desc = "Zeigt Timer für die verschiedenen Buff-Kristalle der NPCs an."
	L.crystal_red = "Roter Kristall"
	L.crystal_green = "Grüner Kristall"
	L.crystal_blue = "Blauer Kristall"

	L.twilight = "Zwielicht"
	L.cast = "Zwielicht Zauberleiste"
	L.cast_desc = "Zeigt eine 5 sekündige Leiste, wenn Stunde des Zwielichts gewirkt wird."

	L.lightyou = "Schwindendes Licht auf Dir"
	L.lightyou_desc = "Zeigt eine Leiste mit der verbleibenden Zeit, bis schwindendes Licht Dich explodieren lässt."
	L.lightyou_bar = "<Du Explodierst>"
end

L = BigWigs:NewBossLocale("Warmaster Blackhorn", "deDE")
if L then
	L.harpooning = "Harpooning"

	L.rush = "Klingenansturm"

	L.sunder = "Rüstung zerreißen"
	L.sunder_desc = "Nur für Tanks. Zählt die Stapel von Rüstung zerreißen und zeigt eine Timerleiste an."
	L.sunder_message = "%2$dx Rüstung zerreißen auf %1$s"

	L.sapper_trigger = "A drake swoops down to drop a Twilight Sapper onto the deck!"
	L.sapper = "Pionier"
	L.sapper_desc = "Der Pionier (Schurke) spawnt und fügt dem Schiff Schaden zu."
end

L = BigWigs:NewBossLocale("Spine of Deathwing", "deDE")
if L then
	L.left_start = "rollt bald nach links"
	L.right_start = "rollt bald nach rechts"
	L.left = "Rolle nach links"
	L.right = "Rolle nach rechts"
	L.not_hooked = "DU bist >NICHT< befestigt!"
	L.roll_message = "Er rollt, rollt, rollt!"
	L.level_trigger = "beruhigt sich"
	L.level_message = "Wieder ausgeglichen!"

	L.exposed = "Rüstung freigelegt"
end

L = BigWigs:NewBossLocale("Madness of Deathwing", "deDE")
if L then
	L.impale_desc = "Nur für Tanks. "..select(2,EJ_GetSectionInfo(4114))
end

