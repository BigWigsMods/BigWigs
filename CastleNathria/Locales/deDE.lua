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
	-- L.stage2_yell = "The anticipation to use this relic is killing me! Though, it will more likely kill you."
	-- L.stage3_yell = "I hope this wondrous item is as lethal as it looks!"
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "deDE")
if L then
	-- L.times = "%dx %s"

	L.level = "%s (Stufe |cffffff00%d|r)"
	L.full = "%s (|cffff0000VOLL|r)"

	L.custom_off_experimental = "Experimentelle Funktionen aktivieren"
	L.custom_off_experimental_desc = "Diese Funktionen wurden |cffff0000nicht getestet|r und können |cffff0000spammen|r."

	L.anima_tracking = "Anima Verfolgung |cffff0000(Experimentell)|r"
	L.anima_tracking_desc = "Nachrichten und Leisten zur Verfolgung der Anima-Level in den Behältern.|n|cffaaff00Tip: Informationsboxen oder Balken nach Belieben deaktivieren."

	L.custom_on_stop_timers = "Fähigkeitenleisten immer anzeigen"
	L.custom_on_stop_timers_desc = "Derzeit nur zum Testen"

	L.bottles = "Behälter"
	L.sins = "Sünden"
end

L = BigWigs:NewBossLocale("The Council of Blood", "deDE")
if L then
	-- L.macabre_start_emote = "Take your places for the Danse Macabre!" -- [RAID_BOSS_EMOTE] Take your places for the Danse Macabre!#Dance Controller#4#false"
	L.custom_on_repeating_dark_recital = "Wiederholte Dunkler Vortrag Ansage"
	L.custom_on_repeating_dark_recital_desc = "Gibt wiederholt Chatnachrichten mit den Symbolen {rt1}, {rt2} aus, um den Partner beim Tanzen zu finden."
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "deDE")
if L then
	L.first_blade = "Erste Klinge"
	L.second_blade = "Zweite Klinge"
end
