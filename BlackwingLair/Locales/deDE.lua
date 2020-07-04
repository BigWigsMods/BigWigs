local L = BigWigs:NewBossLocale("Razorgore the Untamed", "deDE")
if not L then return end
if L then
	L.bossName = "Feuerkralle der Ungezähmte"

	L.start_trigger = "Eindringlinge sind in die"
	L.start_message = "Razorgore angegriffen!"
	L.start_soon = "Mob Spawn in 5sec!"
	L.start_mob = "Mob Spawn"

	L.eggs = "Eier nicht zählen"
	L.eggs_desc = "Die zerstörten Eier nicht zählen."
	L.eggs_message = "%d/30 Eier zerstört!"

	L.phase2_message = "Alle Eier zerstört!"
end

L = BigWigs:NewBossLocale("Vaelastrasz the Corrupt", "deDE")
if L then
	L.bossName = "Vaelastrasz der Verdorbene"

	-- L.warmup_trigger = "Too late, friends!"
	-- L.warmup_message = "RP started, engaging in ~43s"
end

L = BigWigs:NewBossLocale("Broodlord Lashlayer", "deDE")
if L then
	L.bossName = "Brutwächter Dreschbringer"
end

L = BigWigs:NewBossLocale("Firemaw", "deDE")
if L then
	L.bossName = "Feuerschwinge"
end

L = BigWigs:NewBossLocale("Ebonroc", "deDE")
if L then
	L.bossName = "Schattenschwinge"
end

L = BigWigs:NewBossLocale("Flamegor", "deDE")
if L then
	L.bossName = "Flammenmaul"
end

L = BigWigs:NewBossLocale("Chromaggus", "deDE")
if L then
	L.bossName = "Chromaggus"

	L.breath = "Atem"
	L.breath_desc = "Warnung, wenn Chromaggus seinen Atem wirkt."

	-- L.debuffs_message = "3/5 debuffs, carefull!"
	-- L.debuffs_warning = "4/5 debuffs, %s on 5th!"
end

L = BigWigs:NewBossLocale("NefarianBWL", "deDE")
if L then
	L.bossName = "Nefarian"

	L.landing_soon_trigger = "Sehr gut, meine Diener"
	L.landing_trigger = "BRENNT! Ihr Elenden!"
	L.zerg_trigger = "Unmöglich! Erhebt euch"

	L.triggershamans = "Schamane, zeigt mir was"
	L.triggerwarlock = "Hexenmeister, Ihr solltet nicht mit Magie"
	L.triggerhunter = "Jäger und ihre lästigen"
	L.triggermage = "Auch Magier%? Ihr solltet vorsichtiger"

	L.landing_soon_warning = "Nefarian landet in 10 Sekunden!"
	L.landing_warning = "Nefarian ist gelandet!"
	L.zerg_warning = "Diener herbeigerufen!"
	L.classcall_warning = "Klassenruf in Kürze!"

	L.warnshaman = "Schamanen - Totems!"
	L.warndruid = "Druiden - Gefangen in Katzenform!"
	L.warnwarlock = "Hexenmeister - Höllenbestien herbeigerufen!"
	L.warnpriest = "Priester - Heilung schadet!"
	L.warnhunter = "Jäger - Angelegte Fernkampfwaffen defekt!"
	L.warnwarrior = "Krieger - Gefangen in Berserkerhaltung!"
	L.warnrogue = "Schurken - Teleportiert und festgewurzelt!"
	L.warnpaladin = "Paladine - Segen des Schutzes!"
	L.warnmage = "Magier - Verwandlung!"

	L.classcall_bar = "Klassenruf"

	L.classcall = "Klassenruf"
	L.classcall_desc = "Warnung vor Klassenrufen."

	L.otherwarn = "Anderes"
	L.otherwarn_desc = "Warnung, wenn Nefarian landet und seine Diener ruft."

	-- L.add = "Drakonid deaths"
	-- L.add_desc = "Announce the number of adds killed in Phase 1 before Nefarian lands."
end

