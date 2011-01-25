local L = BigWigs:NewBossLocale("Cho'gall", "deDE")
if L then
	L.orders = "Schatten- / Flammenbefehl"
	L.orders_desc = "Warnt, wenn Cho'gall zwischen Befehle des Schattens und Flammenbefehl wechselt."

	L.crash_say = "Schmettern auf MIR!"
	L.worship_cooldown = "~Verehren"
	L.adherent_bar = "Nächster Kultist %d"
	L.adherent_message = "Kultist %d kommt!"
	L.ooze_bar = "Schleime %d"
	L.ooze_message = "Schleime %d kommen!"
	L.tentacles_bar = "Nächste Tentakel"
	L.tentacles_message = "Tentakel Disco Party!"
	L.sickness_message = "Krankheit auf DIR!"
	L.fury_bar = "Nächster Furor"
	L.fury_message = "Furor!"

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

	L.engulfingmagic_say = "Einhüllende Magie auf MIR!"
	L.engulfingmagic_cooldown = "~Einhüllende Magie"

	L.devouringflames_cooldown = "~Verschlingende Flammen"

	L.valiona_trigger = "Theralion, ich werde den Gang einhüllen. Deck ihre Flucht!"

	L.twilight_shift = "%2$dx Verschiebung auf %1$s"
end

L = BigWigs:NewBossLocale("Halfus Wyrmbreaker", "deDE")
if L then

end

L = BigWigs:NewBossLocale("Sinestra", "deDE")
if L then
	L.egg_vulnerable = "Zeit für Omlet!"

	--L.omlet_trigger = "You mistake this for weakness?  Fool!"

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

	L.shield_up_message = "Schild ist oben!"
	L.shield_bar = "Nächstes Schild"

	L.lightning_rod_say = "Blitzableiter auf MIR!"

	L.switch_trigger = "Wir kümmern uns um sie!" -- check

	L.thundershock_quake_soon = "%s in 10 sek!"

	L.quake_trigger = "Der Boden unter Euch grollt unheilvoll..." -- check
	L.thundershock_trigger = "Die Luft beginnt, vor Energie zu knistern...." -- check

	L.searing_winds_message = "Donnerschock kommt!"
	L.grounded_message = "Erdbeben kommt!"

	L.last_phase_trigger = "SCHMECKT DIE VERDAMMNIS!" -- check
end
