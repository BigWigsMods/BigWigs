local L = BigWigs:NewBossLocale("Kazzara, the Hellforged", "deDE")
if not L then return end
if L then
	L.dread_rift = "Riss" -- Singular Dread Rift
end

L = BigWigs:NewBossLocale("The Amalgamation Chamber", "deDE")
if L then
	L.custom_on_fade_out_bars = "Phase 1 Leisten abblenden"
	L.custom_on_fade_out_bars_desc = "Leisten, welche zum außer Reichweite befindlichen Boss in Phase 1 gehören abblenden."

	L.coalescing_void = "Weglaufen"
	L.shadow_convergence = "Kugeln"
	L.molten_eruption = "Soaks"
	L.swirling_flame = "Tornados"
	L.gloom_conflagration = "Meteor + Weglaufen"
	L.blistering_twilight = "Bombs + Tornados"
	L.convergent_eruption = "Soaks + Kugeln"
	L.shadowflame_burst = "Frontaler Kegel"

	L.shadow_and_flame = "Mythische Debuffs"
end

L = BigWigs:NewBossLocale("The Forgotten Experiments", "deDE")
if L then
	L.rending_charge_single = "Erster Ansturm"
	L.massive_slam = "Frontaler Kegel"
	L.unstable_essence_new = "Neue Bombe"
	L.custom_on_unstable_essence_high = "Sprechblasen bei hohen Stapeln von Instabiler Essenz"
	L.custom_on_unstable_essence_high_desc = "Chatnachrichten mit der Anzahl von Stapeln Deiner Instabilen Essenz wenn diese hoch genug ist."
	L.volatile_spew = "Ausweichen"
	L.volatile_eruption = "Eruption"
	L.temporal_anomaly = "Heilkugel"
	L.temporal_anomaly_knocked = "Heilkugel weggestoßen"
end

L = BigWigs:NewBossLocale("Assault of the Zaqali", "deDE")
if L then
	-- These are in-game emotes and need to match the text shown in-game
	-- You should also replace the comment (--) with the full emote as it shows in-game
	L.zaqali_aide_north_emote_trigger = "nördliche Festungsmauer" -- Kommandanten erklimmen die nördliche Festungsmauer!
	L.zaqali_aide_south_emote_trigger = "südliche Festungsmauer" -- Kommandanten erklimmen die südliche Festungsmauer!

	L.north = "Norden"
	L.south = "Süden"
	L.both = "Beide"

	L.zaqali_aide_message = "%s klettern %s" -- Big Adds Climbing North
	L.add_bartext = "%s: %s (%d)"
	L.boss_returns = "Boss landet: Norden"

	L.molten_barrier = "Barriere"
	L.catastrophic_slam = "Türschmettern"
end

L = BigWigs:NewBossLocale("Rashok, the Elder", "deDE")
if L then
	L.doom_flames = "Kleine Soaks"
	L.shadowlave_blast = "Frontaler Kegel"
	L.charged_smash = "Großer Soak"
	L.energy_gained = "Energie erreicht: %d"

	-- Mythic
	L.unleash_shadowflame = "Mythische Kugeln"
end

L = BigWigs:NewBossLocale("The Vigilant Steward, Zskarn", "deDE")
if L then
	L.tactical_destruction = "Drachenköpfe"
	L.bombs_soaked = "Bomben ausgelöst" -- Bombs Soaked (2/4)
	L.unstable_embers = "Funken"
	L.unstable_ember = "Funke"
end

L = BigWigs:NewBossLocale("Magmorax", "deDE")
if L then
	L.energy_gained = "Energie erreicht (-17s)" -- When you fail, you lose 17 seconds, the boss reaches full energy faster

	-- Mythic
	L.explosive_magma = "Pfütze soaken"
end

L = BigWigs:NewBossLocale("Echo of Neltharion", "deDE")
if L then
	L.custom_on_repeating_sunder_reality = "Realität zerreißen Warnung wiederholen"
	L.custom_on_repeating_sunder_reality_desc = "Wiederholt eine Nachricht während dem Schwarzen Zerstörung Zauber bis Du in einem Portal bist."

	L.twisted_earth = "Wände"
	L.echoing_fissure = "Spalt"
	L.rushing_darkness = "Rückstoß Linien"

	L.umbral_annihilation = "Auslöschung"
	L.sunder_reality = "Portale"
	L.ebon_destruction = "Großer Knall"
end

L = BigWigs:NewBossLocale("Scalecommander Sarkareth", "deDE")
if L then
	--L.claws = "Tank Debuff" -- (Stage 1) Burning Claws / (Stage 2) Void Claws / (Stage 3) Void Slash
	L.claws_debuff = "Tank Explosionen"
	L.emptiness_between_stars = "Leere"
	--L.void_slash = "Tank Frontal"

	L.boss_immune = "Boss immun"
	L.ebon_might = "Adds immun"
end
