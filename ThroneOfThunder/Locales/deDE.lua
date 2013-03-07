local L = BigWigs:NewBossLocale("Jin'rokh the Breaker", "deDE")
if not L then return end
if L then
	L.storm_duration = "Gewittersturm Dauer"
	L.storm_duration_desc = "Eine separate Leiste für die Dauer von Gewittersturm"

	L.in_water = "Du stehst im Wasser!"
end

L = BigWigs:NewBossLocale("Horridon", "deDE")
if L then
	L.charge_trigger = "richtet seinen Blick"
	L.door_trigger = "stürmen"

	L.chain_lightning_message = "Dein Fokus wirkt Kettenblitzschlag!"
	L.chain_lightning_bar = "Fokus: Kettenblitzschlag"

	L.fireball_message = "Dein Fokus wirkt Feuerball!"
	L.fireball_bar = "Fokus: Feuerball"

	L.venom_bolt_volley_message = "Dein Fokus wirkt Salve!"
	L.venom_bolt_volley_bar = "Fokus: Salve"

	L.adds = "Adds erscheinen"
	L.adds_desc = "Warnungen für das Erscheinen der Farraki, Gurubashi, Drakkari, Amani und des Kriegsgottes Jalak."

	L.door_opened = "Tor geöffnet!"
	L.door_bar = "Nächstes Tor (%d)"
	L.balcony_adds = "Adds von oben"
	L.orb_message = "Kugel der Kontrolle gefallen!"

	L.focus_only = "|cffff0000Nur Meldungen für Fokusziele.|r "
end

L = BigWigs:NewBossLocale("Council of Elders", "deDE")
if L then
	L.priestess_adds = "Priesterin Adds"
	L.priestess_adds_desc = "Warnungen, wenn Hohepriesterin Mar'li beginnt, Adds zu beschwören."
	L.priestess_adds_message = "Priesterin Add"

	L.full_power = "Volle Energie"
	L.assault_message = "Kalte Angriffe"
	L.hp_to_go_power = "Noch %d%% HP - Energie: %d"

	L.custom_on_markpossessed = "Mark Possessed Boss"
	L.custom_on_markpossessed_desc = "Mark the possessed boss with a skull."
end

L = BigWigs:NewBossLocale("Tortos", "deDE")
if L then
	L.kick = "Unterbrechen"
	L.kick_desc = "Anzeigen, wie viele Schildkröten unterbrochen werden können"
	L.kickable_turtles = "Unterbrechbare Schildkröten: %d"

	L.crystal_shell_removed = "Kristallpanzer entfernt!"
	L.no_crystal_shell = "KEIN Kristallpanzer"
end

L = BigWigs:NewBossLocale("Megaera", "deDE")
if L then
	L.breaths = "Atem"
	L.breaths_desc = "Warnungen zu den verschiedenen Atem."

	L.arcane_adds = "Arkane Adds"
end

L = BigWigs:NewBossLocale("Ji-Kun", "deDE")
if L then
	L.flight_over = "Flug vorbei"
	L.young_egg_hatching = "Frisch gelegtes Ei schlüpft"
	L.lower_hatch_trigger = "Die Eier in einem der unteren Nester beginnen, aufzubrechen!"
	L.upper_hatch_trigger = "Die Eier in einem der oberen Nester beginnen, aufzubrechen!"
	L.upper_nest = "|c00008000Oberes|r Nest"
	L.lower_nest = "|c00FF0000Unteres|r Nest"
	L.lower_upper_nest = "|c00FF0000Unteres|r + |c00008000Oberes|r Nest"
	L.nest = "Nester"
	L.nest_desc = "Warnungen für die Nester. |c00FF0000Schalte diese Warnungen aus, wenn Du nicht für die Nester eingeteilt bist!|r"
	L.big_add = "Großes Add in %s"

	L.custom_off_ray_controllers = "Ray controllers"
	L.custom_off_ray_controllers_desc = "Use the %s, %s, %s raid markers to mark people who will control the ray spawn positions and movement."
end

L = BigWigs:NewBossLocale("Durumu the Forgotten", "deDE")
if L then
	L.rays_spawn = "Lichtstrahlen erscheinen"
	L.red_spawn_trigger = "Das Infrarotlicht offenbart einen purpurroten Nebel!"
	L.blue_spawn_trigger = "Der blaue Strahl offenbart einen azurblauen Nebel!"
	L.red_add = "|c00FF0000Rotes|r Add"
	L.blue_add = "|c000000FFBlaues|r Add"
	L.clockwise = "Im Uhrzeigersinn"
	L.counter_clockwise = "Gegen den Uhrzeigersinn"
	L.death_beam = "Desintegrationsstrahl"
end

L = BigWigs:NewBossLocale("Primordius", "deDE")
if L then
	L.stream_of_blobs = "Pathogendrüsen"
	L.mutations = "Mutationen"
end

L = BigWigs:NewBossLocale("Dark Animus", "deDE")
if L then
	L.engage_trigger = "Die Kugel explodiert!"
	L.slam_message = "Schmettern"
end

L = BigWigs:NewBossLocale("Iron Qon", "deDE")
if L then
	L.molten_energy = "Geschmolzene Macht"

	L.overload_casting = "Wirkt Geschmolzene Überladung"
	L.overload_casting_desc = "Warnung für das Wirken von Geschmolzene Überladung"

	L.arcing_lightning_cleared = "Kein Überspringender Blitz mehr"
end

L = BigWigs:NewBossLocale("Twin Consorts", "deDE")
if L then
	L.barrage_fired = "Beschuss abgefeuert!"
	L.last_phase_yell_trigger = "Aber nur dieses eine Mal..."
end

L = BigWigs:NewBossLocale("Lei Shen", "deDE")
if L then
	L.conduit_abilities = "Leitungs-Fähigkeiten"
	L.conduit_abilities_desc = "Ungefähre Cooldown-Leisten für die spezifischen Fähigkeiten der Leitungen"
	L.conduit_ability_meassage = "Nächste Leitungs-Fähigkeit"

	L.intermission = "Unterbrechung"
	L.overchargerd_message = "Betäubender AoE Puls"
	L.static_shock_message = "Aufteilender AoE Schaden"
	L.diffusion_add_message = "Kugelblitzelementare"
	L.diffusion_chain_message = "Kugelblitzelementare bald - VERTEILEN!"
end

L = BigWigs:NewBossLocale("Ra-den", "deDE")
if L then

end