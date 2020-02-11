local L = BigWigs:NewBossLocale("Razorgore the Untamed", "deDE")
if not L then return end
if L then
	L.start_trigger = "Eindringlinge sind in die"
	L.start_message = "Razorgore angegriffen!"
	L.start_soon = "Mob Spawn in 5sec!"
	L.start_mob = "Mob Spawn"

	L.eggs = "Eier nicht zählen"
	L.eggs_desc = "Die zerstörten Eier nicht zählen."
	L.eggs_message = "%d/30 Eier zerstört!"

	L.phase2_message = "Alle Eier zerstört!"
end

L = BigWigs:NewBossLocale("Chromaggus", "deDE")
if L then
	L.breath = "Atem"
	L.breath_desc = "Warnung, wenn Chromaggus seinen Atem wirkt."

	--L.debuffs_message = "3/5 debuffs, carefull!"
	--L.debuffs_warning = "4/5 debuffs, %s on 5th!"
end

L = BigWigs:NewBossLocale("Nefarian ", "deDE")
if L then
	L.landing_soon_trigger = "Sehr gut, meine Diener"
	L.landing_trigger = "BRENNT! Ihr Elenden!"
	L.zerg_trigger = "Unmöglich! Erhebt euch"

	L.triggershamans = "Schamane, zeigt mir was"
	L.triggerwarlock = "Hexenmeister, Ihr solltet nicht mit Magie"
	L.triggerhunter = "Jäger und ihre lästigen"
	L.triggermage = "Auch Magier%? Ihr solltet vorsichtiger"
	L.triggerdeathknight = "Todesritter"
	--L.triggermonk = "Monks"

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
	--L.warndeathknight = "Death Knights - Death Grip"
	--L.warnmonk = "Monks - Stuck Rolling"
	--L.warndemonhunter = "Demon Hunters - Blinded"

	L.classcall_bar = "Klassenruf"

	L.classcall = "Klassenruf"
	L.classcall_desc = "Warnung vor Klassenrufen."

	L.otherwarn = "Anderes"
	L.otherwarn_desc = "Warnung, wenn Nefarian landet und seine Diener ruft."
end

