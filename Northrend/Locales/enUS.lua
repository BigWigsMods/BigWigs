local L = LibStub("AceLocale-3.0"):NewLocale("BigWigsArchavon the Stone Watcher", "enUS", true)
if L then
	L.stomp_message = "Stomp - Charge Inc!"
	L.stomp_warning = "Possible Stomp in ~5sec!"
	L.stomp_bar = "~Stomp Cooldown"
	
	L.cloud_message = "Choking Cloud on YOU!"
	
	L.charge = "Charge"
	L.charge_desc = "Warn about Charge on players."

	L.icon = "Raid Icon"
	L.icon_desc = "Place a Raid Target Icon on the player targetted by Rock Shards. (requires promoted or higher)"
end

L = LibStub("AceLocale-3.0"):NewLocale("BigWigsEmalon the Storm Watcher", "enUS", true)
if L then
	L.nova_next = "~Nova Cooldown"

	L.overcharge_message = "A minion is overcharged!"
	L.overcharge_bar = "Explosion"
	L.overcharge_next = "~Overcharge Cooldown"

	L.icon = "Overcharge Icon"
	L.icon_desc = "Place a skull on the mob with Overcharge."
end

L = LibStub("AceLocale-3.0"):NewLocale("BigWigsMalygos", "enUS", true)
if L then
	L.sparks = "Spark Spawns"
	L.sparks_desc = "Warns on Power Spark spawns."
	L.sparks_message = "Power Spark spawns!"
	L.sparks_warning = "Power Spark in ~5sec!"

	L.sparkbuff_message = "Malygos gains Power Spark!"
	
	L.vortex = "Vortex"
	L.vortex_desc = "Warn for Vortex in phase 1."
	L.vortex_message = "Vortex!"
	L.vortex_warning = "Possible Vortex in ~5sec!"
	L.vortex_next = "Vortex Cooldown"
	
	L.breath = "Deep Breath"
	L.breath_desc = "Warn when Malygos is using Deep Breath in phase 2."
	L.breath_message = "Deep Breath!"
	L.breath_warning = "Deep Breath in ~5sec!"

	L.surge = "Surge of Power"
	L.surge_desc = "Warn when Malygos uses Surge of Power on you in phase 3."
	L.surge_you = "Surge of Power on YOU!"
	L.surge_trigger = "%s fixes his eyes on you!"

	L.phase = "Phases"
	L.phase_desc = "Warn for phase changes."
	L.phase2_warning = "Phase 2 soon!"
	L.phase2_trigger = "I had hoped to end your lives quickly"
	L.phase2_message = "Phase 2 - Nexus Lord & Scion of Eternity!"
	L.phase2_end_trigger = "ENOUGH! If you intend to reclaim Azeroth's magic"
	L.phase3_warning = "Phase 3 soon!"
	L.phase3_trigger = "Now your benefactors make their"
	L.phase3_message = "Phase 3!"
end


L = Libstub("AceLocale-3.0"):NewLocale("BigWigsSartharion", "enUS", true)
if L then
	L.engage_trigger = "It is my charge to watch over these eggs. I will see you burn before any harm comes to them!"

	L.tsunami = "Flame Wave"
	L.tsunami_desc = "Warn for churning lava and show a bar."
	L.tsunami_warning = "Wave in ~5sec!"
	L.tsunami_message = "Flame Wave!"
	L.tsunami_cooldown = "Wave Cooldown"
	L.tsunami_trigger = "The lava surrounding %s churns!"

	L.breath_cooldown = "~Breath Cooldown"

	L.drakes = "Drake Adds"
	L.drakes_desc = "Warn when each drake add will join the fight."
	L.drakes_incomingsoon = "%s landing in ~5sec!"
	
	L.twilight = "Twilight Events"
	L.twilight_desc = "Warn what happens in the Twilight."
	L.twilight_trigger_tenebron = "Tenebron begins to hatch eggs in the Twilight!"
	L.twilight_trigger_vesperon = "A Vesperon Disciple appears in the Twilight!"
	L.twilight_trigger_shadron = "A Shadron Acolyte appears in the Twilight!"
	L.twilight_message_tenebron = "Eggs hatching"
	L.twilight_message = "%s add up!"
end