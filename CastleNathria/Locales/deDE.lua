local L = BigWigs:NewBossLocale("Shriekwing", "deDE")
if not L then return end
if L then
	L.pickup_lantern = "%s hat die Laterne aufgenommen!"
	L.dropped_lantern = "Laterne fallengelassen von %s!"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "deDE")
if L then
	 L.killed = "%s getötet"
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "deDE")
if L then
	L.stage2_yell = "Die Vorfreude auf dieses Relikt bringt mich fast um! Aber wahrscheinlich tötet es eher Euch."
	L.stage3_yell = "Hoffentlich ist dieser wundersame Gegenstand so tödlich, wie er aussieht!"
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "deDE")
if L then
	-- L.times = "%dx %s"

	L.level = "%s (Stufe |cffffff00%d|r)"
	L.full = "%s (|cffff0000VOLL|r)"

	L.container_active = "Behälter aktivieren: %s"

	L.anima_adds = "Konzentrierte Anima Adds"
	L.anima_adds_desc = "Zeigt einen Timer für die erscheinenden Adds vom Debuff Konzentrierte Anima."

	L.custom_off_experimental = "Experimentelle Funktionen aktivieren"
	L.custom_off_experimental_desc = "Diese Funktionen wurden |cffff0000nicht getestet|r und können |cffff0000spammen|r."

	L.anima_tracking = "Anima Verfolgung |cffff0000(Experimentell)|r"
	L.anima_tracking_desc = "Nachrichten und Leisten zur Verfolgung der Anima-Level in den Behältern.|n|cffaaff00Tip: Informationsboxen oder Balken nach Belieben deaktivieren."

	L.custom_on_stop_timers = "Fähigkeitenleisten immer anzeigen"
	L.custom_on_stop_timers_desc = "Derzeit nur zum Testen"

	L.desires = "Begierden"
	L.bottles = "Flaschen"
	L.sins = "Sünden"
end

L = BigWigs:NewBossLocale("The Council of Blood", "deDE")
if L then
	L.macabre_start_emote = "Plätze für den Totentanz einnehmen!" -- [RAID_BOSS_EMOTE] Take your places for the Danse Macabre!#Dance Controller#4#false"
	L.custom_on_repeating_dark_recital = "Wiederholte Dunkler Vortrag Ansage"
	L.custom_on_repeating_dark_recital_desc = "Gibt wiederholt Chatnachrichten mit den Symbolen {rt1}, {rt2} aus, um den Partner beim Tanzen zu finden."

	L.custom_off_select_boss_order = "Tötungsreihenfolge markieren"
	L.custom_off_select_boss_order_desc = "Markiert die Reihenfolge, in welcher der Schlachtzug die Bosse tötet mit Kreuz {rt7}. Benötigt Schlachtzugsleiter oder Assistent zum Markieren."
	L.custom_off_select_boss_order_value1 = "Niklaus -> Frieda -> Stavros"
	L.custom_off_select_boss_order_value2 = "Frieda -> Niklaus -> Stavros"
	L.custom_off_select_boss_order_value3 = "Stavros -> Niklaus -> Frieda"
	L.custom_off_select_boss_order_value4 = "Niklaus -> Stavros -> Frieda"
	L.custom_off_select_boss_order_value5 = "Frieda -> Stavros -> Niklaus"
	L.custom_off_select_boss_order_value6 = "Stavros -> Frieda -> Niklaus"

	L.dance_assist = "Tanzassistent"
	L.dance_assist_desc = "Zeigt an, in welche Richtung beim Tanzen gelaufen werden muss."
	L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t Tanze vorwärts |T450907:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t Tanze nach rechts |T450908:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t Tanze nach unten |T450905:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t Tanz nach links |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "vorwärts" -- Tänzelt vorwärts!
	L.dance_yell_right = "rechts" -- Schlenker nach rechts!
	L.dance_yell_down = "unten" -- Tänzelt nach unten!
	L.dance_yell_left = "links" -- Gleitet nach links!
end

L = BigWigs:NewBossLocale("Sludgefist", "deDE")
if L then
	L.stomp_shift = "Stampfen & Verschiebung" -- Destructive Stomp + Seismic Shift
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "deDE")
if L then
	L.first_blade = "Erste Klinge" -- Wicked Blade
	L.second_blade = "Zweite Klinge"

	L.skirmishers = "Scharmützlerinnen" -- Short for Stone Legion Skirmishers

	L.custom_on_stop_timers = "Fähigkeitenleisten immer anzeigen"
	L.custom_on_stop_timers_desc = "Derzeit nur zum Testen"
end

L = BigWigs:NewBossLocale("Sire Denathrius", "deDE")
if L then
	L.add_spawn = "Blutrote Kabalisten folgen Denathrius' Ruf." -- [RAID_BOSS_EMOTE] Crimson Cabalists answer the call of Denathrius.#Sire Denathrius#4#true"

	L.infobox_stacks = "%d |4Stapel:Stapel;: %d |4Spieler:Spieler;" -- 4 Stacks: 5 players // 1 Stack: 1 player

	--L.custom_on_repeating_nighthunter = "Repeating Night Hunter Yell"
	--L.custom_on_repeating_nighthunter_desc = "Repeating yell messages for the Night Hunter ability using icons {rt1} or {rt2} or {rt3} to find your line easier if you have to soak."

	--L.custom_on_repeating_impale = "Repeating Impale Say"
	--L.custom_on_repeating_impale_desc = "Repeating say messages for the Impale ability using '1' or '22' or '333' or '4444' to make it clear in what order you will be hit."

	-- L.hymn_stacks = "Nathrian Hymn"
	-- L.hymn_stacks_desc = "Alerts for the amount of Nathrian Hymn stacks currently on you."

	-- L.ravage_target = "Reflection: Ravage Target Cast Bar"
	-- L.ravage_target_desc = "Cast bar showing the time until the reflection targets a location for Ravage."
	-- L.ravage_targeted = "Ravage Targeted" -- Text on the bar for when Ravage picks its location to target in stage 3

	-- L.no_mirror = "No Mirror: %d" -- Player amount that does not have the Through the Mirror
	-- L.mirror = "Mirror: %d" -- Player amount that does have the Through the Mirror
end
