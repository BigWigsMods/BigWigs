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

L = BigWigs:NewBossLocale("Sun King's Salvation", "deDE")
if L then
	L.shield_removed = "%s entfernt nach %.1fs" -- "Shield removed after 1.1s" s = seconds
	L.shield_remaining = "%s verbleibend: %s (%.1f%%)" -- "Shield remaining: 2.1K (5.3%)"
end

L = BigWigs:NewBossLocale("Hungering Destroyer", "deDE")
if L then
	L.miasma = "Miasma" -- Short for Gluttonous Miasma

	L.custom_on_repeating_yell_miasma = "Wiederholtes Miasma Gesundheit Schreien"
	L.custom_on_repeating_yell_miasma_desc = "Gibt wiederholt Schrei-Nachrichten für Gefräßiges Miasma aus, damit Mitspieler merken, wenn Du unter 75% Gesundheit bist."

	L.custom_on_repeating_say_laser = "Wiederholte Instabiler Ausstoß Ansage"
	L.custom_on_repeating_say_laser_desc = "Gibt wiederholt Chatnachrichten für Instabilen Ausstoß aus um beim Annähern an Spieler in Reichweite der Chatnachrichten zu helfen, falls diese die erste Nachricht nicht gelesen haben."

	L.tempPrint = "Es wurde eine Gesundheitsansage für Miasma hinzugefügt. Falls bislang eine WeakAura hierfür verwendet wurde, kann diese gelöscht werden um doppelte Ansagen zu vermeiden."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "deDE")
if L then
	L.stage2_yell = "Die Vorfreude auf dieses Relikt bringt mich fast um! Aber wahrscheinlich tötet es eher Euch."
	L.stage3_yell = "Hoffentlich ist dieser wundersame Gegenstand so tödlich, wie er aussieht!"
	L.tear = "Riss" -- Short for Dimensional Tear
	L.spirits = "Geister" -- Short for Fleeting Spirits
	L.seeds = "Saaten" -- Short for Seeds of Extinction
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "deDE")
if L then
	L.times = "%dx %s"

	L.level = "%s (Stufe |cffffff00%d|r)"
	L.full = "%s (|cffff0000VOLL|r)"

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
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t Tanze nach links |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "Tänzelt vorwärts" -- Tänzelt vorwärts!
	L.dance_yell_right = "Schlenker nach rechts" -- Schlenker nach rechts!
	L.dance_yell_down = "Tänzelt nach unten" -- Tänzelt nach unten!
	L.dance_yell_left = "Gleitet nach links" -- Gleitet nach links!
end

L = BigWigs:NewBossLocale("Sludgefist", "deDE")
if L then
	L.stomp_shift = "Stampfen & Verschiebung" -- Destructive Stomp + Seismic Shift

	L.fun_info = "Schadensinfo"
	L.fun_info_desc = "Zeigt eine Nachricht mit der verlorenen Gesundheit des Bosses während dem Zerstörerischen Einschlag."

	L.health_lost = "Schlickfaust hat %.1f%% verloren!"
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "deDE")
if L then
	L.first_blade = "Erste Klinge" -- Wicked Blade
	L.second_blade = "Zweite Klinge"

	L.skirmishers = "Scharmützlerinnen" -- Short for Stone Legion Skirmishers

	L.custom_on_stop_timers = "Fähigkeitenleisten immer anzeigen"
	L.custom_on_stop_timers_desc = "Derzeit nur zum Testen"

	L.goliath_short = "Goliath"
	L.goliath_desc = "Zeigt Warnungen und Timer für das Erscheinen eines Goliaths der Steinlegion."

	L.commando_short = "Kommandosoldat"
	L.commando_desc = "Zeigt Warnungen wenn ein Kommandosoldat der Steinlegion getötet wird."
end

L = BigWigs:NewBossLocale("Sire Denathrius", "deDE")
if L then
	L.add_spawn = "Blutrote Kabalisten folgen Denathrius' Ruf." -- [RAID_BOSS_EMOTE] Crimson Cabalists answer the call of Denathrius.#Sire Denathrius#4#true"

	L.infobox_stacks = "%d |4Stapel:Stapel;: %d |4Spieler:Spieler;" -- 4 Stacks: 5 players // 1 Stack: 1 player

	L.custom_on_repeating_nighthunter = "Wiederholtes Nachtjäger Schreien"
	L.custom_on_repeating_nighthunter_desc = "Gibt wiederholt Schrei-Nachrichten für die Nachtjäger Fähigkeit mit den Symbolen {rt1} oder {rt2} oder {rt3} aus, um die Linie zum Abfangen leichter zu finden."

	L.custom_on_repeating_impale = "Wiederholte Durchbohren Ansage"
	L.custom_on_repeating_impale_desc = "Gibt wiederholt Chatnachrichten für die Durchbohren Fähigkeit mit '1' oder '22' oder '333' oder '4444' aus, um die Reihenfolge der Angriffe zu verdeutlichen."

	L.hymn_stacks = "Hymne von Nathria"
	L.hymn_stacks_desc = "Benachrichtigungen für die aktuelle Stapelanzahl von Hymne von Nathria auf dem Spieler."

	L.ravage_target = "Reflexion: Verheeren Ziel Zauberleiste"
	L.ravage_target_desc = "Zeigt eine Zauberleiste mit der verbleibenden Zeit bis die Reflexion einen Ort für Verheeren anvisiert."
	L.ravage_targeted = "Verheeren anvisiert" -- Text on the bar for when Ravage picks its location to target in stage 3

	L.no_mirror = "Kein Spiegel: %d" -- Player amount that does not have the Through the Mirror
	L.mirror = "Spiegel: %d" -- Player amount that does have the Through the Mirror
end

L = BigWigs:NewBossLocale("Castle Nathria Trash", "deDE")
if L then
	--[[ Pre Shriekwing ]]--
	L.moldovaak = "Moldovaak"
	L.caramain = "Caramain"
	L.sindrel = "Sindrel"
	L.hargitas = "Hargitas"

	--[[ Shriekwing -> Huntsman Altimor ]]--
	L.gargon = "Bulliger Gargon"
	L.hawkeye = "Scharfschütze von Nathria"
	L.overseer = "Zwingeraufseherin"

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	L.feaster = "Schreckensschmauser"
	L.rat = "Ungewöhnlich große Ratte"
	L.miasma = "Miasma" -- Short for Gluttonous Miasma

	--[[ Hungering Destroyer -> Lady Inerva Darkvein ]]--
	L.deplina = "Deplina"
	L.dragost = "Dragost"
	L.kullan = "Kullan"

	--[[ Shriekwing -> Xy'mox ]]--
	L.antiquarian = "Finstere Antiquarin"
	L.conservator = "Konservator von Nathria"
	L.archivist = "Archivarin von Nathria"

	--[[ Sludgefist -> Stone Legion Generals ]]--
	L.goliath = "Goliath der Steinlegion"
end
