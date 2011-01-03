local L = BigWigs:NewBossLocale("Cho'gall", "deDE")
if L then
	--heroic
	L.orders = "Schatten- / Flammenbefehl"
	L.orders_desc = "Warnt, wenn Cho'gall Befehle des Schattens und Flammenbefehl wirkt."

	--normal
	L.worship_cooldown = "~Verehren"
end

L = BigWigs:NewBossLocale("Valiona and Theralion", "deDE")
if L then
	L.phase_switch = "Phasenwechsel"
	L.phase_switch_desc = "Warnt, wenn die Phase gewechselt wird."

	L.engulfingmagic_say = "Einhüllende Magie auf MIR!"
	L.engulfingmagic_cooldown = "~Einhüllende Magie"

	L.devouringflames_cooldown = "~Verschlingende Flammen"

	L.valiona_trigger = "Theralion, ich werde den Gang einhüllen. Deck ihre Flucht!" -- check

	L.twilight_shift = "%2$dx Zwielichtverschiebung auf %1$s"
end

L = BigWigs:NewBossLocale("Halfus Wyrmbreaker", "deDE")
if L then

end

L = BigWigs:NewBossLocale("Sinestra", "deDE")
if L then

end

L = BigWigs:NewBossLocale("Ascendant Council", "deDE")
if L then
	L.static_overload_say = "Statische Überladung auf MIR!"
	L.gravity_core_say = "Gravitationskern auf MIR!"
	L.health_report = "%s ist bei %d%% Leben, Wechsel bald!"
	L.switch = "Wechsel"
	L.switch_desc = "Warnt, wenn die Bosse wechseln."

	L.lightning_rod_say = "Blitzableiter auf MIR!"

	L.switch_trigger = "Wir kümmern uns um sie!" -- check

	L.quake_trigger = "Der Boden unter Euch grollt unheilvoll..." -- check
	L.thundershock_trigger = "Die Luft beginnt, vor Energie zu knistern...." -- check

	L.searing_winds_message = "Wirbelnde Winde abholen!"
	L.grounded_message = "Auf den Boden!"

	L.last_phase_trigger = "SCHMECKT DIE VERDAMMNIS!" -- check
end
