
local L = BigWigs:NewBossLocale("Cho'gall", "deDE")
if not L then return end
if L then
	L.orders = "Schatten- / Flammenbefehl"
	L.orders_desc = "Warnt, wenn Cho'gall zwischen Befehle des Schattens und Flammenbefehl wechselt."

	L.worship_cooldown = "~Verehren"

	L.adherent_bar = "Kultist %d"
	L.adherent_message = "Kultist %d kommt!"
	L.ooze_bar = "Schleime %d"
	L.ooze_message = "Schleime %d kommen!"

	L.tentacles_bar = "Nächste Tentakel"
	L.tentacles_message = "Tentakel Disco Party!"

	L.sickness_message = "Krankheit auf DIR!"
	L.blaze_message = "Lohe auf DIR!"
	L.crash_say = "Schmettern auf MIR!"

	L.fury_message = "Furor!"
	L.first_fury_soon = "Furor bald!"
	L.first_fury_message = "85% - Furor kommt!"

	L.unleashed_shadows = "Schatten"

	L.phase2_message = "Phase 2!"
	L.phase2_soon = "Phase 2 bald!"
end

L = BigWigs:NewBossLocale("Valiona and Theralion", "deDE")
if L then
	L.phase_switch = "Phasenwechsel"
	L.phase_switch_desc = "Warnt, wenn die Phase gewechselt wird."

	L.phase_bar = "%s landet"
	L.breath_message = "Tiefer Atem kommt!"
	L.dazzling_message = "Wirbelzonen kommen!"

	L.blast_message = "Druckwelle"
	L.engulfingmagic_say = "Einhüllende Magie auf MIR!"

	L.valiona_trigger = "Theralion, ich werde den Gang einhüllen. Deck ihre Flucht!"

	L.twilight_shift = "%2$dx Verschiebung auf %1$s"
end

L = BigWigs:NewBossLocale("Halfus Wyrmbreaker", "deDE")
if L then
	L.strikes_message = "%2$dx Stöße auf %1$s"

	L.breath_message = "Atem kommt!"
	L.breath_bar = "~Atem"

	L.engage_yell = "Cho'gall wird eure Köpfe fordern! ALLE!"
end

L = BigWigs:NewBossLocale("Sinestra", "deDE")
if L then
	L.whelps = "Welpen"
	L.whelps_desc = "Warnt vor den Wellen der Welpen."

	L.slicer_message = "~Orb Ziele"

	L.egg_vulnerable = "Zeit für Omelett!"

	L.whelps_trigger = "Fresst, Kinder!" -- check
	L.omelet_trigger = "Ihr denkt, ich sei schwach?" -- check

	L.phase13 = "Phase 1 und 3"
	L.phase = "Phasen"
	L.phase_desc = "Warnt, wenn die Phasen wechseln."
end

L = BigWigs:NewBossLocale("Ascendant Council", "deDE")
if L then
	L.static_overload_say = "Überladung auf MIR!"
	L.gravity_core_say = "Gravitation auf MIR!"
	L.health_report = "%s bei %d%%, Wechsel bald!"
	L.switch = "Wechsel"
	L.switch_desc = "Warnt, wenn die Bosse wechseln."

	L.shield_up_message = "Schild ist OBEN!"
	L.shield_down_message = "Schild ist UNTEN!"
	L.shield_bar = "Schild"

	L.switch_trigger = "Wir kümmern uns um sie!"

	L.thundershock_quake_soon = "%s in 10 sek!"

	L.quake_trigger = "Der Boden unter Euch grollt unheilvoll..."
	L.thundershock_trigger = "Die Luft beginnt, vor Energie zu knistern..."

	L.thundershock_quake_spam = "%s in %d"

	L.last_phase_trigger = "Beeindruckende Leistung…" -- what the heck Blizz??
end

