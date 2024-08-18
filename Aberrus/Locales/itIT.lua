local L = BigWigs:NewBossLocale("The Amalgamation Chamber", "itIT")
if not L then return end
if L then
	L.custom_on_fade_out_bars = "Dissolvenza Barre Fase 1"
	L.custom_on_fade_out_bars_desc = "Dissolvi le barre del boss che fuori raggio d'azione in Fase 1."

	L.coalescing_void = "Scappa"

	L.shadow_and_flame = "Penalità Mitico"
end

L = BigWigs:NewBossLocale("The Forgotten Experiments", "itIT")
if L then
	L.rending_charge_single = "Prima Carica"
	L.unstable_essence_new = "Nuova Bomba"
	L.custom_on_unstable_essence_high = "Messaggio Chat Molti Accumuli di Essenza Instabile"
	L.custom_on_unstable_essence_high_desc = "Messaggio di chat con il numero di accumuli per il tuo maleficio di Essenza Instabile quando sono troppi."
	L.volatile_spew = "Evita"
	L.volatile_eruption = "Erupzione"
	L.temporal_anomaly_knocked = "Globo Curativo Intercettato"
end

L = BigWigs:NewBossLocale("Assault of the Zaqali", "itIT")
if L then
	-- These are in-game emotes and need to match the text shown in-game
	-- You should also replace the comment (--) with the full emote as it shows in-game
	--L.zaqali_aide_north_emote_trigger = "northern battlement" -- Commanders ascend the northern battlement!
	--L.zaqali_aide_south_emote_trigger = "southern battlement" -- Commanders ascend the southern battlement!

	--L.both = "Both"
	--L.zaqali_aide_message = "%s Climbing %s" -- Big Adds Climbing North
	L.add_bartext = "%s: %s (%d)"
	--L.boss_returns = "Boss Lands: North"

	L.molten_barrier = "Barriera"
	--L.catastrophic_slam = "Door Slam"
end

L = BigWigs:NewBossLocale("Rashok, the Elder", "itIT")
if L then
	L.doom_flames = "Assorbimenti Minori"
	L.charged_smash = "Assorbimento Maggiore"
	L.energy_gained = "Energia Guadagnata: %d"
end

L = BigWigs:NewBossLocale("The Vigilant Steward, Zskarn", "itIT")
if L then
	L.tactical_destruction = "Statue di Drago"
	L.bombs_soaked = "Bombe Assorbite" -- Bombs Soaked (2/4)
	L.unstable_embers = "Braci"
	L.unstable_ember = "Brace"
end

L = BigWigs:NewBossLocale("Magmorax", "itIT")
if L then
	L.energy_gained = "Energia Guadagnata (-17s)" -- When you fail, you lose 17 seconds, the boss reaches full energy faster

	-- Mythic
	L.explosive_magma = "Assorbi Pozza"
end

L = BigWigs:NewBossLocale("Echo of Neltharion", "itIT")
if L then
	L.twisted_earth = "Muri"
	L.echoing_fissure = "Fessura"
	L.rushing_darkness = "Distruggi Linee"

	L.umbral_annihilation = "Annientamento"
	L.ebon_destruction = "Big Bang"

	--L.wall_breaker = "Wall Breaker (Mythic)"
	--L.wall_breaker_desc = "A player targeted by Rushing Darkness will be chosen as the wall breaker. They will be marked ({rt6}) and send a message in say chat. This is restricted to Mythic difficulty on stage 1."
	--L.wall_breaker_message = "Wall Breaker"
end

L = BigWigs:NewBossLocale("Scalecommander Sarkareth", "itIT")
if L then
	L.claws = "Penalità Difensori" -- (Fase 1) Artigli Ardenti / (Fase 2) Artigli del Vuoto / (Fase 3) Squarcio del Vuoto
	--L.claws_debuff = "Tank Explodes"
	--L.emptiness_between_stars = "Emptiness"
	--L.void_slash = "Tank Frontal"

	--L.ebon_might = "Adds Immune"
end

L = BigWigs:NewBossLocale("Aberrus, the Shadowed Crucible Trash", "itIT")
if L then
	L.edgelord = "Campionessa della Soglia Frammentata" -- NPC 198873
	L.naturalist = "Naturalista Frammentato" -- NPC 201746
	L.siegemaster = "Maestro d'Assedio Frammentato" -- NPC 198874
	L.banner = "Stendardo" -- Short for "Sundered Flame Banner" NPC 205638
	L.arcanist = "Arcanista Frammentata" -- NPC 201736
	L.chemist = "Alchimista Frammentata" -- NPC 205656
	L.fluid = "Fluido d'Animazione" -- NPC 203939
	L.slime = "Poltiglia Ribollente" -- NPC 205651
	L.goo = "Viscidume Strisciante" -- NPC 205820
	L.whisper = "Sussurro nell'Oscurità" -- NPC 203806
end
