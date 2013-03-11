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

	L.custom_on_markpossessed = "Verstärkten Boss markieren"
	L.custom_on_markpossessed_desc = "Markiert den von Gara'jal verstärkten Boss mit einem Totenkopf."

	L.assault_stun = "Tank betäubt!"
	L.assault_message = "Kalte Angriffe"
	L.full_power = "Volle Energie"
	L.hp_to_go_power = "Noch %d%% HP - Energie: %d"
end

L = BigWigs:NewBossLocale("Tortos", "deDE")
if L then
	L.kick = "Unterbrechen"
	L.kick_desc = "Anzeigen, wie viele Schildkröten unterbrochen werden können"
	L.kick_message = "Unterbrechbare Schildkröten: %d"

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
	L.lower_hatch_trigger = "Die Eier in einem der unteren Nester beginnen, aufzubrechen!"
	L.upper_hatch_trigger = "Die Eier in einem der oberen Nester beginnen, aufzubrechen!"

	L.nest = "Nester"
	L.nest_desc = "Warnungen für die Nester. |c00FF0000Schalte diese Warnungen aus, wenn Du nicht für die Nester eingeteilt bist!|r"

	L.flight_over = "Flug in %d Sek vorbei!"
	L.upper_nest = "|cff008000Oberes|r Nest"
	L.lower_nest = "|cffff0000Unteres|r Nest"
	L.upper = "|cff008000Oben|r"
	L.lower = "|cffff0000Unten|r"
	L.add = "Add"
	L.big_add_message = "Großes Add in %s"
end

L = BigWigs:NewBossLocale("Durumu the Forgotten", "deDE")
if L then
	L.red_spawn_trigger = "Das Infrarotlicht offenbart einen purpurroten Nebel!"
	L.blue_spawn_trigger = "Der blaue Strahl offenbart einen azurblauen Nebel!"

	L.custom_off_ray_controllers = "Kontrollierer der Lichtstrahlen"
	L.custom_off_ray_controllers_desc = "Verwenden der %s, %s, %s Schlachtzugsmarkierungen auf Spieler, welche die Erscheinungsorte sowie Bewegungen der Lichtstrahlen kontrollieren."

	L.rays_spawn = "Lichtstrahlen erscheinen"
	L.red_add = "|cffff0000Rotes|r Add"
	L.blue_add = "|cff0000ffBlaues|r Add"
	L.death_beam = "Desintegrationsstrahl"
	L.red_beam = "|cffff0000Roter|r Strahl"
	L.blue_beam = "|cff0000ffBlauer|r Strahl"
	L.yellow_beam = "|cffffff00Gelber|r Strahl"
end

L = BigWigs:NewBossLocale("Primordius", "deDE")
if L then
	L.mutations = "Mutationen |cff008000(%d)|r |cffff0000(%d)|r"
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